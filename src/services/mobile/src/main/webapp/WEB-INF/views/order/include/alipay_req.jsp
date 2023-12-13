<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!------------------------------------------------------------------------------

FILE NAME : alipay_req.jsp
DATE : 2014/09
Author : MI1
Description :   Alipay Front Test Page1234
                http://www.inicis.com
                Copyright 2014 KG Inicis, Co. All rights reserved.
------------------------------------------------------------------------------>
<script>
    AlipayUtil = {
          returnUrl:location.protocol + '//' + location.host + '/m/front/order/alipay-result'
          /*returnUrl:location.protocol + '//fa492a24.ngrok.io/front/order/alipay-result'*/
          ,openAlipay:function() {
            var timestamp = AlipayUtil.getTimeStamp();

            if(AlipayUtil.setPopupDataCofig(timestamp)){
                 $("#alipay_info").attr("accept-charset","euc-kr");
                 $('#alipay_info').submit();
            }

        }
        , setPopupDataCofig:function(timestamp) {
            var title = 'ALIPAY';
            if(AlipayUtil.requestParamMapping(timestamp)) { //요청 파라미터 매핑
                window.open('', title, 'width=700,height=700,scrollbars=yes'); //ALIPAY 결제 팝업오픈
                $('#alipay_info').attr('target', title);
                return true;
            }else{
                return false;
            }
        }
        , getTimeStamp:function() {
            var d = new Date();
            var s =
                AlipayUtil.leadingZeros(d.getFullYear(), 4) + '' +
                AlipayUtil.leadingZeros(d.getMonth() + 1, 2) + '' +
                AlipayUtil.leadingZeros(d.getDate(), 2) + '' +
                AlipayUtil.leadingZeros(d.getHours(), 2) + '' +
                AlipayUtil.leadingZeros(d.getMinutes(), 2) + '' +
                AlipayUtil.leadingZeros(d.getSeconds(), 2);
            return s;
        }
        , leadingZeros:function(n, digits) {
            var zero = '';
            n = n.toString();

            if (n.length < digits) {
                for (i = 0; i < digits - n.length; i++)
                    zero += '0';
            }
            return zero + n;
        }
        , getHashData:function(vo) {
            var url = '/m/front/order/alipay-hashdata-info',
            dfd = jQuery.Deferred();

            AlipayUtil.getCustomJSON(url, vo, function(result) {
                if (result == null || result.success != true) {
                    return;
                }

                dfd.resolve(result.data);
                $('input[name=hashdata]').val(result.data.hashdata);
            });

            return dfd.promise();
        }
        , getCustomJSON : function(url, param, callback) { //hashdata를 동기방식(async:false)으로 불러오기위해서 따로 메서드 생성
            $.ajax({
                type : 'post',
                url : url,
                data : param,
                async : false,
                dataType : 'json'
            }).done(function(result) {
                if (result) {
                    Dmall.AjaxUtil.viewMessage(result, callback);
                } else {
                    callback();
                }
            }).fail(function(result) {
                Dmall.AjaxUtil.viewMessage(result.responseJSON, callback);
            });
        }
        , requestParamMapping:function(timestamp) { //페이팔 요청파라미터 세팅
            $('input[name=P_NEXT_URL]').val(AlipayUtil.returnUrl);
            $('input[name=P_GOODS]').val('${ordNo}');
            $('input[name=P_AMT]').val($('#paymentAmt').val());
            var ordrNm = $('#ordrNm').val();
            var err = 0;

            for (var i=0; i<ordrNm.length; i++)  {
                var chk = ordrNm.substring(i,i+1);
                if(!chk.match(/[a-z]|[A-Z]/)) {
                    err = err + 1;
                }
            }
            if (err > 0) {
                Dmall.LayerUtil.alert("주문자 명은 영문만 입력가능합니다.","확인");
                return false;
            }else{
                return true;
            }
            $('input[name=P_UNAME]').val(ordrNm);
            $('input[name=P_EMAIL]').val($('#email01').val()+'@'+$('#email02').val());
        }
        , responseParamMapping:function(map) { //페이팔 응답파라미터 세팅
            $('#confirmResultCd').val(map.P_STATUS); //응답코드(성공:00, 실패:01)
            $('#confirmResultMsg').val(map.P_RESULTMSG); //결과메세지(Format: CODE | MSG)
            $('#txNo').val(map.P_TID); //거래번호
            $('#ordNo').val(map.P_OID); //상점 거래 주문ID, ordNo
            $('#P_TID').val(map.P_TID); //거래번호
        }
    }
</script>

<%--
운영
https://inilite.inicis.com/inipayStdAlipay
개발
https://javadev.inicis.com/inipayStdAlipay
--%>

     <c:if test="${server ne 'product'}">
        <form id="alipay_info" method="post" action="https://devmobile1.inicis.com/smart/etc/">
        <%--<form id="alipay_info" method="post" action="https://inilite.inicis.com/inipayStdAlipay" onSubmit="return conf(this)">--%>
    </c:if>
    <c:if test="${server eq 'product'}">
        <form id="alipay_info" method="post" action="https://mobile.inicis.com/smart/etc/"> <!-- 실결제 -->
    </c:if>

     <input type="hidden" name="P_MID"                   value="${alipayPaymentConfig.data.alipayPaymentStoreId}">
     <input type="hidden" name="P_OID"                   value="${ordNo}">
     <input type="hidden" name="P_AMT"                   value="">
     <input type="hidden" name="P_UNAME"                 value="">
     <input type="hidden" name="P_NOTI"                  value="">
     <input type="hidden" name="P_NEXT_URL"              value="">
     <input type="hidden" name="P_NOTI_URL"              value="${siteDomain}/inicis-stdpay-notice">
     <input type="hidden" name="P_GOODS"                 value="">
     <input type="hidden" name="P_CURRENCY"              value="WON">
     <input type="hidden" name="P_MOBILE"                value="">
     <input type="hidden" name="P_EMAIL"                 value="">
     <input type="hidden" name="P_RESERVED"              value="etc_paymethod=APAY&alipay_noti=Y&alipay_timeout=5m">
</form>
