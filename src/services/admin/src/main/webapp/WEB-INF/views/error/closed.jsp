<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>  
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>  
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" CONTENT="0"> 
	<meta http-equiv="Cache-Control" content="no-cache" />
	<title></title>
	<link rel="stylesheet" type="text/css" href="/admin/css/include.css">
	<link rel="stylesheet" type="text/css" href="/admin/css/custom.css">
	<script type="text/javascript">
	</script>
</head>
<body>
<!--- contents --->
<div class="error">
	<div class="error_box">
		<%--<h1 class="error_logo"><img src="/admin/img/common/f_logo.png" alt=""></h1>
		<div class="error_title">
			해당 쇼핑몰은 이용 정지되었습니다.
		</div>
		<div class="error_text01">
			해당 쇼핑몰은 이용기간이 만료되거나<br/>
			고객의 요청에 따라 이용 중지, 정지 혹은 폐쇄되었습니다.<br/>
			다시 한번 확인해주시기 바랍니다.
		</div>
		<div class="error_text02">
			감사합니다.
		</div>--%><img src="/admin/img/common/event_error.jpg" style="padding-top:24px;">
		<div class="btn_area">
			<button type="button" class="btn_error_prev" style="margin-right:6px" onclick="history.back();">뒤로가기</button>
			<a href="/admin"><button type="button" class="btn_error_main">홈 바로가기</button></a>
		</div>
	</div>
	<div class="error_footer">COPYRIGHT  (C) D-Mall, ALL RIGHTS RESERVED</div>
</div>
<!---// contents --->
</body>
</html>




