<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${_MOBILE_PATH}/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    var json = ${result};
    if(json.P_STATUS === '00') {
        window.opener.PayPalUtil.responseParamMapping(json); //응답데이터 세팅
        $("#frmAGS_pay").attr("accept-charset",""); 
        opener.document.getElementById("frmAGS_pay").target="_self";
        opener.document.getElementById("frmAGS_pay").action = '/m/front/order/order-insert';
        opener.document.getElementById("frmAGS_pay").submit();
        self.close();
    } else {
        alert('결제승인에 실패하였습니다. [code::'+json.P_STATUS+'][Message::'+json.P_RMESG1+']');
        self.close();
    }
});
</script>
