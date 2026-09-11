<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${view.sname} - 음식점 상세</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/storeView.css">
<script>
    function openRatingModal() {
        document.getElementById("ratingModal").style.display = "block";
    }

    function closeRatingModal() {
        document.getElementById("ratingModal").style.display = "none";
    }

    window.onclick = function(event) {
        const modal = document.getElementById("ratingModal");
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
</script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <div class="sv-wrap">

        <%-- ===================== 이미지 캐러셀 ===================== --%>
        <c:set var="imgList" value="${fn:split(view.sfiles, ',')}"/>

        <c:choose>
            <c:when test="${fn:length(imgList) > 0 and not empty imgList[0]}">
                <div class="sv-carousel" id="svCarousel">

                    <div class="sv-carousel-track" id="svCarouselTrack">
                        <c:forEach var="image" items="${imgList}">
                            <div class="sv-carousel-slide">
                                <img src="${image}" alt="${view.sname}">
                            </div>
                        </c:forEach>
                    </div>

                    <c:if test="${fn:length(imgList) > 1}">
                        <button type="button" class="sv-carousel-arrow prev" onclick="svCarouselMove(-1)" aria-label="이전 사진">&lsaquo;</button>
                        <button type="button" class="sv-carousel-arrow next" onclick="svCarouselMove(1)" aria-label="다음 사진">&rsaquo;</button>

                        <div class="sv-carousel-dots" id="svCarouselDots">
                            <c:forEach var="image" items="${imgList}" varStatus="loop">
                                <button type="button"
                                        class="sv-carousel-dot${loop.index == 0 ? ' active' : ''}"
                                        onclick="svCarouselGoTo(${loop.index})"></button>
                            </c:forEach>
                        </div>
                    </c:if>

                </div>
            </c:when>
            <c:otherwise>
                <div class="sv-gallery-empty">등록된 사진이 없습니다.</div>
            </c:otherwise>
        </c:choose>

        <%-- ===================== 헤더 정보 ===================== --%>
        <div class="sv-head">

            <div>
                <c:if test="${not empty view.scategory}">
                    <span class="sv-category-badge">${view.scategory}</span>
                </c:if>

                <h1 class="sv-name">${view.sname}</h1>

                <c:if test="${not empty view.skeyword}">
                    <div class="sv-tags">
                        <c:forEach var="tag" items="${fn:split(view.skeyword, ',')}">
                            <span class="sv-tag">#${tag}</span>
                        </c:forEach>
                    </div>
                </c:if>

                <ul class="sv-info-list">
                    <li><span class="sv-info-icon">📍</span>${view.saddr}</li>
                    <c:if test="${not empty view.stel}">
                        <li><span class="sv-info-icon">📞</span>${view.stel}</li>
                    </c:if>
                    <c:if test="${not empty view.sinfo}">
                        <li><span class="sv-info-icon">🕒</span>${view.sinfo}</li>
                    </c:if>
                    <c:if test="${not empty view.sparking}">
                        <li><span class="sv-info-icon">🅿️</span>${view.sparking}</li>
                    </c:if>
                </ul>
            </div>

            <c:if test="${not empty view.sstatus}">
                <span class="sv-status-badge ${view.sstatus == 'OPEN' ? 'sv-status-open' : 'sv-status-close'}">
                    <c:choose>
                        <c:when test="${view.sstatus == 'OPEN'}">영업중</c:when>
                        <c:otherwise>영업종료</c:otherwise>
                    </c:choose>
                </span>
            </c:if>

        </div>

        <%-- ===================== 소개 ===================== --%>
        <c:if test="${not empty view.scontent}">
            <div class="sv-section">
                <h3>소개</h3>
                <p class="sv-desc">${view.scontent}</p>
            </div>
        </c:if>

        <%-- ===================== 메뉴 ===================== --%>
        <div class="sv-section">
            <h3>메뉴</h3>
            <div class="sv-menu-list">
                <c:forEach var="menu" items="${menu}">
                    <div class="sv-menu-row">
                        <span class="sv-menu-name">${menu.mnname}</span>
                        <span class="sv-menu-price"><fmt:formatNumber value="${menu.mnprice}" pattern="#,###"/>원</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%-- ===================== 후기 ===================== --%>
        <div class="sv-section">
            <h3>후기</h3>

            <c:choose>
                <c:when test="${not empty preview}">
                    <c:forEach var="preview" items="${preview}">
                        <div class="rating-item">
                            <strong>${preview.rtitle}</strong>
                            <span class="rating-rate">★ ${preview.rrate}</span>
                            <p>${preview.rcontent}</p>
                            <div class="rating-meta">
                                ${preview.mname} · <fmt:formatDate value="${preview.rdate}" pattern="yyyy.MM.dd"/>
                            </div>
                        </div>
                    </c:forEach>

                    <button type="button" class="rating-more-btn" onclick="openRatingModal()">후기 더보기</button>
                </c:when>
                <c:otherwise>
                    <p class="sv-empty-review">아직 작성된 후기가 없습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- ===================== 전체 후기 모달 ===================== --%>
        <div id="ratingModal" class="rating-modal">
            <div class="rating-modal-content">
                <span class="rating-close" onclick="closeRatingModal()">&times;</span>
                <h3>전체 후기</h3>

                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="list" items="${list}">
                            <div class="rating-item">
                                <strong>${list.rtitle}</strong>
                                <span class="rating-rate">★ ${list.rrate}</span>
                                <p>${list.rcontent}</p>
                                <c:if test="${not empty list.rfeature}">
                                    <div class="rating-meta">특징 : ${list.rfeature}</div>
                                </c:if>
                                <div class="rating-meta">
                                    ${list.mname} · <fmt:formatDate value="${list.rdate}" pattern="yyyy.MM.dd"/>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="sv-empty-review">아직 작성된 후기가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ===================== 액션 버튼 ===================== --%>
        <div class="sv-actions">
            <a href="/board/ratingWriteForm?sno=${view.sno}" class="sv-btn sv-btn-primary">후기 작성</a>
            <a href="/member/bookmarkInsert?sno=${view.sno}" class="sv-btn sv-btn-outline">북마크</a>

            <sec:authorize access="hasRole('ADMIN')">
                <a href="/admin/storeUpdateForm?sno=${view.sno}" class="sv-btn sv-btn-outline">수정</a>
                <a href="/admin/storeDelete?sno=${view.sno}" class="sv-btn sv-btn-danger">삭제</a>
            </sec:authorize>

            <a href="/guest/storeList" class="sv-btn sv-btn-outline">목록</a>
        </div>

    </div>

    <c:if test="${not empty msg}">
        <script>
            alert("${msg}");
        </script>
    </c:if>

    <%@ include file="../guest/footer.jsp" %>

    <script>
    (function() {
        var track = document.getElementById("svCarouselTrack");
        if (!track) return;

        var slides = track.children;
        var total = slides.length;
        var dots = document.querySelectorAll("#svCarouselDots .sv-carousel-dot");
        var current = 0;
        var timer = null;

        function render() {
            track.style.transform = "translateX(-" + (current * 100) + "%)";
            dots.forEach(function(dot, i) {
                dot.classList.toggle("active", i === current);
            });
        }

        window.svCarouselMove = function(dir) {
            current = (current + dir + total) % total;
            render();
            resetTimer();
        };

        window.svCarouselGoTo = function(index) {
            current = index;
            render();
            resetTimer();
        };

        function resetTimer() {
            if (timer) clearInterval(timer);
            if (total > 1) {
                timer = setInterval(function() {
                    current = (current + 1) % total;
                    render();
                }, 5000);
            }
        }

        resetTimer();
    })();
    </script>
</body>
</html>