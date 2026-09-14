<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 확인</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="password-wrapper">
        <div class="password-card">
            <h3 class="password-title">비밀번호 확인</h3>
            <div class="password-card-line"></div>
            
            <form name="passwordCheckForm" method="post" action="<c:url value='/guest/passwordCheck'/>">
                <input type="hidden" name="bno" value="${bno}">
                
                <div class="password-input-group">
                    <label for="mpasswd" class="password-label">비밀번호</label>
                    <input type="password" 
                           id="mpasswd"
                           name="mpasswd" 
                           class="password-input" 
                           placeholder="비밀번호를 입력해 주세요" 
                           autofocus 
                           required>
                </div>

                <div class="password-button-group">
                    <button type="submit" class="password-confirm">전송</button>
                    <button type="button" class="password-cancel" onclick="location.href='<c:url value='/guest/boardList'/>'">취소</button>
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