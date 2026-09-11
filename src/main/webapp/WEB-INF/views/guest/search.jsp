<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>


<style>

/* =========================================================
   메인 히어로 검색 영역
   ========================================================= */

.hero-search-box {

    position: relative;

    width: 100%;

    max-width: 760px;

    margin: 0 auto;

}


/* =========================================================
   검색 탭
   ========================================================= */

.hero-search-box .search-type {

    display: flex;

    justify-content: center;

    gap: 30px;

    margin-bottom: 15px;

}


.hero-search-box .search-type button {

    background: rgba(255, 255, 255, 0.9);

    border: none;

    padding: 9px 4px;

    font-size: 15px;

    color: #777;

    cursor: pointer;

    border-bottom: 2px solid transparent;

    font-family: inherit;

}


.hero-search-box .search-type button.active {

    color: #2f6fed;

    font-weight: 700;

    border-bottom: 2px solid #2f6fed;

}


/* =========================================================
   검색창 전체
   ========================================================= */

.hero-search-box #totalSearch,
.hero-search-box #storeSearch {

    width: 100%;

}


.hero-search-box #totalFilterForm,
.hero-search-box #storeSearch form {

    position: relative;

    display: flex;

    align-items: center;

    gap: 8px;

    width: 100%;

}


/* =========================================================
   검색 입력 영역
   ========================================================= */

.hero-search-box .search-input-wrap {

    position: relative;

    display: flex;

    align-items: center;

    flex: 1;

    min-width: 0;

    height: 58px;

    background: #ffffff;

    border-radius: 30px;

    padding: 0 12px 0 16px;

    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);

}


.hero-search-box .search-input-wrap > input {

    flex: 1;

    min-width: 0;

    height: 100%;

    border: none;

    outline: none;

    background: transparent;

    font-size: 16px;

    color: #333;

    padding: 0 10px;

}


.hero-search-box .search-input-wrap > input::placeholder {

    color: #999;

}


/* =========================================================
   뒤로가기 버튼
   ========================================================= */

.hero-search-box .search-back-btn {

    flex-shrink: 0;

    width: 34px;

    height: 34px;

    border: none;

    border-radius: 50%;

    background: transparent;

    color: #777;

    font-size: 27px;

    line-height: 1;

    cursor: pointer;

}


.hero-search-box .search-back-btn:hover {

    color: #2f6fed;

}


/* =========================================================
   검색 버튼
   ========================================================= */

.hero-search-box .search-input-wrap > button[type="submit"] {

    flex-shrink: 0;

    height: 40px;

    padding: 0 18px;

    border: none;

    border-radius: 22px;

    background: #2f6fed;

    color: #ffffff;

    font-size: 14px;

    font-weight: 700;

    cursor: pointer;

}


.hero-search-box .search-input-wrap > button[type="submit"]:hover {

    background: #255ed0;

}


/* =========================================================
   자동완성
   ========================================================= */

.hero-search-box .autocomplete-box {

    display: none;

    position: absolute;

    top: calc(100% + 8px);

    left: 0;

    width: 100%;

    background: #ffffff;

    border: 1px solid #ddd;

    border-radius: 12px;

    box-shadow: 0 10px 24px rgba(0, 0, 0, 0.12);

    overflow: hidden;

    z-index: 2000;

}


.hero-search-box .autocomplete-item {

    padding: 13px 16px;

    cursor: pointer;

    font-size: 14px;

    color: #444;

}


.hero-search-box .autocomplete-item:hover {

    background-color: #f5f5f5;

}


.hero-search-box .autocomplete-item em {

    font-style: normal;

    font-weight: bold;

    color: #2f6fed;

}


/* =========================================================
   고급 검색 버튼
   ========================================================= */

.hero-search-box .filter-toggle-btn {

    position: relative;

    flex-shrink: 0;

    width: 42px;

    height: 42px;

    border-radius: 50%;

    border: 1px solid #dfe3e8;

    background: #ffffff;

    display: flex;

    align-items: center;

    justify-content: center;

    cursor: pointer;

    padding: 0;

    transition:
        border-color .15s ease,
        background-color .15s ease;

}


.hero-search-box .filter-toggle-btn:hover {

    border-color: #2f6fed;

    background: #eef4ff;

}


