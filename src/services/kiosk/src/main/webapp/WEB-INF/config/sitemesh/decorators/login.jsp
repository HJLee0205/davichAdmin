<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<!doctype html>
<html lang="ko">
<head>
<%

response.setHeader("Pragma","no-cache"); 

response.setDateHeader("Expires",0); 

response.setHeader("Cache-Control", "no-cache");

%>
    <title>다비치 고객맞이 시스템</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="mobile-web-app-capable" content="yes">
	<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT">
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<link rel="manifest" href="/kiosk/js/manifest.json">
    <link rel="stylesheet" type="text/css" href="/kiosk/css/style.css" /> <!-- 스킨 css -->
	<link rel="stylesheet" type="text/css" href="/kiosk/css/mobile.css" />
	
	<!--[if lt IE 9]>
	<script type="text/javascript" src="/kiosk/js/html5shiv.js"></script>
	<script type="text/javascript" src="/kiosk/js/html5shiv.printshiv.js"></script>
	<![endif]-->
	
	<script type="text/javascript" src="/kiosk/js/jquery-1.12.2.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/jquery-ui.1.9.2.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/jquery.bxslider.min.js"></script>
	<script type="text/javascript" src="/kiosk/js/style.js"></script> 
	<script type="text/javascript" src="/kiosk/js/common.js"></script>
	<script type="text/javascript">
	function setCookie(cookieName, value, exdays){
	   var exdate = new Date();
	   exdate.setDate(exdate.getDate() + exdays);
	   var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
	   document.cookie = cookieName + "=" + cookieValue;
	}

	function deleteCookie(cookieName){
	   var expireDate = new Date();
	   expireDate.setDate(expireDate.getDate() - 1);
	   document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}

	function getCookie(cookieName) {
	   cookieName = cookieName + '=';
	   var cookieData = document.cookie;
	   var start = cookieData.indexOf(cookieName);
	   var cookieValue = '';
	   if(start != -1){
	      start += cookieName.length;
	      var end = cookieData.indexOf(';', start);
	      if(end == -1)end = cookieData.length;
	      cookieValue = cookieData.substring(start, end);
	   }
	   return unescape(cookieValue);
	}
	
	$(function(){
		var str_code = getCookie("str_code");
		if(str_code) {
			$("#purpose_check01").attr("checked", true);
			$("#str_code").val(str_code);
			$("#login_id").val(getCookie("login_id"));
			$("#login_pw").val(getCookie("login_pw"));
		}
		
		$(".order_check").click(function(){
			 var keepLogin = $("#purpose_check01");
			 if(keepLogin[0].checked){
			     setCookie("str_code", $("#str_code").val(), 30); 
			     setCookie("login_id", $("#login_id").val(), 30); 
			     setCookie("login_pw", $("#login_pw").val(), 30); 
			 } else {
			     deleteCookie("str_code");
			     deleteCookie("login_id");
			     deleteCookie("login_pw");
			 }
		 });
	});	 
	</script>
</head>
<body>
	<div id="login_wrap">
		<!-- 컨텐츠 -->
		<sitemesh:write property='body'/>
		<!--// 컨텐츠 -->
	
		<!-- 푸터영역 -->
		<div id="login_footer">
		Copyright (C) 2018 Davich Optical Chain Store
		</div><!--// login_footer -->		
		<!--// 푸터영역 -->	
	</div>
</body>
</html>