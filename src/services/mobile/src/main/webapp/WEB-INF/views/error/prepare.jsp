<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<link rel="stylesheet" type="text/css" href="/front/css/include.css" /> <!--- 공통 css ---->
	<script type="text/javascript">
	</script>
</head>
<body>
<!--- contents --->
<div class="error">
	<div class="error_box">
		<%--<h1 class="error_logo"><img src="/front/img/member/error_logo.png" alt=""></h1>
		<div class="error_title">
			현재 쇼핑몰이 생성되고 있습니다.
		</div>
		<div class="error_text01">
			고객님께서 신청해주신 쇼핑몰이 생성되고 있습니다.<br/>
			1시간 뒤 다시 한번 확인해주시기 바랍니다.<br/>
			쇼핑몰 생성 완료 시 SMS 및 이메일로 완료 결과를 안내해드립니다.
		</div>
		<div class="error_text02">
			감사합니다.
		</div>
		<div class="btn_area" style="height:100px">

		</div>--%>
		<img src="/front/img/common/event_error.jpg" style="padding-top:24px;">
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




