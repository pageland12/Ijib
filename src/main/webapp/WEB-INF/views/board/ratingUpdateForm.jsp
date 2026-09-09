<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기 수정</title>
<script src="/js/ratingWU.js"></script>
</head>
<body>
	<%@ include file="../guest/header.jsp" %>
    
	<form name="ratingUpdateForm" method="post" action="/board/ratingUpdate">
		<input type="hidden" name="rno" value="${update.rno}">
		<table border=1 width=400>
			<tr>
				<th>제목</th>
				<td><input type="text" name="rtitle" value="${update.rtitle}"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="rcontent">${update.rcontent}</textarea></td>
			</tr>
			<tr>
            	<th>평점</th>
                    <td>
                        <select name="rrate">
                            <option value="5.0" ${update.rrate == 5.0 ? 'selected' : ''}> ★★★★★ (5.0) </option>
                            <option value="5.0" ${update.rrate == 4.0 ? 'selected' : ''}> ★★★★ (4.0) </option>
                            <option value="5.0" ${update.rrate == 3.0 ? 'selected' : ''}> ★★★ (3.0) </option>
                            <option value="5.0" ${update.rrate == 2.0 ? 'selected' : ''}> ★★ (2.0) </option>
                            <option value="5.0" ${update.rrate == 1.0 ? 'selected' : ''}> ★ (1.0) </option>
                        </select>
                    </td>
                <th>가게 특징</th>
                	<td><input type="text" name="rfeature" value="${update.rfeature}"></td>
                </tr>	
		</table>
		<a href="/guest/ratingList">목록</a>
		<input type="submit" value="등록" onclick="return check()">
	</form>

	<br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>