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
    <t:putAttribute name="title">본인확인 인증 서비스</t:putAttribute>
    <t:putAttribute name="script">
      <script type="text/javascript">
        jQuery(document).ready(function() {
            
            fn_get_Info();
            
            jQuery('#a_upload_pvc').off('click').on('click', function(e) {
                Dmall.LayerPopupUtil.open(jQuery('#layer_id_admin'));
            });
            
            jQuery('#a_id_upload').off('click').on('click', function (e) {
                Dmall.EventUtil.stopAnchorAction(e);

                if(Dmall.FileUpload,checkFileSize('fileUploadForm')) {
                    jQuery.when(FileUpload.upload('fileUploadForm')).then(function (result) {
                        var file = result.files[0] || null;
                        if (file) {
                            jQuery('#div_id_download').html('<a class="btn_red" href="/admin/common/common-download?' + jQuery.param(file) + '">다운로드</a>');
                        }
                    });
                }
            });
            
            jQuery('#btn_save').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                fn_save();
            });
            
            $('label.radio').off('click').on('click', function(e) {
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
                var target = $input.data('class');
                if ('N' === $input.data('input-value')) {
                    $('input:text.' + target ).prop('disabled', true).val('');
                    $('input:checkbox.' + target ).each(function() { 
                        $(this).prop('disabled', true).prop('checked', false);
                        $('#lb_' + $(this).attr('id')).removeClass('on');
                    });
                } else {
                    $('input:text.' + target ).each(function() { 
                        $(this).prop('disabled', false).val($(this).data('prev_value'));
                    });
                    $('input:checkbox.' + target ).each(function() { 
                        $(this).prop('disabled', false);
                        if ('Y' === $(this).data('prev_value')) {
                            $(this).prop('checked', true); 
                            $('#lb_' + $(this).attr('id')).addClass('on');
                        }
                    });
                }
            });
            
            // Valicator 셋팅
            Dmall.validate.set('form_person_certify_info');
        });
        
         function fn_set_result(idx, data) {
             $('[data-find="person_certify_info_' + idx + '"]').DataBinder(data);
             var target = 'certify_info_' + idx;
             if ('N' === data['useYn']) {
                 $('input:text.' + target ).prop('disabled', true).val('');
                 $('input:checkbox.' + target ).each(function() { 
                     $(this).prop('disabled', true).prop('checked', false);
                     $('#lb_' + $(this).attr('id')).removeClass('on');
                 });
             }
         }
         
         function fn_get_Info() {
             var url = '/admin/setup/personcertify/personcertify-config-list',
             param = '';
             
             Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if (result && result.success === true && result.resultList && result.resultList.length > 0) {
                     jQuery.each(result.resultList, function(idx, obj) {
                         fn_set_result(idx, obj);
                     });                     
                 } else {
                     var initObj = {
                             'useYn':'N',
                             'siteCd':'',
                             'sitePw':'',
                             'memberJoinUseYn':'N',
                             'pwFindUseYn':'N',
                             'dormantmemberCertifyUseYn':'N',
                             'adultCertifyAccessUseYn':'N'
                     };
                     $('[data-find=person_certify_info_0]').DataBinder(initObj);
                     $('[data-find=person_certify_info_1]').DataBinder(initObj);
                 }
                 
             });
         }

         function setUseYn(data, obj, bindName, target, area, row) {
             var value = obj.data("bind-value")
                 , useYn = data[value]
                 , $label = jQuery('label', obj)
                 , $input = jQuery('input', obj);

             // 체크박스 값 설정
             if (useYn && 'Y' == useYn) {
                 $label.addClass('on');;
                 $input.data('prev_value', 'Y').prop('checked', true); 
             } else {
                 $label.removeClass('on');
                 $input.data('prev_value', 'N').prop('checked', false); 
             }
             // 체크박스 이벤트 설정
              $label.off('click').on('click', function(e) {
                 Dmall.EventUtil.stopAnchorAction(e);
                 
                 if ( $input.prop('disabled') ) {
                     return false;
                 } 
                 
                 var checked = !($input.prop('checked'));
                 $input.prop('checked', checked);

                 $label.toggleClass('on');
             })
         }
         
         function setUseYnRdo(data, obj, bindName, target, area, row) {
             var value = obj.data("bind-value")
             , useYn = data[value]
             , objValue = obj.data("input-value")
             , $label = jQuery(obj.closest('label'))
             , $input = jQuery(obj);

             // 체크박스 값 설정
             if (useYn && objValue == useYn) {
                 $label.trigger('click'); 
             }
         }         
         
         function fn_save() {
             if(Dmall.validate.isValid('form_id_regist')) {
                 var url = '/admin/setup/personcertify/personcertify-config-update',
                 param = {},
                 key,
                 $tbody = $("#tbody_setup_data");
                 
                 if(Dmall.validate.isValid('form_person_certify_info')) {
                     var useYn0 = $('input:radio[name=useYn_0]:checked', '#tbody_setup_data').val();
                     var useYn1 = $('input:radio[name=useYn_1]:checked', '#tbody_setup_data').val();
                     
                     if (!useYn0) {
                         Dmall.LayerUtil.alert('아이핀 인증 사용여부를 설정해 주세요.');
                         return false;
                     } else if ('Y' === useYn0) {
                         var siteCd1 = $('#txt_site_cd_1').val()
                           , sitePw1 = $('#txt_site_pw_1').val();
                         if(!siteCd1 || siteCd1.trim() == '') {
                             Dmall.LayerUtil.alert('사이트 코드를 입력해 주십시요.');
                             $('#txt_site_cd_1').focus();
                             return false;
                         }
                         if(!sitePw1 || sitePw1.trim() == '') {
                             Dmall.LayerUtil.alert('사이트 패스워드를 입력해 주십시요.');
                             $('#txt_site_pw_1').focus();
                             return false;
                         } 
                     }
                     setParamData(0, $tbody, param);
                     
                     if (!useYn1) {
                         Dmall.LayerUtil.alert('휴대폰 인증 사용여부를 설정해 주세요.');
                         return false;
                     } else if ('Y' === useYn1) {
                         if ('Y' === $('input:radio[name=useYn_1]:checked', '#tbody_setup_data').val()) {
                             var siteCd2 = $('#txt_site_cd_2').val()
                               , sitePw2 = $('#txt_site_pw_2').val();
                             if(!siteCd2 || siteCd2.trim() == '') {
                                 Dmall.LayerUtil.alert('사이트 코드를 입력해 주십시요.');
                                 $('#txt_site_cd_2').focus();
                                 return false;
                             }
                             if(!sitePw2 || sitePw2.trim() == '') {
                                 Dmall.LayerUtil.alert('사이트 패스워드를 입력해 주십시요.');
                                 $('#txt_site_pw_2').focus();
                                 return false;
                             }
                         }
                     }
                     setParamData(1, $tbody, param);
                     Dmall.AjaxUtil.getJSON(url, param, function(result) {
                         Dmall.validate.viewExceptionMessage(result, 'form_person_certify_info');
                         
                         if (result == null || result.success != true) {
                             return;
                         } else {
                             fn_get_Info();
                         }
                     });
                 }
             }                
             return false;
         }
         
         function setParamData(idx, $tbody, param) {
             var data = $(".certify_info_"+idx, $tbody).UserInputBinderGet();
             for (var prop in data) {
                 var key = 'list[' + idx + '].'+ prop;
                 if (prop == 'useYn_' + idx) {
                     param['list[' + idx + '].useYn'] = data[prop];
                 } else {
                     param[key] = data[prop];
                 }
             }             
         }
      </script>
   </t:putAttribute>
    
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">본인확인 인증 서비스</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="btn_save">저장하기</a>
            </div>
        </div>
        
        <form:form id="form_person_certify_info">
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">휴대폰/아이핀 인증 설정 및 사용</h3>
            <!-- tblh -->
            <div class="tblh th_l tblmany">
                <table summary="이표는 휴대폰/아이핀 인증 설정 및 사용 표 입니다. 구성은 본인확인, 서비스계약코드 등록, 회원가입, 비밀번호 찾기, 휴면회원인증, 성인 전용 상품 접근 시 인증(휴대폰 인증, 아이핀인증) 입니다.">
                    <caption>휴대폰/아이핀 인증 설정 및 사용</caption>
                    <colgroup>
                        <col width="12%">
                        <col width="13%">
                        <col width="15%">
                        <col width="15%">
                        <col width="15%">
                        <col width="15%">
                        <col width="15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>본인확인</th>
                            <th colspan="2">서비스계약코드 등록</th>
                            <th>회원가입/개인정보수정</th>
                            <th>아이디찾기/비밀번호찾기</th>
                            <th>휴면회원인증</th>
                            <th>성인 전용 상품<br>접근 시 인증</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_setup_data">
                        <tr id="tr_setup_data_0">
                            <th rowspan="2" class="certify_info_0" data-input-type="radio" data-input-name="useYn_0">
                                아이핀 인증
                                <span class="br2"></span>
                                <label for="rdo_useYn_0_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn_0" id="rdo_useYn_0_Y" value="Y" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="useYn" data-bind-function="setUseYnRdo" data-class="certify_info_0" data-input-value="Y"></span> 사용</label>
                                <label for="rdo_useYn_0_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn_0" id="rdo_useYn_0_N" value="N" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="useYn" data-bind-function="setUseYnRdo" data-class="certify_info_0" data-input-value="N"></span> 미사용</label>
                            </th>

                            <td>사이트코드
                                <input type="hidden" name="siteNo" id="hd_01_0" value="" data-find="person_certify_info_0" data-bind-type="text" data-bind-value="siteNo" 
                                       data-input-type="text" data-input-name="siteNo" class="certify_info_0" />
                                <input type="hidden" name="certifyTypeCd" id="hd_01_1" value="01" data-bind-type="text"
                                       data-input-type="text" data-input-name="certifyTypeCd" class="certify_info_0" />
                            </td>
                            <td><span class="intxt wid100p">
                                <input type="text" name="siteCd_0" id="txt_site_cd_1"  data-find="person_certify_info_0" data-bind-type="text" data-bind-value="siteCd" 
                                       data-input-type="text" data-input-name="siteCd" class="certify_info_0" maxlength="50" data-validation-engine="maxSize[50]]">
                            </span></td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="memberJoinUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="memberJoinUseYn" id="chack01_1" class="blind certify_info_0" data-input-type="checkbox" data-input-name="memberJoinUseYn">
                                <label id="lb_chack01_1" for="chack01_1" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="pwFindUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="pwFindUseYn" id="chack01_2" class="blind certify_info_0" data-input-type="checkbox" data-input-name="pwFindUseYn">
                                <label id="lb_chack01_2" for="chack01_2" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="dormantmemberCertifyUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="dormantmemberCertifyUseYn" id="chack01_3" class="blind certify_info_0" data-input-type="checkbox" data-input-name="dormantmemberCertifyUseYn">
                                <label id="lb_chack01_3" for="chack01_3" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_0" data-bind-value="adultCertifyAccessUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="adultCertifyAccessUseYn" id="chack01_4" class="blind certify_info_0"  data-input-type="checkbox" data-input-name="adultCertifyAccessUseYn">
                                <label id="lb_chack01_4" for="chack01_4" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="line_l">사이트<br>패스워드</td>
                            <td><span class="intxt wid100p">
                                <input type="text" name="sitePw_0"  id="txt_site_pw_1" data-find="person_certify_info_0" data-bind-type="text" data-bind-value="sitePw" 
                                       data-input-type="text" data-input-name="sitePw" class="certify_info_0" maxlength="50" data-validation-engine="validate[maxSize[50]]">
                            </span></td>
                        </tr>
                        <tr id="tr_setup_data_1">
                            <th rowspan="2" class="certify_info_1" data-input-type="radio" data-input-name="useYn_1">
                                휴대폰 인증
                                <span class="br2"></span>
                                <label for="rdo_useYn_1_Y" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn_1" id="rdo_useYn_1_Y" value="Y" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="useYn" data-bind-function="setUseYnRdo" data-class="certify_info_1" data-input-value="Y"></span> 사용</label>
                                <label for="rdo_useYn_1_N" class="radio mr20"><span class="ico_comm"><input type="radio" name="useYn_1" id="rdo_useYn_1_N" value="N" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="useYn" data-bind-function="setUseYnRdo" data-class="certify_info_1" data-input-value="N"></span> 미사용</label>
                            </th>
                            <td>사이트코드
                                <input type="hidden" name="siteNo" id="hd_02_0" value="" data-find="person_certify_info_1" data-bind-type="text" data-bind-value="siteNo" 
                                       data-input-type="text" data-input-name="siteNo" class="certify_info_1" />
                                <input type="hidden" name="certifyTypeCd" id="hd_02_1" value="02"
                                       data-input-type="text" data-input-name="certifyTypeCd" class="certify_info_1" />
                            </td>
                            <td><span class="intxt wid100p">
                                <input type="text" name="siteCd_1" id="txt_site_cd_2"  data-find="person_certify_info_1" data-bind-type="text" data-bind-value="siteCd" 
                                       data-input-type="text" data-input-name="siteCd" class="certify_info_1" >
                            </span></td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="memberJoinUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="memberJoinUseYn" id="chack03_1" value="Y" class="blind certify_info_1" data-input-type="checkbox" data-input-name="memberJoinUseYn">
                                <label id="lb_chack03_1"  for="chack03_1" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="pwFindUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="pwFindUseYn" id="chack03_2" class="blind certify_info_1" data-input-type="checkbox" data-input-name="pwFindUseYn">
                                <label id="lb_chack03_2" for="chack03_2" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="dormantmemberCertifyUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="dormantmemberCertifyUseYn" id="chack03_3" class="blind certify_info_1" data-input-type="checkbox" data-input-name="dormantmemberCertifyUseYn">
                                <label id="lb_chack03_3" for="chack03_3" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td rowspan="2" data-bind-type="function" data-find="person_certify_info_1" data-bind-value="adultCertifyAccessUseYn" data-bind-function="setUseYn">
                                <input type="checkbox" name="adultCertifyAccessUseYn" id="chack03_4" class="blind certify_info_1" data-input-type="checkbox" data-input-name="adultCertifyAccessUseYn">
                                <label id="lb_chack03_4" for="chack03_4" class="chack" >
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <td class="line_l">사이트<br>패스워드</td>
                            <td><span class="intxt wid100p">
                                <input type="text" name="sitePw_1" id="txt_site_pw_2" data-find="person_certify_info_1" data-bind-type="text" data-bind-value="sitePw" 
                                       data-input-type="text" data-input-name="sitePw" class="certify_info_1" >
                            </span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- //tblh -->
            <!-- //tblh -->
            <h3 class="tlth3 ">휴대폰/아이핀 인증 안내</h3>
            <ul class="tlt_list ">
                <li>- 휴대폰본인인증은 이름, 생년월일, 휴대폰 번호를 통해 본인확인을 할 수 있는 서비스입니다.</li>
                <li>- 아이핀은 주민번호 대신 본인확인기관이 공급하는 아이핀 ID/패스워드를 사용하여 본인확인을 할 수 있는 서비스입니다.</li>
            </ul>
            <h3 class="tlth3 mt20">휴대폰/아이핀 인증 서비스 계약 안내</h3>
            <ul class="tlt_list">
                <li>- 쇼핑몰 회원가입 시 본인확인(휴대폰본인인증, 아이핀) 절차를 거침으로써 양질의 회원정보를 보유한 쇼핑몰이 됩니다.<br> 이용 방법은 아래와 같습니다.</li>
            </ul>
            <div class="g_line_box">
                <h4>1. 휴대폰 인증 신청방법</h4>
                <ol>
                    <li>① 계약서류를 작성하여 드림시큐리티에 등기(우편) 발송 하세요.</li>
                    <li>② 드림시큐리티로부터 세팅정보를 받으시게 됩니다.</li>
                    <li>③ 위에 입력란에 세팅 정보를 입력 후 저장하면 쇼핑몰 본인인증이 필요한 서비스에 휴대폰 인증이 동작하게 됩니다.</li>
                </ol>
                <h4 class="mt20">2. 아이핀 인증 신청방법</h4>
                <ol>
                    <li>① 계약서류를 작성하여 나이스평가정보에 등기(우편) 발송 하세요.</li>
                    <li>② 나이스평가정보로부터 세팅정보를 받으시게 됩니다.</li>
                    <li>③ 위에 입력란에 세팅 정보를 입력 후 저장하면 쇼핑몰 본인인증이 필요한 서비스에 아이핀 인증이 동작하게 됩니다.</li>
                </ol>
                <span class="point_c3"><br/>참고: 아이디패스워드 찾기 시 인증을 통해 가입한 회원은 해당 인증 수단을 통해 찾을 수 있습니다.</span>
                
            </div>
        </div>
        <!-- //line_box -->
        </form:form>
    </div>

        
    </t:putAttribute>
</t:insertDefinition>