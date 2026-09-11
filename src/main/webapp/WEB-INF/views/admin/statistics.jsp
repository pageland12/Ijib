<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>통계</title>

    <style>
        .statistics-container {
            width: 100%;
            padding: 20px;
            box-sizing: border-box;
        }

        .kibana-dashboard {
            width: 100%;
            height: 800px;
        }

        .kibana-dashboard iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
    </style>
</head>

<body>
<%@ include file="../guest/header.jsp" %>
<div class="statistics-container">

    <h1>통계</h1>

    <div class="kibana-dashboard">
        <iframe
            src="http://192.168.10.32:5601/app/dashboards#/view/09f8b040-ada8-11f1-99e1-25f1eca6aed7?embed=true&_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:now-1h,to:now))&_a=(description:'',filters:!(),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:%EC%A7%91%EC%96%B4%EB%95%8C%ED%86%B5%EA%B3%84,viewMode:view)">
        </iframe>
    </div>
<%@ include file="../guest/footer.jsp" %>
</div>

</body>
</html>