<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - 이집어때</title>
<script>
	function goPopup(){	
		var pop = window.open("/guest/jusoPopup","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 		    
	}
	
	function jusoCallBack(maddr1,maddr2,mzipno){
		document.member.maddr1.value = maddr1;
		document.member.maddr2.value = maddr2;
		document.member.mzipno.value = mzipno;		
	}
</script>
</head>
<body>
	<%@ include file="header.jsp" %>
	<main class="main-content">
	        <h2>회원가입</h2>
	        <form name="member" method="post" action="/guest/write">        
	            <div>
	                <label>이메일</label>
	                    <input type="text" name="memail">
	            </div>
	                
	            <div>
	                <label>비밀번호</label>
	                <input type="password" name="mpasswd" placeholder="비밀번호를 입력하세요">
				</div>
				
				<div>
	                <label>비밀번호 확인</label>
	                <input type="password" name="mpasswd2" placeholder="비밀번호를 다시 입력하세요">
	            </div>
	            
	            <div>	
	                <label>이름</label>
	                <input type="text" name="mname" placeholder="이름을 입력하세요">
	            </div>
	            
				<div>
					<label>성별:</label>
					<input type="radio" id="male" name="gender" value="M" checked>
					<label for="male">남성</label>					  
					<input type="radio" id="female" name="gender" value="F">
					<label for="female">여성</label>
				</div>
				
				<div>
				    <label for="ageGroup">연령대:</label>
				    <select id="ageGroup" name="ageGroup">
				      <option value="10">10대</option>
				      <option value="20">20대</option>
				      <option value="30">30대</option>
				      <option value="40">40대</option>
				      <option value="50">50대</option>
				      <option value="60">60대</option>
				      <option value="70">70대</option>
				      <option value="80">80대</option>
				      <option value="90">90대</option>
				    </select>
				</div>
				
				<div>	
	                <label>주소</label>
	                <input type="text" name="mzipno" placeholder="우편번호" readonly>
	                <input type="button" value="주소검색" class="btn-sub" onclick="goPopup();">
	                <input type="text" name="maddr1" placeholder="기본주소" readonly style="margin-bottom: 8px;">
	                <input type="text" name="maddr2" placeholder="상세주소 입력" readonly>
	            </div>
	            
	            <div>
	                <label>연락처</label>
	                    <input type="text" name="mtel1" maxlength="3">
	                    <span>-</span>
	                    <input type="text" name="mtel2" maxlength="4">
	                    <span>-</span>
	                    <input type="text" name="mtel3" maxlength="4">
	            </div>
	            
	            <div>
	                <label>예금주</label>
	                <input type="text" name="maccount1" placeholder="예금주명">
	            </div>
	            
	            <div>
	                <label>은행명</label>
	                <select name="maccount2">
	                    <option value="">----- 은행 선택 -----</option>
	                    <option value="KB국민은행">KB국민은행</option>
	                    <option value="NH농협은행">NH농협은행</option>
	                    <option value="우리은행">우리은행</option>
	                    <option value="BNK부산은행">BNK부산은행</option>
	                    <option value="카카오뱅크">카카오뱅크</option>
	                    <option value="토스뱅크">토스뱅크</option>
	                </select>
	            </div>
	            
	            <div>
	                <label>계좌번호</label>
	                <input type="text" name="maccount3" placeholder="숫자 및 하이픈(-) 포함 9 ~ 18자리">
	                <input type="submit" value="회원가입" class="btn-submit" onclick="return check()">
	                <input type="button" value="취소" class="btn-cancel" onclick="history.back()">
	            </div>
		</form>
    </main>
	<%@ include file="footer.jsp" %>
</body>
</html>