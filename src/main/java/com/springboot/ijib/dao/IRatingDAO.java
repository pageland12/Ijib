package com.springboot.ijib.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.ijib.dto.RatingDTO;

@Mapper
public interface IRatingDAO {
	// 목록
	public List<RatingDTO> ratingList(int sno);
	
	// 일부 후기 조회
	public List<RatingDTO> ratingPreview(int sno);
	
	// 마이페이지 목록
	public List<RatingDTO> myRatingList(int mno);
	
	// 상세 보기
	public RatingDTO ratingView(int rno);
	
	// 작성
	public int ratingWrite(RatingDTO rdto);
	
	// 수정
	public int ratingUpdate(RatingDTO rdto);
	
	// 삭제
	public int ratingDelete(int rno);
}
