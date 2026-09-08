package com.springboot.ijib.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class MemberPassesDTO {
	private	int				mpno;		// 회원 구독권 번호
	// Date -> LocalDateTime으로 변경
	private	LocalDateTime	mpstart;	// 회원 구독권 시작일
	private	LocalDateTime	mpend;		// 회원 구독권 만료일
	private String			mpstatus;	// 회원 구독권 상태 (ACTIVE / INACTIVE)
	private	int				mno;		// 회원 번호
	private	String			ono;		// 주문 번호
	private	int				pno;		// 구독권 번호
	
	// 회원 구독권 조회를 위한 필드 변수
	private int				mpcount;
}
