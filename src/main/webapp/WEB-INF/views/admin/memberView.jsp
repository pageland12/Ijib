<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 정보</title>
<link rel="stylesheet" href="<c:url value='/css/memberView.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="view-wrapper">
        <div class="view-card">

            <div class="view-category">MEMBER</div>
            <h3 class="view-title">회원 상세 정보</h3>

            <div class="view-meta">
                <span><strong>회원번호</strong> ${view.mno}</span>
                <span class="divider">|</span>
                <span><strong>가입일</strong> <fmt:formatDate value="${view.mdate}" pattern="yy-MM-dd" /></span>
                <span class="divider">|</span>
                <span><strong>상태</strong> ${view.mstatus}</span>
            </div>

            <hr class="view-line">

            <div class="info-table">
                <div class="info-row">
                    <div class="info-label">이메일</div>
                    <div class="info-value">${view.memail}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">이름</div>
                    <div class="info-value">${view.mname}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">성별</div>
                    <div class="info-value">${view.mgender}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">나이</div>
                    <div class="info-value">${view.mage}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">주소</div>
                    <div class="info-value">${view.maddr}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">전화번호</div>
                    <div class="info-value">${view.mtel}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">계좌정보</div>
                    <div class="info-value">${view.maccount}</div>
                </div>
                <div class="info-row">
                    <div class="info-label">권한</div>
                    <div class="info-value">${view.mauth}</div>
                </div>
            </div>

            <div class="view-btn-wrap">
                <a href="/admin/adminUpdateForm?mno=${view.mno}" class="btn-list">수정</a>
                <a href="/admin/memberList" class="btn-list-outline">목록</a>
            </div>

        </div>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>