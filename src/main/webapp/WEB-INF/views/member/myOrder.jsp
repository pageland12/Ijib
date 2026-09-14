<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역</title>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/form.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/myOrder.css'/>">
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
    	alert("결제일로부터 7일이 경과하여 환불 신청이 불가능합니다.\n고객센터에 문의해주세요.");
    	return;
    }
	
	document.getElementById("modalPaymentId").value = paymentId;
    document.getElementById("modalProdName").innerText = prodName;
    document.getElementById("refundReasonSelect").value = "단순 변심";
    document.getElementById("customReasonBox").style.display = "none";
    document.getElementById("customReasonText").value = "";
    document.getElementById("refundModal").style.display = "flex"; // flex로 변경하여 중앙 정렬
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
            location.reload();
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

        <!-- 본문 영역을 sidebar 우측에 정확히 위치시키기 위해 통합 -->
        <main class="member-content">
            <div class="content-title-area">
                <h2>주문 내역 <span>ORDERS</span></h2>
            </div>
            
            <table class="order-table">
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
                    <c:choose>
                        <c:when test="${empty orders}">
                            <tr>
                                <td colspan="6" style="padding: 40px; color: #777;">주문 내역이 존재하지 않습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}" varStatus="status">
                                <tr>
                                    <td>${order.ono}</td>
                                    <td><fmt:formatNumber value="${order.oprice}" pattern="#,###" />원</td>
                                    <td>${order.opayment}</td>
                                    <td>${odates[status.index]}</td>
                                    <td style="font-weight: 600; color: #222;">${order.pname}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.ostatus eq 'PAID'}">
                                                <button type="button" class="btn-refund-sm" onclick="openRefundModal('${order.ono}', '${order.pname}', '${order.ostatus}', '${odates[status.index]}')">
                                                    환불 신청
                                                </button>
                                            </c:when>
                                            <c:when test="${order.ostatus eq 'REFUND'}">
                                                <span class="status-refunded">환불 완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-none">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </main>
    </div>
    
    <!-- 환불 사유 입력 모달 영역 -->
    <div id="refundModal" class="custom-modal-overlay">
        <div class="custom-modal-box">
            <h3>구독권 환불 신청</h3>
            <p><strong>상품명: </strong><span id="modalProdName"></span></p>
            
            <!-- 숨겨둘 paymentId -->
            <input type="hidden" id="modalPaymentId" value="" />
    
            <div class="modal-form-group">
                <label for="refundReasonSelect">환불 사유 선택</label>
                <select id="refundReasonSelect" onchange="toggleCustomReason(this.value)">
                    <option value="단순 변심">단순 변심 / 서비스 불필요</option>
                    <option value="서비스 불만족">콘텐츠 및 서비스 불만족</option>
                    <option value="결제 오류/중복 결제">결제 오류 / 중복 결제</option>
                    <option value="기타">기타 사유 직접 입력</option>
                </select>
            </div>
    
            <div id="customReasonBox" class="modal-form-group" style="display: none;">
                <textarea id="customReasonText" placeholder="상세 사유를 입력해 주세요 (최대 100자)"></textarea>
            </div>
    
            <div class="modal-btn-group">
                <button type="button" class="btn-modal-cancel" onclick="closeRefundModal()">취소</button>
                <button type="button" class="btn-modal-confirm" onclick="submitRefund()">환불 확인</button>
            </div>
        </div>
    </div>
    
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>