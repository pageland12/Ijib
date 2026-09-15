<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원탈퇴</title>

    <link rel="stylesheet"
          type="text/css"
          href="<c:url value='/css/member.css'/>">
</head>

<body>

    <%@ include file="../guest/header.jsp" %>

    <div class="member-page">

        <%@ include file="memberSidebar.jsp" %>

        <main class="member-content">

            <div class="content-title-area">
                <h2>회원탈퇴 <span>DELETE ACCOUNT</span></h2>
            </div>

            <section class="account-list-section">

			
			    <div class="delete-confirm-box">
			
			        <h4 class="delete-confirm-title">
			            정말 탈퇴하시겠습니까?
			        </h4>
			
			        <p class="delete-confirm-text">
			            회원탈퇴를 진행하면 계정 정보가 삭제됩니다.<br>
			            탈퇴 후에는 계정을 복구할 수 없습니다.
			        </p>
			
			        <div class="delete-button-group">
			
			            <form action="<c:url value='/member/memberDelete'/>"
			                  method="post"
			                  style="flex: 1;">
			
			                <button type="submit"
			                        class="delete-button">
			                    탈퇴하기
			                </button>
			
			            </form>
			
			            <a href="<c:url value='/member/myPage'/>"
			               class="delete-cancel">
			                취소
			            </a>
			
			        </div>
			
			    </div>
			
			</section>

        </main>

    </div>

    <%@ include file="../guest/footer.jsp" %>

</body>
</html>