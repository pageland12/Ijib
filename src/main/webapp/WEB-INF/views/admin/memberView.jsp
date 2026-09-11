<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 정보</title>
</head>
<body>
	<h3>회원 상세 정보</h3>
	<table border="1">
		<tr>
			<th>회원번호</th>
			<td>${view.mno}</td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>${view.memail}</td>
		</tr>
		<tr>
			<th>이름</th>
			<td>${view.mname}</td>
		</tr>
		<tr>
			<th>성별</th>
			<td>${view.mgender}</td>
		</tr>
		<tr>
			<th>나이</th>
			<td>${view.mage}</td>
		</tr>
		<tr>
			<th>주소</th>
			<td>${view.maddr}</td>
		</tr>
		<tr>
			<th>전화번호</th>
			<td>${view.mtel}</td>
		</tr>
		<tr>
			<th>계좌정보</th>
			<td>${view.maccount}</td>
		</tr>
		<tr>
			<th>권한</th>
			<td>${view.mauth}</td>
		</tr>
		<tr>
			<th>상태</th>
			<td>${view.mstatus}</td>
		</tr>
		<tr>
			<th>가입일</th>
			<td><fmt:formatDate value="${view.mdate}" pattern="yy-MM-dd" /></td>
		</tr>
		<tr>
			<td colspan="2">
				<a href="/admin/adminUpdateForm?mno=${view.mno}">수정</a> / 
				<a href="/admin/memberList">목록</a>
			</td>
		</tr>
	</table>
</body>
</html>