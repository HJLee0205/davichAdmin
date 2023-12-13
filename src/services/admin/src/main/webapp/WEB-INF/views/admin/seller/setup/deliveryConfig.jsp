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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">배송설정</t:putAttribute>
    <t:putAttribute name="script">
        <script>
        jQuery(document).ready(function() {
            
            fn_setDefault();
            
            fn_getInfo();
            
            // 지역 배송 정보 취득
            fn_getSearchDeliveryList();
            
            // HS코드 정보 취득
            //fn_getSearchHscdList();
            
            jQuery('#btn_save').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_save();
            });
            jQuery('#btn_apply_default').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_apply_default();
            });
            
            jQuery('#btn_delete').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_delete();
            });
            jQuery('#btn_all_delete').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_all_delete();
            });
            jQuery('#btn_add_area').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                Dmall.LayerPopupUtil.zipcode(registZipData);
            });
            jQuery('#btn_add_hscd').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                $('[data-bind=hscd]', $('#form_add_hscd')).val('');
                Dmall.LayerPopupUtil.open(jQuery('#layer_add_hscd'));
            });
            jQuery('#btn_search_hscd').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                $("#tbody_search_hscd").find(".searchResult").each(function() {
                    $(this).remove();
                });
                $("#tbody_search_hscd").append('<tr id="tr_no_hscd_data" class="searchResult"><td colspan="3">데이터가 없습니다.</td></tr>');               
                Dmall.LayerPopupUtil.open(jQuery('#layer_search_hscd'));
            });
            jQuery('#btn_regist_hscd').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_add_hscd();
            });
            jQuery('#btn_pop_search_hscd').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_getPopSearchHscdList();
            });
            
            
            Dmall.validate.set('form_delivery_config');
            Dmall.validate.set('form_add_hscd');
            
            Dmall.common.comma();
        });
        
        function fn_setDefault() {
            jQuery("#tr_delivery_area_template").hide();
            jQuery('label.chack').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                
                
                var $this = jQuery(this),
                    $input = jQuery("#" + $this.attr("for")),
                    checked = !($input.prop('checked'));
                $input.prop('checked', checked);
                $this.toggleClass('on');
                
                if('lb_chk_all' === $this.attr('id')) {
                    $('input:checkbox[name=chack_f1]', '#tbody_delivery_area').each(function() {
                        var $chkinput = $(this)
                          , $chk = $chkinput.parent().find('label');
                          
                        if (checked) {
                            $chk.addClass('on');
                            $chkinput.prop('checked', true);
                        } else {
                            $chk.removeClass('on');
                            $chkinput.prop('checked', false);
                        }
                    });
                } 
            });  
            
            jQuery('label.radio').off('click').on('click', function(e) {
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
                }
                fn_set_radio_element();
            });
                    
        }
        
         function fn_set_result(data) {
             $('[data-find="delivery_config"]').DataBinder(data);
         }
         
         function fn_getInfo() {
             var url = '/admin/seller/setup/delivery/delivery-config-info',
             param = ''; 
             
             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 fn_set_result(result.data);
                 
                 fn_set_radio_element(); 
             });
         }

         function setUseYn(data, obj, bindName, target, area, row) {
             var value = obj.data("bind-value")
                 , useYn = data[value]
                 , $label = jQuery(obj)
                 , $input = jQuery("#" + $label.attr("for"));
             
             useYn = (useYn && ('Y' == useYn || '1' == useYn ));

             // 체크박스 값 설정
             if (useYn) {
                 $label.addClass('on');;
                 $input.data("value", "Y").prop('checked', true); 
             } else {
                 $label.removeClass('on');;
                 $input.data("value", "N").prop('checked', false); 
             }             
         }
         
         function fn_set_radio_element() {
             var value = $("input:radio[name=defaultDlvrcTypeCd]:checked").val(),
             $txt1 = $("#txt_defaultDlvrc").prop("disabled",true).val(''),
             $txt2 = $("#txt_defaultDlvrMinDlvrc").prop("disabled",true).val(''),
             $txt3 = $("#txt_defaultDlvrMinAmt").prop("disabled",true).val(''),            
             $chk = $("label[for='chk_freedlvrTypeCd']").off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 return false;
             }),
             $chkinput = $("#chk_freedlvrTypeCd");             
             
             switch (value) {
                 case "2":
                     $txt1.prop("disabled",false).val($txt1.data("commavalue")).focus();
                     $chk .removeClass('on');
                     $chkinput.prop('checked', false);
                     break;
                 case "3":
                     $chk.off('click').on('click', function(e) {
                         Dmall.EventUtil.stopAnchorAction(e);
                         var $this = jQuery(this),
                             $input = jQuery("#" + $this.attr("for")),
                             checked = !($input.prop('checked'));
                         $input.prop('checked', checked);
                         $this.toggleClass('on');
                     });
                     if ('Y' == $chkinput.data("value")) {
                         $chk.addClass('on');
                         $chkinput.prop('checked', true);
                     }
                     $txt2.prop("disabled",false).val($txt2.data("commavalue"));
                     $txt3.prop("disabled",false).val($txt3.data("commavalue")).focus();
                     break;
                 default:
                     $chk .removeClass('on');
                     $chkinput.prop('checked', false);
                     break;
             }
         }
         
         function setDefaultDlvrcTypeCd(data, obj, bindName, target, area, row) {
             var bindValue = obj.data("bind-value")
                 , value = data[bindValue];
             $("input:radio[name=defaultDlvrcTypeCd][value=" + value + "]").trigger('click');
         }
         
         function fn_checkInputParam() {
             var $defaultDlvrc = $("#txt_defaultDlvrc"), 
             $defaultDlvrMinAmt = $("#txt_defaultDlvrMinAmt"),
             $defaultDlvrMinDlvrc = $("#txt_defaultDlvrMinDlvrc");
         
             if ($("#rdo_defaultDlvrcTypeCd_2").is(":checked") 
                     && ($defaultDlvrc.val().trim().length < 1 ) ) {
                 $defaultDlvrc.focus();
                 Dmall.LayerUtil.alert("상품별 배송비를 입력해 주십시요.");
                 return false;
             } else {
                 $('#hd_defaultDlvrc').val( $defaultDlvrc.val().replaceAll(",", "")); 
             }
             
             if ($("#rdo_defaultDlvrcTypeCd_3").is(":checked")) {
                 
                 if ($defaultDlvrMinAmt.val().trim().length < 1 ) { 
                     $defaultDlvrMinAmt.focus();
                     Dmall.LayerUtil.alert("배송비 부과 최소 금액을 입력해 주십시요.");
                     return false;
                 } else {
                     $('#hd_defaultDlvrMinAmt').val( $defaultDlvrMinAmt.val().replaceAll(",", ""));
                 }
                 
                 if ($defaultDlvrMinDlvrc.val().trim().length < 1 ) { 
                     $defaultDlvrMinDlvrc.focus();
                     Dmall.LayerUtil.alert("부과 최소 배송비을 입력해 주십시요.");
                     return false;
                 } else {
                     $('#hd_defaultDlvrMinDlvrc').val( $defaultDlvrMinDlvrc.val().replaceAll(",", ""));
                 }
             }
         }
         
         function fn_save() {

             fn_checkInputParam();

             if(Dmall.validate.isValid('form_delivery_config')) {
                 var url = '/admin/seller/setup/delivery/delivery-config-update',
                 param = jQuery('#form_delivery_config').serialize();
                 
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     Dmall.validate.viewExceptionMessage(result, 'form_order_config');
                     
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         fn_getInfo();
                     }
                 });
             }                
             return false;
         }
         
         // 검색결과 취득
         function fn_getSearchDeliveryList() {
             fn_setDefaultValue();
             
             var url = '/admin/seller/setup/delivery/delivery-area-list',
             param = $('#form_delivery_area').serialize();

             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 $("#tbody_delivery_area").find(".searchResult").each(function() {
                     $(this).remove();
                 });
                 
                 // 취득결과 셋팅
                 jQuery.each(result.resultList, function(idx, obj) {
                     fn_setResultData(obj);
                 });
                 
                 // 결과가 없을 경우 NO DATA 화면 처리
                 if ( $("#tbody_delivery_area").find(".searchResult").length < 1 ) {
                     jQuery('#tr_no_delivery_area_data').show();
                 } else {
                     jQuery('#tr_no_delivery_area_data').hide();                                            
                 }
                 /* 
                     var cnt_search = result["filterdRows"],
                         cnt_search = null == cnt_search ? 0 : cnt_search;
                     $("#cnt_search").html(cnt_search);
                     
                     var cnt_total = result["totalRows"],
                         cnt_total = null == cnt_total ? 0 : cnt_total;
                     $("#cnt_total").html(cnt_total); 
                 */
                 
                 Dmall.GridUtil.appendPaging('form_delivery_area', 'div_id_paging', result, 'paging_id_area_list', fn_getSearchDeliveryList);
             });
         }
         // 검색관련 기본 설정
         function fn_setDefaultValue() {
             $('input:checkbox', '#tb_delivery_area').each(function() {
                 var $chkinput = $(this)
                   , $chk = $chkinput.parent().find('label');
                 
                 $chk.removeClass('on');
                 $chkinput.prop('checked', false);
             });
             
             jQuery('#hd_srod').val(jQuery('#sel_sord').val());
             jQuery('#hd_rows').val(jQuery('#sel_rows').val());
         }
         // 검색결과 화면 바인딩
         function fn_setResultData(data) {
             var $tmpSearchResultTr = $("#tr_delivery_area_template").clone().show().removeAttr("id");
             var trId = "tr_area_" + data.areaDlvrSetNo;
             $($tmpSearchResultTr).attr("id", trId).addClass("searchResult").data("detail", data)
                    .data("postNo", data.postNo).data("dlvrc", data.dlvrc).data("numAddr", data.numAddr).data("roadnmAddr", data.roadnmAddr).data("areaNm", data.areaNm);
             $('[data-bind="delivery_area"]', $tmpSearchResultTr).DataBinder(data);                
             $("#tbody_delivery_area").append($tmpSearchResultTr);
             Dmall.common.comma();
         }
         function registZipData(data) {
             var url = '/admin/seller/setup/delivery/delivery-area-insert',
             param = {
                         postNo : data.zonecode,
                         dlvrc : 0,
                         numAddr : data.jibunAddress,
                         roadnmAddr : data.roadAddress,
                         areaNm : data.address,
                         
                     };             

             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 
                 if (result == null || result.success != true) {
                     return;
                 } else {
                     fn_getSearchDeliveryList();
                 }
             });
               
             return false;
         }
         
         function setRdo(data, obj, bindName, target, area, row) {
             var value = obj.data("bind-value")
             , useYn = data[value]
             , objValue = obj.data("input-value")
             , $label = jQuery(obj.closest('label'))
             , $input = jQuery(obj);
             

             // 라디오 값 설정
             if (useYn && objValue == useYn) {
                 $label.addClass('on');;
                 $input.prop('checked', true); 
             } else {
                 $label.removeClass('on');;
                 $input.prop('checked', false); 
             }
         } 
         
         function setAreaChkBox(data, obj, bindName, target, area, row) {
             var chkId = "chk_" + data["areaDlvrSetNo"]
                 , $input = obj.find('input')
                 , $label = obj.find('label');
             
             $input.removeAttr("id").attr("id", chkId).data("areaDlvrSetNo", data["areaDlvrSetNo"]);
             $label.attr("for", chkId);
 
             jQuery($label).off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 var $this = jQuery(this),
                     checked = !($input.prop('checked'));
                 $input.prop('checked', checked);
                 $this.toggleClass('on');
             });
         }
         
         function setAreaNm(data, obj, bindName, target, area, row) {
             var areaNm =  data["numAddr"] == '' ? data["roadnmAddr"] : data["roadnmAddr"] + '(' + data["numAddr"] + ')';
             obj.html(areaNm);
         }
         
         // 결과 행의 수정 버튼 설정
         function setAreaEdit(data, obj, bindName, target, area, row) {
             obj.data("areaDlvrSetNo", data["areaDlvrSetNo"]);                
             obj.off("click").on('click', function() {
                 executeAreaEdit($(this));
             });
         }
         // 수정 화면으로의 이동 처리 
         function executeAreaEdit(obj) {
             var trID = "tr_area_" + obj.data("areaDlvrSetNo"),              
                 $targetTr = $("#" + trID);
             
             $("#pop_lb_chk_sel,#pop_tr_lb_chk_sel").off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 return false;
             });
             $("#pop_btn_edit").off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 var dlvrc = jQuery('#pop_txt_dlvrc').val();
                 if ( !dlvrc || dlvrc.trim().length < 1 ) {
                     Dmall.LayerUtil.alert("배송비를 설정해 주세요.");
                 }
                 jQuery('#pop_hd_dlvrc').val(jQuery('#pop_txt_dlvrc').val().replaceAll(",", ""));
                 
                 var url = '/admin/seller/setup/delivery/delivery-area-update',
                     param =  jQuery('#form_delivery_info').serialize();                 

                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     
                     if (result == null || result.success != true) {
                         return;
                     } else {                        
                         // Dmall.LayerPopupUtil.close(jQuery('#layer_area_edit'));
                         
                         fn_getSearchDeliveryList();
                         
                         $("#pop_btn_close").trigger('click');
                         return false;
                     }
                 });
             });
             
             Dmall.LayerPopupUtil.open(jQuery('#layer_area_edit'));
             $('[data-bind="delivery_info"]', $('#pop_tr_template')).DataBinder($targetTr.data("detail"));  
             
             Dmall.common.comma();
         }
         
         // 기본 지역별 추가배송비 적용 이벤트 설정
         function fn_apply_default() {
             Dmall.LayerUtil.confirm('기본 추가 배송비 설정을 적용하시면 기존 추가 배송비 정보가 삭제 됩니다. 기본 설정을 적용 하시겠습니까?', function() {
                 var url = '/admin/seller/setup/delivery/default-delivery-update',
                     param = {};            
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     jQuery('#hd_page').val(1);
                     fn_getSearchDeliveryList();
                 });
             });
         }
         
         // 지역별 추가배송비 삭제 이벤트 설정
         function fn_delete() {
             Dmall.LayerUtil.confirm('<spring:message code="biz.common.confirmDelete"/>', function() {
                 var url = '/admin/seller/setup/delivery/delivery-area-delete',
                     param = {},
                     key,
                     selected = fn_selectedList();
                 if (selected) {
                     jQuery.each(selected, function(i, o) {
                         key = 'list[' + i + '].areaDlvrSetNo';
                         param[key] = o;
                     });              
                     Dmall.AjaxUtil.getJSON(url, param, function(result) {
                         jQuery('#hd_page').val(1);
                         fn_getSearchDeliveryList();
                     });
                 }
             });
         }
         
         // 지역별 추가배송비 전체삭제 이벤트 설정
         function fn_all_delete() {
             Dmall.LayerUtil.confirm('<spring:message code="biz.common.confirmDelete"/>', function() {
             var url = '/admin/seller/setup/delivery/alldelivery-area-delete',
                 param = {};           
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     jQuery('#hd_page').val(1);
                     fn_getSearchDeliveryList();
                 });
             });
         }
      
         // 그리드에서 선택된 지역별 추가배송비 설정 취득
         function fn_selectedList() {
             var selected = [];
             $('#tbody_delivery_area input:checked').each(function() {
                 if ($(this).data('areaDlvrSetNo')) { 
                     selected.push($(this).data('areaDlvrSetNo'));
                 }
             });
             if (selected.length < 1) {
                 Dmall.LayerUtil.alert('선택된 지역별 추가배송비 설정이 없습니다.');
                 return false;   
             }
             return selected;
         }
         
         
         // HSCD - 처리 START
         // HSCD 검색결과 취득
         function fn_getSearchHscdList() {
             var url = '/admin/seller/setup/delivery/hscode-list',
             param = $('#form_hscd').serialize();

             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 $("#tbody_hscd").find(".searchResult").each(function() {
                     $(this).remove();
                 });
                 
                 // 취득결과 셋팅
                 jQuery.each(result.resultList, function(idx, obj) {
                     fn_setHscdResultData(obj, $('#tr_hscd_template'), $('#tbody_hscd'));
                 });
                 
                 // 결과가 없을 경우 NO DATA 화면 처리
                 if ( $("#tbody_hscd").find(".searchResult").length < 1 ) {
                     $("#tbody_hscd").append('<tr id="tr_no_hscd_data" class="searchResult"><td colspan="3">데이터가 없습니다.</td></tr>');
                 }
                 Dmall.GridUtil.appendPaging('form_hscd', 'div_hscd_paging', result, 'paging_id_hscd_list', fn_getSearchHscdList);
             });
         }
         // HS코드 검색 POPUP용 검색 결과 취득
         function fn_getPopSearchHscdList() {
             var url = '/admin/seller/setup/delivery/hscode-list',
             param = $('#form_search_hscd').serialize();

             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result == null || result.success != true) {
                     return;
                 }
                 $("#tbody_search_hscd").find(".searchResult").each(function() {
                     $(this).remove();
                 });
                 
                 // 취득결과 셋팅
                 jQuery.each(result.resultList, function(idx, obj) {
                     fn_setHscdResultData(obj, $('#tr_search_hscd_template'), $('#tbody_search_hscd'));
                 });
                 
                 // 결과가 없을 경우 NO DATA 화면 처리
                 if ( $("#tbody_search_hscd").find(".searchResult").length < 1 ) {
                     $("#tbody_search_hscd").append('<tr id="tr_no_hscd_data" class="searchResult"><td colspan="3">데이터가 없습니다.</td></tr>');
                 }
                 Dmall.GridUtil.appendPaging('form_pop_hscd', 'div_pop_hscd_paging', result, 'paging_id_pop_hscd_list', fn_getPopSearchHscdList);
             });
         }
         // HS코드 취득 결과 바인딩
         function fn_setHscdResultData(data, $tempTr, $tbody) {
             var $tr = $tempTr.clone().show().removeAttr("id");
             var trId = "tr_hscd_" + data.hscdSeq;
             $tr.attr("id", trId).addClass("searchResult").data("data", data);
             $('[data-bind=hscd]', $tr).DataBinder(data);
             $tbody.append($tr);
         }
         // HS목록 중 수정 버튼 바인딩
         function setHscdEdit(data, obj, bindName, target, area, row) {
             obj.off("click").on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 Dmall.LayerPopupUtil.open(jQuery('#layer_add_hscd'));
                 var data = obj.closest("tr").data("data");
                 $('[data-bind=hscd]', $('#form_add_hscd')).DataBinder(data); 
             });
         }
         // HS목록 중 삭제 버튼 바인딩
         function setHscdDelete(data, obj, bindName, target, area, row) {
             obj.off("click").on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 var data = obj.closest("tr").data("data");
                 if (!data || !data['hscdSeq']) {
                     Dmall.LayerUtil.alert('<spring:message code="biz.exception.common.nodata"/>');
                     return false;
                 } else {
                     Dmall.LayerUtil.confirm('<spring:message code="biz.common.confirmDelete"/>', function() {
                     var url = '/admin/seller/setup/delivery/hscode-delete',
                         param = {'hscdSeq' : data['hscdSeq']};
                         Dmall.AjaxUtil.getJSON(url, param, function(result) {
                             if ($('#layer_search_hscd').is(':visible')) {
                                 
                             } else {
                                 jQuery('#hd_page_hscd').val(1);
                                 fn_getSearchHscdList();
                             }
                         });
                     });
                 }
             });
         }
         // HS목록 중 수정 버튼 바인딩
         function setPopHscdEdit(data, obj, bindName, target, area, row) {
             obj.off("click").on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 var url = '/admin/seller/setup/delivery/hscode-update',
                 $tr = obj.closest('tr'),
                 param = $tr.data("data"),
                 hscd = $('input[name=hscd]', $tr).val(),
                 item = $('input[name=item]', $tr).val();
                 if (!hscd || !item) {
                     Dmall.LayerUtil.alert('<spring:message code="biz.exception.common.nodata"/>');
                     return false;
                 }
                 param['hscd'] = hscd;
                 param['item'] = item;
                 
                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         fn_getPopSearchHscdList();
                     }
                 });
             });
         }
         // HS코드 추가
         function fn_add_hscd() {
             if(Dmall.validate.isValid('form_add_hscd')) {
                 var url = '/admin/seller/setup/delivery/hscode-update',
                 param = jQuery('#form_add_hscd').serialize();

                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     Dmall.validate.viewExceptionMessage(result, 'form_add_hscd');
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         if ($('#layer_search_hscd').is(':visible')) {
                             
                         } else {
                             Dmall.LayerPopupUtil.close('layer_add_hscd');
                             jQuery('#hd_page_hscd').val(1);
                             fn_getSearchHscdList();
                         }
                     }
                 });
             }
             return false;
         }
         // HS코드 삭제
         function fn_delete_hscd(hscd) {
             if(Dmall.validate.isValid('form_edit_hscd')) {
                 var url = '/admin/seller/setup/delivery/hscode-delete',
                 param = {'hscd' : hscd};

                 Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     Dmall.validate.viewExceptionMessage(result, 'form_edit_hscd');
                     if (result == null || result.success != true) {
                         return;
                     } else {
                         // 메인 패이지 HS코드 목록 재취득
                         fn_getSearchHscdList();
                     }
                 });
             }
             return false;
         }
         // HSCD - 처리 END
         
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <sec:authentication property="details.session.sellerNo" var="sellerNo"></sec:authentication>
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">배송설정</h2>
                <div class="btn_box right">
                    <a href="#none" class="btn blue" id="btn_save">저장하기</a>
                </div>
            </div>
            
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">국내 – 배송정책 설정 </h3>
            <!-- tblw -->
            <form:form id="form_delivery_config" >
            <div class="tblw tblmany">
                <table summary="이표는 국내 – 배송정책 설정 표 입니다. 구성은 배송 방법, 배송비적용 입니다.">
                    <caption>국내 – 배송정책 설정</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="85%">
                    </colgroup>
                    <tbody id="tbody_delivery_config" data-bind-type="function" data-find="delivery_config" data-bind-value="defaultDlvrcTypeCd" data-bind-function="setDefaultDlvrcTypeCd">
                        <tr>
                            <th>배송 방법</th>
                            <td>
                                <input type="checkbox" value="Y" name="couriUseYn" id="chk_couriUseYn" class="blind">
                                <label for="chk_couriUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="couriUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    택배배송
                                </label>
