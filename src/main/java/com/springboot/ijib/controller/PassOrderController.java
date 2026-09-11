package com.springboot.ijib.controller;

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
		// 1. JS에서 보낸 JSON 데이터를 reqData.get()으로 꺼내서 사용
	    String paymentId = (String) reqData.get("paymentId");
	    int pno = ((Number) reqData.get("pno")).intValue();
	    int totalAmount = ((Number) reqData.get("totalAmount")).intValue();
	    String payment = (String) reqData.get("payment");
	    String buyerEmail = (String) reqData.get("buyerEmail");
		
		// 2. 구매 혹은 연장 실행
	    int mno = mdao.findByEmail(buyerEmail).getMno();
	    
	    OrdersDTO odto = new OrdersDTO();
	    odto.setMno(mno);
	    odto.setOno(paymentId);
	    odto.setOpayment(payment);
	    odto.setOprice(totalAmount);
	    
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
	    Map<String, Object> result = new HashMap<>();
	    result.put("success", true);
	    return result;
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
		
		// 1. 로그인 검증
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
		
		try {
			// 3. 포트원 V2 취소 API 통신
			poservice.cancelPortOnePayment(ono, reason);
			
			// 4. DB 트랜잭션, 주문 내역/회원 구독권 상태 갱신
			String dbRole = poservice.refundPass(mno, ono);
			
			// 5. DB 권한과 세션 권한 비교 후 불일치 시 세션 인증 토큰 재발급
			if (!poservice.checkDBandSecurityAuth(dbRole, user.getAuthorities())) {
				poservice.refreshUserAuthentication(dbRole, request);
			}
			
			result.put("success", true);
			result.put("message", "환불 처리가 완료됐습니다.");
			
		} catch(Exception e) {
			result.put("success", false);
			result.put("message", "환불 실패: " + e.getMessage());
		}
		
		return result;
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
        
        return "redirect:/admin/adminPassList";
    }
}