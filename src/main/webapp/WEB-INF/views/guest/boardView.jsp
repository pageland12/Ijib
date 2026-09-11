<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세</title>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
	<jsp:include page="/WEB-INF/views/guest/headerSearch.jsp" />
    
	<table border=1 width=400>
		<tr>
			<th>제목</th>
			<td>${view.btitle}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${view.mname}</td>
		</tr>
		<tr>
			<th>작성일</th>
			<td><fmt:formatDate value="${view.bdate}" pattern="yyyy-MM-dd HH:mm" /></td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${view.bhit}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${view.bcontent}</td>
		</tr>
	</table>
	<a href="/guest/boardList">목록</a>
	
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>