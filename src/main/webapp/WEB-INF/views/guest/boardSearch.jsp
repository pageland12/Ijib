<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<div class="board-page">

    <!-- 상단 흰색 영역 -->
    <div class="board-header">

        <!-- 왼쪽 제목 + 메뉴 -->
        <div class="board-header-left">

            <div class="board-title">
                ${pageTitle}
            </div>

            <div class="board-tabs">

                <!-- 공지사항 -->
                <a href="${pageContext.request.contextPath}/guest/noticeList"
                   class="board-tab ${pageTitle == '공지사항' ? 'active' : ''}">
                    공지사항
                </a>

                <!-- 게시판 -->
                <a href="${pageContext.request.contextPath}/guest/boardList"
                   class="board-tab ${pageTitle == '게시판' ? 'active' : ''}">
                    게시판
                </a>

                <!-- 후기 -->
                <a href="${pageContext.request.contextPath}/guest/ratingList"
                   class="board-tab ${pageTitle == '후기' ? 'active' : ''}">
                    후기
                </a>

            </div>

        </div>


        <!-- 세로 구분선 -->
        <div class="board-header-line"></div>


        <!-- 검색 -->
        <div class="board-search">

            <form action="${pageContext.request.contextPath}/guest/search"
                  method="get">

                <div class="search-box">

                    <!-- 돋보기 -->
                    <span class="search-icon">⌕</span>

                    <input type="text"
                           name="keyword"
                           value="${param.keyword}"
                           placeholder="프레스 센터 내에서 검색해보세요.">

                    <button type="submit">
                        검색
                    </button>

                </div>

            </form>

        </div>

    </div>

</div>