<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구독권 구매</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/passList.css">
</head>

<body>

    <%@ include file="../guest/header.jsp" %>
<br>

    <main class="premium-page">
        <section class="premium-header">
            <p class="premium-label">
                IJIB PREMIUM
            </p>
            <h1 class="premium-title-font">
			    이집어때 프리미엄 콘텐츠 이용권
			</h1>
            <p class="premium-description">
                이집어때 프리미엄 콘텐츠 이용권을 구매하시면<br>
                더욱 다양한 맛집 콘텐츠와 편리한 검색 서비스를 이용하실 수 있습니다.
            </p>
        </section>
        <section class="premium-benefits">
            <div class="benefit-item">
                <div class="benefit-number">
                    BENEFIT 01
                </div>
                <h3>
                    모든 맛집 콘텐츠 열람
                </h3>

                <p>
                    이집어때의 콘텐츠 이용권을 구매하시면 맛집 리뷰를 비롯하여 본 사이트에서 제공하는 모든 콘텐츠를 열람하실 수 있습니다.
                </p>

            </div>


            <div class="benefit-item">

                <div class="benefit-number">
                    BENEFIT 02
                </div>

                <h3>
                    더욱 편리한 맛집 검색
                </h3>

                <p>
                    지역별, 예산, 음식 종류, 특징에 따라 내가 원하는 맛집을 정확하게 찾아주는 멀티 검색 기능을 사용하실 수 있습니다.
                </p>

            </div>


            <div class="benefit-item">

                <div class="benefit-number">
                    BENEFIT 03
                </div>

                <h3>
                    나만의 맛집 북마크
                </h3>

                <p>
                   마이 페이지의 북마크 기능을 사용하실 수 있습니다.
                </p>

            </div>

        </section>


        <section class="premium-product-section">

            <div class="section-title">

                <p class="section-label">
                    PREMIUM MEMBERSHIP
                </p>

                <h2>
                    이집어때 프리미엄 이용권
                </h2>

                <p>
                    원하는 기간의 이용권을 선택해보세요.
                </p>

            </div>


            <div class="premium-products">

                <c:forEach var="pass" items="${pass}">

                    <a href="${pageContext.request.contextPath}/member/payForm?pno=${pass.pno}"
                       class="premium-product">

                        <div class="product-image">

                            <img src="${pageContext.request.contextPath}/images/${pass.pimg}"
                                 alt="이집어때 프리미엄 이용권">

                        </div>

                        <div class="product-buy">

                            <span>
                                이용권 구매
                            </span>

                            <span class="arrow">
                                →
                            </span>

                        </div>

                    </a>

                </c:forEach>

            </div>

        </section>


        <!-- 안내 -->
        <section class="premium-notice">

            <p>
                * 이집어때 프리미엄 콘텐츠 이용권은 1개월, 6개월, 1년 단위로 선택하여 구매하실 수 있습니다.
            </p>

            <p>
                * 모든 이용권 금액은 부가세 10%가 포함된 가격입니다.
            </p>

        </section>

    </main>

<br>
    <%@ include file="../guest/footer.jsp" %>

</body>
</html>