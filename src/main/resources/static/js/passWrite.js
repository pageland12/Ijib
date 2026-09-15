function check() {
		let pupload = document.pass.pupload;
		let pname = document.pass.pname;
		let pprice = document.pass.pprice;
		let pperiod = document.pass.pperiod;
		
		let expPname = /^[가-힣0-9\s]{2,20}$/;
		let expPprice = /^[0-9]{1,6}$/;
		let expPperiod = /^[0-9]{1,3}$/;
		
		if(!pupload.value) {
			alert("이미지를 선택하세요.")
			return false;
		}
		
		if(!pname.value) {
			alert("상품명을 입력하세요.")
			pname.focus();
			return false;
		}
		
		if(!expPname.test(pname.value)) {
			alert("상품명은 2~20자 이내의 한글, 숫자만 입력 가능합니다.")
			pname.value="";
			pname.focus();
			return false;
		}
		
		if(!pprice.value) {
			alert("가격을 입력하세요.")
			pprice.focus();
			return false;
		}
		
		if(!expPprice.test(pprice.value)) {
			alert("가격은 6자 이내의 숫자만 입력하세요.")
			pprice.value="";
			pprice.focus();
			return false;
		}
		
		if(!pperiod.value) {
			alert("기간을 입력하세요.")
			pperiod.focus();
			return false;
		}
		
		if(!expPperiod.test(pperiod.value)) {
			alert("기간은 3자 이내의 숫자만 입력하세요.")
			pperiod.value="";
			pperiod.focus();
			return false;
		}
		
		return true;
	}