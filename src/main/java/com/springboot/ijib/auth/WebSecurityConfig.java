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
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		http.csrf((csrf) -> csrf.disable())	// CSRF 보호 비활성화
			.cors((cors) -> cors.disable())	// CORS 비활성화
			.authorizeHttpRequests(request -> request
					.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()	// 내부 포인트 요청 허용
					.requestMatchers("/","/main", "/j_spring_security_check").permitAll()	// root(/)는 모두 허용
					.requestMatchers("/css/**","/js/**","/images/**", "/favicon.ico").permitAll()// 정적 리소스 모두 허용
					.requestMatchers("/guest/**","/board/**","/member/**","/admin/**").permitAll()	// 모두 허용 (게스트 페이지)
					//.requestMatchers("/member/**").hasAnyRole("NORMAL","ADMIN") // USER와 ADMIN만 허용 (회원 페이지)
					//.requestMatchers("/admin/**").hasAnyRole("ADMIN") // ADMIN만 허용 (관리자 페이지)
					.anyRequest().authenticated() // 나머지는 모두 인증 필요
			);
		// login
		http.formLogin((formLogin) -> formLogin
			.loginPage("/loginForm")
			.loginProcessingUrl("/j_spring_security_check")
			.defaultSuccessUrl("/main", true)
			.failureUrl("/loginError")
			.usernameParameter("memail")
			.passwordParameter("mpasswd")
			.permitAll()
		);
		
		// logout
		http.logout((logout) -> logout
			.logoutUrl("/logout")
			.logoutSuccessUrl("/")
			.invalidateHttpSession(true) // ★ 로그아웃 시 세션 완전히 삭제
		    .clearAuthentication(true)   // ★ 인증 정보 초기화
			.permitAll()
		);
		
		return http.build();
	}
}