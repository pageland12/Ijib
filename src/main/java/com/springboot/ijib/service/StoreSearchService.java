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
        List<String> skeyword = searchDTO.getSkeyword();
        String ssido = searchDTO.getSsido();
        List<String> ssigungu = searchDTO.getSsigungu();
        Integer minPrice = searchDTO.getMinPrice();
        Integer maxPrice = searchDTO.getMaxPrice();
        List<String> sinfo = searchDTO.getSinfo();
        String sparking = searchDTO.getSparking();
        Double minRating = searchDTO.getMinRating();
        String sstatus = searchDTO.getSstatus();

        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();

        // 검색어가 있을 때만 통합검색
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

        // 분류 필터
        if (scategory != null && !scategory.isEmpty()) {

            boolQuery.filter(
                QueryBuilders.termsQuery(
                    "scategory.keyword",
                    scategory
                )
            );
        }
        
        // 키워드 필터
        if (skeyword != null && !skeyword.isEmpty()) {

            BoolQueryBuilder keywordQuery = QueryBuilders.boolQuery();

            for (String keywordValue : skeyword) {

                keywordQuery.must(
                    QueryBuilders.matchPhraseQuery(
                        "skeyword",
                        keywordValue
                    )
                );
            }

            boolQuery.filter(keywordQuery);
        }
        
        // 시도 필터
        if (ssido != null && !ssido.isEmpty()) {
            boolQuery.filter(
                QueryBuilders.termQuery("ssido.keyword", ssido)
            );
        }
        
        // 시군구 필터
        if (ssigungu != null && !ssigungu.isEmpty()) {
            boolQuery.filter(
                QueryBuilders.termsQuery("ssigungu.keyword", ssigungu)
            );
        }
        
        // 가격 필터
        if (minPrice != null || maxPrice != null) {

            BoolQueryBuilder priceQuery = QueryBuilders.boolQuery();

            if (minPrice != null) {
                priceQuery.must(
                    QueryBuilders.rangeQuery("menu.mnprice")
                        .gte(minPrice)
                );
            }

            if (maxPrice != null) {
                priceQuery.must(
                    QueryBuilders.rangeQuery("menu.mnprice")
                        .lte(maxPrice)
                );
            }

            boolQuery.filter(
                QueryBuilders.nestedQuery(
                    "menu",
                    priceQuery,
                    org.apache.lucene.search.join.ScoreMode.Avg
                )
            );
        }
        
        // 영업요일 필터
        if (sinfo != null && !sinfo.isEmpty()) {

            System.out.println("===== 영업요일 필터 =====");
            System.out.println("선택 요일 = " + sinfo);

            BoolQueryBuilder sinfoQuery = QueryBuilders.boolQuery();

            for (String day : sinfo) {

                // 선택한 요일이 휴무인 가게는 제외
                sinfoQuery.mustNot(
                    QueryBuilders.wildcardQuery(
                        "sinfo.keyword",
                        "*" + day + ": 휴무일*"
                    )
                );
            }

            // 선택한 요일들은 AND
            boolQuery.filter(sinfoQuery);
        }
        
        // 주차 여부 필터
        if (sparking != null && !sparking.isEmpty()) {

            System.out.println("===== 주차 여부 필터 =====");
            System.out.println("선택 주차 여부 = " + sparking);

            // 주차 불가능
            if ("불가능".equals(sparking)) {

                BoolQueryBuilder parkingQuery = QueryBuilders.boolQuery();

                // 주차 정보 없음
                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 정보 없음"
                    )
                );

                // 주차 불가
                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가"
                    )
                );

                // 주차 불가능
                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가능"
                    )
                );

                // 사실상 주차 불가
                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "사실상 주차 불가"
                    )
                );

                // 별도의 주차 공간이 없습니다
                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "별도의 주차 공간이 없습니다"
                    )
                );

                parkingQuery.minimumShouldMatch(1);

                boolQuery.filter(parkingQuery);
            }

            // 주차 가능
            else if ("가능".equals(sparking)) {

                BoolQueryBuilder parkingQuery = QueryBuilders.boolQuery();

                // 주차 정보 없음 → 제외
                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 정보 없음"
                    )
                );

                // 주차 불가 → 제외
                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가"
                    )
                );

                // 주차 불가능 → 제외
                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가능"
                    )
                );

                // 사실상 주차 불가 → 제외
                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "사실상 주차 불가"
                    )
                );

                // 별도의 주차 공간이 없습니다 → 제외
                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "별도의 주차 공간이 없습니다"
                    )
                );

                boolQuery.filter(parkingQuery);
            }
        }
        
        // 영업 상태 필터
        if (sstatus != null && !sstatus.isEmpty()) {

            boolQuery.filter(
                QueryBuilders.termQuery(
                    "sstatus",
                    sstatus
                )
            );
        }
        
        // 평균 별점 필터
        if (minRating != null) {

            boolQuery.filter(
                QueryBuilders.rangeQuery("ratingAvg")
                    .gte(minRating)
            );

        }

        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();

        sourceBuilder.query(boolQuery);
        sourceBuilder.size(100);

        SearchRequest request = new SearchRequest("store");
        request.source(sourceBuilder);

        SearchResponse response = client.search(
            request,
            RequestOptions.DEFAULT
        );

        List<StoreSearchDTO> result = new ArrayList<>();

        // ES 검색 결과 → Oracle에서 상세정보 조회
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

        return result;
    }
}