<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세</title>
</head>
<body>
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
	<a href="/board/boardUpdateForm?bno=${view.bno}">수정</a>
	<a href="/board/boardDelete?bno=${view.bno}">삭제</a>
	<a href="/guest/boardList">목록</a>
</body>
</html>