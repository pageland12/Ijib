<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

        <!-- 오른쪽: 로그인/로그아웃 + 햄버거 -->
        <div class="header-right">
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
            </sec:authorize>
            <li class="menu-divider"></li>
            <li><a href="/guest/storeList">전체 식당</a></li>
            <li><a href="/member/bookmarkList">북마크</a></li>
            <li><a href="/guest/boardList">게시판</a></li>
            <li><a href="/guest/ratingList">후기 게시판</a></li>
            <li><a href="/guest/passList">구독권 구매</a></li>
            <li><a href="/main">홈으로</a></li>
        </ul>
    </div>
</header>
</body>
</html>