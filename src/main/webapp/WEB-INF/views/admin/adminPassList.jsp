<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 관리 페이지</title>
<link rel="stylesheet" href="<c:url value='/css/memberList.css'/>">
</head>
<body>

    <%@ include file="../guest/header.jsp" %>

    <div class="list-page">
        <div class="list-container">

            <h3 class="list-title">구독권 관리 페이지</h3>

            <table class="list-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>이미지</th>
                        <th>상품명</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pass" items="${pass}">
                        <tr>
                            <td>${pass.pno}</td>
                            <td>
                                <a href="/admin/passView?pno=${pass.pno}">
                                    <img src="/images/${pass.pimg}" class="list-thumb">
                                </a>
                            </td>
                            <td class="cell-link">
                                <a href="/admin/passView?pno=${pass.pno}">${pass.pname}</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty pass}">
                        <tr>
                            <td colspan="3" class="list-empty">등록된 구독권이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>

        </div>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>

</body>
</html>