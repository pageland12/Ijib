function goPopup(){	
		var pop = window.open("/guest/jusoPopup","addressPop","width=570,height=420, scrollbars=yes, resizable=yes"); 		    
	}
	
	function jusoCallBack(maddr1,maddr2,mzipno){
		document.member.maddr1.value = maddr1;
		document.member.maddr2.value = maddr2;
		document.member.mzipno.value = mzipno;		
	}
	
	function goEmailCheck(){
		console.log("goEmailCheck 실행");
		var pop = window.open("/guest/emailPopup","emailPop","width=570,height=420, scrollbars=yes, resizable=yes");
		console.log("팝업 객체:", pop);
	}
	
	function emailCallBack(email){
		document.member.memail.value = email;
	}
	
	function check() {
		let memail = document.member.memail;
		let mpasswd = document.member.mpasswd;
		let mpasswd2 = document.member.mpasswd2;
		let mname = document.member.mname;
		let mzipno = document.member.mzipno;
		let maddr1 = document.member.maddr1;
		let maddr2 = document.member.maddr2;
		let mtel1 = document.member.mtel1;
		let mtel2 = document.member.mtel2;
		let mtel3 = document.member.mtel3;
		let mtel = mtel1.value + "-" + mtel2.value + "-" + mtel3.value;
		let maccount1 = document.member.maccount1;
		let maccount2 = document.member.maccount2;
		let maccount3 = document.member.maccount3;
		
		let expMpasswd = /^[a-zA-Z0-9~!@#$%]{8,20}$/;
		let expMname = /^[가-힣]{2,10}$/;
		let expMtel = /^\d{2,3}-\d{3,4}-\d{4}$/;
		let expMaccount1 = /^[가-힣]{2,10}$/;
		let expMaccount3 = /^[0-9-]{9,18}$/;
		
		if(!memail.value) {
			alert("이메일 중복 검사를 해주세요.")
			return false;
		}
		
		if(!mpasswd.value) {
			alert("비밀번호를 입력해주세요.")
			mpasswd.focus();
			return false;
		}
		
		if(!expMpasswd.test(mpasswd.value)){
			alert("비밀번호는 영문 대·소문자, 숫자, 특수문자(~!@#$%)를 포함한\n8자 이상 20자 이하로 입력해주세요.");
			mpasswd.focus();
			return false;
		}
		
		if(mpasswd.value != mpasswd2.value){
			alert("비밀번호가 일치하지 않습니다.");
			mpasswd2.value="";
			mpasswd.focus();
			return false;
		}
		
		if(!mname.value){
			alert("이름을 입력해주세요.");
			mname.focus();
			return false;
		}
		
		if(!expMname.test(mname.value)){
			alert("이름은 한글 2자 이상 10자 이하로 입력해주세요.");
			mname.value="";
			mname.focus();
			return false;
		}
		
		if(!mzipno.value){
			alert("주소를 입력해주세요.");
			maddr1.focus();
			return false;
		}
		
		if(!maddr2.value){
			alert("상세 주소를 입력해주세요.");
			maddr2.focus();
			return false;
		}
		
		if(!mtel1.value || !mtel2.value || !mtel3.value){
			alert("연락처를 입력해주세요.");
			if(!mtel1.value){
				mtel1.focus();
			} else if(!mtel2.value){
				mtel2.focus();
			} else{
				mtel3.focus();
			}
			return false;
		}
		
		if(!expMtel.test(mtel)){
			alert("연락처를 올바르게 입력해주세요.");
			mtel1.value="";
			mtel2.value="";
			mtel3.value="";
			mtel1.focus();
			return false;
		}
		
		if(!maccount1.value){
			alert("예금주를 입력해주세요.");
			maccount1.focus();
			return false;
		}
		
		if(!expMaccount1.test(maccount1.value)){
			alert("예금주는 한글 2자 이상 10자 이하로 입력해주세요.");
			maccount1.value="";
			maccount1.focus();
			return false;
		}
		
		if(!maccount2.value){
			alert("은행을 선택해주세요.");
			maccount2.focus();
			return false;
		}
		
		if(!maccount3.value){
			alert("계좌번호를 입력해주세요.");
			maccount3.focus();
			return false;
		}
		
		if(!expMaccount3.test(maccount3.value)){
			alert("계좌번호는 숫자 및 하이픈(-) 포함 9 ~ 18자리로 입력해주세요.");
			maccount3.value="";
			maccount3.focus();
			return false;
		}
		
		return true;
	}