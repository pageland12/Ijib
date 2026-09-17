<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 비밀번호 변경</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="password-wrapper">
        <div class="password-card">
            <h3 class="password-title">
                비밀번호 변경 <span>RESET PASSWORD</span>
            </h3>
            <div class="password-card-line"></div>
            
            <form method="post" action="<c:url value='/guest/resetPassword'/>" onsubmit="return validatePassword();">
                <!-- 새 비밀번호 입력 -->
                <div class="password-input-group">
                    <label for="newPasswd" class="password-label">새 비밀번호</label>
                    <input type="password" 
                           id="newPasswd"
                           name="newPasswd" 
                           class="password-input" 
                           placeholder="새 비밀번호를 입력해 주세요" 
                           autofocus 
                           required>
                </div>

                <!-- 새 비밀번호 확인 입력 -->
                <div class="password-input-group">
                    <label for="newPasswdCheck" class="password-label">비밀번호 확인</label>
                    <input type="password" 
                           id="newPasswdCheck"
                           name="newPasswdCheck" 
                           class="password-input" 
                           placeholder="비밀번호를 한번 더 입력해 주세요" 
                           required>
                </div>

                <div class="password-button-group">
                    <button type="submit" class="password-confirm">변경 완료</button>
                    <button type="button" class="password-cancel" onclick="location.href='<c:url value='/loginForm'/>'">취소</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // 두 비밀번호가 일치하는지 간단히 체크하는 자바스크립트
        function validatePassword() {
            let p1 = document.getElementById("newPasswd")
            let p2 = document.getElementById("newPasswdCheck");
            
            if(p1.value != p2.value) {
                alert("새 비밀번호가 일치하지 않습니다.");
                p1.value = "";
                p2.value = "";
                p1.focus();
                return false;
            }
            return true;
        }
    </script>

    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>