<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">택배사관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                
                // init.radio();                
                var courierCd = '${paramModel}';
                if ( courierCd != null && courierCd.length > 0  ) {
                    fn_getCourierData(courierCd);
                    
                } else {
                    fn_loadDefault();
                    fn_getCourierdOptionValue();
                }
                
                jQuery('#btn_list').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_goList();
                });
                
                jQuery('#btn_regist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    fn_regist();
                });
                
                jQuery('#sel_dlvrc').on('change', function(e) {
                    var $txt_dlvrc = $("#txt_dlvrc");
                    if ( $(this).val() == '') {
                        $txt_dlvrc.show().parents('span').show();
                        $txt_dlvrc.focus()
                    } else {
                        $txt_dlvrc.parents('span').hide();
                    }
                });
                
                Dmall.validate.set('form_id_regist');
                
                Dmall.common.comma();
                Dmall.common.date();
            });
            
            function fn_goList() {
                Dmall.FormUtil.submit('/admin/setup/delivery/courier-config', {courierCd : ''});
            }
            
            function fn_regist() {
                var courierCd = $("#sel_courier_cd").val();
                var sel_dlvrc = $("#sel_dlvrc").val();
                var txt_dlvrc = $("#txt_dlvrc").val();
                
                if (!courierCd) {
                    Dmall.LayerUtil.alert("추가가능한 택배사가 없습니다.");
                    return false;
                }
                /* 
                if ( '' == sel_dlvrc && '' != txt_dlvrc ) {
                    $("#hd_dlvrc").val(parseInt(txt_dlvrc.replaceAll(",", "")));
                } else if (sel_dlvrc){
                    $("#hd_dlvrc").val(sel_dlvrc);
                } else {
                    Dmall.LayerUtil.alert("배송비를 입력해주세요.");
                    return false;
                } 
                */
                $("#hd_courier_nm").val($("#sel_courier_cd option:selected").text());
                
                if(Dmall.validate.isValid('form_id_regist')) {
                    var url = '/admin/setup/delivery/courier-insert',
                        param = jQuery('#form_id_regist').serialize();
                    
                    if ( $('#btn_regist').data("regist_type") == "U" ) {
                        url = '/admin/setup/delivery/courier-use-update';
                    }
                    //
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_regist');
                        
                        if (result == null || result.success != true) {
                            return;
                        } else {
                            fn_getCourierData(courierCd);
                        }
                    });
                }                
                return false;
            }
            
            function fn_loadDefault() {
                $('#btn_regist').data("regist_type", "I");
                $("#txt_regDttm").val(new Date().format('yyyy-MM-dd'));
                $("input[value='N']", $("#td_useyn")).parents('label').addClass("on").siblings().find('input').removeAttr('checked');
                $("input[value='N']", $("#td_useyn")).attr('checked', 'checked').trigger('change');
                $("#txt_dlvrc").val('');
                $("#lb_sel_dlvrc").html($("option:first", $('#sel_dlvrc')).attr("selected", "true").text()); 
            }
            
            
            function fn_getCourierData(courierCd) {
                var url = '/admin/setup/delivery/courier',
                    param = {courierCd : courierCd};
                //
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }                
                    var courierInfo = result.data;
                    fn_set_result(courierInfo);
                });
            }
            
            function fn_set_result(courierInfo) {
                $('#btn_regist').data("regist_type", "U");
                $('[data-find="courier_info"]').DataBinder(courierInfo);             
            }

            function fn_bindRowData(rowData) {
                var $tmpSearchRow = $("#tr_search_data_template").clone().show().removeAttr("id");
                var trId = "tr_" + rowData.courierCd;
                $($tmpSearchRow).attr("id", trId).addClass("searchResult");
                $('[data-bind="resultRow"]', $tmpSearchRow).DataBinder(rowData);
                $("#tbody_search_data").append($tmpSearchRow);
            }
            
            function setCourierSel(data, obj, bindName, target, area, row) {
                var courierCd = data["courierCd"];
                // $('#sel_courier_cd').find('option[value=' + courierCd + ']').attr('disabled', 'disabled');                              
                $('#sel_courier_cd option').each(function(){
                    if( $(this).val() == courierCd ) {
                        $(this).attr("selected", "selected");
                    } else {
                        // $(this).attr('disabled', 'disabled');
                        $(this).remove();
                    }
                });
                $('#lb_courier_cd').text($('#sel_courier_cd option:selected').text());
                
            }
            
            function setUseYn(data, obj, bindName, target, area, row) {
                var useYn = data["useYn"];
                if (useYn && 'N' == useYn) {
                    $("input[value='N']", obj).parents('label').addClass("on").siblings().find('input').removeAttr('checked');
                    $("input[value='N']", obj).attr('checked', 'checked').trigger('change');
                } else {
                    $("input[value='Y']", obj).parents('label').addClass("on").siblings().find('input').removeAttr('checked');
                    $("input[value='Y']", obj).attr('checked', 'checked').trigger('change');
                }
            }
            
            function setDlvrc(data, obj, bindName, target, area, row) {
                var dlvrc = data["dlvrc"];
                if ( dlvrc ) {
                    var label = $("option[value='"+ parseInt(dlvrc) +"']", obj).attr("selected", "true").text();
                    obj.siblings('label').text(label);
                }                
                var $txt_dlvrc = $("#txt_dlvrc");
                if ( $("option:selected", obj).index() > 1) {
                    $txt_dlvrc.parents('span').hide();
                } else {
                    var label = $("option:first", obj).attr("selected", "true").text();
                    obj.siblings('label').text(label);
                    $txt_dlvrc.val( parseInt(dlvrc) .getCommaNumber() ).show().parents('span').show();
                }
            }
            
            function fn_getCourierdOptionValue($sel) {
                var url = '/admin/setup/delivery/courier-list',
                    param = '';
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }                
                    var rstList = result.resultList;
                    if (rstList == null) {
                        return;
                    }
                    
                    var disableOptCnt = 0, optCnt =$('#sel_courier_cd option').length, selectIdx = -1;
                    jQuery.each(rstList, function(i, o) {
                        $('#sel_courier_cd').find('option[value=' + o + ']').attr('disabled', 'disabled');
                    });
                    
                    $('#sel_courier_cd option').each(function(){
                        if( $(this).attr("disabled") == 'disabled' ) {
                            disableOptCnt++;
                            return true;
                        } else {
                            $(this).attr("selected", "selected");
                            return false;
                        }
                    });
                    if (optCnt == disableOptCnt) {
                        $('#sel_courier_cd').append($('<option>', { value : "" }).text("추가가능 택배사 없음"));
                        $('#sel_courier_cd option:last').attr("selected", "selected");
                    }
                    $('#lb_courier_cd').text($('#sel_courier_cd option:selected').text());
                });   
            }             
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">택배사 관리</h2>
                <div class="btn_box left">
                    <a href="#none" class="btn blue"  id="btn_list">택배사 목록</a>
                </div>
                <div class="btn_box right">
                    <a href="#none" class="btn blue"  id="btn_regist">등록</a>
                </div>
            </div>
            
        <!-- search_box -->
            <form:form id="form_id_regist" >
            <div class="line_box fri">
                <h3 class="tlth3">택배사 추가 등록</h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 택배사 추가 등록 표 입니다. 구성은 등록일, 택배사명, 사용여부, 배송비 입니다.">
                        <caption>택배사 추가 등록</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>등록일</th>
                                <td>
                                    <span class="intxt"><input type="text" name="regDttm" id="txt_regDttm" class="bell_date_sc date" data-find="courier_info" data-bind-type="text" data-bind-value="regDttm" maxlength="10" data-validation-engine="validate[maxSize[10]]" ></span>
                                    <a href="#calendar" class="date_sc ico_comm">달력이미지</a>
                                </td>
                            </tr>
                            <tr>
                                <th>택배사명</th>
                                <td>
                                    <span class="select nor">
                                        <label for="sel_courier_cd" id="lb_courier_cd"></label>
                                        <select id="sel_courier_cd" name="courierCd" data-find="courier_info" data-bind-value="courierCd" data-bind-type="function" data-bind-function="setCourierSel">
                                            <code:option codeGrp="COURIER_CD" />
                                        </select>
                                    </span>
                                    <!-- <span class="intxt"><input type="text" value="" id=""></span> -->
                                    <input type="hidden" id="hd_courier_nm" name="courierNm" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th>사용여부</th>
                                <td id="td_useyn" data-find="courier_info" data-bind-value="dlvrc" data-bind-type="function" data-bind-function="setUseYn">
                                    <label for="radio0_1" class="radio mr20"><span class="ico_comm"><input id="rdo_useyn_y" type="radio" name="useYn" value="Y"></span> 사용</label>
                                    <label for="radio0_2" class="radio mr20"><span class="ico_comm"><input id="rdo_useyn_n" type="radio" name="useYn" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
<%--                        
                            <tr>
                                <th>배송비</th>
                                <td>
                                    <span class="select">
                                        <label id="lb_sel_dlvrc" for="sel_dlvrc"></label>
                                        <select name="sdlvrc" id="sel_dlvrc" data-find="courier_info" data-bind-value="dlvrc" data-bind-type="function" data-bind-function="setDlvrc">
                                            <tags:option codeStr=":직접 입력;1000:1,000;2000:2,000;2500:2,500;3000:3,000;3500:3,500;4000:4,000;4500:4,500;5000:5,000;6000:6,000;10000:10,000;" />
                                        </select>
                                    </span>
                                    <span class="intxt"><input type="text" id="txt_dlvrc" class="comma" data-find="courier_info" data-bind-type="textcomma" data-bind-value="dlvrc" maxlength="10" data-validation-engine="validate[required, maxSize[10]]" ></span>
                                    <input type="hidden" id="hd_dlvrc" name="dlvrc" value="0" maxlength="6" data-validation-engine="validate[maxSize[6]]" />
                                    원
                                </td>
                            </tr> 
--%>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
            </form:form>
            

            
        </div>
        <!-- //line_box -->

    </t:putAttribute>
</t:insertDefinition>
