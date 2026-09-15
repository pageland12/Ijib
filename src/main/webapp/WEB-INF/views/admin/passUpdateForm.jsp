<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 수정</title>
<link rel="stylesheet" href="<c:url value='/css/memberWrite.css'/>">
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="admin-page">
        <div class="admin-card">

            <div class="content-header">
                <h2 class="content-title">구독권 수정</h2>
                <div class="content-subtitle">
                    구독권 이미지와 상품 정보를 수정할 수 있습니다.
                </div>
            </div>

            <form name="pass" method="post" action="/admin/passUpdate" enctype="multipart/form-data">
                <input type="hidden" name="pno" value="${update.pno}">
                <input type="hidden" name="pimg" value="${update.pimg}">

                <table class="admin-table">
                    <tr>
                        <th>현재 이미지</th>
                        <td>
                            <div class="file-preview-box">${update.pimg}</div>
                        </td>
                    </tr>
                    <tr>
                        <th>이미지</th>
                        <td><input type="file" name="pupload" class="file-input"></td>
                    </tr>
                    <tr>
                        <th>상품명</th>
                        <td><input type="text" name="pname" value="${update.pname}"></td>
                    </tr>
                    <tr>
                        <th>가격</th>
                        <td><input type="text" name="pprice" value="${update.pprice}"></td>
                    </tr>
                    <tr>
                        <th>기간</th>
                        <td><input type="text" name="pperiod" value="${update.pperiod}"></td>
                    </tr>
                </table>

                <div class="btn-group">
                    <input type="submit" class="btn-submit" value="수정">
                    <input type="button" class="btn-cancel" value="취소" onclick="history.back()">
                </div>
            </form>

        </div>
    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>