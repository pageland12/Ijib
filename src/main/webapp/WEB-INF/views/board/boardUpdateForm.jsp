<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
</head>
<body>
	<form name="boardWriteForm" method="post" action="/board/boardUpdate">
		<input type="hidden" name="bno" value="${view.bno}">
		<table border=1 width=400>		
			<tr>
				<th>제목</th>
				<td><input type="text" name="btitle" value="${view.btitle}"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="bcontent">${view.bcontent}</textarea></td>
			</tr>
			<tr>
				<th>비밀글 설정</th>
				<td><input type="radio" name="bcategory" value="추천글" ${view.bcategory == '추천글' ? 'checked' : ''}>추천글
					<input type="radio" name="bcategory" value="비밀글" ${view.bcategory == '비밀글' ? 'checked' : ''}>비밀글
				</td>
			</tr>								
		</table>
		<input type="submit" value="수정">
	</form>
</body>
</html>