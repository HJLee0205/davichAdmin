<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<%@ include file="common_include.jsp" %>
 
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">

<meta name="keyword" content="컨텐츠">

<title>간편결제(pay2) 테스트페이지</title>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<!--
<script src="/share/js/requirejs/require.js"></script>
<script src="/share/js/requirejs/require.config.js"></script>
-->
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script type="text/javascript">

function order_chk(){
    if($(".payco input:radio[name=sort]:checked").val() == null){
        alert("결제방식을 선택하세요.");      
        return;
    }else{
        if($(".payco input:radio[name=sort]:checked").val() == "payco"){
            callPaycoUrl();
            return;
        }else{
            alert($(".payco input:radio[name=sort]:checked").val());
            return;
        }   
    }
}

function callPaycoUrl(){
    
    var Params = "customerOrderNumber=<%=customerOrderNumber%>";    //가맹점고객주문번호 입력

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류 
    $.support.cors = true;

    /* + "&" + $('order_product_delivery_info').serialize() ); */
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/payco-reserve",
        data: Params,       // JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"json",
        success:function(data){
            if(data.code == '0') {
                $('#order_num').val(data.result.reserveOrderNo);
                $('#order_url').val(data.result.orderSheetUrl);
                order();
            }
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });
}


function order(){
    
    var order_Url = $('#order_url').val();
    
    if(<%=isMobile%>){
        location.href = order_Url;
    }else{
        window.open(order_Url, 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes'); 
    }
}

function order_state_modify(){
    // 선택박스 필수 옵션을 체크 함
    if( $('#orderNo_modify').val() == "" ) {
        alert('주문번호를 입력해주세요.');
        return false;
    }

    if( $('#sellerOrderProductReferenceKey_modify').val() == "" ) {
        alert('주문상품연동키를 입력해주세요.');
        return false;
    }

    if( $('#orderProductStatus option:selected').val() == "" ) {
        alert('상태값을 선택해주세요.');
        return false;
    }

    // 선택박스 필수 옵션을 체크 함
    var Params = "orderNo=" 
               + $('#orderNo_modify').val()
               + "&sellerOrderProductReferenceKey="
               + $('#sellerOrderProductReferenceKey_modify').val()
               + "&orderProductStatus="
               + $('#orderProductStatus option:selected').val();

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;

    /* + "&" + $('order_product_delivery_info').serialize() ); */
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/paycoUpstatus.jsp",
        data: Params,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"json",
        success:function(data){
            if(data.code == '0') {
                alert("변경되었습니다.");
            } else {
                alert("code:"+data.code+"\n"+"message:"+data.message);
            }
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });
}

function cancel_order_all_test(){
    // 선택박스 필수 옵션을 체크 함
    if( $('#orderNo_all').val() == "" )         { alert( '주문 번호를 입력해주세요.        ' );    return false; }
    if( $('#orderCertifyKey_all').val() == "" ) { alert( '주문 인증 Key를 입력해주세요.    ' );    return false; }
    if( $('#cancelTotalAmt_all').val() == "" )  { alert( '취소할 총 금액을 입력해주세요.' );     return false; }

    // 선택박스 필수 옵션을 체크 함
    var Params = "cancelType=ALL" 
               + "&orderNo="
               + $('#orderNo_all').val()
               + "&orderCertifyKey="
               + encodeURIComponent($('#orderCertifyKey_all').val())
               + "&cancelTotalAmt="
               + $('#cancelTotalAmt_all').val()
               + "&totalCancelTaxfreeAmt="
               + $('#totalCancelTaxfreeAmt_all').val()
               + "&totalCancelTaxableAmt="
               + $('#totalCancelTaxableAmt_all').val()
               + "&totalCancelVatAmt="
               + $('#totalCancelVatAmt_all').val()
               + "&totalCancelPossibleAmt="
               + $('#totalCancelPossibleAmt_all').val()
               + "&requestMemo="
               + $('#requestMemo_all').val();     

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;
    
    /* + "&" + $('order_product_delivery_info').serialize() ); */
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/sample-payco-cancel",
        data: Params,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"json",
        success:function(data){
            if(data.code == '0') {
                    alert("주문이 정상적으로 취소되었습니다.\n( 주문취소번호 : "+data.result.cancelTradeSeq+" )");
            } else {
                alert("code:"+data.code+"\n"+"message:"+data.message);
            }
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });
}

