<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>음식점/검색 통계</title>
<link rel="stylesheet" href="../css/statistics.css">
</head>

<body>
<%@ include file="../guest/header.jsp" %>
<div class="statistics-container">

	<div class="tab-menu">
	    <a href="/admin/storeStatistics" class="tab-btn active">음식점/검색 통계</a>
	    <a href="/admin/memberStatistics" class="tab-btn">회원 통계</a>
	    <a href="/admin/passStatistics" class="tab-btn">구독권 통계</a>
	</div>

    <h1>음식점/검색 통계</h1>
    
    <div class="kibana-dashboard">
        <iframe src="http://192.168.10.32:5601/app/dashboards#/view/09f8b040-ada8-11f1-99e1-25f1eca6aed7?embed=true&_a=(description:'',filters:!(),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:%EC%9D%B4%EC%A7%91%EC%96%B4%EB%95%8C_%EC%9D%8C%EC%8B%9D%EC%A0%90%2F%EA%B2%80%EC%83%89%ED%86%B5%EA%B3%84,viewMode:view)&_g=(filters:!(),query:(language:kuery,query:''),refreshInterval:(pause:!t,value:0),time:(from:'2026-09-01T03:05:02.846Z',to:now))" height="600" width="800"></iframe>
    </div>
<%@ include file="../guest/footer.jsp" %>
</div>

</body>
</html>