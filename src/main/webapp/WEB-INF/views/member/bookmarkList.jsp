<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>북마크 목록</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="member-page">
        <%@ include file="memberSidebar.jsp" %>

        <main class="member-content">
            <div class="content-title-area">
                <h2>북마크 목록 <span>BOOKMARK</span></h2>
            </div>

            <div class="store-grid">
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="bm" items="${list}">
                            <div class="store-card">
                                <%-- 1. 가게 이미지 (sfiles 매핑) --%>
                                <div class="card-img-wrap">
                                    <c:if test="${not empty bm.sfiles}">
                                        <img src="<c:url value='${bm.sfiles}'/>" alt="${bm.sname}" class="card-img" />
                                    </c:if>
                                    <c:if test="${empty bm.sfiles}">
                                        <div class="no-img">이미지 없음</div>
                                    </c:if>
                                </div>

                                <%-- 2. 카드 본문 정보 --%>
                                <div class="card-body">
                                    <div class="card-badge-wrap">
                                        <span class="badge badge-star">★★</span>
                                        <span class="badge badge-tag">추천 맛집</span>
                                    </div>

                                    <div class="card-header">
                                        <h3 class="store-name">${bm.sname}</h3>
                                        <a href="<c:url value='/member/bookmarkDelete?bmno=${bm.bmno}'/>" 
                                           class="bookmark-btn" 
                                           title="북마크 해제"
                                           onclick="return confirm('북마크 목록에서 삭제하시겠습니까?');">
                                            🔖
                                        </a>
                                    </div>

                                    <p class="store-category">#맛집 #추천식당</p>
                                    <p class="store-address">📍 ${bm.saddr}</p>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-list">
                            북마크한 맛집이 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>