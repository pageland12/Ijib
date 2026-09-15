<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%-- 활성 필터 개수 계산 (뱃지 표시용) --%>
<c:set var="filterCount" value="0" />
<c:if test="${not empty search.mgender}">
    <c:set var="filterCount" value="${filterCount + 1}" />
</c:if>
<c:if test="${not empty search.ageGroups}">
    <c:set var="filterCount" value="${filterCount + fn:length(search.ageGroups)}" />
</c:if>
<c:if test="${not empty search.regions}">
    <c:set var="filterCount" value="${filterCount + fn:length(search.regions)}" />
</c:if>
<c:if test="${not empty search.mauth}">
    <c:set var="filterCount" value="${filterCount + fn:length(search.mauth)}" />
</c:if>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminSearch.css">

<div class="search-container-relative">

    <div class="search-form-wrap">
        <form action="${pageContext.request.contextPath}/admin/memberSearch" method="get" id="memberSearchForm">

            <div class="search-bar-box">
                <span class="search-icon-left">🔍</span>

                <input type="text"
                       name="keyword"
                       class="search-input-field"
                       placeholder="이메일 / 이름 / 전화번호 / 주소"
                       value="${search.keyword}">

                <button type="button"
                        class="btn-filter-trigger"
                        id="filterTrigger"
                        onclick="toggleFilterPanel()">
                    ⚙
                    <c:if test="${filterCount > 0}">
                        <span class="filter-badge">${filterCount}</span>
                    </c:if>
                </button>
            </div>

            <!-- 고급 검색 패널 -->
            <div class="advanced-filter-panel" id="advancedFilterPanel">

                <div class="filter-panel-header">
                    <h3>고급 검색</h3>
                    <button type="button" class="filter-panel-close" onclick="toggleFilterPanel()">&times;</button>
                </div>

                <!-- 성별 -->
                <div class="filter-section">
                    <h4>성별</h4>
                    <div class="filter-chip-group">
                        <label>
                            <input type="radio" name="mgender" value="M" ${search.mgender == 'M' ? 'checked' : ''}>
                            남성
                        </label>
                        <label>
                            <input type="radio" name="mgender" value="F" ${search.mgender == 'F' ? 'checked' : ''}>
                            여성
                        </label>
                    </div>
                </div>

                <!-- 나이 -->
				<div class="filter-section">
				    <h4>나이</h4>
				    <div class="filter-chip-group">
				        <c:set var="ageList" value="10,20,30,40,50,60,70,80,90" />
				        <c:forEach var="age" items="${fn:split(ageList, ',')}">
				            <label>
				                <input type="checkbox" name="ageGroups" value="${age}"
				                       ${search.ageGroups != null && search.ageGroups.contains(age) ? 'checked' : ''}>
				                ${age}대
				            </label>
				        </c:forEach>
				    </div>
				</div>

                <!-- 지역 -->
				<div class="filter-section">
				    <h4>지역</h4>
				    <div class="filter-chip-group">
				        <c:set var="regionList" value="서울,부산,대구,인천,광주,대전,울산,세종,경기,강원,충북,충남,전북,전남,경북,경남,제주" />
				        <c:forEach var="region" items="${fn:split(regionList, ',')}">
				            <label>
				                <input type="checkbox" name="regions" value="${region}"
				                       ${search.regions != null && search.regions.contains(region) ? 'checked' : ''}>
				                ${region}
				            </label>
				        </c:forEach>
				    </div>
				</div>

                <!-- 권한 -->
                <div class="filter-section">
                    <h4>권한</h4>
                    <div class="filter-chip-group">
                        <label>
                            <input type="checkbox" name="mauth" value="NORMAL"
                                   ${search.mauth != null && search.mauth.contains('NORMAL') ? 'checked' : ''}>
                            일반
                        </label>
                        <label>
                            <input type="checkbox" name="mauth" value="SUBSCRIBER"
                                   ${search.mauth != null && search.mauth.contains('SUBSCRIBER') ? 'checked' : ''}>
                            구독자
                        </label>
                        <label>
                            <input type="checkbox" name="mauth" value="ADMIN"
                                   ${search.mauth != null && search.mauth.contains('ADMIN') ? 'checked' : ''}>
                            관리자
                        </label>
                    </div>
                </div>

                <div class="filter-panel-footer">
                    <button type="button"
                            class="filter-reset-link"
                            onclick="location.href='${pageContext.request.contextPath}/admin/memberSearch'">
                        필터 초기화
                    </button>
                    <button type="submit" class="filter-apply-btn">검색</button>
                </div>

            </div>
        </form>
    </div>

</div>

<script>
function toggleFilterPanel() {
    const panel = document.getElementById("advancedFilterPanel");
    const trigger = document.getElementById("filterTrigger");

    panel.classList.toggle("open");
    trigger.classList.toggle("active");
}

// 패널 바깥 클릭 시 닫기
document.addEventListener("click", function (e) {
    const wrap = document.querySelector(".search-form-wrap");
    const panel = document.getElementById("advancedFilterPanel");
    const trigger = document.getElementById("filterTrigger");

    if (!wrap.contains(e.target) && panel.classList.contains("open")) {
        panel.classList.remove("open");
        trigger.classList.remove("active");
    }
});
</script>