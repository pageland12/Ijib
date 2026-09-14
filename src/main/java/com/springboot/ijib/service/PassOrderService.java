package com.springboot.ijib.service;

import java.net.URI;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dao.IMemberPassesDAO;
import com.springboot.ijib.dao.IOrdersDAO;
import com.springboot.ijib.dao.IPassDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberPassesDTO;
import com.springboot.ijib.dto.OrdersDTO;
import com.springboot.ijib.dto.PassDTO;

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
	
	// Spring Security 권한과 DB 권한을 비교하는 메서드
	public boolean checkDBandSecurityAuth(String dbRole, Collection<GrantedAuthority> auth) {
		String targetRole = "ROLE_" + dbRole;
		
		// 권한이 같으면 true 반환
		return auth.stream().anyMatch(a -> a.getAuthority().equals(targetRole));
	}
	
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
            		session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, SecurityContextHolder.getContext());
            	}
            }
        }
    }
	
	// 결제: 주문 내역/회원 구독권 등록
	@Transactional(rollbackFor = Exception.class)
	public String buyOrExtendPass(int mno, OrdersDTO odto, MemberPassesDTO mpdto) {
		// 중복 결제 요청 1차 방어: 시간차가 있는 재요청 조회
		String ono = odto.getOno();	// 발급 받은 주문 번호
		OrdersDTO existingOrder = odao.orderView(ono);
		if (existingOrder != null) {
			MemberDTO member = mdao.memberView(mno);
			return member != null ? member.getMauth() : "SUBSCRIBER";
		}
		
		// 1. 주문 내역(Orders) 등록
		odao.orderInsert(odto);
		
		// 동시성 등록 방어: 회원 레코드에 배타적 락(FOR UPDATE) 획득
		// 다른 주문 혹은 환불 트랜잭션이 동일한 회원의 구독권을 연장 혹은 환불 중이라면, 여기서 대기함
		mdao.memberViewForUpdate(mno);
		
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
		
		return "SUBSCRIBER";
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
	
	// 환불: PortOne V2 취소 API 통신 메소드
	@Value("${portone.api.secret}")
	private String portoneApiSecret;

	public void cancelPortOnePayment(String paymentId, String reason) {
	    RestTemplate restTemplate = new RestTemplate();
	    String cancelUrl = "https://api.portone.io/payments/" + paymentId + "/cancel";

	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_JSON);
	    headers.set("Authorization", "PortOne " + portoneApiSecret);

	    Map<String, Object> body = new HashMap<>();
	    body.put("reason", reason);

	    HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

	    try {
	        ResponseEntity<String> response = restTemplate.postForEntity(URI.create(cancelUrl), entity, String.class);
	        if (!response.getStatusCode().is2xxSuccessful()) {
	            throw new RuntimeException("포트원 결제 취소 거절: " + response.getBody());
	        }
	    } catch (Exception e) {
	        throw new RuntimeException("결제 취소 API 통신 실패: " + e.getMessage());
	    }
	}
	
	// 환불 선점: PAID -> REFUND_PENDING
	@Transactional(rollbackFor = Exception.class)
	public boolean markRefundPending(int mno, String ono) {
	    OrdersDTO odto = new OrdersDTO();
	    odto.setMno(mno);
	    odto.setOno(ono);
	    return odao.markRefundPending(odto) == 1;
	}

	// 환불 롤백: REFUND_PENDING -> PAID
	@Transactional(rollbackFor = Exception.class)
	public void rollbackRefundPending(int mno, String ono) {
	    OrdersDTO odto = new OrdersDTO();
	    odto.setMno(mno);
	    odto.setOno(ono);
	    odao.rollbackRefundOrder(odto);
	}
	
	// 환불: 주문 내역/회원 구독권 상태 갱신
	@Transactional(rollbackFor = Exception.class)
	public String refundPass(int mno, String ono) {
		OrdersDTO odto = new OrdersDTO();
		odto.setMno(mno);
		odto.setOno(ono);
		
		MemberPassesDTO mpdto = new MemberPassesDTO();
		mpdto.setMno(mno);
		mpdto.setOno(ono);
		
		// 1차 방어: 멱등성 검증 (주문 정보 조회 및 상태 확인)
		OrdersDTO order = odao.orderView(ono);
		if (order == null) {
			throw new IllegalArgumentException("존재하지 않는 주문 번호입니다. ono=" + ono);
		}
		
		// 이미 환불 처리된 건이면 날짜 차감 없이 바로 현재 권한 반환
		if ("REFUND".equalsIgnoreCase(order.getOstatus())) {
			MemberDTO currentMember = mdao.memberView(mno);
			return currentMember != null ? currentMember.getMauth() : "NORMAL";
		}
		
		// 1. 주문 내역의 상태(ostatus)를 'REFUND'로 변경
		int updatedCount = odao.refundedOrderUpdate(odto);
		
		// 2차 방어: 동시 진입 시 오직 한 스레드만 updatedCount에 1을 반환받음
		// 업데이트가 안된 스레드는 0을 반환받음
		if (updatedCount == 0) {
		    // 0.001초 차이로 다른 스레드가 먼저 'REFUND'로 바꿨다는 뜻
		    MemberDTO currentMember = mdao.memberView(mno);
		    return currentMember != null ? currentMember.getMauth() : "NORMAL";
		}
		
		// updatedCount가 1인 유일한 요청만 아래 코드를 실행
		// 동시성 등록 방어: 회원 레코드에 배타적 락(FOR UPDATE) 획득
		// 다른 주문 혹은 환불 트랜잭션이 동일한 회원의 구독권을 연장 혹은 환불 중이라면, 여기서 대기함
		mdao.memberViewForUpdate(mno);
		
		// 2-1. 해당 회원 구독권 상태(mpstatus)를 'REFUND'로 변경
		mpdao.refundedPassUpdate(mpdto);
		
		// 2-2. 환불처리된 회원 구독권의 일수만큼 구독정보 차감
		// 환불처리된 회원 구독권의 일수 확인
		MemberPassesDTO refundedPass = mpdao.memberPassDetail(mpdto);
		int pperiod = pdao.passView(refundedPass.getPno()).getPperiod();
		// 환불처리된 회원 구독권보다 mpend가 늦은 회원 구독권 pull back
		mpdao.futurePassesPullBack(mno, pperiod, refundedPass.getMpend());
		
		// 3. 회원의 활성화 구독권을 확인
		LocalDateTime mpend = mpdao.findActivePass(mno);
		
		// 4. 회원의 활성화 구독권이 없는데, 'SUBSCRIBER'인 경우 'NORMAL'로 강등
		MemberDTO mdto = mdao.memberView(mno);
		String dbRole = mdto.getMauth();
		if (mpend == null && "SUBSCRIBER".equals(mdto.getMauth())) {
			mdto.setMauth("NORMAL");
			mdao.memberAuthUpdate(mdto);
			dbRole = mdto.getMauth();
		}
		
		return dbRole;
	}
}
