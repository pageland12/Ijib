<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 게시글</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <!-- 마이페이지 공통 레이아웃 구조 -->
    <div class="member-page">

        <!-- 마이페이지 사이드바 인클루드 -->
        <jsp:include page="/WEB-INF/views/member/memberSidebar.jsp" />

        <main class="member-content">
            <h2>게시판</h2>
            <table border=1 width=400>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                    <th>비밀글 여부</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
                <c:forEach var="board" items="${board}">
                    <tr>
                        <td>${board.bno}</td>
                        <td><a href="/guest/boardView?bno=${board.bno}">${board.btitle}</a></td>
                        <td>${board.mname}</td>
                        <td><fmt:formatDate value="${board.bdate}" pattern="yyyy-MM-dd" /></td>
                        <td>${board.bhit}</td>
                        <td>${board.bcategory}</td>
                        <td><a href="/board/boardUpdateForm?bno=${board.bno}">수정</a></td>
                        <td><a href="/board/boardDelete?bno=${board.bno}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
                    </tr>
                </c:forEach>
            </table>

            <br>
            <h2>후기</h2>
            <table border=1 width=400>
                <tr>
                    <th>번호</th>
                    <th>사진</th>
                    <th>제목</th>
                    <th>평점</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>수정</th>
                    <th>삭제</th>
                </tr>
                <c:forEach var="rating" items="${rating}">
                    <tr>
                        <td>${rating.rno}</td>
                        <td><img src="/images/${rating.sfiles}"></td>
                        <td>${rating.rtitle}</td>
                        <td>${rating.rrate}</td>
                        <td>${rating.mname}</td>
                        <td><fmt:formatDate value="${rating.rdate}" pattern="yyyy-MM-dd" /></td>
                        <td><a href="/board/ratingUpdateForm?rno=${rating.rno}">수정</a></td>
                        <td><a href="/board/ratingDelete?rno=${rating.rno}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
                    </tr>
                </c:forEach>
            </table>
            <a href="/member/memberMain">마이페이지</a>
        </main>

    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>