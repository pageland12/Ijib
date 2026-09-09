<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
	
    <h3>비밀글입니다.</h3>
    <form name="passwordCheckForm" method="post" action="/guest/passwordCheck">
        <input type="hidden" name="bno" value="${bno}">
        <label>회원 비밀번호</label>
        <input type="password" name="mpasswd" required>
        <button type="submit"">확인</button>
    </form>
    <a href="/guest/boardList">목록</a>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>

