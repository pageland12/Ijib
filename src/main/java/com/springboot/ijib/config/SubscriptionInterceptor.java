package com.springboot.ijib.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.service.PassOrderService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class SubscriptionInterceptor implements HandlerInterceptor{
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private PassOrderService poservice;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		// 로그인한 회원의 권한 들고오기
		// @AuthenticationPrincipal는 @Controller에서만 사용 가능
		// 이외에는 SecurityContextHolder에서 들고와야함
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		// 1. 비로그인 상태이거나 익명 토큰인 경우 차단
        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='/login';</script>");
            return false;
        }
        
        // 2. 관리자는 검증 없이 통과
        boolean isAdmin = auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        if (isAdmin) {
        	return true;
        }
		
		// 3. 현재 세션에 'SUBSCRIBER' 권한이 있는지 체크
		boolean isSubscriber = auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_SUBSCRIBER"));
		if (isSubscriber) {
			String email = auth.getName();
			MemberDTO member = mdao.findByEmail(email);
			
			// 3. DB에 있는 회원의 권한을 조회해 'NORMAL'이라면 접근 차단
			if (member != null && "NORMAL".equals(member.getMauth())) {
				// 세션 인증 토큰 재발급, 'NORMAL'로 초기화
				poservice.refreshUserAuthentication("NORMAL", request);
				
				// 알림창을 띄우고 구독권 안내 페이지로 리다이렉트
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('구독권이 만료되어 일반 회원으로 전환되었습니다.'); location.href='/guest/passList';</script>");
                return false; // 요청 중단 (컨트롤러로 진입하지 않음)
			}
			
			// DB까지 검증했을 때도 여전히 SUBSCRIBER라면 통과
			return true;
		}
		
		// 4. 비구독자 회원 or 모든 조건에 만족하지 않는 사용자 차단
		response.setContentType("text/html; charset=UTF-8");
        response.getWriter().println("<script>alert('구독자 전용 서비스입니다.'); history.back();</script>");
		
		return false;
	}
}
