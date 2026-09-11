<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>나의 구독권</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="member-page">
        <%@ include file="memberSidebar.jsp" %>

        <main class="member-content">
            <div class="content-title-area">
                <h2>나의 구독권 <span>MY PASS</span></h2>
            </div>

            <div class="pass-container">
                <c:choose>
                    <c:when test="${not empty start && not empty end}">
                        <div class="pass-card active-pass">
                            <div class="pass-dates">
                                <div class="date-item">
                                    <span class="date-label">구독 시작일</span>
                                    <span class="date-val">${start}</span>
                                </div>
                                <div class="date-item">
                                    <span class="date-label">구독 만료일</span>
                                    <span class="date-val highlight">${end}</span>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="pass-card no-pass">
                            <div class="pass-icon-big">🎫</div>
                            <h3>현재 이용 중인 구독권이 없습니다</h3>
                            <p>구독권을 구매하시고 다양한 혜택을 누려보세요!</p>
                            <a href="<c:url value='/guest/passList'/>" class="btn-buy-pass">구독권 구매하러 가기 ›</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>