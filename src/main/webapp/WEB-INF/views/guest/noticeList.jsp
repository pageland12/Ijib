<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 목록</title>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
    
	<table border=1 width=400>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
			</tr>
		<c:forEach var="list" items="${list}">
			<tr>
				<td>${list.nno}</td>
				<td><a href="/guest/noticeView?nno=${list.nno}">${list.ntitle}</a></td>
				<td>${list.mname}</td>
				<td><fmt:formatDate value="${list.ndate}" pattern="yyyy-MM-dd" /></td>
				<td>${list.nhit}</td>
			</tr>
		</c:forEach>
	</table>
	<sec:authorize access="hasRole('ADMIN')">
		<a href="/admin/noticeWriteForm">공지사항 작성</a>
	</sec:authorize>
	
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>