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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 주문관리 &gt; 상세화면</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
        /** 옵션 처리용 변수 Strart **/
        var itemInfo = '',
        // 오리지널 단품 가격
        orgItemSalePrice = 0,
        newItemSalePrice = 0,
        oldItemNo = '',
        newItemNo = '', 
        newItemNm = '';
        multiOptYn = 'N',
        optionOrdQtt = 0,   //주문 수량
        stockQtt = 0,
        siteNo = ${siteNo};
        /** 옵션 처리용 변수 End **/
        jQuery(document).ready(function() {
            ordExchangePopup.init();
            ordRefundPopup.init();

            console.log("${rsltInfoVo}");
            console.log("${payVo}");
            console.log("${orderGoodsVO}");
            /* currency(3자리수 콤마) */
            var commaNumber = (function(p){
                if(p==0) return 0;
                var reg = /(^[+-]?\d+)(\d{3})/;
                var n = (p + '');
                while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
                return n;
            });
            
            jQuery('#btn_fUpdateStatus20').on('click', function(e) {
                var ordStatusCd = '<c:if test="${fn:contains(rsltInfoVo.fordStatusCd, '20')}">20</c:if>';

                if(ordStatusCd!=null && ordStatusCd!='') {
                    jQuery('#ordStatusCd').val(ordStatusCd);
                    updateStatus(e);
                }
            });

            jQuery('#btn_fUpdateStatus30').on('click', function(e) {
                var ordStatusCd = '<c:if test="${fn:contains(rsltInfoVo.fordStatusCd, '30')}">30</c:if>';
                var mdConfirmYn = $(this).find("[name=mdConfirmYn]").val();
                if(mdConfirmYn!=undefined){
                    $('#mdConfirmYn').val(mdConfirmYn);
                }
                if(ordStatusCd!=null && ordStatusCd!='') {
                    jQuery('#ordStatusCd').val(ordStatusCd);
                    updateStatus(e);
                }
            });

            jQuery('#btn_bUpdateStatus').on('click', function(e) {
                var ordStatusCd = '<c:out value="${rsltInfoVo.bordStatusCd}"/>';
                if(ordStatusCd!=null && ordStatusCd!='') {
                    jQuery('#ordStatusCd').val(ordStatusCd);
                    // 주문취소 
                    if(ordStatusCd == '10'){
                        var ordNo = ${rsltInfoVo.ordNo};
                        var ordDtlSeqArr = "";
                        var comma = ",";
                        var cancelStatusCd = "11";
                        <c:forEach var="orderGoodsVo" items="${orderGoodsVO}" varStatus="status">

                        var statusIdx = ${status.index};
                        var addOptYn = "${orderGoodsVo.addOptYn}";
                        if (addOptYn == 'N') {
                            ordDtlSeqArr += ${orderGoodsVo.ordDtlSeq};
                            ordDtlSeqArr += comma;         
                        }
                        </c:forEach>
                        var param = {ordNo:ordNo,ordDtlSeqArr:ordDtlSeqArr,cancelStatusCd:cancelStatusCd};
                        var url = '/admin/order/manage/order-cancel-all';
                        //var param = $('#form_id_cancel').serializeArray();
                        Dmall.LayerUtil.confirm('<spring:message code="biz.confirm.ord.updateOrdStatus"/>', function() {
                            Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert('주문 취소 완료 되었습니다.');
                                    dtlReload();
                                }
                            });
                        });
                    }else{
                        updateStatus(e);
                    }
                }   
            });
            
            jQuery('#btn_memo_save').on('click', function(e) {
               e.preventDefault();
               e.stopPropagation();
               var url = "/admin/order/manage/order-memo-insert";
               param = jQuery('#form_ord_memo').serialize();
               Dmall.AjaxUtil.getJSON(url, param, function(result) {
                   if(result.success) {
                   }
               });   
            });
            
            jQuery('#btn_print').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var url =  "/admin/order/manage/order-print";
                var ordNo = $("#form_ord_dtl").find('input[name="ordNo"]').val();

                window.open(url, "ordPrint", "width="+1024+",height="+860+",resizable=1,scrollbars=1") ;
                Dmall.FormUtil.submit(url, {ordNo : ordNo}, "ordPrint");
            });
            
            //우편번호 팝업
            jQuery('#btn_post').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                Dmall.LayerPopupUtil.zipcode(setZipcode);
            });
            
            //지역 구분
            var memberGbCd = '${rsltInfoVo.memberGbCd}';
            if(memberGbCd == '10')$('#shipping_domestic').click();
            if(memberGbCd == '20')$('#shipping_oversea').click();
            
            //배송지 변경 저장
            jQuery('#btn_addr').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var url = "/admin/order/delivery/order-address-update";
                if($("input[name='memberGbCd']:checked").val() == '10') { // 국내 주소
                    
                    if($("input[name='postNo']").val()=='' || $("input[name='dtlAddr']").val()=='') {
                        Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.deliveryAddrInfo"/>');
                        return;
                    }
                } else {
                    if($("select[name='frgAddrCountry']").val()=='' || $("input[name='frgAddrZipCode']").val()=='' || $("input[name='frgAddrState']").val()=='' || $("input[name='frgAddrCity']").val()=='' || $("input[name='frgAddrDtl1']").val()=='') {
                        Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.deliveryAddrInfo"/>');
                        return;
                    }
                }
                    
                param = jQuery('#form_ord_dtl').serialize();
                console.log("param = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                    }
                });  
                
            });
            // 주문 관리
            jQuery('#btn_ordlist').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var url = "/admin/order/manage/order-status";
                var data = {};
                //$("#form_ord_so").serializeArray().map(function(x){data[x.name] = x.value;});
                
                var i = 0, oldName ='', newName = [];
                
                $("#form_ord_so").serializeArray().map(function(x){
                    if(x.value!='') {
                        if(x.name =='ordStatusCd' || x.name =='paymentWayCd' || x.name =='ordMediaCd' || x.name =='saleChannelCd') {
                            if(oldName =='')
                                newName = [];
                            if(oldName =='' || oldName == x.name) {
                                newName[i] = x.value;
                                i++;
                            }
                            else {
                                if(newName.length > 0) {
                                    data[oldName] = newName;
                                    newName = [];
                                    i=0;
                                }
                                newName[i] = x.value;
                                i++;
                            }
                            oldName = x.name;
                        }
                        else {
                            data[x.name] = x.value;
                            if(newName.length > 0) {
                                data[oldName] = newName;
                                newName = [];
                            }
                        }
                    }
                });
                
                $("#form_ord_so").submit();
                
            });
            // 배송 처리 레이어 팝업
            jQuery('#btn_delivery').on('click', function(e) {
                   e.preventDefault();
                   e.stopPropagation();
                   $("#tbody_div_data").find(".searchDivResult").each(function() {
                       $(this).remove();
                   });
                   
                   jQuery("#tr_div_data_template").hide();
                   jQuery('#tr_no_div_data').show();
                   var url = '/admin/order/delivery/invoice-popup',
                   param = $('#form_ord_dtl').serialize(),
                   dfd = jQuery.Deferred();
           
                   Dmall.AjaxUtil.getJSON(url, param, function(result) {
                       //
                       if (result == null || result.success != true) {
                           return;
                       }
                       // 취득결과 셋팅
                       jQuery.each(result.resultList, function(idx, obj) {
                           var trId = obj.rownum;
                           var $tmpSearchResultTr = "";
//                           alert(obj.rownum);
                           var $tmpSearchResultTr = $("#tr_div_data_template").clone().show().removeAttr("id");
                           $($tmpSearchResultTr).attr("id", trId).addClass("searchDivResult");
                           if(obj.dlvrcPaymentCd=='04') { // 매장픽업인 경우
                               /*$($tmpSearchResultTr).find("#div_dlvrcPaymentNm").css("display","");
                               $($tmpSearchResultTr).find("#span_courierCd_template").css("display","none");
                               $($tmpSearchResultTr).find("#span_div_rlsInvoiceNo").css("display","none");
                               $($tmpSearchResultTr).find("#span_div_rlsInvoiceNo2").css("display","none");*/
                           }
                           // 배송처리 완료 경우
                           if(obj.ordDtlStatusCd != '30') { // 결제최소
                               $($tmpSearchResultTr).find("#span_div_rlsInvoiceNo2").css("display","none");
                               $($tmpSearchResultTr).find("#btn_div_rlsInvoiceNo2").css("display","none");
                               if(obj.ordDtlStatusCd=='21') {
                                   $($tmpSearchResultTr).find("#span_div_rlsInvoiceNo").css("display","none");
                               }
                           }
                           $('[data-bind="divInfo"]', $tmpSearchResultTr).DataBinder(obj);                
                           $("#tbody_div_data").append($tmpSearchResultTr);
                       });
                       // 결과가 없을 경우 NO DATA 화면 처리
                       if ( $("#tbody_div_data").find(".searchDivResult").length < 1 ) {
                           jQuery('#tr_no_div_data').show();
                       } else {
                           jQuery('#tr_no_div_data').hide();                                            
                       }
                       Dmall.LayerPopupUtil.open(jQuery('#layout_delivery'));
                   });
            });
            
            //  환불처리 레이어 팝업
            jQuery('#btn_refund').on('click', function(e) {
                ordRefundPopup.btnRefundClick('<c:out value="${rsltInfoVo.ordNo}"/>', 1, 'M');
            });

            // 교환 레이어 팝업
            jQuery('#btn_exchange').on('click', function(e) {
                <c:set var="claimOrdStatusCd" value="${rsltInfoVo.fClaimOrdStatusCd}"/>
                ordExchangePopup.btnExchangeClick('<c:out value="${rsltInfoVo.ordNo}"/>', 2, '<c:if test="${fn:contains(claimOrdStatusCd, '50')}">50</c:if>', 'M');
            });

            // 결제 취소 레이어 팝업
            jQuery('#btn_payCancel').on('click', function(e) {
                <c:set var="claimOrdStatusCd" value="${rsltInfoVo.fClaimOrdStatusCd}"/>
                ordExchangePopup.btnExchangeClick('<c:out value="${rsltInfoVo.ordNo}"/>', 3, '<c:if test="${fn:contains(claimOrdStatusCd, '50')}">50</c:if>', 'M');
            });
            
            // 환불 교환 히스토리 확인 후 버튼 disable
            var hasRefundHis = 'N';
            var hasExchangeHis = 'N';
            var hasPayCancelHis = 'N';
             <c:forEach var="ordClaimList" items="${ordClaimList}" varStatus="status">
            <c:if test="${status.index eq 0 and ordClaimList.claimTypeCd eq '6'}">
                hasExchangeHis = 'Y';
                hasPayCancelHis = 'Y';
            </c:if>
            <c:if test="${status.index eq 0 and ordClaimList.claimTypeCd eq '7'}">
                hasRefundHis = 'Y';
            </c:if>
            </c:forEach>
            if(hasRefundHis == 'Y')
                $("#btn_exchange").attr('href', '').css({'cursor': 'pointer', 'pointer-events' : 'none'});
            if(hasExchangeHis == 'Y')
                $("#btn_refund").attr('href', '').css({'cursor': 'pointer', 'pointer-events' : 'none'});
            if(hasPayCancelHis == 'Y')
                $("#btn_payCancel").attr('href', '').css({'cursor': 'pointer', 'pointer-events' : 'none'});


            // 택배사 미리 세팅
            <c:if test="${rsltInfoVo.ordStatusCd eq '20' or rsltInfoVo.ordStatusCd eq '30' or rsltInfoVo.ordStatusCd eq '39' or rsltInfoVo.ordStatusCd eq '49' or fn:contains(rsltInfoVo.fordStatusCd, '40')}">
            var url2 = '/admin/order/delivery/site-courier-list';
            var s = $('#div_rlsCourierCd');
            Dmall.AjaxUtil.getJSON(url2, jQuery('#form_ord_dtl').serialize(), function(result2) {
                // 택배사 목록
                $("<option />", {value: '', text: '선택'}).appendTo(s);
//                $("<option />", {value: '00', text: '직접배송'}).appendTo(s);
                jQuery.each(result2.resultList, function(idx, obj) {
                     $("<option />", {value: obj.rlsCourierCd, text: obj.rlsCourierNm}).appendTo(s);
                });
            });
            </c:if>
            
            /* 옵션 레이어 추가(필수)*/
            var k = 0; //옵션레이어 순번
            $(document).on('change', 'select.select_option.goods_option', function(e){
                
//             $('select.select_option.goods_option').on('change',function(){
                //하위 옵션 동적 생성
                var val = $(this).find(':selected').val();
                var seq = $(this).data().optionSeq;
                jsSetOptionInfo(seq, val);
                var optAdd = true;
                $('select.select_option.goods_option').each(function(index){
                    if($(this).val() == '') {
                        optAdd = false;
                        return false;
                    }
                });

                //필수옵션을 모두 선택하면 레이어 생성
                if (optAdd) {
                    //단품번호 조회
                    var optNo1=0, optNo2=0, optNo3=0, optNo4=0, attrNo1=null, attrNo2=null, attrNo3=null, attrNo4=null;
                    $('select.select_option.goods_option').each(function(index){
                    
                        var d=$(this).data();
                        switch(d.optionSeq) {
                            case 1:
                                optNo1 = d.optNo;
                                attrNo1 = $(this).find('option:selected').val()
                                break;
                            case 2:
                                optNo2 = d.optNo;
                                attrNo2 = $(this).find('option:selected').val()
                                break;
                            case 3:
                                optNo3 = d.optNo;
                                attrNo3 = $(this).find('option:selected').val()
                                break;
                            case 4:
                                optNo4 = d.optNo;
                                attrNo4 = $(this).find('option:selected').val()
                                break;
                        }
                    });
                    if (itemInfo != '') {
                        var obj = JSON.parse(itemInfo); //단품정보
                        var addLayer = true;    //레이어 추가 여부
                        var itemNo = "";    //단품번호
                        var itemNm = "";    //단품명
                        //var salePrice = '${goodsInfo.data.salePrice}';  //상품가격
                        var itemPrice = 0;  //단품가격
                        //var stockQtt = 0;   //재고수량
                        for(var i=0; i<obj.length; i++) {
                            if(obj[i].attrNo1 == attrNo1 && obj[i].attrNo2 == attrNo2 && obj[i].attrNo3 == attrNo3 && obj[i].attrNo3 == attrNo3) {
                                itemNo = obj[i].itemNo;
                                if (obj[i].attrValue1 != null) {
                                    itemNm += obj[i].optValue1 + ':';
//                                    if(itemNm != '') itemNm +=', ';
                                    itemNm += obj[i].attrValue1;
                                }
                                if (obj[i].attrValue2 != null) {
                                    if(itemNm != '') itemNm +=', ';
                                    itemNm += obj[i].optValue2 + ':';
                                    itemNm += obj[i].attrValue2;
                                }
                                if (obj[i].attrValue3 != null) {
                                    if(itemNm != '') itemNm +=', ';
                                    itemNm += obj[i].optValue3 + ':';
                                    itemNm += obj[i].attrValue3;
                                }
                                if (obj[i].attrValue4 != null) {
                                    if(itemNm != '') itemNm +=', ';
                                    itemNm += obj[i].optValue4 + ':';
                                    itemNm += obj[i].attrValue4;
                                }
                                itemPrice = obj[i].salePrice;
                                stockQtt = obj[i].stockQtt;
 //                                itemNm += '&nbsp;&nbsp;(재고:'+commaNumber(stockQtt)+')';
                            }
                        }
                        if($('.itemNoArr').length > 0) {
                            $('.itemNoArr').each(function(index){
                                if($(this).val() == itemNo) {
                                    $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                                    addLayer = false;
                                }
                            });
                        }
                        newItemNo = itemNo;
                        newItemNm = itemNm;
                        newItemSalePrice = itemPrice;
                    }
                }
            })

            // 옵션 변경 확인
            $('#btn_option_change').on('click', function(){
                var formCheck = false;
                formCheck = jsFormValidation();
                if(formCheck && newItemNo!='') {
                    var url = '/admin/order/manage/order-option-update';
                    var ordNo = jQuery('#form_ord_dtl input[name=ordNo]').val();
                    var ordDtlSeq = jQuery('#form_ord_dtl input[name=ordDtlSeq]').val();
                    var param = {ordNo:ordNo, ordDtlSeq:ordDtlSeq, itemNo:newItemNo, itemNm:newItemNm, ordQtt:optionOrdQtt, oldItemNo:oldItemNo};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.alert('옵션을 변경했습니다.');
                            Dmall.LayerPopupUtil.close('layout_option');
                            dtlReload();
                        }
                    }); 
                }
            });

        });

        // 배송중 > 배송 완료로 주문 상태 변경
        function updateDelivDone(ordDtlSeq) {
            var ordStatusCd = '50';
            var curOrdStatusCd = '40';
            Dmall.LayerUtil.confirm('배송완료처리 하시겠습니까?', function() {
                var url = "/admin/order/manage/order-status-update";
                jQuery('#form_ord_dtl input[name=curOrdStatusCd]').val(curOrdStatusCd);
                jQuery('#form_ord_dtl input[name=ordStatusCd]').val(ordStatusCd);
                jQuery('#form_ord_dtl input[name=ordDtlSeq]').val(ordDtlSeq);
                param = jQuery('#form_ord_dtl').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        dtlReload();
                    }
                });
            });
        }

        /** 주문 상태 변경 */
        function updateStatus(e) {
            e.preventDefault();
            e.stopPropagation();
            Dmall.LayerUtil.confirm('<spring:message code="biz.confirm.ord.updateOrdStatus"/>', function() {
                var url = "/admin/order/manage/order-status-update";
                jQuery('#form_ord_dtl input[name=ordDtlSeq]').val('');
                param = jQuery('#form_ord_dtl').serialize();
                console.log("parma = ", param);
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        dtlReload();
                    }
                });
            });
        }
        // 페이지 새로 호출
        function dtlReload() { 
            //$('#ordNo').val(ordNo);
            var data = {};
            jQuery('#form_ord_so input[name=ordDtlSeq]').val('Y');
            $("#form_ord_so").serializeArray().map(function(x){data[x.name] = x.value;});
            var url =  "/admin/order/manage/order-detail";
            Dmall.FormUtil.submit(url, data);
        }
        
        
        // print
        function OpenWindow(url,intWidth,intHeight) { 
            window.open(url, "_blank", "width="+intWidth+",height="+intHeight+",resizable=1,scrollbars=1") ; 
        }
        
   
        //우편번호, 주소 값 입력
        function setZipcode(data) {
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('#postNo').val(data.zonecode); //5자리 새우편번호 사용
            $('#numAddr').val(data.jibunAddress);
            $('#roadnmAddr').val(data.roadAddress);
            $('#addrDtl').val('').focus();
        }
        
        // 결과 행의 배송처리 버튼 실행
        function updateDelivery(data, obj, bindName, target, area, row) {
            var rownum = data["rownum"];
            obj.off("click").on('click', function() {
               if(('04'!=getColVal(rownum, 'div_dlvrcPaymentCd','')) && ((''==getColVal(rownum, 'div_rlsCourierCd','select')) || ('98'!=getColVal(rownum, 'div_rlsCourierCd','select') && ''==getColVal(rownum, 'div_rlsInvoiceNo','input'))) ) {
                   Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.deliveryInfo"/>');
                   return;
               }



               if(confirm("SMS/알림톡을 전송하시겠습니까?")){
                    jQuery('#form_delivery input[name=smsSendYn]').val("Y");
               }else{
                    jQuery('#form_delivery input[name=smsSendYn]').val("N");
               }

               Dmall.LayerUtil.confirm('<spring:message code="biz.confirm.ord.deliveryInfo"/>', function() {


                           jQuery('#form_delivery input[name=dlvrcPaymentCd]').val(getColVal(rownum, 'div_dlvrcPaymentCd', ''));
                           jQuery('#form_delivery input[name=rlsCourierCd]').val(getColVal(rownum, 'div_rlsCourierCd', 'select'));
                           jQuery('#form_delivery input[name=rlsInvoiceNo]').val(getColVal(rownum, 'div_rlsInvoiceNo', 'input'));
                           jQuery('#form_delivery input[name=dlvrNo]').val(getColVal(rownum, 'div_dlvrNo', 'input'));
                           jQuery('#form_delivery input[name=ordDtlSeq]').val(getColVal(rownum, 'div_ordDtlSeq', 'input'));
                           jQuery('#form_delivery input[name=goodsNo]').val(getColVal(rownum, 'div_goodsNo', 'input'));
                           jQuery('#form_delivery input[name=dlvrQtt]').val(getColVal(rownum, 'div_ordQtt', 'input'));
                           var url = '/admin/order/delivery/order-newinvoice-update',
                               param = $('#form_delivery').serialize(),
                               dfd = jQuery.Deferred();

                           Dmall.AjaxUtil.getJSON(url, param, function (result) {
                               if (result.success) {

                                   //Dmall.LayerPopupUtil.close(jQuery('#layout_delivery'));
                               }

                               /*                        if (result == null || result.success != true) {
                                                          alert('
                               <spring:message code="biz.exception.common.error"/>');
                               }else {
                                   alert('
                               <spring:message code="biz.common.insert"/>');
                               }
         */
                           });


               });
            });
        }
        /** 배송 정보 데이터 input 이름으로 갖고 오기 */
        function getColVal(rownum, name, action){
            str = '';
            var i = 0;
            $(action + "[id='" + name + "']").each(function() {
                if (i==rownum) {
                    str = $(this).val();
                } 
                i++;
            });
            return str;
        }
        /**
            택배사, 송장번호 변경
        */
        function btn_deliv_chg(index) {
            var url = "/admin/order/delivery/order-invoice-update";
            param = jQuery('#form_ord_dlv_' + index).serialize();
            if(jQuery('#dtl_rlsCourierCd_'+index).val()!='98' && jQuery('#dtl_rlsInvoiceNo_'+index).val()=='') {
                Dmall.LayerUtil.alert('<spring:message code="biz.exception.ord.noInvoice"/>');
                return;
            }
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                }
            });   
         }
    
    // 옵션 변경 레이어 팝업
    function openOptionLayer(goodsNo, itemNo, salePrice, ordQtt, goodsIndex, ordDtlSeq) {
      //옵션 정보 호출
      orgItemSalePrice = salePrice;
      oldItemNo = itemNo;
      optionOrdQtt = ordQtt;
      var url = "/admin/order/manage/order-detail-option",
      param = {goodsNo:goodsNo, itemNo:itemNo};
      jQuery('#form_ord_dtl input[name=ordDtlSeq]').val(ordDtlSeq);
      Dmall.AjaxUtil.getJSON(url, param, function(result) {
          if(result.success) {
              if(result.data.goodsOptionList==null) {
                  Dmall.LayerUtil.alert('선택할 수 있는 옵션이 없습니다.');
              } else {
                  var template1 = '' +
                          '<span class="select">' +
                          '<label for="select_option">(필수) 선택하세요</label>',
                  template2 =   ' data-opt-no="{{optNo}}" data-opt-nm="{{optNm}}">' +
                          '<option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>' +
                          '</select>' +
                          '</span>' +
                      '<br>',
                  tr = '';
                  <c:forEach var="orderGoodsVo" items="${orderGoodsVO}" varStatus="status2">
                      index = ${status2.index};
                      if(index == goodsIndex) {
                          <c:forEach var="optionList" items="${orderGoodsVo.goodsOptionList}" varStatus="status">
                          tr += '<li>';
                          tr += template1;
                          tr += '<select class="select_option goods_option" id="goods_option_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">' ;
                          tr += ' data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">' ;
                          tr += '<option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>';
                          tr += '</select>' ;
                          tr += '</span>' ;
                          tr += '</li>';
                          </c:forEach>
                      }
                  </c:forEach>
                  // 기존 아이템 정보 출력
                  oldTr = '';
                  jQuery.each(result.data.goodsItemList, function(idx, obj) {
                      if(obj.attrValue1!=null && obj.attrValue1!='')
                          oldTr += obj.optValue1 + ' : ' + obj.attrValue1 + "<br>";
                      if(obj.attrValue2!=null && obj.attrValue2!='')
                          oldTr += obj.optValue2 + ' : ' + obj.attrValue2 + "<br>";
                      if(obj.attrValue3!=null && obj.attrValue3!='')
                          oldTr += obj.optValue3 + ' : ' + obj.attrValue3 + "<br>";
                      if(obj.attrValue4!=null && obj.attrValue4!='')
                          oldTr += obj.optValue4 + ' : ' + obj.attrValue4;
    
                  });
                  jQuery('#optionList').html(tr);
                  jQuery('#optionOldList').html(oldTr);
                  <c:forEach var="orderGoodsVo" items="${orderGoodsVO}" varStatus="status">
                  index = ${status.index};
                  if(index == goodsIndex) {
                      itemInfo = '${orderGoodsVo.jsonList}';
                  }
                  </c:forEach>
                  multiOptYn = result.data.multiOptYn;
                  stockQtt = result.data.stockQtt;
                  jsSetOptionInfo(0,'');
                  Dmall.LayerPopupUtil.open(jQuery('#layout_option'));
              }
          }
      });
    };
    
    /* 옵션 셀렉트 박스 동적 생성 */
    function jsSetOptionInfo(seq, val) {
         $('#goods_option_'+seq).find("option").remove();
        if(itemInfo != '') {
            var obj = JSON.parse(itemInfo); //단품정보
            var optionHtml = '<option selected="selected"  value="">(필수) 선택하세요</option>';
            var preAttrNo = ''
            var selectBoxCount = $('[id^=goods_option_]').length;

            if(seq == 0) {  //최초 셀렉트박스 옵션 생성
                for(var i=0; i<obj.length; i++) {
                    if(preAttrNo != obj[i].attrNo1) {
                        optionHtml += '<option value="'+obj[i].attrNo1+'">'+obj[i].attrValue1+'</option>';
                        preAttrNo = obj[i].attrNo1;
                    }
                }
            } else {

                var attrNo = [];
                for(var i=0; i<seq; i++) {
                    attrNo[i] = $('#goods_option_'+i).find(':selected').val();
                }

                //하위 옵션 셀렉트 박스 초기화
                if(val == '') {
                    for(var i=seq; i<selectBoxCount; i++) {
                        $('#goods_option_'+i).find("option").remove();
                    }
                }

                for(var i=0; i<obj.length; i++) {
                    var len = attrNo.length;

                    if(seq==1) {
                        if(attrNo[0] == obj[i].attrNo1) {
                            if(preAttrNo != obj[i].attrNo2) {
                                optionHtml += '<option value="'+obj[i].attrNo2+'">'+obj[i].attrValue2+'</option>';
                                preAttrNo = obj[i].attrNo1;
                            }
                        }
                    } else if(seq==2) {
                        if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2) {
                            if(preAttrNo != obj[i].attrNo3) {
                                optionHtml += '<option value="'+obj[i].attrNo3+'">'+obj[i].attrValue3+'</option>';
                                preAttrNo = obj[i].attrNo1;
                            }
                        }
                    } else if(seq==3) {
                        if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2 && attrNo[3] == obj[i].attrNo3) {
                            if(preAttrNo != obj[i].attrNo4) {
                                optionHtml += '<option value="'+obj[i].attrNo4+'">'+obj[i].attrValue4+'</option>';
                                preAttrNo = obj[i].attrNo1;
                            }
                        }
                    }
                }
            }
            $('#goods_option_'+seq).append(optionHtml);
        }
    }
        
        /* 폼 필수 체크 */
        function jsFormValidation() {

            var optLayerCnt = $('[id^=option_layer_]').length; //필수옵션 레이어 갯수
            var optionSelectOk = true; //필수옵션 선택 확인
            var addOptRequiredYn = 'N'; //추가옵션(필수) 존재 여부;
            var addOptRequiredOptNo = new Array(); //추가옵션(필수) 선택한 옵션 번호 배열;
            var addOptBoxCnt = 0;//추가옵션(필수) 셀렉트박스 갯수
            var addOptionSelectOk = true; //추가옵션(필수) 선택 확인
            var optionNm = ''; //옵션명
            var itemNm = ''; //단품명
            $('[id^=add_option_layer_]').each(function(index){
                if($(this).data().requiredYn == 'Y') {
                    addOptRequiredOptNo.push($(this).data().addOptNo);
                }
            });
            $('select.select_option.goods_addOption').each(function(){
                if($(this).data().requiredYn == 'Y') {
                    addOptBoxCnt++;
                }
            });


            /* 필수 옵션 선택 확인 */
            if(multiOptYn == 'Y' && optLayerCnt == 0) {
                $('select.select_option.goods_option').each(function(){
                    if($(this).find(':selected').val() == ''){
                        optionNm = $(this).data().optNm;
                        optionSelectOk = false;
                        return false;
                    }
                });
                if(!optionSelectOk) {
                    Dmall.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
                    return false;
                }
            }
            // 동일한 옵션일 경우 
            if(oldItemNo == newItemNo) {
                Dmall.LayerUtil.alert('동일한 옵션을 선택했습니다.');
                return false;
            }
            // 바뀐 옵션에 따른 ItemNo
            if(orgItemSalePrice != newItemSalePrice) { // 옵션 변경 후 가격 변동이 있다면
                Dmall.LayerUtil.alert('동일한 가격으로만 옵션을 변경할 수 있습니다.');
                return false;
            }
            //재고 확인
            stockQttOk = jsCheckOptionStockQtt();

            if(!stockQttOk) {
                if(itemNm == '') {
                    Dmall.LayerUtil.alert('재고수량을 확인해 주시기 바랍니다.');
                } else {
                    Dmall.LayerUtil.alert(itemNm+'<br>재고수량을 확인해 주시기 바랍니다.');
                }
                return false;
            }
            return true;
        }
        

        /* 상품 옵션 초기화 */
        function jsOptionInit(){
            $('select.select_option.goods_option').each(function(index){
                $(this).val('');
                $(this).trigger('change');
            });
        }

        /* 옵션 재고 확인(옵션O) */
        function jsCheckOptionStockQtt() {
            var rtn = true;
            if(Number(stockQtt) > Number(optionOrdQtt)) {
                rtn = true;
            } else {
                rtn = false;
            }
            return rtn;
        }
        
        /* 적용할인쿠폰 상세화면 이동 */
        function openCouponDtl(couponNo) {
        	Dmall.FormUtil.submit('/admin/promotion/coupon-detail',{couponNo : couponNo});
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form:form id="form_ord_so" action="/admin/order/manage/order-status">
            <input type="hidden" name="ordDayS" value='${ordSO.ordDayS}'/>
            <input type="hidden" name="ordDayE" value='${ordSO.ordDayE}'/>
            <input type="hidden" name="dayTypeCd" value='${ordSO.dayTypeCd}'/>
            <c:forEach var="ordStatusCd" items="${ordSO.ordStatusCd}">
            <input type="hidden" name="ordStatusCd" value='${ordStatusCd}'/>
            </c:forEach>
            <c:forEach var="paymentWayCd" items="${ordSO.paymentWayCd}">
            <input type="hidden" name="paymentWayCd" value='${paymentWayCd}'/>
            </c:forEach>
            <c:forEach var="ordMediaCd" items="${ordSO.ordMediaCd}">
            <input type="hidden" name="ordMediaCd" value='${ordMediaCd}'/>
            </c:forEach>
            <c:forEach var="saleChannelCd" items="${ordSO.saleChannelCd}">
            <input type="hidden" name="saleChannelCd" value='${saleChannelCd}'/>
            </c:forEach>
            <input type="hidden" name="memberOrdYn" value='${ordSO.memberOrdYn}'/>
            <input type="hidden" name="searchCd" value='${ordSO.searchCd}'/>
            <input type="hidden" name="searchWord" value='${ordSO.searchWord}'/>
            <input type="hidden" name="ordNo" value='${ordSO.ordNo}'/>
            <input type="hidden" name="sidx" value='${ordSO.sidx}'/>
            <input type="hidden" name="sord" value='${ordSO.sord}'/>
            <input type="hidden" name="rows" value='${ordSO.rows}'/>
            <input type="hidden" name="page" value="${ordSO.page}" />
            <input type="hidden" name="ordDtlSeq"/>
        </form:form>

        <form:form id="form_delivery">
            <input type="hidden" name="dlvrNo" value=''/>
            <input type="hidden" name="siteNo" value='<c:out value="${rsltInfoVo.siteNo}"/>'/>
            <input type="hidden" name="ordNo" value='<c:out value="${rsltInfoVo.ordNo}"/>'/>
            <input type="hidden" name="ordDtlSeq" value=''/>
            <input type="hidden" name="goodsNo" />
            <input type="hidden" name="ordStatusCd" value='<c:out value="${rsltInfoVo.ordStatusCd}"/>'/>
            <input type="hidden" name="rlsCourierCd"/>
            <input type="hidden" name="rlsInvoiceNo"/>
            <input type="hidden" name="dlvrcPaymentCd"/>
            <input type="hidden" name="dlvrQtt" />
            <input type="hidden" name="dlvrMsg" value='<c:out value="${rsltInfoVo.dlvrMsg}"/>'/>
            <input type="hidden" name="smsSendYn" value="N"/>
        </form:form>

        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    주문 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">주문 관리</h2>
            </div>
            <!-- line_box -->
            <div class="line_box pb">
                <!-- 주문상태관리 -->
                <h3 class="tlth3">주문 상태 관리</h3>
                <c:set var="fordStatusCd" value="${rsltInfoVo.fordStatusCd}"/>
                <c:set var="fClaimOrdStatusCd" value="${rsltInfoVo.fClaimOrdStatusCd}"/>
                <div class="tblw tblmany ">
                    <table summary="이표는 주문 상태 관리표입니다. 구성은 주문번호 주문상태 클레임상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="150px" />
                            <col width="" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>주문번호</th>
                                <td >${rsltInfoVo.ordNo}</td>
                            </tr>
                            <tr>
                                <th>주문상태</th>
                                <td>

                                    <c:if test="${fordStatusCd ne ''}">
                                        <c:if test="${fn:contains(fordStatusCd, '20')}">
                                        <a href="javascript:;" class="btn--white btn--small mr20" id="btn_fUpdateStatus20">
                                            결제완료
                                        </a>
                                        </c:if>
                                        <c:if test="${fn:contains(fordStatusCd, '30')}">
                                            <a href="javascript:;" class="btn--white btn--small mr20" id="btn_fUpdateStatus30">
                                                MD확정
                                                <input type="hidden" class="btn blue" name="mdConfirmYn" value="Y"/>
                                            </a>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${fn:contains(fordStatusCd, '40')}">
                                        <a href="javascript:;" class="btn--white btn--small" id="btn_delivery">배송처리</a>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>클레임 상태</th>
                                <td >
                                    <c:if test="${rsltInfoVo.saleChannelCd eq 'shop9999'}">

                                        <c:if test="${fn:contains(fClaimOrdStatusCd, '20')}">
                                            <a href="javascript:;" class="btn--white btn--small mr20" id="btn_payCancel">결제취소신청</a>
                                        </c:if>
                                        <c:if test="${fn:contains(fClaimOrdStatusCd, '50')}">
                                            <a href="javascript:;" class="btn--white btn--small mr20" id="btn_refund">반품</a>
                                        </c:if>
                                        <c:if test="${fn:contains(fClaimOrdStatusCd, '50')}">
                                            <a href="javascript:;" class="btn--white btn--small mr20" id="btn_exchange">교환</a>
                                        </c:if>
                                    </c:if>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 주문상품 -->
                <h3 class="tlth3">주문 상품</h3>
                <div class="tblh tblmany line_no">
                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="8%">
                            <col width="23%">
                            <col width="12%">
                            <col width="7%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>이미지</th>
                                <th>상품명<br>[상품코드]</th>
                                <th>옵션</th>
                                <th>수량</th>
                                <th>판매가</th>
                                <th>할인금액</th>
                                <th>배송비</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="sumQty" value="0"/>
                            <c:set var="sumSaleAmt" value="0"/>
                            <c:set var="sumTotalSaleAmt" value="0"/>
                            <c:set var="sumDcAmt" value="0"/>
                            <c:set var="sumDlvrAmt" value="0"/>
                            <c:set var="sumPayAmt" value="0"/>
                            <c:set var="sumGoodsDmoneyUseAmt" value="0"/>
                            <c:set var="totalRow" value="${orderGoodsVO.size()}"/>
                            <c:forEach var="orderGoodsVo" items="${orderGoodsVO}" varStatus="status">
                                <tr>
                                    <td class="txtl">
                                        <div class="item_box">
                                            <a href="javascript:;" class="goods_img"><img src="${_IMAGE_DOMAIN}${orderGoodsVo.imgPath}" alt="" /></a>
                                        </div>
                                    </td>
                                    <td class="txtl">
                                        <div class="item_box">
                                            <a href="javascript:;" class="goods_txt">
                                                <span class="tlt">${orderGoodsVo.goodsNm}</span>
                                                <span class="code">[상품코드 : ${orderGoodsVo.goodsNo}]</span>
                                                <c:if test="${orderGoodsVo.freebieNm ne null and orderGoodsVo.freebieNm ne ''}">
                                                <span class="option">
                                                   <span class="ico01">사은품</span>
                                                   <c:out value="${orderGoodsVo.freebieNm}"/>
                                                </span>
                                                </c:if>
                                            </a>
                                        </div>
                                    </td>
                                    <td class="txtl">
                                        <div class="item_box">
                                            <a href="javascript:;" class="goods_txt">
                                                <c:if test="${orderGoodsVo.itemNm ne null and orderGoodsVo.itemNm ne ''}">
                                                <span class="option">
                                                    <span class="ico01">옵션</span>
                                                    <c:out value="${orderGoodsVo.itemNm}"/>
                                                </span>
                                                </c:if>
                                                <c:if test="${orderGoodsVo.freebieNm ne null and orderGoodsVo.freebieNm ne ''}">
                                                <span class="option">
                                                   <span class="ico01">사은품</span>
                                                   <c:out value="${orderGoodsVo.freebieNm}"/>
                                                </span>
                                                </c:if>
                                            </a>
                                        </div>
                                    </td>
                                    <td>${orderGoodsVo.ordQtt}</td>
                                    <td class="txtc"><fmt:formatNumber value='${orderGoodsVo.saleAmt}' type='number'/></td>
                                    <td class="txtc"><fmt:formatNumber value='${orderGoodsVo.dcAmt}' type='number'/> </td>

                                    <c:if test="${orderGoodsVo.addOptYn eq 'N' and orderGoodsVo.dlvrcCnt ne 0}">
                                    <td rowspan="${orderGoodsVo.dlvrcCnt}" id='${orderGoodsVo.areaAddDlvrc}'>

                                        <c:choose>
                                        <c:when test="${orderGoodsVo.areaAddDlvrc ne '0' }">
                                            선불<br>
                                        </c:when>
                                        <c:otherwise>
                                            ${orderGoodsVo.dlvrcPaymentNm}<br>
                                        </c:otherwise>
                                        </c:choose>

                                    <c:if test="${(orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc) > 0 }">
                                        <fmt:formatNumber value='${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}' type='number'/>
                                    </c:if>
                                    </td>
                                    </c:if>
                                    <td class="txtc"><fmt:formatNumber value='${orderGoodsVo.payAmt - orderGoodsVo.goodsDmoneyUseAmt}' type='number'/></td>
                                    <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                                    <td>
                                        <c:if test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                            예약전용
                                        </c:if>
                                        <c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
                                            ${orderGoodsVo.ordDtlStatusNm}
                                        </c:if>
                                    </td>
                                    </c:if>
                                </tr>
                            <c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
                            <c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.ordQtt * orderGoodsVo.saleAmt)}"/>
                            <c:set var="sumTotalSaleAmt" value="${sumTotalSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
                            <c:set var="sumDcAmt" value="${sumDcAmt + orderGoodsVo.dcAmt}"/>
                            <c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc}"/>
                            <c:set var="sumPayAmt" value="${sumPayAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt) + orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc - orderGoodsVo.dcAmt - orderGoodsVo.goodsDmoneyUseAmt}"/>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td></td>
                            <td class="txtc fwb">소계</td>
                            <td class="txtc fwb"><c:out value="${sumQty}"/></td>
                            <td class="txtc fwb"><fmt:formatNumber value='${sumSaleAmt}' type='number'/></td>
                            <td class="txtc fwb"><fmt:formatNumber value='${sumDcAmt}' type='number'/></td>
                            <td class="txtc fwb"><fmt:formatNumber value='${sumDlvrAmt}' type='number'/></td>
                            <td class="txtc total"><fmt:formatNumber value='${sumPayAmt}' type='number'/></td>
                            <td></td>
                         </tr>
                    </tfoot>
                    </table>
                    <div class="all_sum">
                        <ul>
                            <li class="gray_box">
                                <strong>판매가</strong>
                                <br>
                                <span><fmt:formatNumber value='${sumTotalSaleAmt}' type='number'/>원</span>
                            </li>
                            <li class="wid5"><img src="/admin/img/order/icon_pay_plus.png" alt="플러스" /></li>
                            <li class="gray_box">
                                <strong>배송비</strong>
                                <br>
                                <span><fmt:formatNumber value='${sumDlvrAmt}' type='number'/>원</span>
                            </li>
                            <li class="wid5"><img src="/admin/img/order/icon_pay_minus.png" alt="마이너스" /></li>
                            <li class="gray_box">
                                <strong>쿠폰</strong>
                                <br>
                                <span><fmt:formatNumber value='${sumDcAmt}' type='number'/>원</span>
                                <c:if test="${fn:length(ordAddedAmountList) > 0}">
                                    <b><img src="/admin/img/order/sum_detail.gif" alt="상세" /></b>
                                    <div class="sum_area th">
                                        <ul>
                                            <c:forEach var="addedVo" items="${ordAddedAmountList}" varStatus="status">
                                                <li>${addedVo.addedAmountGbNm} <span><fmt:formatNumber value='${addedVo.addedAmountAmt}' type='number'/>원</span></li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>
                            </li>
                            <li class="wid5"><img src="/admin/img/order/icon_pay_minus.png" alt="마이너스" /></li>
                            <li class="gray_box">
                                <strong>포인트</strong>
                                <br>
                                <c:set var="svmnAmt" value="0"/>
                                <c:forEach var="pVO" items="${payVo}" varStatus="status">
                                    <c:if test="${pVO.paymentWayCd eq '01'}" >
                                        <c:set var="svmnAmt" value="${svmnAmt + pVO.paymentAmt}"/>
                                    </c:if>
                                </c:forEach>
                                <%--<c:set var="sumPayAmt" value="${sumPayAmt -svmnAmt}"/>--%>
                                <span><fmt:formatNumber value='${svmnAmt}' type='number'/>원</span>
                            </li>
                            <%--<li class="wid5"><img src="/admin/img/order/icon_pay_minus.png" alt="마이너스" /></li>
                            <li class="gray_box">
                                <strong>쿠폰</strong>
                                <br>
                                <span>0원</span>
                            </li>--%>
                            <li class="wid5"><img src="/admin/img/order/icon_pay_total.png" alt="합" /></li>
                            <li class="wid20">
                                <strong>총 결제금액</strong>
                                <br>
                                <span><fmt:formatNumber value='${sumPayAmt}' type='number'/></span>원
                            </li>
                        </ul>