<!--                                 
                                <input type="checkbox" value="Y" name="fastregstUseYn" id="chk_fastregstUseYn" class="blind">
                                <label for="chk_fastregstUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="fastregstUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    빠른등기
                                </label>
                                <input type="checkbox" value="Y" name="directDlvrUseYn" id="chk_directDlvrUseYn" class="blind">
                                <label for="chk_directDlvrUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="directDlvrUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    직접배송
                                </label>
                                <input type="checkbox" value="Y" name="quickdlvUseYn" id="chk_quickdlvUseYn" class="blind">
                                <label for="chk_quickdlvUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="quickdlvUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    퀵 배송
                                </label>
                                <input type="checkbox" value="Y" name="cargoDlvrUseYn" id="chk_cargoDlvrUseYn" class="blind">
                                <label for="chk_cargoDlvrUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="cargoDlvrUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    화물배송
                                </label>
 -->



                                <c:if test="${sellerNo eq '1'}">
                                <input type="checkbox" value="Y" name="directVisitRecptYn" id="chk_directVisitRecptYn" class="blind">
                                <label for="chk_directVisitRecptYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="directVisitRecptYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    직접매장픽업
                                </label>
                                </c:if>
<!--                                 
                                <input type="checkbox" value="Y" name="etcUseYn" id="chk_etcUseYn" class="blind">
                                <label for="chk_etcUseYn" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="etcUseYn" data-bind-function="setUseYn">
                                    <span class="ico_comm">&nbsp;</span>
                                    기타
                                </label>
