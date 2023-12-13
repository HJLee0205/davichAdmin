<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>

/**
 결제취소
**/
var ordPayCancelPopup = {
        init : function() {
           jQuery('#btn_payCancel_close').on('click', function(e) {
               Dmall.LayerPopupUtil.close();
           });
        },
        
        // 결제취소 버튼 클릭 시 실행
        btnPayCancelClick : function (ordNo, type, curOrdStatusCd) {
            // 환불, 결제취소
            $("#label_exchangeOrdNo").text(ordNo);
            $("#tbody_exchange_data").find(".searchExchangeResult").each(function() {
                $(this).remove();
            });    
            jQuery("#tr_exchange_data_template").hide();
            jQuery('#tr_no_exchange_data').show();
            $('#claimDtlReason').val("");
            $('#claimMemo').val("");
            $("#estimateAmt").html(0);
            $("#modifyAmt").html(0);
            $("#refundAmt").html(0);
            $("#pgAmt").val(0);
            $("#tempPgAmt").html(0);
            $("#payReserveAmt").val(0);
            $("#tempReserveAmt").html(0);
            $("#pgtype1").html("");
            $("#pgType option:eq(0)").replaceWith("<option value='01'>무통장 환불</option>");
            $("#pgType option:eq(1)").replaceWith("<option value='02'>PG 환불</option>");
            
            var url;
            
            Dmall.LayerPopupUtil.open(jQuery('#layout_payCancel'));
            url =  "/admin/order/exchange/order-detail-exchange";
            $('#exchangeOrdStatusCd').val(curOrdStatusCd);
            
            var param = {ordNo:ordNo,claimType:'C'};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var dfd = jQuery.Deferred();
                var template1_1 =
                                '<input type="text" name="exchange_OrdStatusCd" id="exchange_OrdStatusCd" value="{{ordDtlSeq}}" />' +
                                '<tr>' +
                                '<td class="txtl">' +
                                '<div class="item_box">' ;
                var template1_2 =
                                '<tr>' +
                                '<td>' +
                                '<label for="exchange_ordNo" class="chack mr10">' +
                                '<span class="ico_comm"><input type="checkbox" name="exchange_ordNo" id="exchange_ordNo" class="blind" value="{{ordNo}}:{{ordDtlSeq}}:{{ordDtlStatusCd}}" /></span>' +
                                '</label>' +
                                '</td>' +
                                '<td class="txtl">' +
                                '<div class="item_box">' ;
                var template1_2_1 =
                    '<tr>' +
                    '<td>' +
                    '</td>' +
                    '<td class="txtl">' +
                    '<div class="item_box">' ;
                var template2_2 =
                                '<tr>' +
                                '<td>' +
                                '&nbsp;' +
                                '</td>' +
                                '<td class="txtl">' +
                                '<div class="item_box">' ;
                var template1_3 =
                                '<tr>' +
                                '<td>' +
                                '</td>' +
                                '<td class="txtl">' +
                                '<div class="item_box">' ;
                var template1_add =
                                '<span class="addition" >' +
                                '<img src="/admin/img/order/icon_addition.png" alt="추가상품" />' +
                                '</span>';
                var template1_goods =
                            '<a href="javascript:;" class="goods_img"><img src="{{imgPath}}" alt="" /></a>' +
                            '<a href="javascript:;" class="goods_txt">' +
                            '<span class="tlt">{{goodsNm}}</span>' ;
                var template2 =
                    '<span class="option">' +
                    /*'<span class="ico01">옵션</span> ' +*/
                    '{{itemNm}}' +
                    '</span>' ;
                    var template3 =
                    '<span class="code">[상품코드 : {{goodsNo}}]</span>' ;
                    var template4 =
                        '<span class="option">' +
                        '<span class="ico01">추가옵션</span>{{addOptNm}}' +
                        '</span>' ;
                        var template5 =
                        '</a>' +
                        '</div>' +
                        '</td>'+
                        '<td>{{ordQtt}}</td>' +
                        '<td class="txtc">' ;
                        var template5_1=
                        '</td>' +
                        '<td class="txtc">{{saleAmt}}</td>' +
                        '<td class="txtc">{{dcAmt}}</td>';
                        var template7 =
                        '<td class="txtc">{{payAmt}}</td>' ;
                        var templateEndTr =  '</tr>' ;
                        managerTemplate1_1 = new Dmall.Template(template1_1),
                        managerTemplate1_2 = new Dmall.Template(template1_2),
                        managerTemplate1_2_1 = new Dmall.Template(template1_2_1),
                        managerTemplate2_2 = new Dmall.Template(template2_2),
                        managerTemplate1_3 = new Dmall.Template(template1_3),
                        managerTemplate1_add = new Dmall.Template(template1_add),
                        managerTemplate1_goods = new Dmall.Template(template1_goods),
                        managerTemplate2 = new Dmall.Template(template2),
                        managerTemplate3 = new Dmall.Template(template3),
                        //                managerTemplate4 = new Dmall.Template(template4),
                        managerTemplate5 = new Dmall.TemplateNoFormat(template5),
                        managerTemplate5_1 = new Dmall.TemplateNoFormat(template5_1),
                        //managerTemplate7 = new Dmall.TemplateNoFormat(template7),
                        //                managerTemplate7 = new Dmall.Template(template7),

                        tr =  '';
                        var orgCnt = 0;
                jQuery.each(result.data.orderGoodsVO, function(idx, obj) {
                    if(obj.addOptYn=='N') {
                        if(obj.ordDtlStatusCd == '23') {
                            tr += managerTemplate1_2.render(obj);
                        } else {
                            tr += managerTemplate1_2_1.render(obj);
                        }
                    } else {
                        tr += managerTemplate1_3.render(obj);
                    }
                    if(obj.addOptYn=='Y')
                        tr += managerTemplate1_add.render(obj);
                    tr += managerTemplate1_goods.render(obj);
                    if(obj.addOptYn=='N' && obj.itemNm !='')
                        tr += managerTemplate2.render(obj);
                    if(obj.addOptYn=='N'){
                        orgCnt++;
                        tr += managerTemplate3.render(obj);                        
                    }
                    tr += managerTemplate5.render(obj);
                    tr+=obj.claimQtt;
                    tr+='<input type="hidden" name="claimQtt" value="'+obj.claimQtt+'">';
                    tr += managerTemplate5_1.render(obj);
                    var template6 = '';
                    if(obj.addOptYn == 'N' && obj.dlvrcCnt != '0') {
                        template6 =
                            '<td  class="txtc" rowspan="{{dlvrcCnt}}">';
                        if(obj.areaAddDlvrc != '0')
                            template6 += '선불<br>';
                        else 
                            template6 += '{{dlvrcPaymentNm}}<br>';
                        if((obj.dlvrAmt + obj.areaAddDlvrc) > 0)
                            template6 += commaNumber(Number(obj.dlvrAmt) + Number(obj.areaAddDlvrc)) + '원';
                        template6 += '</td>'; 
                        managerTemplate6 = new Dmall.Template(template6);
                        tr += managerTemplate6.render(obj);
                    }
                    var dlvrAmt = 0;
                    if(obj.dlvrAmt == null || obj.dlvrAmt == '' || obj.dlvrAmt == '0') {
                        if(obj.realDlvrAmt == null || obj.realDlvrAmt == '' || obj.realDlvrAmt == '0') {
                            dlvrAmt = 0;
                        } else {
                            dlvrAmt = obj.realDlvrAmt;
                        }
                    } else {
                        dlvrAmt = obj.dlvrAmt;
                    }
                    var template7 = '';
                    template7 = '<td>';
                    template7 += commaNumber(Number(obj.paymentAmt) + Number(dlvrAmt) + Number(obj.areaAddDlvrc) - Number(obj.goodsDmoneyUseAmt));
                    template7 += '</td>';
                    managerTemplate7 = new Dmall.Template(template7);
                    tr += managerTemplate7.render(obj);
                    var template8 = '';
                    if(obj.addOptYn == 'N' && obj.refundAmt > 0) {
                        template8 =
                            '<td  class="txtc" rowspan="{{turnCnt}}">';
                        if(obj.refundAmt > 0)  
                            template8 += obj.refundAmt;
                        template8 += '</td>'; 
                        managerTemplate8 = new Dmall.Template(template8);
                        tr += managerTemplate8.render(obj);
                    }                    
                    
                    if(obj.addOptYn == 'N') {
                        tr += new Dmall.Template('<td class="txtc" rowspan="{{cnt}}">{{ordDtlStatusNm}}</td>').render(obj);
                    }
                    tr += templateEndTr;
                });
                // 전체 갯수확인 
                $('#orgCnt').val(orgCnt);

                jQuery('#ajaxPayCancelGoodsList').html(tr);
                dfd.resolve(result.data.orderGoodsVO);
                /**
                 * 처리 로그 출력
                 */
                var templateLog1 = '<li >{{regDttm}} [주문 상세번호:{{ordDtlSeq}}] [{{ordStatusCd}}] {{ordStatusNm}}</li>';
                tr =  '';
                managerLogTemplate = new Dmall.Template(templateLog1),
                jQuery.each(result.data.ordHistVOList, function(idx, obj) {
                    tr += managerLogTemplate.render(obj);
                });

                jQuery('#ajaxPayCancelLogList').html(tr);
                
                $('input:checkbox[name="exchange_ordNo"]').each(function() {
                    $(this).parents('label').addClass('on');
                    this.checked = true; //checked 처리
                    this.disabled = true;
                    if(this.checked){//checked 처리된 항목의 값
                          //alert(this.value);
                    }
                });  
                payCancelGo();
            });
            
            
        }    
};


