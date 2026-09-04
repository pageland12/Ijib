<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 등록</title>
</head>
<body>
	<form name="noticeWriteForm" method="post" action="/admin/noticeWrite" enctype="multipart/form-data">
		<table border=1 width=400>
			<tr>
				<th>제목</th>
				<td><input type="text" name="ntitle"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="ncontent" ></textarea></td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td><input type="file" name="nupload"></td>
			</tr>		
		</table>
		<input type="submit" value="등록">
	</form>
</body>
</html>