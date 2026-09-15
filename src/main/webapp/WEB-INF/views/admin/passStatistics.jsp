<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구독권 통계</title>
<link rel="stylesheet" href="../css/statistics.css">
</head>

<body>
<%@ include file="../guest/header.jsp" %>
<div class="statistics-container">

	<div class="tab-menu">
	    <a href="/admin/storeStatistics" class="tab-btn">음식점/검색 통계</a>
	    <a href="/admin/memberStatistics" class="tab-btn">회원 통계</a>
	    <a href="/admin/passStatistics" class="tab-btn active">구독권 통계</a>
	</div>

    <h1>구독권 통계</h1>
    
    <div class="kibana-dashboard">
        <iframe src="http://192.168.10.32:5601/app/dashboards#/view/165b8280-b0d3-11f1-9151-a31dedf6e5af?embed=true&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:'2025-12-31T03:05:02.846Z',to:now))&_a=(description:'2026%EB%85%84%201%EC%9B%94%20~%209%EC%9B%94%20%ED%98%84%EC%9E%AC',filters:!(),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:'%EC%9D%B4%EC%A7%91%EC%96%B4%EB%95%8C%20%EA%B5%AC%EB%8F%85%EA%B6%8C%20%ED%86%B5%EA%B3%84%20%EC%A0%95%EB%B3%B4',viewMode:view)" height="600" width="800"></iframe>
    </div>
<%@ include file="../guest/footer.jsp" %>
</div>

</body>
</html>