<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
	<%@ include file="../admin/adminSearch.jsp" %>
	
	<h3>회원 목록</h3>
	<table border=1>
		<tr>
			<th>번호</th>
			<th>이메일</th>
			<th>이름</th>
			<th>성별</th>
			<th>나이</th>
			<th>주소</th>
			<th>전화번호</th>
			<th>권한</th>
			<th>상태</th>
			<th>가입일</th>
		</tr>
	<c:forEach var="list" items="${list}">
		<tr>
			<td>${list.mno}</td>
			<td><a href="/admin/memberView?mno=${list.mno}">${list.memail}</a></td>
			<td><a href="/admin/memberView?mno=${list.mno}">${list.mname}</a></td>
			<td>${list.mgender}</td>
			<td>${list.mage}</td>
			<td>${list.maddr}</td>
			<td>${list.mtel}</td>
			<td>${list.mauth}</td>
			<td>${list.mstatus}</td>
			<td><fmt:formatDate value="${list.mdate}" pattern="yy-MM-dd" /></td>
		</tr>
	</c:forEach>
	</table>
	<%@ include file="../guest/footer.jsp" %>
</body>
</html>