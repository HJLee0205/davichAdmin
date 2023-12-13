<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(document).ready(function(){
            Dmall.validate.set('form_id_accoutn_search');
            <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
            VarMobile.server = '${server}';

            $("#mobile_auth").click(function(){
                setDefault();
                openDRMOKWindow();
            });
            $("#ipin_auth").click(function(){
                setDefault();
                openIPINWindow();
            });
            $("#email_auth").click(function(){
                setDefault();
                $('#div_id_01').show();
            });
            jQuery('#select_id_month').on('change', function() {
                var d = new Date(),
                        lastDate,
                        html = '<option value="" selected="selected">일</option>';
                d.setFullYear(jQuery('#select_id_year').val(), this.value, 1);
                d.setDate(0);
                lastDate = d;
                for(var i = 1; i <= lastDate.getDate(); i++) {
                    if(i<10){
                        html += '<option value="0' + i + '">0' + i + '</option>';
                    }else{
                        html += '<option value="' + i + '">' + i + '</option>';
                    }
                }
                jQuery('#select_id_date').html(html).trigger('change');
            });
            // #EMAIL AUTH_CHECK
            $("#btn_search_confirm").click(function(){
                if(Dmall.validate.isValid('form_id_accoutn_search')){
                    var url = '/front/login/account-detail';
                    year = jQuery('#select_id_year option:selected').val(),
                    month = jQuery('#select_id_month option:selected').val(),
                    date = jQuery('#select_id_date option:selected').val(),
                    param = {
                        mode : jQuery('#mode').val(),
                        loginId : jQuery('#login_id').val(),
                        memberNm : jQuery('#login_name').val(),
                        birth : '' + year + month.df(2) + date.df(2),
                        email : jQuery('#email01').val() + '@' + jQuery('#email02').val(),
                        certifyMethodCd : 'EMAIL'
                    };

                    if(!Dmall.validate.isValid('form_id_email')) {
                        return false;
                    }

                    if(year === '') {
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
                    }
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data != null){
                                $("#loginId").val(result.data.loginId);
                                $("#memberNo").val(result.data.memberNo);
                                setDefault();
                                if( $("#mode").val()=="id" ){
                                    $("#result_id").html("고객님의 아이디는 <b>["+result.data.loginId+"]</b>입니다.");
                                    $("#div_id_02").show();
                                }else{
                                    $("#div_id_03").show();
                                }
                            }else{
                                Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                            }
                        }
                    });
                }
            });

            $("#btn_change_pw").click(function(){
                if( $('#newPw').val() !=  $('#newPw_check').val()){
                    Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                    return;
                }
                if(passwordCheck($('#newPw').val())){
                    var url = '/front/login/update-password';
                    var param = $('#form_id_accoutn_search').serializeArray();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                         if(result.success) {
                             setDefault();
                             $("#div_id_04").show();
                         }
                    });
                }
            });
            //e-mail selectBox
            var emailSelect = $('#email03');
            var emailTarget = $('#email02');
            emailSelect.bind('change', null, function() {
                var host = this.value;
                if (host != 'etc' && host != '') {
                    emailTarget.attr('readonly', true);
                    emailTarget.val(host).change();
                } else if (host == 'etc') {
                    emailTarget.attr('readonly'
                            , false);
                    emailTarget.val('').change();
                    emailTarget.focus();
                } else {
                    emailTarget.attr('readonly', true);
                    emailTarget.val('').change();
                }
            });
            //birthday
            init();
        });

        var VarMobile = {
            server:''
        };

        //# display default-setting(tab-click)
        function setMode(mode){
            $('#mode').val(mode);
            setDefault();
            if(mode == 'id'){
                $("#id_title").show();
                $("#password_title").hide();
                $("#input_id").hide();
            }else{
                $("#id_title").hide();
                $("#password_title").show();
                $("#input_id").show();
            }
        }

        //#div default-setting(인정 bitton click)
        function setDefault(){
            $("#div_id_01").hide();
            $("#div_id_02").hide();
            $("#div_id_03").hide();
            $("#div_id_04").hide();
            $("#newPw").val('');
            $("#newPw_check").val('');
        }

        // mobile auth popup
        var KMCIS_window;
        function openDRMOKWindow(){
            DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
            if(DRMOK_window == null){
                alert(" ※ 윈도우 XP SP2 또는 인터넷 익스플로러 7 사용자일 경우에는 \n    화면 상단에 있는 팝업 차단 알림줄을 클릭하여 팝업을 허용해 주시기 바랍니다. \n\n※ MSN,야후,구글 팝업 차단 툴바가 설치된 경우 팝업허용을 해주시기 바랍니다.");
            }
            $('#certifyMethodCd').val("mobile");

            var certUrl = '';
            if(VarMobile.server === 'local') {
                certUrl = 'https://dev.mobile-ok.com/popup/common/hscert.jsp';
            } else {
                certUrl = 'https://www.mobile-ok.com/popup/common/hscert.jsp';
            }

            document.reqDRMOKForm.action = certUrl;
            document.reqDRMOKForm.target = 'DRMOKWindow';
            document.reqDRMOKForm.submit();
        }
        // ipin auth popup
        function openIPINWindow(){
            window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
            document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
            document.reqIPINForm.target = "popupIPIN2";
            document.reqIPINForm.submit();
        }

        function successIdentity(){
            var url = '/front/login/account-detail';
            param = {memberDi : jQuery('#memberDi').val(),certifyMethodCd : jQuery('#certifyMethodCd').val()};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    if(result.data != null){
                        $("#loginId").val(result.data.loginId);
                        $("#memberNo").val(result.data.memberNo);
                        setDefault();
                        if( $("#mode").val()=="id" ){
                            $("#result_id").html("고객님의 아이디는 <b>["+result.data.loginId+"]</b>입니다.");
                            $("#div_id_02").show();
                        }else{
                            $("#div_id_03").show();
                        }
                    }else{
                        Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                    }
                }
            });
        }

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
                if(i<10){
                    html += '<option value="0' + i + '">0' + i + '</option>';
                }else{
                    html += '<option value="' + i + '">' + i + '</option>';
                }
            }
            jQuery('#select_id_month').append(html);
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <!-- MC0GCCqGSIb3DQIJAyEAJoUfFTQOP/b5AT7VZDivZ/UxbMhQvraJ1YuyLLz1l8U= : 최군 di -->
    <form:form id="form_id_accoutn_search">
    <input type="hidden" name="mode" id="mode" value="${mode}"/>
    <input type="hidden" name="certifyMethodCd" id="certifyMethodCd"/>
    <input type="hidden" name="memberDi" id="memberDi"/>
    <input type="hidden" name="memberNo" id="memberNo"/>
    <input type="hidden" name="loginId" id="loginId"/>
    <input type="hidden" name="name" id="name"/>
    <input type="hidden" name="birth" id="birth"/>
    <input type="hidden" name="gender" id="gender"/>
    <input type="hidden" name="email" id="email"/>
    <input type="hidden" name="nationalInfo" id="nationalInfo"/>

    <div class="contents fixwid">
        <div id="member_location">
            <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>아이디 / 패스워드 찾기
        </div>
        <ul class="tabs">
            <li <c:if test="${mode == 'id'}" >class="active"</c:if> style="width:50%" onclick="setMode('id');">아이디 찾기</li>
            <li <c:if test="${mode == 'pass'}" >class="active"</c:if>style="width:49.4%" onclick="setMode('pass');">패스워드 찾기</li>
        </ul>
        <div>
            <div class="idpassSearch_box" >
                <h3 class="login_stit" id="id_title" <c:if test="${mode ne 'id'}" >style="display: none;"</c:if>>
                    아이디 찾기
                    <span>아이디가 생각나지 않으세요? <br/>회원님의 개인정보를 안전하게 되찾으실 수 있도록 도와드리겠습니다.</span>
                </h3>
                <h3 class="login_stit" id="password_title" <c:if test="${mode ne 'pass'}" >style="display: none;"</c:if>>
                    패스워드 찾기
                    <span>패스워드가 생각나지 않으세요? <br/>회원님의 개인정보를 안전하게 되찾으실 수 있도록 도와드리겠습니다.</span>
                </h3>
                <!--step1-->
                <div>
                    <div class="btn_area">
                        <c:if test="${mo ne null}">
                            <button type="button" class="btn_login_auth_mobile" id="mobile_auth" style="margin-right:6px">휴대폰 인증</button>
                        </c:if>
                        <c:if test="${io ne null}">
                            <button type="button" class="btn_login_auth_Ipin" id="ipin_auth" style="margin-right:6px">I-PIN 인증</button>
                        </c:if>
                        <button type="button" class="btn_login_auth_email" id="email_auth">이메일 인증</button>
                    </div>
                </div>
                <!--//step1-->

                <!--이메일 인증일 경우-->
                <div id="div_id_01" style="display: none;">
                    <div class="pw_search_info">
                        회원가입 시 입력한 이메일주소를 입력해주세요.
                    </div>
                    <ul class="login_form">
                        <li id = "input_id" <c:if test="${mode ne 'pass'}" >style="display: none;"</c:if>>
                            <span class="login_form_tit">아이디</span>
                            <span class="login_form_input"><input type="text" id="login_id"></span>
                        </li>
                        <li>
                            <span class="login_form_tit">이름</span>
                            <span class="login_form_input"><input type="text" id="login_name" name="login_name" value=""></span>
                        </li>
                        <li>
                            <span class="login_form_tit">생년월일</span>
                            <span class="login_form_input">
                                <div class="select_box select_box_birth" style="display:inline-block">
                                    <label for="select_id_year">년도</label>
                                    <select class="select_option" title="select option" id="select_id_year">
                                        <option value="" selected="selected">년도</option>
                                    </select>
                                </div>
                                <div class="select_box select_box_birth" style="display:inline-block">
                                    <label for="select_id_month">월</label>
                                    <select class="select_option" title="select option" id="select_id_month">
                                        <option value="" selected="selected">월</option>
                                    </select>
                                </div>
                               <div class="select_box select_box_birth" style="display:inline-block">
                                    <label for="select_id_date">일</label>
                                    <select class="select_option" title="select option" id="select_id_date">
                                        <option value="" selected="selected">일</option>
                                    </select>
                                </div>
                            </span>
                        </li>
                        <li>
                            <span class="login_form_tit">이메일</span>
                            <span class="login_form_input">
                                <input type="text" id="email01" class="email" value=""> @ <input type="text" id="email02" class="email" value="">
                                <select id="email03">
                                <option value="" selected="selected">- 이메일 선택 -</option>
                                <option value="naver.com">naver.com</option>
                                <option value="daum.net">daum.net</option>
                                <option value="nate.com">nate.com</option>
                                <option value="hotmail.com">hotmail.com</option>
                                <option value="yahoo.com">yahoo.com</option>
                                <option value="empas.com">empas.com</option>
                                <option value="korea.com">korea.com</option>
                                <option value="dreamwiz.com">dreamwiz.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="etc">직접입력</option>
                                </select>
                            </span>
                        </li>
                    </ul>
                    <div class="pw_search_info02">
                        <button type="button" class="btn_popup_login" style="margin-top:22px" id="btn_search_confirm">확인</button>
                    </div>
                </div>
                <!--//이메일 인증일 경우-->

                <!--step2-->
                <div id="div_id_02" style="display: none;">
                    <div class="id_search_result" id ="result_id"></div>
                    <div class="btn_area">
                        <button type="button" class="btn_popup_login" onclick="move_page('login');">로그인</button>
                        <button type="button" class="btn_popup_pwsearch" onclick="move_page('main');">메인으로</button>
                    </div>
                </div>
                <!--//step2-->

                <!--인증완료 비밀번호 변경-->
                <div id="div_id_03" style="display: none;">
                    <div class="pw_search_info">
                        회원님의 정보가 확인되었습니다.
                        새로운 비밀번호를 입력해 주세요.
                    </div>
                    <ul class="login_form">
                        <li>
                            <span class="login_form_tit">새 비밀번호</span>
                            <span class="login_form_input"><input type="password" id="newPw" name="newPw" maxlength="16"></span>
                        </li>
                        <li>
                            <span class="login_form_tit">비밀번호 확인</span>
                            <span class="login_form_input"><input type="password" id="newPw_check" name="newPw_check" maxlength="16"></span>
                        </li>
                    </ul>
                    <div class="pw_search_info02">
                        비밀번호는 영문과 숫자를 포함하여, 최소 8자~ 최대 16자로 만들어주세요.<br>
변경 전 비밀번호와 동일한 비밀번호로는 변경하실 수 없습니다.<br>
                        <button type="button" class="btn_popup_login" id="btn_change_pw" style="margin-top:22px">확인</button>
                    </div>
                </div>
                <!--//step2-->

                <!--step3-->
                <div id="div_id_04" style="display: none;">
                    <div class="id_search_result">
                        회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>
로그인 시, 새로운 비밀번호로 로그인해 주시기 바랍니다.<br/>
                    </div>
                    <div class="btn_area">
                        <button type="button" class="btn_popup_login" onclick="move_page('login');">로그인</button>
                        <button type="button" class="btn_popup_pwsearch" onclick="move_page('main');">메인으로</button>
                    </div>
                </div>
                <!--//step3-->

            </div>
        </div>
    </div>
    </form:form>
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
    </t:putAttribute>
</t:insertDefinition>