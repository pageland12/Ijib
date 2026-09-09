package com.springboot.ijib.dao;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.MemberPassesDTO;

@Mapper
public interface IMemberPassesDAO {
	// 회원 구독권 조회
	public MemberPassesDTO memberPassesList(int mno);
	
	// 회원 구독권 확인(구독권 구매 시 활성화된 다른 구독권이 있으면 해당 구독권들 중 가장 만료일이 늦은 구독권의 만료일 반환)
	public LocalDateTime findActivePass(int mno);
	
	// 회원 구독권 등록(구독권 구매)
	public int memberPassInsert(MemberPassesDTO dto);
	
	// 전체 회원 구독권 만료 갱신
	public int allExpiredPassesUpdate();
	
	// 회원 구독권 만료 갱신
	public int expiredPassesUpdate(int mno);
}
