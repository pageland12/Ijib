function check() {
	let ntitle = document.noticeWriteForm.ntitle;
	
	if(!ntitle.value) {
		alert("제목을 입력해주세요.");
		ntitle.focus();
		return false;
	}
	
	return true;
}