function hidePopupForDay() {
    /* 쿠키가 존재할 시간: 1분 */
    const maxAge = 60;
    
    /* 쿠키 굽기 규격 설정 (path=/ 를 지정해야 사이트 전역에서 인식합니다)
    자바스크립트에서 쿠키 설정: 키=값;속성1=값;속성2=값...
    max-age="" -> setMaxAge()
    path=/ -> setPath("/"), 해당 jsp파일이 guest하위이므로 해당 쿠키를 전역으로 뿌리기 위함 */
    const cookieString = "hideCoupon=true; max-age=" + maxAge + "; path=/";
    
    if (window.opener) {
    	// 팝업창을 열어준 부모 창(메인페이지)에 쿠키를 저장
        window.opener.document.cookie = cookieString;
    }
    
    window.close();
}

function goToPassList() {
    const targetUrl = "/guest/passList";

    // 팝업을 열어준 부모 창(메인 화면)이 살아있는 경우
    if (window.opener && !window.opener.closed) {
        window.opener.location.href = targetUrl; // 부모 창 이동
        window.close(); // 팝업창 닫기
    } else {
        // 부모 창이 닫혀있다면 현재 팝업 창 자체에서 이동
        location.href = targetUrl;
    }
}