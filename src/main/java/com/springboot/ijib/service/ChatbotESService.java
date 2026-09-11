package com.springboot.ijib.service;

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

import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.StoreDTO;

@Service
public class ChatbotESService {
	@Autowired
	private RestHighLevelClient client;
	
	@Autowired
	private IStoreDAO sdao;
	
	// 챗봇 자연어 질의 기반 백년가게 검색
	// query: 사용자 질문, size: 최대 추천 가게수
	public List<StoreDTO> chatbotStoresSearch(String query, int size) {
		// 반환할 추천 가게 리스트
		List<StoreDTO> storeList = new ArrayList<>();
		
		if (query == null || query.isBlank()) {
			return storeList;
		}
		
		String searchKeyword = query.trim();
		
		try {
			BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
			
			// 1. 영업 중인 가게만 검색
			boolQuery.filter(QueryBuilders.termQuery("sstatus", "OPEN"));
			
			// 2. nori 분석기를 통해 매핑된 필드 다중 매칭
			BoolQueryBuilder shouldQuery = QueryBuilders.boolQuery();
			
			// 2-1. 상호명, 현재 가중치: 3.5
			shouldQuery.should(QueryBuilders.matchQuery("sname", searchKeyword).boost(3.5f));
			
			// 2-2. 메뉴명, 현재 가중치: 3.0
			shouldQuery.should(
					QueryBuilders.nestedQuery(
							"menu", 
							QueryBuilders.matchQuery("menu.mname", searchKeyword), 
							// 해당 가게의 메뉴 중에서 가장 점수가 높은 메뉴의 점수를 가져옴
							org.apache.lucene.search.join.ScoreMode.Max)
					).boost(3.0f);
			
			// 2-3. 업종 분류, 현재 가중치: 2.5
			shouldQuery.should(QueryBuilders.matchQuery("scategory", searchKeyword)).boost(2.5f);
			
			// 2-4. 주소 및 시군구, 현재 가중치: 2.0
			shouldQuery.should(QueryBuilders.matchQuery("saddr", searchKeyword)).boost(2.0f);
			shouldQuery.should(QueryBuilders.matchQuery("ssido", searchKeyword)).boost(2.0f);
			shouldQuery.should(QueryBuilders.matchQuery("ssigungu", searchKeyword)).boost(2.0f);
			
			// 2-5. 키워드 태그, 현재 가중치: 1.5
			shouldQuery.should(QueryBuilders.matchQuery("skeyword", searchKeyword)).boost(1.5f);
			
			// 2-6. 상세 소개글, 현재 가중치: 1.0
			shouldQuery.should(QueryBuilders.matchQuery("scontent", searchKeyword)).boost(1.5f);
			
			shouldQuery.minimumShouldMatch(1);
			boolQuery.must(shouldQuery);
			
			// 3. 검색 쿼리 빌드
			SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
			sourceBuilder.query(boolQuery);
			sourceBuilder.size(size);
						
			SearchRequest request = new SearchRequest("store");
			request.source(sourceBuilder);
			
			// 4. Elastic Search 실행
			SearchResponse response = client.search(request, RequestOptions.DEFAULT);
			
			// 5. sno 추출 -> Oracle DB 단건 조회
			for (SearchHit hit : response.getHits().getHits()) {
				Map<String, Object> source = hit.getSourceAsMap();
				if (source != null && source.get("sno") != null) {
					int sno = ((Number) source.get("sno")).intValue();
					StoreDTO store = sdao.storeView(sno);
					if (store != null) {
						storeList.add(store);
					}
				}
			}
			
		} catch (Exception e) {
			System.err.println("챗봇 백년가게 검색 실패: " + e.getMessage());
			e.printStackTrace();
		}
		
		return storeList;
	}
}
