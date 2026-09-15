<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 등록</title>
<link rel="stylesheet" href="/css/storeWU.css">
<script src="/js/storeWrite.js"></script>
<script>

    function addMenu() {

        const menu = document.createElement("div");
        menu.className = "menu-input-row";

        menu.innerHTML =
            '<span class="menu-label">메뉴명</span>' +
            '<input type="text" name="mnname">' +
            '<span class="menu-label">가격</span>' +
            '<input type="text" name="mnprice">' +
            '<input type="button" value="삭제" onclick="this.parentElement.remove()">';

        document.getElementById("menuAdd").before(menu);
    }
</script>

</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="write-container">
        <h3>음식점 등록 페이지</h3>

        <form name="store" method="post" action="/admin/storeWrite">
            <table class="write-table">
                <tr>
                    <th>음식점명</th>
                    <td><input type="text" name="sname"></td>
                </tr>
                <tr>
                    <th>이미지</th>
                    <td><input type="text" name="sfiles"></td>
                </tr>
                <tr>
                    <th>카테고리</th>
                    <td><input type="text" name="scategory"></td>
                </tr>
                <tr>
                    <th>키워드</th>
                    <td>
                        <div class="keyword-grid">
                            <label><input type="checkbox" name="skeyword" value="새벽까지 영업하는">새벽까지 영업하는</label>
                            <label><input type="checkbox" name="skeyword" value="혼자 식사하기 좋은">혼자 식사하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="가족외식">가족외식</label>
                            <label><input type="checkbox" name="skeyword" value="데이트하기 좋은">데이트하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는">조용하게 식사할 수 있는</label>
                            <label><input type="checkbox" name="skeyword" value="가성비가 좋은">가성비가 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은">예약하고 방문하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="포장해서 먹기 좋은">포장해서 먹기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="주차하기 편한">주차하기 편한</label>
                            <label><input type="checkbox" name="skeyword" value="단체로 방문하기 좋은">단체로 방문하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="노키즈존">노키즈존</label>
                            <label><input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은">아이와 함께 가기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는">반려동물과 함께 갈 수 있는</label>
                            <label><input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은">간단하게 식사하기 좋은</label>
                            <label><input type="checkbox" name="skeyword" value="경치가 좋은">경치가 좋은</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>설명</th>
                    <td><textarea name="scontent"></textarea></td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td><input type="text" name="saddr"></td>
                </tr>
                <tr>
                    <th>시도</th>
                    <td><input type="text" name="ssido"></td>
                </tr>
                <tr>
                    <th>시군구</th>
                    <td><input type="text" name="ssigungu"></td>
                </tr>
                <tr>
                    <th>위도</th>
                    <td><input type="text" name="slat"></td>
                </tr>
                <tr>
                    <th>경도</th>
                    <td><input type="text" name="slong"></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><input type="text" name="stel"></td>
                </tr>
                <tr>
                    <th>영업 정보</th>
                    <td><textarea name="sinfo"></textarea></td>
                </tr>
                <tr>
                    <th>주차 여부</th>
                    <td><input type="text" name="sparking"></td>
                </tr>
                <tr>
                    <th>영업 상태</th>
                    <td>
                        <div class="status-radio-group">
                            <label><input type="radio" name="sstatus" value="OPEN" checked>영업중</label>
                            <label><input type="radio" name="sstatus" value="CLOSED">폐업</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>메뉴</th>
                    <td>
                        <div class="menu-input-row">
                            <span class="menu-label">메뉴명</span>
                            <input type="text" name="mnname">
                            <span class="menu-label">가격</span>
                            <input type="text" name="mnprice">
                        </div>
                        <span id="menuAdd"></span>
                        <input type="button" class="menu-add-btn" value="+ 메뉴 추가" onclick="addMenu()">
                    </td>
                </tr>
            </table>

            <div class="write-btn-area">
                <input type="submit" class="btn-submit" value="등록" onclick="return check()">
                <input type="button" class="btn-cancel" value="취소" onclick="history.back()">
            </div>
        </form>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>