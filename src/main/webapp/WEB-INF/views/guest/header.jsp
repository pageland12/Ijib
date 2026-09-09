<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.springboot.ijib.dto.MemberDTO" %>
<link rel="stylesheet" href="/css/header.css">
<script src="/js/header.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
	<style>
		.main-header {
		    height: 80px;           /* 헤더 높이를 넉넉하게 */
		    display: flex;
		    align-items: center;    /* 세로 중앙 정렬 */
		    padding: 0 20px;        /* 좌우 여백은 필요한 만큼만 */
		}
		
		.header-logo {
		    display: flex;
		    align-items: center;
		    height: 100%;
		}
		
		.header-logo .logo-img {
		    height: 64px;    /* 40px → 64px로 키움. 필요하면 더 키워도 됨 */
		    width: auto;
		    max-height: 90%; /* 헤더 높이를 넘지 않게 안전장치 */
		    display: block;
		}
	</style>
</head>
<body>
		<%
		    // 로그인 여부 및 권한 체크
		    MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
		    boolean isLoggedIn = (loginMember != null);
		    boolean isAdmin = isLoggedIn && "ADMIN".equals(loginMember.getMauth());
		%>
	
<header class="main-header">

    <div class="header-inner">

        <!-- 로고 -->
        <a href="/" class="header-logo">
		    <img src="/assets/logo.png" alt="IJIB-EOTTAE" class="logo-img">
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
            <% if (!isLoggedIn) { %>
            <li>
                <a href="/loginForm">로그인</a>
            </li>
            <li>
                <a href="/guest/writeForm">회원가입</a>
            </li>
            <% } else { %>
            <li>
                <a href="/logout">로그아웃</a>
            </li>
            <% } %>
            <li>
                <a href="/guest/noticeList">공지사항</a>
            </li>
            <% if (isLoggedIn) { %>
                <% if (isAdmin) { %>
            <li>
                <a href="/member/memberMain">관리자 페이지</a>
            </li>
                <% } else { %>
            <li>
                <a href="/member/memberMain">마이페이지</a>
            </li>
                <% } %>
            <% } %>
            <li class="menu-divider"></li>
            <li>
                <a href="/guest/storeList">전체 식당</a>
            </li>
            <li>
                <a href="/guest/boardList">게시판</a>
            </li>
            <li>
                <a href="/guest/ratingList">후기 게시판</a>
            </li>
            <li>
                <a href="/guest/passList">구독권 구매</a>
            </li>
            <li>
                <a href="/guest/main">홈으로</a>
            </li>
        </ul>
    </div>

</header>
</body>
</html>