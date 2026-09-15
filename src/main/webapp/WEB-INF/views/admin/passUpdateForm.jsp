<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>구독권 수정</title>

    <link rel="stylesheet" href="/css/passWU.css">
    <script src="/js/passUpdate.js"></script>
</head>

<body>

    <%@ include file="../guest/header.jsp" %>

    <div class="write-container">

        <h3>구독권 수정 페이지</h3>

        <form name="pass"
              method="post"
              action="/admin/passUpdate"
              enctype="multipart/form-data">

            <input type="hidden"
                   name="pno"
                   value="${update.pno}">

            <input type="hidden"
                   name="pimg"
                   value="${update.pimg}">

            <table class="write-table">

                <tr>
                    <th>현재 이미지</th>
                    <td>
                        <div class="file-preview-box">
                            ${update.pimg}
                        </div>
                    </td>
                </tr>

                <tr>
                    <th>이미지</th>
                    <td>
                        <input type="file"
                               name="pupload">
                    </td>
                </tr>

                <tr>
                    <th>상품명</th>
                    <td>
                        <input type="text"
                               name="pname"
                               value="${update.pname}">
                    </td>
                </tr>

                <tr>
                    <th>가격</th>
                    <td>
                        <input type="text"
                               name="pprice"
                               value="${update.pprice}">
                    </td>
                </tr>

                <tr>
                    <th>기간</th>
                    <td>
                        <input type="text"
                               name="pperiod"
                               value="${update.pperiod}">
                    </td>
                </tr>

            </table>

            <div class="write-btn-area">

                <input type="submit"
                       class="btn-submit"
                       value="수정"
                       onclick="return check()">

                <input type="button"
                       class="btn-cancel"
                       value="취소"
                       onclick="history.back()">

            </div>

        </form>

    </div>

    <%@ include file="../guest/footer.jsp" %>

</body>
</html>