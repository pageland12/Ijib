<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>음식점 상세</title>
<style>
    /* 후기 하나 */
    .rating-item {
        padding: 15px;
        margin-bottom: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
    }

    /* 전체 후기 모달 */
    .rating-modal {
        /* 처음에는 숨김 */
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
    }

    /* 모달 내부 */
    .rating-modal-content {
        position: relative;
        background-color: white;
        width: 600px;
        max-width: 90%;
        max-height: 80vh;
        overflow-y: auto;
        margin: 5% auto;
        padding: 30px;
        border-radius: 10px;
        box-sizing: border-box;
    }

    /* X 버튼 */
    .rating-close {
        position: absolute;
        top: 10px;
        right: 20px;
        font-size: 30px;
        font-weight: bold;
        cursor: pointer;
    }

    /* X 버튼 마우스 올렸을 때 */
    .rating-close:hover {
        color: #777;
    }

</style>
<script>
    // 전체 후기 모달 열기
    function openRatingModal() {
        document.getElementById("ratingModal").style.display = "block";
    }

    // 전체 후기 모달 닫기
    function closeRatingModal() {
        document.getElementById("ratingModal").style.display = "none";
    }

    // 모달 바깥쪽 클릭하면 닫기
    window.onclick = function(event) {
        const modal = document.getElementById("ratingModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }

</script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
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

    <h3>후기</h3>  
    <!-- 후기 미리보기 -->
    <c:choose>
        <c:when test="${not empty preview}">
            <c:forEach var="preview" items="${preview}">
                <div class="rating-item">
                    <strong>${preview.rtitle}</strong><br>
                    평점 : ${preview.rrate}<br>
                    ${preview.rcontent}<br>
                    작성자 : ${preview.mname}<br>
                    작성일 : <fmt:formatDate value="${preview.rdate}" pattern="yyyy.MM.dd"/>
                </div>
            </c:forEach>
            <br>
            <!-- 더보기 -->
            <button type="button" onclick="openRatingModal()">더보기</button>
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
            <c:choose>
        		<c:when test="${not empty list}">
	            	<c:forEach var="list" items="${list}">
    	            	<div class="rating-item">
        	           		<strong>${list.rtitle}</strong><br>
            	        	평점 : ${list.rrate}<br>
                	    	${list.rcontent}<br>
                	    	특징 : ${list.rfeature} <br>
                    		작성자 : ${list.mname}<br>
                    		작성일 : <fmt:formatDate value="${list.rdate}" pattern="yyyy.MM.dd"/>
                		</div>
            		</c:forEach>
            		<br>
        		</c:when>        
        	<c:otherwise>
	            아직 작성된 후기가 없습니다.
        	</c:otherwise>
    		</c:choose>
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

	<br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>