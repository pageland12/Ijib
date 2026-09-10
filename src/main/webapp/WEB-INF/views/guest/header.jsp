<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="/css/header.css">
<script src="/js/header.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
</head>
<body>
<header class="main-header">
    <div class="header-inner">

        <!-- 로고 (중앙 고정) -->
        <a href="/" class="header-logo">
            <img src="/images/logo.png" alt="IJIB-EOTTAE" class="logo-img">
        </a>

        <!-- 오른쪽: 검색창 + 로그인/로그아웃 + 햄버거 -->
        <div class="header-right">
            
            <!-- [추가] 메인 페이지(/, /main)가 아닐 때만 검색창 표시 -->
            <c:set var="currentURI" value="${pageContext.request.requestURI}" />
            <c:if test="${currentURI != '/' && currentURI != '/main' && currentURI != '/WEB-INF/views/guest/main.jsp'}">
                <form action="/guest/storeSearch" method="get" class="header-search">
                    <button type="submit" class="search-btn" aria-label="검색">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                    </button>
                    <input type="text" name="keyword" value="${keyword}" class="search-input" placeholder="장소, 메뉴명, 식당명을 입력하세요." autocomplete="off">
                </form>
            </c:if>

            <sec:authorize access="!isAuthenticated()">
                <a href="/loginForm" class="auth-link">로그인</a>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <a href="/logout" class="auth-link">로그아웃</a>
            </sec:authorize>

            <button type="button" class="menu-button" id="menuButton">
                <span></span>
                <span></span>
                <span></span>
            </button>
        </div>

    </div>

    <!-- 드롭다운 메뉴 -->
    <div class="menu-dropdown" id="menuDropdown">
        <ul class="menu-list">
            <sec:authorize access="!isAuthenticated()">
                <li><a href="/guest/writeForm">회원가입</a></li>
            </sec:authorize>
            <li><a href="/guest/noticeList">공지사항</a></li>
            <sec:authorize access="isAuthenticated()">
                <sec:authorize access="hasRole('ADMIN')">
                    <li><a href="/admin/adminMain">관리자 페이지</a></li>
                </sec:authorize>
                <sec:authorize access="!hasRole('ADMIN')">
                    <li><a href="/member/memberMain">마이페이지</a></li>
                </sec:authorize>
                 <sec:authorize access="!hasRole('ADMIN')">
                    <li><a href="/member/bookmarkList">북마크</a></li>
                </sec:authorize>
            </sec:authorize>
            <li class="menu-divider"></li>
            <li>
                <a href="/guest/storeList">전체 식당</a>
            </li>
            <li>
                <a href="/guest/boardList">게시판</a>
            </li>
            <li>
                <a href="/guest/passList">구독권 구매</a>
            </li>
            <li>
                <a href="/main">홈으로</a>
            </li>
        </ul>
    </div>
</header>
</body>
</html>