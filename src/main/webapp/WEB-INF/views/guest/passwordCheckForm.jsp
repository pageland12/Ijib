<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <h3>비밀글입니다.</h3>
    <form action="/guest/passwordCheck" method="post">
        <input type="hidden" name="bno" value="${bno}">
        <label>회원 비밀번호</label>
        <input type="password" name="mpasswd" required>
        <button type="submit">확인</button>
    </form>
    <a href="/guest/boardList">목록</a>
    
    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>