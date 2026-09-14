<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 확인</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/form.css'/>">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <!-- 마이페이지 공통 레이아웃 구조 -->
    <div class="member-page">

        <!-- 마이페이지 사이드바 인클루드 -->
        <jsp:include page="/WEB-INF/views/member/memberSidebar.jsp" />

        <main class="member-content">
            <div class="content-title-area">
                <h2>비밀번호 확인</h2>
            </div>

			<div class="password-wrapper" style="min-height: auto; background: none; padding: 20px 0; justify-content: flex-start;">
			    <div class="password-card" style="margin: 0; width: 100%; max-width: 480px;">
                    <form name="passwordCheckForm" method="post" action="<c:url value='/member/passwordCheck'/>">
                        <input type="hidden" name="mode" value="${mode}">

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
                            <button type="button" class="password-cancel" onclick="history.back()">취소</button>
                        </div>
                    </form>

                    <!-- 에러 메시지 표시 영역 -->
                    <c:if test="${not empty msg}">
                        <script>
                            alert("${msg}");
                        </script>
                    </c:if>
                </div>
            </div>
        </main>

    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>