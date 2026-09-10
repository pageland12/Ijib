package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.dto.StoreSearchDTO;

@Service
public class StoreNameSearchService {

    @Autowired
    private RestHighLevelClient client;

    @Autowired
    private IStoreDAO storeDAO;


    // 식당명 검색
    public List<StoreSearchDTO> search(String keyword) throws IOException {

        List<StoreSearchDTO> result = new ArrayList<>();


        // Elasticsearch 검색 조건
        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

        sourceBuilder.query(
            QueryBuilders.matchQuery("sname", keyword)
        );

        sourceBuilder.size(100);


        // store 인덱스 검색
        SearchRequest request = new SearchRequest("store");
        request.source(sourceBuilder);


        SearchResponse response = client.search(
            request,
            RequestOptions.DEFAULT
        );


        // 검색 결과 처리
        for (var hit : response.getHits().getHits()) {

            int sno = ((Number) hit.getSourceAsMap()
                    .get("sno"))
                    .intValue();

            System.out.println("식당명 검색 ES sno = " + sno);


            // Oracle에서 상세 정보 조회
            StoreDTO store = storeDAO.storeView(sno);


            if (store != null) {

                System.out.println(
                    "Oracle 조회 성공 = " + store.getSno()
                );


                StoreSearchDTO dto = new StoreSearchDTO();

                dto.setKeyword(keyword);
                dto.setSno(store.getSno());
                dto.setSname(store.getSname());
                dto.setSfiles(store.getSfiles());
                dto.setSaddr(store.getSaddr());
                dto.setScontent(store.getScontent());

                result.add(dto);


            } else {

                System.out.println(
                    "Oracle 조회 실패 = " + sno
                );
            }
        }


        return result;
    }
}
