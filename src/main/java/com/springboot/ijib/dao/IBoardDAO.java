package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.BoardDTO;

@Mapper
public interface IBoardDAO {
	// 목록
	public List<BoardDTO> boardList();
	
	// 상세보기
	public BoardDTO boardView(int bno);
	
	// 작성
	public int boardWrite(BoardDTO bdto);
	
	// 수정
	public int boardUpdate(BoardDTO bdto);
	
	// 삭제
	public int boardDelete(int bno);
	
	// 조회수 증가
	public int boardHit(int bno);

}
