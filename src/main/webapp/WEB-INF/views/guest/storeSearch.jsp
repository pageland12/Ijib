<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<title>검색 결과</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeList.css">

<!-- 버튼 커서 Pointer 적용 및 기본 스타일 보장 -->
<style>
.pagination .page-btn {
    cursor: pointer !important;
}
</style>

<%@ include file="../guest/header.jsp" %>

<!-- 페이지네이션 5개 단위 고정 계산 로직 (1~5페이지에서는 startPage=1 고정) -->
<c:set var="pageBlock" value="5" />
<c:set var="currentPage" value="${empty page ? 1 : page}" />

<!-- (currentPage - 1) / 5 의 내림 처리 후 * 5 + 1 -->
<c:set var="startPage" value="${currentPage - ((currentPage - 1) % pageBlock)}" />
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
            <div style="width: 100%; text-align: center; padding: 80px 0; color: #999; font-size: 15px;">
                검색 결과가 없습니다.
            </div>
        </c:when>
        <c:otherwise>
		    <div class="store-grid">
		        <c:forEach var="store" items="${result}">
		            <a href="${pageContext.request.contextPath}/guest/storeView?sno=${store.sno}" class="store-card">
		                <div class="store-card-thumb-wrap">
		                    <img src="${fn:split(store.sfiles, ',')[0]}" class="store-card-thumb" alt="${store.sname}">
		                </div>
		                <div class="store-card-body">
						    <!-- 별점 & 카테고리 -->
						    <div class="store-tag-row">
						        <span class="tag-star">
						            ★ (<fmt:formatNumber value="${store.ratingAvg}" pattern="0.0" />)
						        </span>
						        <span class="tag-recommend">${store.scategory}</span>
						    </div>
						
						    <!-- 가게 이름 -->
						    <h3 class="store-card-name">
						        ${store.sname}
						    </h3>
						
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
						
						    <!-- 주소 -->
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

    <!-- 5개 단위 페이징 (검색조건 유지하며 이동 / 구독자 권한 제어) -->
    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <%-- 이전 블록 버튼 --%>
            <c:if test="${startPage > 1}">
                <c:choose>
                    <c:when test="${isSubscriber}">
                        <button type="button" class="page-btn" onclick="goToPage(${startPage - 1})">&lsaquo;</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="page-btn" onclick="alertSubscriberOnly()">&lsaquo;</button>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <%-- 페이지 번호 버튼들 --%>
            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <c:choose>
                    <%-- 1페이지이거나 구독자/관리자인 경우 정상 이동 --%>
                    <c:when test="${i == 1 || isSubscriber}">
                        <button type="button"
                                class="page-btn ${i == currentPage ? 'active' : ''}"
                                onclick="goToPage(${i})">${i}</button>
                    </c:when>
                    <%-- 비구독자가 2페이지 이상을 누른 경우 --%>
                    <c:otherwise>
                        <button type="button"
                                class="page-btn"
                                onclick="alertSubscriberOnly()">${i}</button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <%-- 다음 블록 버튼 --%>
            <c:if test="${endPage < totalPages}">
                <c:choose>
                    <c:when test="${isSubscriber}">
                        <button type="button" class="page-btn" onclick="goToPage(${endPage + 1})">&rsaquo;</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="page-btn" onclick="alertSubscriberOnly()">&rsaquo;</button>
                    </c:otherwise>
                </c:choose>
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

function alertSubscriberOnly() {
    alert("더 많은 맛집 목록은 프리미엄 구독자 전용 혜택입니다.\n구독권 구매 페이지로 이동합니다.");
    location.href = "${pageContext.request.contextPath}/guest/passList";
}
</script>

<%@ include file="../guest/footer.jsp" %>