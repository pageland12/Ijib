function check() {
	let ntitle = document.noticeWriteForm.ntitle;
	
	if(!ntitle.value) {
		alert("제목을 입력해주세요.");
		ntitle.focus();
		return false;
	}
	
	if(ntitle.value.length<2 || ntitle.value.length>15) {
		alert("제목은 2자이상 15자 이하로 입력해주세요.");
		ntitle.focus();
		return false;
	}
	
	return true;
}