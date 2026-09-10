<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>주문 / 결제</title>
    <!-- 포트원 V2 SDK 스크립트 -->
    <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
	<h2 class="pay-title">주문 / 결제</h2>
	
	<p>
		<span>주문 상품</span>
		<span>${prodName}</span>
	</p>
	
	<p>
		<span>주문자 이메일</span>
		<span>${buyerEmail}</span>
	</p>
	
	<p>
		<span>결제 금액</span>
		<span>${totalAmount}</span>
	</p>

    <p>
	    <button type="button" onclick="requestPayment()">
	        <fmt:formatNumber value="${totalAmount}" pattern="#,###" />원 결제하기
	    </button>
    </p>
	
    <script th:inline="javascript">
        async function requestPayment() {
            const orderName = '${prodName}';
            const totalAmount = Number('${totalAmount}')
            const buyerEmail = '${buyerEmail}';
            const buyerTel = '${buyerTel}';
            const buyerName = '${buyerName}';
            
            // 결제 방식, 주문 고유 번호 (고유값 생성)
            const payment = 'KAKAO_PAY';
            const paymentId = "ORD-" + new Date().getTime();

            try {
                // 포트원 V2 결제창 요청
                const response = await PortOne.requestPayment({
                    storeId: "store-30399cea-2dc5-47b1-8daa-39beeea2337e",          // Store ID 작성
                    channelKey: "channel-key-ac6ec6ee-8852-4f9b-9f4e-cc679167904a",  // Channel Key 작성
                    paymentId: paymentId,
                    orderName: orderName,
                    totalAmount: totalAmount,
                    currency: "CURRENCY_KRW",
                  	payMethod: "CARD",
                    customer: {
                        email: buyerEmail,
                        phoneNumber: buyerTel,
                        fullName: buyerName
                    }
                });

                // 결제 실패 또는 취소
                if (response.code != null) {
                    alert("결제 실패: " + response.message);
                    return;
                }

                // 결제 성공
                console.log("결제 성공! paymentId:", response.paymentId);
                fetch('/pay/paySuccess', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        paymentId: response.paymentId,      // 포트원 결제 고유 번호
                        pno: Number('${pno}') || 0,    		// 구독권 번호
                        totalAmount: totalAmount,  			// 실제로 결제한 금액
                        payment: payment,					// 결제 수단
                        buyerEmail: buyerEmail				// 결제 이메일
                    })
                })
                .then(res => res.json())
                .then(data => {
                	if (data.success) {
                        // 결제 및 DB 저장 성공 시 완료 페이지로 이동 (paymentId 전달)
                        location.href = "/pay/payResult?paymentId=" + response.paymentId;
                    } else {
                        alert("주문 처리 중 오류 발생: " + data.message);
                    }
                })
                .catch(err => {
                    console.error("서버 전송 중 에러 발생:", err);
                    alert("서버와 통신 중 오류가 발생했습니다.");
                });

            } catch (error) {
                console.error("결제 중 에러 발생:", error);
            }
        }
    </script>
    	
    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>