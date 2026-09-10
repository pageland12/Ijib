<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/member.css">

<aside class="member-sidebar">
    <div class="sidebar-title">
    <a href="/member/memberMain">마이페이지</a>
    </div>

    <div class="member-info">
        <span class="member-name">
            <c:choose>
                <c:when test="${not empty view.mname}">${view.mname}</c:when>
                <c:otherwise><sec:authentication property="principal.username"/></c:otherwise>
            </c:choose>
        </span><span class="member-nim">님</span>
        <a href="<c:url value='/member/passwordCheckForm?mode=update'/>" class="account-link">
            계정 관리 <span>›</span>
        </a>
    </div>

    <section class="sidebar-section">
        <h3>구독 및 결제</h3>

        <a href="<c:url value='/member/myPass'/>" class="sidebar-menu-item">
            <span class="side-icon pass-icon"></span>
            <span class="menu-text">나의 구독권</span>
            <span class="menu-more">자세히 보기&nbsp; ›</span>
        </a>

        <a href="<c:url value='/member/bookmarkList'/>" class="sidebar-menu-item">
            <span class="side-icon bookmark-icon"></span>
            <span class="menu-text">북마크</span>
            <span class="menu-more">자세히 보기&nbsp; ›</span>
        </a>

        <a href="<c:url value='/member/myOrder'/>" class="sidebar-menu-item">
            <span class="side-icon payment-icon"></span>
            <span class="menu-text">최근 결제 내역</span>
            <span class="menu-more">자세히 보기&nbsp; ›</span>
        </a>
    </section>

    <section class="sidebar-section">
        <h3>게시글 관리</h3>

        <a href="<c:url value='/member/myBoard'/>" class="sidebar-menu-item">
            <span class="side-icon review-icon"></span>
            <span class="menu-text">후기 내역</span>
            <span class="menu-more">자세히 보기&nbsp; ›</span>
        </a>
    </section>
</aside>