function payCancelGo(){

    // 상세화면
    $("#tbody_exchange_data").find(".searchExchangeResult").each(function() {
        $(this).remove();
    });
    
    jQuery("#tr_exchange_data_template").hide();
    jQuery('#tr_no_exchange_data').show();
    var comma = ',';
    var ordNoArr = '', ordDtlSeqArr = ''
        , claimQttArr='';
    var estimateAmtArr = 0;
    var ordNo = '';

    ordNo = $("#label_exchangeOrdNo").text();
    $('input[name=exchange_ordNo]:checked').map(function() {
        if($(this).val()!='') {
            var strArr = $(this).val().split(':');
            /*if(strArr[2]=='23'){*/
                ordNoArr += strArr[0];
                ordNoArr += comma;
                ordDtlSeqArr += strArr[1];
                ordDtlSeqArr += comma;
                var _el = $(this).parents('tr').find('[name=claimQtt]');
                if(_el.is('select')){
                    claimQttArr+=_el.find('option:selected').val();
                    claimQttArr += comma;
                }else{
                    claimQttArr+=_el.val();
                    claimQttArr += comma;
                }
            /*}*/
        }
    });
    
    var url = '/admin/order/refund/paycancel-info-layer',
    dfd = jQuery.Deferred();
    var param = {ordNoArr : ordNoArr, ordDtlSeqArr : ordDtlSeqArr, claimQttArr:claimQttArr,ordNo : ordNo,refundType:"V",cancelSearchType:"02"};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if (result == null || result.success != true) {
            alert("데이터가 존재하지 않습니다.");
            return;
        }
        
        // 취득결과 셋팅
        var chkCnt = 0;
        var goodsDmoneyUseAmt = 0;
        jQuery.each(result.data.claimGoodsVO, function(idx, obj) {
            var trId = obj.ordNo + ":" + obj.ordDtlSeq;
            var $tmpSearchResultTr = "";
            
            var $tmpSearchResultTr = $("#tr_exchange_data_template").clone().show().removeAttr("id");
            $($tmpSearchResultTr).attr("id", trId).addClass("searchExchangeResult");

            $('[data-bind="exchangeInfo"]', $tmpSearchResultTr).DataBinder(obj);

            $("#tbody_exchange_data").append($tmpSearchResultTr);
            
            if(obj.claimReasonCd!=''){
                //$("#refundReasonCd").val(obj.claimReasonCd);
                $("#claimReasonCd").val(obj.claimReasonCd).prop("selected", true);
                $("#claimReasonCd2").text($("#claimReasonCd option:selected").text());
            }
            goodsDmoneyUseAmt += obj.goodsDmoneyUseAmt;
            chkCnt++
            console.log("goodsDmoneyUseAmt = ", goodsDmoneyUseAmt);
        });

        // 결제취소정보
        var objP = result.data.claimPayRefundVO;
        if(objP!=null) {
            $("#claimMemo").val(objP.claimMemo);
            $("#claimDtlReason").val(objP.claimDtlReason);
            $("#payPgCd").val(objP.payPgCd);
            $("#payPgWayCd").val(objP.payPgWayCd);
            $("#payPgAmt").val(objP.payPgAmt);
            $("#payUnpgCd").val(objP.payUnpgCd);
            $("#payUnpgWayCd").val(objP.payUnpgWayCd);
            $("#payUnpgAmt").val(objP.payUnpgAmt);
            $("#payReserveCd").val(objP.payReserveCd);
            $("#payReserveWayCd").val(objP.payReserveWayCd);
            $("#tempReserveAmt").text(objP.payReserveAmt);
            $("#orgReserveAmt").val(objP.payReserveAmt);
            $("#bankCd").val(objP.bankCd).prop("selected", true);
            $("#bankCd2").text($("#bankCd option:selected").text());
            $("#actNo").val(objP.actNo);
            $("#holderNm").val(objP.holderNm);
            $("#totalDlvrAmt").val(objP.totalDlvrAmt);


            var dlvrAmt = 0;
            if(objP.dlvrAmt == null || objP.dlvrAmt == '' || objP.dlvrAmt == '0') {
                if(objP.realDlvrAmt == null || objP.realDlvrAmt == '' || objP.realDlvrAmt == '0') {
                    dlvrAmt = 0;
                } else {
                    dlvrAmt = objP.realDlvrAmt;
                }
            } else {
                dlvrAmt = objP.dlvrAmt;
            }
            $("#realDlvrAmt").val(dlvrAmt);
           /* // 환불 금액
            var eAmt = (objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt ) - objP.restAmt;
            // pg전체 결제 금액
            var tAmt = objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt;
            // pg전체 결제 금액
            var pAmt = objP.payPgAmt + objP.payUnpgAmt;*/

            // 환불 금액
            //var eAmt = (objP.payPgAmt + objP.payUnpgAmt + objP.payReserveAmt ) - objP.restAmt;
            /*var eAmt = (objP.saleAmt * objP.claimQtt )-objP.dcAmt*/
            var eAmt = objP.eamt + dlvrAmt - objP.goodsDmoneyUseAmt;
            // 전체 결제 금액
            var tAmt = objP.orgPayPgAmt + objP.orgPayUnpgAmt;
            // pg전체 결제 금액
            var pAmt = objP.payPgAmt + objP.payUnpgAmt;


            $("#estimateAmt").html(eAmt);
            $("#modifyAmt").html(eAmt);
            $("#refundAmt").html(eAmt);

            // 환불 금액 계산
            if(objP.payUnpgAmt > 0 ) {
                // 실제 환불금액
                // if (eAmt<objP.payUnpgAmt){
                    $("#pgAmt").val(eAmt);
                // }else {
                //     $("#pgAmt").val(objP.payUnpgAmt);
                // }
                $("#pgtype1").html("무통장 환불");
                $("#pgType option:eq(1)").replaceWith("<option value='01' selected>무통장 환불</option>");
                $("#tempPgAmt").text(tAmt);

                jQuery('#bankInfo').show();

            }else if(objP.payPgAmt > 0 ) {
                // 실제 환불금액
                // if (eAmt<objP.payPgAmt){
                    $("#pgAmt").val(eAmt);
                // }else {
                //     $("#pgAmt").val(objP.payPgAmt);
                // }
                $("#pgType").val("02");
                // 최초결제금액
                $("#tempPgAmt").text(tAmt);
                $("#pgtype1").html("PG 환불");
                $("#pgType option:eq(2)").replaceWith("<option value='02' selected>PG 환불</option>");
                jQuery("#bankInfo").hide();
            }else{
                $("#pgType").val(0);
                $("#tempPgAmt").text(0);
                $("#pgAmt").val(0);
                $("#pgtype1").html("");
                $("#pgType option:eq(1)").replaceWith("<option value='01'>무통장 환불</option>");
                $("#pgType option:eq(2)").replaceWith("<option value='02'>PG 환불</option>");
                jQuery("#bankInfo").hide();
            }

            // 마켓포인트 환불 계산 최대금액측정
            if(pAmt > eAmt){
                //alert("환불금액보다 pg 금액이크다");
                $("#payReserveAmt").val(0);
            }else if(pAmt < eAmt){
                //alert("환불금액보다 pg 금액이 작다");
                if (eAmt-pAmt>objP.payReserveAmt){
                    //alert("마켓포인트보다 남은 금액이 크다");
                    $("#payReserveAmt").val(objP.payReserveAmt);
                }else {
                    //alert("마켓포인트보다 남은 금액이 작다");
                    $("#payReserveAmt").val(tAmt-pAmt);
                }
            }
            console.log("objP.restAmt = ", objP.restAmt);
            console.log("objP.payReserveAmt = ", objP.payReserveAmt);
            console.log("goodsDmoneyUseAmt = ", objP.goodsDmoneyUseAmt);
            $("#restAmt").val(objP.restAmt);
            $("#payReserveAmt").val(objP.goodsDmoneyUseAmt);
            $("#pgAmt").val(eAmt);
            $("#orgPgAmt").val(objP.orgPayPgAmt);
            $("#refundAmt").val(eAmt);
            // 부분취소 확인
            if (eAmt != tAmt) {
                $("#partCancelYn").val("Y");
            } else {
                $("#partCancelYn").val("N");
            }
                /*$("#payReserveAmt").val(objP.dlvrAmt);
                $("#payReserveAmt").val(objP.payReserveAmt);*/

            // 결과가 없을 경우 NO DATA 화면 처리
            if ( $("#tbody_exchange_data").find(".searchexchangeResult").length < 1 ) {
                jQuery('#tr_no_exchange_data').show();
            } else {
                jQuery('#tr_no_exchange_data').hide();
            }

            /*$("input[name=refundAmt]").attr("disabled","disabled");
            $("select[name=pgType]").attr("disabled","disabled");


            $("input[name=pgAmt]").attr("disabled","disabled");
            $("input[name=payReserveAmt]").attr("disabled","disabled");*/
            /*$("select[name=claimReasonCd]").attr("disabled","disabled");*/

            /*$("textarea[name=claimDtlReason]").attr("disabled","disabled");
            $("textarea[name=claimMemo]").attr("disabled","disabled");*/
        }
        preCheckGoods($("#exchange_ordNo:checked").length);
        curCheckGoods($("#exchange_ordNo:checked").length);
    });            
    
}

