<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 완료</title>
</style>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
	<h2>주문이 정상적으로 완료되었습니다!</h2>
    <p>
        소중한 주문 감사드립니다.
    </p>
	
	<p>
	    <span>주문 번호 :</span>
	    <strong>${paymentId}</strong>
	</p>

    <a href="/main">홈으로 이동</a>
    <a href="/member/myOrder">주문내역 확인</a>

	<br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>