.hero-search-box .filter-toggle-btn.active {

    border-color: #2f6fed;

    background: #eef4ff;

}


.hero-search-box .filter-toggle-btn svg {

    width: 18px;

    height: 18px;

}


.hero-search-box .filter-toggle-btn svg .ft-line {

    stroke: #666666;

}


.hero-search-box .filter-toggle-btn svg .ft-knob {

    stroke: #666666;

    fill: #ffffff;

}


.hero-search-box .filter-toggle-btn.active svg .ft-line,
.hero-search-box .filter-toggle-btn.active svg .ft-knob {

    stroke: #2f6fed;

}


/* =========================================================
   필터 뱃지
   ========================================================= */

.hero-search-box .filter-badge {

    position: absolute;

    top: -4px;

    right: -4px;

    min-width: 17px;

    height: 17px;

    padding: 0 4px;

    border-radius: 999px;

    background: #ff4d4f;

    color: #ffffff;

    font-size: 10px;

    font-weight: 700;

    line-height: 17px;

    text-align: center;

}


/* =========================================================
   고급 검색 패널
   ========================================================= */

.hero-search-box .advanced-filter-panel {

    display: none;

    position: absolute;

    top: calc(100% + 12px);

    right: 0;

    width: 440px;

    max-width: 92vw;

    max-height: 70vh;

    overflow-y: auto;

    background: #ffffff;

    border-radius: 16px;

    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.18);

    padding: 22px 24px 0;

    z-index: 3000;

    text-align: left;

}


.hero-search-box .advanced-filter-panel.open {

    display: block;

}


/* =========================================================
   필터 패널 헤더
   ========================================================= */

.hero-search-box .filter-panel-header {

    position: sticky;

    top: 0;

    background: #ffffff;

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding-bottom: 14px;

    margin-bottom: 4px;

}


.hero-search-box .filter-panel-header h3 {

    margin: 0;

    font-size: 17px;

    color: #222222;

}


.hero-search-box .filter-panel-close {

    border: none;

    background: none;

    font-size: 20px;

    line-height: 1;

    color: #999999;

    cursor: pointer;

    padding: 0;

}


/* =========================================================
   필터 섹션
   ========================================================= */

.hero-search-box .filter-section {

    border-top: 1px solid #eeeeee;

    padding: 16px 0;

}


.hero-search-box .filter-section:first-of-type {

    border-top: none;

    padding-top: 0;

}


.hero-search-box .filter-section h4 {

    margin: 0 0 10px;

    font-size: 14px;

    color: #333333;

}


/* =========================================================
   필터 칩
   ========================================================= */

.hero-search-box .filter-chip-group {

    display: flex;

    flex-wrap: wrap;

    gap: 8px;

}


.hero-search-box .filter-chip-group label {

    display: inline-flex;

    align-items: center;

    gap: 5px;

    padding: 7px 12px;

    border-radius: 999px;

    border: 1px solid #dfe3e8;

    font-size: 13px;

    color: #555555;

    cursor: pointer;

    user-select: none;

}


.hero-search-box .filter-chip-group input {

    accent-color: #2f6fed;

    margin: 0;

}


/* =========================================================
   시군구
   ========================================================= */

.hero-search-box #sigunguArea {

    display: flex;

    flex-wrap: wrap;

    gap: 8px;

    font-size: 13px;

    color: #999999;

}


.hero-search-box #sigunguArea label {

    display: inline-flex;

    align-items: center;

    gap: 5px;

    padding: 7px 12px;

    border-radius: 999px;

    border: 1px solid #dfe3e8;

    font-size: 13px;

    color: #555555;

    cursor: pointer;

}


/* =========================================================
   가격
   ========================================================= */

.hero-search-box .filter-price-row {

    display: flex;

    align-items: center;

    gap: 8px;

    font-size: 13px;

    color: #555555;

}


.hero-search-box .filter-price-row + .filter-price-row {

    margin-top: 10px;

}


.hero-search-box .filter-price-row input[type="number"] {

    width: 110px;

    padding: 7px 10px;

    border: 1px solid #dfe3e8;

    border-radius: 8px;

    font-size: 13px;

}


/* =========================================================
   필터 하단
   ========================================================= */

