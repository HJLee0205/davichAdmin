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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 기본관리 &gt; 택배연동설정</t:putAttribute>
    <t:putAttribute name="script">
      <script type="text/javascript">
        jQuery(document).ready(function() {
            
            $( "#accordion-1" ).accordion({
                active: false,
                autoHeight: true,
                collapsible: true,
                heightStyle: "content"
            });
            
            jQuery('#btn_setup_service_1').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                if (!$('#tb_16').is(':visible')) { 
                    fn_get_Info('16');          // 우체국 '16'
                }
                $('#tab_setup_service_1').trigger('click');
            });
            
            jQuery('#btn_setup_service_2').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                if (!$('#tb_05').is(':visible')) { 
                    fn_get_Info('05');          // CJ택배 '05'
                }
                $('#tab_setup_service_2').trigger('click');
            });
            
            jQuery('#btn_confirm').off("click").on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);

                var code = $('div[data-role=collapsible]:visible' , '#accordion-1').data('bind-value');
                if (!code) {
                    return false;
                }

                if(Dmall.validate.isValid('form_info_' + code)) {
                    var url = '/admin/setup/deliveryInteface/delivery-interface-update',
                    
                        // param = jQuery('#form_info_' + code).serialize();
                    param = jQuery('[data-find=courier_interface_'+ code +']','#form_info_' + code).UserInputBinderGet();
                    
                    if ( $('input:radio[data-bind-value=linkUseYn]:visible:checked').val() === 'Y'
                            && (!'privacyClctApplyYn' in param || 'Y' !== param['privacyClctApplyYn'] 
                         || !'privacyUseApplyYn' in param || 'Y' !== param['privacyUseApplyYn'])) {
                        // Dmall.LayerUtil.alert('개인정보 제공동의 안내 약관에 동의해주세요. 동의하지 않으시면 서비스 신청이 불가합니다.');
                        Dmall.LayerUtil.alert('<spring:message code="biz.exception.setup.delivery.check.apply"/>');
                        return;
                    }
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_info_' + code);
                        
                        if (result == null || result.success != true) {
                            return;
                        } else {
                            fn_get_Info(code);
                        }
                    });
                }
                return false;                
            });
            
            jQuery('a.privacyClctApplyYn, a.privacyUseApplyYn').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                if ('Y' === $('input:radio[data-bind-value=linkUseYn]:visible:checked').val()){
                    $div = $('#' + $(this).attr('for'));
                    if ($div.is(":visible")) {
                        $div.slideUp('fals', function() {
                            $div.closest("tr.acd_con2").slideUp(100, function() {});
                        });
                    } else {
                        $div.closest("tr.acd_con2").slideDown(100, function() {});
                        $div.slideDown('fast', function() {});
                    }
                };
            });
            
            jQuery('#btn_view_service_1').off('click').on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                Dmall.LayerUtil.confirm('우체국 택배 연계 정보 페이지로 이동 하시겠습니까?', fn_linkUrl1);
            });
            
            jQuery('#sel_email2_16').change(function(){
                var domain = $(this).val()
                    prev_value = $('#txt_email2_16').data("prev_value") ? $('#txt_email2_16').data('prev_value') : '';
                if (domain == '') {
                    $('#txt_email2_16').removeAttr("readonly").val(prev_value).focus();
                } else {
                    $('#txt_email2_16').attr("readonly","readonly").val(domain);
                }
            })
            
            jQuery('input[readonly]').focus(function(){
                this.blur();
            });
            
            /*
            jQuery('#btn_post').off("click").on('click', function(e) {
                Dmall.EventUtil.stopAnchorAction(e);
                Dmall.LayerPopupUtil.zipcode(setZipcode);
            });
            */
           
            Dmall.common.numeric();
            Dmall.common.decimal();
            Dmall.common.phoneNumber();
        });
        
        // 우체국 사이트 바로가기 클릭 이벤트
        function fn_linkUrl1() {
            var path = 'http://biz.epost.go.kr/';
            window.open(path,'','');
            return false;
        }       
        
        function setZipcode(data) {
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('input[name=post]:visible').val(data.zonecode); //5자리 새우편번호 사용
            $('input[name=addrNum]:visible').val(data.jibunAddress);
            // $('#txt_company_addr2').val(data.roadAddress);
            $('input[name=addrCmnDtl]:visible').val('').focus();
        }

        // 검색결과 바인딩 
        function fn_set_result(data, courierCd) {
            var telNo = 'telNo' in data && data['telNo'] ? data['telNo'] : ''
                telNoArr = telNo.split('-')
                email = 'email' in data && data['email'] ? data['email'] : ''
                emailArr = email.split('@')
                ;
            
            data['telNo1'] = telNoArr[0];
            data['telNo2'] = telNoArr[1];
            data['telNo3'] = telNoArr[2];
            data['email1'] = emailArr[0];
            data['email2'] = emailArr[1];
            
            $('[data-find="courier_interface_' + courierCd + '"]').DataBinder(data);
            
            var useYn = $('input:radio[data-bind-value=linkUseYn]:visible:checked').val();
            if (!useYn){
                $('label[for=linkUseYn_'+ courierCd + '_Y]').trigger('click');
            }
            if ('N' === useYn) {
                $('label[for=linkUseYn_'+ courierCd + '_N]').trigger('click');
            }
            Dmall.validate.set('form_info_' + courierCd)
        }

        //택배사 연동 설정 정보 조회 
        function fn_get_Info(courierCd) {
            var url = '/admin/setup/deliveryInteface/delevery-interface',
            param = { 'courierCd' : courierCd },
            dfd = jQuery.Deferred();
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if (result == null || result.success != true) {
                    return;
                }
                // 결과 바인딩 호출
                fn_set_result(result.data, courierCd);                
                dfd.resolve(result.resultList);
                
            });
            return dfd.promise();
        }
        
        function setMailDomain(data, obj, bindName, target, area, row) {
            var mailDomain = data["email2"];
            if ( mailDomain ) {
                var label = $("option[value='"+ mailDomain +"']", obj).attr("selected", true).text()
                  , $label = obj.siblings('label').text(label);
               
                if(!label || label.trim().length < 1) {
                    var label = $('option:first', obj).attr('selected', true).text();
                    obj.siblings('label').text(label);
                }
                
            }  
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

            // 라디오 값 설정
            if (useYn && objValue == useYn) {
                $label.addClass('on');;
                $input.prop('checked', true); 
            } else {
                $label.removeClass('on');;
                $input.prop('checked', false); 
            }
            
            // 체크박스 이벤트 설정
             $label.off('click').on('click', function(e) {
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
                    $('input:text[data-find=' + target + ']').prop('disabled', true).val('');
                    $('input:checkbox[data-find=' + target + ']').each(function() { 
                        $(this).prop('disabled', true).prop('checked', false);
                        $('#lb_' + $(this).attr('id')).removeClass('on');
                    });
                } else {
                    $('input:text[data-find=' + target + ']').each(function() {
                        var $this = $(this);
                        $this.val($(this).data('prev_value'));
                        if ($this.hasClass('editable')) {
                            $this.prop('disabled', false);
                        }
                    });
                    $('input:checkbox[data-find=' + target + ']').each(function() { 
                        $(this).prop('disabled', false);
                        if ('Y' === $(this).data('prev_value')) {
                            $(this).prop('checked', true); 
                            $('#lb_' + $(this).attr('id')).addClass('on');
                        }
                    });
                }
            });
        } 
      </script>
   </t:putAttribute>
    
    <t:putAttribute name="content">
    <div class="sec01_box">
        <div class="tlt_box">
            <h2 class="tlth2">택배연동설정 </h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="btn_confirm">저장하기</a>
            </div>            
        </div>
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">택배 연동서비스</h3>
            <ul class="tlt_list">
                <li>- “택배의 고품질 택배 서비스”쇼핑몰 운영에서 뗄 수 없는 배송 업무를 택배 연동 서비스를 이용하여 쉽고 편리하게 진행할 수 있습니다.</li>
                <li>- 배송할 제품의 송장번호와 배송상태가 자동으로 입력되고, 변경되어 배송업무의 번거로움을 줄여 업무의 효율성을 높일 수 있습니다.</li>
            </ul>

            <div class="step_lay">   
                <ul class="pgsa_box">
                    <li class="pgsa">
                        <div>
                            <span class="logo"><img src="/admin/img/set/post_logo.png" alt="우체국택배"></span>
                            <p>우체국택배</p>
                            <ul class="info">
                                <li>· 대표전화 : 0000-0000</li>
                                <li>· FAX : 050-4984-9901</li>
                            </ul>
                            <div class="btn">
                                <a href="#none" class="btn_blue" id="btn_setup_service_1">서비스 신청하기</a>
                                <a href="#none" class="btn_gray" id="btn_view_service_1">사이트 바로가기</a>                                
                            </div>
                        </div>
                    </li>
                </ul>
            </div>

    <div id="accordion-1">
        <h3 style="display:none;"id="tab_setup_service_1">Tab 1</h3>
            <div id="div_post_service" data-role="collapsible" data-bind-value="16">
            <form id="form_info_16">
                <input type="hidden" name="courierCd" value="16" data-find="courier_interface_16" data-input-type="text" data-input-name="courierCd"/>
                <input type="hidden" name="linkApplyStatus" data-find="courier_interface_16" data-bind-type="text" data-bind-value="linkApplyStatus" data-input-type="text" data-input-name="linkApplyStatus" />
                <h3 class="tlth3 mt20">우체국택배 서비스 절차</h3>
                <div class="step_lay">
                    <ul class="step_img post">
                        <li class="step_arrow"><img src="/admin/img/set/post_step01.png" alt="step 1 지역우체국 기업택배 계약(계약신청서 작성)"></li>
                        <li class="step_arrow"><img src="/admin/img/set/post_step02.png" alt="step 2 고객번호 10자리 발급"></li>
                        <li class="step_arrow"><img src="/admin/img/set/post_step03.png" alt="step 3 우체국 사업자 회원가입"></li>
                        <li><img src="/admin/img/set/post_step04.png" alt="step 4 관리자페이지 우체국 택배 연동 신청"></li>
                    </ul>
                </div>  
                <h3 class="tlth3">우체국택배 연동서비스</h3>

                <!-- tblw -->
                <div class="tblw tblmany mb0">
                    <table id="tb_16" summary="이표는 우체국택배 연동서비스 표 입니다. 구성은 쇼핑몰 도메인, 우체국회원ID, 우체국 회원 비밀번호, 우체국 고객번호, 계약우체국명, 상호명, 대표자명, 사업자 번호, E-MAIL, 전화번호, 휴대폰번호, 주소, 라벨프린터 입니다.">
                       <caption>우체국택배 연동서비스</caption>
                       <colgroup>
                            <col width="16%">
                            <col width="32%">
                            <col width="14%">
                            <col width="38%">
                        </colgroup>
                        <tbody>
                           <tr>
                               <th>사용여부</th>
                               <td colspan="3" data-find="courier_interface_16" data-input-type="radio" data-input-name="linkUseYn" >
                                   <label for="linkUseYn_16_N" class="radio mr20"><span class="ico_comm">
                                       <input type="radio" name="linkUseYn" id="linkUseYn_16_N" value="N"
                                       data-input-value="N" data-bind-type="function" data-find="courier_interface_16" data-bind-value="linkUseYn" data-bind-function="setUseYnRdo" data-class="courier_interface_16">
                                   </span> 사용안함</label>
                                   <label for="linkUseYn_16_Y" class="radio mr20"><span class="ico_comm">
                                       <input type="radio" name="linkUseYn" id="linkUseYn_16_Y" value="Y"
                                       data-input-value="Y" data-bind-type="function" data-find="courier_interface_16" data-bind-value="linkUseYn" data-bind-function="setUseYnRdo" data-input-value="Y" data-class="courier_interface_16">
                                   </span> 사용함</label>
                               </td>
                            </tr>
                            <tr>
                                <th>우체국회원ID</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_linkId_16" class="editable" data-find="courier_interface_16" data-bind-type="text" data-bind-value="linkId" maxlength="50" 
                                    data-input-type="text" data-input-name="linkId" data-validation-engine="validate[required, maxSize[50]]">
                                </span></td>
                                <th>우체국 회원 <br>비밀번호</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_linkPw_16" class="editable" data-find="courier_interface_16" data-bind-type="text" data-bind-value="linkPw" maxlength="50" 
                                    data-input-type="text" data-input-name="linkPw" data-validation-engine="validate[required, maxSize[50]]">
                                </span></td>
                            </tr>
                            <tr>
                                <th>우체국 고객번호</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_custno_16" class="editable" data-find="courier_interface_16" data-bind-type="text" data-bind-value="linkCustno" maxlength="20" 
                                    data-input-type="text" data-input-name="linkCustno" data-validation-engine="validate[required, maxSize[20]]">
                                </span></td>
                                <th>계약우체국명</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_contrtPtNm_16" class="editable" data-find="courier_interface_16" data-bind-type="text" data-bind-value="linkContrtPtNm" maxlength="50" 
                                    data-input-type="text" data-input-name="linkContrtPtNm" data-validation-engine="validate[maxSize[50]]">
                                </span></td>
                            </tr>
                            <tr>
                                <th>상호명</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_mtnm_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="companyNm" maxlength="50" data-validation-engine="validate[maxSize[50]]" readonly>
                                </span></td>
                                <th>대표자명</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_ceonm_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="ceoNm" maxlength="10" data-validation-engine="validate[maxSize[10]]" readonly>
                                </span></td>
                            </tr>
                            <tr>
                                <th>사업자 번호</th>
                                <td><span class="intxt wid100p">
                                    <input type="text" id="txt_bizno_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="bizNo" maxlength="14" data-validation-engine="validate[required, maxSize[14]]" readonly>
                                </span></td>
                                <th>E-MAIL</th>
                                <td>
                                    <span class="intxt shot">
                                        <input type="text" id="txt_email1_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="email1" maxlength="20" data-validation-engine="validate[maxSize[20]]" readonly>
                                    </span>
                                    @
                                    <span class="intxt shot">
                                        <input type="text" id="txt_email2_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="email2" maxlength="20" data-validation-engine="validate[maxSize[20]]" readonly>
                                    </span>
                                    <span class="select">
                                        <label for="sel_email2_16">직접입력</label>
                                        <select name="email2" id="sel_email2_16" data-find="courier_interface_16" data-bind-value="email2" data-bind-type="function" data-bind-function="setMailDomain" disabled="disabled">
                                            <option value="">직접입력</option>
                                            <tags:option codeStr="naver.com:naver.com;nate.com:nate.com;daum.net:daum.net;gmail.com:gmail.com;hotmail.com:hotmail.com" />
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>전화번호</th>
                                <td colspan="3">
                                    <span class="select">
                                        <label for="sel_telno_1_16" data-find="courier_interface_16" data-bind-type="labelselect" data-bind-value="telNo1">02</label>
                                        <select name="telno1" id="sel_telno_1_16" disabled="disabled">
                                            <option value="02">02</option>
                                            <tags:option codeStr="031:031;032:032;033:033;041:041;042:042;043:043;044:044;051:051;052:052;053:053;054:054;055:055;061:061;062:062;063:063;064:064;070:070;0130:0130;0505:0505" />
                                        </select>
                                    </span>
                                    <span class="intxt shot">
                                        <input type="text" id="txt_telno2_16" class="numeric" data-find="courier_interface_16" data-bind-type="text" data-bind-value="telNo2" maxlength="4" data-validation-engine="validate[maxSize[4]]" readonly>
                                    </span>
                                    -
                                    <span class="intxt shot">
                                        <input type="text" id="txt_telno3_16" class="numeric" data-find="courier_interface_16" data-bind-type="text" data-bind-value="telNo3" maxlength="4" data-validation-engine="validate[maxSize[4]]" readonly>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>주소</th>
                                <td colspan="3">
