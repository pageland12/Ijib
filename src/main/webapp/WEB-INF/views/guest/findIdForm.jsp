<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/findID.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="find-wrapper">
        <div class="find-card">
            <h3 class="find-title">아이디 찾기 <span>FIND ID</span></h3>
            <div class="find-card-line"></div>
            
            <!-- 아이디 찾기 입력 폼 -->
            <form method="post" action="<c:url value='/guest/findId'/>">
                <div class="find-input-group">
                    <label for="mname" class="find-label">이름</label>
                    <input type="text" 
                           id="mname"
                           name="mname" 
                           value="${mname}" 
                           class="find-input"
                           placeholder="가입하신 이름을 입력해 주세요" 
                           required 
                           autofocus>
                </div>

                <div class="find-input-group">
                    <label for="mtel" class="find-label">전화번호</label>
                    <input type="text" 
                           id="mtel"
                           name="mtel" 
                           value="${mtel}" 
                           class="find-input"
                           placeholder="010-1234-1234 형식으로 입력" 
                           required>
                </div>

                <div class="find-button-group">
                    <button type="submit" class="find-btn-submit">아이디 찾기</button>
                    <button type="button" class="find-btn-cancel" onclick="location.href='<c:url value='/guest/loginForm'/>'">취소</button>
                </div>
            </form>

            <!-- 아이디를 찾았을 경우 결과를 보여주는 영역 -->
            <c:if test="${not empty foundId}">
                <div class="find-result-box">
                    <p style="color: #495057; font-size: 14px; margin: 0;">회원님의 이메일입니다.</p>
                    <div class="find-result-email">${foundId}</div>
                </div>
                <div style="margin-top: 15px;">
                    <button type="button" class="find-btn-submit" style="width: 100%;" onclick="location.href='<c:url value='/guest/loginForm'/>'">로그인하러 가기</button>
                </div>
            </c:if>
        </div>
    </div>
    
    <!-- 경고 메시지 팝업 -->
    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>