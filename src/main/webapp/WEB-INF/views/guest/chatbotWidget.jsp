<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div id="chatbot-wrapper" style="position: fixed; bottom: 25px; right: 25px; z-index: 99999; text-align: left;">
    <button type="button" id="chatbot-toggle-btn" onclick="toggleChatbot()" 
            style="background-color: #2b3a4a; color: #fff; padding: 12px 18px; border-radius: 30px; border: 2px solid #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.3); font-size: 14px; font-weight: bold; cursor: pointer;">
        💬 챗봇 문의
    </button>

    <div id="chatbot-container" style="display: none; width: 320px; background: #fff; border: 2px solid #2b3a4a; border-radius: 8px; padding: 10px; margin-bottom: 10px; box-shadow: 0 8px 20px rgba(0,0,0,0.2);">
        <!-- 상단 바 -->
        <div>
            <h3>백년가게 AI 가이드</h3>
            <button type="button" onclick="toggleChatbot()">닫기</button>
        </div>

        <!-- 메시지 출력 영역 -->
        <div id="chatbot-messages" style="height: 300px; overflow-y: auto; border: 1px solid #ccc; padding: 10px;">
            <div class="msg-bot">
                <strong>[안내]</strong> 안녕하세요! 백년가게 추천 및 서비스 안내 챗봇입니다.<br>
                지역명(부산, 종로 등)이나 음식, 또는 구독/환불 관련 문의를 입력해 주세요.
            </div>
            <div id="chatbot-loading" style="display: none; color: gray;">
                답변을 생성하고 있습니다...
            </div>
        </div>

        <!-- 입력 폼 -->
        <div>
            <input type="text" id="chatbot-input" placeholder="메시지를 입력하세요..." onkeydown="handleChatbotEnter(event)" />
            <button type="button" id="chatbot-send-btn" onclick="sendChatbotMessage()">전송</button>
        </div>
    </div>
</div>

<script>
// 1. 챗봇 열기/닫기 토글
function toggleChatbot() {
    const container = document.getElementById("chatbot-container");
    const toggleBtn = document.getElementById("chatbot-toggle-btn");

    if (container.style.display === "none") {
        container.style.display = "block";
        toggleBtn.innerText = "챗봇 닫기";
        document.getElementById("chatbot-input").focus();
    } else {
        container.style.display = "none";
        toggleBtn.innerText = "챗봇 열기";
    }
}

// 2. 엔터키 감지
function handleChatbotEnter(e) {
    if (e.key === "Enter") {
        sendChatbotMessage();
    }
}

// 3. 메시지 전송 및 백엔드 통신
function sendChatbotMessage() {
    const input = document.getElementById("chatbot-input");
    const message = input.value.trim();
    if (!message) return;

    // 사용자 메시지 렌더링
    appendMessage("사용자", message);
    input.value = "";

    // 로딩 문구 활성화
    const loading = document.getElementById("chatbot-loading");
    loading.style.display = "block";
    scrollChatToBottom();

    // 백엔드 ChatbotController 호출
    fetch("/chat/message", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ message: message })
    })
    .then(res => res.json())
    .then(data => {
        loading.style.display = "none";
        if (data.success) {
            appendMessage("챗봇", data.reply);
        } else {
            appendMessage("오류", data.reply);
        }
    })
    .catch(err => {
        console.error("챗봇 통신 오류:", err);
        loading.style.display = "none";
        appendMessage("시스템", "서버 통신 중 오류가 발생했습니다.");
    })
    .finally(() => {
        scrollChatToBottom();
    });
}

// 4. 메시지 엘리먼트 추가
function appendMessage(sender, text) {
    const messagesBox = document.getElementById("chatbot-messages");
    const loading = document.getElementById("chatbot-loading");

    const msgDiv = document.createElement("div");
    msgDiv.style.margin = "8px 0";
    msgDiv.style.lineHeight = "1.5";

    const senderStrong = document.createElement("strong");
    senderStrong.innerText = "[" + sender + "] ";

    const contentSpan = document.createElement("span");
    
    if (sender === "챗봇") {
        // 백엔드에서 내려준 <a> 태그나 <br> 태그가 링크와 줄바꿈으로 동작하도록 innerHTML 적용
        // \n 줄바꿈 문자도 <br>로 치환해줍니다.
        contentSpan.innerHTML = text.replace(/\n/g, "<br>");
    } else {
        // 사용자 입력은 XSS 방지를 위해 순수 텍스트(innerText) 처리
        contentSpan.innerText = text;
    }

    msgDiv.appendChild(senderStrong);
    msgDiv.appendChild(contentSpan);

    messagesBox.insertBefore(msgDiv, loading);
    scrollChatToBottom();
}

// 5. 스크롤 최하단 이동
function scrollChatToBottom() {
    const messagesBox = document.getElementById("chatbot-messages");
    messagesBox.scrollTop = messagesBox.scrollHeight;
}
</script>