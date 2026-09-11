package com.springboot.ijib.dto;

import java.util.List;

import lombok.Data;

@Data
public class MemberSearchDTO {

    // 검색창
    private String keyword;

    // 성별
    private String mgender;

    // 나이
    private List<Integer> ageGroups;
    // 지역명
    private List<String> regions;

    // 권한
    private List<String> mauth;
}