function check() {
	let btitle = document.boardWriteForm.btitle;
	let bcategory = document.boardWriteForm.bcategory;
	
	if(!btitle.value) {
		alert("제목을 입력해주세요.")
		btitle.focus();
		return false;
	}
	
	if(btitle.value.length < 2 || btitle.value.length >15) {
		alert("제목은 2자이상 15자 이하로 입력해주세요.")
		btitle.focus();
		return false;
	}
	
	if(!bcategory[0].checked && !bcategory[1].checked) {
		alert("게시글 유형을 선택해주세요.")
		return false;
	}
	
	return true;
}