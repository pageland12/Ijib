<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- 분리된 CSS 불러오기 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerSearch.css">

<div class="search-container-relative">

    <!-- 탭 선택 (중앙 상단) -->
    <div class="search-tab-group">
        <button type="button" id="totalTab" class="tab-btn ${empty param.searchType || param.searchType == 'total' ? 'active' : ''}" onclick="changeSearchType('total')">통합검색</button>
        <button type="button" id="storeTab" class="tab-btn ${param.searchType == 'store' ? 'active' : ''}" onclick="changeSearchType('store')">식당명 검색</button>
    </div>

    <!-- 1. 통합 검색 영역 -->
    <div id="totalSearch" style="width: 100%; display: ${empty param.searchType || param.searchType == 'total' ? 'block' : 'none'};">
        <form action="${pageContext.request.contextPath}/guest/storeSearch" method="get" class="search-form-wrap">
            <input type="hidden" name="searchType" value="total">

            <div class="search-bar-box">
                <span class="search-icon-left">🔍</span>
                <input type="text" name="keyword" value="${param.keyword}" placeholder="음식점이나 메뉴를 검색하세요" class="search-input-field" autocomplete="off">
                <button type="button" id="filterToggleBtn" class="btn-filter-trigger" aria-label="필터" onclick="toggleFilterPanel()">
                    ⚙️
                </button>
            </div>

            <!-- ================= 고급 검색 패널 (전체 필터) ================= -->
            <div class="advanced-filter-panel" id="advancedFilterPanel">
                
                <!-- 헤더 -->
                <div class="filter-panel-header">
                    <h3>고급 검색</h3>
                    <button type="button" class="filter-panel-close" aria-label="닫기" onclick="toggleFilterPanel(false)">&times;</button>
                </div>

                <!-- 분류 -->
                <div class="filter-section">
                    <h4>분류</h4>
                    <div class="filter-chip-group">
                        <label><input type="checkbox" name="scategory" value="고기/구이" <c:if test="${scategory != null and fn:contains(scategory, '고기/구이')}">checked</c:if>> 고기/구이</label>
                        <label><input type="checkbox" name="scategory" value="국/탕/백반" <c:if test="${scategory != null and fn:contains(scategory, '국/탕/백반')}">checked</c:if>> 국/탕/백반</label>
                        <label><input type="checkbox" name="scategory" value="닭/오리" <c:if test="${scategory != null and fn:contains(scategory, '닭/오리')}">checked</c:if>> 닭/오리</label>
                        <label><input type="checkbox" name="scategory" value="면/분식" <c:if test="${scategory != null and fn:contains(scategory, '면/분식')}">checked</c:if>> 면/분식</label>
                        <label><input type="checkbox" name="scategory" value="양식" <c:if test="${scategory != null and fn:contains(scategory, '양식')}">checked</c:if>> 양식</label>
                        <label><input type="checkbox" name="scategory" value="일식" <c:if test="${scategory != null and fn:contains(scategory, '일식')}">checked</c:if>> 일식</label>
                        <label><input type="checkbox" name="scategory" value="중식" <c:if test="${scategory != null and fn:contains(scategory, '중식')}">checked</c:if>> 중식</label>
                        <label><input type="checkbox" name="scategory" value="카페/디저트" <c:if test="${scategory != null and fn:contains(scategory, '카페/디저트')}">checked</c:if>> 카페/디저트</label>
                        <label><input type="checkbox" name="scategory" value="한식" <c:if test="${scategory != null and fn:contains(scategory, '한식')}">checked</c:if>> 한식</label>
                        <label><input type="checkbox" name="scategory" value="해산물/회" <c:if test="${scategory != null and fn:contains(scategory, '해산물/회')}">checked</c:if>> 해산물/회</label>
                    </div>
                </div>

                <!-- 키워드 -->
                <div class="filter-section">
                    <h4>키워드</h4>
                    <div class="filter-chip-group">
                        <label><input type="checkbox" name="skeyword" value="새벽까지 영업하는"> 새벽까지 영업하는</label>
                        <label><input type="checkbox" name="skeyword" value="혼자 식사하기 좋은"> 혼자 식사하기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="가족외식"> 가족외식</label>
                        <label><input type="checkbox" name="skeyword" value="데이트하기 좋은"> 데이트하기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="조용하게 식사할 수 있는"> 조용하게 식사할 수 있는</label>
                        <label><input type="checkbox" name="skeyword" value="가성비가 좋은"> 가성비가 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="예약하고 방문하기 좋은"> 예약하고 방문하기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="포장해서 먹기 좋은"> 포장해서 먹기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="주차하기 편한"> 주차하기 편한</label>
                        <label><input type="checkbox" name="skeyword" value="단체로 방문하기 좋은"> 단체로 방문하기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="노키즈존"> 노키즈존</label>
                        <label><input type="checkbox" name="skeyword" value="아이와 함께 가기 좋은"> 아이와 함께 가기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="반려동물과 함께 갈 수 있는"> 반려동물과 함께 갈 수 있는</label>
                        <label><input type="checkbox" name="skeyword" value="간단하게 식사하기 좋은"> 간단하게 식사하기 좋은</label>
                        <label><input type="checkbox" name="skeyword" value="경치가 좋은"> 경치가 좋은</label>
                    </div>
                </div>

                <!-- 지역(시/도) -->
                <div class="filter-section">
                    <h4>지역</h4>
                    <div class="filter-chip-group">
                        <label><input type="radio" name="ssido" value="강원특별자치도" onchange="showSigungu()" <c:if test="${ssido == '강원특별자치도'}">checked</c:if>> 강원특별자치도</label>
                        <label><input type="radio" name="ssido" value="경기" onchange="showSigungu()" <c:if test="${ssido == '경기'}">checked</c:if>> 경기</label>
                        <label><input type="radio" name="ssido" value="경남" onchange="showSigungu()" <c:if test="${ssido == '경남'}">checked</c:if>> 경남</label>
                        <label><input type="radio" name="ssido" value="경북" onchange="showSigungu()" <c:if test="${ssido == '경북'}">checked</c:if>> 경북</label>
                        <label><input type="radio" name="ssido" value="대구" onchange="showSigungu()" <c:if test="${ssido == '대구'}">checked</c:if>> 대구</label>
                        <label><input type="radio" name="ssido" value="대전" onchange="showSigungu()" <c:if test="${ssido == '대전'}">checked</c:if>> 대전</label>
                        <label><input type="radio" name="ssido" value="부산" onchange="showSigungu()" <c:if test="${ssido == '부산'}">checked</c:if>> 부산</label>
                        <label><input type="radio" name="ssido" value="서울" onchange="showSigungu()" <c:if test="${ssido == '서울'}">checked</c:if>> 서울</label>
                        <label><input type="radio" name="ssido" value="세종특별자치시" onchange="showSigungu()" <c:if test="${ssido == '세종특별자치시'}">checked</c:if>> 세종특별자치시</label>
                        <label><input type="radio" name="ssido" value="울산" onchange="showSigungu()" <c:if test="${ssido == '울산'}">checked</c:if>> 울산</label>
                        <label><input type="radio" name="ssido" value="인천" onchange="showSigungu()" <c:if test="${ssido == '인천'}">checked</c:if>> 인천</label>
                        <label><input type="radio" name="ssido" value="전남광주통합특별시" onchange="showSigungu()" <c:if test="${ssido == '전남광주통합특별시'}">checked</c:if>> 전남광주통합특별시</label>
                        <label><input type="radio" name="ssido" value="전북특별자치도" onchange="showSigungu()" <c:if test="${ssido == '전북특별자치도'}">checked</c:if>> 전북특별자치도</label>
                        <label><input type="radio" name="ssido" value="제주특별자치도" onchange="showSigungu()" <c:if test="${ssido == '제주특별자치도'}">checked</c:if>> 제주특별자치도</label>
                        <label><input type="radio" name="ssido" value="충남" onchange="showSigungu()" <c:if test="${ssido == '충남'}">checked</c:if>> 충남</label>
                        <label><input type="radio" name="ssido" value="충북" onchange="showSigungu()" <c:if test="${ssido == '충북'}">checked</c:if>> 충북</label>
                    </div>
                </div>

                <!-- 시군구 -->
                <div class="filter-section">
                    <h4>시군구</h4>
                    <div id="sigunguArea">
                        시도를 먼저 선택해주세요.
                    </div>
                </div>

                <!-- 가격 -->
                <div class="filter-section">
                    <h4>가격</h4>
                    <div class="filter-price-row">
                        <label>최소 가격</label>
                        <input type="number" name="minPrice" value="${minPrice}" placeholder="예: 10000" min="0"> 원
                    </div>
                    <div class="filter-price-row">
                        <label>최대 가격</label>
                        <input type="number" name="maxPrice" value="${maxPrice}" placeholder="예: 30000" min="0"> 원
                    </div>
                </div>

                <!-- 영업요일 -->
                <div class="filter-section">
                    <h4>영업요일</h4>
                    <div class="filter-chip-group">
                        <label><input type="checkbox" name="sinfo" value="월"> 월</label>
                        <label><input type="checkbox" name="sinfo" value="화"> 화</label>
                        <label><input type="checkbox" name="sinfo" value="수"> 수</label>
                        <label><input type="checkbox" name="sinfo" value="목"> 목</label>
                        <label><input type="checkbox" name="sinfo" value="금"> 금</label>
                        <label><input type="checkbox" name="sinfo" value="토"> 토</label>
                        <label><input type="checkbox" name="sinfo" value="일"> 일</label>
                    </div>
                </div>

                <!-- 주차 여부 -->
                <div class="filter-section">
                    <h4>주차 여부</h4>
                    <div class="filter-chip-group">
                        <label><input type="radio" name="sparking" value="가능" <c:if test="${sparking == '가능'}">checked</c:if>> 주차 가능</label>
                        <label><input type="radio" name="sparking" value="불가능" <c:if test="${sparking == '불가능'}">checked</c:if>> 주차 불가능</label>
                    </div>
                </div>

                <!-- 영업 상태 -->
                <div class="filter-section">
                    <h4>영업 상태</h4>
                    <div class="filter-chip-group">
                        <label><input type="radio" name="sstatus" value="OPEN" <c:if test="${sstatus == 'OPEN'}">checked</c:if>> 영업중</label>
                        <label><input type="radio" name="sstatus" value="CLOSE" <c:if test="${sstatus == 'CLOSE'}">checked</c:if>> 영업종료</label>
                    </div>
                </div>

                <!-- 별점 -->
                <div class="filter-section">
                    <h4>별점</h4>
                    <div class="filter-chip-group">
                        <label><input type="radio" name="minRating" value="4" <c:if test="${minRating == 4}">checked</c:if>> 4점 이상</label>
                        <label><input type="radio" name="minRating" value="3" <c:if test="${minRating == 3}">checked</c:if>> 3점 이상</label>
                        <label><input type="radio" name="minRating" value="2" <c:if test="${minRating == 2}">checked</c:if>> 2점 이상</label>
                        <label><input type="radio" name="minRating" value="1" <c:if test="${minRating == 1}">checked</c:if>> 1점 이상</label>
                    </div>
                </div>

                <!-- 하단 버튼 -->
                <div class="filter-panel-footer">
                    <button type="button" class="filter-reset-link" onclick="resetFilters()">전체 해제</button>
                    <button type="submit" class="filter-apply-btn">필터 적용</button>
                </div>

            </div>
        </form>
    </div>

    <!-- 2. 식당명 검색 영역 -->
    <div id="storeSearch" style="width: 100%; display: ${param.searchType == 'store' ? 'block' : 'none'};">
        <form action="${pageContext.request.contextPath}/guest/storeSearch" method="get" class="search-form-wrap">
            <input type="hidden" name="searchType" value="store">
            <div class="search-bar-box">
                <span class="search-icon-left">🔍</span>
                <input type="text" name="keyword" value="${param.keyword}" placeholder="식당명을 입력하세요" class="search-input-field" autocomplete="off">
                <button type="submit" class="filter-apply-btn" style="padding: 6px 16px;">검색</button>
            </div>
        </form>
    </div>