<%--                        <div class="coupon-area">--%>
<%--                            <c:if test="${fn:length(cpList) > 0}">--%>
<%--                            적용할인쿠폰 :--%>
<%--                            <c:forEach var="cpList" items="${cpList}" varStatus="status">--%>
<%--                                <a href="javascript:openCouponDtl('${cpList.couponNo}');">${cpList.couponNm}</a>--%>
<%--                            </c:forEach>--%>
<%--                            </c:if>--%>
<%--                        </div>--%>
                    </div>
                </div>
                <c:if test="${rsltInfoVo.buyGlassLensYn eq 'Y'}">
                <!-- 안경렌즈구매여부 -->
                <h3 class="tlth3">안경렌즈 구매 요청</h3>
                <div class="tblw tblmany">
                    <table>
                        <colgroup>
                            <col width="150px">
                            <col width="">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>상태</th>
                            <td>
                                요청완료
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                </c:if>
                <form:form id="form_ord_dtl">
                    <input type="hidden" name="ordNo" value='${rsltInfoVo.ordNo}'/>
                    <input type="hidden" name="ordDtlSeq" value=''/>
                    <input type="hidden" name="ordStatusCd" id="ordStatusCd" />
                    <input type="hidden" name="curOrdStatusCd" id="curOrdStatusCd"  value='${rsltInfoVo.ordStatusCd}'/>
                    <input type="hidden" name="mdConfirmYn" id="mdConfirmYn" value='N'/>
                    <input type="hidden" name="memberGbCd" id="memberGbCd" value="10"/>
                    <h3 class="tlth3">주문자 정보</h3>
                    <div class="tblw tblmany ">
                        <table summary="이표는 주문자 정보 표 입니다. 구성은  입니다.">
                            <caption>주문자 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>아이디</th>
                                    <td><c:out value="${rsltInfoVo.loginId}"/> </td>
                                </tr>
                                <tr>
                                    <th>이름</th>
                                    <td class="txtl"><c:out value="${rsltInfoVo.ordrNm}"/> <c:if test="${rsltInfoVo.memberOrdYn eq Y}">(<c:out value="${rsltInfoVo.loginId}"/>/<c:out value="${rsltInfoVo.ordrNm}"/>)</c:if></td>
                                </tr>
                                <tr>
                                    <th>휴대폰</th>
                                    <td><c:out value="${rsltInfoVo.ordrMobile}"/></td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td><c:out value="${rsltInfoVo.ordrEmail}"/></td>
                                </tr>
                                <tr>
                                    <th>결제방법</th>
                                    <td><c:out value="${rsltInfoVo.paymentWayNm}"/></td>
                                </tr>
                                <tr>
                                    <th>결제일시</th>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${rsltInfoVo.paymentCmpltDttm}" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${rsltInfoVo.storeNm eq null}">
                    <h3 class="tlth3" >배송지 정보
                        <c:if test="${rsltInfoVo.ordStatusCd eq '20' or rsltInfoVo.ordStatusCd eq '30'}">
                        <div class="right wid_at">
                            <button class="btn_blue" id="btn_addr">변경저장</button>
                        </div>
                        </c:if>
                    </h3>
                    <div class="tblw tblmany " >
                        <table summary="이표는 배송지 정보 표 입니다. 구성은  입니다.">
                            <caption>배송지 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>이름</th>
                                <td>
                                    <c:out value="${rsltInfoVo.adrsNm}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>주소</th>
                                <td>
                                    <span class="intxt w50p">
                                        <input <c:if test="${rsltInfoVo.ordStatusCd ne '20' and rsltInfoVo.ordStatusCd ne '30'}">readOnly</c:if> type="text" id="roadnmAddr" name="roadnmAddr" value="${rsltInfoVo.roadnmAddr}"/>
                                    </span>
                                    <span class="intxt shot1"><input <c:if test="${rsltInfoVo.ordStatusCd ne '20' and rsltInfoVo.ordStatusCd ne '30'}">readOnly</c:if> type="text" value='<c:out value="${rsltInfoVo.postNo}"/>' id="postNo" name="postNo"></span>
                                    <c:if test="${rsltInfoVo.ordStatusCd eq '20' or rsltInfoVo.ordStatusCd eq '30'}">
                                        <a href="javascript:;" class="btn_gray" id="btn_post">우편번호</a>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>상세주소</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input <c:if test="${rsltInfoVo.ordStatusCd ne '20' and rsltInfoVo.ordStatusCd ne '30'}">readOnly</c:if> type="text" id="dtlAddr" name="dtlAddr" value="${rsltInfoVo.dtlAddr}"/>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>휴대폰</th>
                                <td>
                                    <c:out value="${rsltInfoVo.adrsMobile}"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    </c:if>
                    <c:if test="${rsltInfoVo.storeNm ne null}">
                    <h3 class="tlth3">픽업 스토어 정보</h3>
                    <div class="tblw tblmany ">
                        <table summary="이 표는 픽업 스토어 정보 표 입니다. 구성은 스토어명, 방문일자, 시간 입니다.">
                            <caption>픽업 스토어 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>스토어명</th>
                                    <td><c:out value="${rsltInfoVo.storeNm}"/> </td>
                                </tr>
                                <tr>
                                    <th>방문일자</th>
                                    <td><c:out value="${fn:substring(rsltInfoVo.strVisitDate,0,15)}"/> </td>
                                </tr>
                                <tr>
                                    <th>시간</th>
                                    <td><c:out value="${fn:substring(rsltInfoVo.strVisitDate,15,22)}"/> </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </c:if>
                    <c:if test="${rsltInfoVo.storeNm ne null and rsltInfoVo.ordStatusCd eq '90'}">
                    <h3 class="tlth3">픽업 완료</h3>
                    <div class="tblw tblmany ">
                        <table summary="이 표는 픽업 완료 정보 표 입니다. 구성은 스토어명, 방문일자, 시간 입니다.">
                            <caption>픽업 완료 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>스토어명</th>
                                    <td><c:out value="${rsltInfoVo.storeNm}"/> </td>
                                </tr>
                                <tr>
                                    <th>픽업일자</th>
                                    <td><c:out value="${fn:substring(rsltInfoVo.ordUpdateDate,0,10)}"/> </td>
                                </tr>
                                <tr>
                                    <th>시간</th>
                                    <td><c:out value="${fn:substring(rsltInfoVo.ordUpdateDate,11,16)}"/> </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </c:if>
                    <h3 class="tlth3">결제 정보</h3>
                    <div class="tblw tblmany ">
                        <table summary="이표는 결제 정보 표 입니다. 구성은  입니다.">
                            <caption>결제 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <c:forEach var="pVO" items="${payVo}" varStatus="status">
                                    <tr>
                                        <th>결제수단</th>
                                        <td><c:out value="${pVO.paymentWayNm}" /></td>
                                    </tr>
                                <c:if test="${pVO.paymentWayCd eq '23'}" >
                                    <tr>
                                        <th>결제금액</th>
                                        <td><fmt:formatNumber value='${pVO.paymentAmt}' type='number'/></td>
                                    </tr>
                                    <tr>
                                        <th>카드명</th>
                                        <td><c:out value="${pVO.cardNm}"/></td>
                                    </tr>
                                    <tr>
                                        <th>승인번호</th>
                                        <td><c:out value="${pVO.confirmNo}"/></td>
                                    </tr>
                                    <tr>
                                        <th>할부개월</th>
                                        <td><c:out value="${pVO.instmntMonth}"/></td>
                                    </tr>
                                </c:if>
                                <c:if test="${pVO.paymentWayCd eq '21' or pVO.paymentWayCd eq '11'}" >
                                    <tr>
                                        <th>입금자명</th>
                                        <td><c:out value="${pVO.dpsterNm}"/></td>
                                    </tr>
                                    <tr>
                                        <th>결제금액</th>
                                        <td><fmt:formatNumber value='${pVO.paymentAmt}' type='number'/></td>
                                    </tr>
                                    <tr>
                                        <th>은행명</th>
                                        <td><c:out value="${pVO.bankNm}"/></td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                            <c:forEach var="payFailVo" items="${payFailVo}" varStatus="status">
                                <tr>
                                    <th>실패코드</th>
                                    <td>${payFailVo.errCd}</td>
                                </tr>

                                <c:if test="${payFailVo.resultContent ne null}">
                                    <c:set var="resultContent" value="${payFailVo.resultContent}"/>
                                </c:if>

                                <c:if test="${payFailVo.resultContent eq null}">
                                    <c:set var="resultContent" value=""/>
                                    <c:choose>
                                        <c:when test="${payFailVo.errCd eq '170053'}">
                                            <c:set var="resultContent" value="은행 전산마감 작업중(약 30분 후 결제 요망)"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '160278'}">
                                            <c:set var="resultContent" value="계좌개설 금융기관 문의"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '120054'}">
                                            <c:set var="resultContent" value="잔액부족"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '120016'}">
                                            <c:set var="resultContent" value="월 사용한도 초과"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '120014'}">
                                            <c:set var="resultContent" value="카드번호 오류"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '068906'}">
                                            <c:set var="resultContent" value="PG하위몰 사업자번호 오류"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '068906'}">
                                            <c:set var="resultContent" value="PG하위몰 사업자번호 오류"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '0004'}">
                                            <c:set var="resultContent" value="신규자로 처리불가(재등록시)"/>
                                        </c:when>
                                        <c:when test="${payFailVo.errCd eq '0001'}">
                                            <c:set var="resultContent" value="시스템 장애. 계좌번호, 비밀번호 등을 확인하여 주시기 바랍니다."/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="resultContent" value="상점관리자에서 확인하세요."/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <tr>
                                    <th>내용</th>
                                    <td>${resultContent}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </form:form>

                <h3 class="tlth3">배송정보</h3>
                <div class="tblh tblmany line_no">
                    <table>
                        <colgroup>
                            <col width="">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="12%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>배송상품</th>
                            <th>발송수량</th>
                            <th>배송방법</th>
                            <th>택배사</th>
                            <th>운송장번호</th>
                            <th>배송일(출고일)</th>
                            <th>변경</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="deliveryVo" items="${deliveryVo}" varStatus="status">
                            <form:form id="form_ord_dlv_${status.index}">
                                <input type="hidden" name="dlvrNo" value='${deliveryVo.dlvrNo}'/>
                                <tr>
                                    <td class="txtl">
                                        <div class="item_box">
                                            <a href="javascript:;" class="goods_img"><img src="${deliveryVo.imgPath}" alt="" /></a>
                                            <a href="javascript:;" class="goods_txt">
                                                <span class="tlt">${deliveryVo.goodsNm}</span>
                                                <c:if test="${deliveryVo.itemNm ne ''}">
                                                    <span class="option">
                                                        <span class="ico01">옵션</span>
                                                        <c:out value="${deliveryVo.itemNm}"/>
                                                    </span>
                                                </c:if>
                                                <c:if test="${deliveryVo.addOptNm ne null}">
                                                   <span class="option">
                                                       <span class="ico01">추가옵션</span>
                                                       <c:out value="${deliveryVo.addOptNm}"/>
                                                   </span>
                                                </c:if>
                                            </a>
                                        </div>
                                    </td>
                                    <td><c:out value="${deliveryVo.dlvrQtt}"/></td>
                                    <td><c:out value="${deliveryVo.dlvrcPaymentNm}"/></td>
                                    <c:choose>
                                        <c:when test="${deliveryVo.ordDtlStatusCd < 50}">
                                            <%-- <c:choose>
                                             <c:when test="${deliveryVo.dlvrcPaymentCd eq '04'}">
                                                  <td colspan="2">매장픽업</td>
                                             </c:when>
                                             <c:otherwise>--%>
                                            <td>
                                                    <span class="select">
                                                    <label for="dtl_rlsCourierCd_${status.index}"></label>
                                                    <select name="rlsCourierCd" id="dtl_rlsCourierCd_${status.index}">
                                                        <c:forEach var="courierList" items="${courierVoList}" varStatus="status2">
                                                        <option value='${courierList.rlsCourierCd}' <c:if test='${courierList.rlsCourierCd eq deliveryVo.rlsCourierCd }'> selected</c:if> >${courierList.rlsCourierNm}
                                                        </c:forEach>
                                                    </select>
                                                    </span>
                                            </td>
                                            <td><span class="intxt"><input type="text" id="dtl_rlsInvoiceNo_${status.index}" name="rlsInvoiceNo" value="${deliveryVo.rlsInvoiceNo}" /></span></td>
                                            <%-- </c:otherwise>
                                             </c:choose>--%>
                                        </c:when>
                                        <c:otherwise>
                                            <td><c:out value="${deliveryVo.rlsCourierNm}"/></td>
                                            <td><c:out value="${deliveryVo.rlsInvoiceNo}"/></td>
                                        </c:otherwise>
                                    </c:choose>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${deliveryVo.rlsInvoiceRegDttm}" /></td>
                                        <%--<c:choose>
                                           <c:when test="${deliveryVo.dlvrcPaymentCd eq '04'}">
                                           <td></td>
                                           </c:when>
                                           <c:otherwise>--%>
                                    <td>
                                        <c:if test="${deliveryVo.ordDtlStatusCd < 50}">
                                            <a href="javascript:btn_deliv_chg(${status.index});" class="btn_blue" id="btn_deliv_chg">변경내역저장</a>
                                        </c:if>
                                        <c:if test="${deliveryVo.ordDtlStatusCd eq 40}">
                                            <span class="br2"></span>
                                            <button class="btn_blue" type="button" onclick="javascript:updateDelivDone('${deliveryVo.ordDtlSeq}');">배송완료</button>
                                        </c:if>
                                    </td>
                                        <%--</c:otherwise>
                                     </c:choose>--%>
                                </tr>
                            </form:form>
                        </c:forEach>
                        <c:if test="${fn:length(deliveryVo)==0}">
                            <tr>
                                <td colspan="7">배송 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>


                <h3 class="tlth3">결제취소 / 교환 / 환불 내역</h3>
                <div class="tblh tblmany line_no">
                    <table summary="이표는 결제취소 / 교환 / 환불 내역 리스트 표 입니다. 구성은  입니다.">
                        <caption>결제취소 / 교환 / 환불 내역 리스트</caption>
                        <colgroup>
                            <col width="35%">
                            <col width="15%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>상품</th>
                            <th>결제취소 / 교환 / 환불</th>
                            <th>수량</th>
                            <th>금액</th>
                            <th>반품상태</th>
                            <th>환불상태</th>
                            <th>접수일</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ordClaimList" items="${ordClaimList}" varStatus="status">
                            <tr>
                                <td class="txtl"><c:out value="${ordClaimList.goodsNm}"/></td>
                                <td><c:out value="${ordClaimList.claimTypeNm}"/></td>
                                <td><fmt:formatNumber value='${ordClaimList.ordQtt}' type='number'/></td>
                                <td><fmt:formatNumber value='${(ordClaimList.ordQtt * ordClaimList.saleAmt) + ordClaimList.dlvrAmt + ordClaimList.dlvrAddAmt - ordClaimList.dcAmt - ordClaimList.goodsDmoneyUseAmt}' type='number'/></td>
                                <td><c:out value="${ordClaimList.returnNm}"/></td>
                                <td><c:out value="${ordClaimList.claimNm}"/></td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${ordClaimList.claimAcceptDttm}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${fn:length(ordClaimList)==0}">
                            <tr>
                                <td colspan="7">취소 / 교환 / 환불 내역이 없습니다.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <h3 class="tlth3">상담메모
                    <div class="right wid_at">
                        <a href="javascript:;" class="btn_gray2 change_btn" id="btn_memo_save">저장</a>
                    </div>
                </h3>
                <div class="txt_area tblmany">
