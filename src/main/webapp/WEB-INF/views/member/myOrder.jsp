<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역</title>
</head>
<body>
	<h2>주문 내역</h2>
	
	<table border="1">
		<tr>
			<th>주문 번호</th>
			<th>결제액</th>
			<th>결제 방법</th>
			<th>결제일</th>
			<th>상품 이름</th>
		</tr>
		<c:forEach var="order" items="${orders}" varStatus="status">
			<tr>
				<td>${order.ono}</td>
				<td>${order.oprice}원</td>
				<td>${order.opayment}</td>
				<td>${odates[status.index]}</td>
				<td>${order.pname}</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>