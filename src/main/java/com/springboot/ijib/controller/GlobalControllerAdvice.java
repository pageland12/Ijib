package com.springboot.ijib.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;

@ControllerAdvice
public class GlobalControllerAdvice {

    @Autowired
    private IMemberDAO mdao;

    // 로그인 여부와 상관없이 모든 컨트롤러 요청에 "view" 모델 속성을 자동으로 채워준다.
    // -> 헤더/사이드바처럼 여러 페이지에 include 되는 JSP에서 ${view.mname} 을 페이지 구분 없이 쓸 수 있음
    @ModelAttribute("view")
    public MemberDTO addLoginMember(Authentication authentication) {
        if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
            return null; // 비로그인 상태
        }
        return mdao.findByEmail(authentication.getName());
    }
}