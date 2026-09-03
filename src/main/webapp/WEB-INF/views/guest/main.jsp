<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
		<a href="/guest/loginForm">로그인</a> <br>
		<a href="/guest/writeForm">회원가입</a> <br>
		<a href="/member/memberMain">나의 페이지</a> <br>
		
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>