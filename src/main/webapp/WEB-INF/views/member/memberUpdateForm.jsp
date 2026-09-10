<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="maddrArray" value="${fn:split(update.maddr, ',')}" />
<c:set var="mtelArray" value="${fn:split(update.mtel, '-')}" />
<c:set var="maccountArray" value="${fn:split(update.maccount, ',')}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 - 회원정보 수정</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
		<script>
		// 1. 주소 검색 팝업 창 호출
		function goPopup() {
		    // jusoPopup.jsp 또는 컨트롤러에서 jusoPopup 매핑으로 이동
		    //절대경로 및 팝업 설정
		    var pop = window.open("/member/jusoPopup", "pop", "width=570,height=420,scrollbars=yes,resizable=yes"); 
		}
		
		// 2. jusoPopup.jsp에서 콜백(callback)으로 주소 데이터를 받아오는 함수
		function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno) {
		    // 팝업에서 선택한 데이터를 회원 정보 입력란에 셋팅
		    document.getElementById("zipcode").value = zipNo;
		    document.getElementById("address").value = roadAddrPart1 + " " + roadAddrPart2;
		    document.getElementById("addressDetail").value = addrDetail;
		}
	</script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <!-- 마이페이지 공통 레이아웃 구조 -->
    <div class="member-page">
        
        <!-- 마이페이지 사이드바 인클루드 -->
        <jsp:include page="/WEB-INF/views/member/memberSidebar.jsp" />

        <main class="member-content">
            <div class="content-header">
                <h2 class="content-title">회원정보 수정</h2>
                <div class="content-subtitle">
                    회원님의 기본 정보와 환불/정산용 계좌 정보를 수정할 수 있습니다.
                </div>
            </div>

            <form name="memberUpdate" method="post" action="/member/memberUpdate">
                <input type="hidden" name="mno" value="${update.mno}">

                <table class="form-table">
                    <tr>
                        <th>이메일 (아이디)</th>
                        <td>
                            <input type="text" name="memail" class="form-control input-full" readonly value="${update.memail}">
                        </td>
                    </tr>
					<tr>
					    <th>새 비밀번호</th>
					    <td>
					        <input type="password" name="newPasswd" class="form-control input-full" placeholder="변경하지 않으려면 비워두세요">
					    </td>
					</tr>
					<tr>
					    <th>새 비밀번호 확인</th>
					    <td>
					        <input type="password" name="newPasswdCheck" class="form-control input-full" placeholder="새 비밀번호를 한 번 더 입력하세요">
					    </td>
					</tr>
					
					<tr>
					    <th>이름</th>
					    <td>
					        <input type="text"
					               name="mname"
					               class="form-control input-mid"
					               value="${update.mname}">
					    </td>
					</tr>
					
					<tr>
					    <th>성별</th>
					    <td>
					        <input type="radio"
					               id="male"
					               name="gender"
					               value="M"
					               ${update.mgender == 'M' ? 'checked' : ''}>
					        <label for="male">남성</label>
					
					        <input type="radio"
					               id="female"
					               name="gender"
					               value="F"
					               ${update.mgender == 'F' ? 'checked' : ''}>
					        <label for="female">여성</label>
					    </td>
					</tr>
					
					<tr>
					    <th>연령대</th>
					    <td>
					        <select name="ageGroup" class="form-control" style="width: 160px;">
					
					            <option value="10" ${update.mage == 10 ? 'selected' : ''}>10대</option>
					            <option value="20" ${update.mage == 20 ? 'selected' : ''}>20대</option>
					            <option value="30" ${update.mage == 30 ? 'selected' : ''}>30대</option>
					            <option value="40" ${update.mage == 40 ? 'selected' : ''}>40대</option>
					            <option value="50" ${update.mage == 50 ? 'selected' : ''}>50대</option>
					            <option value="60" ${update.mage == 60 ? 'selected' : ''}>60대</option>
					            <option value="70" ${update.mage == 70 ? 'selected' : ''}>70대</option>
					            <option value="80" ${update.mage == 80 ? 'selected' : ''}>80대</option>
					            <option value="90" ${update.mage == 90 ? 'selected' : ''}>90대</option>
					
					        </select>
					    </td>
					</tr>
					<tr>
						<th>주소</th>
                        <td>
                            <div class="address-stack">
                                <div class="input-group-row">
                                    <input type="text" name="mzipno" class="form-control" style="width: 120px;" readonly placeholder="우편번호" value="${maddrArray[2]}">
                                    <input type="button" value="주소검색" class="btn-search" onclick="goPopup();">
                                </div>
                                <input type="text" name="maddr1" class="form-control input-full" readonly placeholder="기본주소" value="${maddrArray[0]}">
                                <input type="text" name="maddr2" class="form-control input-full" readonly placeholder="상세주소" value="${maddrArray[1]}">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td>
                            <div class="input-group-row">
                                <input type="text" name="mtel1" class="form-control input-tel" maxlength="3" value="${mtelArray[0]}">
                                <span>-</span>
                                <input type="text" name="mtel2" class="form-control input-tel" maxlength="4" value="${mtelArray[1]}">
                                <span>-</span>
                                <input type="text" name="mtel3" class="form-control input-tel" maxlength="4" value="${mtelArray[2]}">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>환불 계좌 정보</th>
                        <td>
                            <div class="address-stack">
                                <div class="input-group-row">
                                    <select name="maccount2" class="form-control" style="width: 160px;">
                                        <option value="">은행 선택</option>
                                        <option value="KB국민은행" ${maccountArray[1] == 'KB국민은행' ? 'selected' : ''}>KB국민은행</option>
                                        <option value="NH농협은행" ${maccountArray[1] == 'NH농협은행' ? 'selected' : ''}>NH농협은행</option>
                                        <option value="우리은행" ${maccountArray[1] == '우리은행' ? 'selected' : ''}>우리은행</option>
                                        <option value="BNK부산은행" ${maccountArray[1] == 'BNK부산은행' ? 'selected' : ''}>BNK부산은행</option>
                                        <option value="카카오뱅크" ${maccountArray[1] == '카카오뱅크' ? 'selected' : ''}>카카오뱅크</option>
                                        <option value="토스뱅크" ${maccountArray[1] == '토스뱅크' ? 'selected' : ''}>토스뱅크</option>
                                    </select>
                                    <input type="text" name="maccount1" class="form-control" style="width: 130px;" placeholder="예금주" value="${maccountArray[0]}">
                                </div>
                                <input type="text" name="maccount3" class="form-control input-full" placeholder="계좌번호 (- 제외)" value="${maccountArray[2]}">
                            </div>
                        </td>
                    </tr>
                </table>

                <div class="form-btn-area">
                    <input type="submit" value="정보 수정" class="btn-submit" onclick="return check()">
                    <a href="/member/memberMain" class="btn-cancel">취소</a>
                </div>
            </form>
        </main>

    </div>

    <%@ include file="../guest/footer.jsp" %>

    <script src="/js/memberUpdate.js"></script>
</body>
</html>