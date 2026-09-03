<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="login-wrapper">
        <div class="login-container">
            <h2 class="login-title">로그인</h2>
            
            <form name="login" method="post" action="/j_spring_security_check">
                <div class="form-group">
                    <label class="form-label" for="memail">이메일</label>
                    <input type="text" id="memail" name="memail" class="form-input" placeholder="이메일을 입력해 주세요" autofocus required>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="mpasswd">비밀번호</label>
                    <input type="password" id="mpasswd" name="mpasswd" class="form-input" placeholder="비밀번호를 입력해 주세요" required>
                </div>

                <div class="button-group">
                    <input type="submit" class="btn-submit" value="로그인">
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 컨트롤러에서 msg가 넘어왔을 때만 alert 띄우기 -->
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>