package com.springboot.ijib.dto;

import java.util.List;

import lombok.Data;

@Data
public class StoreSearchDTO {

    // 검색어
    private String keyword;

    // 검색 결과
    private int sno;
    private String sname;
    private String sfiles;
    private String saddr;
    private String scontent;

    // 필터
    private List<String> scategory;   	// 분류
    private List<String> skeyword;    	// 키워드
    private String ssido;       		// 시도
    private List<String> ssigungu;   	// 시군구
    private List<String> sinfo;       	// 영업정보
    private String sparking;    		// 주차 여부
    private String sstatus;     		// 상태

    private Integer minPrice;   		// 최소 가격
    private Integer maxPrice;   		// 최대 가격

    private Double minRating;   		// 최소 별점

    private String rfeature;    		// 리뷰 특징
}