function cancel_order_part_test(){
    // 선택박스 필수 옵션을 체크 함
    if( $('#orderNo_part').val() == "" )                        {   alert( '주문번호를 입력해주세요.' );               return false;   }
    if( $('#orderCertifyKey_part').val() == "" )                {   alert( '주문 인증 Key를 입력해주세요.' );          return false;   }
    if( $('#sellerOrderProductReferenceKey_part').val() == "" ) {   alert( '취소할 주문 상품 번호를 입력해주세요.' );   return false;   }
    if( $('#cancelTotalAmt_part').val() == "" )                 {   alert( '취소할 총 금액을 입력해주세요.' );           return false;   }
    if( $('#cancelAmt_part').val() == "" )                      {   alert( '취소상품 금액을 입력해주세요.' );            return false;   }
// 
    // 선택박스 필수 옵션을 체크 함
    var Params = "cancelType=PART" 
               + "&orderNo="
               + $('#orderNo_part').val()
               + "&orderCertifyKey="
               + encodeURIComponent($('#orderCertifyKey_part').val())
               + "&cancelTotalAmt="
               + $('#cancelTotalAmt_part').val()
               + "&totalCancelTaxfreeAmt="
               + $('#totalCancelTaxfreeAmt_part').val()
               + "&totalCancelTaxableAmt="
               + $('#totalCancelTaxableAmt_part').val()
               + "&totalCancelVatAmt="
               + $('#totalCancelVatAmt_part').val()
               + "&totalCancelPossibleAmt="
               + $('#totalCancelPossibleAmt_part').val()
               + "&sellerOrderProductReferenceKey="
               + $('#sellerOrderProductReferenceKey_part').val()
               + "&cancelDetailContent="
               + $('#cancelDetailContent_part').val()
               + "&cancelAmt="
               + $('#cancelAmt_part').val()
               + "&requestMemo="
               + $('#requestMemo_part').val();

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;

    /* + "&" + $('order_product_delivery_info').serialize() ); */
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/sample-payco-cancel",
        data: Params,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"json",
        success:function(data){
            if(data.code == '0') {      
                    alert("주문이 정상적으로 취소되었습니다.\n( 주문취소번호 : "+data.result.cancelTradeSeq+" / 취소상품금액 : "+data.result.totalCancelPaymentAmt+" )");
            } else {
                alert("code:"+data.code+"\n"+"message:"+data.message);
            }
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });
}

function mileage_cancel_test(){
    // 선택박스 필수 옵션을 체크 함
    if( $('#orderNo_mile').val() == "" ) {
        alert('주문번호를 입력해주세요.');
        return false;
    }

    if( $('#cancelPaymentAmount_mile').val() == "" ) {
        alert('취소할 주문서의 총 취소 금액을 입력해주세요.\n(마일리지 적립율을 곱한 금액이 취소됩니다.)');
        return false;
    }

    // 선택박스 필수 옵션을 체크 함
    var Params = "orderNo="
               + $('#orderNo_mile').val()
               + "&cancelPaymentAmount="
               + $('#cancelPaymentAmount_mile').val();


    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;

    /* + "&" + $('order_product_delivery_info').serialize() ); */
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/payco_mileage_cancel.jsp",
        data: Params,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"json",
        success:function(data){
            if(data.code == '0') {
                    alert("주문이 정상적으로 취소되었습니다.\n( 취소 마일리지 : "+data.result.canceledMileageAcmAmount +", 잔여 마일리지 : "+data.result.remainingMileageAcmAmount+" )");
            } else {
                alert("code:"+data.code+"\n"+"message:"+data.message);
            }
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });
}

function receipt_go(){
    if($(".payco input:radio[name=receipt]:checked").val() == null){
        alert("출력할 영수증을 선택하세요.");       
        return;
    }
    var orderurl = "https://alpha-bill.payco.com/outseller/receipt/"+$('#orderNo_receipt').val()+"?receiptKind="+$(".payco input:radio[name=receipt]:checked").val();
    window.open(orderurl, 'receipt_pop','scrollbars=yes');
}   


