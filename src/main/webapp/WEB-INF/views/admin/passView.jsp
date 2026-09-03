<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 상세 정보</title>
</head>
<body>
	<h3>구독권 상세 페이지</h3>
	<table border="1">
		<tr>
            <th>번호</th>
            <td>${view.pno}</td>
        </tr>
        <tr>
            <th>이미지</th>
            <td><img src="/images/${view.pimg}" width="200"></td>
        </tr>
        <tr>
            <th>상품명</th>
            <td>${view.pname}</td>
        </tr>
        <tr>
            <th>가격</th>
            <td>${view.pprice}원</td>
        </tr>
        <tr>
            <th>기간</th>
            <td>${view.pperiod}일</td>
        </tr>
        <tr>
        	<td colspan="2">
        		<a href="/admin/passUpdateForm?pno=${view.pno}">수정</a> / 
        		<a href="/admin/passDelete?pno=${view.pno}">삭제</a> /
        		<a href="/admin/adminPassList">목록</a>  
        	</td>
        </tr>
	</table>
</body>
</html>