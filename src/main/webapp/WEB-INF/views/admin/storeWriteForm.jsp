<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 등록</title>

<script>

    function addMenu() {

        const menu = document.createElement("span");

        menu.innerHTML =
            '메뉴명 : <input type="text" name="mnname">' +
            ' 가격 : <input type="text" name="mnprice">' +
            ' <input type="button" value="삭제" onclick="this.parentElement.remove()"><br>';

        document.getElementById("menuAdd").before(menu);
    }

</script>

</head>

<body>

<h3>음식점 등록 페이지</h3>

<form name="store" method="post" action="/admin/storeWrite">
    음식점명 : <input type="text" name="sname"><br>
    이미지 : <input type="text" name="sfiles"><br>
    카테고리 : <input type="text" name="scategory"><br>
    키워드 : <br>
    <input type="checkbox" name="skeyword" value="새벽까지 영업하는"> 새벽까지 영업하는
    <input type="checkbox" name="skeyword" value="혼자 식사하기 좋은"> 혼자 식사하기 좋은
    <input type="checkbox" name="skeyword" value="가족외식"> 가족외식
    <input type="checkbox" name="skeyword" value="데이트하기 좋은"> 데이트하기 좋은 <br>
    <input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는"> 조용하게 식사할 수 있는
    <input type="checkbox" name="skeyword" value="가성비가 좋은"> 가성비가 좋은
    <input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은"> 예약하고 방문하기 좋은
    <input type="checkbox" name="skeyword" value="포장해서 먹기 좋은"> 포장해서 먹기 좋은 <br>
    <input type="checkbox" name="skeyword" value="주차하기 편한"> 주차하기 편한
    <input type="checkbox" name="skeyword" value="단체로 방문하기 좋은"> 단체로 방문하기 좋은
    <input type="checkbox" name="skeyword" value="노키즈존"> 노키즈존
    <input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은"> 아이와 함께 가기 좋은 <br>
    <input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는"> 반려동물과 함께 갈 수 있는
    <input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은"> 간단하게 식사하기 좋은
    <input type="checkbox" name="skeyword" value="경치가 좋은"> 경치가 좋은
    <br>
    설명 : <textarea name="scontent"></textarea><br>
    주소 : <input type="text" name="saddr"><br>
    위도 : <input type="text" name="slat"><br>
    경도 : <input type="text" name="slong"><br>
    전화번호 : <input type="text" name="stel"><br>
    영업 정보 : <textarea name="sinfo"></textarea><br>
    주차 여부 : <input type="text" name="sparking"><br>
    영업 상태 :
    <input type="radio" name="sstatus" value="OPEN" checked> 영업중
    <input type="radio" name="sstatus" value="CLOSED"> 폐업<br>
    메뉴 <br>
	메뉴명 : <input type="text" name="mnname">
	가격 : <input type="text" name="mnprice"><br>
	<span id="menuAdd"></span>
	<input type="button" value="메뉴 추가" onclick="addMenu()"><br>
    <input type="submit" value="등록">
    <input type="button" value="취소" onclick="history.back()">
</form>

</body>
</html>