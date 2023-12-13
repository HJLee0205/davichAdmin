<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!------------------------------------------------------------------------------

FILE NAME : paypal.jsp
DATE : 2014/09
Author : MI1
Description :   Paypal Front Test Page1234
                http://www.inicis.com
                Copyright 2014 KG Inicis, Co. All rights reserved.
------------------------------------------------------------------------------>
<script>
    PayPalUtil = {
          openPaypal:function() {
             var timestamp = PayPalUtil.getTimeStamp();
            //PayPalUtil.getHashData(PayPalUtil.vo("${ordNo}", timestamp));
            PayPalUtil.setPopupDataCofig(timestamp);
            /* $("#frmAGS_pay").attr("accept-charset","euc-kr"); */ 
            $('#frmAGS_pay').attr("action","https://mobile.inicis.com/smart/etc/");
            $('#frmAGS_pay').submit();
        }
        , setPopupDataCofig:function(timestamp) {
            var title = 'PAYPAL';
            window.open('', title, 'width=700,height=700,scrollbars=yes'); //페이팔 결제 팝업오픈
            PayPalUtil.requestParamMapping(timestamp); //요청 파라미터 매핑
            $('#frmAGS_pay').attr('target', title);
        }
        , getTimeStamp:function() {
            var d = new Date();
            var s =
                PayPalUtil.leadingZeros(d.getFullYear(), 4) + '' +
                PayPalUtil.leadingZeros(d.getMonth() + 1, 2) + '' +
                PayPalUtil.leadingZeros(d.getDate(), 2) + '' +
                PayPalUtil.leadingZeros(d.getHours(), 2) + '' +
                PayPalUtil.leadingZeros(d.getMinutes(), 2) + '' +
                PayPalUtil.leadingZeros(d.getSeconds(), 2);
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
            var url = '/m/front/order/paypal-hashdata-info',
            dfd = jQuery.Deferred();

            PayPalUtil.getCustomJSON(url, vo, function(result) {
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
            //$('input[name=timestamp]').val(timestamp);
            //$('input[name=returnurl]').val(PayPalUtil.returnUrl);
            
            $('input[name=P_MNAME]').val('');    
            $('input[name=P_NEXT_URL]').val('${siteDomain}/paypal-result');
            $('input[name=P_GOODS]').val('${ordNo}');
            $('input[name=P_AMT]').val($('#paymentAmt').val());
            //paypal 모바일 에선 한글 입력 불가-> 로그인ID 로 대체
            $('input[name=P_UNAME]').val("${user.session.loginId}");
            
            //$('input[name=buyertel]').val($('#ordrTel01').val()+'-'+$('#ordrTel02').val()+'-'+$('#ordrTel03').val());
            $('input[name=P_EMAIL]').val(encodeURIComponent($('#email01').val()+'@'+$('#email02').val()));
            
            //$('input[name=P_ETC_SHIP_COUNTRYCODE]').val($('#frgAddrCountry').val());
           /*  $('input[name=P_ETC_SHIP_NAME]').val($('#adrsNm').val());
            $('input[name=P_ETC_SHIP_ZIP]').val($('#frgAddrZipCode').val());
            $('input[name=P_ETC_SHIP_STATE]').val($('#frgAddrState').val());
            $('input[name=P_ETC_SHIP_CITY]').val($('#frgAddrCity').val());
            $('input[name=P_ETC_SHIP_STREET]').val($('#frgAddrDtl1').val());
            $('input[name=P_ETC_SHIP_STREET2]').val($('#frgAddrDtl2').val()); */
            
            //상품명, 상품가격, 구매자정보, 배송지정보 값이 매핑되어야한다.
        }
        , responseParamMapping:function(map) { //페이팔 응답파라미터 세팅
            $('#confirmResultCd').val(map.P_STATUS); //응답코드(성공:00, 실패:01)
            $('#confirmResultMsg').val(map.P_RMESG1); //결과메세지(Format: CODE | MSG)
            $('#txNo').val(map.P_TID); //거래번호
            $('#ordNo').val('${ordNo}'); //상점 거래 주문ID, ordNo
            $('#P_TID').val(map.P_TID); //거래번호
            $('#P_REQ_URL').val(map.P_REQ_URL); //거래번호
            
            //$('#confirmDttm').val(map.authdate + map.authtime); //페이팔 승인 처리 날짜(yyyyMMdd hhmmss), confirmDttm
            /* map.goodname; //상품명
            map.price; //상품금액(단위 : cent)
            map.pricewon; //원화금액(원화 결제요청인 경우)
            map.currency; //상점에서 요청시 설정한 통화단위
            map.paymethod; //페이팔 결제타입
            map.authdate; //페이팔 승인 처리 날짜(yyyyMMdd), confirmDttm
            map.authtime; //페이팔 승인 처리 시간(hhmmss), confirmDttm
            map.notetext; //배송특이사항, memoContent
            map.shiptoname; //받는사람
            map.shiptostreet;//주소1
            map.shiptostreet2; //주소2
            map.shiptocity; //도시
            map.shiptostate; //주
            map.shiptozip; //도시코드
            map.shiptocountrycode; //나라코드
            map.shiptophonenum; //휴대폰번호
            map.shiptocountryname; //나라이름 */
        }
       /*  , vo:function(orderNo, timestamp) {
            return {
                'timestamp':timestamp
                , 'mid':PayPalUtil.mid
                , 'reqtype':'authreq'
                , 'webordernumber':orderNo
                , 'currency':'WON'
                , 'price':1500
                , 'merchantKey':PayPalUtil.merchantKey
            };
        } */
    }
</script>

<!-- <form id="paypal_info" method="post"> --> <!-- 실결제 -->
    
    
    <%-- <input type="hidden" name="P_MID"                   value="${foreignPaymentConfig.data.frgPaymentStoreId}"> --%>
    <!-- <input type="hidden" name="timestamp"           value=""> -->                 
    <%-- <input type="hidden" name="P_OID"                   value="${ordNo}"> --%>
    <!-- <input type="hidden" name="reqtype"             value="authreq"> -->
    <!-- <input type="hidden" name="P_NOTI"                  value=""> -->
    <!-- <input type="hidden" name="P_NEXT_URL"              value=""> -->
    <input type="hidden" name="P_CANCEL_URL"            value="${siteDomain}/paypal-result">
    <!-- <input type="hidden" name="hashdata"            value=""> -->                 
    <!-- <input type="hidden" name="logourl"             value=""> -->                 
    <!-- <input type="hidden" name="P_GOODS"                 value=""> -->         
    <!-- 원: WON, 달러: USD -->
    <input type="hidden" name="P_CURRENCY"              value="WON">              
    <input type="hidden" name="P_RESERVED"              value="etc_paymethod=PPAY">
    
    <!-- <input type="hidden" name="P_AMT"                    value=""> -->             
    <!-- <input type="hidden" name="P_UNAME"                  value=""> -->     
    <!-- <input type="hidden" name="buyertel"            value="010-8818-9251"> -->    
    <!-- <input type="hidden" name="P_EMAIL"                  value=""> -->
        
    <!-- <input type="hidden" name="P_ETC_SHIP_NAME"          value="">     
    <input type="hidden" name="P_ETC_SHIP_STREET"        value="">      
    <input type="hidden" name="P_ETC_SHIP_STREET2"       value="">          
    <input type="hidden" name="P_ETC_SHIP_CITY"          value="">         
    <input type="hidden" name="P_ETC_SHIP_STATE"         value="">                -->
    
    <!-- 한국: kr, 미국: us -->
    <!-- <input type="hidden" name="P_ETC_SHIP_COUNTRYCODE"   value="KR">               
    <input type="hidden" name="P_ETC_SHIP_ZIP"           value="">             -->
    
    <!-- <input type="hidden" name="P_CHARSET" value="utf8"> --> <!-- 캐릭터셋 설정 -->
<!-- </form> -->
