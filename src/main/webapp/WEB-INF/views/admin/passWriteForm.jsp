<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 등록</title>
</head>
<body>
	<h3>구독권 등록 페이지</h3>
	<form name="pass" method="post" action="/admin/passWrite" enctype="multipart/form-data">
		이미지 : <input type="file" name="pupload"> <br>
		상품명 : <input type="text" name="pname"><br>
		가격 : <input type="text" name="pprice"><br>
		기간 : <input type="text" name="pperiod"><br>
		<input type="submit" value="등록">
		<input type="button" value="취소" onclick="history.back()">
	</form>
</body>
</html>