</script>

<div id="layout_payCancel" class="layer_popup">
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">결제취소 [<label id="label_exchangeOrdNo"></label>]</h2>
            <button class="close ico_comm" id="btn_payCancel_close2">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <h3 class="tlth3">주문상품</h3>
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="2%">
                            <col width="">
                            <col width="8%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">
                            <col width="8%">
                            <col width="9%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th></th>
                                <th>주문상품</th>
                                <th>수량</th>
                                <th>취소수량</th>
                                <th>판매가</th>
                                <th>할인금액</th>
                                <th>배송</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                            </tr>
                        </thead>
                        <tbody id = "ajaxPayCancelGoodsList">
                        </tbody>
                    </table>
                </div>

                
                
                <!--결제취소상품-->
                <h3 class="tlth3">결제취소상품</h3>
                <!-- tblh -->
                <input type="hidden" name="preCheckGoods" id="preCheckGoods" value="0"/>
                <input type="hidden" name="curCheckGoods" id="curCheckGoods" value="0"/>
                <input type="hidden" name="cancelType" id="cancelType" value="02"/>
                <input type="hidden" name="restAmt" id="restAmt" />
                <input type="hidden" name="orgReserveAmt" id="orgReserveAmt" />
                <input type="hidden" name="partCancelYn" id="partCancelYn" />
                <input type="hidden" name="exchangePayPgCd" id="exchangePayPgCd" />
                <input type="hidden" name="exchangePayPgWayCd" id="exchangePayPgWayCd" />
                <input type="hidden" name="exchangePayPgAmt" id="exchangePayPgAmt" />
                <input type="hidden" name="exchangePayUnpgCd" id="exchangePayUnpgCd" />
                <input type="hidden" name="exchangePayUnpgWayCd" id="exchangePayUnpgWayCd"/>
                <input type="hidden" name="exchangePayUnpgAmt" id="exchangePayUnpgAmt" />
                <input type="hidden" name="exchangePayReserveWayCd" id="exchangePayReserveWayCd" />
                <input type="hidden" name="orgCnt" id="orgCnt" />
                <input type="hidden" name="payReserveAmt" id="payReserveAmt" />
                <input type="hidden" name="orgPgAmt" id="orgPgAmt" />
                <input type="hidden" name="pgType" id="pgType" />
                <input type="hidden" name="pgAmt" id="pgAmt" />
                <input type="hidden" name="refundAmt" id="refundAmt" />
                <input type="hidden" name="realDlvrAmt" id="realDlvrAmt" />
                
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 주문취소상품 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="32%">
                            <col width="6%">
                            <col width="17%">
                            <col width="15%">
                            <col width="15%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>주문상품취소</th>
                                <th>취소수량</th>
                                <th>취소접수일시</th>
                                <th>취소완료일시</th>
                                <th>처리상태</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_exchange_data">
                        <form:form id="form_exchange_list">
                            <input type="hidden" name="siteNo" value="${siteNo}" />
                            <tr id="tr_exchange_data_template">
                                <input type="hidden" name="exchangeOrdStatusCd" id="exchangeOrdStatusCd" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd" value=""/>
                                <input type="hidden" name="exchangeOrdNo" id="exchangeOrdNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordNo" value=""/>
                                <input type="hidden" name="exchangeOrdDtlSeq" id="exchangeOrdDtlSeq" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value=""/>
                                <input type="hidden" name="exchangeDlvrAmt" id="exchangetotalDlvrAmt" />
                                <input type="hidden" name="exchangeClaimQtt" id="exchangeClaimQtt" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimQtt" value=""/>
                                <input type="hidden" name="exchangeClaimNo" id="exchangeClaimNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimNo" value=""/>
                                <td class="txtl">
                                <div class="item_box">
                                    <a href="javascript:;" class="goods_img"><img src="" alt="" data-bind="exchangeInfo" data-bind-type="img" data-bind-value="imgPath"/></a>
                                    <a href="javascript:;" class="goods_txt">
                                        <span class="tlt">
                                            <span data-bind="exchangeInfo" data-bind-type="String" data-bind-value="goodsNm"></span>
                                            <input type="hidden" name="goodsNm" id="goodsNm" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="goodsNm">
                                        </span>
                                        <span class="option">
                                            <span id="itemNm" data-bind="exchangeInfo" data-bind-type="string" data-bind-value="itemNm"></span>
                                        </span>
                                        <span class="code">[상품코드 : <span id="goodsNo" data-bind="exchangeInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]</span>
                                    </a>
                                </div>
                                </td>
                                <td data-bind="exchangeInfo" data-bind-value="claimQtt" data-bind-type="number"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="ordDtlStatusNm"  data-bind-type="String"></td>
                            </tr>
                        </form:form>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!--//주문취소상품-->
                
                <h3 class="tlth3">결제취소정보</h3>
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 결제취소정보 리스트 표 입니다. 구성은 계좌 정보, 상세사유, 관리메모 입니다.">
                        <caption>결제취소정보 리스트</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                            <tr id="bankInfo" style="display:none">
                                <th>계좌 정보</th>
                                <td colspan="3">
                                은행
                                <span class="select" id="span_bankCd_template">
                                    <label for="bankCd" id="bankCd2"></label>
                                      <select name="bankCd" id="bankCd" >
                                          <code:option codeGrp="BANK_CD" includeTotal="true" />
                                      </select>
                                    </label>
                                </span>
                                계좌번호
                                <span class="intxt long2  mr20"><input type="text" name="actNo" id="actNo" /></span>
                                예금주
                                <span class="intxt"><input type="text" name="holderNm" id="holderNm" /></span>
                                </td>
                            </tr>
                            <tr>
                                <th>취소사유</th>
                                <td colspan="3">
                                <span class="select" id="span_claimReasonCd_template">
                                    <label for="claimReasonCd" id="claimReasonCd2"></label>
                                    <select name="claimReasonCd" id="claimReasonCd" >
                                        <option value=""> 선택
                                        <code:option codeGrp="CLAIM_REASON_CD" />
                                    </select>
                                    </label>
                                </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상세사유</th>
                                <td colspan="3">
                                    <div class="txt_area">
                                        <textarea name="claimDtlReason" id="claimDtlReason"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>관리메모</th>
                                <td>
                                    <div class="txt_area">
                                        <textarea name="claimMemo" id="claimMemo"></textarea>
                                    </div>
                                </td>
                                <th class="line">처리로그</th>
                                <td>
                                    <div class="disposal_log">
                                     <ul id='ajaxPayCancelLogList'>
                                     </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <div class="btn_box txtc">
                        <button class="btn green" id="btn_payCancel_reg" claimCd="21">
                            결제 취소
                        </button>
                    <button class="btn green" id="btn_payCancel_close">닫기</button>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->