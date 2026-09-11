<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="search-box">

    <div class="search-title">
        회원 검색
    </div>

    <form action="${pageContext.request.contextPath}/admin/memberSearch"
          method="get">

        <!-- 검색창 -->
        <div class="search-row">

            <input type="text"
                   name="keyword"
                   placeholder="이메일 / 이름 / 전화번호 / 주소"
                   value="${search.keyword}">

            <button type="submit" class="search-btn">
                검색
            </button>

        </div>
        
    <div class="filter-toggle" onclick="toggleFilter()">
	    <span>필터</span>
	    <span id="filterArrow">▼</span>
	</div>

	<div id="filterBox" style="display: none;">
        <!-- 필터 -->
        <div class="filter-box">

            <!-- 성별 -->
            <div class="filter-row">

                <div class="filter-title">
                    성별
                </div>

                <div class="filter-content">

                    <label>
                        <input type="radio"
                               name="mgender"
                               value="M"
                               ${search.mgender == 'M' ? 'checked' : ''}>
                        남성
                    </label>

                    <label>
                        <input type="radio"
                               name="mgender"
                               value="F"
                               ${search.mgender == 'F' ? 'checked' : ''}>
                        여성
                    </label>

                </div>

            </div>


            <!-- 나이 -->
            <div class="filter-row">

                <div class="filter-title">
                    나이
                </div>

                <div class="filter-content">

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="10"
                               ${search.ageGroups != null && search.ageGroups.contains(10) ? 'checked' : ''}>
                        10대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="20"
                               ${search.ageGroups != null && search.ageGroups.contains(20) ? 'checked' : ''}>
                        20대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="30"
                               ${search.ageGroups != null && search.ageGroups.contains(30) ? 'checked' : ''}>
                        30대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="40"
                               ${search.ageGroups != null && search.ageGroups.contains(40) ? 'checked' : ''}>
                        40대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="50"
                               ${search.ageGroups != null && search.ageGroups.contains(50) ? 'checked' : ''}>
                        50대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="60"
                               ${search.ageGroups != null && search.ageGroups.contains(60) ? 'checked' : ''}>
                        60대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="70"
                               ${search.ageGroups != null && search.ageGroups.contains(70) ? 'checked' : ''}>
                        70대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="80"
                               ${search.ageGroups != null && search.ageGroups.contains(80) ? 'checked' : ''}>
                        80대
                    </label>

                    <label>
                        <input type="checkbox"
                               name="ageGroups"
                               value="90"
                               ${search.ageGroups != null && search.ageGroups.contains(90) ? 'checked' : ''}>
                        90대
                    </label>

                </div>

            </div>


            <!-- 지역 -->
            <div class="filter-row">

                <div class="filter-title">
                    지역
                </div>

                <div class="filter-content">

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="서울"
                               ${search.regions != null && search.regions.contains('서울') ? 'checked' : ''}>
                        서울
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="부산"
                               ${search.regions != null && search.regions.contains('부산') ? 'checked' : ''}>
                        부산
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="대구"
                               ${search.regions != null && search.regions.contains('대구') ? 'checked' : ''}>
                        대구
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="인천"
                               ${search.regions != null && search.regions.contains('인천') ? 'checked' : ''}>
                        인천
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="광주"
                               ${search.regions != null && search.regions.contains('광주') ? 'checked' : ''}>
                        광주
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="대전"
                               ${search.regions != null && search.regions.contains('대전') ? 'checked' : ''}>
                        대전
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="울산"
                               ${search.regions != null && search.regions.contains('울산') ? 'checked' : ''}>
                        울산
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="세종"
                               ${search.regions != null && search.regions.contains('세종') ? 'checked' : ''}>
                        세종
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="경기"
                               ${search.regions != null && search.regions.contains('경기') ? 'checked' : ''}>
                        경기
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="강원"
                               ${search.regions != null && search.regions.contains('강원') ? 'checked' : ''}>
                        강원
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="충북"
                               ${search.regions != null && search.regions.contains('충북') ? 'checked' : ''}>
                        충북
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="충남"
                               ${search.regions != null && search.regions.contains('충남') ? 'checked' : ''}>
                        충남
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="전북"
                               ${search.regions != null && search.regions.contains('전북') ? 'checked' : ''}>
                        전북
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="전남"
                               ${search.regions != null && search.regions.contains('전남') ? 'checked' : ''}>
                        전남
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="경북"
                               ${search.regions != null && search.regions.contains('경북') ? 'checked' : ''}>
                        경북
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="경남"
                               ${search.regions != null && search.regions.contains('경남') ? 'checked' : ''}>
                        경남
                    </label>

                    <label>
                        <input type="checkbox"
                               name="regions"
                               value="제주"
                               ${search.regions != null && search.regions.contains('제주') ? 'checked' : ''}>
                        제주
                    </label>

                </div>

            </div>


            <!-- 권한 -->
			<div class="filter-row">
			
			    <div class="filter-title">
			        권한
			    </div>
			
			    <div class="filter-content">
			
			        <label>
			            <input type="checkbox"
			                   name="mauth"
			                   value="NORMAL"
			                   ${search.mauth != null && search.mauth.contains('NORMAL') ? 'checked' : ''}>
			            일반
			        </label>
			
			        <label>
			            <input type="checkbox"
			                   name="mauth"
			                   value="SUBSCRIBER"
			                   ${search.mauth != null && search.mauth.contains('SUBSCRIBER') ? 'checked' : ''}>
			            구독자
			        </label>
			
			        <label>
			            <input type="checkbox"
			                   name="mauth"
			                   value="ADMIN"
			                   ${search.mauth != null && search.mauth.contains('ADMIN') ? 'checked' : ''}>
			            관리자
			        </label>
			
			    </div>
			
			</div>

        </div>


        <!-- 초기화 -->
        <button type="button"
                class="reset-btn"
                onclick="location.href='${pageContext.request.contextPath}/admin/memberSearch'">
            필터 초기화
        </button>
	</div>

    </form>

</div>

<script>
function toggleFilter() {

    const filterBox = document.getElementById("filterBox");
    const arrow = document.getElementById("filterArrow");

    if (filterBox.style.display === "none") {
        filterBox.style.display = "block";
        arrow.textContent = "▲";
    } else {
        filterBox.style.display = "none";
        arrow.textContent = "▼";
    }
}
</script>
