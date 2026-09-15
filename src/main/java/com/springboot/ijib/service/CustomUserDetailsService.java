package com.springboot.ijib.service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
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
        LocalDateTime activePass = mpdao.findActivePass(mno);

        String role = dto.getMauth();
        if (role != null) {
            role = role.trim();
            if (role.startsWith("ROLE_")) {
                role = role.substring(5);
            }
        }
        
        if (activePass == null && "SUBSCRIBER".equalsIgnoreCase(role)) {
            dto.setMauth("NORMAL");
        	dao.memberAuthUpdate(dto);
            role = "NORMAL";
        }
        
        if (activePass != null && "NORMAL".equalsIgnoreCase(role)) {
        	dto.setMauth("SUBSCRIBER");
        	dao.memberAuthUpdate(dto);
        	role = "SUBSCRIBER";
        }
        

        return User.builder()
                .username(dto.getMemail())
                .password(dto.getMpasswd())
                .roles(role)   // 정리된 role 변수 사용
                .build();
    }
}
