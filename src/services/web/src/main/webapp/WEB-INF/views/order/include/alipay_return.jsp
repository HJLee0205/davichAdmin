<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    var json = ${result};
    if(json.resultcode === '00') {
        window.opener.AlipayUtil.responseParamMapping(json); //응답데이터 세팅
        opener.document.getElementById("frmAGS_pay").action = '/front/order/order-insert';
        opener.document.getElementById("frmAGS_pay").submit();
        self.close();
    } else {
        alert('결제승인에 실패하였습니다. [code::'+json.resultcode+'][Message::'+json.resultmessage+']');
        self.close();
    }
});
</script>
