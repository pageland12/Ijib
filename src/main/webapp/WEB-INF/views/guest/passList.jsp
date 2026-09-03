<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 목록</title>
</head>
<body>
	<h1>이집어때 프리미엄 콘텐츠  이용권 구매</h1>
	<p>이집어때 프리미엄 콘텐츠 이용권을 구매하시면 다음과 같이 다양한 서비스를 이용하실 수 있습니다.</p>
	<h3>혜택 1.</h3>
	<p>이집어때의 콘텐츠 이용권을 구매하시면 맛집 리뷰를 비롯하여 본 사이트에서 제공하는 모든 콘텐츠를 열람하실 수 있습니다.</p>
	<h3>혜택 2.</h3>
	<p>지역별, 예산, 음식 종류, 특징에 따라 내가 원하는 맛집을 정확하게 찾아주는 멀티 검색 기능을 사용하실 수 있습니다.</p>
	<h3>혜택 3.</h3>
	<p>마이 페이지의 북마크 기능을 사용하실 수 있습니다.</p>
	<table border="1">
    <c:forEach var="pass" items="${pass}">
        <tr>
            <a href="/member/order?pno=${pass.pno}"><img src="/images/${pass.pimg}" width="150"></a>
        </tr>
    </c:forEach>
	</table> <br>
	* 위 혜택을 누릴 수 있는 이집어때 콘텐츠 이용권은 1개월, 6개월, 1년 단위로 선택해 구매하실 수 있습니다. <br>
	* 모든 이용권 금액은 부가세 10%가 포함된 가격입니다.<br>
</body>
</html>