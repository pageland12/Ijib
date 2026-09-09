<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
	<div>
        <h2>반갑습니다.</h2>
    </div>
           
        <a href="/member/passwordCheckForm?mode=update">
		    <div>회원 정보 수정</div>
		</a>
		
		<a href="/member/passwordCheckForm?mode=delete">
		    <div>회원탈퇴</div>
		</a>
        
        <a href="/member/myBoard">
            <div>나의 게시글</div>
        </a>
        
        <a href="/member/myPass">
            <div>나의 구독권</div>
        </a>
        
        <a href="/member/myOrder">
            <div>주문 내역</div>
        </a>
        
        <a href="/main">
            <div class="card-name">메인 홈</div>
        </a>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>