<!--                                     <span class="intxt shot">
                                        <input  type="text" name="post" id="txt_post_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="postNo" data-validation-engine="validate[maxSize[8]]" readonly>
                                    </span>
                                    <a href="#none" class="btn_gray" id="btn_post">우편번호</a>
                                    <span class="br"></span>
                                    <span class="intxt long2">
                                        <input name="addrNum" id="txt_addr_16" type="text" data-find="courier_interface_16" data-bind-type="text" data-bind-value="addrRoadnm" data-validation-engine="validate[maxSize[50]]" readonly>    
                                    </span>
                                    <span class="intxt long">
                                        <input name="addrCmnDtl" id="txt_dtladdr_16" type="text" maxlength="50" data-find="courier_interface_16" data-bind-type="text" data-bind-value="addrCmnDtl" data-validation-engine="validate[maxSize[50]]">
                                    </span> -->
                                    <div class="addr_field">
                                        <span class="intxt shot">
                                            <input  type="text" name="postNo" id="txt_post_16" data-find="courier_interface_16" data-bind-type="text" data-bind-value="postNo" data-validation-engine="validate[maxSize[8]]" readonly>
                                        </span>
                                        <a href="#none" class="btn_gray">우편번호</a>
                                        <span class="br"></span>
                                        <label for="" class="in_long"><strong>지번</strong> <span class="intxt">
                                            <input name="addrNum" id="txt_company_addr1_16" type="text" data-find="courier_interface_16" data-bind-type="text" data-bind-value="addrNum" data-validation-engine="validate[maxSize[50]]" readonly>
                                        </span></label>
                                        <span class="br"></span>
                                        <label for="" class="in_long"><strong>도로명</strong> <span class="intxt">
                                            <input name="addrRoadnm" id="txt_company_addr2_16" type="text" data-find="courier_interface_16" data-bind-type="text" data-bind-value="addrRoadnm" data-validation-engine="validate[maxSize[50]]" readonly>
                                        </span></label>
                                        <span class="br"></span>
                                        <label for="" class="in_long"><strong>공통상세</strong> <span class="intxt">
                                            <input name="addrCmnDtl" id="txt_company_addrdtl_16" type="text" maxlength="50" data-find="courier_interface_16" data-bind-type="text" data-bind-value="addrCmnDtl" data-validation-engine="validate[maxSize[50]]" readonly>
                                        </span></label>
                                    </div>                                    
                                </td>
                            </tr>
                            <!--  라벨프린터 삭제 2016.07.28 - 이동준 과장 확인 -->
