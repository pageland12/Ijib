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
<script src="/js/memberUpdate.js"></script>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/memberWrite.css'/>">
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

            <div class="content-card">
                <form name="memberUpdate" method="post" action="/member/memberUpdate">
                    <input type="hidden" name="mno" value="${update.mno}">

                    <div class="form-group">
                        <label>이메일 (아이디)</label>
                        <input type="text" name="memail" readonly value="${update.memail}">
                    </div>

                    <div class="form-group">
                        <label>새 비밀번호</label>
                        <input type="password" name="newPasswd" placeholder="변경하지 않으려면 비워두세요">
                    </div>

                    <div class="form-group">
                        <label>새 비밀번호 확인</label>
                        <input type="password" name="newPasswdCheck" placeholder="새 비밀번호를 한 번 더 입력하세요">
                    </div>

                    <div class="form-group">
                        <label>이름</label>
                        <input type="text" name="mname" value="${update.mname}">
                    </div>

                    <div class="form-group">
                        <label>성별</label>
                        <div class="radio-row">
                            <label class="radio-label">
                                <input type="radio" id="male" name="gender" value="M" ${update.mgender == 'M' ? 'checked' : ''}> 남성
                            </label>
                            <label class="radio-label">
                                <input type="radio" id="female" name="gender" value="F" ${update.mgender == 'F' ? 'checked' : ''}> 여성
                            </label>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>연령대</label>
                        <select name="ageGroup">
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
                    </div>

                    <div class="form-group">
                        <label>주소</label>
                        <div class="input-row">
                            <input type="text" name="mzipno" readonly placeholder="우편번호" value="${maddrArray[2]}">
                            <input type="button" value="주소검색" class="btn-sub" onclick="goPopup();">
                        </div>
                        <input type="text" name="maddr1" readonly placeholder="기본주소" value="${maddrArray[0]}" class="stacked-input">
                        <input type="text" name="maddr2" readonly placeholder="상세주소" value="${maddrArray[1]}" class="stacked-input">
                    </div>

                    <div class="form-group">
                        <label>연락처</label>
                        <div class="tel-row">
                            <input type="text" name="mtel1" maxlength="3" value="${mtelArray[0]}">
                            <span>-</span>
                            <input type="text" name="mtel2" maxlength="4" value="${mtelArray[1]}">
                            <span>-</span>
                            <input type="text" name="mtel3" maxlength="4" value="${mtelArray[2]}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>환불 계좌 정보</label>
                        <div class="input-row">
                            <select name="maccount2" class="account-bank">
                                <option value="">은행 선택</option>
                                <option value="KB국민은행" ${maccountArray[1] == 'KB국민은행' ? 'selected' : ''}>KB국민은행</option>
                                <option value="NH농협은행" ${maccountArray[1] == 'NH농협은행' ? 'selected' : ''}>NH농협은행</option>
                                <option value="우리은행" ${maccountArray[1] == '우리은행' ? 'selected' : ''}>우리은행</option>
                                <option value="BNK부산은행" ${maccountArray[1] == 'BNK부산은행' ? 'selected' : ''}>BNK부산은행</option>
                                <option value="카카오뱅크" ${maccountArray[1] == '카카오뱅크' ? 'selected' : ''}>카카오뱅크</option>
                                <option value="토스뱅크" ${maccountArray[1] == '토스뱅크' ? 'selected' : ''}>토스뱅크</option>
                            </select>
                            <input type="text" name="maccount1" placeholder="예금주" value="${maccountArray[0]}">
                        </div>
                        <input type="text" name="maccount3" placeholder="계좌번호 (- 제외)" value="${maccountArray[2]}" class="stacked-input">
                    </div>

                    <div class="btn-group">
                        <input type="submit" value="정보 수정" class="btn-submit" onclick="return check()">
                        <a href="/member/memberMain" class="btn-cancel btn-cancel-link">취소</a>
                    </div>
                </form>
            </div>
        </main>

    </div>

    <%@ include file="../guest/footer.jsp" %>
</body>
</html>