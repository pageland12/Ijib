<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
</head>
<body>
	<form name="noticeWriteForm" method="post" action="/admin/noticeUpdate" enctype="multipart/form-data">
		<input type="hidden" name="nno" value="${view.nno}">
		<input type="hidden" name="nfiles" value="${view.nfiles}">
		<table border=1 width=400>		
			<tr>
				<th>제목</th>
				<td><input type="text" name="ntitle" value="${view.ntitle}"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="ncontent">${view.ncontent}</textarea></td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
					<c:if test="${not empty view.nfiles}">
                    	<p>현재 파일: ${view.nfiles}</p>
                    	<img src="/images/${view.nfiles}" width="150"><br>
                	</c:if>
                	<input type="file" name="nupload">
                </td>
			</tr>		
		</table>
		<input type="submit" value="수정">
	</form>
</body>
</html>