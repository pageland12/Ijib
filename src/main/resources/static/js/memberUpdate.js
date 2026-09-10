function check() {
    let form = document.memberUpdate;

    let mname = form.mname;
    let newPasswd = form.newPasswd;
    let newPasswdCheck = form.newPasswdCheck;
    let mtel1 = form.mtel1;
    let mtel2 = form.mtel2;
    let mtel3 = form.mtel3;

    if (!mname.value) {
        alert("이름을 입력해주세요.");
        mname.focus();
        return false;
    }

    // 새 비밀번호를 입력한 경우에만 검증 (비워두면 비밀번호 변경 안 함)
    if (newPasswd.value || newPasswdCheck.value) {
        if (newPasswd.value.length < 4) {
            alert("새 비밀번호는 4자 이상 입력해주세요.");
            newPasswd.focus();
            return false;
        }
        if (newPasswd.value !== newPasswdCheck.value) {
            alert("새 비밀번호가 일치하지 않습니다.");
            newPasswdCheck.focus();
            return false;
        }
    }

    if (!mtel1.value || !mtel2.value || !mtel3.value) {
        alert("연락처를 모두 입력해주세요.");
        mtel1.focus();
        return false;
    }

    return true;
}