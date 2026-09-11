<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이집어때 게시판</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardView.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardList.css">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    <jsp:include page="/WEB-INF/views/guest/boardSearch.jsp" />
    
    <div class="board-wrapper">
        <div class="board-card">
            
            <!-- 상단 제목 영역 -->
            <div class="board-category">COMMUNITY</div>
            <h2 class="board-main-title">이집어때 게시판</h2>

            <!-- 게시글 제목 -->
            <h1 class="board-post-title">${view.btitle}</h1>

            <!-- 작성정보 (좌측 정렬) -->
            <div class="board-meta">
                <span><strong>작성자</strong> ${view.mname}</span>
                <span class="divider">|</span>
                <span><fmt:formatDate value="${view.bdate}" pattern="yyyy-MM-dd HH:mm" /></span>
                <span class="divider">|</span>
                <span><strong>조회수</strong> ${view.bhit}</span>
            </div>

            <!-- 상단 구분선 -->
            <hr class="board-line">

            <!-- 본문 내용 -->
            <div class="board-content">
                ${view.bcontent}
            </div>

            <!-- 하단 구분선 -->
            <hr class="board-line">

            <!-- 좌측 하단 목록 버튼 -->
            <div class="board-btn-wrap">
                <a href="/guest/boardList" class="btn-list">목록</a>
            </div>

        </div>
    </div>
	
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>