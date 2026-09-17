// 브라우저에 특정 이름의 쿠키가 존재하는지 찾아내는 함수
function getCookie(name) {
    // value: ; ...; hideCoupon=true; ...
	const value = "; " + document.cookie;
	
	// 해당 쿠키를 name 매개변수를 기준으로 나눔
	// name: hideCoupon인 경우
	// parts[0]: ; ...;
	// parts[1]: =ture; ...
	// 따라서 쿠키가 있는 경우 parts 배열에는 총 2개의 문자열이 있음
    const parts = value.split("; " + name + "=");
	
	// 쿠키가 있는 경우 실행
    if (parts.length == 2) {
        // parts.pop(): parts 배열의 가장 뒤 인덱스 값을 빼옴 -> true; ...
		// .split(";"): ;를 기준으로 나눔 -> true / ...
		// .shift(): 배열의 가장 앞 인덱스 값을 빼옴 -> true
		return parts.pop().split(";").shift();
    }
    return null;
}

function goMainPopup(){
	// hideCoupon cookie가 있는지 확인해서 없으면 팝업 띄우기
	if (!getCookie('hideCoupon')) {
		var pop = window.open("/guest/mainPopup","pop","width=450,height=656,top=100,left=100,scrollbars=no,resizable=no");
	}
}