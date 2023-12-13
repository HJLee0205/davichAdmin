<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>
<%@ page import="aegis.pgclient.*,java.text.*,java.net.*,java.lang.*" %>
<%@ page import="dmall.framework.common.util.*" %>
<%@ page import="kr.co.allthegate.mobile.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript" src="${_MOBILE_PATH}/front/js/jquery-1.12.2.min.js"></script>
<script src="${_MOBILE_PATH}/front/js/lib/jquery/jquery.cookie.js" charset="utf-8"></script>

<script>


jQuery(document).ready(function() {
    
 try{
    
     alert($.cookie('orderConts'));
    return;
    
	$("#frmAGS_pay input[name=tracking_id]",opener.document).val("${tracking_id}");
	$("#frmAGS_pay input[name=transaction]",opener.document).val("${transaction}");
	$("#frmAGS_pay input[name=store_id]",opener.document).val("${store_id}");
	
	$("#frmAGS_pay",opener.document).attr('target','_self');
	$('#frmAGS_pay',opener.document).attr('action','/m/front/order/order-insert');
	$("#frmAGS_pay",opener.document).submit();
    
	self.close();
	
	
 }catch(e){
     alert(e);
 }
 
});
</script>
<%-- ${info} --%>

<c:forEach var="i" items="${info}">
    <input type="hidden" name='${i.key}' id='${i.key}' value='${i.value}' />
    ${i.key}=>${i.value}</br>
</c:forEach>
--------------------------------------<br>
<c:forEach var="i" items="${result}">
    <input type="hidden" name='${i.key}' id='${i.key}' value='${i.value}' />
    ${i.key}=>${i.value}</br>
</c:forEach>

--------------------------------------<br>

${po}
<!-- 승인프로세스 필수값 -->
<!--     <input type="hidden" name="tracking_id" value="">
    <input type="hidden" name="transaction" value="">
    <input type="hidden" name="store_id" value=""> -->