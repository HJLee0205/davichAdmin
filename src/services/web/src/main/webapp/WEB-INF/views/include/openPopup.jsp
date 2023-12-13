<%@ page contentType="text/html;charset=UTF-8" language="java"  %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.js"></script>


<script>
$(document).ready(function() {
    $('#content').html('${so.content}');
});

function addCookie(){
	var ckkClick = $('input:checkbox[id=today_check]').is(':checked');
	if(ckkClick){
    var expdate = new Date();
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * '${so.cookieValidPeriod}');
    var name = "cookieName_${so.popupNo}";
    var value = "cookieValue_${so.popupNo}";
    window.opener.setCookie(name,value,expdate);
    }
    window.close();

}
</script>	
<style type="text/css">
	#content p {text-align:center !important}
	.popup_btn_area {margin-top:0;padding:10px;overflow:hidden;background:#fff;}
	.today_check {float:left;color:#666;font-family: 'NotoSansKR', Arial, Helvetica, sans-serif;font-size:14px;font-weight:300;}
	.today_cancel {float:right;color:#fff;font-size:12px;height:30px;line-height:28px;width:65px;background:#333;border:1px solid #4d4f52;}
	.today_check input[type="checkbox"] {display:none;}
	.today_check input[type="checkbox"] label {cursor:pointer}
	.today_check input[type="checkbox"] + label span {display:inline-block;width:17px;height:17px;margin:0 10px -3px 0;vertical-align:0;background:url(/front/img/common/order_check.gif) 0 top no-repeat;cursor:pointer;}
	.today_check input[type="checkbox"]:checked + label span {background:url(/front/img/common/order_check.gif) 0 bottom no-repeat}
</style>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${so.popupNm}</title>
</head>
<body style="margin:0">
<div id="content"></div>
<div id="div"></div>
 <div class="popup_btn_area popdloat">
	<div class="today_check">		
		<input type="checkbox" id="today_check">
		<label for="today_check"><span></span>${so.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
	</div>
	<button type="button" id="addCookieClick" onclick="addCookie()" class="today_cancel">닫기</button>
</div>  
<!-- <button name="addCookieClick" id = "addCookieClick" onclick="addCookie()" >${so.cookieValidPeriod}일 동안 안보기</button>> -->
</body>
</html>