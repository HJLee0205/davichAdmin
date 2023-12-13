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
	<script type="text/javascript">
	</script>
</head>
<body>
<!--- contents --->
<div class="error">
	<div class="error_box">
		<h1 class="error_logo"><img src="/admin/img/common/f_logo.png" alt=""></h1>
		<div class="error_title">
			이용에 불편을 드려 죄송합니다.
		</div>
		<div class="error_text01">
			페이지의 경로가 잘못 입력되었거나 변경 혹은 삭제되어 요청하신 페이지를 찾을 수 없습니다.<br/>
			입력하신 경로가 정확한지 다시 한 번 확인해주시기 바랍니다.
		</div>
		
		<div class="btn_area">
			<button type="button" class="btn_error_prev" onclick="history.back();">뒤로가기</button>
			<a href="/admin"><button type="button" class="btn_error_main">관리자 홈</button></a>
		</div>
	</div>
	<div class="error_footer">Copyright ⓒ Davich Market.com  All Rights Reserved.</div>
</div>
<!---// contents --->
</body>
</html> 




