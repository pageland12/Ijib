package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.SortBuilders;
import org.elasticsearch.search.sort.SortOrder;

import com.springboot.ijib.dto.MenuESDTO;
import com.springboot.ijib.dto.RatingESDTO;
import com.springboot.ijib.dto.StoreESDTO;

@Service
public class StoreESService {

    @Autowired
    private RestHighLevelClient client;

    // 음식점 등록 / 수정
    public void storeSave(StoreESDTO dto) throws IOException {

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
        data.put("ratingAvg", dto.getRatingAvg());

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
        
        // 리뷰
        if(dto.getRating() != null) {

            List<Map<String, Object>> ratingList = new ArrayList<>();

            for(RatingESDTO rating : dto.getRating()) {

                Map<String, Object> ratingData = new HashMap<>();

                ratingData.put("rrate", rating.getRrate());
                ratingData.put("rfeature", rating.getRfeature());

                ratingList.add(ratingData);
            }

            data.put("rating", ratingList);
        }
        
        IndexRequest request = new IndexRequest("store")
                .id(String.valueOf(dto.getSno()))
                .source(data);

        IndexResponse response = client.index(request, RequestOptions.DEFAULT);
        
    }
    
    // 음식점 삭제
    public void storeDelete(int sno) throws IOException {

        DeleteRequest request = new DeleteRequest(
                "store",
                String.valueOf(sno)
        );

        DeleteResponse response = client.delete(
                request,
                RequestOptions.DEFAULT
        );
    }
    
    // 내 주변 음식점 검색
    public List<Map<String, Object>> nearbyStoreList(
            double lat,
            double lon,
            double distanceKm) throws IOException {

        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

        sourceBuilder.query(
            QueryBuilders.geoDistanceQuery("location")
                .point(lat, lon)
                .distance(distanceKm, org.elasticsearch.common.unit.DistanceUnit.KILOMETERS)
        );

        // 가까운 순으로 정렬
        sourceBuilder.sort(
            SortBuilders.geoDistanceSort("location", lat, lon)
                .order(SortOrder.ASC)
        );

        SearchRequest request = new SearchRequest("store");
        request.source(sourceBuilder);

        SearchResponse response =
                client.search(request, RequestOptions.DEFAULT);

        List<Map<String, Object>> list = new ArrayList<>();

        for (org.elasticsearch.search.SearchHit hit : response.getHits().getHits()) {
            Map<String, Object> data = new HashMap<>(hit.getSourceAsMap());

            // Elasticsearch 문서 ID
            data.put("sno", Integer.parseInt(hit.getId()));

            list.add(data);
        }

        return list;
    }
}