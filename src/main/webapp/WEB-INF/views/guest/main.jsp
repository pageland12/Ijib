<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>이집어때 - 메인페이지</title>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/main.css">

</head>

<body>

    <%@ include file="../guest/header.jsp" %>


    <section class="hero">

        <!-- 블러 배경 이미지 -->
        <div class="hero-bg">

            <img
                src="${pageContext.request.contextPath}/images/main-hero.jpg"
                alt=""
                class="hero-bg-img">

        </div>


			<!-- 히어로 영역 -->
			<section class="hero">
			    <div class="hero-bg">
			        <img src="${pageContext.request.contextPath}/images/hero-bg.jpg" class="hero-bg-img" alt="배경">
			    </div>
			    
			    <!-- 흰색 카드 컨테이너 (main.css의 hero-inner) -->
			    <div class="hero-inner">
			        <!-- 좌측 인사말 -->
			        <div class="hero-greeting">
			            <p class="line">안녕하세요.</p>
			            <p class="line brand">이집어때 입니다.</p>
			            <p class="line">어떤 맛집을 찾으시나요?</p>
			        </div>
			
			        <!-- 우측 검색 영역 -->
			        <div class="hero-search-box">
			            <%@ include file="../guest/headerSearch.jsp" %>
			        </div>
			    </div>
			</section>	

    </section>



    <!-- ===================== 어디로 갈까요 ===================== -->

    <section class="home-section">

        <div class="section-inner">

            <div class="section-head">

                <h2>어디로 갈까요?</h2>

                <a
                    href="${pageContext.request.contextPath}/guest/storeList"
                    class="see-all">

                    모두보기

                </a>

            </div>


            <div class="carousel">

                <button
                    type="button"
                    class="carousel-btn prev"
                    data-target="areaScroll"
                    aria-label="이전">

                    ‹

                </button>
			<div class="chip-scroll" id="areaScroll">

			    <!-- 내 주변 -->
			    <a href="${pageContext.request.contextPath}/guest/storeList" class="area-chip my-location">
			        <span class="chip-icon">📍</span>
			        <span>내 주변</span>
			    </a>
			
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=강원특별자치도" class="area-chip"><span>강원</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=경기" class="area-chip"><span>경기</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=경남" class="area-chip"><span>경남</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=경북" class="area-chip"><span>경북</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=대구" class="area-chip"><span>대구</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=대전" class="area-chip"><span>대전</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=부산" class="area-chip"><span>부산</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=서울" class="area-chip"><span>서울</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=세종특별자치시" class="area-chip"><span>세종</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=울산" class="area-chip"><span>울산</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=인천" class="area-chip"><span>인천</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=전남광주통합특별시" class="area-chip"><span>전남·광주</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=전북특별자치도" class="area-chip"><span>전북</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=제주특별자치도" class="area-chip"><span>제주</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=충남" class="area-chip"><span>충남</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeSearch?ssido=충북" class="area-chip"><span>충북</span></a>
			
			</div>


                <button
                    type="button"
                    class="carousel-btn next"
                    data-target="areaScroll"
                    aria-label="다음">

                    ›

                </button>

            </div>

        </div>

    </section>



    <!-- ===================== 무엇을 먹을까요 ===================== -->

    <section class="home-section food-section">

        <div class="section-inner">

            <div class="section-head">

                <h2>무엇을 먹을까요?</h2>

                <a
                    href="${pageContext.request.contextPath}/guest/storeList"
                    class="see-all">

                    모두보기

                </a>

            </div>


            <div class="carousel">

                <button
                    type="button"
                    class="carousel-btn prev"
                    data-target="foodScroll"
                    aria-label="이전">

                    ‹

                </button>


                <div class="food-scroll" id="foodScroll">


                    <!-- 한식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=한식"
                        class="food-card">

                        <div class="food-thumb food-thumb-1">

                            <span>🍚</span>

                        </div>

                        <span class="food-label">한식</span>

                    </a>


                    <!-- 중식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=중식"
                        class="food-card">

                        <div class="food-thumb food-thumb-2">

                            <span>🥟</span>

                        </div>

                        <span class="food-label">중식</span>

                    </a>


                    <!-- 일식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=일식"
                        class="food-card">

                        <div class="food-thumb food-thumb-3">

                            <span>🍣</span>

                        </div>

                        <span class="food-label">일식</span>

                    </a>


                    <!-- 양식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=양식"
                        class="food-card">

                        <div class="food-thumb food-thumb-4">

                            <span>🍝</span>

                        </div>

                        <span class="food-label">양식</span>

                    </a>


                    <!-- 고기/구이 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=고기/구이"
                        class="food-card">

                        <div class="food-thumb food-thumb-5">

                            <span>🥩</span>

                        </div>

                        <span class="food-label">고기/구이</span>

                    </a>


                    <!-- 닭/오리 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=닭/오리"
                        class="food-card">

                        <div class="food-thumb food-thumb-6">

                            <span>🍗</span>

                        </div>

                        <span class="food-label">닭/오리</span>

                    </a>


                    <!-- 면/분식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=면/분식"
                        class="food-card">

                        <div class="food-thumb food-thumb-7">

                            <span>🍜</span>

                        </div>

                        <span class="food-label">면/분식</span>

                    </a>


                    <!-- 국/탕/백반 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=국/탕/백반"
                        class="food-card">

                        <div class="food-thumb food-thumb-8">

                            <span>🍲</span>

                        </div>

                        <span class="food-label">국/탕/백반</span>

                    </a>


                    <!-- 해산물/회 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=해산물/회"
                        class="food-card">

                        <div class="food-thumb food-thumb-9">

                            <span>🦐</span>

                        </div>

                        <span class="food-label">해산물/회</span>

                    </a>


                    <!-- 카페/디저트 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeSearch?scategory=카페/디저트"
                        class="food-card">

                        <div class="food-thumb food-thumb-10">

                            <span>🍰</span>

                        </div>

                        <span class="food-label">카페/디저트</span>

                    </a>

                </div>


                <button
                    type="button"
                    class="carousel-btn next"
                    data-target="foodScroll"
                    aria-label="다음">

                    ›

                </button>

            </div>

        </div>

    </section>



    <br>


    <!-- ===================== 푸터 ===================== -->

    <%@ include file="../guest/footer.jsp" %>



    <!-- ===================== 메인 캐러셀 JS ===================== -->

    <script>

        (function () {

            function initCarousel(scrollId) {

                var track = document.getElementById(scrollId);

                if (!track) {
                    return;
                }


                var prevBtn =
                    document.querySelector(
                        '.carousel-btn.prev[data-target="' +
                        scrollId +
                        '"]'
                    );


                var nextBtn =
                    document.querySelector(
                        '.carousel-btn.next[data-target="' +
                        scrollId +
                        '"]'
                    );


                if (!prevBtn || !nextBtn) {
                    return;
                }


                function update() {

                    var maxScroll =
                        track.scrollWidth -
                        track.clientWidth;


                    prevBtn.disabled =
                        track.scrollLeft <= 4;


                    nextBtn.disabled =
                        track.scrollLeft >=
                        maxScroll - 4;

                }


                prevBtn.addEventListener(
                    'click',
                    function () {

                        track.scrollBy({
                            left: -track.clientWidth * 0.8,
                            behavior: 'smooth'
                        });

                    }
                );


                nextBtn.addEventListener(
                    'click',
                    function () {

                        track.scrollBy({
                            left: track.clientWidth * 0.8,
                            behavior: 'smooth'
                        });

                    }
                );


                track.addEventListener(
                    'scroll',
                    update
                );


                window.addEventListener(
                    'resize',
                    update
                );


                update();

            }


            initCarousel('areaScroll');

            initCarousel('foodScroll');

        })();

    </script>
	<script>
		document.addEventListener("DOMContentLoaded", function() {
		
		    const filterButton = document.getElementById("filterButton");
		    const filterDropdown = document.getElementById("filterDropdown");
		
		    filterButton.addEventListener("click", function(event) {
		        event.stopPropagation();
		
		        filterDropdown.classList.toggle("active");
		        filterButton.classList.toggle("active");
		    });
		
		    document.addEventListener("click", function(event) {
		
		        if (!filterDropdown.contains(event.target) &&
		            !filterButton.contains(event.target)) {
		
		            filterDropdown.classList.remove("active");
		            filterButton.classList.remove("active");
		        }
		
		    });
		
	});
	</script>

</body>

</html>