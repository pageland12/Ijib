package com.springboot.ijib.service;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.springboot.ijib.dao.IStoreDAO;
import com.springboot.ijib.dto.StoreDTO;

@Service
public class ChatbotService {
	@Autowired
	private ChatbotESService chatbotESService;
	
	@Autowired
	private IStoreDAO sdao;
	
	// Google Gemini API 연동용 Key와 Url
	// Google Gemini API가 테스트 및 시연용으로 쓰기에 공짜라서 좋음
	@Value("${gemini.api.key}")
	private String geminiApiKey;

	@Value("${gemini.api.url}")
	private String geminiApiUrl;
	
	// application.properties에 chatbot.llm.enabled 설정 (기본값: false)
    @Value("${chatbot.llm.enabled:false}")
    private boolean llmEnabled;
	
	// 챗봇 질의 진입 (규칙 라우팅 -> 분기 처리)
	public String processChat(String userQuery) {
		if (userQuery == null || userQuery.isBlank()) {
			return "궁금하신 백년가게(지역, 음식)나 서비스 이용 관련 질문을 남겨주세요!";
		}
		
		String trimmed = userQuery.trim();
		
		// 1. 규칙 라우팅: 구독, 결제, 환불 관련 질의 감지
		if (isSubscriptionIntent(trimmed)) {
			return handleSubscriptionAnswer(trimmed);
		}
		
		// 2. 규칙 라우팅: 리뷰 수 관련 질의 감지
		if (isRatingIntent(trimmed)) {
			// "인기", "리뷰 많은", "식당" 등 수식어 제거 후 순수 타깃 단어(부산, 한식 등)만 추출
	        String filterKeyword = trimmed.replaceAll("(인기|리뷰|많은|유명한|추천|알려줘|식당|곳|맛집)", "").trim();
			return handleStoreRecommendation(trimmed, "rating");
		}
		
		// 3. 기본 라우팅: 백년가게 ES 검색 및 추천 질의 처리
		return handleStoreRecommendation(trimmed, "normal");
	}
	
	// 구독, 결제, 환불 의도 판별 (규칙 기반)
	// 랜덤으로 음식을 추천 의도 판별 (규칙 기반)
	private boolean isSubscriptionIntent(String query) {
		return 	query.contains("구독") || query.contains("결제") || 
				query.contains("환불") || query.contains("이용권") || 
				query.contains("멤버십") || query.contains("취소")	||
				(query.contains("뭐") && query.contains("먹")) ||
				(query.contains("무슨") && query.contains("먹")) || 
				query.contains("아무") ||
				(query.contains("메뉴") && query.contains("추천")) ||
				(query.contains("음식") && query.contains("추천"));
	}
	
	// 리뷰 수 관련 질의 의도 판별 (규칙 기반)
	private boolean isRatingIntent(String query) {
		return 	query.contains("리뷰") || 
				(query.contains("추천") && query.contains("수")) ||
				(query.contains("추천") && query.contains("많은")) ||
				query.contains("인기") ||
                query.contains("유명") ||
                query.contains("많은") ||
                query.contains("맛집");
	}
	
