package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.ijib.dto.OrdersDTO;

@Mapper
public interface IOrdersDAO {
	// 주문 목록: 회원
	public List<OrdersDTO> mordersList(int mno);
	
	// 주문 목록 등록
	public int orderInsert(OrdersDTO dto);
	
	// 주문 상태 갱신(환불)
	public int refundedOrderUpdate(OrdersDTO dto);
	
	// 회원의 전체 주문 페이징 목록
    public List<OrdersDTO> memberOrderListPaging(@Param("mno") int mno, @Param("startRow") int startRow, @Param("endRow") int endRow);
    
    // 회원의 전체 주문 개수
    public int getTotalOrderCountByMno(int mno);
}
