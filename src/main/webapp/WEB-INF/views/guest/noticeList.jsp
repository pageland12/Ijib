<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec"
    uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>공지사항</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/boardList.css">

</head>

<body>

    <!-- 기존 헤더 유지 -->
    <%@ include file="../guest/header.jsp" %>


    <!-- 현재 페이지 제목 전달 -->
    <c:set var="pageTitle" value="공지사항" />


    <!-- 공통 검색/탭 영역 -->
    <jsp:include page="/WEB-INF/views/guest/boardSearch.jsp" />


    <!-- 게시판 내용 -->
    <main class="board-container">

        <div class="board-list">

            <c:forEach var="list" items="${list}">

                <div class="board-item">

                    <a href="${pageContext.request.contextPath}/guest/noticeView?nno=${list.nno}"
                       class="board-item-link">

                        <div class="board-item-content">

                            <div class="board-item-title">
                                ${list.ntitle}
                            </div>

                            <div class="board-item-info">

                                <span>
                                    ${list.mname}
                                </span>

                                <span class="info-divider">|</span>

                                <span>
                                    <fmt:formatDate
                                        value="${list.ndate}"
                                        pattern="yyyy-MM-dd" />
                                </span>

                                <span class="info-divider">|</span>

                                <span>
                                    조회 ${list.nhit}
                                </span>

                            </div>

                        </div>

                        <div class="board-arrow">
                            ›
                        </div>

                    </a>

                </div>

            </c:forEach>


            <!-- 글이 없을 경우 -->
            <c:if test="${empty list}">

                <div class="board-empty">
                    등록된 공지사항이 없습니다.
                </div>

            </c:if>

        </div>


        <!-- 관리자만 작성 버튼 -->
        <sec:authorize access="hasRole('ADMIN')">

            <div class="board-button-area">

                <a href="${pageContext.request.contextPath}/admin/noticeWriteForm"
                   class="board-write-button">
                    공지사항 작성
                </a>

            </div>

        </sec:authorize>

    </main>


    <!-- 기존 푸터 유지 -->
    <%@ include file="../guest/footer.jsp" %>

</body>
</html>