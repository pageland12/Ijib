<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 등록</title>
<link rel="stylesheet" href="/css/passWU.css">
<script src="/js/passWrite.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="write-container">
        <h3>구독권 등록 페이지</h3>

        <form name="pass" method="post" action="/admin/passWrite" enctype="multipart/form-data">
            <table class="write-table">
                <tr>
                    <th>이미지</th>
                    <td><input type="file" name="pupload"></td>
                </tr>
                <tr>
                    <th>상품명</th>
                    <td><input type="text" name="pname"></td>
                </tr>
                <tr>
                    <th>가격</th>
                    <td><input type="text" name="pprice"></td>
                </tr>
                <tr>
                    <th>기간</th>
                    <td><input type="text" name="pperiod"></td>
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