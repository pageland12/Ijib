<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="member-page">
        <%-- 공통 사이드바 include --%>
        <%@ include file="memberSidebar.jsp" %>

        <main class="member-content">
            <div class="content-title-area">
                <h2>내 계정 <span>MY ACCOUNT</span></h2>
            </div>

            <section class="account-list-section">
                <h3>계정 관리</h3>

                <a href="<c:url value='/member/passwordCheckForm?mode=update'/>" class="account-list-item">
                    <div>
                        <strong>회원정보 수정</strong>
                        <p>회원님의 기본 정보와 계정 정보를 수정할 수 있습니다.</p>
                    </div>
                    <span>›</span>
                </a>

                <a href="<c:url value='/member/passwordCheckForm?mode=delete'/>" class="account-list-item account-delete">
                    <div>
                        <strong>회원탈퇴</strong>
                        <p>회원 탈퇴를 진행합니다.</p>
                    </div>
                    <span>›</span>
                </a>
            </section>

            <section class="account-list-section">
                <h3>나의 활동</h3>

                <a href="<c:url value='/member/bookmarkList'/>" class="account-list-item">
                    <div>
                        <strong>북마크</strong>
                        <p>북마크한 맛집을 확인할 수 있습니다.</p>
                    </div>
                    <span>›</span>
                </a>

                <a href="<c:url value='/member/myBoard'/>" class="account-list-item">
                    <div>
                        <strong>나의 게시글 · 맛집 평가 내역</strong>
                        <p>작성한 게시글과 맛집 평가를 확인할 수 있습니다.</p>
                    </div>
                    <span>›</span>
                </a>

                <a href="<c:url value='/member/myPass'/>" class="account-list-item">
                    <div>
                        <strong>나의 구독권</strong>
                        <p>현재 이용 중인 구독권 정보를 확인할 수 있습니다.</p>
                    </div>
                    <span>›</span>
                </a>

                <a href="<c:url value='/member/myOrder'/>" class="account-list-item">
                    <div>
                        <strong>최근 결제 내역</strong>
                        <p>결제한 구독권의 주문 내역을 확인할 수 있습니다.</p>
                    </div>
                    <span>›</span>
                </a>
            </section>
        </main>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>