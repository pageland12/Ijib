package com.springboot.ijib.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IMemberPassesDAO;
import com.springboot.ijib.dto.MemberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private IMemberDAO dao;

    @Autowired
    private IMemberPassesDAO mpdao;
    
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberDTO dto = dao.findByEmail(username);

        if (dto == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다: " + username);
        }
        int mno = dto.getMno();
        
        // 3. DB 권한(mauth)이 "ROLE_USER" 형태일 때 Safe하게 적용
        String role = dto.getMauth();
        if (role != null && role.startsWith("ROLE_")) {
        	role = role.substring(5); // "ROLE_USER" -> "USER"
        }

        // 4. 만료된 정기권 갱신 및 현재 활성화되어 있는 정기권 확인
        LocalDateTime mpend = null;
        if("SUBSCRIBER".equals(role)) {
        	mpdao.expiredPassesUpdate(mno);
        	mpend = mpdao.findActivePass(mno);
        }
        
        // 5. 현재 활성화된 정기권이 없는데 회원의 권한이 "SUBSCRIBER"인 경우 "NORMAL"로 변경
        if (mpend == null && "SUBSCRIBER".equals(role)) {
        	role = "NORMAL";
        	dto.setMauth("NORMAL");
        	dao.memberAuthUpdate(dto);
        }
        
        // 6. Spring Security 인증용 UserDetails 객체 생성 반환
        return User.builder()
                .username(dto.getMemail())   	// 로그인 아이디 (memail)
                .password(dto.getMpasswd())  	// DB에 저장된 암호화된 비밀번호
                .roles(role) 					// 기본 권한 지정
                .build();
    }
}