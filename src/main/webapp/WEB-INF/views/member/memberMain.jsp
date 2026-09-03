<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인페이지</title>
</head>
<body>
	<div>
        <h2>반갑습니다.</h2>
    </div>
    
    <div class="admin-grid">
        
        <a href="/member/memberUpdateForm">
            <div>회원수정</div>
        </a>
        
        <a href="/member/memberDelete">
            <div>회원탈퇴</div>
        </a>
        
        <a href="/member/boardList">
            <div>나의 게시글</div>
        </a>
        
        <a href="guest/main">
            <div class="card-name">메인 홈</div>
        </a>
        
    </div>
</body>
</html>