package com.springboot.ijib.controller;

import java.util.HashMap;
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
										@AuthenticationPrincipal User user, 
										HttpServletRequest request) {
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
	    
	    poservice.buyOrExtendPass(mno, odto, mpdto);
	    
	    // 3. ES의 pass 인덱스에 등록
	    PassDTO pdto = pdao.passView(pno);
	    poEsservice.save(odto, pdto);
	    
	    // 4. 로그인 인증 객체 재발급
	    poservice.refreshUserAuthentication("SUBSCRIBER", request);
	    
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
}
