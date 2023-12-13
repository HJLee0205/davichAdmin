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
    <t:putAttribute name="title">주문설정</t:putAttribute>
    <t:putAttribute name="script">
      <script type="text/javascript">
         jQuery(document).ready(function() {
             fn_setDefault();
             
             jQuery('#btn_save').off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 fn_save();
             });
             
             jQuery('label.radio', '#td_availStockSaleYn').off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 
                 var $this = $(this),
                     $input = jQuery("#" + $this.attr("for"));
                 
                 $("input:radio[name=" + $input.attr("name") + "]").each(function() {
                     $(this).removeProp('checked');
                     $("label[for=" + $(this).attr("id") + "]").removeClass('on');
                 });
                 $input.prop('checked', true).trigger('change');
                 
                 if ($input.prop('checked')) {
                     $this.addClass('on');
                     // 라디오 선택 값에 따른 이벤트 설정
                     if ('Y' == $input.val()) {
                         $('#tr_availStockQtt').show();
                     } else {
                         $('#tr_availStockQtt').hide();
                     }
                 }
             });
             
             Dmall.validate.set('form_order_config');
             
             Dmall.common.comma();
             Dmall.common.numeric();
         });
        
         function fn_setDefault() {
             $('input:text, textarea').val('');
             
             jQuery("input[name=goodsAutoDelUseYn]:radio").on('change', function(e) {
                 var $obj = $("#txt_goodsKeepDcnt"); 
                 if ($("#rdo_goodsAutoDelUseYn_Y").is(":checked")) {                    
                     $obj.prop("disabled",false).val($obj.data("value")).focus();
                 } else {                    
                     $obj.prop("disabled",true).val('');
                 }
             });
             
             jQuery("input[name=goodsKeepQttLimitYn]:radio").on('change', function(e) {
                 var $obj = $("#txt_goodsKeepQtt"); 
                 if ($("#rdo_goodsKeepQttLimitYn_Y").is(":checked")) {
                     $obj.prop("disabled",false).val($obj.data("value")).focus();
                 } else {
                     $obj.prop("disabled",true).val('');
                 }
             });
             
             fn_get_Info();
         }
        
         function setDefaultRadioValue() {
             $('input:radio', '#form_order_config').each(function(){
                 var name =$(this).attr('name') 
                 , $radios = $('input:radio[name='+ name +']')
                 , $radio = $radios.filter(':visible:first');
                 
                 if ($('input:radio[name='+ name +']:checked').length < 1) {
                     $('label[for='+ $radio.attr('id') +']').trigger('click');
                 }
             });
         };
        
         function fn_set_result(data) {
             if (!'goodsKeepDcnt' in data || !data['goodsKeepDcnt'] ) {
                 // data['goodsKeepDcnt'] = 10;
             }
             if (!'goodsKeepQtt' in data || !data['goodsKeepQtt'] ) {
                 // data['goodsKeepQtt'] = 50;
             }
             
             $('[data-find="order_config"]').DataBinder(data);
             
             setDefaultRadioValue();
         }
         
         function fn_get_Info() {
             var url = '/admin/setup/config/order/order-config-info',
             param = '',
             dfd = jQuery.Deferred();
             
             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 fn_set_result(result.data);
                 
                 dfd.resolve(result.resultList);
                 
             });
             return dfd.promise();
         }
         
         function fn_save() {
             var $goodsKeepCnt = $("#txt_goodsKeepDcnt"), 
                 $goodsKeepQtt = $("#txt_goodsKeepQtt");
             if ($("#rdo_goodsAutoDelUseYn_Y").is(":checked") 
                     && ($goodsKeepCnt.val().trim().length < 1 ) ) {
                 $goodsKeepCnt.focus();
                 Dmall.LayerUtil.alert("상품 보관 기간을 입력해 주십시요.");
                 return false;
             }
             
             if ($("#rdo_goodsKeepQttLimitYn_Y").is(":checked") 
                     && ($goodsKeepQtt.val().trim().length < 1 ) ) {
                 $goodsKeepQtt.focus();
                 Dmall.LayerUtil.alert("상품 보관 개수를 입력해 주십시요.");
                 return false;
             }
             
             if ($("#rdo_stockSetYn_Y").is(":checked") && $("#rdo_availStockSaleYn_Y").is(":checked")) {
                 var $availStockQtt = $('#txt_availStockQtt');
                 if ( !$availStockQtt.val() || $availStockQtt.val().length < 1) {
                     $availStockQtt .focus();
                     Dmall.LayerUtil.alert("가용 재고 개수를 입력해 주십시요.");
                     return false;
                 } else {
                     $('#hd_availStockQtt').val($availStockQtt.val().trim().replaceAll(',', ''));
                 } 
             } else{
                 $('#hd_availStockQtt').val('');
             }
             
             if(Dmall.validate.isValid('form_order_config')) {
                 var url = '/admin/setup/config/order/order-config-update',
                 param = jQuery('#form_order_config').serialize();
                 
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     Dmall.validate.viewExceptionMessage(result, 'form_order_config');
                     
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         fn_get_Info();
                     }
                 });
             }                
             return false;
         }
         
         function setParamData(idx, $tbody, param) {
             var data = $(".certify_info_"+idx, $tbody).UserInputBinderGet();
             for (var prop in data) {
                 var key = 'list[' + idx + '].'+ prop;
                 param[key] = data[prop];
             }
         }
         
         function setAvailStockSaleYn(data, obj, bindName, target, area, row) {
             var bindValue = obj.data("bind-value")
                 , value = data[bindValue];
             // 기존 선택 값 리셋
             var $radio = $('input:radio[name='+ bindValue +']').prop('checked', false);
             $radio.each(function (){
                $('label[for=' + $(this).attr('id') + ']', $radio.parent()).removeClass('on'); 
             });
             // 값 설정
             $('input:radio[name='+ bindValue +'][value=' + value + ']').trigger('click');
         }
      </script>
   </t:putAttribute>
    
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">주문 설정</h2>
            <!-- <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
            </div> -->
        </div>
        
        <form:form id="form_order_config">