function verifyPayment() {
    // 선택박스 필수 옵션을 체크 함
    if( $('#verifyPayment_reserveOrderNo').val() == "" )            {   alert( 'PAYCO 주문예약번호를 입력해주세요.' );                   return false;   }
    if( $('#verifyPayment_sellerOrderReferenceKey').val() == "" )   {   alert( '외부가맹점에서 발급하는 주문연동키를 입력해주세요.' ); return false;   }

    // 전송 파라미터
    var Params = "reserveOrderNo="
                + $('#verifyPayment_reserveOrderNo').val()
                + "&sellerOrderReferenceKey="
                + $('#verifyPayment_sellerOrderReferenceKey').val();

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;
    
    $.ajax({
        type: "POST",
        url: "<%=domainName%>/payco_verifyPayment.jsp",
        data: Params,
        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        dataType:"html",
        success:function(html){
            var win = window.open("", 'popupVarifyPayment', 'top=100, left=250, width=1100px, height=800px, resizble=no, scrollbars=yes, align=center');
            win.document.write(html);
        },
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            return false;
        }
    });

}

</script>

<style type="text/css">
    #sort {
        width:13px; 
        height:13px; 
        margin:0 0 2px; 
        padding:0; 
        border: 1px solid #FFF; 
        vertical-align:middle;
    }
</style>

</head>
<body>

<div id="header">
    <div class="gnb" id="gognb">
        <div class="wrap">
            <ul class="gognb" >
                <li><h3>간편결제(EASYPAY - PAY2)</h3></li>
            </ul>
        </div>
    </div>
</div>
    <div id="container" class="clearfix">
    <div class="main_fix_wrap easyPay_wrap">

    <table cellspacing="0" cellpadding="0" class="tbl_std">
        <colgroup>
            <col width="9%">
            <col width="46%">
            <col width="10%">
            <col width="10%">
            <col width="10%">
            <col width="15%">
        </colgroup>
        <thead>
            <tr>
                <th colspan="2" class="fst left">상품정보</th>
                <th>수량</th>
                <th>상품금액</th>
                <th>마켓포인트</th>
                <th>주문금액</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="fst">
                    <img src="http://image.popshoes.co.kr/images/goods_img/20160119/138095/138095_a_500.jpg?20160202160638" alt="" width="80" height="80">
                </td>
                <td class="left">
                    <p>[GLOBE] TILT KIDS (NAVY/ORANGE)</p>
                    <p>옵션 : 280</p>
                </td>
                <td>1</td>
                <td>
                    <p>79,000 원</p>
                </td>
                <td class="bg_sum">0원</td>
                <td class="bg_sum txt_sum text_bold">79,000 원</td>
            </tr>
            <tr>
                <td class="fst left" colspan="4">
                </td>
                <td colspan="2" class="bg_total left">
                    <ul class="total_wrap">
                        <li><p>총상품금액</p>
                            <strong>79,000원</strong></li>
                        <li><p>총마켓포인트</p>
                            <strong>0원</strong></li>
                        <li><p>배송비</p>
                            <strong>2,500원</strong></li>
                        <li><p>결제금액</p>
                            <strong class="point">81,500원</strong></li>
                    </ul>
                </td>
            </tr>
        </tbody>
    </table>