<%--                    <textarea name="memoContent" id="memoContent"><c:out value="${rsltInfoVo.memoContent}"/></textarea>--%>
                    <div>
                    <form:form id="form_ord_memo">
                        <input type="hidden" name="ordNo" value='${rsltInfoVo.ordNo}'/>

                        <div class="txt_area">
                            <textarea name="memoContent" id="memoContent"><c:out value="${rsltInfoVo.memoContent}"/></textarea>
                        </div>
                     </form:form>
                    </div>
                </div>

                <h3 class="tlth3">처리로그</h3>
                <div class="disposal_log tblmany">
                    <ul>
                    <c:forEach var="list" items="${ordHistVOList}" varStatus="status">
                        <li><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${list.regDttm}" /> [주문 상세번호:<c:out value="${list.ordDtlSeq}"/>] [<c:out value="${list.ordStatusCd}"/>] <c:out value="${list.ordStatusNm}"/></li>
                    </c:forEach>
                    </ul>
                </div>
            </div>
            <!-- //line_box -->
            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_ordlist">목록</button>
                    </div>
                </div>
                <%--<div class="right">
                    <button class="btn--blue-round">저장</button>
                </div>--%>
            </div>
        </div>


        <%@ include file="/WEB-INF/views/admin/member/manage/SmsLayerPop.jsp" %>
        <%@ include file="/WEB-INF/views/admin/member/manage/EmailLayerPop.jsp" %>
    </t:putAttribute>
