package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dto.MenuESDTO;
import com.springboot.ijib.dto.StoreESDTO;

@Service
public class StoreESService {

    @Autowired
    private RestHighLevelClient client;

    // 음식점 1개를 Elasticsearch에 저장
    public void storeInsert(StoreESDTO dto) throws IOException {

        Map<String, Object> data = new HashMap<>();

        data.put("sno", dto.getSno());
        data.put("sname", dto.getSname());
        data.put("scategory", dto.getScategory());
        data.put("skeyword", dto.getSkeyword());
        data.put("scontent", dto.getScontent());
        data.put("saddr", dto.getSaddr());
        data.put("ssido", dto.getSsido());
        data.put("ssigungu", dto.getSsigungu());
        data.put("sinfo", dto.getSinfo());
        data.put("sparking", dto.getSparking());
        data.put("sstatus", dto.getSstatus());

        // 위도 + 경도를 Elasticsearch geo_point 형태로 저장
        Map<String, Object> location = new HashMap<>();
        location.put("lat", dto.getSlat());
        location.put("lon", dto.getSlong());

        data.put("location", location);

        // 메뉴
        if(dto.getMenu() != null) {

            List<Map<String, Object>> menuList = new ArrayList<>();

            for(MenuESDTO menu : dto.getMenu()) {

                Map<String, Object> menuData = new HashMap<>();

                menuData.put("mnname", menu.getMnname());
                menuData.put("mnprice", menu.getMnprice());

                menuList.add(menuData);
            }

            data.put("menu", menuList);
        }

        System.out.println("===== Elasticsearch 저장 시작 =====");
        System.out.println("sno : " + dto.getSno());
        System.out.println("sname : " + dto.getSname());
        System.out.println("menu : " + dto.getMenu());
        
        IndexRequest request = new IndexRequest("store")
                .id(String.valueOf(dto.getSno()))
                .source(data);

        IndexResponse response = client.index(request, RequestOptions.DEFAULT);
        
        System.out.println("Elasticsearch 저장 완료 : " + response.getId());
    }
    
    
}