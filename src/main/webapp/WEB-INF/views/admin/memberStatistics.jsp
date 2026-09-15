<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 통계</title>
<link rel="stylesheet" href="../css/statistics.css">
</head>

<body>
<%@ include file="../guest/header.jsp" %>
<div class="statistics-container">

	<div class="tab-menu">
	    <a href="/admin/storeStatistics" class="tab-btn">음식점/검색 통계</a>
	    <a href="/admin/memberStatistics" class="tab-btn active">회원 통계</a>
	    <a href="/admin/passStatistics" class="tab-btn">구독권 통계</a>
	</div>

    <h1>회원 통계</h1>
    
    <div class="kibana-dashboard">
        <iframe src="http://192.168.10.32:5601/app/dashboards#/view/af1d6800-b0c2-11f1-9151-a31dedf6e5af?embed=true&_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:'2026-09-01T03:05:02.846Z',to:now))&_a=(description:'',filters:!(),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:%EC%9D%B4%EC%A7%91%EC%96%B4%EB%95%8C_%ED%9A%8C%EC%9B%90%ED%86%B5%EA%B3%84,viewMode:view)" height="600" width="800"></iframe>
    </div>
<%@ include file="../guest/footer.jsp" %>
</div>

</body>
</html>