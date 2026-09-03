<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 목록</title>
</head>
<body>
	<h3>음식점 목록</h3>
	<table border="1">
		<tr>
			<th>가게 사진</th>
			<th>상호명</th>
			<th>주소</th>
			<th>설명</th>
		</tr>
	<c:forEach var="list" items="${list}">
		<tr>
			<td><a href="/guest/storeView?sno=${list.sno}"><img src="${list.sfiles}"></a></td>
			<td><a href="/guest/storeView?sno=${list.sno}">${list.sname}</a></td>
			<td>${list.saddr}</td>
			<td>
			<c:choose>
		        <c:when test="${fn:length(list.scontent) > 20}">
		            ${fn:substring(list.scontent, 0, 20)}...
		        </c:when>
		        <c:otherwise>
		            ${list.scontent}
		        </c:otherwise>
		    </c:choose>
		    </td>
		</tr>
	</c:forEach>
	</table>
</body>
</html>