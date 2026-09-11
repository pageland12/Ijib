package com.springboot.ijib.service;

import java.io.IOException;
import java.util.ArrayList;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dao.IMemberDAO;
import com.springboot.ijib.dto.MemberDTO;
import com.springboot.ijib.dto.MemberSearchDTO;

@Service
public class MemberSearchService {

    @Autowired
    private RestHighLevelClient client;

    @Autowired
    private IMemberDAO memberDAO;


    // 회원 통합검색 + 필터
    public List<MemberDTO> search(MemberSearchDTO searchDTO)
            throws IOException {

        String keyword = searchDTO.getKeyword();
        String mgender = searchDTO.getMgender();
        List<Integer> ageGroups = searchDTO.getAgeGroups();
        List<String> regions = searchDTO.getRegions();
        List<String> mauth = searchDTO.getMauth();


        // 공통 필터
        BoolQueryBuilder baseQuery =
                QueryBuilders.boolQuery();

        // 성별
        if (mgender != null
                && !mgender.trim().isEmpty()
                && !"전체".equals(mgender)) {

            baseQuery.filter(
                QueryBuilders.termQuery(
                    "mgender",
                    mgender
                )
            );
        }

        // 나이대
        if (ageGroups != null
                && !ageGroups.isEmpty()) {

            BoolQueryBuilder ageQuery =
                    QueryBuilders.boolQuery();

            for (Integer ageGroup : ageGroups) {

                int minAge = ageGroup;
                int maxAge = ageGroup + 9;

                ageQuery.should(
                    QueryBuilders.rangeQuery("mage")
                        .gte(minAge)
                        .lte(maxAge)
                );
            }

            // 선택한 나이대 중 하나라도 해당되면 검색
            ageQuery.minimumShouldMatch(1);

            baseQuery.filter(ageQuery);
        }

        // 지역
        if (regions != null
                && !regions.isEmpty()) {

            BoolQueryBuilder regionQuery =
                    QueryBuilders.boolQuery();

            for (String region : regions) {

                if (region == null
                        || region.trim().isEmpty()) {
                    continue;
                }

                String regionName = region.trim();

                String addressPrefix = "";

                switch (regionName) {

                    case "서울":
                        addressPrefix = "서울특별시";
                        break;

                    case "경기":
                        addressPrefix = "경기도";
                        break;

                    case "인천":
                        addressPrefix = "인천광역시";
                        break;

                    case "부산":
                        addressPrefix = "부산광역시";
                        break;

                    case "대구":
                        addressPrefix = "대구광역시";
                        break;

                    case "광주":
                        addressPrefix = "광주광역시";
                        break;

                    case "대전":
                        addressPrefix = "대전광역시";
                        break;

                    case "울산":
                        addressPrefix = "울산광역시";
                        break;

                    case "세종":
                        addressPrefix = "세종특별자치시";
                        break;

                    case "강원":
                        addressPrefix = "강원특별자치도";
                        break;

                    case "충북":
                        addressPrefix = "충청북도";
                        break;

                    case "충남":
                        addressPrefix = "충청남도";
                        break;

                    case "전북":
                        addressPrefix = "전북특별자치도";
                        break;

                    case "전남":
                        addressPrefix = "전라남도";
                        break;

                    case "경북":
                        addressPrefix = "경상북도";
                        break;

                    case "경남":
                        addressPrefix = "경상남도";
                        break;

                    case "제주":
                        addressPrefix = "제주특별자치도";
                        break;
                }

                if (!addressPrefix.isEmpty()) {

                    regionQuery.should(
                        QueryBuilders.wildcardQuery(
                            "maddr.keyword",
                            addressPrefix + "*"
                        )
                    );
                }
            }

            // 선택한 지역 중 하나라도 해당되면 검색
            regionQuery.minimumShouldMatch(1);

            baseQuery.filter(regionQuery);
        }

        // 권한
        if (mauth != null && !mauth.isEmpty()) {

            BoolQueryBuilder authQuery =
                    QueryBuilders.boolQuery();

            for (String auth : mauth) {

                if (auth != null && !auth.trim().isEmpty()) {

                    authQuery.should(
                        QueryBuilders.termQuery(
                            "mauth",
                            auth.trim()
                        )
                    );
                }
            }

            // 선택한 권한 중 하나라도 해당되면 검색
            authQuery.minimumShouldMatch(1);

            baseQuery.filter(authQuery);
        }

        // 검색창
        BoolQueryBuilder finalQuery =
                QueryBuilders.boolQuery();

        // 공통 필터 적용
        finalQuery.must(baseQuery);


        if (keyword != null
                && !keyword.trim().isEmpty()) {

            String searchKeyword =
                    keyword.trim();


            // 이름
            finalQuery.should(
                QueryBuilders.wildcardQuery(
                    "mname.keyword",
                    "*" + searchKeyword + "*"
                )
            );


            // 이메일
            finalQuery.should(
                QueryBuilders.wildcardQuery(
                    "memail",
                    "*" + searchKeyword + "*"
                )
            );


            // 전화번호
            finalQuery.should(
                QueryBuilders.wildcardQuery(
                    "mtel",
                    "*" + searchKeyword + "*"
                )
            );


            // 주소
            finalQuery.should(
                QueryBuilders.matchQuery(
                    "maddr",
                    searchKeyword
                )
            );


            // 위 4개 중 하나라도 일치
            finalQuery.minimumShouldMatch(1);
        }

        // Elasticsearch 검색
        SearchSourceBuilder sourceBuilder =
                new SearchSourceBuilder();

        sourceBuilder.query(finalQuery);

        sourceBuilder.size(100);


        SearchRequest request =
                new SearchRequest("member");

        request.source(sourceBuilder);


        SearchResponse response =
                client.search(
                    request,
                    RequestOptions.DEFAULT
                );

        // ES 결과 → Oracle 회원정보 조회
        List<MemberDTO> result =
                new ArrayList<>();


        for (SearchHit hit :
                response.getHits().getHits()) {

            Map<String, Object> source =
                    hit.getSourceAsMap();


            if (source.get("mno") == null) {
                continue;
            }


            int mno =
                ((Number) source.get("mno"))
                    .intValue();


            System.out.println(
                "ES 회원 검색 mno = " + mno
            );


            // Oracle에서 최종 회원정보 조회
            MemberDTO member =
                memberDAO.memberView(mno);


            if (member != null) {

                result.add(member);

                System.out.println(
                    "Oracle 회원 조회 성공 = "
                    + member.getMno()
                );

            } else {

                System.out.println(
                    "Oracle 회원 조회 실패 = "
                    + mno
                );
            }
        }


        return result;
    }
}