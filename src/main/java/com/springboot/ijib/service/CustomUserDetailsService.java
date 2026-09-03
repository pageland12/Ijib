package com.springboot.ijib.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private IMemberDAO dao;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. WebSecurityConfig의 usernameParameter("memail")에 의해 memail 값이 username 매개변수로 들어옴
        MemberDTO dto = dao.findByEmail(username);
        
        // 2. 사용자가 존재하지 않을 경우 처리
        if (dto == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다: " + username);
        }
        
        // 3. DB 권한(mauth)이 "ROLE_USER" 형태일 때 Safe하게 적용
        String role = dto.getMgrade();
        if (role != null && role.startsWith("ROLE_")) {
            role = role.substring(5); // "ROLE_USER" -> "USER"
        }
        
        // 4. Spring Security 인증용 UserDetails 객체 생성 반환
        return User.builder()
                .username(dto.getMemail())   // 로그인 아이디 (memail)
                .password(dto.getMpasswd())  // DB에 저장된 암호화된 비밀번호
                .roles(dto.getMgrade()) // 기본 권한 지정
                .build();
    }
}