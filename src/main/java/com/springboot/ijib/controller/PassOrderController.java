package com.springboot.ijib.controller;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
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
    
    // 결제 폼
    @RequestMapping("/member/payForm")
    public String payForm(PassDTO pdto, Model model,
                          Authentication authentication,
                          RedirectAttributes rttr) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/loginForm";
        }

        MemberDTO mdto = mdao.findByEmail(authentication.getName());
        
        pdto = pdao.passView(pdto.getPno());
        if (pdto == null) {
            rttr.addFlashAttribute("msg", "존재하지 않는 구독권 상품입니다.");
            return "redirect:/guest/passList";
        }
        
        model.addAttribute("buyerName", mdto.getMname());
        model.addAttribute("buyerEmail", mdto.getMemail());
        model.addAttribute("buyerTel", mdto.getMtel());
        model.addAttribute("prodName", pdto.getPname());
        model.addAttribute("pno", pdto.getPno());
        model.addAttribute("totalAmount", pdto.getPprice());
        
        return "pay/payForm";
    }
    
    // 결제 성공 API
    @RequestMapping("/pay/paySuccess")
    @ResponseBody
    public Map<String, Object> paySuccess(@RequestBody Map<String, Object> reqData,
                                        HttpServletRequest request) {
        String paymentId = (String) reqData.get("paymentId");
        int pno = ((Number) reqData.get("pno")).intValue();
        int totalAmount = ((Number) reqData.get("totalAmount")).intValue();
        String payment = (String) reqData.get("payment");
        String buyerEmail = (String) reqData.get("buyerEmail");
        
        int mno = mdao.findByEmail(buyerEmail).getMno();
        
        OrdersDTO odto = new OrdersDTO();
        odto.setMno(mno);
        odto.setOno(paymentId);
        odto.setOpayment(payment);
        odto.setOprice(totalAmount);
        
        MemberPassesDTO mpdto = new MemberPassesDTO();
        mpdto.setPno(pno);
        
        poservice.buyOrExtendPass(mno, odto, mpdto);
        
        PassDTO pdto = pdao.passView(pno);
        poEsservice.save(odto, pdto);
        
        poservice.refreshUserAuthentication("SUBSCRIBER", request);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
    
    // 결제 결과 페이지
    @RequestMapping("/pay/payResult")
    public String payResult(@RequestParam("paymentId") String paymentId, Model model) {
        model.addAttribute("paymentId", paymentId);
        return "pay/paySuccess";
    }
    
    @RequestMapping("/member/myPass")
    public String myPass(Authentication authentication, Model model) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/loginForm";
        }

        // 1. 사이드바의 ${view.mname} 출력을 위한 회원 데이터 조회 및 전달 (필수)
        MemberDTO mdto = mdao.findByEmail(authentication.getName());
        model.addAttribute("view", mdto);

        // 2. 구독권 조회
        MemberPassesDTO pass = mpdao.memberPassesList(mdto.getMno());
        model.addAttribute("pass", pass);

        if (pass != null) {
            // pname은 MemberPassesDTO에 없으므로, pno로 PassDTO를 다시 조회해서 넘긴다
            PassDTO pdto = pdao.passView(pass.getPno());
            model.addAttribute("pname", pdto != null ? pdto.getPname() : "");

            // 날짜 포맷팅
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            model.addAttribute("start", pass.getMpstart() != null ? pass.getMpstart().format(formatter) : "-");
            model.addAttribute("end", pass.getMpend() != null ? pass.getMpend().format(formatter) : "-");
        }

        return "member/myPass";
    }
    
    // 회원용 주문 목록 조회 (Null 예외 안전 처리)
    @RequestMapping("/member/myOrder")
    public String myOrder(Authentication authentication, Model model) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/loginForm";
        }

        MemberDTO mdto = mdao.findByEmail(authentication.getName());
        if (mdto == null) {
            return "redirect:/loginForm";
        }

        List<OrdersDTO> orders = odao.mordersList(mdto.getMno());
        List<String> odates = new ArrayList<>();
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        
        if (orders != null) {
            for (OrdersDTO order : orders) {
                if (order.getOdate() != null) {
                    odates.add(order.getOdate().format(formatter));
                } else {
                    odates.add("-");
                }
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