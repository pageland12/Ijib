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
<script src="/js/main.js" type="text/javascript"></script>

</head>

<body onload="goMainPopup()">

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
			    <a href="#" id="nearbyBtn" class="area-chip my-location">
				    <span class="chip-icon">📍</span>
				    <span>내 주변</span>
				</a>
			
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=강원특별자치도" class="area-chip"><span>강원</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=경기" class="area-chip"><span>경기</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=경남" class="area-chip"><span>경남</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=경북" class="area-chip"><span>경북</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=대구" class="area-chip"><span>대구</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=대전" class="area-chip"><span>대전</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=부산" class="area-chip"><span>부산</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=서울" class="area-chip"><span>서울</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=세종특별자치시" class="area-chip"><span>세종</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=울산" class="area-chip"><span>울산</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=인천" class="area-chip"><span>인천</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=전남광주통합특별시" class="area-chip"><span>전남·광주</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=전북특별자치도" class="area-chip"><span>전북</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=제주특별자치도" class="area-chip"><span>제주</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=충남" class="area-chip"><span>충남</span></a>
			    <a href="${pageContext.request.contextPath}/guest/storeList?ssido=충북" class="area-chip"><span>충북</span></a>
			
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
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=한식"
                        class="food-card">

                        <div class="food-thumb food-thumb-1">

                            <span>🍚</span>

                        </div>

                        <span class="food-label">한식</span>

                    </a>


                    <!-- 중식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=중식"
                        class="food-card">

                        <div class="food-thumb food-thumb-2">

                            <span>🥟</span>

                        </div>

                        <span class="food-label">중식</span>

                    </a>


                    <!-- 일식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=일식"
                        class="food-card">

                        <div class="food-thumb food-thumb-3">

                            <span>🍣</span>

                        </div>

                        <span class="food-label">일식</span>

                    </a>


                    <!-- 양식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=양식"
                        class="food-card">

                        <div class="food-thumb food-thumb-4">

                            <span>🍝</span>

                        </div>

                        <span class="food-label">양식</span>

                    </a>


                    <!-- 고기/구이 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=고기/구이"
                        class="food-card">

                        <div class="food-thumb food-thumb-5">

                            <span>🥩</span>

                        </div>

                        <span class="food-label">고기/구이</span>

                    </a>


                    <!-- 닭/오리 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=닭/오리"
                        class="food-card">

                        <div class="food-thumb food-thumb-6">

                            <span>🍗</span>

                        </div>

                        <span class="food-label">닭/오리</span>

                    </a>


                    <!-- 면/분식 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=면/분식"
                        class="food-card">

                        <div class="food-thumb food-thumb-7">

                            <span>🍜</span>

                        </div>

                        <span class="food-label">면/분식</span>

                    </a>


                    <!-- 국/탕/백반 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=국/탕/백반"
                        class="food-card">

                        <div class="food-thumb food-thumb-8">

                            <span>🍲</span>

                        </div>

                        <span class="food-label">국/탕/백반</span>

                    </a>


                    <!-- 해산물/회 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=해산물/회"
                        class="food-card">

                        <div class="food-thumb food-thumb-9">

                            <span>🦐</span>

                        </div>

                        <span class="food-label">해산물/회</span>

                    </a>


                    <!-- 카페/디저트 -->

                    <a
                        href="${pageContext.request.contextPath}/guest/storeList?scategory=카페/디저트"
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
    
	<!-- ===================== 오늘 뭐 먹지? ===================== -->
	<section class="home-section random-section">
	    <div class="section-inner">
	        <div class="section-head">
	            <h2>오늘 뭐 먹지? 🤔</h2>
	            <span class="section-sub">고민될 땐 랜덤으로 골라보세요!</span>
	        </div>
	
	        <!-- 원래의 중앙 집중형 박스 레이아웃을 다듬은 형태 -->
	        <div class="random-card-box">
	            <button type="button" class="random-btn" id="randomCategoryBtn">
	                🎲 랜덤으로 뽑기
	            </button>
	
	            <div class="random-result-area">
				    <span class="result-label">오늘의 추천 카테고리는</span>
				    <a href="#" class="random-category-link" id="randomCategoryLink">
				        <span class="random-category-name empty" id="randomCategoryName">
				            버튼을 눌러주세요
				        </span>
				    </a>
				</div>
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
		
		 	// 메인 화면처럼 해당 버튼/드롭다운이 없을 때는 건너뛰도록 방어 조건 추가
		    if (filterButton && filterDropdown) {
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
		    }
		
	});
	</script>
	<script>
	document.getElementById('nearbyBtn').addEventListener('click', function(e) {
	    e.preventDefault();
	
	    if (!navigator.geolocation) {
	        alert('이 브라우저에서는 위치 정보를 사용할 수 없습니다.');
	        return;
	    }
	
	    navigator.geolocation.getCurrentPosition(
	        function(position) {
	
	            const lat = position.coords.latitude;
	            const lon = position.coords.longitude;
	            const contextPath = '${pageContext.request.contextPath}';
	
	            location.href =
	                contextPath + '/guest/nearby?lat=' +
	                encodeURIComponent(lat) +
	                '&lon=' +
	                encodeURIComponent(lon);
	        },
	
	        function(error) {
	            alert('현재 위치를 가져올 수 없습니다.');
	        }
	    );
	});
	</script>
	
	<script>
	    // 카테고리명과 해당하는 이모지를 객체 배열로 구성
	    const randomCategoryData = [
	        { name: "한식", emoji: "🍚" },
	        { name: "중식", emoji: "🥟" },
	        { name: "일식", emoji: "🍣" },
	        { name: "양식", emoji: "🍝" },
	        { name: "고기/구이", emoji: "🥩" },
	        { name: "닭/오리", emoji: "🍗" },
	        { name: "면/분식", emoji: "🍜" },
	        { name: "국/탕/백반", emoji: "🍲" },
	        { name: "해산물/회", emoji: "🦐" },
	        { name: "카페/디저트", emoji: "🍰" }
	    ];
	
	    const randomCategoryBtn = document.getElementById("randomCategoryBtn");
	    const randomCategoryName = document.getElementById("randomCategoryName");
	    const randomCategoryLink = document.getElementById("randomCategoryLink");
	
	    randomCategoryBtn.addEventListener("click", function () {
	        // 1. 랜덤 인덱스 뽑기
	        const randomIndex = Math.floor(Math.random() * randomCategoryData.length);
	        const selected = randomCategoryData[randomIndex];
	
	        // 2. 이모지와 텍스트 함께 표시 (예: 🍣 일식)
	        randomCategoryName.textContent = selected.emoji + " " + selected.name;
	
	        // 3. 스타일 클래스 적용 (empty 클래스 제거 및 애니메이션 재실행)
	        randomCategoryName.classList.remove("empty");
	        randomCategoryName.classList.remove("show");
	        void randomCategoryName.offsetWidth; // 리플로우 강제 (애니메이션 리셋)
	        randomCategoryName.classList.add("show");
	
	        // 4. 클릭 시 해당 카테고리 페이지로 이동하도록 URL 설정
	        randomCategoryLink.href =
	            "${pageContext.request.contextPath}/guest/storeList?scategory="
	            + encodeURIComponent(selected.name);
	    });
	</script>

</body>

</html>