.hero-search-box .filter-panel-footer {

    position: sticky;

    bottom: 0;

    background: #ffffff;

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding: 14px 0;

    border-top: 1px solid #eeeeee;

    margin-top: 4px;

}


.hero-search-box .filter-reset-link {

    border: none;

    background: none;

    font-size: 13px;

    color: #999999;

    text-decoration: underline;

    cursor: pointer;

    padding: 0;

}


.hero-search-box .filter-apply-btn {

    border: none;

    background: #2f6fed;

    color: #ffffff;

    border-radius: 999px;

    padding: 10px 24px;

    font-size: 14px;

    font-weight: 700;

    cursor: pointer;

}


.hero-search-box .filter-apply-btn:hover {

    background: #255ed0;

}


/* =========================================================
   모바일
   ========================================================= */

@media (max-width: 768px) {

    .hero-search-box {

        max-width: 100%;

        padding: 0 15px;

    }


    .hero-search-box .search-input-wrap {

        height: 52px;

    }


    .hero-search-box .search-input-wrap > input {

        font-size: 14px;

    }


    .hero-search-box .search-input-wrap > button[type="submit"] {

        padding: 0 13px;

    }


    .hero-search-box .advanced-filter-panel {

        width: calc(100vw - 30px);

        right: 0;

    }

}

</style>


<%-- =========================================================
     현재 적용된 필터 개수
     ========================================================= --%>

<c:set var="filterCount" value="0"/>


<c:if test="${scategory != null and fn:length(scategory) > 0}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${skeyword != null and fn:length(skeyword) > 0}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${ssido != null and ssido != ''}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${ssigungu != null and fn:length(ssigungu) > 0}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${sinfo != null and fn:length(sinfo) > 0}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${minPrice != null}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${maxPrice != null}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${sparking != null and sparking != ''}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${sstatus != null and sstatus != ''}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<c:if test="${minRating != null}">
    <c:set var="filterCount" value="${filterCount + 1}"/>
</c:if>


<!-- =========================================================
     검색 종류
     ========================================================= -->

<div class="search-type">

    <button
        type="button"
        id="totalTab"
        onclick="changeSearchType('total')">

        통합검색

    </button>


    <button
        type="button"
        id="storeTab"
        onclick="changeSearchType('store')">

        식당명 검색

    </button>

</div>



<!-- =========================================================
     통합검색
     ========================================================= -->

