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
	<t:putAttribute name="title">로그인</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
		<script>
            jQuery(document).ready(function() {
                jQuery('.auth_email_form').hide();

                Dmall.validate.set('form_id_email');

                /* jQuery('div.btn_area button.btn_login_auth_mobile').on('click', function() {
                    openDRMOKWindow();
                    jQuery('#div_id_email').hide();
                });
                jQuery('div.btn_area button.btn_login_auth_Ipin').on('click', function() {
                    openIPINWindow();
                    jQuery('#div_id_email').hide();
                });
                jQuery('div.btn_area button.btn_login_auth_email').on('click', function() {
                    jQuery('#div_id_email').show();
                }); */
                
                
            $("input[name=pw_auth_select]").click(function(){
                var pw_auth_select = $("input[name=pw_auth_select]:checked").val();
                if(pw_auth_select=='hp'){
                    openDRMOKWindow();
                    jQuery('.auth_email_form').hide();
                }else if(pw_auth_select=='ipin'){
                   openIPINWindow();
                    jQuery('.auth_email_form').hide();
                    
                }else if(pw_auth_select=='email'){
                     jQuery('.auth_email_form').show();
                }
                
            });
                
                jQuery('#select_id_month').on('change', function() {
                    var d = new Date(),
                            lastDate,
                            html = '<option value="" selected="selected">일</option>';
                    d.setFullYear(jQuery('#select_id_year').val(), this.value, 1);
                    d.setDate(0);
                    lastDate = d;
                    for(var i = 1; i <= lastDate.getDate(); i++) {
                        html += '<option value="' + i + '">' + i + '</option>';
                    }
                    jQuery('#select_id_date').html(html).trigger('change');
                });
                jQuery('#select_id_email').on('change', function() {
                    if(this.value === 'etc') {
                        jQuery('#email02').val('');
                    } else {
                        jQuery('#email02').val(this.value);
                    }
                });

                jQuery('#button_id_confirm').on('click', function() {
                    var url = '/front/login/account-detail',
                       /*  year = jQuery('#select_id_year option:selected').val(),
                        month = jQuery('#select_id_month option:selected').val(),
                        date = jQuery('#select_id_date option:selected').val(), */
                        idbirth =jQuery('#select_id_birth').val(),
                        param = {
                            certifyMethodCd : 'EMAIL',
                            memberNm : jQuery('#login_name').val(),
                            birth : '' + idbirth,
                            /* birth : '' + year + month.df(2) + date.df(2), */
                            /* email : jQuery('#email01').val() + '@' + jQuery('#email02').val() */
                            email : jQuery('#email01').val()
                        };

                    if(!Dmall.validate.isValid('form_id_email')) {
                        return false;
                    }

                    /* if(year === '') {
                        jQuery('#select_id_year').validationEngine('showPrompt', '년도를 선택해 주세요', 'error');
                        return false;
                    }
                    if(month === '') {
                        jQuery('#select_id_month').validationEngine('showPrompt', '월을 선택해 주세요', 'error');
                        return false;
                    }
                    if(date === '') {
                        jQuery('#select_id_date').validationEngine('showPrompt', '일 선택해 주세요', 'error');
                        return false;
                    } */

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data != null){
                                $('#loginId').val(result.data.loginId);
                                successIdentity();
                            }else{
                                Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                            }

                        }
                    });
                });

                init();
            });

            function init() {
                var html = '',
                    d = new Date(),
                    firstYear = d.getFullYear() - 100;
                for (var i = d.getFullYear(); i >= firstYear; i--) {
                    html += '<option value="' + i + '">' + i + '</option>';
                }
                jQuery('#select_id_year').append(html);
                html = '';
                for(var i = 1; i <= 12; i++) {
                    html += '<option value="' + i + '">' + i + '</option>';
                }
                jQuery('#select_id_month').append(html);
            }

            // mobile auth popup
            var KMCIS_window;
            function openDRMOKWindow(){
                DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
                if(DRMOK_window == null){
                    alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
                }
                $('#certifyMethodCd').val("mobile");
                document.reqDRMOKForm.action = 'http://dev.mobile-ok.com/popup/enhscert.jsp';
                document.reqDRMOKForm.target = 'DRMOKWindow';
                document.reqDRMOKForm.submit();
            }
            // ipin auth popup
            function openIPINWindow(){
                window.open('', 'popupIPIN', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
                document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
                document.reqIPINForm.target = "popupIPIN";
                document.reqIPINForm.submit();
            }
            // success identinty
            function successIdentity(){
                var url = '/front/member/dormant-member-update';
                var param = $('#form_id_identity').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Dmall.LayerUtil.alert("휴면상태에서 해제가 완료되었습니다.", "알림");
                        window.location.href = '/front/login/member-login';
                    }
                });
            }
        </script>
	</t:putAttribute>
	<t:putAttribute name="content">
    <!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">  
        <div class="member_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            휴면회원 인증
        </div>
        <ul class="auth_id">
        <c:if test="${mo ne null}">
            <li>
                <span class="icon_mobile"></span>
                <input type="radio" id="pw_auth_select01" name="pw_auth_select" value="hp" checked>
                <label for="pw_auth_select01">
                    <span></span>
                    휴대폰 인증
                </label>
            </li>   
        </c:if>
        <c:if test="${io ne null}">
            <li>
                <span class="icon_gpin"></span>
                <input type="radio" id="pw_auth_select02" name="pw_auth_select" value="ipin">
                <label for="pw_auth_select02">
                    <span></span>
                    I-PIN인증
                </label>
            </li>
        </c:if>
            <li>
                <span class="icon_email"></span>
                <input type="radio" id="pw_auth_select03" name="pw_auth_select" value="email">
                <label for="pw_auth_select03">
                    <span></span>
                    이메일
                </label>
            </li>
        </ul>   
        <div class="inactivity_text">
            회원님의 계정은 현재 휴면 상태 입니다. 
            개인정보 보호를 위해 1년 이상 또는 로그인 이력이 없으신 회원님의 개인정보는 별도 보관 처리 됩니다.

            <span>본인인증을 완료하면 서비스를 정상적으로 이용하실 수 있습니다. 위 방법 중 하나를 선택하여 본인인증을 진행해 주세요.</span>          
        </div>
        <!-- 이메일인증시 -->
        <div class="auth_email_form ">
            <form:form id="form_id_identity" >
            <input type="hidden" id="loginId" name="loginId"/>
            <input type="hidden" id="memberDi" name="memberDi"/>
            </form:form>
            <form id="form_id_email">
            <ul class="pw_auth_form">
                <li class="textC">회원가입시 등록하신 정보를 입력해 주세요.</li>
                <li>
                    <input type="text" id="login_name" name="memberNm" maxlength="50" data-validation-engine="validate[required, maxSize[50]]" placeholder="이름">
                </li>
                <li>
                  <input type="text" id="select_id_birth" placeholder="생년월일 (ex.19890805)">
                </li>
                <li>
                    <input type="text" id="email01" placeholder="이메일 (abcd@efg.com)">
                </li>
                <!--// 이메일인증시 -->
            </ul>   
            </form>
            <div class="id_btn_area" style="margin-top:10px">
                <button type="button" class="btn_auth_go"  id="button_id_confirm">확인</button>
                <span>※ 입력하신 정보는 본인확인 용도 외에 사용되거나 저장되지 않습니다.</span>
            </div>
        </div>
        <!---// contents --->
            <form name="reqDRMOKForm" method="post">
                <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
                <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
                <input type="hidden" name="cpid" value = "${mo.cpid}" />
                <input type="hidden" name="design" value="pc"/>
            </form>
            <form name="reqIPINForm" method="post">
                <input type="hidden" name="m" value="pubmain">                      <!-- 필수 데이타로, 누락하시면 안됩니다. -->
                <input type="hidden" name="enc_data" value="${io.encData}">       <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
                <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시
                   해당 값을 그대로 송신합니다. 해당 파라미터는 추가하실 수 없습니다. -->
                <input type="hidden" name="param_r1" value="s">
            </form>
    </div>  
    <!---// 03.LAYOUT:CONTENTS --->

	</t:putAttribute>
</t:insertDefinition>