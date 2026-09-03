<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 관리 페이지</title>
</head>
<body>
	<h3>구독권 관리 페이지</h3>
	<table border="1">
		<tr>
			<th>번호</th>
			<th>이미지</th>
			<th>상품명</th>
		</tr>
	<c:forEach var="pass" items="${pass}">
        <tr>
        	<td>${pass.pno}</td>
            <td><a href="/admin/passView?pno=${pass.pno}"><img src="/images/${pass.pimg}" width="150"></a></td>
            <td><a href="/admin/passView?pno=${pass.pno}">${pass.pname}</a></td>
        </tr>
    </c:forEach>
	</table>	
</body>
</html>