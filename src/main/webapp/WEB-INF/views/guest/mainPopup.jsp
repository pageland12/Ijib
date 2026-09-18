<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 팝업</title>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    width: 100%;
    height: 100%;
    overflow: hidden;
    user-select: none;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Pretendard", sans-serif;
    background-color: #1e293b;
}

/* 팝업 전체 컨테이너 */
.popup-wrap {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
}

/* 601x1080 비율(약 1:1.80)에 맞춰 이미지 표시 */
.img-box {
    flex: 1;
    overflow: hidden;
    background-color: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;
}

.popup-img {
    width: 100%;
    height: 100%;
    object-fit: contain; /* 세로/가로 여백 없이 딱 맞게 표시 */
    display: block;
}

/* 하단 푸터 바: 이집어때 테마에 맞춘 딥 네이비 계열 */
.footer-bar {
    height: 40px;
    background-color: #1e2d3d;
    color: #e2e8f0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 16px;
    font-size: 13px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.hide-btn {
    cursor: pointer;
    letter-spacing: -0.3px;
    color: #cbd5e1;
    transition: color 0.2s;
}

.hide-btn:hover {
    color: #38bdf8;
    text-decoration: underline;
}

.close-btn {
    cursor: pointer;
    font-weight: 600;
    padding: 3px 8px;
    border-radius: 4px;
    color: #94a3b8;
    transition: background-color 0.2s, color 0.2s;
}

.close-btn:hover {
    color: #ffffff;
    background-color: rgba(56, 189, 248, 0.2);
}
</style>

<!-- 외부 쿠키/이벤트 js -->
<script src="/js/mainPopup.js"></script>

<script>
// 브라우저 창 크기 자동 보정 (이미지 비율 601:1080 + 푸터 40px 반영: 가로 380px, 세로 723px)
window.addEventListener("load", function() {
    const targetWidth = 380;
    const targetHeight = 723;
    
    const diffWidth = window.outerWidth - window.innerWidth;
    const diffHeight = window.outerHeight - window.innerHeight;
    
    window.resizeTo(targetWidth + diffWidth, targetHeight + diffHeight);
});
</script>
</head>
<body>
    <div class="popup-wrap">
        <div class="img-box">
            <img src="/images/event-popup-image.png" 
                 class="popup-img" 
                 alt="구독권 할인 이벤트" 
                 onclick="goToPassList()" 
                 style="cursor: pointer;">
        </div>
        
        <div class="footer-bar">
            <span class="hide-btn" onclick="hidePopupForDay()">오늘 하루 동안 보지 않기</span>
            <span class="close-btn" onclick="window.close()">[닫기]</span>
        </div>
    </div>
</body>
</html>