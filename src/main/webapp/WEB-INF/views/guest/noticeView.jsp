<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 상세</title>
</head>
<body>
	<table border=1 width=400>
		<tr>
			<th>제목</th>
			<td>${view.ntitle}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${view.mname}</td>
		</tr>
		<tr>
			<th>작성일</th>
			<td><fmt:formatDate value="${view.ndate}" pattern="yyyy-MM-dd HH:mm" /></td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${view.nhit}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${view.ncontent}</td>
		</tr>
		<tr>
			<th>이미지</th>
			<td><img src="/images/${view.nfiles}" alt="공지사항 이미지"></td>
		</tr>
	</table>
</body>
</html>