<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 수정</title>
<link rel="stylesheet" href="/css/storeWU.css">

<script>
    let menuIndex = ${fn:length(menu)};

    function addMenu() {

        const menu = document.createElement("div");
        menu.className = "menu-input-row menu-item";

        menu.innerHTML =
            '<span class="menu-label">메뉴명</span>' +
            '<input type="text" name="mnname">' +
            '<span class="menu-label">가격</span>' +
            '<input type="text" name="mnprice">' +
            '<input type="button" value="삭제" onclick="this.closest(\'.menu-item\').remove()">';

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
    <%@ include file="../guest/header.jsp" %>

    <div class="write-container">
        <h3>음식점 수정 페이지</h3>

        <form name="store" method="post" action="/admin/storeUpdate">
            <input type="hidden" name="sno" value="${update.sno}">

            <table class="write-table">
                <tr>
                    <th>음식점명</th>
                    <td><input type="text" name="sname" value="${update.sname}"></td>
                </tr>
                <tr>
                    <th>이미지</th>
                    <td><input type="text" name="sfiles" value="${update.sfiles}"></td>
                </tr>
                <tr>
                    <th>카테고리</th>
                    <td><input type="text" name="scategory" value="${update.scategory}"></td>
                </tr>
                <tr>
                    <th>키워드</th>
                    <td>
                        <div class="keyword-grid">
                            <label><input type="checkbox" name="skeyword" value="새벽까지 영업하는" ${fn:contains(update.skeyword, '새벽까지 영업하는') ? 'checked' : ''}>새벽까지 영업하는</label>
                            <label><input type="checkbox" name="skeyword" value="혼자 식사하기 좋은" ${fn:contains(update.skeyword, '혼자 식사하기 좋은') ? 'checked' : ''}>혼자 식사하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="가족외식" ${fn:contains(update.skeyword, '가족외식') ? 'checked' : ''}>가족외식</label>
                            <label><input type="checkbox" name="skeyword" value="데이트하기 좋은" ${fn:contains(update.skeyword, '데이트하기 좋은') ? 'checked' : ''}>데이트하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는" ${fn:contains(update.skeyword, '조용하게 식사할 수 있는') ? 'checked' : ''}>조용하게 식사할 수 있는</label>
                            <label><input type="checkbox" name="skeyword" value="가성비가 좋은" ${fn:contains(update.skeyword, '가성비가 좋은') ? 'checked' : ''}>가성비가 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은" ${fn:contains(update.skeyword, '예약하고 방문하기 좋은') ? 'checked' : ''}>예약하고 방문하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="포장해서 먹기 좋은" ${fn:contains(update.skeyword, '포장해서 먹기 좋은') ? 'checked' : ''}>포장해서 먹기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="주차하기 편한" ${fn:contains(update.skeyword, '주차하기 편한') ? 'checked' : ''}>주차하기 편한</label>
                            <label><input type="checkbox" name="skeyword" value="단체로 방문하기 좋은" ${fn:contains(update.skeyword, '단체로 방문하기 좋은') ? 'checked' : ''}>단체로 방문하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="노키즈존" ${fn:contains(update.skeyword, '노키즈존') ? 'checked' : ''}>노키즈존</label>
                            <label><input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은" ${fn:contains(update.skeyword, '아이와 함께 가기 좋은') ? 'checked' : ''}>아이와 함께 가기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는" ${fn:contains(update.skeyword, '반려동물과 함께 갈 수 있는') ? 'checked' : ''}>반려동물과 함께 갈 수 있는</label>
                            <label><input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은" ${fn:contains(update.skeyword, '간단하게 식사하기 좋은') ? 'checked' : ''}>간단하게 식사하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="경치가 좋은" ${fn:contains(update.skeyword, '경치가 좋은') ? 'checked' : ''}>경치가 좋은</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>설명</th>
                    <td><textarea name="scontent">${update.scontent}</textarea></td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td><input type="text" name="saddr" value="${update.saddr}"></td>
                </tr>
                <tr>
                    <th>시도</th>
                    <td><input type="text" name="ssido" value="${update.ssido}"></td>
                </tr>
                <tr>
                    <th>시군구</th>
                    <td><input type="text" name="ssigungu" value="${update.ssigungu}"></td>
                </tr>
                <tr>
                    <th>위도</th>
                    <td><input type="text" name="slat" value="${update.slat}"></td>
                </tr>
                <tr>
                    <th>경도</th>
                    <td><input type="text" name="slong" value="${update.slong}"></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><input type="text" name="stel" value="${update.stel}"></td>
                </tr>
                <tr>
                    <th>영업 정보</th>
                    <td><textarea name="sinfo">${update.sinfo}</textarea></td>
                </tr>
                <tr>
                    <th>주차 여부</th>
                    <td><input type="text" name="sparking" value="${update.sparking}"></td>
                </tr>
                <tr>
                    <th>영업 상태</th>
                    <td>
                        <div class="status-radio-group">
                            <label><input type="radio" name="sstatus" value="OPEN" ${update.sstatus == 'OPEN' ? 'checked' : ''}>영업중</label>
                            <label><input type="radio" name="sstatus" value="CLOSED" ${update.sstatus == 'CLOSED' ? 'checked' : ''}>폐업</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>메뉴</th>
                    <td>
                        <input type="hidden" name="deleteMnno" id="deleteMnno">

                        <c:forEach var="m" items="${menu}" varStatus="status">
                            <div class="menu-input-row menu-item">
                                <input type="hidden" name="mnno" value="${m.mnno}">
                                <span class="menu-label">메뉴명</span>
                                <input type="text" name="mnname" value="${m.mnname}">
                                <span class="menu-label">가격</span>
                                <input type="text" name="mnprice" value="${m.mnprice}">
                                <input type="button" value="삭제" onclick="deleteMenu(${m.mnno}, this)">
                            </div>
                        </c:forEach>

                        <span id="menuAdd"></span>
                        <input type="button" class="menu-add-btn" value="+ 메뉴 추가" onclick="addMenu()">
                    </td>
                </tr>
            </table>

            <div class="write-btn-area">
                <input type="submit" class="btn-submit" value="수정">
                <input type="button" class="btn-cancel" value="취소" onclick="history.back()">
            </div>
        </form>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>