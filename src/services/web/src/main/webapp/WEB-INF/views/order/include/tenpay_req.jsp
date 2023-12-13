<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
    var TenpayUtil = {
        returnUrl:location.protocol + '//' + location.host + '/front/order/tenpay-result'
        /*returnUrl:location.protocol + '//fa492a24.ngrok.io/front/order/tenpay-result'*/
        , openTenpay:function() {
             var timestamp = TenpayUtil.getTimeStamp();
            TenpayUtil.getHashData(TenpayUtil.vo("${ordNo}", timestamp));
            if(TenpayUtil.setPopupDataCofig(timestamp)) {
                $('#tenpay_info').submit();
            }

        }
        , setPopupDataCofig:function(timestamp) {
            var title = 'TENPAY';
            if(TenpayUtil.requestParamMapping(timestamp)) { //요청 파라미터 매핑
                window.open('', title, 'width=700,height=700,scrollbars=yes'); //TENPAY 결제 팝업오픈

                $('#tenpay_info').attr('target', title);
                return true;
            }else{
                return false;
            }
        }
        , getTimeStamp:function() {
            var d = new Date();
            var s =
                TenpayUtil.leadingZeros(d.getFullYear(), 4) + '' +
                TenpayUtil.leadingZeros(d.getMonth() + 1, 2) + '' +
                TenpayUtil.leadingZeros(d.getDate(), 2) + '' +
                TenpayUtil.leadingZeros(d.getHours(), 2) + '' +
                TenpayUtil.leadingZeros(d.getMinutes(), 2) + '' +
                TenpayUtil.leadingZeros(d.getSeconds(), 2);
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
            var url = '/front/order/tenpay-hashdata-info',
            dfd = jQuery.Deferred();

            TenpayUtil.getCustomJSON(url, vo, function(result) {
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
        , requestParamMapping:function(timestamp) { //TENPAY 요청파라미터 세팅
            $('input[name=timestamp]').val(timestamp);
            $('input[name=returnurl]').val(TenpayUtil.returnUrl);
            /*$('input[name=goodname]').val($('#ordGoodsInfo').val());*/
            $('input[name=goodname]').val($('[name=goodsNo]:eq(0)').val());
            $('input[name=price]').val($('#paymentAmt').val());
            /*$('input[name=buyername]').val($('#ordrNm').val());*/
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


            $('input[name=buyername]').val(ordrNm);
            $('input[name=buyertel]').val($('#ordrMobile01').val()+'-'+$('#ordrMobile02').val()+'-'+$('#ordrMobile03').val());
            $('input[name=buyeremail]').val($('#email01').val()+'@'+$('#email02').val());

        }
        , responseParamMapping:function(map) { //TENPAY 응답파라미터 세팅
            $('#confirmResultCd').val(map.resultcode); //응답코드(성공:00, 실패:01)
            $('#confirmResultMsg').val(map.resultmessage); //결과메세지(Format: CODE | MSG)
            $('#txNo').val(map.tid); //거래번호
            $('#ordNo').val(map.webordernumber); //상점 거래 주문ID, ordNo
            $('#confirmDttm').val(map.tpayauthdate); //TENPAY 승인 처리 날짜(yyyyMMdd hhmmss), confirmDttm


        }
        , vo:function(orderNo, timestamp) {
            return {
                'timestamp':timestamp
                , 'reqtype':'authreq'
                , 'webordernumber':orderNo
                , 'currency':'WON'
                , 'price':$('#paymentAmt').val()
            };
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
        <form id="tenpay_info" method="post" action="https://javadev.inicis.com/inipayStdTenpay">
        <%--<form id="tenpay_info" method="post" action="https://inilite.inicis.com/inipayStdTenpay">--%> <!-- 실결제 -->
        <%-- 테스트모드 배포시 삭제--%>
        <input type="hidden" name="testmode"  value="true">
        <input type="hidden" name="isdev"  value="dev">
        <%-- // 테스트모드 배포시 삭제--%>
    </c:if>
    <c:if test="${server eq 'product'}">
        <form id="tenpay_info" method="post" action="https://inilite.inicis.com/inipayStdTenpay"> <!-- 실결제 -->
    </c:if>

    <input type="hidden" name="mid"                 value="${tenpayPaymentConfig.data.tenpayPaymentStoreId}"> <%--상점아이디 (필수)--%>
    <input type="hidden" name="timestamp"           value=""><%--yyyyMMddHHmmss (필수) --%>
    <input type="hidden" name="webordernumber"      value="${ordNo}"><%-- 상점 주문 ID (필수)--%>
    <input type="hidden" name="goodname"            value=""> <%--상품명 (Only English) (필수) --%>
    <input type="hidden" name="currency"            value="WON"> <!-- 원: WON, 달러: USD (필수)-->
    <input type="hidden" name="price"               value=""><%--상품 가격 (Only number) (필수)--%>
    <input type="hidden" name="buyername"           value=""><%--고객 성명 (Only English) (필수) --%>
    <input type="hidden" name="buyertel"            value=""><%--고객 전화번호 또는 휴대폰--%>
    <input type="hidden" name="buyeremail"          value=""><%--고객 이메일 --%>
    <input type="hidden" name="reqtype"             value="authreq"><%--타입 설정값으로 고정값 입니다. authreq 으로 설정해야 합니다. (필수) --%>
    <input type="hidden" name="returnurl"           value=""><%-- 상점이 Web에서 결과 응답을 받을 URL (필수) --%>
    <input type="hidden" name="notiurl"             value="${siteDomain}/inicis-stdpay-notice"><%--최종 결제 결과를 통보 받는 노티 URL 입니다. (필수)--%>
    <%--<input type="hidden" name="notiurl"             value="//fa492a24.ngrok.io/inicis-stdpay-notice">--%><%--최종 결제 결과를 통보 받는 노티 URL 입니다. (필수)--%>
    <input type="hidden" name="order_vaild_time"    value=""><%--결제유효시간 (단위 : 초, 숫자만 입력, 최대 21600초) --%>
    <input type="hidden" name="idletimenoti"            value=""><%--설정된 시간만큼 노티 전송 대기 (단위 : 분)--%>
    <input type="hidden" name="hashdata"            value=""><%-- 결제 데이터 해쉬 (필수)--%>


</form>
