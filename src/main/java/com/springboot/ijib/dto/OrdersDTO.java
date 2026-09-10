package com.springboot.ijib.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class OrdersDTO {
	private	String			ono;		// 주문 번호
	private	int				oprice;		// 주문 가격
	private	String			opayment;	// 주문 방법
	// Date -> LocalDateTime으로 변경
	private LocalDateTime	odate;		// 주문일
	private String			ostatus;	// 주문 상태(주문:'PAID' or 환불:'REFUND')
	private	int				mno;		// 회원 번호
	
	// 조인을 통해 얻을 컬럼
	private String			pname;		// 구독권 이름
}
