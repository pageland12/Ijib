<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <%@ include file="../guest/search.jsp" %>
    
	<table border=1 width=400>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
			</tr>
		<c:forEach var="list" items="${list}">
			<tr>
				<td>${list.bno}</td>
				<td>
					<c:choose>
						<%-- 카테고리가 '비밀글'인 경우 --%>
						<c:when test="${list.bcategory == '비밀글'}">
							<a href="/guest/passwordCheckForm?bno=${list.bno}">비밀글입니다.</a>
						</c:when>
						<%-- 추천글 또는 일반글인 경우 그대로 출력 --%>
						<c:otherwise>
							<a href="/guest/boardView?bno=${list.bno}">${list.btitle}</a>
						</c:otherwise>
					</c:choose>
				</td>
				<td>${list.mname}</td>
				<td><fmt:formatDate value="${list.bdate}" pattern="yyyy-MM-dd" /></td>
				<td>${list.bhit}</td>
			</tr>
		</c:forEach>
	</table>
	<a href="/main">메인</a>
	<a href="/board/boardWriteForm">게시글 작성</a>
	<%@ include file="../guest/footer.jsp" %>
</body>
</html>