<div id="totalSearch">

    <form
        action="${pageContext.request.contextPath}/guest/storeSearch"
        method="get"
        id="totalFilterForm">


        <input
            type="hidden"
            name="searchType"
            value="total">


        <div class="search-input-wrap">


            <!-- 뒤로가기 -->

            <button
                type="button"
                class="search-back-btn"
                aria-label="뒤로가기"
                onclick="history.back()">

                &lsaquo;

            </button>


            <!-- 검색어 -->

            <input
                type="text"
                name="keyword"
                value="${keyword}"
                placeholder="음식점이나 메뉴를 검색하세요"
                id="totalKeyword"
                autocomplete="off">


            <!-- 자동완성 -->

            <div
                id="totalAutocomplete"
                class="autocomplete-box">
            </div>


            <!-- 검색 -->

            <button type="submit">

                검색

            </button>


            <!-- 고급 검색 -->

            <button
                type="button"
                class="filter-toggle-btn"
                id="filterToggleBtn"
                aria-label="고급 검색"
                aria-expanded="false"
                onclick="toggleFilterPanel()">


                <svg
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none">


                    <line
                        class="ft-line"
                        x1="4"
                        y1="6"
                        x2="20"
                        y2="6"
                        stroke-width="2"
                        stroke-linecap="round"/>


                    <circle
                        class="ft-knob"
                        cx="9"
                        cy="6"
                        r="2.2"
                        stroke-width="2"/>


                    <line
                        class="ft-line"
                        x1="4"
                        y1="12"
                        x2="20"
                        y2="12"
                        stroke-width="2"
                        stroke-linecap="round"/>


                    <circle
                        class="ft-knob"
                        cx="16"
                        cy="12"
                        r="2.2"
                        stroke-width="2"/>


                    <line
                        class="ft-line"
                        x1="4"
                        y1="18"
                        x2="20"
                        y2="18"
                        stroke-width="2"
                        stroke-linecap="round"/>


                    <circle
                        class="ft-knob"
                        cx="11"
                        cy="18"
                        r="2.2"
                        stroke-width="2"/>

                </svg>


                <c:if test="${filterCount > 0}">

                    <span class="filter-badge">

                        ${filterCount}

                    </span>

                </c:if>

            </button>


            <!-- =================================================
                 고급 검색 패널
                 ================================================= -->

            <div
                class="advanced-filter-panel"
                id="advancedFilterPanel">


                <!-- 헤더 -->

                <div class="filter-panel-header">

                    <h3>고급 검색</h3>

                    <button
                        type="button"
                        class="filter-panel-close"
                        aria-label="닫기"
                        onclick="toggleFilterPanel(false)">

                        &times;

                    </button>

                </div>



                <!-- =================================================
                     분류
                     ================================================= -->

                <div class="filter-section">

                    <h4>분류</h4>

                    <div class="filter-chip-group">


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="고기/구이"
                                <c:if test="${scategory != null and fn:contains(scategory, '고기/구이')}">
                                    checked
                                </c:if>>

                            고기/구이

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="국/탕/백반"
                                <c:if test="${scategory != null and fn:contains(scategory, '국/탕/백반')}">
                                    checked
                                </c:if>>

                            국/탕/백반

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="닭/오리"
                                <c:if test="${scategory != null and fn:contains(scategory, '닭/오리')}">
                                    checked
                                </c:if>>

                            닭/오리

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="면/분식"
                                <c:if test="${scategory != null and fn:contains(scategory, '면/분식')}">
                                    checked
                                </c:if>>

                            면/분식

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="양식"
                                <c:if test="${scategory != null and fn:contains(scategory, '양식')}">
                                    checked
                                </c:if>>

                            양식

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="일식"
                                <c:if test="${scategory != null and fn:contains(scategory, '일식')}">
                                    checked
                                </c:if>>

                            일식

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="중식"
                                <c:if test="${scategory != null and fn:contains(scategory, '중식')}">
                                    checked
                                </c:if>>

                            중식

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="카페/디저트"
                                <c:if test="${scategory != null and fn:contains(scategory, '카페/디저트')}">
                                    checked
                                </c:if>>

                            카페/디저트

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="한식"
                                <c:if test="${scategory != null and fn:contains(scategory, '한식')}">
                                    checked
                                </c:if>>

                            한식

                        </label>


                        <label>

                            <input
                                type="checkbox"
                                name="scategory"
                                value="해산물/회"
                                <c:if test="${scategory != null and fn:contains(scategory, '해산물/회')}">
                                    checked
                                </c:if>>

                            해산물/회

                        </label>

                    </div>

                </div>



                <!-- =================================================
                     키워드
                     ================================================= -->

                <div class="filter-section">

                    <h4>키워드</h4>

                    <div class="filter-chip-group">


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

                    </div>

                </div>



                <!-- =================================================
                     지역
                     ================================================= -->

                <div class="filter-section">

                    <h4>지역</h4>

                    <div class="filter-chip-group">


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="강원특별자치도"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '강원특별자치도'}">checked</c:if>>

                            강원특별자치도

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="경기"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '경기'}">checked</c:if>>

                            경기

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="경남"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '경남'}">checked</c:if>>

                            경남

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="경북"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '경북'}">checked</c:if>>

                            경북

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="대구"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '대구'}">checked</c:if>>

                            대구

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="대전"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '대전'}">checked</c:if>>

                            대전

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="부산"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '부산'}">checked</c:if>>

                            부산

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="서울"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '서울'}">checked</c:if>>

                            서울

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="세종특별자치시"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '세종특별자치시'}">checked</c:if>>

                            세종특별자치시

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="울산"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '울산'}">checked</c:if>>

                            울산

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="인천"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '인천'}">checked</c:if>>

                            인천

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="전남광주통합특별시"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '전남광주통합특별시'}">checked</c:if>>

                            전남광주통합특별시

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="전북특별자치도"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '전북특별자치도'}">checked</c:if>>

                            전북특별자치도

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="제주특별자치도"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '제주특별자치도'}">checked</c:if>>

                            제주특별자치도

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="충남"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '충남'}">checked</c:if>>

                            충남

                        </label>


                        <label>
                            <input
                                type="radio"
                                name="ssido"
                                value="충북"
                                onchange="showSigungu()"
                                <c:if test="${ssido == '충북'}">checked</c:if>>

                            충북

                        </label>

                    </div>

                </div>



                <!-- =================================================
                     시군구
                     ================================================= -->

                <div class="filter-section">

                    <h4>시군구</h4>

                    <div id="sigunguArea">

                        시도를 먼저 선택해주세요.

                    </div>

                </div>



                <!-- =================================================
                     가격
                     ================================================= -->

                <div class="filter-section">

                    <h4>가격</h4>


                    <div class="filter-price-row">

                        <label>최소 가격</label>

                        <input
                            type="number"
                            name="minPrice"
                            value="${minPrice}"
                            placeholder="예: 10000"
                            min="0">

                        원

                    </div>


                    <div class="filter-price-row">

                        <label>최대 가격</label>

                        <input
                            type="number"
                            name="maxPrice"
                            value="${maxPrice}"
                            placeholder="예: 30000"
                            min="0">

                        원

                    </div>

                </div>



                <!-- =================================================
                     영업요일
                     ================================================= -->

                <div class="filter-section">

                    <h4>영업요일</h4>

                    <div class="filter-chip-group">


                        <label>
                            <input type="checkbox" name="sinfo" value="월">
                            월
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="화">
                            화
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="수">
                            수
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="목">
                            목
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="금">
                            금
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="토">
                            토
                        </label>


                        <label>
                            <input type="checkbox" name="sinfo" value="일">
                            일
                        </label>

                    </div>

                </div>



                <!-- =================================================
                     주차 여부
                     ================================================= -->

                <div class="filter-section">

                    <h4>주차 여부</h4>

                    <div class="filter-chip-group">


                        <label>

                            <input
                                type="radio"
                                name="sparking"
                                value="가능"
                                <c:if test="${sparking == '가능'}">checked</c:if>>

                            주차 가능

                        </label>


                        <label>

                            <input
                                type="radio"
                                name="sparking"
                                value="불가능"
                                <c:if test="${sparking == '불가능'}">checked</c:if>>

                            주차 불가능

                        </label>

                    </div>

                </div>



                <!-- =================================================
                     영업 상태
                     ================================================= -->

                <div class="filter-section">

                    <h4>영업 상태</h4>

                    <div class="filter-chip-group">


                        <label>

                            <input
                                type="radio"
                                name="sstatus"
                                value="OPEN"
                                <c:if test="${sstatus == 'OPEN'}">checked</c:if>>

                            영업중

                        </label>


                        <label>

                            <input
                                type="radio"
                                name="sstatus"
                                value="CLOSE"
                                <c:if test="${sstatus == 'CLOSE'}">checked</c:if>>

                            영업종료

                        </label>

                    </div>

                </div>



                <!-- =================================================
                     별점
                     ================================================= -->

                <div class="filter-section">

                    <h4>별점</h4>

                    <div class="filter-chip-group">


                        <label>

                            <input
                                type="radio"
                                name="minRating"
                                value="4"
                                <c:if test="${minRating == 4}">checked</c:if>>

                            4점 이상

                        </label>


                        <label>

                            <input
                                type="radio"
                                name="minRating"
                                value="3"
                                <c:if test="${minRating == 3}">checked</c:if>>

                            3점 이상

                        </label>


                        <label>

                            <input
                                type="radio"
                                name="minRating"
                                value="2"
                                <c:if test="${minRating == 2}">checked</c:if>>

                            2점 이상

                        </label>


                        <label>

                            <input
                                type="radio"
                                name="minRating"
                                value="1"
                                <c:if test="${minRating == 1}">checked</c:if>>

                            1점 이상

                        </label>

                    </div>

                </div>



                <!-- =================================================
                     필터 버튼
                     ================================================= -->

                <div class="filter-panel-footer">

                    <button
                        type="button"
                        class="filter-reset-link"
                        onclick="resetFilters()">

                        전체 해제

                    </button>


                    <button
                        type="submit"
                        class="filter-apply-btn">

                        필터 적용

                    </button>

                </div>


            </div>

        </div>

    </form>

