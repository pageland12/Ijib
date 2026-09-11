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

    <!-- 페이지네이션 5개씩 계산 -->
    <c:set var="pageBlock" value="5" />

    <c:set var="currentPage"
           value="${empty page ? 1 : page}" />

    <c:set var="startPage"
           value="${((currentPage - 1) / pageBlock) * pageBlock + 1}" />

    <fmt:parseNumber var="startPage"
                     integerOnly="true"
                     value="${startPage}" />

    <c:set var="endPage"
           value="${startPage + pageBlock - 1}" />

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

                        <a href="${pageContext.request.contextPath}/guest/storeView?sno=${store.sno}"
                           class="store-card">

                            <!-- 음식점 이미지 -->
                            <div class="store-card-thumb-wrap">

                                <img src="${fn:split(store.sfiles, ',')[0]}"
                                     class="store-card-thumb"
                                     alt="${store.sname}">

                            </div>


                            <!-- 음식점 정보 -->
                            <div class="store-card-body">

                                <div class="store-tag-row">

                                    <span class="tag-star">
									    ★ (<fmt:formatNumber value="${store.ratingAvg}" pattern="0.0" />)
									</span>

                                    <span class="tag-recommend">
                                        추천 맛집
                                    </span>

                                </div>


                                <h3 class="store-card-name">
                                    ${store.sname}
                                </h3>


                                <p class="store-card-hashtags">
                                    #맛집 #추천식당
                                </p>


                                <div class="store-card-addr">

                                    <span>📍</span>

                                    <span>
                                        ${store.saddr}
                                    </span>

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

                    <a href="${pageContext.request.contextPath}/guest/storeList?page=${startPage - 1}"
                       class="page-btn">
                        &lsaquo;
                    </a>

                </c:if>


                <!-- 페이지 번호 -->
                <c:forEach var="i"
                           begin="${startPage}"
                           end="${endPage}">

                    <a href="${pageContext.request.contextPath}/guest/storeList?page=${i}"
                       class="page-btn ${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>

                </c:forEach>


                <!-- 다음 5개 블록 -->
                <c:if test="${endPage < totalPages}">

                    <a href="${pageContext.request.contextPath}/guest/storeList?page=${endPage + 1}"
                       class="page-btn">
                        &rsaquo;
                    </a>

                </c:if>

            </div>

        </c:if>

    </div>


    <%@ include file="../guest/footer.jsp" %>

</body>
</html>