</div>

<script>
/* 탭 전환 함수 */
function changeSearchType(type) {
    const totalSearch = document.getElementById("totalSearch");
    const storeSearch = document.getElementById("storeSearch");
    const totalTab = document.getElementById("totalTab");
    const storeTab = document.getElementById("storeTab");

    if (type === "total") {
        totalSearch.style.display = "block";
        storeSearch.style.display = "none";
        totalTab.classList.add("active");
        storeTab.classList.remove("active");
    } else if (type === "store") {
        totalSearch.style.display = "none";
        storeSearch.style.display = "block";
        storeTab.classList.add("active");
        totalTab.classList.remove("active");
        toggleFilterPanel(false);
    }
}

/* 필터 토글 함수 */
function toggleFilterPanel(forceOpen) {
    const panel = document.getElementById("advancedFilterPanel");
    const btn = document.getElementById("filterToggleBtn");
    if (!panel || !btn) return;

    const shouldOpen = (typeof forceOpen === "boolean") ? forceOpen : !panel.classList.contains("open");

    if (shouldOpen) {
        panel.classList.add("open");
        btn.classList.add("active");
    } else {
        panel.classList.remove("open");
        btn.classList.remove("active");
    }
}

/* 초기화 함수 */
function resetFilters() {
    const panel = document.getElementById("advancedFilterPanel");
    if (!panel) return;
    panel.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
    panel.querySelectorAll('input[type="radio"]').forEach(r => r.checked = false);
    panel.querySelectorAll('input[type="number"]').forEach(num => num.value = '');
    document.getElementById("sigunguArea").innerHTML = "시도를 먼저 선택해주세요.";
}

