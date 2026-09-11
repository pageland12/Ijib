<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/payStyle.css">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <main class="pay-container receipt-container">
        <div class="receipt-header">
            <div class="receipt-icon">✓</div>
            <h2>주문이 정상적으로 완료되었습니다!</h2>
            <p>소중한 주문 감사드립니다.</p>
        </div>

        <hr class="receipt-divider">
        
        <p class="receipt-row">
            <span>주문 번호 :</span>
            <strong>${paymentId}</strong>
        </p>

        <hr class="receipt-divider">

        <div class="receipt-actions">
            <a href="/main" class="btn-receipt secondary">홈으로 이동</a>
            <a href="/member/myOrder" class="btn-receipt primary">주문내역 확인</a>
        </div>
    </main>

	<br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>