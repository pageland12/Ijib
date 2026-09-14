<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 등록</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/boardWrite.css'/>">
<script src="/js/noticeWU.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="member-page" style="justify-content: center;">
        <main class="member-content write-container">
            
            <div class="content-title-area">
                <h2>공지사항 작성 <span>NOTICE</span></h2>
            </div>

            <form name="noticeWriteForm" method="post" action="/admin/noticeWrite" enctype="multipart/form-data">
                <table class="write-table">
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="ntitle" placeholder="공지 제목을 입력하세요">
                        </td>
                    </tr>
                    <tr>
                        <th style="vertical-align: top;">내용</th>
                        <td>
                            <textarea name="ncontent" placeholder="공지 내용을 입력하세요"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td>
                            <input type="file" name="nupload" style="font-size: 14px;">
                        </td>
                    </tr>		
                </table>

                <div class="write-btn-area">
                    <input type="submit" value="등록" onclick="return check()" class="btn-submit">
                    <a href="/guest/noticeList" class="btn-cancel">취소</a>
                </div>
            </form>

        </main>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>