<!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">장바구니 상품보관 설정</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 장바구니 상품보관 설정 표 입니다. 구성은 상품 보관 기간 설정, 품절 상품 보관 설정, 상품 보관 개수 입니다.">
                    <caption>장바구니 상품보관 설정</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>상품 보관 기간 설정</th>
                            <td id="td_goodsAutoDelUseYn" data-find="order_config" data-bind-value="goodsAutoDelUseYn" data-bind-type="labelcheckbox">
                                <label for="rdo_goodsAutoDelUseYn_N" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="goodsAutoDelUseYn" value="N" id="rdo_goodsAutoDelUseYn_N">
                                </span> 고객이 삭제 시 까지 보관</label>
                                <label for="rdo_goodsAutoDelUseYn_Y" class="radio"><span class="ico_comm">
                                    <input type="radio" name="goodsAutoDelUseYn" value="Y" id="rdo_goodsAutoDelUseYn_Y">
                                </span></label>
                                <span><span class="intxt shot">
                                    <input type="text" class="numeric" name="goodsKeepDcnt" id="txt_goodsKeepDcnt" data-find="order_config" data-bind-type="text" data-bind-value="goodsKeepDcnt" maxlength="2" data-validation-engine="validate[maxSize[2], onlyNum, max[20]]" >
                                </span> 일까지 보관 후 자동 삭제</span>
                            </td>
                        </tr>
                        <tr>
                            <th>품절 상품 보관 설정</th>
                            <td id="td_soldoutGoodsAutoDelYn" data-find="order_config" data-bind-value="soldoutGoodsAutoDelYn" data-bind-type="labelcheckbox">
                                <label for="rdo_soldoutGoodsAutoDelYn_N" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="soldoutGoodsAutoDelYn" value="N" id="rdo_soldoutGoodsAutoDelYn_N">
                                </span> 품절 시 보관</label>
                                <label for="rdo_soldoutGoodsAutoDelYn_Y" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="soldoutGoodsAutoDelYn" value="Y" id="rdo_soldoutGoodsAutoDelYn_Y">
                                </span> 품절 시 자동 삭제</label>
                            </td>
                        </tr>
                        <tr>
                            <th>상품 보관 개수</th>
                            <td id="td_goodsKeepQttLimitYn" data-find="order_config" data-bind-value="goodsKeepQttLimitYn" data-bind-type="labelcheckbox">
                                <label for="rdo_goodsKeepQttLimitYn_Y" class="radio"><span class="ico_comm">
                                    <input type="radio" name="goodsKeepQttLimitYn" value="Y" id="rdo_goodsKeepQttLimitYn_Y">
                                </span></label>
                                <span class="mr20">설정 [최대 <span class="intxt shot">
                                    <input type="text" class="numeric" name="goodsKeepQtt" id="txt_goodsKeepQtt" data-find="order_config" data-bind-type="text" data-bind-value="goodsKeepQtt" maxlength="3" data-validation-engine="validate[maxSize[3], onlyNum, max[100]]" >
                                </span> 개]</span>
                                <label for="rdo_goodsKeepQttLimitYn_N" class="radio"><span class="ico_comm">
                                    <input type="radio" name="goodsKeepQttLimitYn" value="N" id="rdo_goodsKeepQttLimitYn_N">
                                </span> 설정안함</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <h3 class="tlth3">장바구니 페이지 이동 설정</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 장바구니 페이지 이동 설정 표 입니다. 구성은 장바구니 담기 후 페이지 이동 여부 설정 입니다.">
                    <caption>장바구니 페이지 이동 설정</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>장바구니 담기 후<br> 페이지 이동 여부 설정</th>
                            <td id="td_basketPageMovYn" data-find="order_config" data-bind-value="basketPageMovYn" data-bind-type="labelcheckbox">
                                <label for="rdo_basketPageMovYn_N" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="basketPageMovYn" value="N" id="rdo_basketPageMovYn_N">
                                </span> 장바구니 페이지로 바로 이동(사용안함)</label>
                                <label for="rdo_basketPageMovYn_Y" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="basketPageMovYn" value="Y" id="rdo_basketPageMovYn_Y">
                                </span> 장바구니 페이지 이동 여부 선택(사용)</label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <h3 class="tlth3">재고설정</h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 재고설정 표 입니다. 구성은 설정여부, 재고에 따른 상품 판매 가능 여부, 재고 개수 설정 입니다.">
                    <caption>재고설정</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>설정여부</th>
                            <td id="td_stockSetYn" data-find="order_config" data-bind-value="stockSetYn" data-bind-type="labelcheckbox">
                                <label for="rdo_stockSetYn_Y" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="stockSetYn" value="Y" id="rdo_stockSetYn_Y">
                                </span> 설정</label>
                                <label for="rdo_stockSetYn_N" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="stockSetYn" value="N" id="rdo_stockSetYn_N">
                                </span> 설정안함</label>
                            </td>
                        </tr>
                        <tr>
                            <th>재고에 따른 상품<br> 판매 가능 여부</th>
                            <td id="td_availStockSaleYn" data-find="order_config" data-bind-value="availStockSaleYn" data-bind-type="function" data-bind-function="setAvailStockSaleYn">
                                <label for="rdo_availStockSaleYn_Y" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="availStockSaleYn" value="Y" id="rdo_availStockSaleYn_Y">
                                </span> 가용재고 있는 경우 판매</label>
                                <label for="rdo_availStockSaleYn_N" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="availStockSaleYn" value="N" id="rdo_availStockSaleYn_N">
                                </span> 실물 재고가 있는 경우만 판매</label>
                            </td>
                        </tr>
                        <tr id="tr_availStockQtt">
                            <th>재고 개수 설정</th>
                            <td><span class="intxt">
                                <input type="text" name="availStockQtt_" id="txt_availStockQtt" class="comma" data-find="order_config" data-bind-value="availStockQtt" data-bind-type="textcomma" maxlength="5" data-validation-engine="validate[maxSize[6]]">
                                <input type="hidden" id="hd_availStockQtt" name="availStockQtt" />
                            </span> 개</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
        </div>
        <!-- //line_box -->

        </form:form>

		<div class="btn_box txtc">
                <a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
            </div>
    </div>

        
    </t:putAttribute>
</t:insertDefinition>