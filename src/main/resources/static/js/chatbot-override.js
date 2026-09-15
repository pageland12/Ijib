(function () {
    // 원본 appendMessage가 정의된 뒤 실행되도록 약간 지연
    function overrideAppendMessage() {
        if (typeof window.appendMessage !== "function") {
            // 아직 원본 함수가 로드되지 않았으면 다음 틱에 재시도
            setTimeout(overrideAppendMessage, 50);
            return;
        }

        window.appendMessage = function (sender, text) {
            const messagesBox = document.getElementById("chatbot-messages");
            const loading = document.getElementById("chatbot-loading");

            const msgDiv = document.createElement("div");
            msgDiv.classList.add("chat-bubble-row");

            const bubble = document.createElement("div");
            bubble.classList.add("chat-bubble");

            const contentSpan = document.createElement("span");
            contentSpan.classList.add("chat-bubble-content");

            if (sender === "사용자") {
                msgDiv.classList.add("chat-row-user");
                bubble.classList.add("chat-bubble-user");
                contentSpan.innerText = text; // XSS 방지: 사용자 입력은 innerText 유지
            } else if (sender === "챗봇") {
                msgDiv.classList.add("chat-row-bot");
                bubble.classList.add("chat-bubble-bot");

                const avatar = document.createElement("div");
                avatar.classList.add("chat-avatar");
                avatar.innerText = "💬";
                msgDiv.appendChild(avatar);

                contentSpan.innerHTML = text.replace(/\n/g, "<br>"); // 원본 로직 유지
            } else {
                // 오류 / 시스템 메시지
                msgDiv.classList.add("chat-row-system");
                bubble.classList.add("chat-bubble-system");
                contentSpan.innerText = text;
            }

            bubble.appendChild(contentSpan);
            msgDiv.appendChild(bubble);

            messagesBox.insertBefore(msgDiv, loading);
            scrollChatToBottom();
        };
    }

    overrideAppendMessage();
})();