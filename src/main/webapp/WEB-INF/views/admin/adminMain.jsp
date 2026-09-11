<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인페이지</title>
<link rel="stylesheet" href="/css/adminMain.css">
</head>
<body>

    <!-- 상단 헤더 포함 -->
    <%@ include file="../guest/header.jsp" %>

    <!-- 본문 영역 -->
    <main class="main-content">

        <div class="page-title">시스템 관리자 컨트롤 패널</div>

        <div class="admin-panel">
            <!-- 대칭형 3x2 그리드 영역 -->
            <div class="admin-grid">

                <a href="/admin/noticeWriteForm">
                    <div class="admin-card">공지사항 등록</div>
                </a>

                <a href="/admin/storeWriteForm">
                    <div class="admin-card">신규 매장 등록</div>
                </a>

                <a href="/admin/passWriteForm">
                    <div class="admin-card">신규 구독권 등록</div>
                </a>

                <a href="/admin/memberList">
                    <div class="admin-card">전체 회원 관리</div>
                </a>

                <a href="/admin/adminPassList">
                    <div class="admin-card">등록 구독권 관리</div>
                </a>
                
                <a href="/admin/statistics">
                    <div class="admin-card">통계 관리</div>
                </a>

                <a href="/main">
                    <div class="admin-card">메인 홈</div>
                </a>

            </div>
        </div>

    </main>

    <!-- 하단 푸터 포함 -->
    <%@ include file="../guest/footer.jsp" %>

</body>
</html>