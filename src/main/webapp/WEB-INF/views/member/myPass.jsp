<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 조회</title>
</head>
<body>
	<h2>구독권 정보</h2>
	
	<c:choose>
		<c:when test="${empty start and empty end}">
			정기권이 없습니다.
		</c:when>
		<c:when test="${not empty start and not empty end}">
			<p>
				정기 구독권
			</p>
			<table border="1">
				<tr>
					<th>시작일</th>
					<th>만료일</th>
				</tr>
				<tr>
					<td>${start}</td>
					<td>${end}</td>
				</tr>
			</table>
		</c:when>
	</c:choose>
	
</body>
</html>