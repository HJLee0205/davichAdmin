<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 결제관리 &gt; 간편 결제 서비스 설정</t:putAttribute>
    <t:putAttribute name="script">
       <script type="text/javascript">
           $(document).ready(function() {
               SimplePayInitUtil.init();
               SimpleRenderUtil.render('');

               // 상품선택하기 버튼 클릭시
               $('.layerBtn').on('click', function(e) {
                   e.preventDefault();
                   e.stopPropagation();
                   SimplePayPopupUtil.layerOpen(this);
               });
               
               //서비스 사용여부 여부 클릭시 이벤트
               $("input:radio[name=simplepayUseYn]").on('change', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   SimplePayUtil.useHandler($(this).val());
               });
               
               $('#btn_save').off('click').on('click', function(e) {
                   Dmall.EventUtil.stopAnchorAction(e);
                   SimpleSubmitUtil.submit();
               });
               
               Dmall.validate.set('form_simple_config');
           });
           
           var SimplePayUtil = {
               useHandler:function(value) {
                   value === 'Y' ? $('.tr-simple-pg-cd').show() : $('.tr-simple-pg-cd').hide();
               }
           };
           
           var SimplePayInitUtil = {
               init:function() {
                   $('label.chack').off('click').on('click', function(e) {
                       Dmall.EventUtil.stopAnchorAction(e);
                       var $this = $(this),
                           $input = $("#" + $this.attr("for")),
                           checked = !($input.prop('checked'));
                       $input.prop('checked', checked);
                       $this.toggleClass('on');
                   });  
               }
               , setSimplepayUseYn:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];

                   $("input:radio[name=simplepayUseYn][value=" + value + "]").parent().parent().addClass('on');
                   $("input:radio[name=simplepayUseYn][value=" + value + "]").prop('checked', true);
               }
               , setSimpPgCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];
    
                   $("input:radio[name=simpPgCd][value=" + value + "]").trigger('click');
               }
               , setSimpPgTypeCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];
    
                   $("input:radio[name=simpPgTypeCd][value=" + value + "]").trigger('click');
               }
               , setUseSetCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];
    
                   $("input:radio[name=useSetCd][value=" + value + "]").trigger('click');
               }
               , setUseAreaCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];
    
                   $("input:radio[name=useAreaCd][value=" + value + "]").trigger('click');
               }
               , setDsnSetCd:function(data, obj, bindName, target, area, row) {
                   var bindValue = obj.data("bind-value")
                       , value = data[bindValue];
    
                   $("input:radio[name=dsnSetCd][value=" + value + "]").trigger('click');
               }
           };
           
           var SimplePayPopupUtil = {
               layerOpen:function(obj) {
                   Dmall.LayerPopupUtil.open($('#'+$(obj).attr('data-layer-type')+'Layer'));
               }
           };
           
           var SimpleRenderUtil = {
               render:function(simpPgCd) {
                   var url = '/admin/setup/config/payment/simplepayment-config',
                   param = {'simpPgCd':simpPgCd === '' ? '41' : simpPgCd},
                   dfd = jQuery.Deferred();
                   
                   Dmall.AjaxUtil.getJSON(url, param, function(result) {
                       if (result == null || result.success != true) {
                           return;
                       }

                       dfd.resolve(result.data);
                       if(result.data != null) {
                           SimpleRenderUtil.bind(result.data);
                           SimplePayUtil.useHandler(result.data.simplepayUseYn);
                       }
                   });
                   return dfd.promise();
               }
               , bind:function(data) {
                   $('[data-find="simple_config"]').DataBinder(data);
                   SimplePayInitUtil.init();
               }
           };
           
           var SimpleSubmitUtil = {
               submit:function() {
                   if(Dmall.validate.isValid('form_simple_config')) {
                       var url = '/admin/setup/config/payment/simplepayment-config-update'
                           , param = $('#form_simple_config').serialize();
                       Dmall.AjaxUtil.getJSON(url, param, function(result) {
                           Dmall.validate.viewExceptionMessage(result, 'form_simple_config');
                           if (result == null || result.success != true) {
                               return;
                           } else {
                               SimpleRenderUtil.render('');
                           }
                       });
                   }
               }
           };
       </script>
    </t:putAttribute>

    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">간편 결제 서비스 설정</h2>
                <div class="btn_box right">
                    <a href="#none" id="btn_save" class="btn blue shot">저장하기</a>
                </div>
            </div>
            <form id="form_simple_config" method="post">
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3">간편 결제 서비스 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 간편 결제 서비스 표 입니다. 구성은 서비스 사용여부, 간편결제 업체 선택 입니다.">
                        <caption>간편 결제 서비스</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>서비스 사용여부</th>
                                <td id="td_simplepayUseYn" data-find="simple_config" data-bind-value="simplepayUseYn" data-bind-type="function" data-bind-function="SimplePayInitUtil.setSimplepayUseYn">
                                    <label for="rdo_simplepayUseYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="simplepayUseYn" id="rdo_simplepayUseYn1" value="Y"></span> 사용</label>
                                    <label for="rdo_simplepayUseYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="simplepayUseYn" id="rdo_simplepayUseYn2" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                            <tr class="tr-simple-pg-cd">
                                <th>간편결제 업체 선택</th>
                                <td id="td_simpPgCd" data-find="simple_config" data-bind-value="simpPgCd" data-bind-type="function" data-bind-function="SimplePayInitUtil.setSimpPgCd">
                                    <label for="rdo_simpPgCd1" class="radio mr20"><span class="ico_comm"><input type="radio" name="simpPgCd" id="rdo_simpPgCd1" value="41"></span> PAYCO</label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
    
                <h3 class="tlth3">간편 결제 서비스 연동 설정 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 간편 결제 서비스 연동 설정 표 입니다. 구성은 서비스 선택, 사용설정, 서비스 설정 입니다.">
                        <caption>간편 결제 서비스 연동 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>서비스 선택</th>
                                <td id="td_simpPgTypeCd" data-find="simple_config" data-bind-value="simpPgTypeCd" data-bind-type="function" data-bind-function="SimplePayInitUtil.setSimpPgTypeCd">
                                    <!-- 간편구매+간편결제는 사용하지 않기로 합의되었으나 일단 그냥둔다 -->
                                    <!-- <label for="rdo_simpPgTypeCd1" class="radio mr20"><span class="ico_comm"><input type="radio" name="simpPgTypeCd" id="rdo_simpPgTypeCd1" value="1001"></span> PAYCO 간편구매+ 간편결제</label> -->
                                    <label for="rdo_simpPgTypeCd2" class="radio mr20"><span class="ico_comm"><input type="radio" name="simpPgTypeCd" id="rdo_simpPgTypeCd2" value="1002"></span> PAYCO간편결제</label>
                                </td>
                            </tr>
                            <tr>
                                <th>사용설정</th>
                                <td id="td_useSetCd" data-find="simple_config" data-bind-value="useSetCd" data-bind-type="function" data-bind-function="SimplePayInitUtil.setUseSetCd">
                                    <label for="rdo_useSetCd1" class="radio mr20"><span class="ico_comm"><input type="radio" name="useSetCd" id="rdo_useSetCd1" value="0"></span> 테스트하기</label>
                                    <label for="rdo_useSetCd2" class="radio mr20"><span class="ico_comm"><input type="radio" name="useSetCd" id="rdo_useSetCd2" value="1"></span> 실제 사용하기</label>
                                </td>
                            </tr>
                            <tr>
                                <th>서비스 설정</th>
                                <td>
                                    <!-- tblw_p -->
                                    <div class="tblw_p">
                                        <table summary="">
                                            <caption></caption>
                                            <colgroup>
                                                <col width="20%">
                                                <col width="80%">
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th>가맹점코드</th>
                                                    <td><span class="intxt wid100p"><input type="text" id="frcCd" name="frcCd" data-find="simple_config" data-bind-value="frcCd" data-bind-type="text" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>상점ID</th>
                                                    <td><span class="intxt wid100p"><input type="text" id="storeId" name="storeId" data-find="simple_config" data-bind-value="storeId" data-bind-type="text" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span></td>
                                                </tr>
                                                <tr>
                                                    <th>상점PW</th>
                                                    <td><span class="intxt wid100p"><input type="text" id="storePw" name="storePw" data-find="simple_config" data-bind-value="storePw" data-bind-type="text" maxlength="50" data-validation-engine="validate[maxSize[50]]"></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- //tblw_p -->
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                
                <h3 class="tlth3">간편 결제 서비스 이용 설정 </h3>
                <!-- tblw -->
                <div class="tblw tblmany">
                    <table summary="이표는 간편 결제 서비스 이용 설정 표 입니다. 구성은 이용 영역선택, 디자인 선택 입니다.">
                        <caption>간편 결제 서비스 이용 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>이용 영역선택</th>
                                <td id="td_useAreaCd" data-find="simple_config" data-bind-value="useAreaCd" data-bind-type="function" data-bind-function="SimplePayInitUtil.setUseAreaCd">
                                    <label for="rdo_useAreaCd0" class="radio mr20"><span class="ico_comm"><input type="radio" name="useAreaCd" id="rdo_useAreaCd0" value="0"></span> PC+모바일</label>
                                    <label for="rdo_useAreaCd1" class="radio mr20"><span class="ico_comm"><input type="radio" name="useAreaCd" id="rdo_useAreaCd1" value="1"></span> PC</label>
                                    <label for="rdo_useAreaCd2" class="radio mr20"><span class="ico_comm"><input type="radio" name="useAreaCd" id="rdo_useAreaCd2" value="2"></span> 모바일</label>
                                </td>
                            </tr>
                            <tr>
                                <th>디자인 선택</th>
                                <td id="td_dsnSetCd" data-find="simple_config" data-bind-value="dsnSetCd" data-bind-type="function" data-bind-function="SimplePayInitUtil.setDsnSetCd">
                                    <label for="rdo_dsnSetCd1" class="radio mr20">
                                        <span class="ico_comm"><input type="radio" name="dsnSetCd" id="rdo_dsnSetCd1" value="01"></span>
                                        <img src="/admin/img/set/easypay_a1.png" class="vtam" alt="PAYCO 간편결제">
                                    </label>
                                    <label for="rdo_dsnSetCd2" class="radio mr20">
                                        <span class="ico_comm"><input type="radio" name="dsnSetCd" id="rdo_dsnSetCd2" value="02"></span>
                                        <img src="/admin/img/set/easypay_a2.png" class="vtam" alt="PAYCO 간편결제">
                                    </label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
            </form>
        </div>
    </t:putAttribute>
</t:insertDefinition>