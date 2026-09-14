<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이집어때 - 후기 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/ratingForm.css">
<script src="/js/ratingWU.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="rating-wrapper">
        <div class="rating-card">
            <div class="rating-category">REVIEW</div>
            <h2 class="rating-main-title">식당 후기 수정</h2>

            <form name="ratingUpdateForm" method="post" action="/board/ratingUpdate">
                <input type="hidden" name="rno" value="${update.rno}">
                <input type="hidden" name="sno" value="${update.sno}">
                
                <div class="rating-form-table">
                    <!-- 제목 -->
                    <div class="form-group">
                        <label>제목</label>
                        <input type="text" name="rtitle" value="${update.rtitle}">
                    </div>

                    <!-- 내용 -->
                    <div class="form-group">
                        <label>내용</label>
                        <textarea name="rcontent">${update.rcontent}</textarea>
                    </div>

                    <!-- 평점 및 가게 특징 (가로 배치) -->
                    <div class="form-row-group">
                        <div class="form-group">
                            <label>평점</label>
                            <select name="rrate">
                                <option value="5.0" ${update.rrate == 5.0 ? 'selected' : ''}>★★★★★ (5.0)</option>
                                <option value="4.0" ${update.rrate == 4.0 ? 'selected' : ''}>★★★★☆ (4.0)</option>
                                <option value="3.0" ${update.rrate == 3.0 ? 'selected' : ''}>★★★☆☆ (3.0)</option>
                                <option value="2.0" ${update.rrate == 2.0 ? 'selected' : ''}>★★☆☆☆ (2.0)</option>
                                <option value="1.0" ${update.rrate == 1.0 ? 'selected' : ''}>★☆☆☆☆ (1.0)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>가게 특징</label>
                            <input type="text" name="rfeature" value="${update.rfeature}">
                        </div>
                    </div>
                </div>

                <hr class="rating-line">

                <!-- 하단 버튼 영역 -->
                <div class="rating-action-row">
                    <a href="/guest/ratingList" class="btn-list">목록</a>
                    <button type="submit" class="btn-submit" onclick="return check()">수정 완료</button>
                </div>
            </form>
        </div>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>