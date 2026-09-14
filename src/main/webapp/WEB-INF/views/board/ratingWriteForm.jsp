<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이집어때 - 후기 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/ratingForm.css">
<script src="/js/ratingWU.js"></script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="rating-wrapper">
        <div class="rating-card">
            <div class="rating-category">REVIEW</div>
            <h2 class="rating-main-title">식당 후기 등록</h2>

            <form name="ratingWriteForm" method="post" action="/board/ratingWrite">
                <input type="hidden" name="sno" value="${sno}">
                
                <div class="rating-form-table">
                    <!-- 제목 -->
                    <div class="form-group">
                        <label>제목</label>
                        <input type="text" name="rtitle" placeholder="제목을 입력하세요">
                    </div>

                    <!-- 내용 -->
                    <div class="form-group">
                        <label>내용</label>
                        <textarea name="rcontent" placeholder="내용을 입력하세요"></textarea>
                    </div>

                    <!-- 평점 및 가게 특징 (가로 배치) -->
                    <div class="form-row-group">
                        <div class="form-group">
                            <label>평점</label>
                            <select name="rrate">
                                <option value="">별점 선택</option>
                                <option value="5.0">★★★★★ (5.0)</option>
                                <option value="4.0">★★★★☆ (4.0)</option>
                                <option value="3.0">★★★☆☆ (3.0)</option>
                                <option value="2.0">★★☆☆☆ (2.0)</option>
                                <option value="1.0">★☆☆☆☆ (1.0)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>가게 특징</label>
                            <input type="text" name="rfeature" placeholder="예: 주차 편리, 친절함 등">
                        </div>
                    </div>
                </div>

                <hr class="rating-line">

                <!-- 하단 버튼 영역 -->
                <div class="rating-action-row">
                    <a href="/guest/ratingList" class="btn-list">목록</a>
                    <button type="submit" class="btn-submit" onclick="return check()">등록</button>
                </div>
            </form>
        </div>
    </div>

    <br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>