<div style="height:30px;"></div>
    <table cellspacing="0" cellpadding="0" class="save_point_wrap">
        <colgroup>
            <col width="78%">
            <col width="22%">
        </colgroup>
        <tbody>
            <tr>
                <td>
                    <!-- s:안내 -->
                    <table cellspacing="0" cellpadding="0" class="save_point">
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="underline">결제방식</th>
                                <td class="left underline">
                                    <div class="payco" style="text-align: left;">
                                    <span><input type="radio"  value="신용카드 결제" name="sort" id="sort"><label for="pay01">신용카드 결제</label></span>
                                    <span style= "margin-left: 3px;"><input type="radio"  value="가상 계좌" name="sort" id="sort"><label for="pay02">가상 계좌</label></span>   
                                    <span style= "margin-left: 3px;"><input type="radio"  value="휴대폰 결제" name="sort" id="sort"><label for="pay03">휴대폰 결제</label></span> 
                                    <span style= "margin-left: 3px;"><input type="radio"  value="payco" name="sort" id="sort"></span><span id="payco_btn_type_A1" style="padding-left: 3px;"></span>    
                                </div>
                                </td>
                            </tr>

                            <!-- PAYCO 안내 -->
                            <tr id="div_toastpay" class="pay_detail"
                                style="height: 148px">
                                <th>PAYCO</th>
                                <td class="left">
                                    <ul>
                                        <li>PAYCO는 NHN 엔터테인먼트가 만든 간편결제입니다.</li>
                                        <li>결제수단 : 신용카드(BC, 삼성, 롯데, 현대, 외환), 휴대폰(SKT, KT, LG U+,
                                            헬로모바일, tplus)</li>
                                        <li>적립혜택 : <font color="red">
                                                PAYCO 포인트(2%) 모두 적립!</font></li>
                                        <li>오픈기념 이벤트! 첫 구매 지원금 <font color="red"> 2,000P
                                                바로 지급!</font>&nbsp; <a href="javascript:paycoEventPopUpOpen()"><font
                                                color="#999999">이벤트안내&gt;</font></a></li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>
        
    <div class="easyPay_div"><button type="button" class="btn easyPay_btn"  onclick="order_chk();" >주문예약실행</button> </div>
    <div class="easyPay_div">
        <li style="margin:20px 0;"><em>예약주문번호 </em>
            <input type="text" class="form-control input_text" name="order_num" id="order_num" value=""  ></li>
            <li><em>주문창URL </em>
            <input type="text" class="form-control input_text" name="order_url" id="order_url" value=""  ></li>
        </li>
    </div>
    <div class="easyPay_div"><button type="button" class="btn easyPay_btn"  onclick="order();" >결제하기</button> </div>

        <div class="detail_area">
            <div class="payco">
                <span class="glyphicon glyphicon-menu-down" aria-hidden="true">주문 상태 변경 테스트</span>
                <ul style="border-bottom:none;">
                    <li style="margin:20px 0;">
                        <em>주문번호</em>
                        <input type="text" class="form-control input_text" name="orderNo_modify" id="orderNo_modify" value="">
                        <em>변경할 주문 상품 연동키</em>
                        <input type="text" class="form-control input_text" name="sellerOrderProductReferenceKey_modify" id="sellerOrderProductReferenceKey_modify" value="">
                        <em>상태값 </em>
                        <div class="input-group">
                            <select id="orderProductStatus" name="orderProductStatus" class="fs12 gray_03" style="width: 220px">
                                    <option value="">선택하세요</option>
                                    <option value="PAYMENT_WAITNG">입금대기</option>
                                    <option value="PAYED">결제완료 (빌링 결제완료)</option>
                                    <option value="DELIVERY_READY">배송 준비 중 [deprecated]</option>
                                    <option value="DELIVERING">배송 중 [deprecated]</option>
                                    <option value="DELIVERY_COMPLETE">배송 완료 [deprecated]</option>
                                    <option value="DELIVERY_START">배송 시작(출고지시)</option>
                                    <option value="PURCHASE_DECISION">구매확정</option>
                                    <option value="CANCELED">취소</option>
                            </select>
                            <span class="input-group-btn">
                             <button id="order_modify_btn"  class="btn btn-default" type="button" onclick="order_state_modify();">GO</button>
                            </span>
                        </div>
                    </li>
                </ul>
                <span class="glyphicon glyphicon-menu-down" aria-hidden="true">주문 취소 테스트 (전체)</span>
                <ul style="border-bottom:none;">
                    <li style="margin:20px 0;">
                        <em>주문번호</em>
                        <input type="text" class="form-control input_text" name="orderNo_all" id="orderNo_all" value="">
                        <em>PAYCO에서 발급하는 주문인증 Key</em>
                        <input type="text" class="form-control input_text" name="orderCertifyKey_all" id="orderCertifyKey_all" value="">
                        <em>총 취소할 면세금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelTaxfreeAmt_all" id="totalCancelTaxfreeAmt_all" value="">
                        <em>총 취소할 과세금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelTaxableAmt_all" id="totalCancelTaxableAmt_all" value="">
                        <em>총 취소할 부가세 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelVatAmt_all" id="totalCancelVatAmt_all" value="">
                        <em>총 취소가능금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelPossibleAmt_all" id="totalCancelPossibleAmt_all" value="">
                        <em>취소처리 요청메모 [선택]</em>
                        <input type="text" class="form-control input_text" name="requestMemo_all" id="requestMemo_all" value="">
                        <em>총 취소 금액</em>
                        <div class="input-group">
                            <input type="text" class="form-control input_text" name="cancelTotalAmt_all" id="cancelTotalAmt_all" value="">
                            <span class="input-group-btn">
                                <button id="order_cancel_all__btn" class="btn btn-default" type="button" onclick="cancel_order_all_test();">GO</button>
                            </span>
                        </div>
                    </li>
                </ul>
                <span class="glyphicon glyphicon-menu-down" aria-hidden="true">주문 취소 테스트 (부분 - 상품 1개만)</span>
                <ul style="border-bottom:none;">
                    <li style="margin:20px 0;">
                        <em>주문번호</em>
                        <input type="text" class="form-control input_text" name="orderNo_part" id="orderNo_part" value="">
                        <em>PAYCO에서 발급하는 주문인증 Key</em>
                        <input type="text" class="form-control input_text" name="orderCertifyKey_part" id="orderCertifyKey_part" value="">
                        <em>취소할 주문 상품 연동키</em>
                        <input type="text" class="form-control input_text" name="sellerOrderProductReferenceKey_part" id="sellerOrderProductReferenceKey_part" value="">
                        <em>취소할 총 금액</em>
                        <input type="text" class="form-control input_text" name="cancelTotalAmt_part" id="cancelTotalAmt_part" value="">
                        <em>총 취소할 면세금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelTaxfreeAmt_part" id="totalCancelTaxfreeAmt_part" value="">
                        <em>총 취소할 과세금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelTaxableAmt_part" id="totalCancelTaxableAmt_part" value="">
                        <em>총 취소할 부가세 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelVatAmt_part" id="totalCancelVatAmt_part" value="">
                        <em>총 취소가능 금액 [선택]</em>
                        <input type="text" class="form-control input_text" name="totalCancelPossibleAmt_part" id="totalCancelPossibleAmt_part" value="">
                        <em>취소 사유 [선택]</em>
                        <input type="text" class="form-control input_text" name="cancelDetailContent_part" id="cancelDetailContent_part" value="">
                        <em>취소처리 요청메모 [선택]</em>
                        <input type="text" class="form-control input_text" name="requestMemo_part" id="requestMemo_part" value="">
                        <em>취소 할 주문상품 금액</em>
                        <div class="input-group">
                            <input type="text" class="form-control input_text" name="cancelAmt_part" id="cancelAmt_part" value="">
                            <span class="input-group-btn">
                                <button id="order_cancel_btn" class="btn btn-default" type="button" onclick="cancel_order_part_test();">GO</button>
                            </span>
                        </div>
                    </li>
                </ul>
                <span class="glyphicon glyphicon-menu-down" aria-hidden="true">마일리지 적립 취소 테스트</span>
                <ul style="border-bottom:none;">
                    <li style="margin:20px 0;">
                        <em>주문번호</em>
                        <input type="text" class="form-control input_text" name="orderNo_mile" id="orderNo_mile" value="">
                        <em>취소 총 금액</em>
                        <div class="input-group">
                            <input type="text" class="form-control input_text" name="cancelPaymentAmount_mile" id="cancelPaymentAmount_mile" value="">
                            <span class="input-group-btn">
                                <button id="order_cancel_btn" class="btn btn-default" type="button" onclick="mileage_cancel_test();">GO</button>
                            </span>
                        </div>
                    </li>
                </ul>
                <span class="glyphicon glyphicon-menu-down" aria-hidden="true">영수증 확인</span>
                <ul style="border-bottom:none;">
                    <li style="margin:20px 0;">
                        <em>주문번호</em>
                        <input type="text" class="form-control input_text" name="orderNo_receipt" id="orderNo_receipt" value="">
                        <em>결제수단</em>
                        <div class="input-group">
                            <span style= "margin-right: 3px;"><input type="radio"  value="cash" name="receipt"> <label for="pay01">현금영수증</label></span>
                            <span style= "margin-right: 3px;"><input type="radio"  value="online" name="receipt"><label for="pay02">온라인영수증</label></span>   
                            <span style= "margin-right: 3px;"><input type="radio"  value="card" name="receipt" checked><label for="pay03">신용카드매출전표</label></span>   
                            <span class="input-group-btn">
                                <button id="order_mile_cancel_btn" class="btn btn-default" type="button" onclick="receipt_go();">GO</button>
                            </span>
                        </div>
                    </li>
                </ul> 
            </div>
        </div>
    </div>
    <button type="button" class="btn btn-default btn-lg" id="more_btn" style="margin-bottom :20px; display:none;">
      <span class="glyphicon glyphicon-menu-down" aria-hidden="true"></span> 주문 예약 API 정보
    </button>
</div>
<script type="text/javascript">
      Payco.Button.register({
        SELLER_KEY:'1111',
        ORDER_METHOD:"EASYPAY",
        /* ORDER_METHOD:"CHECKOUT", */
        BUTTON_TYPE:"A1",
        BUTTON_HANDLER:order,
        DISPLAY_PROMOTION:"Y",
        DISPLAY_ELEMENT_ID:"payco_btn_type_A1",
        "":""
      });
      
      
</script>
</body>
</html>