-->
                            </td>
                        </tr>
                        <tr>
                            <th rowspan="3">배송비적용</th>
                            <td>
                                <label for="rdo_defaultDlvrcTypeCd_1" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="defaultDlvrcTypeCd" id="rdo_defaultDlvrcTypeCd_1" value="1">
                                </span> 무료</label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="rdo_defaultDlvrcTypeCd_2" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="defaultDlvrcTypeCd" id="rdo_defaultDlvrcTypeCd_2" value="2">
                                </span> 상품별 배송비 (유료)</label>
                                <span>개수와 상관없이 배송비 <span class="intxt shot2">
                                    <input type="text" value="" name="defaultDlvrc1" class="comma" id="txt_defaultDlvrc" data-find="delivery_config" data-bind-type="textcomma" data-bind-value="defaultDlvrc" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                    <input type="hidden" name="defaultDlvrc" id="hd_defaultDlvrc" value="" />
                                </span> 원</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="rdo_defaultDlvrcTypeCd_3" class="radio"><span class="ico_comm">
                                    <input type="radio" name="defaultDlvrcTypeCd" id="rdo_defaultDlvrcTypeCd_3" value="3">
                                </span></label>
                                주문합계 금액으로 배송비 부과 - 금액이
                                <span class="intxt shot2">
                                    <input type="text" value="" name="defaultDlvrMinAmt1" id="txt_defaultDlvrMinAmt" class="comma" data-find="delivery_config" data-bind-type="textcomma" data-bind-value="defaultDlvrMinAmt" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                    <input type="hidden" name="defaultDlvrMinAmt" id="hd_defaultDlvrMinAmt" value="" />
                                </span> 원 미만일 경우,
                                <span class="intxt shot2">
                                    <input type="text" value="" name="defaultDlvrMinDlvrc1" id="txt_defaultDlvrMinDlvrc" class="comma" data-find="delivery_config" data-bind-type="textcomma" data-bind-value="defaultDlvrMinDlvrc" maxlength="10" data-validation-engine="validate[maxSize[10]]" >
                                    <input type="hidden" name="defaultDlvrMinDlvrc" id="hd_defaultDlvrMinDlvrc" value="" />
                                </span> 원 부과                              
                                <span class="br2"></span>
                                <span class="fc_pr1 fs_pr1">
                                    주문금액 : 총 주문금액(할인 전)을 모두 인정.
                                <!--   
                                    <br>
                                    
                                    결제금액 : 실결제 금액(신용카드, 무통장입금, 휴대폰결제, 실시간계좌이체)으로 결제.
                                    <br>무료 배송으로 지정된 상품 구입 시 무조건 <strong>배송비 무료</strong>
                                    <input type="checkbox" value="Y" name="freedlvrTypeCd" id="chk_freedlvrTypeCd" class="blind">
                                    <label for="chk_freedlvrTypeCd" class="chack mr20" data-bind-type="function" data-find="delivery_config" data-bind-value="freedlvrTypeCd" data-bind-function="setUseYn"> 
                                    <span class="ico_comm">&nbsp;</span></label>
                                -->
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>배송비결제방식</th>
                            <td data-find="delivery_config" data-input-type="radio" data-input-name="dlvrPaymentKindCd" >
                                <label for="dlvrPaymentKindCd_1" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="dlvrPaymentKindCd" id="dlvrPaymentKindCd_1" value="1"
                                       data-input-value="1" data-bind-type="function" data-find="delivery_config" data-bind-value="dlvrPaymentKindCd" data-bind-function="setRdo"></span>선불</label>
                                <label for="dlvrPaymentKindCd_2" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="dlvrPaymentKindCd" id="dlvrPaymentKindCd_2" value="2"
                                       data-input-value="2" data-bind-type="function" data-find="delivery_config" data-bind-value="dlvrPaymentKindCd" data-bind-function="setRdo"></span>착불</label>
                                <label for="dlvrPaymentKindCd_3" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="dlvrPaymentKindCd" id="dlvrPaymentKindCd_3" value="3"
                                       data-input-value="3" data-bind-type="function" data-find="delivery_config" data-bind-value="dlvrPaymentKindCd" data-bind-function="setRdo"></span>선불 + 착불</label>
                                <%--<label for="dlvrPaymentKindCd_4" class="radio mr20"><span class="ico_comm">
                                    <input type="radio" name="dlvrPaymentKindCd" id="dlvrPaymentKindCd_4" value="4"
                                       data-input-value="4" data-bind-type="function" data-find="delivery_config" data-bind-value="dlvrPaymentKindCd" data-bind-function="setRdo"></span>직접매장픽업</label>--%>
                            </td>
                        </tr>
                        
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
            </form:form>
            
                        <!-- //tblw -->
           <%-- <h3 class="tlth3 btn1">
                HS코드 관리
                <a href="#none" class="btn_gray2" id="btn_add_hscd">추가</a>
                <a href="#none" class="btn_gray2" id="btn_search_hscd">검색</a>
            </h3>
            <!-- tblh -->
            <div class="tblh tblmany th_l">
                <table summary="이표는 HS코드 관리 표 입니다. 구성은 항목, HS코드, 관리 입니다.">
                    <caption>HS코드 관리</caption>
                    <colgroup>
                        <col width="30%">
                        <col width="50%">
                        <col width="20%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>항목</th>
                            <th>HS코드</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_hscd">
                        <tr id="tr_hscd_template" style="display:none;">
                            <td data-bind="hscd" data-bind-type="string" data-bind-value="item"></td>
                            <td data-bind="hscd" data-bind-type="string" data-bind-value="hscd"></td>
                            <td>
                                <button class="btn_gray" data-bind="hscd" data-bind-value="hscd" data-bind-type="function" data-bind-function="setHscdEdit">수정</button>
                                <button class="btn_gray" data-bind="hscd" data-bind-value="hscd" data-bind-type="function" data-bind-function="setHscdDelete">삭제</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- bottom_lay -->
            <div class="bottom_lay">
                <div class="pageing"  id="div_hscd_paging">
                </div>
             </div>
             <form:form id="form_hscd" >
                 <input type="hidden" name="page" id="hd_page_hscd" value="1" />
                 <input type="hidden" name="sord" id="hd_srod_hscd" value="" />
                 <input type="hidden" name="rows" id="hd_rows_hscd" value="5" />
             </form:form>     --%>
            <!-- //bottom_lay -->            
            <!-- //tblh -->
            
            <h3 class="tlth3 btn1">
                지역별 추가 배송비 설정
                <a href="#none" class="btn_gray2" id="btn_add_area">추가</a>
                <div class="right">
                    <a href="#none" class="btn_gray2" id="btn_apply_default">기본 지역별 추가 배송비 적용</a>
                </div> 
            </h3>
            <!-- tblh -->
            <div class="tblh th_l">
                <table id="tb_delivery_area" summary="이표는 기본도서지역 리스트 표 입니다. 구성은 체크박스, 우편번호, 지역(도로명, 지번), 추가 배송비 입니다.">
                    <caption>지역별 추가 배송비 목록</caption>
                    <colgroup>
                        <col width="5%">
                        <col width="20%">
                        <col width="50%">
                        <col width="25%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" name="chack_f1" id="chk_all" class="blind">
                                <label id="lb_chk_all" for="chk_all" class="chack" ><span class="ico_comm">&nbsp;</span></label>
                            </th>
                            <th>우편번호</th>
                            <th>주소(도로명, 지번)</th>
                            <th>추가배송비</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_delivery_area">
                        <tr id="tr_delivery_area_template">
                            <td data-bind="delivery_area" data-bind-value="areaDlvrSetNo" data-bind-type="function" data-bind-function="setAreaChkBox">
                                <input type="checkbox" name="chack_f1" id="chk_select_template" class="blind">
                                <label for="chk_select_template" class="chack"><span class="ico_comm">&nbsp;</span></label>
                            </td>
                            <td data-bind="delivery_area" data-bind-type="string" data-bind-value="postNo"></td>
                            <td data-bind="delivery_area" data-bind-value="areaDlvrSetNo" data-bind-type="function" data-bind-function="setAreaNm"></td>
                            <td>
                                <span class="intxt shot"><input id="tr_txt_dlvrc" type="text" class="comma" data-bind="delivery_area" data-bind-type="textcomma" data-bind-value="dlvrc" disabled="disabled" maxlength="10"></span>
                                원
                                <button class="btn_gray" data-bind="delivery_area" data-bind-value="areaDlvrSetNo" data-bind-type="function" data-bind-function="setAreaEdit">수정</button>
                            </td>
                        </tr>
                        <tr id="tr_no_delivery_area_data"><td colspan="4">데이터가 없습니다.</td></tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <!-- bottom_lay -->
            <div class="bottom_lay">
                <div class="left">
                    <div class="pop_btn">
                        <a href="#none" class="btn_gray2" id="btn_delete">삭제</a>
                        <a href="#none" class="btn_gray2" id="btn_all_delete">전체삭제</a>
                    </div>
                </div>
                <div class="pageing"  id="div_id_paging">
                </div>
             </div>
            <!-- //bottom_lay -->
        </div>
        <form:form id="form_delivery_area" >
            <input type="hidden" name="page" id="hd_page" value="1" />
            <input type="hidden" name="sord" id="hd_srod" value="" />
            <input type="hidden" name="rows" id="hd_rows" value="" />
        </form:form>
        <!-- //line_box -->



        <div id="layer_area_edit" class="layer_popup">

            <div class="pop_wrap size1">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">지역별 추가 배송비 수정</h2>
                    <button id="pop_btn_close" class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con">
                    <div>
                        <!-- gray_tbl -->
                        <div class="gray_tbl txt_an_c">
                            <table summary="이표는 기본도서지역 리스트 표 입니다. 구성은 체크박스, 우편번호, 지역(도로명, 지번), 추가 배송비 입니다.">
                                <caption>지역별 추가 배송비</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="20%">
                                    <col width="50%">
                                    <col width="25%">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>
                                            <input type="checkbox" name="chack_f1" id="pop_chk_sel" class="blind" checked="checked">
                                            <label for="pop_chk_sel" id="pop_lb_chk_sel" class="chack on" ><span class="ico_comm">&nbsp;</span></label>
                                        </th>
                                        <th>우편번호</th>
                                        <th>주소(도로명, 지번)</th>
                                        <th>추가배송비</th>
                                    </tr>
                                </thead>
                                <form:form id="form_delivery_info" >
                                <tbody id="tbody_delivery_info">
                                    <tr id="pop_tr_template">
                                        <td>
                                            <input type="checkbox" name="chack_f1" id="pop_tr_chk_sel" class="blind" >
                                            <label for="pop_tr_chk_sel" id="pop_tr_lb_chk_sel" class="chack"><span class="ico_comm">&nbsp;</span></label>
                                        </td>
                                        <td data-bind="delivery_info" data-bind-type="string" data-bind-value="postNo"></td>
                                        <td data-bind="delivery_info" data-bind-value="areaDlvrSetNo" data-bind-type="function" data-bind-function="setAreaNm"></td>
                                        <td>
                                            <span class="intxt shot">
                                                <input type="text" id="pop_txt_dlvrc" class="comma" data-bind="delivery_info" data-bind-type="textcomma" data-bind-value="dlvrc" maxlength="10">
                                                <input type="hidden" name="dlvrc" id="pop_hd_dlvrc" data-bind="delivery_info" data-bind-type="text" data-bind-value="dlvrc" />  
                                                <input type="hidden" name="areaDlvrSetNo" id="pop_hd_areaDlvrSetNo" data-bind="delivery_info" data-bind-type="text" data-bind-value="areaDlvrSetNo" />
                                                <input type="hidden" name="postNo" id="pop_hd_ddlvrc" data-bind="delivery_info" data-bind-type="text" data-bind-value="postNo" />  
                                                <input type="hidden" name="numAddr" id="pop_hd_ddlvrc" data-bind="delivery_info" data-bind-type="text" data-bind-value="numAddr" />  
                                                <input type="hidden" name="roadnmAddr" id="pop_hd_ddlvrc" data-bind="delivery_info" data-bind-type="text" data-bind-value="roadnmAddr" />
                                                <input type="hidden" name="areaNm" id="pop_hd_ddlvrc" data-bind="delivery_info" data-bind-type="text" data-bind-value="areaNm" />   
                                            </span>
                                            원
                                            <button class="btn_gray" id="pop_btn_edit">수정</button>
                                        </td>
                                    </tr>
                                </tbody>
                                </form:form>
                            </table>
                        </div>
                        <!-- //gray_tbl -->
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
    </div>
