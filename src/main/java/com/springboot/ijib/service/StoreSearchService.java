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
import com.springboot.ijib.dao.IStoreSearchDAO;
import com.springboot.ijib.dto.StoreDTO;
import com.springboot.ijib.dto.StoreSearchDTO;

@Service
public class StoreSearchService {

    @Autowired
    private RestHighLevelClient client;

    @Autowired
    private IStoreDAO storeDAO;
    
    @Autowired
    private IStoreSearchDAO storeSearchDAO;

    // 음식점 검색
    public List<StoreSearchDTO> search(
            StoreSearchDTO searchDTO,
            String searchType) throws IOException {

        String keyword = searchDTO.getKeyword();
        List<String> scategoryList = searchDTO.getScategoryList();
        List<String> skeywordList = searchDTO.getSkeywordList();
        String ssido = searchDTO.getSsido();
        List<String> ssigungu = searchDTO.getSsigungu();
        Integer minPrice = searchDTO.getMinPrice();
        Integer maxPrice = searchDTO.getMaxPrice();
        List<String> sinfo = searchDTO.getSinfo();
        String sparking = searchDTO.getSparking();
        Double minRating = searchDTO.getMinRating();
        String sstatus = searchDTO.getSstatus();

        // 공통 필터 Query
        BoolQueryBuilder baseQuery = QueryBuilders.boolQuery();

        // 분류 필터
        if (scategoryList != null && !scategoryList.isEmpty()) {
            baseQuery.filter(
                QueryBuilders.termsQuery("scategory.keyword", scategoryList)
            );
        }

        // 키워드 필터
        if (skeywordList != null && !skeywordList.isEmpty()) {
            BoolQueryBuilder keywordQuery = QueryBuilders.boolQuery();
            for (String keywordValue : skeywordList) {
                keywordQuery.must(
                    QueryBuilders.matchPhraseQuery("skeyword", keywordValue)
                );
            }
            baseQuery.filter(keywordQuery);
        }

        // 시도 필터
        if (ssido != null && !ssido.isEmpty()) {
            baseQuery.filter(
                QueryBuilders.termQuery("ssido.keyword", ssido)
            );
        }

        // 시군구 필터
        if (ssigungu != null && !ssigungu.isEmpty()) {
            baseQuery.filter(
                QueryBuilders.termsQuery("ssigungu.keyword", ssigungu)
            );
        }

        // 가격 필터
        if (minPrice != null || maxPrice != null) {
            BoolQueryBuilder priceQuery = QueryBuilders.boolQuery();

            if (minPrice != null) {
                priceQuery.must(
                    QueryBuilders.rangeQuery("menu.mnprice").gte(minPrice)
                );
            }

            if (maxPrice != null) {
                priceQuery.must(
                    QueryBuilders.rangeQuery("menu.mnprice").lte(maxPrice)
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

            BoolQueryBuilder sinfoQuery = QueryBuilders.boolQuery();

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
                BoolQueryBuilder parkingQuery = QueryBuilders.boolQuery();

                parkingQuery.should(QueryBuilders.matchPhraseQuery("sparking", "주차 정보 없음"));
                parkingQuery.should(QueryBuilders.matchPhraseQuery("sparking", "주차 불가"));
                parkingQuery.should(QueryBuilders.matchPhraseQuery("sparking", "주차 불가능"));
                parkingQuery.should(QueryBuilders.matchPhraseQuery("sparking", "사실상 주차 불가"));
                parkingQuery.should(QueryBuilders.matchPhraseQuery("sparking", "별도의 주차 공간이 없습니다"));

                parkingQuery.minimumShouldMatch(1);
                baseQuery.filter(parkingQuery);
            }
            // 주차 가능
            else if ("가능".equals(sparking)) {
                BoolQueryBuilder parkingQuery = QueryBuilders.boolQuery();

                parkingQuery.mustNot(QueryBuilders.matchPhraseQuery("sparking", "주차 정보 없음"));
                parkingQuery.mustNot(QueryBuilders.matchPhraseQuery("sparking", "주차 불가"));
                parkingQuery.mustNot(QueryBuilders.matchPhraseQuery("sparking", "주차 불가능"));
                parkingQuery.mustNot(QueryBuilders.matchPhraseQuery("sparking", "사실상 주차 불가"));
                parkingQuery.mustNot(QueryBuilders.matchPhraseQuery("sparking", "별도의 주차 공간이 없습니다"));

                baseQuery.filter(parkingQuery);
            }
        }

        // 영업 상태 필터
        if (sstatus != null && !sstatus.isEmpty()) {
            baseQuery.filter(
                QueryBuilders.termQuery("sstatus", sstatus)
            );
        }

        // 평균 별점 필터
        if (minRating != null) {
            baseQuery.filter(
                QueryBuilders.rangeQuery("ratingAvg").gte(minRating)
            );
        }

        SearchResponse response;

        // 1. 식당명 검색
        if ("store".equals(searchType) && keyword != null && !keyword.trim().isEmpty()) {
            String searchKeyword = keyword.trim();

            // 1차 : 식당명 완전 일치 검색
            BoolQueryBuilder exactQuery = QueryBuilders.boolQuery();
            exactQuery.must(baseQuery);
            exactQuery.must(QueryBuilders.termQuery("sname.keyword", searchKeyword));

            SearchSourceBuilder exactSource = new SearchSourceBuilder();
            exactSource.query(exactQuery);
            exactSource.size(300);

            SearchRequest exactRequest = new SearchRequest("store");
            exactRequest.source(exactSource);

            SearchResponse exactResponse = client.search(exactRequest, RequestOptions.DEFAULT);

            // 완전 일치 결과가 있으면
            if (exactResponse.getHits().getTotalHits().value > 0) {
                System.out.println("===== 식당명 완전 일치 검색 성공 =====");
                System.out.println("검색어 = " + searchKeyword);
                response = exactResponse;
            } else {
                System.out.println("===== 완전 일치 결과 없음 =====");
                System.out.println("유사 식당명 검색 실행");

                BoolQueryBuilder similarQuery = QueryBuilders.boolQuery();
                similarQuery.must(baseQuery);
                similarQuery.must(QueryBuilders.matchQuery("sname", searchKeyword));

                SearchSourceBuilder similarSource = new SearchSourceBuilder();
                similarSource.query(similarQuery);
                similarSource.size(300);

                SearchRequest similarRequest = new SearchRequest("store");
                similarRequest.source(similarSource);

                response = client.search(similarRequest, RequestOptions.DEFAULT);
            }
        }
        // 2. 통합검색
        else {
            String searchKeyword = keyword == null ? "" : keyword.trim();

            if (!searchKeyword.isEmpty()) {
                // 2-1. 지역 검색
                BoolQueryBuilder regionQuery = QueryBuilders.boolQuery();
                regionQuery.should(QueryBuilders.prefixQuery("ssigungu.keyword", searchKeyword));
                regionQuery.should(QueryBuilders.prefixQuery("ssido.keyword", searchKeyword));
                regionQuery.minimumShouldMatch(1);

                BoolQueryBuilder finalRegionQuery = QueryBuilders.boolQuery();
                finalRegionQuery.must(baseQuery);
                finalRegionQuery.must(regionQuery);

                SearchSourceBuilder regionSource = new SearchSourceBuilder();
                regionSource.query(finalRegionQuery);
                regionSource.size(300);

                SearchRequest regionRequest = new SearchRequest("store");
                regionRequest.source(regionSource);

                SearchResponse regionResponse = client.search(regionRequest, RequestOptions.DEFAULT);

                if (regionResponse.getHits().getTotalHits().value > 0) {
                    System.out.println("===== 지역 검색 성공 =====");
                    System.out.println("지역 검색어 = " + searchKeyword);
                    response = regionResponse;
                } else {
                    boolean addressSearch = searchKeyword.endsWith("로")
                            || searchKeyword.endsWith("길")
                            || searchKeyword.endsWith("대로")
                            || searchKeyword.endsWith("거리");

                    // 2-2. 주소 검색
                    if (addressSearch) {
                        System.out.println("===== 주소 검색 =====");
                        System.out.println("주소 검색어 = " + searchKeyword);

                        BoolQueryBuilder addressQuery = QueryBuilders.boolQuery();
                        addressQuery.must(baseQuery);
                        addressQuery.must(QueryBuilders.matchPhraseQuery("saddr", searchKeyword));

                        SearchSourceBuilder addressSource = new SearchSourceBuilder();
                        addressSource.query(addressQuery);
                        addressSource.size(300);

                        SearchRequest addressRequest = new SearchRequest("store");
                        addressRequest.source(addressSource);

                        response = client.search(addressRequest, RequestOptions.DEFAULT);
                    }
                    // 2-3. 일반 통합검색
                    else {
                        System.out.println("===== 일반 통합검색 =====");
                        System.out.println("검색어 = " + searchKeyword);

                        BoolQueryBuilder totalQuery = QueryBuilders.boolQuery();
                        totalQuery.must(baseQuery);
                        totalQuery.should(QueryBuilders.matchQuery("sname", searchKeyword));
                        totalQuery.should(QueryBuilders.matchQuery("scontent", searchKeyword));
                        totalQuery.should(QueryBuilders.matchPhraseQuery("saddr", searchKeyword));
                        totalQuery.should(
                            QueryBuilders.nestedQuery(
                                "menu",
                                QueryBuilders.matchQuery("menu.mnname", searchKeyword),
                                org.apache.lucene.search.join.ScoreMode.Avg
                            )
                        );
                        totalQuery.minimumShouldMatch(1);

                        SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
                        sourceBuilder.query(totalQuery);
                        sourceBuilder.size(300);

                        SearchRequest request = new SearchRequest("store");
                        request.source(sourceBuilder);

                        response = client.search(request, RequestOptions.DEFAULT);
                    }
                }
            } else {
                SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
                sourceBuilder.query(baseQuery);
                sourceBuilder.size(300);

                SearchRequest request = new SearchRequest("store");
                request.source(sourceBuilder);

                response = client.search(request, RequestOptions.DEFAULT);
            }
        }

        // ES 검색 결과 → Oracle 상세정보 조회
        System.out.println("===== ES 응답 총 건수 = " + response.getHits().getTotalHits().value + " =====");

        List<StoreSearchDTO> result = new ArrayList<>();

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
                dto.setScategory(store.getScategory());
                dto.setSkeyword(store.getSkeyword());

                result.add(dto);
            } else {
                System.out.println("Oracle 조회 실패 = " + sno);
            }
        }

