<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="password-wrapper">
        <div class="password-card">
            <h3 class="password-title">
                비밀번호 찾기 <span>FIND PASSWORD</span>
            </h3>
            <div class="password-card-line"></div>
            
            <!-- 1단계: 이메일 입력 및 전송 폼 -->
            <form method="post" action="<c:url value='/guest/sendAuthCode'/>">
                <div class="password-input-group">
                    <label for="memail" class="password-label">이메일</label>
                    <input type="email" 
                           id="memail"
                           name="memail" 
                           class="password-input" 
                           placeholder="가입된 이메일을 입력해 주세요" 
                           value="${memail}"
                           autofocus 
                           required>
                </div>

                <div class="password-button-group">
                    <button type="submit" class="password-confirm">인증번호 전송</button>
                    <button type="button" class="password-cancel" onclick="location.href='<c:url value='/guest/loginForm'/>'">취소</button>
                </div>
            </form>

            <!-- 2단계: 메일이 전송된 경우에만 아래에 슥 나타나는 인증번호 입력 영역 -->
            <c:if test="${mailSent == true}">
                <div class="password-card-line" style="margin: 24px 0;"></div>
                
                <form method="post" action="<c:url value='/guest/verifyAuthCode'/>">
                    <div class="password-input-group" style="margin-bottom: 0;">
                        <label for="userCode" class="password-label">인증번호</label>
                        <input type="text" 
                               id="userCode"
                               name="userCode" 
                               class="password-input" 
                               placeholder="인증번호 6자리 입력" 
                               required>
                    </div>

                    <div class="password-button-group">
                        <button type="submit" class="password-confirm">인증 확인</button>
                    </div>
                </form>
            </c:if>

        </div>
    </div>
    
    <!-- 컨트롤러에서 넘겨준 경고/안내 메시지 팝업 -->
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>