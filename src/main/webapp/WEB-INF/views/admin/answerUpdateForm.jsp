<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답변 수정</title>
</head>
<body>
    <h2>답변 수정</h2>
    <form action="/admin/answerUpdate" method="post">
        <input type="hidden" name="ano" value="${answer.ano}">
        <input type="hidden" name="bno" value="${answer.bno}">
        <textarea name="acontent">${answer.acontent}</textarea>
        <br>
        <button type="submit">수정</button>
        <a href="/guest/boardView?bno=${answer.bno}">취소</a>
    </form>
</body>
</html>