<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역</title>
<script>
// 모달 열기
function openRefundModal(paymentId, prodName, status, odate) {
    if (status === 'REFUND') {
    	alert("이미 환불된 주문입니다.");
    	return;
    }
    
    // 주문일(odate) 기준 7일 계산
    const orderDate = new Date(odate.replace(" ", "T"));
    const limitDate = new Date(orderDate.getTime() + (7 * 24 * 60 * 60 * 1000));
    const now = new Date();
    
    if (now > limitDate) {
    	alert("걸제일로부터 7일이 경과하여 환불 신청이 불가능합니다.\n고객센터에 문의해주세요.");
    	return;
    }
	
	document.getElementById("modalPaymentId").value = paymentId;
    document.getElementById("modalProdName").innerText = prodName;
    document.getElementById("refundReasonSelect").value = "단순 변심";
    document.getElementById("customReasonBox").style.display = "none";
    document.getElementById("customReasonText").value = "";
    document.getElementById("refundModal").style.display = "block";
}

// 모달 닫기
function closeRefundModal() {
    document.getElementById("refundModal").style.display = "none";
}

// '기타' 사유 선택 시 직접 입력창 토글
function toggleCustomReason(val) {
    const customBox = document.getElementById("customReasonBox");
    if (val === "기타") {
        customBox.style.display = "block";
    } else {
        customBox.style.display = "none";
    }
}

// 환불 전송 요청
function submitRefund() {
    const paymentId = document.getElementById("modalPaymentId").value;
    const selectVal = document.getElementById("refundReasonSelect").value;
    const customText = document.getElementById("customReasonText").value.trim();

    // 최종 사유 결정
    let finalReason = selectVal;
    if (selectVal === "기타") {
        if (!customText) {
            alert("환불 사유를 상세히 입력해 주세요.");
            return;
        }
        finalReason = customText;
    }

    if (!confirm("정말로 환불을 진행하시겠습니까?\n환불 즉시 구독 혜택이 종료됩니다.")) {
        return;
    }

    // 백엔드로 환불 요청 전송
    fetch("/pay/refund", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            paymentId: paymentId,
            reason: finalReason
        })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert("환불 처리가 완료되었습니다.");
            location.reload();				// 환불이 완료되면 페이지 새로고침
        } else {
            alert("환불 처리 실패: " + data.message);
        }
    })
    .catch(err => {
        console.error("환불 통신 오류:", err);
        alert("서버 통신 중 오류가 발생했습니다.");
    })
    .finally(() => {
        closeRefundModal();
    });
}
</script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>

    <!-- 마이페이지 공통 레이아웃 구조 -->
    <div class="member-page">

        <!-- 마이페이지 사이드바 인클루드 -->
        <jsp:include page="/WEB-INF/views/member/memberSidebar.jsp" />
	<div class="content-title-area">
    <h2>주문 내역</h2>
    </div>
    
	 <main class="member-content">
	    <h2>게시판</h2>
	    <table border=1 width=400>
        <thead>
            <tr>
                <th>주문 번호</th>
                <th>결제액</th>
                <th>결제 방법</th>
                <th>결제일</th>
                <th>상품 이름</th>
                <th>환불</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="order" items="${orders}" varStatus="status">
                <tr>
                    <td>${order.ono}</td>
                    <td><fmt:formatNumber value="${order.oprice}" pattern="#,###" />원</td>
                    <td>${order.opayment}</td>
                    <td>${odates[status.index]}</td>
                    <td>${order.pname}</td>
                    <td>
                        <c:choose>
                            <c:when test="${order.ostatus eq 'PAID'}">
                                <button type="button" onclick="openRefundModal('${order.ono}', '${order.pname}', '${order.ostatus}', '${odates[status.index]}')">
                                    환불 신청
                                </button>
                            </c:when>
                            <c:when test="${order.ostatus eq 'REFUND'}">
                                <span>환불 완료</span>
                            </c:when>
                            <c:otherwise>
                                <span>-</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <!-- 환불 사유 입력 모달 영역 -->
    <div id="refundModal" style="display: none;">
        <div>
            <h3>구독권 환불 신청</h3>
            <p><strong>상품명: </strong><span id="modalProdName"></span></p>
            
            <!-- 숨겨둘 paymentId -->
            <input type="hidden" id="modalPaymentId" value="" />
    
            <div>
                <label for="refundReasonSelect">환불 사유 선택</label>
                <select id="refundReasonSelect" onchange="toggleCustomReason(this.value)">
                    <option value="단순 변심">단순 변심 / 서비스 불필요</option>
                    <option value="서비스 불만족">콘텐츠 및 서비스 불만족</option>
                    <option value="결제 오류/중복 결제">결제 오류 / 중복 결제</option>
                    <option value="기타">기타 사유 직접 입력</option>
                </select>
            </div>
    
            <div id="customReasonBox" style="display: none;">
                <textarea id="customReasonText" placeholder="상세 사유를 입력해 주세요 (최대 100자)"></textarea>
            </div>
    
            <div>
                <button type="button" onclick="closeRefundModal()">취소</button>
                <button type="button" onclick="submitRefund()">환불 확인</button>
            </div>
        </div>
    </div>
    
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>