	// 구독, 환불 안내 처리 (ES 검색 및 외부 LLM API 호출 없이 즉시 응답)
	// 음식 아무거나 추천 등 랜덤으로 음식을 추천해달라고 하는 경우
	private String handleSubscriptionAnswer(String query) {
		StringBuilder sb = new StringBuilder();
		
		String searchKeyword = query.trim();
		if (searchKeyword.contains("혜택") || searchKeyword.contains("기능")) {
			sb.append("• 구독 혜택: 백년가게 프리미엄 리뷰 및 멀티 검색 기능 열람, 북마크 기능 사용 가능\n\n");
		} else if ((searchKeyword.contains("연장") && searchKeyword.contains("환불"))) {
			sb.append("• 구독 연장권 보정: 여러 달을 결제하셨더라도 중간 연장권 취소 시 잔여 기간은 자동으로 공백 없이 앞당겨집니다.\n\n");
		} else if (searchKeyword.contains("환불")) {
			sb.append("• 환불 규정: 전자상거래법에 의거하여 결제일 기준 7일 이내 신청 시 100% 환불 처리됩니다.\n");
	        sb.append("• 환불 신청 방법: [마이페이지] > [주문 내역]에서 해당 건의 '환불 신청' 버튼을 통해 즉시 처리 가능합니다.\n\n");
		} else if (searchKeyword.contains("구매") || (searchKeyword.contains("사는") && searchKeyword.contains("법")) || 
				  (searchKeyword.contains("구독") && searchKeyword.contains("사"))) {
			sb.append("• 구독권 구매 방법: [메뉴] > [구독권 구매]에서 원하시는 구독권 상품을 클릭해 구매 가능합니다.\n\n");
		} else if (searchKeyword.contains("연장")) {
			sb.append("• 구독권 연장 방법: 구독권이 있을 때, 구독권을 구매하면 자동으로 구독권 기간이 연장됩니다.\n\n");
		} else if ((searchKeyword.contains("음식") && searchKeyword.contains("추천")) || (searchKeyword.contains("메뉴") && searchKeyword.contains("추천")) ||
				   searchKeyword.contains("아무") || (searchKeyword.contains("뭐") && searchKeyword.contains("먹")) || 
				   (searchKeyword.contains("무슨") && searchKeyword.contains("먹"))) { 
			sb.append("• 뭘 먹을지 고민이 되신다면, 메인페이지에 있는 랜덤 카테고리 추천 기능을 사용해보세요!\n\n");
		} else {
			sb.append("📋 [구독권 및 결제/환불 규정 안내]\n\n");
	        sb.append("• 구독 혜택: 백년가게 프리미엄 리뷰 및 멀티 검색 기능 열람, 북마크 기능 사용 가능\n");
	        sb.append("• 구독권 구매 방법: [메뉴] > [구독권 구매]에서 원하시는 구독권 상품을 클릭해 구매 가능합니다.\n\n");
	        sb.append("• 구독권 연장 방법: 구독권이 있을 때, 구독권을 구매하면 자동으로 구독권 기간이 연장됩니다.\n\n");
	        sb.append("• 환불 규정: 전자상거래법에 의거하여 결제일 기준 7일 이내 신청 시 100% 환불 처리됩니다.\n");
	        sb.append("• 환불 신청 방법: [마이페이지] > [주문 내역]에서 해당 건의 '환불 신청' 버튼을 통해 즉시 처리 가능합니다.\n");
	        sb.append("• 구독 연장권 보정: 여러 달을 결제하셨더라도 중간 연장권 취소 시 잔여 기간은 자동으로 공백 없이 앞당겨집니다.\n\n");
		}
		
        sb.append("추가로 궁금한 점이 있으시면 고객센터로 문의해 주세요!");
        return sb.toString();
    }
	
