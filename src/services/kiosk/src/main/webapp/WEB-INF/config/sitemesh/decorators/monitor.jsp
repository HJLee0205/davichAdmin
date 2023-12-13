<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<c:set var="CTX_CUR" value="${requestScope['javax.servlet.forward.servlet_path']}"/>
<!doctype html>
<html lang="ko">
<head>
<%

response.setHeader("Pragma","no-cache"); 

response.setDateHeader("Expires",0); 

response.setHeader("Cache-Control", "no-cache");

%>
    <title>다비치 고객맞이 시스템</title>
    <meta name="apple-mobile-web-app-capable" content="yes" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
    <link rel="stylesheet" type="text/css" href="/kiosk/css/style.css" /> <!-- 스킨 css -->
	<!--[if lt IE 9]>
	<script type="text/javascript" src="/kiosk/js/html5shiv.js"></script>
	<script type="text/javascript" src="/kiosk/js/html5shiv.printshiv.js"></script>
	<![endif]-->
	<script type="text/javascript" src="/kiosk/js/jquery-1.12.2.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/jquery-ui.1.9.2.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/jquery.bxslider.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/style.js"></script> 
	<script type="text/javascript" src="/kiosk/js/common.js"></script> 
        
    <c:if test = "${loginVo.loginId == '' || loginVo.loginId == null}">
	<script type="text/javascript">
		alert("로그인 하세요.");
		location.href = "/kiosk/login.do";
	</script>
	</c:if>
</head>
<body>
<form name="kioskForm" method="post" style="height:100%">
<input type="hidden" name="store_no" id="store_no" value="${loginVo.strCode}">
<input type="hidden" name="login_id" id="login_id" value="${loginVo.loginId}">
	<!-- 컨텐츠 -->
	<sitemesh:write property='body'/>
	<!--// 컨텐츠 -->
</form>
</body>
</html>