package com.springboot.ijib.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.bucket.nested.Nested;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
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
	
	// 카테고리 상수 필드
	private static final List<String> CATEGORY_DICTIONARY = Arrays.asList(
		    "한식", "중식", "일식", "양식", "고기", "구이", "닭", "오리", "면", "분식", "국", "탕", "백반", "해산물", "회", "카페", "디저트"
	);
	
	// 시/도 상수 필드 (CSV 고유값 기준 + 일상 축약어 반영)
	private static final List<String> SIDO_DICTIONARY = Arrays.asList(
	    // 긴 명칭 우선 매칭
	    "전남광주통합특별시", "강원특별자치도", "전북특별자치도", "제주특별자치도", "세종특별자치시",
	    // 기본 시/도 명칭 및 축약어
	    "서울", "부산", "대구", "인천", "광주", "대전", "울산", "세종",
	    "경기", "강원", "충북", "충남", "전북", "전남", "경북", "경남", "제주"
	);

	// 시/군/구 상수 필드 (CSV 등록 177개 시군구 전체)
	private static final List<String> SIGUNGU_DICTIONARY = Arrays.asList(
	    "가평군", "강릉시", "강진군", "거제시", "거창군", "경산시", "경주시", "고령군", 
	    "고성군", "고양시", "고창군", "고흥군", "곡성군", "공주시", "과천시", "광명시", 
	    "광양시", "광주시", "괴산군", "구례군", "구미시", "군산시", "군위군", "군포시", 
	    "금산군", "김천시", "김포시", "김해시", "나주시", "남원시", "남해군", "단양군", 
	    "담양군", "당진시", "동두천시", "동해시", "목포시", "문경시", "밀양시", "보령시", 
	    "보성군", "보은군", "봉화군", "부안군", "부여군", "부천시", "사천시", "산청군", 
	    "삼척시", "상주시", "서귀포시", "서산시", "서천군", "성남시", "성주군", "속초시", 
	    "수원시", "순창군", "순천시", "시흥시", "아산시", "안동시", "안산시", "안성시", 
	    "안양시", "양구군", "양산시", "양양군", "양주시", "양평군", "여수시", "여주시", 
	    "영광군", "영덕군", "영동군", "영암군", "영양군", "영월군", "영주시", "영천시", 
	    "예산군", "예천군", "옥천군", "완도군", "완주군", "용인시", "울진군", "원주시", 
	    "음성군", "의령군", "의성군", "의왕시", "의정부시", "이천시", "익산시", "인제군", 
	    "임실군", "장성군", "장수군", "장흥군", "전주시", "정선군", "정읍시", "제주시", 
	    "제천시", "진도군", "진안군", "진주시", "진천군", "창녕군", "창원시", "천안시", 
	    "철원군", "청도군", "청송군", "청양군", "청주시", "춘천시", "충주시", "태백시", 
	    "태안군", "통영시", "파주시", "평창군", "평택시", "포천시", "포항시", "하동군", 
	    "함안군", "함양군", "함평군", "합천군", "해남군", "홍천군", "홍성군", "화성시", 
	    "화순군", "화천군", "횡성군",
	    // 구 단위 (광역시 및 대도시 자치구/일반구)
	    "강남구", "강동구", "강북구", "강서구", "관악구", "광산구", "광진구", "구로구", 
	    "금정구", "금천구", "남구", "남동구", "노원구", "달서구", "달성군", "대덕구", 
	    "동구", "동래구", "동대문구", "동작구", "마포구", "부산진구", "북구", "사상구", 
	    "사하구", "서구", "서대문구", "서초구", "성동구", "성북구", "송파구", "수성구", 
	    "수영구", "양천구", "연제구", "영도구", "영등포구", "용산구", "은평구", "종로구", 
	    "중구", "중랑구", "해운대구"
	);

	// 전체 지역 통합 사전 (sigungu 우선 매칭 -> sido 매칭 권장)
	private static final List<String> REGION_DICTIONARY = new ArrayList<>();
	static {
	    REGION_DICTIONARY.addAll(SIGUNGU_DICTIONARY);
	    REGION_DICTIONARY.addAll(SIDO_DICTIONARY);
	}
	
	// 1. 식당별 테마/상황 표준 키워드 목록 (DB 및 ES skeyword에 저장된 원본)
	private static final List<String> THEME_KEYWORDS = Arrays.asList(
	    "새벽까지 영업하는",
	    "혼자 식사하기 좋은",
	    "가족외식",
	    "데이트하기 좋은",
	    "조용하게 식사할 수 있는",
	    "가성비가 좋은",
	    "예약하고 방문하기 좋은",
	    "포장해서 먹기 좋은",
	    "주차하기 편한",
	    "단체로 방문하기 좋은",
	    "노키즈존",
	    "아이와 함께 가기 좋은",
	    "반려동물과 함께 갈 수 있는",
	    "간단하게 식사하기 좋은",
	    "경치가 좋은"
	);

	// 2. 일상 대화어 -> 표준 키워드 매핑 테이블 (유의어 지원)
	private static final Map<String, String> THEME_SYNONYM_MAP = new LinkedHashMap<>();
	static {
	    // 새벽 / 심야
	    THEME_SYNONYM_MAP.put("새벽까지 영업하는", "새벽까지 영업하는");
	    THEME_SYNONYM_MAP.put("새벽", "새벽까지 영업하는");
	    THEME_SYNONYM_MAP.put("심야", "새벽까지 영업하는");
	    THEME_SYNONYM_MAP.put("야간", "새벽까지 영업하는");

	    // 혼밥 / 혼자
	    THEME_SYNONYM_MAP.put("혼자 식사하기 좋은", "혼자 식사하기 좋은");
	    THEME_SYNONYM_MAP.put("혼밥", "혼자 식사하기 좋은");
	    THEME_SYNONYM_MAP.put("혼자", "혼자 식사하기 좋은");
	    THEME_SYNONYM_MAP.put("혼자서", "혼자 식사하기 좋은");

	    // 가족 / 부모님 / 모임
	    THEME_SYNONYM_MAP.put("가족외식", "가족외식");
	    THEME_SYNONYM_MAP.put("가족", "가족외식");
	    THEME_SYNONYM_MAP.put("부모님", "가족외식");
	    THEME_SYNONYM_MAP.put("외식", "가족외식");

	    // 데이트 / 연인 / 분위기
	    THEME_SYNONYM_MAP.put("데이트하기 좋은", "데이트하기 좋은");
	    THEME_SYNONYM_MAP.put("데이트", "데이트하기 좋은");
	    THEME_SYNONYM_MAP.put("연인", "데이트하기 좋은");
	    THEME_SYNONYM_MAP.put("분위기 좋은", "데이트하기 좋은");

	    // 조용한
	    THEME_SYNONYM_MAP.put("조용하게 식사할 수 있는", "조용하게 식사할 수 있는");
	    THEME_SYNONYM_MAP.put("조용한", "조용하게 식사할 수 있는");
	    THEME_SYNONYM_MAP.put("조용하게", "조용하게 식사할 수 있는");
	    THEME_SYNONYM_MAP.put("룸", "조용하게 식사할 수 있는");

	    // 가성비 / 저렴
	    THEME_SYNONYM_MAP.put("가성비가 좋은", "가성비가 좋은");
	    THEME_SYNONYM_MAP.put("가성비", "가성비가 좋은");
	    THEME_SYNONYM_MAP.put("저렴한", "가성비가 좋은");
	    THEME_SYNONYM_MAP.put("착한가격", "가성비가 좋은");

	    // 예약
	    THEME_SYNONYM_MAP.put("예약하고 방문하기 좋은", "예약하고 방문하기 좋은");
	    THEME_SYNONYM_MAP.put("예약", "예약하고 방문하기 좋은");

	    // 포장 / 배달 / 테이크아웃
	    THEME_SYNONYM_MAP.put("포장해서 먹기 좋은", "포장해서 먹기 좋은");
	    THEME_SYNONYM_MAP.put("포장", "포장해서 먹기 좋은");
	    THEME_SYNONYM_MAP.put("테이크아웃", "포장해서 먹기 좋은");

	    // 주차
	    THEME_SYNONYM_MAP.put("주차하기 편한", "주차하기 편한");
	    THEME_SYNONYM_MAP.put("주차", "주차하기 편한");
	    THEME_SYNONYM_MAP.put("주차장", "주차하기 편한");

	    // 단체 / 회식
	    THEME_SYNONYM_MAP.put("단체로 방문하기 좋은", "단체로 방문하기 좋은");
	    THEME_SYNONYM_MAP.put("단체", "단체로 방문하기 좋은");
	    THEME_SYNONYM_MAP.put("회식", "단체로 방문하기 좋은");

	    // 노키즈존
	    THEME_SYNONYM_MAP.put("노키즈존", "노키즈존");
	    THEME_SYNONYM_MAP.put("노키즈", "노키즈존");

	    // 아이 / 유아 / 애기
	    THEME_SYNONYM_MAP.put("아이와 함께 가기 좋은", "아이와 함께 가기 좋은");
	    THEME_SYNONYM_MAP.put("아이", "아이와 함께 가기 좋은");
	    THEME_SYNONYM_MAP.put("아이랑", "아이와 함께 가기 좋은");
	    THEME_SYNONYM_MAP.put("유아", "아이와 함께 가기 좋은");
	    THEME_SYNONYM_MAP.put("어린이", "아이와 함께 가기 좋은");

	    // 반려동물 / 애완동물 / 반려견
	    THEME_SYNONYM_MAP.put("반려동물과 함께 갈 수 있는", "반려동물과 함께 갈 수 있는");
	    THEME_SYNONYM_MAP.put("반려동물", "반려동물과 함께 갈 수 있는");
	    THEME_SYNONYM_MAP.put("반려견", "반려동물과 함께 갈 수 있는");
	    THEME_SYNONYM_MAP.put("애견", "반려동물과 함께 갈 수 있는");
	    THEME_SYNONYM_MAP.put("강아지", "반려동물과 함께 갈 수 있는");

	    // 간단 식사 / 가볍게
	    THEME_SYNONYM_MAP.put("간단하게 식사하기 좋은", "간단하게 식사하기 좋은");
	    THEME_SYNONYM_MAP.put("간단하게", "간단하게 식사하기 좋은");
	    THEME_SYNONYM_MAP.put("가볍게", "간단하게 식사하기 좋은");

	    // 경치 / 뷰 / 뷰맛집
	    THEME_SYNONYM_MAP.put("경치가 좋은", "경치가 좋은");
	    THEME_SYNONYM_MAP.put("경치", "경치가 좋은");
	    THEME_SYNONYM_MAP.put("뷰", "경치가 좋은");
	    THEME_SYNONYM_MAP.put("풍경", "경치가 좋은");
	    THEME_SYNONYM_MAP.put("전망", "경치가 좋은");
	}
	
	
	// 질의에서 카테고리 추출
	public String extractCategory(String query) {
		if (query == null || query.isBlank()) return null;
		for (String cat : CATEGORY_DICTIONARY) {
			if (query.contains(cat)) return cat;
		}
		return null;
	}
	
	// 질의에서 지역명 추출
	public String extractRegion(String query) {
		if (query == null || query.isBlank()) return null;
		for (String reg : REGION_DICTIONARY) {
			if (query.contains(reg)) return reg;
		}
		return null;
	}
	
	// 질의에서 테마/상황 키워드 추출 (표준 키워드로 반환)
	// 예: "부산에 혼밥하기 좋은 국밥집" -> "혼자 식사하기 좋은" 반환
	public String extractKeyword(String query) {
		if (query == null || query.isBlank()) return null;

		for (Map.Entry<String, String> entry : THEME_SYNONYM_MAP.entrySet()) {
			if (query.contains(entry.getKey())) {
				return entry.getValue(); // 실제 ES skeyword 필드에 매칭될 표준 키워드 반환
			}
		}
		return null;
	}
	
	// 카테고리/지역/키워드 필터 기반 리뷰 수 랭킹 집계
	// query: 사용자 질문, topN: 최대 추천 가게수
	// 1차 must 엄격 검색 -> 0건일 경우 2차 should 완화 검색
    public Map<Integer, Long> chatbotStoresByFilterAndRatingWithFallback(String query, int topN) {
    	// 사용자의 질문에서 지역과 카테고리 및 키워드를 추출
    	String detectedRegion = extractRegion(query);
		String detectedCategory = extractCategory(query);
		String detectedKeyword = extractKeyword(query);
    	
    	// 1단계: 지역 + 카테고리 + 키워드 셋 다 반드시 일치하는 엄격 쿼리 실행
        Map<Integer, Long> strictResult = executeReviewAggregation(detectedRegion, detectedCategory, detectedKeyword, query, true, topN);

        if (!strictResult.isEmpty()) {
            System.out.println("== [1차 엄격 일치(MUST) 검색 성공]: " + strictResult.size() + "건 발견 ==");
            return strictResult;
        }

        // 2단계: 결과가 0건이면 셋 중 하나라도 걸리는 완화(SHOULD) 쿼리로 폴백
        System.out.println("== [1차 결과 0건] -> [2차 완화(SHOULD) 검색으로 전환] ==");
        return executeReviewAggregation(detectedRegion, detectedCategory, detectedKeyword, query, false, topN);
    }

    // isStrict true면 must(반드시 둘 다 일치), false면 should(하나라도 일치)
    private Map<Integer, Long> executeReviewAggregation(String region, String category, String keyword, String rawQuery, boolean isStrict, int topN) {
    	Map<Integer, Long> storeReviewCountMap = new LinkedHashMap<>();

		try {
			BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
			boolQuery.filter(QueryBuilders.termQuery("sstatus", "OPEN"));

			BoolQueryBuilder conditionQuery = QueryBuilders.boolQuery();

			// 1. 지역 조건 매칭 (정제된 region 단어 사용)
			if (region != null && !region.isBlank()) {
				BoolQueryBuilder regionQuery = QueryBuilders.boolQuery()
						.should(QueryBuilders.prefixQuery("ssido.keyword", region))
						.should(QueryBuilders.prefixQuery("ssigungu.keyword", region))
						.should(QueryBuilders.matchQuery("saddr", region));
				
				if (isStrict) {
					conditionQuery.must(regionQuery);
					System.out.println("지역 조건: " + region);
				} else {
					conditionQuery.should(regionQuery.boost(3.0f));
				}
			}

			// 2. 카테고리 매칭 (정제된 category 단어 사용)
			if (category != null && !category.isBlank()) {
				BoolQueryBuilder categoryQuery = QueryBuilders.boolQuery()
						.should(QueryBuilders.matchQuery("scategory", category))
						.should(QueryBuilders.nestedQuery(
								"menu",
								QueryBuilders.matchQuery("menu.mnname", category),
								org.apache.lucene.search.join.ScoreMode.Max
						));

				if (isStrict) {
					conditionQuery.must(categoryQuery);
					System.out.println("카테고리 조건: " + category);
				} else {
					conditionQuery.should(categoryQuery.boost(2.0f));
				}
			}

			// 3. 키워드 매칭 (정제된 keyword 단어 사용)
			if (keyword != null && !keyword.isBlank()) {
				// matchQuery 대신 matchPhraseQuery 사용으로 완전문구 일치
				var keywordQuery = QueryBuilders.matchPhraseQuery("skeyword", keyword);
	
				if (isStrict) {
					conditionQuery.must(keywordQuery);
					System.out.println("키워드 조건: " + keyword);
				} else {
					conditionQuery.should(keywordQuery.boost(2.0f));
				}
			}

			// 만약 지역/카테고리/키워드가 셋 다 안 잡힌 일반 질문이면 원문 전체로 Nori 분석기 검색
			if ((region == null || region.isBlank()) && (category == null || category.isBlank()) && (keyword == null || keyword.isBlank())) {
				conditionQuery.should(QueryBuilders.matchQuery("sname", rawQuery).boost(2.0f));
				conditionQuery.should(QueryBuilders.matchQuery("scontent", rawQuery).boost(1.0f));
				conditionQuery.should(QueryBuilders.matchQuery("skeyword", rawQuery).boost(1.0f));
			}

			if (!isStrict) {
				conditionQuery.minimumShouldMatch(1);
			}

			boolQuery.must(conditionQuery);

			// 4. 하위 리뷰 nested 집계
			var nestedAgg = AggregationBuilders.nested("rating_count", "rating");

			// 리뷰 많은 순 정렬
			var termsAgg = AggregationBuilders.terms("by_store")
					.field("sno")
					.size(topN)
					.order(BucketOrder.aggregation("rating_count", false))
					.subAggregation(nestedAgg);

			SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
			sourceBuilder.size(0);
			sourceBuilder.query(boolQuery);
			sourceBuilder.aggregation(termsAgg);

			SearchRequest searchRequest = new SearchRequest("store");
			searchRequest.source(sourceBuilder);

			SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
			
			// 전체 필터 매칭 가게 수 (참고용)
            long totalMatches = (response.getHits().getTotalHits() != null) 
                                ? response.getHits().getTotalHits().value : 0L;

            Terms byStore = response.getAggregations().get("by_store");
            int bucketCount = (byStore != null) ? byStore.getBuckets().size() : 0;

            // [로그 1] 실제 집계된 가게 건수 출력 (size=0 이므로 hits 대신 buckets 확인)
            System.out.println("== [ES 리뷰 집계 (" + (isStrict ? "엄격" : "완화") + ")] 매칭 가게: " 
                               + totalMatches + "건 중 상위 집계: " + bucketCount + "건 ==");

			if (byStore != null) {
				for (Terms.Bucket bucket : byStore.getBuckets()) {
					int sno = bucket.getKeyAsNumber().intValue();
					Nested ratingNested = bucket.getAggregations().get("rating_count");
					long reviewCount = (ratingNested != null) ? ratingNested.getDocCount() : 0L;

					storeReviewCountMap.put(sno, reviewCount);
				}
			}
			
			// [로그 2] 최종 Map에 적재된 가게 수 출력
            System.out.println("== [ES 리뷰 집계 완료] 최종 반환 가게: " + storeReviewCountMap.size() + "건 ==");

		} catch (Exception e) {
			System.err.println("집계 쿼리 실행 실패 (isStrict=" + isStrict + "): " + e.getMessage());
			e.printStackTrace();
		}

		return storeReviewCountMap;
	}
	
	
    // 챗봇 자연어 질의 기반 백년가게 검색
	// query: 사용자 질문, size: 최대 추천 가게수
 	public List<StoreDTO> chatbotStoresSearch(String query, int size) {
 		List<StoreDTO> storeList = new ArrayList<>();
 		
 		if (query == null || query.isBlank()) {
 			return storeList;
 		}
 		
 		String searchKeyword = query.trim();
 		
 		try {
 			BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
 			
 			// 1. 영업 중인 가게 필수 필터
 			boolQuery.filter(QueryBuilders.termQuery("sstatus", "OPEN"));
 			
 			// 2-1. 지역명 감지 시 필수 필터(Filter)로 고정
 			String detectedRegion = extractRegion(searchKeyword);
 			if (detectedRegion != null) {
 				BoolQueryBuilder regionFilter = QueryBuilders.boolQuery()
 						.should(QueryBuilders.prefixQuery("ssido.keyword", detectedRegion))
 						.should(QueryBuilders.prefixQuery("ssigungu.keyword", detectedRegion))
 						.should(QueryBuilders.matchQuery("saddr", detectedRegion));
 				regionFilter.minimumShouldMatch(1);
 				
 				boolQuery.filter(regionFilter); // ⭐ 타 지역 가게 유입 원천 차단
 			}
 			
 			// 2-2. 키워드 감지 시 필수 필터로 고정
 			String detectedKeyword = extractKeyword(searchKeyword);
 			if (detectedKeyword != null) {
 				boolQuery.filter(QueryBuilders.matchPhraseQuery("skeyword", detectedKeyword));
 			}
 			
 			// 3. 내용 매칭 (상호, 메뉴, 카테고리, 소개글)
 			BoolQueryBuilder shouldQuery = QueryBuilders.boolQuery();
 			
 			// 대표 메뉴 매칭
 			shouldQuery.should(
 					QueryBuilders.nestedQuery(
 							"menu", 
 							QueryBuilders.matchQuery("menu.mnname", searchKeyword), 
 							org.apache.lucene.search.join.ScoreMode.Max
 					).boost(3.0f)
 			);
 			
 			// 상호명 매칭
 			shouldQuery.should(QueryBuilders.matchQuery("sname", searchKeyword).boost(3.5f));
 			
 			// 카테고리 매칭
 			shouldQuery.should(QueryBuilders.matchQuery("scategory", searchKeyword).boost(3.0f));
 			
 			// 만약 키워드가 감지되지 않은 일반 질의일 경우를 대비해 키워드 필드도 should에 유지
 			if (detectedKeyword == null) {
 				shouldQuery.should(QueryBuilders.matchQuery("skeyword", searchKeyword).boost(2.0f));
 			}
 			
 			// 상세 소개글 매칭
 			shouldQuery.should(QueryBuilders.matchQuery("scontent", searchKeyword).boost(4.0f));
 			
 			// 만약 지역이 감지되지 않은 일반 질의일 경우를 대비해 주소 필드도 should에 유지
 			if (detectedRegion == null) {
 				shouldQuery.should(QueryBuilders.matchQuery("saddr", searchKeyword).boost(2.0f));
 				shouldQuery.should(QueryBuilders.matchQuery("ssido", searchKeyword).boost(2.0f));
 				shouldQuery.should(QueryBuilders.matchQuery("ssigungu", searchKeyword).boost(2.0f));
 			}
 			
 			shouldQuery.minimumShouldMatch(1);
 			boolQuery.must(shouldQuery);
 			
 			// 4. 쿼리 빌드
 			SearchSourceBuilder sourceBuilder = new SearchSourceBuilder();
 			sourceBuilder.query(boolQuery);
 			sourceBuilder.size(size);
 						
 			SearchRequest request = new SearchRequest("store");
 			request.source(sourceBuilder);
 			
 			// 5. 실행 및 결과 매핑
 			SearchResponse response = client.search(request, RequestOptions.DEFAULT);
 			
 			// [로그 추가 1] ES에서 조건에 맞아 실제 추출된 건수
 			int esHitCount = response.getHits().getHits().length;
 			long totalMatches = response.getHits().getTotalHits().value; // 전체 일치 건수 (참고용)
 			System.out.println("== [챗봇 ES 검색] 질의: '" + searchKeyword + "' | ES 추출 건수: " + esHitCount + "건 (전체 매칭: " + totalMatches + "건) ==");
 			
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
 			
 			// [로그 추가 2] DB 조회까지 완료되어 LLM 프롬프트로 넘어갈 최종 가게 건수
 			System.out.println("== [챗봇 ES 검색] Oracle DB 연동 완료 최종 후보: " + storeList.size() + "건 ==");
 			
 		} catch (Exception e) {
 			System.err.println("챗봇 백년가게 검색 실패: " + e.getMessage());
 			e.printStackTrace();
 		}
 		
 		return storeList;
 	}
	
	
}
