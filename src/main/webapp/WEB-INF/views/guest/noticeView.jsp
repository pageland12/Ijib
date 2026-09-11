<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이집어때 공지사항</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/noticeView.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardList.css">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    <jsp:include page="/WEB-INF/views/guest/boardSearch.jsp" />
    
    <main class="notice-container">
        <!-- 상단 타이틀 영역 -->
        <div class="notice-page-header">
            <span class="notice-badge">NOTICE</span>
            <h2 class="notice-page-title">이집어때 공지사항</h2>
        </div>

        <!-- 공지사항 상세 카드 -->
        <article class="notice-card">
            
            <!-- 1. 헤더 (제목 및 메타 정보) -->
            <header class="notice-header">
                <h1 class="notice-title">${view.ntitle}</h1>
                <div class="notice-meta">
                    <span class="meta-item writer">
                        <strong>작성자</strong> ${view.mname}
                    </span>
                    <span class="meta-divider">|</span>
                    <span class="meta-item date">
                        <fmt:formatDate value="${view.ndate}" pattern="yyyy-MM-dd HH:mm" />
                    </span>
                    <span class="meta-divider">|</span>
                    <span class="meta-item hit">
                        <strong>조회수</strong> ${view.nhit}
                    </span>
                </div>
            </header>

            <hr class="notice-divider">

            <!-- 2. 첨부 이미지 (본문 상단 배치) -->
            <c:if test="${not empty view.nfiles}">
                <div class="notice-image-wrap">
                    <img src="/images/${view.nfiles}" alt="공지사항 이미지">
                </div>
            </c:if>

            <!-- 3. 본문 내용 -->
            <div class="notice-content">
                ${view.ncontent}
            </div>

            <hr class="notice-divider">

            <!-- 4. 하단 버튼 영역 -->
            <footer class="notice-footer">
                <div class="left-btns">
                    <a href="/guest/noticeList" class="btn btn-list">목록</a>
                </div>
                
                <sec:authorize access="hasRole('ADMIN')">
                    <div class="right-btns">
                        <a href="/admin/noticeUpdateForm?nno=${view.nno}" class="btn btn-edit">수정</a>
                        <a href="/admin/noticeDelete?nno=${view.nno}" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                    </div>
                </sec:authorize>
            </footer>

        </article>
    </main>
	
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>