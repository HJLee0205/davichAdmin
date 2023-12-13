<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.util.*" %>
<script type="text/javascript" src="/m/front/js/jquery-1.12.2.min.js"></script>
<script>
jQuery(document).ready(function() {
/*     $("#authUrl",opener.document).val('${io.authUrl}');
    $("#netCancel",opener.document).val('${io.netCancel}');
    $("#authToken",opener.document).val($("#cToken").text());
 */
 <c:choose>
 <c:when test="${P_STATUS=='00'}">
    try{
    opener.Dmall.waiting.payStart();

     $("#frmAGS_pay input[name=P_STATUS]",opener.document).val("${P_STATUS}");
     $("#frmAGS_pay input[name=P_REQ_URL]",opener.document).val("${P_REQ_URL}");
     $("#frmAGS_pay input[name=P_TID]",opener.document).val("${P_TID}");
 
    $("#frmAGS_pay",opener.document).attr('accept-charset','UTF-8');
    $("#frmAGS_pay",opener.document).attr('target','_self');
    $('#frmAGS_pay',opener.document).attr('action','/m/front/order/order-insert');
    $("#frmAGS_pay",opener.document).submit();
    }catch(e){
        alert(e);
    }
 </c:when>
 <c:otherwise>
    alert('결제실패');
    window.close();
 </c:otherwise>
 </c:choose>
   window.close();
});
</script>
<%-- <textarea id="cToken" style="height: 0px;">${io.authToken}</textarea> --%>
 