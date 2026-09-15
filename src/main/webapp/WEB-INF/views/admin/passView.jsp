<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 상세 정보</title>
<link rel="stylesheet" href="<c:url value='/css/memberView.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="view-wrapper">
        <div class="view-card">

            <div class="view-category">SUBSCRIPTION</div>
            <h3 class="view-title">구독권 상세 정보</h3>

            <div class="view-meta">
                <span><strong>번호</strong> ${view.pno}</span>
                <span class="divider">|</span>
                <span><strong>가격</strong> ${view.pprice}원</span>
                <span class="divider">|</span>
                <span><strong>기간</strong> ${view.pperiod}일</span>
            </div>

            <hr class="view-line">

            <div class="info-table">
                <div class="info-row">
                    <div class="info-label">이미지</div>
                    <div class="info-value">
                        <img src="/images/${view.pimg}" class="view-thumb">
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label">상품명</div>
                    <div class="info-value">${view.pname}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">가격</div>
                    <div class="info-value">${view.pprice}원</div>
                </div>
                <div class="info-row">
                    <div class="info-label">기간</div>
                    <div class="info-value">${view.pperiod}일</div>
                </div>
            </div>

            <div class="view-btn-wrap">
                <a href="/admin/passUpdateForm?pno=${view.pno}" class="btn-list">수정</a>
                <a href="/admin/passDelete?pno=${view.pno}" class="btn-delete-link"
                   onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                <a href="/admin/adminPassList" class="btn-list-outline">목록</a>
            </div>

        </div>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>