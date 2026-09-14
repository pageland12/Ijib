<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="login-wrapper">
        <div class="login-card">
            <h2 class="login-title">로그인 <span>LOGIN</span></h2>
            <div class="login-card-line"></div>
            
            <form name="login" method="post" action="<c:url value='/j_spring_security_check'/>">
                <div class="login-input-row">
                    <div class="login-fields">
                        <input type="text" id="memail" name="memail" class="login-input" placeholder="이메일" autofocus required>
                        <input type="password" id="mpasswd" name="mpasswd" class="login-input" placeholder="비밀번호" required>
                    </div>
                    <button type="submit" class="login-submit-btn">로그인</button>
                </div>

                <div class="login-sub-links">
                    <a href="<c:url value='#'/>">아이디 찾기</a>
                    <span class="dot">•</span>
                    <a href="<c:url value='#'/>">비밀번호 찾기</a>
                    <span class="dot">•</span>
                    <a href="<c:url value='/guest/writeForm'/>">회원가입</a>
                </div>
            </form>
        </div>
    </div>

    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>