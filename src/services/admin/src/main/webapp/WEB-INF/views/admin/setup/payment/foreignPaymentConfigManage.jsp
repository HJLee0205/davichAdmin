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
 <t:putAttribute name="title">홈 &gt; 설정 &gt; 결제관리 &gt; 해외 결제 설정</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function() {
                ForeignInitUtil.init();
                ForeignRenderUtil.render();

                $('#btn_save').off('click').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    ForeignSubmitUtil.submit();
                });
                
                //사용여부 클릭시 이벤트
                $("input:radio[name=frgPaymentYn]").on('change', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    ForeignInitUtil.textBoxHandler($(this).val());
                });
                
                Dmall.validate.set('form_foreign_config');
            });
            
            var ForeignInitUtil = {
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
                , setFrgPaymentYn:function(data, obj, bindName, target, area, row) {
                    var bindValue = obj.data("bind-value")
                        , value = data[bindValue];
     
                    $("input:radio[name=frgPaymentYn][value=" + value + "]").trigger('click');
                    /* $("input:radio[name=frgPaymentYn][value=" + value + "]").parent().parent().addClass('on');
                    $("input:radio[name=frgPaymentYn][value=" + value + "]").prop('checked', true); */
                }
                , textBoxHandler:function(value) {
                    value === 'Y' ? $('.tr-text').show() : $('.tr-text').hide();
                }
            };
            
            var ForeignRenderUtil = {
                render:function() {
                    var url = '/admin/setup/config/payment/foreignpayment-config-info',
                    dfd = jQuery.Deferred();
                    
                    Dmall.AjaxUtil.getJSON(url, {}, function(result) {
                        if (result == null || result.success != true) {
                            return;
                        }
                        
                        dfd.resolve(result.data);
                        ForeignRenderUtil.bind(result.data);
                    });
                    return dfd.promise();
                }
                , bind:function(data) {
                    //사용안함설정이면 textbox가 보이지 않도록
                    ForeignInitUtil.textBoxHandler(data.frgPaymentYn);
                    //데이터 매핑
                    $('[data-find="foreign_config"]').DataBinder(data);
                }
            };
            
            var ForeignSubmitUtil = {
                submit:function() {
                    if(Dmall.validate.isValid('form_foreign_config')) {
                        var url = '/admin/setup/config/payment/foreignpayment-config-update',
                        param = jQuery('#form_foreign_config').serialize();
    
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_foreign_config');
                            
                            if (result == null || result.success != true) {
                                return;
                            } else {
                                ForeignRenderUtil.render();
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
                <h2 class="tlth2">해외 결제 설정</h2>
                <div class="btn_box right">
                    <a href="#none" id="btn_save" class="btn blue shot">저장하기</a>
                </div>
            </div>
            <form id="form_foreign_config" method="post">
            <!-- line_box -->
            <div class="line_box fri">
                <h3 class="tlth3 btn1">
                    Paypal 설정                     <div class="right">
                        <a href="https://www.paypal.com/kr/home?locale.x=ko_KR" class="btn_gray2" target="_blank">Paypal 바로가기</a>
                    </div>
                </h3>
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 Paypal 설정 표 입니다. 구성은 PG사, 상점 ID, 키 패스워드 입니다.">
                        <caption>Paypal 설정</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>PG사</th>
                                <td>PAYPAL</td>
                            </tr>
                            <tr>
                                <th>사용여부</th>
                                <td id="td_frgPaymentYn" data-find="foreign_config" data-bind-value="frgPaymentYn" data-bind-type="function" data-bind-function="ForeignInitUtil.setFrgPaymentYn">
                                    <label for="rdo_frgPaymentYn1" class="radio mr20"><span class="ico_comm"><input type="radio" name="frgPaymentYn" id="rdo_frgPaymentYn1" value="Y"></span> 사용</label>
                                    <label for="rdo_frgPaymentYn2" class="radio mr20"><span class="ico_comm"><input type="radio" name="frgPaymentYn" id="rdo_frgPaymentYn2" value="N"></span> 사용안함</label>
                                </td>
                            </tr>
                            <tr class="tr-text">
                                <th>상점 ID</th>
                                <td><span class="intxt long"><input type="text" id="frgPaymentStoreId" name="frgPaymentStoreId" data-find="foreign_config" data-bind-value="frgPaymentStoreId" data-bind-type="text" maxlength="200" data-validation-engine="validate[maxSize[200]]"></span></td>
                            </tr>
                            <tr class="tr-text">
                                <th>키 패스워드</th>
                                <td><span class="intxt long"><input type="text" id="frgPaymentPw" name="frgPaymentPw" data-find="foreign_config" data-bind-value="frgPaymentPw" data-bind-type="text" maxlength="200" data-validation-engine="validate[maxSize[200]]"></span></td>
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