<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 수정</title>

<script>
    let menuIndex = ${fn:length(menu)};

    function addMenu() {

        const menu = document.createElement("span");

        menu.className = "menu-item";

        menu.innerHTML =
            '메뉴명 : <input type="text" name="mnname">' +
            ' 가격 : <input type="text" name="mnprice">' +
            ' <input type="button" value="삭제" onclick="this.closest(\'.menu-item\').remove()">' +
            '<br>';

        document.getElementById("menuAdd").before(menu);
    }
    
    let deleteMnno = [];

    function deleteMenu(mnno, element) {

        deleteMnno.push(mnno);

        document.getElementById("deleteMnno").value =
            deleteMnno.join(",");

        element.closest(".menu-item").remove();
    }
</script>

</head>
<body>
<h3>음식점 수정 페이지</h3>
	<form name="store" method="post" action="/admin/storeUpdate">
	    <input type="hidden" name="sno" value="${update.sno}">
	    음식점명 : <input type="text" name="sname" value="${update.sname}"><br>
	    이미지 : <input type="text" name="sfiles" value="${update.sfiles}"><br>
	    카테고리 : <input type="text" name="scategory" value="${update.scategory}"><br>
	    키워드 : <br>
	    <input type="checkbox" name="skeyword" value="새벽까지 영업하는" ${fn:contains(update.skeyword, '새벽까지 영업하는') ? 'checked' : ''}>새벽까지 영업하는
	    <input type="checkbox" name="skeyword" value="혼자 식사하기 좋은" ${fn:contains(update.skeyword, '혼자 식사하기 좋은') ? 'checked' : ''}>혼자 식사하기 좋은
	    <input type="checkbox" name="skeyword" value="가족외식" ${fn:contains(update.skeyword, '가족외식') ? 'checked' : ''}>가족외식
	    <input type="checkbox" name="skeyword" value="데이트하기 좋은" ${fn:contains(update.skeyword, '데이트하기 좋은') ? 'checked' : ''}>데이트하기 좋은<br>
	    <input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는" ${fn:contains(update.skeyword, '조용하게 식사할 수 있는') ? 'checked' : ''}>조용하게 식사할 수 있는
	    <input type="checkbox" name="skeyword" value="가성비가 좋은" ${fn:contains(update.skeyword, '가성비가 좋은') ? 'checked' : ''}>가성비가 좋은
	    <input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은" ${fn:contains(update.skeyword, '예약하고 방문하기 좋은') ? 'checked' : ''}>예약하고 방문하기 좋은
	    <input type="checkbox" name="skeyword" value="포장해서 먹기 좋은" ${fn:contains(update.skeyword, '포장해서 먹기 좋은') ? 'checked' : ''}>포장해서 먹기 좋은<br>
	    <input type="checkbox" name="skeyword" value="주차하기 편한" ${fn:contains(update.skeyword, '주차하기 편한') ? 'checked' : ''}>주차하기 편한
	    <input type="checkbox" name="skeyword" value="단체로 방문하기 좋은" ${fn:contains(update.skeyword, '단체로 방문하기 좋은') ? 'checked' : ''}>단체로 방문하기 좋은
	    <input type="checkbox" name="skeyword" value="노키즈존" ${fn:contains(update.skeyword, '노키즈존') ? 'checked' : ''}>노키즈존
	    <input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은" ${fn:contains(update.skeyword, '아이와 함께 가기 좋은') ? 'checked' : ''}>아이와 함께 가기 좋은<br>
	    <input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는" ${fn:contains(update.skeyword, '반려동물과 함께 갈 수 있는') ? 'checked' : ''}>반려동물과 함께 갈 수 있는
	    <input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은" ${fn:contains(update.skeyword, '간단하게 식사하기 좋은') ? 'checked' : ''}>간단하게 식사하기 좋은
	    <input type="checkbox" name="skeyword" value="경치가 좋은" ${fn:contains(update.skeyword, '경치가 좋은') ? 'checked' : ''}>경치가 좋은<br>
	    설명 : <textarea name="scontent">${update.scontent}</textarea><br>
	    주소 : <input type="text" name="saddr" value="${update.saddr}"><br>
	    위도 : <input type="text" name="slat" value="${update.slat}"><br>
	    경도 : <input type="text" name="slong" value="${update.slong}"><br>
	    전화번호 : <input type="text" name="stel" value="${update.stel}"><br>
	    영업 정보 : <textarea name="sinfo">${update.sinfo}</textarea><br>
	    주차 여부 : <input type="text" name="sparking" value="${update.sparking}"><br>
	    영업 상태 :
	    <input type="radio" name="sstatus" value="OPEN" ${update.sstatus == 'OPEN' ? 'checked' : ''}> 영업중
	    <input type="radio" name="sstatus" value="CLOSED" ${update.sstatus == 'CLOSED' ? 'checked' : ''}> 폐업<br>
	    
	    메뉴 <br>
	    <input type="hidden" name="deleteMnno" id="deleteMnno">
		<c:forEach var="m" items="${menu}" varStatus="status">
		    <span class="menu-item">
		        <input type="hidden" name="mnno" value="${m.mnno}">
		        메뉴명 : <input type="text" name="mnname" value="${m.mnname}">
		        가격 : <input type="text" name="mnprice" value="${m.mnprice}">
		        <input type="button" value="삭제" onclick="deleteMenu(${m.mnno}, this)"><br>
		    </span>
		</c:forEach>
		<span id="menuAdd"></span>
		<input type="button" value="메뉴 추가" onclick="addMenu()"><br>
	    
		<input type="submit" value="수정">
	    <input type="button" value="취소" onclick="history.back()">
	</form>
</body>
</html>