package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.dto.StoreSearchDTO;

@Service
public class StoreSearchService {

    @Autowired
    private RestHighLevelClient client;

    @Autowired
    private IStoreDAO storeDAO;

    // 음식점 통합검색
    public List<StoreSearchDTO> search(StoreSearchDTO searchDTO) throws IOException {

        String keyword = searchDTO.getKeyword();
        List<String> scategory = searchDTO.getScategory();

        System.out.println("===== ES 검색 시작 =====");
        System.out.println("keyword = " + keyword);
        System.out.println("scategory = " + scategory);

        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();

        /*
         * 검색어가 있을 때만 통합검색
         */
        if (keyword != null && !keyword.trim().isEmpty()) {

            // 상호명
            boolQuery.should(
                QueryBuilders.matchQuery("sname", keyword)
            );

            // 가게 설명
            boolQuery.should(
                QueryBuilders.matchQuery("scontent", keyword)
            );

            // 주소
            boolQuery.should(
                QueryBuilders.matchQuery("saddr", keyword)
            );

            // 메뉴명
            boolQuery.should(
                QueryBuilders.nestedQuery(
                    "menu",
                    QueryBuilders.matchQuery("menu.mnname", keyword),
                    org.apache.lucene.search.join.ScoreMode.Avg
                )
            );

            // 검색어가 있으면 위 should 중 하나는 반드시 만족
            boolQuery.minimumShouldMatch(1);
        }

        /*
         * 분류 필터
         */
        if (scategory != null && !scategory.isEmpty()) {

            boolQuery.filter(
                QueryBuilders.termsQuery(
                    "scategory.keyword",
                    scategory
                )
            );
        }

        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

        sourceBuilder.query(boolQuery);
        sourceBuilder.size(100);

        SearchRequest request = new SearchRequest("store");
        request.source(sourceBuilder);

        System.out.println("===== ES 요청 전 =====");

        SearchResponse response = client.search(
            request,
            RequestOptions.DEFAULT
        );

        System.out.println("===== ES 응답 받음 =====");
        System.out.println(
            "검색 결과 수 = "
            + response.getHits().getHits().length
        );

        List<StoreSearchDTO> result = new ArrayList<>();

        /*
         * ES 검색 결과 → Oracle에서 상세정보 조회
         */
        for (var hit : response.getHits().getHits()) {

            int sno = ((Number) hit.getSourceAsMap().get("sno")).intValue();

            System.out.println("ES sno = " + sno);

            StoreDTO store = storeDAO.storeView(sno);

            if (store != null) {

                System.out.println("Oracle 조회 성공 = " + store.getSno());

                StoreSearchDTO dto = new StoreSearchDTO();

                dto.setKeyword(keyword);
                dto.setSno(store.getSno());
                dto.setSname(store.getSname());
                dto.setSfiles(store.getSfiles());
                dto.setSaddr(store.getSaddr());
                dto.setScontent(store.getScontent());

                result.add(dto);

            } else {

                System.out.println("Oracle 조회 실패 = " + sno);
            }
        }

        System.out.println("===== 최종 검색 결과 =====");
        System.out.println("결과 DTO 수 = " + result.size());

        return result;
    }
}