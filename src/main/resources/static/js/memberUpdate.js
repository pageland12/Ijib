// 1. 주소 검색 팝업 창 호출
function goPopup() {
    var pop = window.open("/guest/jusoPopup", "pop", "width=570,height=420,scrollbars=yes,resizable=yes"); 
}

// 2. jusoPopup.jsp에서 콜백(callback)으로 주소 데이터를 받아오는 함수
function jusoCallBack(roadAddrPart1, addrDetail, zipNo) {
    document.memberUpdate.mzipno.value = zipNo;
    document.memberUpdate.maddr1.value = roadAddrPart1;
    document.memberUpdate.maddr2.value = addrDetail;
}

function check() {
    let newPasswd = document.memberUpdate.newPasswd;
    let newPasswdCheck = document.memberUpdate.newPasswdCheck;
	let mname = document.memberUpdate.mname;
	let maddr2 = document.memberUpdate.maddr2;
    let mtel1 = document.memberUpdate.mtel1;
    let mtel2 = document.memberUpdate.mtel2;
    let mtel3 = document.memberUpdate.mtel3;
	let mtel = mtel1.value + "-" + mtel2.value + "-" + mtel3.value;
	let maccount1 = document.memberUpdate.maccount1;
	let maccount2 = document.memberUpdate.maccount2;
	let maccount3 = document.memberUpdate.maccount3;
	
	let expMpasswd = /^[a-zA-Z0-9~!@#$%]{8,20}$/;
	let expMname = /^[가-힣]{2,10}$/;
	let expMtel = /^\d{2,3}-\d{3,4}-\d{4}$/;
	let expMaccount1 = /^[가-힣]{2,10}$/;
	let expMaccount3 = /^[0-9-]{9,18}$/;

    if (newPasswd.value || newPasswdCheck.value) {
        if (!expMpasswd.test(newPasswd.value)) {
            alert("비밀번호는 영문 대·소문자, 숫자, 특수문자(~!@#$%)를 포함한\n8자 이상 20자 이하로 입력해주세요.");
            newPasswd.focus();
            return false;
        }
        if (newPasswd.value !== newPasswdCheck.value) {
            alert("비밀번호가 일치하지 않습니다.");
            newPasswdCheck.focus();
            return false;
        }
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
			
	if(!maddr2.value){
		alert("상세 주소를 입력해주세요.");
		maddr2.focus();
		return false;
	}
	
    if (!mtel1.value || !mtel2.value || !mtel3.value) {
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