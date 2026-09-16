<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 목록</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/storeList.css">
</head>

<body>

    <%@ include file="../guest/header.jsp" %>

    <!-- 페이지네이션 계산 -->
    <c:set var="pageBlock" value="5" />
    <c:set var="currentPage" value="${empty page ? 1 : page}" />

    <!-- 정확한 startPage 정수 계산 -->
    <c:set var="startPage" value="${currentPage - ((currentPage - 1) % pageBlock)}" />
    <fmt:parseNumber var="startPage" integerOnly="true" value="${startPage}" />

    <c:set var="endPage" value="${startPage + pageBlock - 1}" />
    <c:if test="${endPage > totalPages}">
        <c:set var="endPage" value="${totalPages}" />
    </c:if>


    <div class="store-grid-wrap">

        <!-- 검색 영역 -->
        <jsp:include page="/WEB-INF/views/guest/headerSearch.jsp" />

        <br>

        <!-- 음식점 목록 -->
        <c:choose>

            <c:when test="${empty list}">
                <div style="text-align:center; padding:60px 0; color:#999;">
                    <c:choose>
                        <c:when test="${not empty nearbyMessage}">
                            ${nearbyMessage}
                        </c:when>
                        <c:otherwise>
                            등록된 음식점이 없습니다.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>

            <c:otherwise>
                <div class="store-grid">
                    <c:forEach var="store" items="${list}">
                        <a href="${pageContext.request.contextPath}/guest/storeView?sno=${store.sno}" class="store-card">
                            <!-- 음식점 이미지 -->
                            <div class="store-card-thumb-wrap">
                                <img src="${fn:split(store.sfiles, ',')[0]}" class="store-card-thumb" alt="${store.sname}" loading="lazy">
                            </div>

                            <!-- 음식점 정보 -->
                            <div class="store-card-body">
                                <div class="store-tag-row">
                                    <span class="tag-star">
                                        ★ (<fmt:formatNumber value="${store.ratingAvg}" pattern="0.0" />)
                                    </span>
                                    <span class="tag-recommend">${store.scategory}</span>
                                </div>

                                <h3 class="store-card-name">${store.sname}</h3>
                                <div class="store-card-hashtags">
								    <c:choose>
								        <c:when test="${not empty store.skeyword}">
								            <c:forEach var="tag" items="${fn:split(store.skeyword, ',')}" varStatus="status">
								                <c:if test="${status.index < 3}">
								                    <div class="hashtag-row">#${fn:trim(tag)}</div>
								                </c:if>
								            </c:forEach>
								        </c:when>
								        <c:otherwise>
								            <div class="hashtag-row">#이집어때 추천맛집</div>
								        </c:otherwise>
								    </c:choose>
								</div>
                                <div class="store-card-addr">
                                    <span>📍</span>
                                    <span>${store.saddr}</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>

        </c:choose>


        <!-- 페이지네이션 -->
        <c:if test="${totalPages > 1 && empty nearbyMessage}">

            <div class="pagination">

                <!-- 이전 5개 블록 -->
                <c:if test="${startPage > 1}">
                    <c:choose>
                        <c:when test="${isSubscriber}">
                            <a href="${pageContext.request.contextPath}/guest/storeList?page=${startPage - 1}&ssido=${ssido}&scategory=${scategory}" class="page-btn">&lsaquo;</a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);" onclick="alertSubscriberOnly()" class="page-btn">&lsaquo;</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>


                <!-- 페이지 번호 -->
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <%-- 1페이지는 누구나 자유롭게 이동 가능 --%>
                        <c:when test="${i == 1}">
                            <a href="${pageContext.request.contextPath}/guest/storeList?page=1&ssido=${ssido}&scategory=${scategory}"
                               class="page-btn ${i == currentPage ? 'active' : ''}">
                                ${i}
                            </a>
                        </c:when>

                        <%-- 2페이지 이상 --%>
                        <c:otherwise>
                            <c:choose>
                                <%-- 구독자/관리자 권한일 때 --%>
                                <c:when test="${isSubscriber}">
                                    <a href="${pageContext.request.contextPath}/guest/storeList?page=${i}&ssido=${ssido}&scategory=${scategory}"
                                       class="page-btn ${i == currentPage ? 'active' : ''}">
                                        ${i}
                                    </a>
                                </c:when>

                                <%-- 일반 회원 / 비로그인 일 때 --%>
                                <c:otherwise>
                                    <a href="javascript:void(0);" onclick="alertSubscriberOnly()" class="page-btn">
                                        ${i}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>


                <!-- 다음 5개 블록 -->
                <c:if test="${endPage < totalPages}">
                    <c:choose>
                        <c:when test="${isSubscriber}">
                            <a href="${pageContext.request.contextPath}/guest/storeList?page=${endPage + 1}&ssido=${ssido}&scategory=${scategory}" class="page-btn">&rsaquo;</a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0);" onclick="alertSubscriberOnly()" class="page-btn">&rsaquo;</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>

            </div>

        </c:if>

    </div>


    <%@ include file="../guest/footer.jsp" %>

    <script>
        function alertSubscriberOnly() {
            alert("더 많은 맛집 목록은 프리미엄 구독자 전용 혜택입니다.\n구독권 구매 페이지로 이동합니다.");
            location.href = "${pageContext.request.contextPath}/guest/passList";
        }
    </script>

</body>
</html>