<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>
<link rel="stylesheet" href="<c:url value='/css/memberList.css'/>">
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
	<%@ include file="../admin/adminSearch.jsp" %>

	<div class="list-page">
		<div class="list-container">

			<h3 class="list-title">회원 목록</h3>

			<table class="list-table">
				<thead>
					<tr>
						<th>번호</th>
						<th>이메일</th>
						<th>이름</th>
						<th>성별</th>
						<th>나이</th>
						<th>주소</th>
						<th>전화번호</th>
						<th>권한</th>
						<th>상태</th>
						<th>가입일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="list" items="${list}">
						<tr>
							<td>${list.mno}</td>
							<td class="cell-link">
								<a href="/admin/memberView?mno=${list.mno}">${list.memail}</a>
							</td>
							<td class="cell-link">
								<a href="/admin/memberView?mno=${list.mno}">${list.mname}</a>
							</td>
							<td>${list.mgender}</td>
							<td>${list.mage}</td>
							<td class="cell-addr">${list.maddr}</td>
							<td>${list.mtel}</td>
							<td>
								<span class="auth-badge auth-${list.mauth}">${list.mauth}</span>
							</td>
							<td>
								<span class="status-badge status-${list.mstatus}">
									<c:choose>
										<c:when test="${list.mstatus == 'OPEN'}">활성화</c:when>
										<c:otherwise>비활성화</c:otherwise>
									</c:choose>
								</span>
							</td>
							<td><fmt:formatDate value="${list.mdate}" pattern="yy-MM-dd" /></td>
						</tr>
					</c:forEach>

					<c:if test="${empty list}">
						<tr>
							<td colspan="10" class="list-empty">등록된 회원이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			
			<c:if test="${totalPage > 0}">
			    <div class="pagination">
			
			        <c:if test="${startPage > 1}">
			            <a href="javascript:goPage(${startPage - 1});"
			               class="page-btn">&lt;</a>
			        </c:if>
			
			        <c:forEach var="page"
			                   begin="${startPage}"
			                   end="${endPage}">
			
			            <c:choose>
			                <c:when test="${page == pageNum}">
			                    <span class="page-btn active">${page}</span>
			                </c:when>
			
			                <c:otherwise>
			                    <a href="javascript:goPage(${page});"
			                       class="page-btn">
			                        ${page}
			                    </a>
			                </c:otherwise>
			            </c:choose>
			
			        </c:forEach>
			
			        <c:if test="${endPage < totalPage}">
			            <a href="javascript:goPage(${endPage + 1});"
			               class="page-btn">&gt;</a>
			        </c:if>
			
			    </div>
			    
			    <script>
			    function goPage(n) {
			        var params = new URLSearchParams(window.location.search);
			        params.set('pageNum', n);
			        window.location.search = params.toString();
			    }
			    </script>
			</c:if>

		</div>
	</div>

	<%@ include file="../guest/footer.jsp" %>
</body>
</html>