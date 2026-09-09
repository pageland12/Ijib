<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<form action="${pageContext.request.contextPath}/guest/storeSearch"
      method="get">

    <!-- 검색창 -->
    <input type="text"
           name="keyword"
           value="${keyword}"
           placeholder="음식점이나 메뉴를 검색하세요">

    <button type="submit">검색</button>

    <!-- 필터 -->
    <details>
        <summary>필터</summary>

        <h4>분류</h4>

        <label>
            <input type="checkbox"
                   name="scategory"
                   value="한식"
                   <c:if test="${scategory != null and scategory.contains('한식')}">checked</c:if>>
            한식
        </label>

        <label>
            <input type="checkbox"
                   name="scategory"
                   value="중식"
                   <c:if test="${scategory != null and scategory.contains('중식')}">checked</c:if>>
            중식
        </label>

        <label>
            <input type="checkbox"
                   name="scategory"
                   value="일식"
                   <c:if test="${scategory != null and scategory.contains('일식')}">checked</c:if>>
            일식
        </label>

        <label>
            <input type="checkbox"
                   name="scategory"
                   value="양식"
                   <c:if test="${scategory != null and scategory.contains('양식')}">checked</c:if>>
            양식
        </label>

        <br><br>
        
        <h4>키워드</h4>

		<label>
		    <input type="checkbox" name="skeyword" value="새벽까지 영업하는">
		    새벽까지 영업하는
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="혼자 식사하기 좋은">
		    혼자 식사하기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="가족외식">
		    가족외식
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="데이트하기 좋은">
		    데이트하기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는">
		    조용하게 식사할 수 있는
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="가성비가 좋은">
		    가성비가 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은">
		    예약하고 방문하기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="포장해서 먹기 좋은">
		    포장해서 먹기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="주차하기 편한">
		    주차하기 편한
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="단체로 방문하기 좋은">
		    단체로 방문하기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="노키즈존">
		    노키즈존
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은">
		    아이와 함께 가기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는">
		    반려동물과 함께 갈 수 있는
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은">
		    간단하게 식사하기 좋은
		</label>
		
		<label>
		    <input type="checkbox" name="skeyword" value="경치가 좋은">
		    경치가 좋은
		</label>

        <button type="submit">필터 적용</button>

    </details>

</form>