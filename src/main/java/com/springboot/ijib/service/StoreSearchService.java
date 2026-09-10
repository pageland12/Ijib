package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
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


    // 음식점 검색
    public List<StoreSearchDTO> search(
            StoreSearchDTO searchDTO,
            String searchType) throws IOException {

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

        // 공통 필터 Query
        BoolQueryBuilder baseQuery =
            QueryBuilders.boolQuery();


        // 분류 필터
        if (scategory != null && !scategory.isEmpty()) {

            baseQuery.filter(
                QueryBuilders.termsQuery(
                    "scategory.keyword",
                    scategory
                )
            );
        }


        // 키워드 필터
        if (skeyword != null && !skeyword.isEmpty()) {

            BoolQueryBuilder keywordQuery =
                QueryBuilders.boolQuery();

            for (String keywordValue : skeyword) {

                keywordQuery.must(
                    QueryBuilders.matchPhraseQuery(
                        "skeyword",
                        keywordValue
                    )
                );
            }

            baseQuery.filter(keywordQuery);
        }


        // 시도 필터
        if (ssido != null && !ssido.isEmpty()) {

            baseQuery.filter(
                QueryBuilders.termQuery(
                    "ssido.keyword",
                    ssido
                )
            );
        }


        // 시군구 필터
        if (ssigungu != null && !ssigungu.isEmpty()) {

            baseQuery.filter(
                QueryBuilders.termsQuery(
                    "ssigungu.keyword",
                    ssigungu
                )
            );
        }


        // 가격 필터
        if (minPrice != null || maxPrice != null) {

            BoolQueryBuilder priceQuery =
                QueryBuilders.boolQuery();

            if (minPrice != null) {

                priceQuery.must(
                    QueryBuilders.rangeQuery(
                        "menu.mnprice"
                    ).gte(minPrice)
                );
            }

            if (maxPrice != null) {

                priceQuery.must(
                    QueryBuilders.rangeQuery(
                        "menu.mnprice"
                    ).lte(maxPrice)
                );
            }

            baseQuery.filter(
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

            BoolQueryBuilder sinfoQuery =
                QueryBuilders.boolQuery();

            for (String day : sinfo) {

                // 선택한 요일이 휴무인 가게 제외
                sinfoQuery.mustNot(
                    QueryBuilders.wildcardQuery(
                        "sinfo.keyword",
                        "*" + day + ": 휴무일*"
                    )
                );
            }

            baseQuery.filter(sinfoQuery);
        }


        // 주차 여부 필터
        if (sparking != null && !sparking.isEmpty()) {

            System.out.println("===== 주차 여부 필터 =====");
            System.out.println("선택 주차 여부 = " + sparking);


            // 주차 불가능
            if ("불가능".equals(sparking)) {

                BoolQueryBuilder parkingQuery =
                    QueryBuilders.boolQuery();

                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 정보 없음"
                    )
                );

                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가"
                    )
                );

                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가능"
                    )
                );

                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "사실상 주차 불가"
                    )
                );

                parkingQuery.should(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "별도의 주차 공간이 없습니다"
                    )
                );

                parkingQuery.minimumShouldMatch(1);

                baseQuery.filter(parkingQuery);
            }


            // 주차 가능
            else if ("가능".equals(sparking)) {

                BoolQueryBuilder parkingQuery =
                    QueryBuilders.boolQuery();

                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 정보 없음"
                    )
                );

                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가"
                    )
                );

                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "주차 불가능"
                    )
                );

                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "사실상 주차 불가"
                    )
                );

                parkingQuery.mustNot(
                    QueryBuilders.matchPhraseQuery(
                        "sparking",
                        "별도의 주차 공간이 없습니다"
                    )
                );

                baseQuery.filter(parkingQuery);
            }
        }


        // 영업 상태 필터
        if (sstatus != null && !sstatus.isEmpty()) {

            baseQuery.filter(
                QueryBuilders.termQuery(
                    "sstatus",
                    sstatus
                )
            );
        }


        // 평균 별점 필터
        if (minRating != null) {

            baseQuery.filter(
                QueryBuilders.rangeQuery(
                    "ratingAvg"
                ).gte(minRating)
            );
        }

        // 검색 Query 생성
        SearchResponse response;

        // 1. 식당명 검색
        if ("store".equals(searchType)
                && keyword != null
                && !keyword.trim().isEmpty()) {

            String searchKeyword =
                keyword.trim();


            // 1차 : 식당명 완전 일치 검색
            BoolQueryBuilder exactQuery =
                QueryBuilders.boolQuery();

            // 공통 필터
            exactQuery.must(baseQuery);

            // 식당명 완전 일치
            exactQuery.must(
                QueryBuilders.termQuery(
                    "sname.keyword",
                    searchKeyword
                )
            );


            SearchSourceBuilder exactSource =
                new SearchSourceBuilder();

            exactSource.query(exactQuery);
            exactSource.size(100);


            SearchRequest exactRequest =
                new SearchRequest("store");

            exactRequest.source(exactSource);


            SearchResponse exactResponse =
                client.search(
                    exactRequest,
                    RequestOptions.DEFAULT
                );


            // 완전 일치 결과가 있으면
            if (exactResponse.getHits().getTotalHits().value > 0) {

                System.out.println(
                    "===== 식당명 완전 일치 검색 성공 ====="
                );

                System.out.println(
                    "검색어 = " + searchKeyword
                );

                response = exactResponse;
            }


            // 완전 일치 결과가 없으면
            else {

                System.out.println(
                    "===== 완전 일치 결과 없음 ====="
                );

                System.out.println(
                    "유사 식당명 검색 실행"
                );


                BoolQueryBuilder similarQuery =
                    QueryBuilders.boolQuery();

                // 공통 필터
                similarQuery.must(baseQuery);

                // 유사 식당명 검색
                similarQuery.must(
                    QueryBuilders.matchQuery(
                        "sname",
                        searchKeyword
                    )
                );


                SearchSourceBuilder similarSource =
                    new SearchSourceBuilder();

                similarSource.query(similarQuery);
                similarSource.size(100);


                SearchRequest similarRequest =
                    new SearchRequest("store");

                similarRequest.source(similarSource);


                response = client.search(
                    similarRequest,
                    RequestOptions.DEFAULT
                );
            }
        }

        // 2. 통합검색
        else {

            String searchKeyword =
                keyword == null
                    ? ""
                    : keyword.trim();


            // 검색어가 있는 경우
            if (!searchKeyword.isEmpty()) {

                // 2-1. 지역 검색
                BoolQueryBuilder regionQuery =
                    QueryBuilders.boolQuery();


                // 시군구
                regionQuery.should(
                    QueryBuilders.prefixQuery(
                        "ssigungu.keyword",
                        searchKeyword
                    )
                );


                // 시도
                regionQuery.should(
                    QueryBuilders.prefixQuery(
                        "ssido.keyword",
                        searchKeyword
                    )
                );


                regionQuery.minimumShouldMatch(1);


                // 공통 필터 + 지역 검색
                BoolQueryBuilder finalRegionQuery =
                    QueryBuilders.boolQuery();

                finalRegionQuery.must(baseQuery);
                finalRegionQuery.must(regionQuery);


                SearchSourceBuilder regionSource =
                    new SearchSourceBuilder();

                regionSource.query(finalRegionQuery);
                regionSource.size(100);


                SearchRequest regionRequest =
                    new SearchRequest("store");

                regionRequest.source(regionSource);


                SearchResponse regionResponse =
                    client.search(
                        regionRequest,
                        RequestOptions.DEFAULT
                    );

                // 지역 검색 결과가 있는 경우
                if (regionResponse.getHits()
                        .getTotalHits().value > 0) {

                    System.out.println(
                        "===== 지역 검색 성공 ====="
                    );

                    System.out.println(
                        "지역 검색어 = " + searchKeyword
                    );

                    response = regionResponse;
                }

                // 지역 검색 결과가 없는 경우
                else {
                    boolean addressSearch =
                        searchKeyword.endsWith("로")
                        || searchKeyword.endsWith("길")
                        || searchKeyword.endsWith("대로")
                        || searchKeyword.endsWith("거리");

                    // 2-2. 주소 검색
                    if (addressSearch) {

                        System.out.println(
                            "===== 주소 검색 ====="
                        );

                        System.out.println(
                            "주소 검색어 = " + searchKeyword
                        );


                        BoolQueryBuilder addressQuery =
                            QueryBuilders.boolQuery();

                        // 공통 필터
                        addressQuery.must(baseQuery);


                        // 주소만 검색
                        addressQuery.must(
                            QueryBuilders.matchPhraseQuery(
                                "saddr",
                                searchKeyword
                            )
                        );


                        SearchSourceBuilder addressSource =
                            new SearchSourceBuilder();

                        addressSource.query(addressQuery);
                        addressSource.size(100);


                        SearchRequest addressRequest =
                            new SearchRequest("store");

                        addressRequest.source(addressSource);


                        response = client.search(
                            addressRequest,
                            RequestOptions.DEFAULT
                        );
                    }

                    // 2-3. 일반 통합검색
                    else {

                        System.out.println(
                            "===== 일반 통합검색 ====="
                        );

                        System.out.println(
                            "검색어 = " + searchKeyword
                        );


                        BoolQueryBuilder totalQuery =
                            QueryBuilders.boolQuery();


                        // 공통 필터
                        totalQuery.must(baseQuery);

                        // 상호명
                        totalQuery.should(
                            QueryBuilders.matchQuery(
                                "sname",
                                searchKeyword
                            )
                        );

                        // 가게 설명
                        totalQuery.should(
                            QueryBuilders.matchQuery(
                                "scontent",
                                searchKeyword
                            )
                        );

                        // 주소
                        totalQuery.should(
                            QueryBuilders.matchPhraseQuery(
                                "saddr",
                                searchKeyword
                            )
                        );

                        // 메뉴명
                        totalQuery.should(
                            QueryBuilders.nestedQuery(
                                "menu",
                                QueryBuilders.matchQuery(
                                    "menu.mnname",
                                    searchKeyword
                                ),
                                org.apache.lucene.search.join.ScoreMode.Avg
                            )
                        );


                        // 위 조건 중 하나 이상 만족
                        totalQuery.minimumShouldMatch(1);


                        SearchSourceBuilder sourceBuilder =
                            new SearchSourceBuilder();

                        sourceBuilder.query(totalQuery);
                        sourceBuilder.size(100);


                        SearchRequest request =
                            new SearchRequest("store");

                        request.source(sourceBuilder);


                        response = client.search(
                            request,
                            RequestOptions.DEFAULT
                        );
                    }
                }
            }


            // 검색어가 없는 경우
            else {

                SearchSourceBuilder sourceBuilder =
                    new SearchSourceBuilder();

                sourceBuilder.query(baseQuery);
                sourceBuilder.size(100);


                SearchRequest request =
                    new SearchRequest("store");

                request.source(sourceBuilder);


                response = client.search(
                    request,
                    RequestOptions.DEFAULT
                );
            }
        }

        // ES 검색 결과 → Oracle 상세정보 조회
        List<StoreSearchDTO> result =
            new ArrayList<>();


        for (var hit : response.getHits().getHits()) {

            int sno =
                ((Number)
                    hit.getSourceAsMap()
                       .get("sno")
                ).intValue();


            System.out.println(
                "ES sno = " + sno
            );


            StoreDTO store =
                storeDAO.storeView(sno);


            if (store != null) {

                System.out.println(
                    "Oracle 조회 성공 = "
                    + store.getSno()
                );


                StoreSearchDTO dto =
                    new StoreSearchDTO();


                dto.setKeyword(keyword);

                dto.setSno(
                    store.getSno()
                );

                dto.setSname(
                    store.getSname()
                );

                dto.setSfiles(
                    store.getSfiles()
                );

                dto.setSaddr(
                    store.getSaddr()
                );

                dto.setScontent(
                    store.getScontent()
                );


                result.add(dto);
            }


            else {

                System.out.println(
                    "Oracle 조회 실패 = " + sno
                );
            }
        }


        return result;
    }

    // 자동완성 + 하이라이트
    public List<Map<String, String>> autocompleteHighlight(
            String keyword,
            String searchType) throws IOException {

        List<Map<String, String>> result =
            new ArrayList<>();


        if (keyword == null
                || keyword.trim().isEmpty()) {

            return result;
        }


        String searchKeyword =
            keyword.trim();


        SearchRequest request =
            new SearchRequest("store");


        SearchSourceBuilder source =
            new SearchSourceBuilder();


        source.size(10);

        // 통합검색
        // 식당명 + 설명 + 주소 + 메뉴명
        if ("total".equals(searchType)) {

            BoolQueryBuilder totalQuery =
                QueryBuilders.boolQuery();


            // 식당명
            totalQuery.should(
                QueryBuilders.matchPhrasePrefixQuery(
                    "sname",
                    searchKeyword
                )
            );


            // 가게 설명
            totalQuery.should(
                QueryBuilders.matchPhrasePrefixQuery(
                    "scontent",
                    searchKeyword
                )
            );


            // 주소
            totalQuery.should(
                QueryBuilders.matchPhrasePrefixQuery(
                    "saddr",
                    searchKeyword
                )
            );


            // 메뉴명
            totalQuery.should(
                QueryBuilders.nestedQuery(
                    "menu",
                    QueryBuilders.matchPhrasePrefixQuery(
                        "menu.mnname",
                        searchKeyword
                    ),
                    org.apache.lucene.search.join.ScoreMode.Avg
                )
            );


            totalQuery.minimumShouldMatch(1);

            source.query(totalQuery);
        }

        // 식당명 검색
        // 식당명만 자동완성
        else if ("store".equals(searchType)) {

            source.query(
                QueryBuilders.matchPhrasePrefixQuery(
                    "sname",
                    searchKeyword
                )
            );
        }

        // 하이라이트
        HighlightBuilder highlight =
            new HighlightBuilder();


        if ("total".equals(searchType)) {

            highlight.field(
                new HighlightBuilder.Field("sname")
                    .highlightQuery(
                        QueryBuilders.matchPhrasePrefixQuery(
                            "sname",
                            searchKeyword
                        )
                    )
            );


            highlight.field(
                new HighlightBuilder.Field("scontent")
                    .highlightQuery(
                        QueryBuilders.matchPhrasePrefixQuery(
                            "scontent",
                            searchKeyword
                        )
                    )
            );


            highlight.field(
                new HighlightBuilder.Field("saddr")
                    .highlightQuery(
                        QueryBuilders.matchPhrasePrefixQuery(
                            "saddr",
                            searchKeyword
                        )
                    )
            );


            highlight.field(
                new HighlightBuilder.Field("menu.mnname")
                    .highlightQuery(
                        QueryBuilders.matchPhrasePrefixQuery(
                            "menu.mnname",
                            searchKeyword
                        )
                    )
            );
        }


        else if ("store".equals(searchType)) {

            highlight.field(
                new HighlightBuilder.Field("sname")
                    .highlightQuery(
                        QueryBuilders.matchPhrasePrefixQuery(
                            "sname",
                            searchKeyword
                        )
                    )
            );
        }


        highlight.preTags("<em>");
        highlight.postTags("</em>");


        source.highlighter(highlight);


        request.source(source);


        SearchResponse response =
            client.search(
                request,
                RequestOptions.DEFAULT
            );

        // 검색 결과
        for (SearchHit hit : response.getHits()) {

            Map<String, Object> sourceMap =
                hit.getSourceAsMap();


            String title = "";


            if (sourceMap.get("sname") != null) {

                title =
                    sourceMap.get("sname").toString();
            }


            String highlighted = title;


            // 식당명 하이라이트가 있으면 사용
            if (hit.getHighlightFields()
                    .get("sname") != null) {

                highlighted =
                    hit.getHighlightFields()
                       .get("sname")
                       .fragments()[0]
                       .string();
            }


            Map<String, String> map =
                new HashMap<>();


            map.put("sname", title);
            map.put("highlight", highlighted);


            result.add(map);
        }


        return result;
    }
}
