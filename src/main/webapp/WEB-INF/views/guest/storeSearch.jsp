<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>

<html>

<head>
<meta charset="UTF-8">
<title>음식점 검색 결과</title>
</head>

<body>

    <%@ include file="../guest/header.jsp"%>

    <%@ include file="../guest/search.jsp"%>

    <hr>

    <h3>'${keyword}' 검색 결과</h3>

    <c:if test="${empty result}">
        <p>검색 결과가 없습니다.</p>
    </c:if>

    <c:forEach var="list" items="${result}">

        <tr>

            <td>
                <a href="${pageContext.request.contextPath}/guest/storeView?sno=${list.sno}">
                    <img src="${fn:split(list.sfiles, ',')[0]}"
                         width="150">
                </a>
            </td>

            <td>
                <a href="${pageContext.request.contextPath}/guest/storeView?sno=${list.sno}">
                    ${list.sname}
                </a>
            </td>

            <td>
                ${list.saddr}
            </td>

            <td>

                <c:choose>

                    <c:when test="${fn:length(list.scontent) > 50}">
                        ${fn:substring(list.scontent, 0, 50)}...
                    </c:when>

                    <c:otherwise>
                        ${list.scontent}
                    </c:otherwise>

                </c:choose>

            </td>

        </tr>

    </c:forEach>

    <%@ include file="../guest/footer.jsp"%>

</body>

</html>