</div>



<!-- =========================================================
     식당명 검색
     ========================================================= -->

<div
    id="storeSearch"
    style="display:none;">

    <form
        action="${pageContext.request.contextPath}/guest/storeSearch"
        method="get">


        <input
            type="hidden"
            name="searchType"
            value="store">


        <div class="search-input-wrap">


            <button
                type="button"
                class="search-back-btn"
                aria-label="뒤로가기"
                onclick="history.back()">

                &lsaquo;

            </button>


            <input
                type="text"
                name="keyword"
                value="${keyword}"
                placeholder="식당명을 검색하세요"
                id="storeKeyword"
                autocomplete="off">


            <div
                id="storeAutocomplete"
                class="autocomplete-box">
            </div>


            <button type="submit">

                검색

            </button>

        </div>

    </form>

</div>



<script>

/* =========================================================
   검색 종류 변경
   ========================================================= */

function changeSearchType(type) {

    const totalSearch =
        document.getElementById("totalSearch");

    const storeSearch =
        document.getElementById("storeSearch");

    const totalTab =
        document.getElementById("totalTab");

    const storeTab =
        document.getElementById("storeTab");


    if (type === "total") {

        totalSearch.style.display = "block";

        storeSearch.style.display = "none";

        totalTab.classList.add("active");

        storeTab.classList.remove("active");

    }


    else if (type === "store") {

        totalSearch.style.display = "none";

        storeSearch.style.display = "block";

        storeTab.classList.add("active");

        totalTab.classList.remove("active");


        /* 식당명 검색으로 변경하면 고급 검색 닫기 */

        toggleFilterPanel(false);

    }

}



