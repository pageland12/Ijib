<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>북마크 목록</title>
</head>
<body>
	<h3>북마크 목록</h3>
	<table border="1">
		<tr>
			<th>가게사진</th>
			<th>상호명</th>
			<th>주소</th>
			<th>삭제</th>
		</tr>
	<c:forEach var="list" items="${list}">
		<tr>
			<th><a href="/guest/storeView?sno=${list.sno}"><img src="${fn:split(list.sfiles, ',')[0]}" width="150"></a></th>
			<th><a href="/guest/storeView?sno=${list.sno}">${list.sname}</a></th>
			<th>${list.saddr}</th>
			<th><a href="/member/bookmarkDelete?bmno=${list.bmno}&sno=${list.sno}" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a></th>
		</tr>
	</c:forEach>
	</table>
</body>
</html>