	// 가게 검색 및 추천 처리 (RAG 구조)
	private String handleStoreRecommendation(String query, String type) {
		// ES에서 관련도 높은 가게 상위 10건 추출
		final int size = 10;
		List<StoreDTO> stores = new ArrayList<>();
		Map<Integer, Long> storesByRating = new LinkedHashMap<>();
		
		// type이 rating인 경우 (규칙 라우팅: 리뷰 수 관련 질의 감지)
		if ("rating".equals(type)) {
			storesByRating = chatbotESService.chatbotStoresByFilterAndRatingWithFallback(query, size);
			// 순서대로 Oracle DB에서 상세 정보 조회 후 리스트 적재
			for (Integer sno : storesByRating.keySet()) {
			    StoreDTO store = sdao.storeView(sno);
			    if (store != null) {
			        stores.add(store);
			    }
			}
		}
		
		// type이 normal인 경우 (기본 라우팅: 백년가게 ES 검색 및 추천 질의 처리)
		if ("normal".equals(type)) {
			stores = chatbotESService.chatbotStoresSearch(query, size);
		}
		
		// ES에서 가게가 추출되지 않았을 경우
		if (stores.isEmpty()) {
			return "질문하신 조건에 맞는 가게를 찾지 못했습니다.\n지역명(예: 서울, 부산 해운대)이나 음식 종류(예: 국밥, 냉면)를 포함해 다시 질문해 주시겠어요?";
		}
		
		// 2. Mock 모드: 토큰 소모 없이 실제 ES 검색 결과를 검증용 텍스트로 변환
		if (!llmEnabled) {
			StringBuilder sb = new StringBuilder();
		    sb.append("💡 <strong>[추천 백년가게 검색 결과]</strong><br>");
		    sb.append("'").append(query).append("' 관련 추천 가게입니다.<br><br>");

		    int rank = 1;
		    for (StoreDTO s : stores) {
		        // 기존 프로젝트의 상세 페이지 매핑 URL 형식에 맞게 sno를 연결합니다.
		        // 예: /store/storeView?sno= 또는 /store/detail?sno=
		        String detailUrl = "/guest/storeView?sno=" + s.getSno();

		        sb.append(rank++).append(". <strong>").append(s.getSname()).append("</strong> ");
		        
		        // 리뷰 수 관련 질의인 경우
		        if ("rating".equals(type)) {
		        	// 리뷰 수가 없는 경우 0을 입력
		        	long reviewCount = storesByRating.getOrDefault(s.getSno(), 0L);
		        	sb.append("   • 리뷰 수: ").append(reviewCount).append("<br>");
		        }
		        
		        // 상세페이지 새 창/현재 창 이동 링크 추가
		        sb.append("<a href='").append(detailUrl).append("' target='_blank' style='color:#0066cc; font-weight:bold; text-decoration:underline;'>[가게 상세보기 🔗]</a><br>");
		        
		        sb.append("   • 주소: ").append(s.getSaddr()).append("<br>");
		        
		        if (s.getScategory() != null && !s.getScategory().isBlank()) {
		            sb.append("   • 분류: ").append(s.getScategory()).append("<br>");
		        }
		        
		        if (s.getScontent() != null && !s.getScontent().isBlank()) {
		            String desc = s.getScontent().length() > 60 
		                          ? s.getScontent().substring(0, 60) + "..." 
		                          : s.getScontent();
		            sb.append("   • 소개: ").append(desc).append("<br>");
		        }
		        sb.append("<br>");
		    }
		    sb.append("<small style='color:gray;'>※ 링크를 클릭하면 해당 백년가게의 상세 정보 페이지로 이동합니다.</small><br>");
            sb.append("<small style='color:gray;'>*(현재 Mock 모드입니다. 추후 LLM API 연결 시 더 매끄럽고 친절한 추천 문장으로 다듬어집니다.)*</small>");
            return sb.toString();
		}
		
		// 3. 실제 운영 모드: 추후 LLM API(Gemini 등) 호출 메서드 연결
        return callLLMApi(query, stores);
	}
	
