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
        MemberDTO dto = dao.findByEmail(username);

        if (dto == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자입니다: " + username);
        }

        String role = dto.getMauth();
        if (role != null) {
            role = role.trim();
            if (role.startsWith("ROLE_")) {
                role = role.substring(5);
            }
        }

        return User.builder()
                .username(dto.getMemail())
                .password(dto.getMpasswd())
                .roles(role)   // 정리된 role 변수 사용
                .build();
    }
}