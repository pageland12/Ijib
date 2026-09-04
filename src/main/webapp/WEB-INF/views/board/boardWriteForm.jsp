<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 등록</title>
</head>
<body>
	<form name="boardWriteForm" method="post" action="/board/boardWrite">
		<table border=1 width=400>
			<tr>
				<th>제목</th>
				<td><input type="text" name="btitle"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="bcontent" ></textarea></td>
			</tr>
			<tr>
				<th>비밀글 설정</th>
				<td>
					<input type="radio" name="bcategory" value="추천글">추천글
					<input type="radio" name="bcategory" value="비밀글">비밀글
				</td>
			</tr>		
		</table>
		<input type="submit" value="등록">
	</form>
</body>
</html>