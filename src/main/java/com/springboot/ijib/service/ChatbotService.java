package com.springboot.ijib.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.springboot.ijib.dto.StoreDTO;

@Service
public class ChatbotService {
	@Autowired
	private ChatbotESService chatbotESService;
	
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
		
		// 2. 기본 라우팅: 백년가게 ES 검색 및 추천 질의 처리
		return handleStoreRecommendation(trimmed);
	}
	
	// 구독, 결제, 환불 의도 판별 (규칙 기반)
	private boolean isSubscriptionIntent(String query) {
		return 	query.contains("구독") || query.contains("결제") || 
				query.contains("환불") || query.contains("이용권") || 
				query.contains("멤버십") || query.contains("취소");
	}
	
	// 구독, 환불 안내 처리 (ES 검색 및 외부 LLM API 호출 없이 즉시 응답)
	private String handleSubscriptionAnswer(String query) {
        StringBuilder sb = new StringBuilder();
        sb.append("📋 **[구독권 및 결제/환불 규정 안내]**\n\n");
        sb.append("• **구독 혜택**: 백년가게 프리미엄 리뷰 및 멀티 검색 기능 열람\n");
        sb.append("• **환불 규정**: 전자상거래법에 의거하여 **결제일 기준 7일 이내** 신청 시 100% 환불 처리됩니다.\n");
        sb.append("• **환불 신청 방법**: [마이페이지] > [주문 내역]에서 해당 건의 '환불 신청' 버튼을 통해 즉시 처리 가능합니다.\n");
        sb.append("• **구독 연장권 보정**: 여러 달을 결제하셨더라도 중간 연장권 취소 시 잔여 기간은 자동으로 공백 없이 앞당겨집니다.\n\n");
        sb.append("추가로 궁금한 점이 있으시면 고객센터로 문의해 주세요!");
        return sb.toString();
    }
	
	// 가게 검색 및 추천 처리 (RAG 구조)
	private String handleStoreRecommendation(String query) {
		// ES에서 관련도 높은 가게 상위 3건 추출
		final int size = 3;
		List<StoreDTO> stores = chatbotESService.chatbotStoresSearch(query, size);
		
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
        // TODO: LLM API(Gemini 1.5 Flash 등) 연동
        return "";
    }
}
