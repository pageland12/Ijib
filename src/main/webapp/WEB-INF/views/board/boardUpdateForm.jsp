<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/boardWrite.css'/>">
<script src="/js/boardWU.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="member-page" style="justify-content: center;">
        <main class="member-content write-container">
            
            <div class="content-title-area">
                <h2>게시글 수정 <span>UPDATE</span></h2>
            </div>

            <form name="boardWriteForm" method="post" action="/board/boardUpdate">
                <input type="hidden" name="bno" value="${view.bno}">
                
                <table class="write-table">		
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="btitle" value="${view.btitle}" placeholder="제목을 입력하세요">
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align: top;">내용</th>
                        <td>
                            <textarea name="bcontent" placeholder="내용을 입력하세요">${view.bcontent}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>설정</th>
                        <td>
                            <label><input type="radio" name="bcategory" value="추천글" ${view.bcategory == '추천글' ? 'checked' : ''}> 일반/추천글</label>
                            <label><input type="radio" name="bcategory" value="비밀글" ${view.bcategory == '비밀글' ? 'checked' : ''}> 비밀글</label>
                        </td>
                    </tr>								
                </table>

                <div class="write-btn-area">
                    <input type="submit" value="수정" onclick="return check()" class="btn-submit">
                    <a href="/guest/boardView?bno=${view.bno}" class="btn-cancel">취소</a>
                </div>
            </form>

        </main>
    </div>
    
    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>