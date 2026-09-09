<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>후기 등록</title>
</head>
<body>
    <%@ include file="../guest/header.jsp" %>
    
	<form name="ratingWriteForm" method="post" action="/board/ratingWrite">
		<input type="hidden" name="sno" value="${sno}">
		<table border=1 width=400>
			<tr>
				<th>제목</th>
				<td><input type="text" name="rtitle"></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name="rcontent" ></textarea></td>
			</tr>
			<tr>
            	<th>평점</th>
                    <td>
                        <select name="rrate">
                            <option value="5.0">★★★★★ (5.0)</option>
                            <option value="4.0">★★★★☆ (4.0)</option>
                            <option value="3.0">★★★☆☆ (3.0)</option>
                            <option value="2.0">★★☆☆☆ (2.0)</option>
                            <option value="1.0">★☆☆☆☆ (1.0)</option>
                        </select>
                    </td>
                <th>가게 특징</th>
                	<td><input type="text" name="rfeature"></td>
                </tr>	
		</table>
		<a href="/guest/ratingList">목록</a>
		<input type="submit" value="등록">
	</form>

	<br>
    <%@ include file="../guest/footer.jsp" %>
</body>
</html>