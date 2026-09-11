<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeList.css">

<%@ include file="../guest/header.jsp" %>

<!-- 페이지네이션 5개씩 계산 로직 -->
<c:set var="pageBlock" value="5" />
<c:set var="currentPage" value="${empty page ? 1 : page}" />
<c:set var="startPage" value="${((currentPage - 1) / pageBlock) * pageBlock + 1}" />
<fmt:parseNumber var="startPage" integerOnly="true" value="${startPage}" />
<c:set var="endPage" value="${startPage + pageBlock - 1}" />
<c:if test="${endPage > totalPages}">
    <c:set var="endPage" value="${totalPages}" />
</c:if>

<div class="store-grid-wrap">

    <!-- 검색 영역 (탭 + 검색창 + 고급 검색) -->
    <%@ include file="../guest/headerSearch.jsp" %>

    <div class="section-title-wrap">
        <h2 class="section-title">'${keyword}' 검색 결과</h2>
        <div class="section-count">
            총 <span>${totalCount}</span>개의 식당
        </div>
    </div>

    <!-- 음식점 카드 그리드 -->
    <c:choose>
        <c:when test="${empty result}">
            <div style="text-align: center; padding: 60px 0; color: #999;">검색 결과가 없습니다.</div>
        </c:when>
        <c:otherwise>
            <div class="store-grid">
                <c:forEach var="store" items="${result}">
                    <a href="${pageContext.request.contextPath}/guest/storeView?sno=${store.sno}" class="store-card">
                        <div class="store-card-thumb-wrap">
                            <img src="${fn:split(store.sfiles, ',')[0]}" class="store-card-thumb" alt="${store.sname}">
                        </div>
                        <div class="store-card-body">
                            <h3 class="store-card-name">${store.sname}</h3>
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

    <!-- 5개 단위 페이징 (검색조건 유지하며 이동) -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:if test="${startPage > 1}">
                <button type="button" class="page-btn" onclick="goToPage(${startPage - 1})">&lsaquo;</button>
            </c:if>

            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <button type="button"
                        class="page-btn ${i == currentPage ? 'active' : ''}"
                        onclick="goToPage(${i})">${i}</button>
            </c:forEach>

            <c:if test="${endPage < totalPages}">
                <button type="button" class="page-btn" onclick="goToPage(${endPage + 1})">&rsaquo;</button>
            </c:if>
        </div>
    </c:if>

</div>

<script>
function goToPage(n) {
    var params = new URLSearchParams(window.location.search);
    params.set('page', n);
    window.location.search = params.toString();
}
</script>

<%@ include file="../guest/footer.jsp" %>