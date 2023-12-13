<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script>
jQuery(document).ready(function() {
    opener.Dmall.waiting.payStart();
    $("#authUrl",opener.document).val('${io.authUrl}');
    $("#netCancel",opener.document).val('${io.netCancel}');
    $("#authToken",opener.document).val($("#cToken").text());
    $("#frmAGS_pay",opener.document).attr('target','_self');
    $('#frmAGS_pay',opener.document).attr('action','/front/order/order-insert');
    $("#frmAGS_pay",opener.document).submit();
});
</script>
<textarea id="cToken" style="height: 0px;">${io.authToken}</textarea>
