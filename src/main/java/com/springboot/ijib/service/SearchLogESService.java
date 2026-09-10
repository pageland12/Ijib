package com.springboot.ijib.service;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SearchLogESService {

    @Autowired
    private RestHighLevelClient client;

    // 검색 기록 저장
    public void searchLogSave(
            String keyword,
            String searchType,
            String priceRange,
            List<String> scategory,
            List<String> skeyword,
            String ssido,
            List<String> ssigungu,
            List<String> sinfo,
            String sparking,
            String sstatus,
            Double minRating,
            String gender,
            Integer age,
            Integer mno) throws IOException {

        Map<String, Object> data = new HashMap<>();

        // 검색 기본 정보
        data.put("keyword", keyword);
        data.put("search_type", searchType);

        // 필터
        data.put("scategory", scategory);
        data.put("skeyword", skeyword);
        data.put("ssido", ssido);
        data.put("ssigungu", ssigungu);
        data.put("sinfo", sinfo);
        data.put("sparking", sparking);
        data.put("sstatus", sstatus);
        data.put("min_rating", minRating);

        // 가격
        data.put("price_range", priceRange);

        // 회원 정보
        data.put("gender", gender);
        data.put("age", age);
        data.put("mno", mno);

        // 검색 시간
        data.put("searched_at", new Date());

        IndexRequest request = new IndexRequest("search_logs")
                .source(data);

        client.index(request, RequestOptions.DEFAULT);
    }
}