/* =========================================================
   시군구 목록
   ========================================================= */

function showSigungu() {

    const selected =
        document.querySelector(
            'input[name="ssido"]:checked'
        );


    const area =
        document.getElementById("sigunguArea");


    area.innerHTML = "";


    if (!selected) {

        area.innerHTML =
            "시도를 먼저 선택해주세요.";

        return;

    }


    const sido = selected.value;


    const sigunguMap = {


        "강원특별자치도": [

            "강릉시",
            "고성군",
            "동해시",
            "삼척시",
            "속초시",
            "양양군",
            "영월군",
            "원주시",
            "인제군",
            "정선군",
            "철원군",
            "춘천시",
            "태백시",
            "평창군",
            "홍천군",
            "횡성군"

        ],


        "경기": [

            "고양시",
            "과천시",
            "광주시",
            "군포시",
            "김포시",
            "남양주시",
            "동두천시",
            "부천시",
            "성남시",
            "수원시",
            "시흥시",
            "안산시",
            "안성시",
            "안양시",
            "양평군",
            "여주시",
            "오산시",
            "용인시",
            "의왕시",
            "의정부시",
            "이천시",
            "파주시",
            "평택시",
            "포천시",
            "화성시"

        ],


        "경남": [

            "거제시",
            "거창군",
            "김해시",
            "남해군",
            "밀양시",
            "사천시",
            "양산시",
            "의령군",
            "진주시",
            "창녕군",
            "창원시",
            "통영시",
            "하동군"

        ],


        "경북": [

            "경산시",
            "경주시",
            "고령군",
            "구미시",
            "김천시",
            "상주시",
            "안동시",
            "영주시",
            "영천시",
            "예천군",
            "울진군",
            "청송군",
            "칠곡군",
            "포항시"

        ],


        "대구": [

            "군위군",
            "남구",
            "달서구",
            "달성군",
            "동구",
            "북구",
            "서구",
            "수성구",
            "중구"

        ],


        "대전": [

            "대덕구",
            "동구",
            "서구",
            "유성구",
            "중구"

        ],


        "부산": [

            "강서구",
            "금정구",
            "기장군",
            "남구",
            "동구",
            "동래구",
            "부산진구",
            "사상구",
            "사하구",
            "서구",
            "수영구",
            "연제구",
            "영도구",
            "중구",
            "해운대구"

        ],


        "서울": [

            "강남구",
            "강동구",
            "강북구",
            "강서구",
            "관악구",
            "광진구",
            "구로구",
            "금천구",
            "노원구",
            "도봉구",
            "동대문구",
            "동작구",
            "마포구",
            "서대문구",
            "서초구",
            "성북구",
            "송파구",
            "양천구",
            "영등포구",
            "용산구",
            "은평구",
            "종로구",
            "중구",
            "중랑구"

        ],


        "세종특별자치시": [

            "부강면",
            "연서면",
            "장군면",
            "조치원읍"

        ],


        "울산": [

            "남구",
            "울주군",
            "중구"

        ],


        "인천": [

            "강화군",
            "계양구",
            "남동구",
            "미추홀구",
            "부평구",
            "연수구",
            "옹진군",
            "제물포구"

        ],


        "전남광주통합특별시": [

            "강진군",
            "고흥군",
            "광산구",
            "광양시",
            "구례군",
            "나주시",
            "남구",
            "담양군",
            "동구",
            "목포시",
            "무안군",
            "보성군",
            "북구",
            "서구",
            "순천시",
            "여수시",
            "영암군",
            "함평군",
            "해남군",
            "화순군"

        ],


        "전북특별자치도": [

            "고창군",
            "군산시",
            "김제시",
            "남원시",
            "부안군",
            "익산시",
            "임실군",
            "전주시",
            "정읍시"

        ],


        "제주특별자치도": [

            "서귀포시",
            "제주시"

        ],


        "충남": [

            "공주시",
            "금산군",
            "논산시",
            "당진시",
            "보령시",
            "부여군",
            "서산시",
            "서천군",
            "아산시",
            "예산군",
            "천안시",
            "청양군",
            "태안군",
            "홍성군"

        ],


        "충북": [

            "괴산군",
            "단양군",
            "보은군",
            "영동군",
            "옥천군",
            "음성군",
            "제천시",
            "증평군",
            "진천군",
            "청주시",
            "충주시"

        ]

    };


    const list = sigunguMap[sido];


    if (!list) {

        area.innerHTML =
            "시군구 정보가 없습니다.";

        return;

    }


    list.forEach(function (sigungu) {

        const label =
            document.createElement("label");


        const checkbox =
            document.createElement("input");


        checkbox.type = "checkbox";

        checkbox.name = "ssigungu";

        checkbox.value = sigungu;


        /*
         * 기존 선택값이 있으면 유지
         */

        const selectedSigungu =
            "${ssigungu}";


        if (
            selectedSigungu &&
            selectedSigungu.includes(sigungu)
        ) {

            checkbox.checked = true;

        }


        label.appendChild(checkbox);

        label.appendChild(
            document.createTextNode(" " + sigungu)
        );


        area.appendChild(label);

    });

}



