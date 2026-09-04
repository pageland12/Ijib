<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <!-- 1. 로그인 안 되었을 때 (isAnonymous) -->
    <c:if test="${empty pageContext.request.userPrincipal}">
        <a href="/loginForm">로그인</a>
        <a href="/guest/writeForm">회원가입</a>
    </c:if>

    <!-- 2. 로그인 되었을 때 (isAuthenticated) -->
    <c:if test="${not empty pageContext.request.userPrincipal}">
        <span><b>${pageContext.request.userPrincipal.name}</b>님 환영합니다!</span>
        <a href="/logout">로그아웃</a>
        <a href="/member/memberMain">나의 페이지</a>
    </c:if>

    <br>
    
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>