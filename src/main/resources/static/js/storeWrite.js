function check() {
		let sname = document.store.sname;
		let scategory = document.store.scategory;
		let scontent = document.store.scontent;
		let saddr = document.store.saddr;
		let slat = document.store.slat;
		let slong = document.store.slong;
		let stel = document.store.stel;
		let sinfo = document.store.sinfo;
		let sparking = document.store.sparking;
		let mnnames = document.querySelectorAll('input[name="mnname"]');
		let mnprices = document.querySelectorAll('input[name="mnprice"]');
		
		let expSname = /^[a-zA-Z가-힣0-9\s]{2,20}$/;
		let expScategory = /^[가-힣/]+$/;
		let expSlat = /^[0-9.]+$/;
		let expSlong = /^[0-9.]+$/;
		let expMnprice = /^[0-9]+$/;
		
		if(!sname.value) {
			alert("음식점명을 입력하세요.");
			sname.focus();
			return false;
		}
		
		if(!expSname.test(sname.value)) {
			alert("음식점명은 영문 대소문자, 한글, 숫자만 입력 가능합니다. ");
			sname.value="";
			sname.focus();
			return false;
		}
		
		if(!scategory.value) {
			alert("카테고리를 입력하세요.");
			scategory.focus();
			return false;
		}
		
		if(!expScategory.test(scategory.value)) {
			alert("카테고리는 한글, 특수기호(/)만 입력 가능합니다.");
			scategory.value="";
			scategory.focus();
			return false;
		}
		
		if(!scontent.value) {
			alert("설명을 입력하세요.");
			scontent.focus();
			return false;
		}
		
		if(!saddr.value) {
			alert("주소를 입력하세요.");
			saddr.focus();
			return false;
		}
		
		if(!slat.value) {
			alert("위도를 입력하세요.");
			slat.focus();
			return false;
		}
		
		if(!expSlat.test(slat.value)) {
			alert("위도를 올바르게 입력해주세요.");
			slat.value="";
			slat.focus();
			return false;
		}
		
		if(!slong.value) {
			alert("경도를 입력하세요.");
			slong.focus();
			return false;
		}
		
		if(!expSlong.test(slong.value)) {
			alert("경도를 올바르게 입력해주세요.");
			slong.value="";
			slong.focus();
			return false;
		}
		
		if(!stel.value) {
			alert("전화번호를 입력하세요.");
			stel.focus();
			return false;
		}
		
		if(!sinfo.value) {
			alert("영업 정보를 입력하세요.");
			sinfo.focus();
			return false;
		}
		
		if(!sparking.value) {
			alert("주차 여부를 입력하세요.");
			sparking.focus();
			return false;
		}
		
		for (let i = 0; i < mnnames.length; i++) {

		    if (!mnnames[i].value.trim()) {
		        alert("메뉴명을 입력하세요.");
		        mnnames[i].focus();
		        return false;
		    }

		    if (!mnprices[i].value.trim()) {
		        alert("가격을 입력하세요.");
		        mnprices[i].focus();
		        return false;
		    }
			
			if (!expMnprice.test(mnprices[i].value.trim())) {
			    alert("가격은 숫자만 입력 가능합니다.");
			    mnprices[i].value = "";
			    mnprices[i].focus();
			    return false;
			}
		}
		
		return true;
	}