	// LLM API 호출부 (API 연동 단계에서 구현)
    private String callLLMApi(String query, List<StoreDTO> stores) {
        try {
        	RestTemplate restTemplate = new RestTemplate();
        	
        	// 1. 요청 URL 및 헤더
        	String requestUrl = geminiApiUrl + "?key=" + geminiApiKey;

        	HttpHeaders headers = new HttpHeaders();
        	headers.setContentType(MediaType.APPLICATION_JSON);

        	// 2. 검색된 가게 정보를 Context 텍스트로 결합
        	StringBuilder contextBuilder = new StringBuilder();
        	int idx = 1;
        	for (StoreDTO s : stores) {
        	    contextBuilder.append(idx++).append(". 가게명: ").append(s.getSname()).append("\n")
        	                  .append("   - 주소: ").append(s.getSaddr()).append("\n")
        	                  .append("   - 업종/분류: ").append(s.getScategory() != null ? s.getScategory() : "정보 없음").append("\n")
        	                  .append("   - 소개: ").append(s.getScontent() != null ? s.getScontent() : "정보 없음").append("\n")
        	                  .append("   - 상세 링크: /guest/storeView?sno=").append(s.getSno()).append("\n\n");
        	}

        	// 3. 지침과 컨텍스트, 유저 질문을 하나의 텍스트로 결합
        	String fullPrompt = 
        	    "[역할 및 지침]\n" +
        	    "너는 전국 백년가게 안내 전문 AI 도우미야.\n" +
        	    "아래 제공된 10개의 [검색된 백년가게 후보 목록] 중에서, 사용자의 질문 의도(분위기, 목적, 취향 등)에 가장 적합한 3곳을 엄선하여 추천해줘.\n" +
        	    "선정하지 않은 나머지 가게는 답변에 언급하지 마. 각 가게마다 왜 이 질문에 적합하다고 생각했는지 매력적인 추천 이유를 함께 덧붙여줘.\n" +
        	    "각 가게를 소개할 때 가게명 옆에 반드시 <a href='/guest/storeView?sno=번호' target='_blank' style='color:#0066cc; font-weight:bold;'>[상세보기 🔗]</a> 링크를 포함해줘.\n" +
        	    "줄바꿈은 <br> 태그를 쓰고 한국어로 다정하게 작성해.\n\n" +
        	    "[검색된 백년가게 정보]:\n" + contextBuilder.toString() + "\n" +
        	    "사용자 질문: " + query;

        	// 4. Gemini 표준 Body 구성 (가장 에러 없는 단일 contents 구조)
        	Map<String, Object> textPart = new HashMap<>();
        	textPart.put("text", fullPrompt);

        	List<Map<String, Object>> partsList = new ArrayList<>();
        	partsList.add(textPart);

        	Map<String, Object> contentMap = new HashMap<>();
        	contentMap.put("parts", partsList);

        	List<Map<String, Object>> contentsList = new ArrayList<>();
        	contentsList.add(contentMap);

        	Map<String, Object> reqBody = new HashMap<>();
        	reqBody.put("contents", contentsList);

        	HttpEntity<Map<String, Object>> entity = new HttpEntity<>(reqBody, headers);

        	// 5. 호출
        	ResponseEntity<Map> response = restTemplate.exchange(
        	    URI.create(requestUrl),
        	    HttpMethod.POST,
        	    entity,
        	    Map.class
        	);
            
        	// 6. 응답 파싱 (정밀 추출)
        	if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
        	    Map<String, Object> resBody = response.getBody();
        	    List<Map<String, Object>> candidates = (List<Map<String, Object>>) resBody.get("candidates");
        	    
        	    if (candidates != null && !candidates.isEmpty()) {
        	        Map<String, Object> candidate = candidates.get(0);
        	        Map<String, Object> resContentMap = (Map<String, Object>) candidate.get("content");
        	        
        	        if (resContentMap != null) {
        	            List<Map<String, Object>> parts = (List<Map<String, Object>>) resContentMap.get("parts");
        	            if (parts != null && !parts.isEmpty()) {
        	                String finalAnswer = null;
        	                
        	                // 뒤에서부터 순회하여 'thought' 플래그가 없는 순수 모델 답변 text를 채택
        	                for (int i = parts.size() - 1; i >= 0; i--) {
        	                    Map<String, Object> p = parts.get(i);
        	                    // 추론 파트(thought=true)가 아닌 일반 텍스트 파트 우선 선택
        	                    if (p.containsKey("text") && !Boolean.TRUE.equals(p.get("thought"))) {
        	                        finalAnswer = (String) p.get("text");
        	                        break;
        	                    }
        	                }
        	                
        	                // 혹시 플래그 구분이 없다면 맨 마지막 파트의 text를 반환
        	                if (finalAnswer == null && parts.get(parts.size() - 1).containsKey("text")) {
        	                    finalAnswer = (String) parts.get(parts.size() - 1).get("text");
        	                }
        	                
        	                if (finalAnswer != null && !finalAnswer.isBlank()) {
        	                    return finalAnswer;
        	                }
        	            }
        	        }
        	    }
        	}
        	
        } catch (Exception e) {
        	System.err.println("Gemini API 호출 중 오류 발생: " + e.getMessage());
        	e.printStackTrace();
        }
    	
        // 만약 Gemini 호출이 실패할 경우 Mock 모드 결과로 자연스럽게 폴백(Fallback)
	    return "AI 응답 생성 중 일시적인 지연이 발생했습니다.<br>" +
	           "대신 검색된 추천 가게 목록을 안내해 드립니다.<br><br>" +
	           buildFallbackStoreList(stores);
    }
    
    // 비상용 폴백 목록 생성 유틸
    private String buildFallbackStoreList(List<StoreDTO> stores) {
    	StringBuilder sb = new StringBuilder();
        int limit = Math.min(stores.size(), 3);
        for (int i = 0; i < limit; i++) {
            StoreDTO s = stores.get(i);
            sb.append("• <strong>").append(s.getSname()).append("</strong> ")
              .append("<a href='/guest/storeView?sno=").append(s.getSno()).append("' target='_blank'>[상세보기]</a><br>")
              .append("  주소: ").append(s.getSaddr()).append("<br><br>");
        }
        return sb.toString();
    }
}
