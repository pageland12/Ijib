<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">
    <title>후기</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/boardList.css">

</head>

<body>


    <%@ include file="../guest/header.jsp" %>


    <c:set var="pageTitle" value="후기" />

    <jsp:include page="/WEB-INF/views/guest/boardSearch.jsp" />


    <main class="board-container">

        <div class="board-list">


            <c:forEach var="list" items="${list}">

                <div class="board-item review-item">

                    <div class="review-card">


                        <div class="review-store">

                            <span class="store-name">
                                ${list.sname}
                            </span>

                        </div>

                        <div class="board-item-title">
                            ${list.rtitle}
                        </div>


                        <div class="review-rating">

                            <span class="star">
                                ★
                            </span>

                            <span class="rating-number">
                                ${list.rrate}
                            </span>

                            <span class="rating-text">
                                / 5
                            </span>

                        </div>


                        <div class="board-item-info">

                            <span>
                                ${list.mname}
                            </span>

                            <span class="info-divider">
                                |
                            </span>

                            <span>
                                ${list.rdate}
                            </span>

                        </div>

                    </div>

                </div>

            </c:forEach>


            <c:if test="${empty list}">

                <div class="board-empty">
                    등록된 후기가 없습니다.
                </div>

            </c:if>

        </div>


        <c:if test="${totalPage > 0}">

            <div class="pagination">

                <c:if test="${startPage > 1}">

                    <a href="${pageContext.request.contextPath}/guest/ratingList?pageNum=${startPage - 1}"
                       class="page-arrow">

                        &lt;

                    </a>

                </c:if>

                <c:forEach
                    var="page"
                    begin="${startPage}"
                    end="${endPage}">

                    <c:choose>

                        <c:when test="${page == pageNum}">

                            <span class="page-number active">
                                ${page}
                            </span>

                        </c:when>

                        <c:otherwise>

                            <a href="${pageContext.request.contextPath}/guest/ratingList?pageNum=${page}"
                               class="page-number">

                                ${page}

                            </a>

                        </c:otherwise>

                    </c:choose>

                </c:forEach>

                <c:if test="${endPage < totalPage}">

                    <a href="${pageContext.request.contextPath}/guest/ratingList?pageNum=${endPage + 1}"
                       class="page-arrow">

                        &gt;

                    </a>

                </c:if>


            </div>
      </c:if>

    </main>

    <%@ include file="../guest/footer.jsp" %>


</body>

</html>