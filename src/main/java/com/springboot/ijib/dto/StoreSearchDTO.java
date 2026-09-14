package com.springboot.ijib.dto;

import java.util.List;
import lombok.Data;

@Data
public class StoreSearchDTO {

    // 검색어
    private String keyword;

    // 검색 결과 (DB 매핑용 필드)
    private int sno;
    private String sname;
    private String sfiles;
    private String saddr;
    private String scontent;
    private String scategory;           // DB의 단일 문자열 카테고리 (화면 출력용)
    private String skeyword;            // DB의 단일 문자열 키워드 (화면 출력용)

    // 필터 조건 (파라미터 전달용 리스트)
    private List<String> scategoryList; // 분류 필터
    private List<String> skeywordList;  // 키워드 필터
    private String ssido;               // 시도
    private List<String> ssigungu;      // 시군구
    private List<String> sinfo;         // 영업정보
    private String sparking;            // 주차 여부
    private String sstatus;             // 상태

    private Integer minPrice;           // 최소 가격
    private Integer maxPrice;           // 최대 가격

    private Double minRating;           // 최소 별점

    private String rfeature;            // 리뷰 특징
    private double ratingAvg;           // 평균 별점
}