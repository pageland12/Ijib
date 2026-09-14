<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardList.css">
</head>
<body>

    <%@ include file="../guest/header.jsp" %>
    <c:set var="pageTitle" value="게시판" />

    <!-- 인클루드 대신 기존 상단 헤더 코드를 직접 삽입 -->
    <div class="board-page">
        <div class="board-header">
            <div class="board-header-left">
                <div class="board-title">
                    ${pageTitle}
                </div>
                <div class="board-tabs">
                    <a href="${pageContext.request.contextPath}/guest/noticeList"
                       class="board-tab ${pageTitle == '공지사항' ? 'active' : ''}">
                        공지사항
                    </a>
                    <a href="${pageContext.request.contextPath}/guest/boardList"
                       class="board-tab ${pageTitle == '게시판' ? 'active' : ''}">
                        게시판
                    </a>
                    <a href="${pageContext.request.contextPath}/guest/ratingList"
                       class="board-tab ${pageTitle == '후기' ? 'active' : ''}">
                        후기
                    </a>
                </div>
            </div>
        </div>
    </div>

    <main class="board-container">
        <div class="board-list">
            <c:forEach var="list" items="${list}">
                <div class="board-item">
                    <c:choose>
                        <c:when test="${list.bcategory == '비밀글'}">
                            <a href="${pageContext.request.contextPath}/guest/passwordCheckForm?bno=${list.bno}"
                               class="board-item-link">
                                <div class="board-item-content">
                                    <div class="board-item-title">
                                        <span class="secret-icon">🔒</span>
                                        비밀글입니다.
                                    </div>
                                    <div class="board-item-info">
                                        <span>${list.mname}</span>
                                        <span class="info-divider">|</span>
                                        <span><fmt:formatDate value="${list.bdate}" pattern="yyyy-MM-dd" /></span>
                                        <span class="info-divider">|</span>
                                        <span>조회 ${list.bhit}</span>
                                    </div>
                                </div>
                                <div class="board-arrow">›</div>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/guest/boardView?bno=${list.bno}"
                               class="board-item-link">
                                <div class="board-item-content">
                                    <div class="board-item-title">
                                        ${list.btitle}
                                    </div>
                                    <div class="board-item-info">
                                        <span>${list.mname}</span>
                                        <span class="info-divider">|</span>
                                        <span><fmt:formatDate value="${list.bdate}" pattern="yyyy-MM-dd" /></span>
                                        <span class="info-divider">|</span>
                                        <span>조회 ${list.bhit}</span>
                                    </div>
                                </div>
                                <div class="board-arrow">›</div>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>

            <c:if test="${empty list}">
                <div class="board-empty">
                    등록된 게시글이 없습니다.
                </div>
            </c:if>
        </div>

        <div class="board-button-area">
            <a href="${pageContext.request.contextPath}/board/boardWriteForm"
               class="board-write-button">
                게시글 작성
            </a>
        </div>

        <c:if test="${totalPage > 0}">
            <div class="pagination">
                <c:if test="${startPage > 1}">
                    <a href="${pageContext.request.contextPath}/guest/boardList?pageNum=${startPage - 1}"
                       class="page-arrow">&lt;</a>
                </c:if>

                <c:forEach var="page" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${page == pageNum}">
                            <span class="page-number active">${page}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/guest/boardList?pageNum=${page}"
                               class="page-number">${page}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${endPage < totalPage}">
                    <a href="${pageContext.request.contextPath}/guest/boardList?pageNum=${endPage + 1}"
                       class="page-arrow">&gt;</a>
                </c:if>
            </div>
        </c:if>
    </main>

    <%@ include file="../guest/footer.jsp" %>

</body>
</html>