/* =========================================================
   고급 검색 열기 / 닫기
   ========================================================= */

function toggleFilterPanel(forceOpen) {

    const panel =
        document.getElementById(
            "advancedFilterPanel"
        );


    const btn =
        document.getElementById(
            "filterToggleBtn"
        );


    if (!panel || !btn) {

        return;

    }


    const shouldOpen =
        (typeof forceOpen === "boolean")
            ? forceOpen
            : !panel.classList.contains("open");


    if (shouldOpen) {

        panel.classList.add("open");

        btn.classList.add("active");

        btn.setAttribute(
            "aria-expanded",
            "true"
        );

    }

    else {

        panel.classList.remove("open");

        btn.classList.remove("active");

        btn.setAttribute(
            "aria-expanded",
            "false"
        );

    }

}



/* =========================================================
   바깥 클릭 시 필터 닫기
   ========================================================= */

document.addEventListener(
    "click",
    function (event) {

        const panel =
            document.getElementById(
                "advancedFilterPanel"
            );


        const btn =
            document.getElementById(
                "filterToggleBtn"
            );


        if (
            !panel ||
            !panel.classList.contains("open")
        ) {

            return;

        }


        if (
            panel.contains(event.target) ||
            (btn && btn.contains(event.target))
        ) {

            return;

        }


        toggleFilterPanel(false);

    }
);



/* =========================================================
   필터 패널 내부 클릭 전파 방지
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        const panel =
            document.getElementById(
                "advancedFilterPanel"
            );


        if (panel) {

            panel.addEventListener(
                "click",
                function (event) {

                    event.stopPropagation();

                }
            );

        }

    }
);



/* =========================================================
   전체 해제
   ========================================================= */

