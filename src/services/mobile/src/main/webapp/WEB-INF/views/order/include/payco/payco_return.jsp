<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="/m/front/js/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    alert('1');
    try{
    var json = ${result};
    
    alert(json)
    window.opener.PaycoUtil.responseParamMapping(json); //응답데이터 세팅
    opener.document.getElementById("frmAGS_pay").action = '/m/front/order/order-insert';
    opener.document.getElementById("frmAGS_pay").submit();
    self.close();
    }catch(e){
        alert(e);
        
    }
});
</script>