<%--                        <tr>
                                <th>라벨프린터</th>
                                <td colspan="3">
                                    <span class="select">
                                        <label for="">사용안함</label>
                                        <select name="" id="">
                                            <option value="">사용안함</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
--%>
                        </tbody>
                    </table>
                </div>
                <p class="point_c3 mt10">* [설정] &gt; [기본관리]에 입력한 정보로 상단의 정보가 자동으로 노출됩니다. 변경을 원하시면 [설정]  &gt; [기본관리] 에서 변경해주세요.</p>
                <!-- //tblw -->
                <!--  배송상태 자동 업데이트 체크박스 삭제 2016.07.28 - 이동준 과장 확인 -->
                <h3 class="tlth3 mt20">우체국택배 배송상태 업데이트</h3>
                <ul class="tlt_list">
                    <li id="li_autoStatusChgYn_16" >
                        2시간마다 자동으로 업데이트 합니다. 배송이 완료된 주문은 ‘배송완료’로 업데이트 됩니다.
                    </li>
                </ul>
                
                <!--공통-개인정보 제공 동의 안내-->
                <h3 class="tlth3 mt20">개인정보 제공 동의 안내</h3>
                <div class="tblw tblmany">
                    <table summary="이표는 우체국택배 연동서비스 표 입니다. 구성은 쇼핑몰 도메인, 우체국회원ID, 우체국 회원 비밀번호, 우체국 고객번호, 계약우체국명, 상호명, 대표자명, 사업자 번호, E-MAIL, 전화번호, 휴대폰번호, 주소, 라벨프린터 입니다.">
                        <caption>우체국택배 연동서비스</caption>
                        <colgroup>
                            <col width="16%">
                            <col width="64%">
                            <col width="20%">
                        </colgroup>
                        <tbody>
                           <tr>
                               <th style="text-align:center;" data-bind-type="function" data-find="courier_interface_16" data-bind-value="privacyClctApplyYn" data-bind-function="setUseYn">
                                   <input type="checkbox" name="privacyClctApplyYn" id="privacyClctApplyYn_16" class="blind" data-find="courier_interface_16" data-input-type="checkbox" data-input-name="privacyClctApplyYn">
                                   <label id="lb_privacyClctApplyYn_16" for="privacyClctApplyYn_16" class="chack"><span class="ico_comm">&nbsp;</span></label>
                               </th>
                               <td>개인정보 수집 및 이용에 동의합니다.</td>
                               <td style="text-align:right"> <a href="" class="btn_gray acd_tlt2 privacyClctApplyYn" for="div_privacyClctApplyYn_16">개인정보 수집 이용약관 보기</a></td>
                           </tr>
                           <tr class="acd_con2">
                               <th></th>
                               <td colspan="2">
                                   <div id="div_privacyClctApplyYn_16" class="td_txt_scroll privacyClctApplyYn" >
                                       위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.
                                   </div>
                               </td>
                           </tr>
                           <tr>
                               <th style="text-align:center;" data-bind-type="function" data-find="courier_interface_16" data-bind-value="privacyUseApplyYn" data-bind-function="setUseYn">
                                   <input type="checkbox" name="privacyUseApplyYn" id="privacyUseApplyYn_16" class="blind" data-find="courier_interface_16" data-input-type="checkbox" data-input-name="privacyUseApplyYn">
                                   <label id="lb_privacyUseApplyYn_16" for="privacyUseApplyYn_16" class="chack"><span class="ico_comm">&nbsp;</span></label>
                               </th>
                               <td>개인정보 수집 및 이용에 동의합니다.  </td>
                               <td style="text-align:right"><a href="" class="btn_gray acd_tlt2 privacyUseApplyYn" for="div_privacyUseApplyYn_16">개인정보 취급위탁 약관 보기</a></td>
                           </tr>
                           <tr class="acd_con2">
                               <th></th>
                               <td colspan="2">
                                   <div id="div_privacyUseApplyYn_16" class="td_txt_scroll privacyUseApplyYn" >
                                       위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.위에 개인정보 수집 이용약관 보기 버튼을 누르면 스르르 열려서 이 글이 보이게 됩니다.
                                   </div>
                               </td>
                           </tr>
                        </tbody>
                   </table>
               </div>
               <!--//공통-개인정보 제공 동의 안내-->
                    
            </form>
            </div>
            <!-- //line_box -->
        </div>
    </div>
</div>

        
    </t:putAttribute>
</t:insertDefinition>