        return result;
    }

    // 자동완성 + 하이라이트
    public List<Map<String, String>> autocompleteHighlight(
            String keyword,
            String searchType) throws IOException {

        List<Map<String, String>> result = new ArrayList<>();

        if (keyword == null || keyword.trim().isEmpty()) {
            return result;
        }

        String searchKeyword = keyword.trim();
        SearchRequest request = new SearchRequest("store");
        SearchSourceBuilder source = new SearchSourceBuilder();
        source.size(10);

        // 통합검색 (식당명 + 설명 + 주소 + 메뉴명)
        if ("total".equals(searchType)) {
            BoolQueryBuilder totalQuery = QueryBuilders.boolQuery();
            totalQuery.should(QueryBuilders.matchPhrasePrefixQuery("sname", searchKeyword));
            totalQuery.should(QueryBuilders.matchPhrasePrefixQuery("scontent", searchKeyword));
            totalQuery.should(QueryBuilders.matchPhrasePrefixQuery("saddr", searchKeyword));
            totalQuery.should(
                QueryBuilders.nestedQuery(
                    "menu",
                    QueryBuilders.matchPhrasePrefixQuery("menu.mnname", searchKeyword),
                    org.apache.lucene.search.join.ScoreMode.Avg
                )
            );
            totalQuery.minimumShouldMatch(1);
            source.query(totalQuery);
        }
        // 식당명 검색
        else if ("store".equals(searchType)) {
            source.query(QueryBuilders.matchPhrasePrefixQuery("sname", searchKeyword));
        }

        // 하이라이트
        HighlightBuilder highlight = new HighlightBuilder();

        if ("total".equals(searchType)) {
            highlight.field(new HighlightBuilder.Field("sname")
                .highlightQuery(QueryBuilders.matchPhrasePrefixQuery("sname", searchKeyword)));
            highlight.field(new HighlightBuilder.Field("scontent")
                .highlightQuery(QueryBuilders.matchPhrasePrefixQuery("scontent", searchKeyword)));
            highlight.field(new HighlightBuilder.Field("saddr")
                .highlightQuery(QueryBuilders.matchPhrasePrefixQuery("saddr", searchKeyword)));
            highlight.field(new HighlightBuilder.Field("menu.mnname")
                .highlightQuery(QueryBuilders.matchPhrasePrefixQuery("menu.mnname", searchKeyword)));
        } else if ("store".equals(searchType)) {
            highlight.field(new HighlightBuilder.Field("sname")
                .highlightQuery(QueryBuilders.matchPhrasePrefixQuery("sname", searchKeyword)));
        }

        highlight.preTags("<em>");
        highlight.postTags("</em>");

        source.highlighter(highlight);
        request.source(source);

        SearchResponse response = client.search(request, RequestOptions.DEFAULT);

        for (SearchHit hit : response.getHits()) {
            Map<String, Object> sourceMap = hit.getSourceAsMap();
            String title = "";

            if (sourceMap.get("sname") != null) {
                title = sourceMap.get("sname").toString();
            }

            String highlighted = title;

            if (hit.getHighlightFields().get("sname") != null) {
                highlighted = hit.getHighlightFields().get("sname").fragments()[0].string();
            }

            Map<String, String> map = new HashMap<>();
            map.put("sname", title);
            map.put("highlight", highlighted);

            result.add(map);
        }

        return result;
    }

    public List<StoreSearchDTO> searchStoresFromDb(StoreSearchDTO searchDTO) {
        return storeSearchDAO.searchStores(searchDTO);
    }
}