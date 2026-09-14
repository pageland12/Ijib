<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 활동 내역</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/form.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/myBoard.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <!-- 마이페이지 공통 레이아웃 구조 -->
    <div class="member-page">

        <!-- 마이페이지 사이드바 인클루드 -->
        <jsp:include page="/WEB-INF/views/member/memberSidebar.jsp" />

        <main class="member-content">
            
            <!-- 게시글 섹션 -->
            <div class="mypage-section">
                <div class="content-title-area">
                    <h2>내가 쓴 게시글 <span>BOARD</span></h2>
                </div>
                <table class="mypage-table">
                    <thead>
                        <tr>
                            <th width="8%">번호</th>
                            <th width="32%">제목</th>
                            <th width="12%">작성자</th>
                            <th width="12%">작성일</th>
                            <th width="8%">조회수</th>
                            <th width="10%">카테고리</th>
                            <th width="10%">수정</th>
                            <th width="10%">삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty board}">
                                <tr>
                                    <td colspan="8" style="padding: 30px; color: #777;">작성한 게시글이 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="b" items="${board}">
                                    <tr>
                                        <td>${b.bno}</td>
                                        <td style="text-align: left; padding-left: 15px;">
                                            <a href="/guest/boardView?bno=${b.bno}">${b.btitle}</a>
                                        </td>
                                        <td>${b.mname}</td>
                                        <td><fmt:formatDate value="${b.bdate}" pattern="yyyy-MM-dd" /></td>
                                        <td>${b.bhit}</td>
                                        <td>${b.bcategory}</td>
                                        <td><a href="/board/boardUpdateForm?bno=${b.bno}" class="btn-action btn-edit">수정</a></td>
                                        <td><a href="/board/boardDelete?bno=${b.bno}" class="btn-action btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 후기 섹션 -->
            <div class="mypage-section">
                <div class="content-title-area">
                    <h2>내가 쓴 후기 <span>REVIEW</span></h2>
                </div>
                <table class="mypage-table">
                    <thead>
                        <tr>
                            <th width="8%">번호</th>
                            <th width="12%">사진</th>
                            <th width="30%">제목</th>
                            <th width="10%">평점</th>
                            <th width="10%">작성자</th>
                            <th width="12%">작성일</th>
                            <th width="9%">수정</th>
                            <th width="9%">삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty rating}">
                                <tr>
                                    <td colspan="8" style="padding: 30px; color: #777;">작성한 후기가 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${rating}">
                                    <tr>
                                        <td>${r.rno}</td>
                                        <td>
                                            <a href="/guest/storeView?sno=${r.sno}">
                                                <img src="${fn:split(r.sfiles, ',')[0]}" class="review-thumb">
                                            </a>
                                        </td>
                                        <td style="text-align: left; padding-left: 15px;">
                                            <a href="/guest/storeView?sno=${r.sno}">${r.rtitle}</a>
                                        </td>
                                        <td>★ ${r.rrate}</td>
                                        <td>${r.mname}</td>
                                        <td><fmt:formatDate value="${r.rdate}" pattern="yyyy-MM-dd" /></td>
                                        <td><a href="/board/ratingUpdateForm?rno=${r.rno}" class="btn-action btn-edit">수정</a></td>
                                        <td><a href="/board/ratingDelete?rno=${r.rno}" class="btn-action btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

        </main>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>