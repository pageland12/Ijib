function check() {
	let rtitle = document.ratingWriteForm.rtitle;
	let rrate = document.ratingWriteForm.rrate;
	
	if(!rtitle.value) {
		alert("제목을 입력해주세요.");
		rtitle.focus();
		return false;
	}
	
	if(rtitle.value.length < 2 || rtitle.value.length > 20) {
		alert("제목은 2자 이상 20자 이하로 입력해주세요.")
		rtitle.focus();
		return false;
	}
	
	if(!rrate.value) {
		alert("평점을 선택해주세요.")
		return false;
	}
	
	return true;
}