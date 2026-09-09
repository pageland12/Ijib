package com.springboot.ijib.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IMemberPassesDAO;
import com.springboot.ijib.dao.IOrdersDAO;
import com.springboot.ijib.dao.IPassDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberPassesDTO;
import com.springboot.ijib.dto.OrdersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class PassOrderService {
	@Autowired
	private	IOrdersDAO odao;
	
	@Autowired
	private IMemberPassesDAO mpdao;
	
	@Autowired
	private IMemberDAO mdao;
	
	@Autowired
	private IPassDAO pdao;
	
    // Spring Security 세션의 권한을 즉시 갱신하는 메서드
    public void refreshUserAuthentication(String role, HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            // 1. 새로운 권한 생성
            List<GrantedAuthority> updatedAuthorities = new ArrayList<>();
            String authorityName = role.startsWith("ROLE_") ? role : "ROLE_" + role;	// 접두어 "ROLE_" 보정
            updatedAuthorities.add(new SimpleGrantedAuthority(authorityName));

            // 2. UserDetails(User) 객체도 새로운 권한을 가진 새 객체로 재생성
            String username = auth.getName(); // 사용자 이메일
            String password = auth.getCredentials() != null ? auth.getCredentials().toString() : "";
            User newUserPrincipal = new User(username, password, updatedAuthorities);

            // 3. 새로운 Authentication 토큰 생성
            Authentication newAuth = new UsernamePasswordAuthenticationToken(
                newUserPrincipal,
                auth.getCredentials(),
                updatedAuthorities
            );
            SecurityContextHolder.getContext().setAuthentication(newAuth);

            // 4. SecurityContext 및 세션 강제 동기화
            if (request != null) {
            	HttpSession session = request.getSession(false);
            	if (session != null) {
            		session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
            	}
            }
        }
    }
	
	// 결제: 주문 내역/회원 구독권 등록
	@Transactional(rollbackFor = Exception.class)
	public void buyOrExtendPass(int mno, OrdersDTO odto, MemberPassesDTO mpdto) {
		// 1. 주문 내역(Orders) 등록
		odao.orderInsert(odto);
		String ono = odto.getOno();	// 등록 후 발급 받은 주문 번호 저장
		
		// 2. 해당 회원이 활성화된 구독권이 있는지 확인(있으면 가장 늦은 mpend 반환)
		LocalDateTime latestMpend = mpdao.findActivePass(mno);
		
		// 3. 구매한 구독권의 기간 확인
		int passPeriod = pdao.passView(mpdto.getPno()).getPperiod();
		
		// 4. MPSTART, MPEND 자정 및 23:59:59 계산
		LocalDateTime mpstart;
		LocalDateTime mpend;
		LocalDate today = LocalDate.now();
		if (latestMpend == null) {
			mpstart = today.plusDays(1).atStartOfDay();
			mpend = mpstart.plusDays(passPeriod - 1).with(LocalTime.of(23, 59, 59));
		} else {
			mpstart = latestMpend.plusSeconds(1);
			mpend = mpstart.plusDays(passPeriod - 1).with(LocalTime.of(23, 59, 59));
		}
		
		// 5. 회원 구독권(Member_Passes) 등록
		mpdto.setOno(ono);
		mpdto.setMpstart(mpstart);
		mpdto.setMpend(mpend);
		mpdto.setMno(mno);
		mpdao.memberPassInsert(mpdto);
		
		// 6. 회원 권한(mauth) 갱신: NORMAL -> SUBSCRIBER
		MemberDTO mdto = new MemberDTO();
		mdto.setMno(mno);
		mdto.setMauth("SUBSCRIBER");
		mdao.memberAuthUpdate(mdto);
	}
	
	// 만료: 전체 구독자의 만료된 구독권 만료 처리 (배치(특정 시각 마다 실행) & 관리자 수동 호출)
	// 사용 시 현재 로그인 중인 회원의 인증 토큰을 재발급해줘야 함
	@Transactional(rollbackFor = Exception.class)
	public int expireAllOverduePasses() {
		// 1. 기간 만료된 구독권 상태 변경
		mpdao.allExpiredPassesUpdate();
		
		// 2. 남은 유효 구독권이 없는 회원의 권한을 ROLE_MEMBER로 감등
		int udpateCount = mdao.downgradeExpiredSubscribers();
		
		// 성공하면 강등된 회원 수 반환
		return udpateCount;
	}
}
