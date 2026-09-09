package com.springboot.ijib.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import jakarta.servlet.DispatcherType;

@Configuration
public class WebSecurityConfig {

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.csrf((csrf) -> csrf.disable()) // CSRF 보호 비활성화
				.cors((cors) -> cors.disable()) // CORS 비활성화
				.authorizeHttpRequests(request -> request.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll() // 내부
																														// 포인트
																														// 요청
																														// 허용

						// 로그인 관련 페이지는 반드시 permitAll (리다이렉트 루프 방지)
						.requestMatchers("/", "/main", "/loginForm", "/loginError", "/j_spring_security_check")
						.permitAll()

						// 정적 리소스 모두 허용
						.requestMatchers("/css/**", "/js/**", "/images/**", "/assets/**", "/favicon.ico").permitAll()

						// 게스트 공용 페이지 (회원/관리자 제외)
						.requestMatchers("/guest/**", "/board/**", "/pay/**").permitAll()

						// 구체적인 규칙을 먼저 배치 (member/admin 순서 중요)
						.requestMatchers("/admin/**").hasAnyRole("ADMIN") // ADMIN만 허용
						.requestMatchers("/member/**").hasAnyRole("NORMAL", "ADMIN") // NORMAL, ADMIN 허용

						.anyRequest().authenticated() // 나머지는 모두 인증 필요
				);

		// login
		http.formLogin((formLogin) -> formLogin.loginPage("/loginForm").loginProcessingUrl("/j_spring_security_check")
				.defaultSuccessUrl("/main", true).failureUrl("/loginError").usernameParameter("memail")
				.passwordParameter("mpasswd").permitAll());

		// logout
		http.logout((logout) -> logout.logoutUrl("/logout").logoutSuccessUrl("/").invalidateHttpSession(true) // ★ 로그아웃
																												// 시 세션
																												// 완전히
																												// 삭제
				.clearAuthentication(true) // ★ 인증 정보 초기화
				.permitAll());

		return http.build();
	}
}