function resetFilters() {

    const panel =
        document.getElementById(
            "advancedFilterPanel"
        );


    if (!panel) {

        return;

    }


    /*
     * 체크박스 해제
     */

    panel
        .querySelectorAll(
            'input[type="checkbox"]'
        )
        .forEach(
            function (el) {

                el.checked = false;

            }
        );


    /*
     * 라디오 해제
     */

    panel
        .querySelectorAll(
            'input[type="radio"]'
        )
        .forEach(
            function (el) {

                el.checked = false;

            }
        );


    /*
     * 가격 초기화
     */

    panel
        .querySelectorAll(
            'input[type="number"]'
        )
        .forEach(
            function (el) {

                el.value = "";

            }
        );


    showSigungu();

}



/* =========================================================
   자동완성
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {


        const totalKeyword =
            document.getElementById(
                "totalKeyword"
            );


        const storeKeyword =
            document.getElementById(
                "storeKeyword"
            );


        const totalAutocomplete =
            document.getElementById(
                "totalAutocomplete"
            );


        const storeAutocomplete =
            document.getElementById(
                "storeAutocomplete"
            );



        /* =====================================================
           통합검색 자동완성
           ===================================================== */

        if (totalKeyword) {

            totalKeyword.addEventListener(
                "input",
                function () {

                    const keyword =
                        this.value.trim();


                    if (keyword.length === 0) {

                        totalAutocomplete.innerHTML =
                            "";

                        totalAutocomplete.style.display =
                            "none";

                        return;

                    }


                    autocomplete(
                        keyword,
                        "total",
                        totalAutocomplete,
                        totalKeyword
                    );

                }
            );

        }



        /* =====================================================
           식당명 검색 자동완성
           ===================================================== */

        if (storeKeyword) {

            storeKeyword.addEventListener(
                "input",
                function () {

                    const keyword =
                        this.value.trim();


                    if (keyword.length === 0) {

                        storeAutocomplete.innerHTML =
                            "";

                        storeAutocomplete.style.display =
                            "none";

                        return;

                    }


                    autocomplete(
                        keyword,
                        "store",
                        storeAutocomplete,
                        storeKeyword
                    );

                }
            );

        }



        /* =====================================================
           자동완성 요청
           ===================================================== */

        function autocomplete(
            keyword,
            searchType,
            autocompleteBox,
            input
        ) {


            fetch(
                "${pageContext.request.contextPath}/guest/storeAutocomplete"
                + "?keyword="
                + encodeURIComponent(keyword)
                + "&searchType="
                + encodeURIComponent(searchType)
            )


            .then(
                response => response.json()
            )


            .then(
                data => {


                    autocompleteBox.innerHTML =
                        "";


                    if (
                        !data ||
                        data.length === 0
                    ) {

                        autocompleteBox.style.display =
                            "none";

                        return;

                    }


                    data.forEach(
                        function (item) {


                            const div =
                                document.createElement(
                                    "div"
                                );


                            div.className =
                                "autocomplete-item";


                            /*
                             * 서버에서 highlight가 내려오면
                             * 그대로 사용
                             */

                            div.innerHTML =
                                item.highlight;


                            div.addEventListener(
                                "click",
                                function () {


                                    input.value =
                                        item.sname;


                                    autocompleteBox.innerHTML =
                                        "";


                                    autocompleteBox.style.display =
                                        "none";

                                }
                            );


                            autocompleteBox.appendChild(
                                div
                            );

                        }
                    );


                    autocompleteBox.style.display =
                        "block";

                }
            )


            .catch(
                error => {


                    console.error(
                        "자동완성 오류:",
                        error
                    );


                    autocompleteBox.innerHTML =
                        "";


                    autocompleteBox.style.display =
                        "none";

                }
            );

        }

    }
);



/* =========================================================
   초기 화면
   ========================================================= */

document.addEventListener(
    "DOMContentLoaded",
    function () {

        changeSearchType("total");


        /*
         * 이미 시도가 선택되어 있는 경우
         * 시군구도 바로 표시
         */

        const selectedSido =
            document.querySelector(
                'input[name="ssido"]:checked'
            );


        if (selectedSido) {

            showSigungu();

        }

    }
);

</script>