/* 시군구 동적 출력 함수 */
function showSigungu() {
    const selected = document.querySelector('input[name="ssido"]:checked');
    const area = document.getElementById("sigunguArea");
    area.innerHTML = "";

    if (!selected) {
        area.innerHTML = "시도를 먼저 선택해주세요.";
        return;
    }

    const sido = selected.value;
    const sigunguMap = {
        "강원특별자치도": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "횡성군"],
        "경기": ["고양시", "과천시", "광주시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양평군", "여주시", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "화성시"],
        "경남": ["거제시", "거창군", "김해시", "남해군", "밀양시", "사천시", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군"],
        "경북": ["경산시", "경주시", "고령군", "구미시", "김천시", "상주시", "안동시", "영주시", "영천시", "예천군", "울진군", "청송군", "칠곡군", "포항시"],
        "대구": ["군위군", "남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"],
        "대전": ["대덕구", "동구", "서구", "유성구", "중구"],
        "부산": ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"],
        "서울": ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
        "세종특별자치시": ["부강면", "연서면", "장군면", "조치원읍"],
        "울산": ["남구", "울주군", "중구"],
        "인천": ["강화군", "계양구", "남동구", "미추홀구", "부평구", "연수구", "옹진군", "제물포구"],
        "전남광주통합특별시": ["강진군", "고흥군", "광산구", "광양시", "구례군", "나주시", "남구", "담양군", "동구", "목포시", "무안군", "보성군", "북구", "서구", "순천시", "여수시", "영암군", "함평군", "해남군", "화순군"],
        "전북특별자치도": ["고창군", "군산시", "김제시", "남원시", "부안군", "익산시", "임실군", "전주시", "정읍시"],
        "제주특별자치도": ["서귀포시", "제주시"],
        "충남": ["공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"],
        "충북": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시", "충주시"]
    };

    const list = sigunguMap[sido];
    if (!list) {
        area.innerHTML = "시군구 정보가 없습니다.";
        return;
    }

    const selectedSigungu = "${ssigungu}";
    list.forEach(function (sigungu) {
        const label = document.createElement("label");
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.name = "ssigungu";
        checkbox.value = sigungu;

        if (selectedSigungu && selectedSigungu.includes(sigungu)) {
            checkbox.checked = true;
        }

        label.appendChild(checkbox);
        label.appendChild(document.createTextNode(" " + sigungu));
        area.appendChild(label);
    });
}

document.addEventListener("DOMContentLoaded", function() {
    showSigungu();
});
</script>