</t:insertDefinition>
<div id="layout_delivery" class="layer_popup">
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">배송처리 [<c:out value="${rsltInfoVo.ordNo}"/>]</h2>
            <button class="close ico_comm" onclick="javascript:dtlReload();">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 배송처리 리스트 표 입니다. 구성은 받으시는 분, 우편번호, 주소, 이메일, 연락처 입니다.">
                        <caption>배송처리 리스트</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="15%">
                            <col width="50%">
                            <col width="20%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>받으시는 분</th>
                                <th>우편번호</th>
                                <th>주소</th>
                                <th>연락처</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><c:out value="${rsltInfoVo.adrsNm}"/></td>
                                <td><c:out value="${rsltInfoVo.postNo}"/></td>
                                <td class="txtl">
                                    (도로명) <c:out value="${rsltInfoVo.roadnmAddr}"/><br>
                                    (지번) <c:out value="${rsltInfoVo.numAddr}"/><br>
                                    (상세주소) <c:out value="${rsltInfoVo.dtlAddr}"/>
                                </td>
                                <td>
                                    <c:out value="${rsltInfoVo.adrsTel}"/><br>
                                    <c:out value="${rsltInfoVo.adrsMobile}"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- tblh -->
                <div class="tblh mt0 line_no">
                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 제고/가용, 주문수량, 취소수량, 배송처리수량, 배송방법 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="2%">
                            <col width="8%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">
                            <col width="8%">
                            <col width="9%">
                            <col width="8%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>주문상품</th>
                                <th>제고/가용</th>
                                <th>주문<br>수량</th>
                                <th>취소<br>수량</th>
                                <th>배송처리<br>수량</th>
                                <th>배송비</th>
                                <th>택배사</th>
                                <th>송장번호</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_div_data">
                            <tr id="tr_div_data_template" >
                                <td class="txtl">
                                    <input type="hidden"   name="div_dlvrNo" id="div_dlvrNo" data-bind="divInfo" data-bind-type="Text" data-bind-value="dlvrNo">
                                    <input type="hidden"   name="rownum" id="rownum" data-bind="divInfo" data-bind-type="Text" data-bind-value="rownum">
                                    <input type="hidden"   name="div_ordDtlSeq" id="div_ordDtlSeq" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordDtlSeq">
                                    <input type="hidden"   name="div_goodsNo" id="div_goodsNo" data-bind="divInfo" data-bind-type="Text" data-bind-value="goodsNo">
                                    <input type="hidden"   name="div_ordQtt" id="div_ordQtt" data-bind="divInfo" data-bind-type="Text" data-bind-value="ordQtt">
                                    
                                    <div class="item_box">
                                        <a href="javascript:;" class="goods_img"><img src="" alt="" data-bind="divInfo" data-bind-type="img" data-bind-value="imgPath" onerror="this.src='/admin/img/design/noImage.jpg'"/></a>
                                        <a href="javascript:;" class="goods_txt" style="width: 180px;">
                                            <span class="tlt" data-bind="divInfo" data-bind-type="String" data-bind-value="goodsNm">
                                            <input type="hidden" width="100%" readOnly name="goodsNm" id="goodsNm" data-bind="divInfo" data-bind-type="Text" data-bind-value="goodsNm">
                                            </span>
                                            <span class="option">
                                                <%--<span class="ico01">옵션</span>--%>
                                                <span data-bind="divInfo" data-bind-type="String" data-bind-value="itemNm"></span>
                                                <input type="hidden" width="100%" readOnly name="itemNm" id="itemNm" data-bind="divInfo" data-bind-type="Text" data-bind-value="itemNm">
                                            </span>
                                            <span class="code">
                                            [상품코드 :
                                            <span data-bind="divInfo" data-bind-type="String" data-bind-value="goodsNo"></span>
                                            <input type="hidden" width="100%" readOnly name="goodsNo" id="goodsNo" data-bind="divInfo" data-bind-type="Text" data-bind-value="goodsNo">]
                                            </span>
                                        </a>
                                    </div>
                                </td>
                                <td>
                                    <span data-bind="divInfo" data-bind-type="String" data-bind-value="stockQtt"></span>/
                                    <span data-bind="divInfo" data-bind-type="String" data-bind-value="availStockQtt"></span>
                                    <input type="hidden" name="stockQtt" id="stockQtt01" data-bind="divInfo" data-bind-type="Text" data-bind-value="stockQtt">
                                    <input type="hidden" name="stockQtt" id="stockQtt02" data-bind="divInfo" data-bind-type="Text" data-bind-value="availStockQtt">
                                </td>
                                <td data-bind="divInfo" data-bind-value="ordQtt" data-bind-type="number" >1</td>
                                <td data-bind="divInfo" data-bind-value="canQtt" data-bind-type="number" >0</td>
                                <td data-bind="divInfo" data-bind-value="dlvrQtt" data-bind-type="number" >0</td>
                                <td data-bind="divInfo" data-bind-value="dlvrcPaymentNm" data-bind-type="string" ></td>
                                <td>
                                    <span class="select" id="span_courierCd_template">
                                        <label for="div_rlsCourierCd"></label>
                                        <select name="div_rlsCourierCd" id="div_rlsCourierCd" data-bind="divInfo" data-bind-value="rlsCourierCd" data-bind-type="labelselect">
                                        </select>
                                    </span>
                                    <input type="hidden" name="div_dlvrcPaymentCd" id="div_dlvrcPaymentCd" data-bind="divInfo" data-bind-value="dlvrcPaymentCd" data-bind-type="Text" >
                                    <span id="div_dlvrcPaymentNm" style="display:none">
                                        매장픽업
                                    </span>
                                </td>
                                <td>
                                    <span class="intxt shot2" id="span_div_rlsInvoiceNo">
                                        <input id="div_rlsInvoiceNo" name="div_rlsInvoiceNo" data-bind="divInfo" data-bind-value="rlsInvoiceNo" data-bind-type="text" style="width:100px;">
                                    </span>
                                    <span class="br" id="span_div_rlsInvoiceNo2" ></span>
                                    <button id="btn_div_rlsInvoiceNo2" class="btn_gray" data-bind="divInfo" data-bind-value="rownum" data-bind-type="function" data-bind-function="updateDelivery">배송처리</button>
                                </td>
                            </tr>
                            <tr id="tr_no_div_data"><td colspan="8">데이터가 없습니다.</td></tr>
                        </tbody>
                        
                    </table>
                </div>
                <!-- //tblh -->
            </div>
        </div>
       <!-- //pop_con -->
    </div>
