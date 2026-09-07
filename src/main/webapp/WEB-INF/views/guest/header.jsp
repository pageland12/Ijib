<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

        <!-- 로고 -->
        <a href="/" class="header-logo">
            <span>ＩＪＩＢ-ＥＯＴＴＡＥ</span>
            <small>SINCE 2026</small>
        </a>

        <!-- 햄버거 버튼 -->
        <button type="button" class="menu-button" id="menuButton">
            <span></span>
            <span></span>
            <span></span>
        </button>

    </div>


    <!-- 햄버거 클릭 시 나타나는 메뉴 -->
    <div class="menu-dropdown" id="menuDropdown">
        <ul class="menu-list">
            <li>
                <a href="/loginForm">로그인</a>
            </li>
            <li>
                <a href="#">매거진</a>
            </li>
            <li>
                <a href="#">커뮤니티</a>
            </li>
            <li>
                <a href="#">스토어</a>
            </li>
            <li>
                <a href="/member/memberMain">마이페이지</a>
            </li>
            <li class="menu-divider"></li>
            <li>
                <a href="#">블루리본 소개</a>
            </li>
            <li>
                <a href="#">식당 등록 안내</a>
            </li>
            <li class="menu-divider"></li>
            <li>
                <a href="#">아워홈 · 급이 다른 미식.</a>
            </li>
            <li>
                <a href="#">코카-콜라 레드리본 맛집</a>
            </li>
            <li>
                <a href="#">세종사랑맛집</a>
            </li>
            <li>
                <a href="#">HERE, HEART and TASTE</a>
            </li>
            <li>
                <a href="#">쿠팡이츠 × 블루리본</a>
            </li>
        </ul>
    </div>

</header>
</body>
</html>