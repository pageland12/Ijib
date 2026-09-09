<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기목록</title>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
    
	<table border=1 width=400>
		<tr>
			<th>번호</th>
			<th>사진</th>
			<th>제목</th>
			<th>평점</th>
			<th>작성자</th>
			<th>작성일</th>
		</tr>
		<c:forEach var="list" items="${list}">
			<tr>
				<td>${list.rno}</td>
				<td>${list.sfiles}</td>
				<td>${list.rtitle}</td>
				<td>${list.rrate}</td>
				<td>${list.mname}</td>
				<td>${list.rdate}</td>
			</tr>
		</c:forEach>
	</table>
	<a href="/board/ratingWriteForm">후기 작성</a>
	
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>