</div>

<c:set var="claimOrdStatusCdPop" value="${rsltInfoVo.fClaimOrdStatusCd}"/>
<!-- 환불 팝업 -->
<c:if test="${rsltInfoVo.orgOrdNo eq null and (rsltInfoVo.ordStatusCd eq '39' or rsltInfoVo.ordStatusCd eq '40' or rsltInfoVo.ordStatusCd eq '49' or rsltInfoVo.ordStatusCd eq '50' or fn:contains(claimOrdStatusCdPop, '50'))}">
<c:set var="refundType" value="M"/>
<%@ include file="/WEB-INF/include/popup/ordRefundPopup.jsp" %>
</c:if>
<!-- 교환 팝업 -->
<c:if test="${rsltInfoVo.ordStatusCd eq '39' or rsltInfoVo.ordStatusCd eq '40' or rsltInfoVo.ordStatusCd eq '49' or rsltInfoVo.ordStatusCd eq '50' or fn:contains(claimOrdStatusCdPop, '50')}">
<c:set var="exchangeType" value="M"/>
<%@ include file="/WEB-INF/include/popup/ordExchangePopup.jsp" %>
</c:if>
<!-- 결제 취소 팝업 -->
<c:if test="${rsltInfoVo.ordStatusCd eq '20' or rsltInfoVo.ordStatusCd eq '23' or fn:contains(fClaimOrdStatusCd, '20')}">
<c:set var="refundType" value="M"/>
<%@ include file="/WEB-INF/include/popup/ordPayCancelPopup.jsp" %>
</c:if>

<!-- layer_popup_option -->
<div id="layout_option" class="layer_popup">
    <div class="pop_wrap size3">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">옵션변경</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <div class="tblh mt0">
                    <table summary="이표는 옵션변경 표 입니다. 구성은 현재 선택된 옵션, 변경 옵션 입니다.">
                        <caption>옵션변경</caption>
                        <colgroup>
                            <col width="50%">
                            <col width="50%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>현재 선택된 옵션</th>
                                <th>변경 옵션</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="txtl" id='optionOldList'>
                                </td>
                                <td class="txtl" id='optionList'>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <div class="btn_box txtc">
                    <button class="btn green" id="btn_option_change">확인</button>
                </div>
            </div>
        </div>
    </div>
        <!-- //pop_con -->
</div>
<!-- //layer_popup_option -->