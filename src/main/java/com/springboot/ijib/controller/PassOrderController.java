package com.springboot.ijib.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IMemberPassesDAO;
import com.springboot.ijib.dao.IOrdersDAO;
import com.springboot.ijib.dao.IPassDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberPassesDTO;
import com.springboot.ijib.dto.OrdersDTO;
import com.springboot.ijib.dto.PassDTO;
import com.springboot.ijib.service.PassOrderESService;
import com.springboot.ijib.service.PassOrderService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class PassOrderController {
	@Autowired
	private IPassDAO pdao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private IMemberPassesDAO mpdao;
	
	@Autowired
	private IOrdersDAO odao;
	
	@Autowired
	private PassOrderService poservice;
	
	@Autowired
	private PassOrderESService poEsservice;
	
	@RequestMapping("/member/payForm")
	public String payForm(PassDTO pdto, Model model,
						@AuthenticationPrincipal User user,
						RedirectAttributes rttr) {
		// 1. 사용자 정보 찾기
		MemberDTO mdto = mdao.findByEmail(user.getUsername());
		
		// 2. 구독권 정보 찾기, 만약 pno가 잘못 전달됐을 경우 
		pdto = pdao.passView(pdto.getPno());
		if (pdto == null) {
		    rttr.addFlashAttribute("msg", "존재하지 않는 구독권 상품입니다.");
		    return "redirect:/guest/passList";
		}
		
		// Model로 넘겨줄 정보: 결제 정보, OrdersDTO, MemberPassesDTO에 필요한 데이터
		model.addAttribute("buyerName", mdto.getMname());
		model.addAttribute("buyerEmail", mdto.getMemail());
		model.addAttribute("buyerTel", mdto.getMtel());
		model.addAttribute("prodName", pdto.getPname());
		model.addAttribute("pno", pdto.getPno());
		model.addAttribute("totalAmount", pdto.getPprice());
		
		return "pay/payForm";
	}
	
	@RequestMapping("/pay/paySuccess")
	@ResponseBody
	public Map<String, Object> paySuccess(@RequestBody Map<String, Object> reqData,
										HttpServletRequest request,
										@AuthenticationPrincipal User user) {
		Map<String, Object> result = new HashMap<>();
		 
		try { 
			// 1. JS에서 보낸 JSON 데이터를 reqData.get()으로 꺼내서 사용
		    String paymentId = (String) reqData.get("paymentId");
		    int pno = ((Number) reqData.get("pno")).intValue();
		    int totalAmount = ((Number) reqData.get("totalAmount")).intValue();
		    String payment = (String) reqData.get("payment");
		    String buyerEmail = (String) reqData.get("buyerEmail");
		    LocalDateTime now = LocalDateTime.now();
			
			// 2. 구매 혹은 연장 실행
		    int mno = mdao.findByEmail(buyerEmail).getMno();
		    
		    OrdersDTO odto = new OrdersDTO();
		    odto.setMno(mno);
		    odto.setOno(paymentId);
		    odto.setOpayment(payment);
		    odto.setOprice(totalAmount);
		    odto.setOdate(now);
		    
		    MemberPassesDTO mpdto = new MemberPassesDTO();
		    mpdto.setPno(pno);
		    
		    String dbRole = poservice.buyOrExtendPass(mno, odto, mpdto);
		    
		    // 3. ES의 pass 인덱스에 등록
		    PassDTO pdto = pdao.passView(pno);
		    poEsservice.save(odto, pdto);
		    
		    // 4. 로그인 인증 객체 재발급
		    // 만약 DB와 스프링 인증 객체의 권한이 다르다면 재발급
		    if (!poservice.checkDBandSecurityAuth(dbRole, user.getAuthorities())) {
		    	poservice.refreshUserAuthentication(dbRole, request);
		    }
		    
		    // 5. 완료 폼으로 이동
		    result.put("success", true);
		    return result;
		} catch (org.springframework.dao.DuplicateKeyException e) {
			// 중복 결제 요청 2차 방어: 시간차가 거의 없는 중복 요청 처리
			// 0.001초 차이로 동시 요청이 들어와 다른 스레드가 먼저 결제를 완료시킨 경우
			System.out.println("동시 결제 요청 차단 (이미 등록 완료된 주문): " + reqData.get("paymentId"));
			
			// 사용자 화면은 이미 결제가 잘 된 것이므로 에러를 내뿜지 않고 성공으로 안내
			result.put("success", true);
			result.put("message", "이미 정상 처리된 결제 건입니다.");
			return result;
		} catch (Exception e) {
			// 그 외 시스템 장애나 비즈니스 예외 (PG 자동 취소 등 연계)
			System.err.println("결제 처리 중 예외 발생: " + e.getMessage());
			
			// 보상 트랜잭션: DB 혹은 ES 저장 실패 시 고객 돈을 즉시 자동 환불
			String paymentId = (String) reqData.get("paymentId");
		    try {
		        if (paymentId != null) {
		            poservice.cancelPortOnePayment(paymentId, "서버 내부 처리 오류로 인한 자동 승인 취소");
		        }
		    } catch (Exception cancelEx) {
		        // 자동 취소 통신마저 실패한 경우: 실무에서는 별도 결제실패 로그 테이블에 적재하거나 슬랙/문자로 관리자 호출
		        System.err.println("CRITICAL: 자동 결제 취소 API 실패! 수동 확인 필요: " + cancelEx.getMessage());
		    }
			
			result.put("success", false);
			result.put("message", "결제 처리 중 오류가 발생했습니다: " + e.getMessage());
			return result;
		}
	}
	
	@RequestMapping("/pay/payResult")
	public String payResult(@RequestParam("paymentId") String paymentId, 
							Model model) {
		model.addAttribute("paymentId", paymentId);
		
		return "pay/paySuccess";
	}
	
	// 구독권 환불
	@RequestMapping("/pay/refund")
	@ResponseBody
	public Map<String, Object> refundSuccess(@RequestBody Map<String, Object> reqData,
										HttpServletRequest request,
										@AuthenticationPrincipal User user) {
		Map<String, Object> result = new HashMap<>();
		final long refundableDate = 7;
		
		// 0. 로그인 검증
		if (user == null) {
			result.put("success", false);
			result.put("message", "로그인이 필요한 서비스입니다.");
			return result;
		}

		// 회원 및 환불 정보
		int mno = mdao.findByEmail(user.getUsername()).getMno();
		String ono = (String) reqData.get("paymentId");
		String reason = (String) reqData.get("reason");
		if (reason == null || reason.isBlank()) {
			reason = "단순 변심";
		}
		String customText = (String) reqData.get("customText");
		if ("기타".equals(reason) && (customText == null || customText.isBlank())) {
			customText = "사유 미기재";
		}
		
		// 1. 환불 기간(구매일 후 7일 이내) 및 주문 상태(PAID) 검증
		OrdersDTO order = odao.orderView(ono);
		if (order == null) {
			result.put("success", false);
			result.put("message", "존재하지 않는 주문 내역입니다.");
			return result;
		}
		
		LocalDateTime odate = order.getOdate();
		LocalDateTime refundableLimit = odate.plusDays(refundableDate);
		LocalDateTime now = LocalDateTime.now();
		String ostatus = order.getOstatus(); 
		
		// 본인의 주문내역인지 확인
		if (mno != order.getMno()) {
			result.put("success", false);
			result.put("message", "본인의 주문 내역만 환불 요청이 가능합니다.");
			return result;
		}
		
		// 구매일로부터 7일 이내인 주문인지 확인
		if (now.isAfter(refundableLimit)) {
			result.put("success", false);
			result.put("message", "환불 기간(" + refundableDate + "일)이 지나 환불이 불가능합니다.");
			return result;
		}
		
		// 2. 상태 선점: PAID -> REFUND_PENDING (동시성 및 중복 클릭 완벽 차단)
		boolean isLocked = poservice.markRefundPending(mno, ono);
		if (!isLocked)  {
			result.put("success", false);
			result.put("message", "이미 환불 처리된 주문 내역입니다.");
			return result;
		}
		
		// 3. 포트원 V2 취소 API 통신
		try {
	        poservice.cancelPortOnePayment(ono, reason);
	    } catch (Exception e) {
	        // PG 취소 실패 시 주문을 다시 PAID로 복구
	        poservice.rollbackRefundPending(mno, ono);
	        result.put("success", false);
	        result.put("message", "결제 취소 통신 실패: " + e.getMessage());
	        return result;
	    }
		
		// 4. PG 취소 성공 후 DB 최종 환불 확정 및 기간 차감
	    try {
	        String dbRole = poservice.refundPass(mno, ono);
	        
	        // ES 동기화
	        try {
	            poEsservice.refundStatusUpdate(ono, reason, customText);
	        } catch (Exception esEx) {
	            System.err.println("ES 동기화 실패: " + esEx.getMessage());
	        }

	        // 세션 갱신
	        if (!poservice.checkDBandSecurityAuth(dbRole, user.getAuthorities())) {
	            poservice.refreshUserAuthentication(dbRole, request);
	        }

	        result.put("success", true);
	        result.put("message", "환불 처리가 완료되었습니다.");
	        return result;

	    } catch (Exception dbEx) {
	        // 이 단계는 DB에 REFUND_PENDING으로 남아있으므로 관리자가 추적 가능
	        System.err.println("CRITICAL: PG는 취소되었으나 DB 반영 실패! 수동 확인 대상: ono=" + ono);
	        result.put("success", false);
	        result.put("message", "결제는 취소되었으나 내부 정산 반영 중 지연이 발생했습니다. 고객센터로 문의 바랍니다.");
	        return result;
	    }
	}
	
	// 회원용 구독권 조회
	@RequestMapping("/member/myPass")
	public String myPass(@AuthenticationPrincipal User user,
						 Model model) {
		MemberPassesDTO pass = mpdao.memberPassesList(mdao.findByEmail(user.getUsername()).getMno());
		
		// LocalDateTime 날짜 포맷
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		
		// pass가 null이 아니거나 mpstart와 mpend가 null이 아니라면 mpstart와 mpend를 형식에 맞게 포맷 후 String으로 저장
		String mpstart = (pass != null && pass.getMpstart() != null) ? pass.getMpstart().format(formatter) : "";
		String mpend = (pass != null && pass.getMpend() != null) ? pass.getMpend().format(formatter) : "";
		
		model.addAttribute("start", mpstart);
		model.addAttribute("end", mpend);
		
		return "member/myPass";
	}
	
	// 회원용 주문 목록 조회
	@RequestMapping("/member/myOrder")
	public String myOrder(@AuthenticationPrincipal User user,
						  Model model) {
		List<OrdersDTO> orders = odao.mordersList(mdao.findByEmail(user.getUsername()).getMno());
		List<String> odates = new ArrayList<>();
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		
		if (orders != null) {
			for (OrdersDTO order: orders) {
				String odate = (order.getOdate() != null) ? order.getOdate().format(formatter) : "";
	            odates.add(odate);
			}
		}
		
		model.addAttribute("orders", orders);
		model.addAttribute("odates", odates);
		
		return "member/myOrder";
	}

    // 관리자용 만료 구독권 갱신
    @RequestMapping("/admin/expiredPassUpdate")
    public String expiredPassUpdate(RedirectAttributes rttr) {
        try {
            int count = poservice.expireAllOverduePasses();
            rttr.addFlashAttribute("msg", "구독권 만료 검증 완료: 총 " + count + "명의 회원이 일반 등급으로 강등되었습니다.");
        } catch (Exception e) {
            rttr.addFlashAttribute("msg", "검증 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return "redirect:/admin/adminMain";
    }
}