<!-- //content -->

    <!-- layer_popup1 -->
    <div id="layer_add_hscd" class="layer_popup">
        <div class="pop_wrap size2">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">HS코드 추가</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <!-- tblw -->
                    <div class="select_top">
                        <a href="http://www.customs.go.kr/kcshome/getBuRyuList.po" target="_blank" class="btn_blue">※ 관세율표 확인하기</a>
                        <!--
                            <div class="right">
                                <button class="btn_gray2">확인</button>
                            </div>
                        -->
                    </div>
                    
                    <form:form id="form_add_hscd" >
                    <input type="hidden" name="hscdSeq" id="hd_hscd_seq" data-bind="hscd" data-bind-type="text" data-bind-value="hscdSeq" /> 
                    <div class="tblw mt0">
                        <table summary="이표는 HS코드 추가 표 입니다. 구성은 항목, HS코드 입니다.">
                            <caption>HS코드 추가</caption>
                            <colgroup>
                                <col width="30%">
                                <col width="70%">
                            </colgroup>
                            <tbody id="tbody_add_hscd">
                                <tr>
                                    <th>항목</th>
                                    <td><span class="intxt wid100p"><input type="text" name="item" id="txt_item" data-bind="hscd" data-bind-type="text" data-bind-value="item" maxlength="100" data-validation-engine="validate[required, maxSize[100]]"></span></td>
                                </tr>
                                <tr>
                                    <th>HS코드</th>
                                    <td><span class="intxt wid100p"><input type="text" name="hscd" id="txt_hscd" data-bind="hscd" data-bind-type="text" data-bind-value="hscd" maxlength="20" data-validation-engine="validate[required, maxSize[20]]"></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    </form:form>
                    <!-- //tblw -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="btn_regist_hscd">등록</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->


    <!-- layer_popup1 -->
    <div id="layer_search_hscd" class="layer_popup">
        <div class="pop_wrap size3">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">HS코드 검색</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <form:form id="form_search_hscd" >
                    <div class="top_search">
                        <span class="select">
                            <label for="sel_hscd"></label>
                            <select name="searchWordType" id="sel_hscd">>
                                <tags:option codeStr="1:항목명;2:HS코드" />
                            </select>
                        </span>
                        <span class="intxt"><input type="text" name="searchWord" id="txt_searchWord" /><button class="ico_comm" id="btn_pop_search_hscd">검색</button></span>
                    </div>
                    </form:form>
                    <!-- tblh -->
                    <div class="tblh mt0">
                        <table summary="이표는 HS코드 관리 표 입니다. 구성은 항목, HS코드, 관리 입니다.">
                            <caption>HS코드 관리</caption>
                            <colgroup>
                                <col width="30%">
                                <col width="50%">
                                <col width="20%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>항목</th>
                                    <th>HS코드</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_search_hscd">
                                <tr id="tr_search_hscd_template" style="display:none;">
                                    <td><span class="intxt wid100p"><input type="text" name="item" data-bind="hscd" data-bind-type="text" data-bind-value="item" maxlength="100" data-validation-engine="validate[required, maxSize[100]]"></span></td>
                                    <td><span class="intxt wid100p"><input type="text" name="hscd" data-bind="hscd" data-bind-type="text" data-bind-value="hscd" maxlength="20" data-validation-engine="validate[required, maxSize[20]]"></span></td>
                                    <td>
                                        <button class="btn_gray" data-bind="hscd" data-bind-value="hscd" data-bind-type="function" data-bind-function="setPopHscdEdit">수정</button>
                                        <button class="btn_gray" data-bind="hscd" data-bind-value="hscd" data-bind-type="function" data-bind-function="setHscdDelete">삭제</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                       <div class="pageing"  id="div_pop_hscd_paging">
                       </div>
                    </div>
                    <form:form id="form_pop_hscd" >
                        <input type="hidden" name="page" id="hd_page_pop_hscd" value="1" />
                        <input type="hidden" name="sord" id="hd_srod_pop_hscd" value="" />
                        <input type="hidden" name="rows" id="hd_rows_pop_hscd" value="5" />
                    </form:form>  
                    <!-- //tblh -->
                </div>
            </div>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->


    </t:putAttribute>
</t:insertDefinition>
