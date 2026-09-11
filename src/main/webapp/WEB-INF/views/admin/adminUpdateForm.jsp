<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
</head>
<body>
	<h3>회원 정보 수정</h3>
	
	<form name="adminUpdate" method="post" action="/admin/adminUpdate">
	<input type="hidden" name="mno" value="${update.mno}">
		<table border="1">
			<tr>
				<th>회원번호</th>
				<td>${update.mno}</td>
			</tr>
			<tr>
				<th>이메일</th>
				<td>${update.memail}</td>
			</tr>
			<tr>
				<th>이름</th>
				<td>${update.mname}</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>${update.mgender}</td>
			</tr>
			<tr>
				<th>나이</th>
				<td>${update.mage}</td>
			</tr>
			<tr>
				<th>주소</th>
				<td>${update.maddr}</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td>${update.mtel}</td>
			</tr>
			<tr>
				<th>계좌정보</th>
				<td>${update.maccount}</td>
			</tr>
			<tr>
				<th>권한</th>
				<td>
					<select name="mauth">
	                    <option value="">----- 등급 선택 -----</option>
	                    <option value="NORMAL" ${update.mauth == 'NORMAL' ? 'selected' : ''}>NORMAL</option>
	                    <option value="SUBSCRIBER" ${update.mauth == 'SUBSCRIBER' ? 'selected' : ''}>SUBSCRIBER</option>
	                    <option value="ADMIN" ${update.mauth == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                    </select>
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
					<select name="mstatus">
						<option value="OPEN" ${update.mstatus == 'OPEN' ? 'selected' : ''}>활성화</option>
						<option value="INACTIVE" ${update.mstatus == 'INACTIVE' ? 'selected' : ''}>비활성화</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>가입일</th>
				<td><fmt:formatDate value="${update.mdate}" pattern="yy-MM-dd" /></td>
			</tr>
		</table>
		<input type="submit" value="수정">
		<input type="button" value="취소" onclick="history.back()">
	</form>
</body>
</html>