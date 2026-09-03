package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.NoticeDTO;

@Mapper
public interface INoticeDAO {
	// 목록
	public List<NoticeDTO> noticeList();
	
	// 상세보기
	public NoticeDTO noticeView(int nno);
	
	// 작성
	public int noticeWrite(NoticeDTO ndto);
	
	// 수정
	public int noticeUpdate(NoticeDTO ndto);
	
	// 삭제
	public int noticeDelete(int nno);
	
	// 조회수 증가
	public int noticeHit(int nno);	
}
