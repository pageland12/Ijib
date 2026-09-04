<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 상세</title>
</head>
<body>
	<h3>음식점 상세</h3>
	음식점명 : ${view.sname}<br>
	이미지 : 
	<c:forEach var="image" items="${fn:split(view.sfiles, ',')}">
	    <img src="${image}" width="200">
	</c:forEach><br>
	카테고리 : ${view.scategory}<br>
	<p>메뉴</p>
	<table border="1">
	    <tr>
	        <th>메뉴명</th>
	        <th>가격</th>
	    </tr>
	    <c:forEach var="menu" items="${menu}">
	        <tr>
	            <td>${menu.mnname}</td>
	            <td>${menu.mnprice}</td>
	        </tr>
	    </c:forEach>
	</table>
	<br>
	키워드 : 
	<c:forEach var="keyword" items="${fn:split(view.skeyword, ',')}">
	    [${keyword}]
	</c:forEach><br>
	설명 : ${view.scontent}<br>
	주소 : ${view.saddr}<br>
	전화번호 : ${view.stel}<br>
	영업 정보 : ${view.sinfo}<br>
	주차 여부 : ${view.sparking}<br>
	영업 상태 : ${view.sstatus}<br>
	
	<a href="/member/bookmarkInsert?sno=${view.sno}">북마크</a> /
	<a href="/admin/storeUpdateForm?sno=${view.sno}">수정</a> / 
	<a href="/admin/storeDelete?sno=${view.sno}">삭제</a> / 
	<a href="/guest/storeList">목록</a>
	
	<c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>
</body>
</html>