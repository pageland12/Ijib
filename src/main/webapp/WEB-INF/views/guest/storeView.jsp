<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 상세</title>
</head>
<body>
	<h3>음식점 상세</h3>
	음식점명 : ${view.sname}<br>
	이미지 : 
	<c:forEach var="image" items="${fn:split(view.sfiles, ',')}">
	    <img src="${image}" width="200">
	</c:forEach><br>
	카테고리 : ${view.scategory}<br>
	<p>메뉴</p>
	<table border="1">
	    <tr>
	        <th>메뉴명</th>
	        <th>가격</th>
	    </tr>
	    <c:forEach var="menu" items="${menu}">
	        <tr>
	            <td>${menu.mnname}</td>
	            <td>${menu.mnprice}</td>
	        </tr>
	    </c:forEach>
	</table>
	<br>
	키워드 : 
	<c:forEach var="keyword" items="${fn:split(view.skeyword, ',')}">
	    [${keyword}]
	</c:forEach><br>
	설명 : ${view.scontent}<br>
	주소 : ${view.saddr}<br>
	전화번호 : ${view.stel}<br>
	영업 정보 : ${view.sinfo}<br>
	주차 여부 : ${view.sparking}<br>
	영업 상태 : ${view.sstatus}<br>
	
	<!-- ================= 후기 ================= -->

    <h3>후기</h3>


    <!-- 후기 미리보기 -->

    <c:choose>

        <c:when test="${not empty preview}">

            <c:forEach var="rating" items="${preview}">

                <div class="rating-item">

                    <strong>${rating.rtitle}</strong>

                    <br>

                    평점 : ${rating.rrate}

                    <br>

                    ${rating.rcontent}

                    <br>

                    작성자 : ${rating.mname}

                    <br>

                    작성일 : ${rating.rdate}

                </div>

            </c:forEach>


            <br>


            <!-- 더보기 -->

            <button type="button"
                onclick="openRatingModal()">

                후기 더보기

            </button>

        </c:when>


        <c:otherwise>

            아직 작성된 후기가 없습니다.

        </c:otherwise>

    </c:choose>


    <!-- ================= 전체 후기 모달 ================= -->

    <div id="ratingModal" class="rating-modal">

        <div class="rating-modal-content">

            <span class="rating-close"
                onclick="closeRatingModal()">

                ×

            </span>


            <h3>전체 후기</h3>


            <c:forEach var="rating" items="${list}">

                <div class="rating-item">

                    <strong>${rating.rtitle}</strong>

                    <br>

                    평점 : ${rating.rrate}

                    <br>

                    내용 : ${rating.rcontent}

                    <br>

                    특징 : ${rating.rfeature}

                    <br>

                    작성자 : ${rating.mname}

                    <br>

                    작성일 : ${rating.rdate}

                </div>

            </c:forEach>

        </div>

    </div>
	
	<a href="/board/ratingWriteForm?sno=${view.sno}">후기 작성</a> /
	<a href="/member/bookmarkInsert?sno=${view.sno}">북마크</a> /
	<a href="/admin/storeUpdateForm?sno=${view.sno}">수정</a> / 
	<a href="/admin/storeDelete?sno=${view.sno}">삭제</a> / 
	<a href="/guest/storeList">목록</a>
	
	<c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>
</body>
</html>