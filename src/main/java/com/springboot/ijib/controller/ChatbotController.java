package com.springboot.ijib.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.ijib.service.ChatbotService;

@Controller
public class ChatbotController {
	@Autowired
	private ChatbotService chatbotSevice;
	
	@RequestMapping("/chat/message")
	@ResponseBody
	public Map<String, Object> handleChatMessage(@RequestBody Map<String, String> request) {
		Map<String, Object> response = new HashMap<>();
		
		String userMessage = request.get("message");
		if (userMessage == null || userMessage.isBlank()) {
			response.put("success", false);
			response.put("reply", "질문 내용을 입력해 주세요.");
			return response;
		}
		
		try {
			// Java 규칙 라우팅 + ES 검색 + Mock 답변 처리
			String reply = chatbotSevice.processChat(userMessage);
			response.put("success", true);
			response.put("reply", reply);
		} catch(Exception e) {
			response.put("success", false);
            response.put("reply", "답변 생성 중 문제가 발생했습니다: " + e.getMessage());
		}
		
		return response;
	}
}
