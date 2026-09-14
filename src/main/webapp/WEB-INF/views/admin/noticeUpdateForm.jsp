<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/boardWrite.css'/>">
<script src="/js/noticeWU.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="member-page">
        <main class="member-content write-container">
            
            <div class="content-title-area">
                <h2>공지사항 수정 <span>NOTICE</span></h2>
            </div>

            <form name="noticeWriteForm" method="post" action="/admin/noticeUpdate" enctype="multipart/form-data">
                <input type="hidden" name="nno" value="${view.nno}">
                <input type="hidden" name="nfiles" value="${view.nfiles}">
                
                <table class="write-table">		
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="ntitle" value="${view.ntitle}" placeholder="제목을 입력하세요">
                        </td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td>
                            <textarea name="ncontent" placeholder="내용을 입력하세요">${view.ncontent}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>첨부파일</th>
                        <td>
                            <c:if test="${not empty view.nfiles}">
                                <div class="file-preview-box">
                                    <span>현재 파일: ${view.nfiles}</span><br>
                                    <img src="/images/${view.nfiles}" class="file-preview-img" alt="첨부 이미지">
                                </div>
                            </c:if>
                            <input type="file" name="nupload">
                        </td>
                    </tr>		
                </table>

                <div class="write-btn-area">
                    <input type="submit" value="수정" onclick="return check()" class="btn-submit">
                    <a href="/guest/noticeView?nno=${view.nno}" class="btn-cancel">취소</a>
                </div>
            </form>

        </main>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>