<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 수정</title>
</head>
<body>
	<h3>구독권 수정 페이지</h3>
	<form name="pass" method="post" action="/admin/passUpdate" enctype="multipart/form-data">
		<input type="hidden" name="pno" value="${update.pno}">
		<input type="hidden" name="pimg" value="${update.pimg}">
		현재 이미지 : ${update.pimg}<br>
		이미지 : <input type="file" name="pupload"> <br>
		상품명 : <input type="text" name="pname" value="${update.pname}"><br>
		가격 : <input type="text" name="pprice" value="${update.pprice}"><br>
		기간 : <input type="text" name="pperiod" value="${update.pperiod}"><br>
		<input type="submit" value="수정">
		<input type="button" value="취소" onclick="history.back()">
	</form>
</body>
</html>