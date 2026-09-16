<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>    
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이집어때 게시판</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardView.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/boardList.css">
<script>
	function showAnswerEdit(ano) {
	
	    // 기존 답변 내용 숨기기
	    document.getElementById("answer-content-" + ano).style.display = "none";
	
	    // 수정창 보여주기
	    document.getElementById("answer-edit-" + ano).style.display = "block";
	}
	
	function hideAnswerEdit(ano) {
	
	    // 기존 답변 내용 다시 보여주기
	    document.getElementById("answer-content-" + ano).style.display = "block";
	
	    // 수정창 숨기기
	    document.getElementById("answer-edit-" + ano).style.display = "none";
	}
</script>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
    <div class="board-wrapper">
        <div class="board-card">
            
            <!-- 상단 제목 영역 -->
            <div class="board-category">COMMUNITY</div>
            <h2 class="board-main-title">이집어때 게시판</h2>

            <!-- 게시글 제목 -->
            <h1 class="board-post-title">${view.btitle}</h1>

            <!-- 작성정보 (좌측 정렬) -->
            <div class="board-meta">
                <span><strong>작성자</strong> ${view.mname}</span>
                <span class="divider">|</span>
                <span><fmt:formatDate value="${view.bdate}" pattern="yyyy-MM-dd HH:mm" /></span>
                <span class="divider">|</span>
                <span><strong>조회수</strong> ${view.bhit}</span>
            </div>

            <!-- 상단 구분선 -->
            <hr class="board-line">

            <!-- 본문 내용 -->
            <div class="board-content">
                ${view.bcontent}
            </div>

            <!-- 하단 구분선 -->
            <hr class="board-line">
            
            <!-- 답변 영역 -->
            <c:if test="${view.bcategory == '비밀글'}">
				<div class="answer-section">
				
				    <h3 class="answer-title">답변</h3>
				
				    <!-- 답변 목록 -->
					<c:forEach var="answer" items="${answerList}">
					
					    <div class="answer-item">
					
					        <!-- 답변 작성자 / 날짜 / 버튼 -->
					        <div class="answer-meta">
					
					            <strong>${answer.mname}</strong>
					
					            <span class="divider">|</span>
					
					            <span>
					                <fmt:formatDate value="${answer.adate}"
					                                pattern="yyyy-MM-dd HH:mm" />
					            </span>
					
					            <!-- 관리자에게만 수정 / 삭제 표시 -->
					            <sec:authorize access="hasRole('ADMIN')">
					
					                <button type="button"
					                        onclick="showAnswerEdit(${answer.ano})">
					                    수정
					                </button>
					
					                <form action="/admin/answerDelete"
					                      method="post"
					                      style="display:inline;">
					
					                    <input type="hidden"
					                           name="ano"
					                           value="${answer.ano}">
					
					                    <input type="hidden"
					                           name="bno"
					                           value="${answer.bno}">
					
					                    <button type="submit"
					                            onclick="return confirm('정말 삭제하시겠습니까?');">
					                        삭제
					                    </button>
					
					                </form>
					
					            </sec:authorize>
					
					        </div>
					
					        <!-- 기존 답변 내용 -->
					        <div class="answer-content" id="answer-content-${answer.ano}">${answer.acontent}</div>
					
					        <!-- 답변 수정 영역 -->
					        <sec:authorize access="hasRole('ADMIN')">
					
					            <div class="answer-edit"
					                 id="answer-edit-${answer.ano}"
					                 style="display:none;">
					
					                <form action="/admin/answerUpdate"
					                      method="post">
					
					                    <input type="hidden"
					                           name="ano"
					                           value="${answer.ano}">
					
					                    <input type="hidden"
					                           name="bno"
					                           value="${answer.bno}">
					
					                    <textarea name="acontent"
										          required>${answer.acontent}</textarea>
										
										<div class="answer-edit-buttons">
										
										    <button type="submit">
										        수정 완료
										    </button>
										
										    <button type="button"
										            onclick="hideAnswerEdit(${answer.ano})">
										        취소
										    </button>
										
										</div>
					
					                </form>
					
					            </div>
					
					        </sec:authorize>
					
					    </div>
					
					</c:forEach>
				
				    <!-- 관리자 답변 작성 -->
				    <sec:authorize access="hasRole('ADMIN')">
				
				        <div class="answer-write">
				
				            <h3 class="answer-title">답변 작성</h3>
				
				            <form action="/admin/answerWrite" method="post">
				
				                <input type="hidden"
				                       name="bno"
				                       value="${view.bno}">
				
				                <textarea name="acontent"
				                          placeholder="답변을 입력해주세요."
				                          required></textarea>
				
				                <button type="submit">답변 등록</button>
				
				            </form>
				
				        </div>
				
				    </sec:authorize>
				
				</div>
				
				<hr class="board-line">
			</c:if>

            <!-- 하단 버튼 영역 (목록 및 관리자 삭제 버튼) -->
            <div class="board-action-row">
                <div class="board-btn-wrap">
                    <a href="/guest/boardList" class="btn-list">목록</a>
                </div>
                
                <!-- 관리자에게만 삭제 버튼 표시 -->
                <sec:authorize access="hasRole('ADMIN')">
                    <form action="/board/boardDelete" method="post">
                        <input type="hidden" name="bno" value="${view.bno}">
                        <button type="submit" class="btn-delete" onclick="return confirm('정말 삭제하시겠습니까?');">
                            삭제
                        </button>
                    </form>
                </sec:authorize>
            </div>

        </div>
    </div>
    
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>