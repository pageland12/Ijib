package com.springboot.ijib.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
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
            String gender,
            int age) throws IOException {

        Map<String, Object> data = new HashMap<>();

        data.put("keyword", keyword);
        data.put("search_type", searchType);
        data.put("price_range", priceRange);
        data.put("gender", gender);
        data.put("age", age);
        data.put("searched_at", new java.util.Date());

        IndexRequest request = new IndexRequest("search_logs")
                .source(data);

        IndexResponse response = client.index(
                request,
                RequestOptions.DEFAULT
        );
    }
}