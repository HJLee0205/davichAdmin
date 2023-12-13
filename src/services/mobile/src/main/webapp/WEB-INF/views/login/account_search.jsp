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
        $(document).ready(function(){
            Dmall.validate.set('form_id_accoutn_search');

            /*
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
		     */

            $("input[name=pw_auth_select]").click(function(){
            	var pw_auth_select = $("input[name=pw_auth_select]:checked").val();
            	if(pw_auth_select=='hp'){
            		setDefault();
                    openDRMOKWindow();
            	}else if(pw_auth_select=='ipin'){
            		setDefault();
                    openIPINWindow();

            	}else if(pw_auth_select=='email'){
            		 setDefault();
                     $('#div_id_01').show();
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
                    var url = '${_MOBILE_PATH}/front/login/account-detail';
                   /*  year = jQuery('#select_id_year option:selected').val(),
                    month = jQuery('#select_id_month option:selected').val(),
                    date = jQuery('#select_id_date option:selected').val(), */
                    idbirth =jQuery('#select_id_birth').val(),
                    param = {
                        mode : jQuery('#mode').val(),
                        loginId : jQuery('#login_id').val(),
                        memberNm : jQuery('#login_name').val(),
                        /* birth : '' + year + month.df(2) + date.df(2), */
                        birth : '' + idbirth,
                        /* email : jQuery('#email01').val() + '@' + jQuery('#email02').val(), */
                        email : jQuery('#email01').val(),
                        certifyMethodCd : 'EMAIL'
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
                    Dmall.LayerUtil.alert("올바른 값을 입력해주세요.", "알림");
                    return;
                }
                if ($('#newPw').val().length<8 || jQuery('#newPw').val().length>16){
                    Dmall.LayerUtil.alert("비밀번호는8 ~16자리로 입력해주세요.", "확인");
                    return false;
                }
                if(/(\w)\1\1/.test($('#newPw').val())){
                    Dmall.LayerUtil.alert("동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
                    return false;
                }
                var url = '${_MOBILE_PATH}/front/login/update-password';
                var param = $('#form_id_accoutn_search').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         setDefault();
                         $("#div_id_04").show();
                     }
                });
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
            /* init(); */

         // #PASSWORD SEARCH
            $("#btn_password_search").click(function(){
                move_page('pass_search');
            });
        });
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
            document.reqDRMOKForm.action = 'http://dev.mobile-ok.com/popup/enhscert.jsp';
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
            var url = '${_MOBILE_PATH}/front/login/account-detail';
            param = {memberDi : jQuery('#memberDi').val(),certifyMethodCd : jQuery('#certifyMethodCd').val()};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    if(result.data != null){
                        $("#loginId").val(result.data.loginId);
                        $("#memberNo").val(result.data.memberNo);
                        setDefault();
                        if( $("#mode").val()=="id" ){


                            $("#result_id").html("고객님께서 가입하신 아이디 입니다.<span class=\"id_view\">아이디 : "+result.data.loginId+"</span>");

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

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
	<c:if test="${mode == 'id'}" >
		<div class="member_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			아이디 찾기
		</div>
	</c:if>
	<c:if test="${mode == 'pass'}" >
		<div class="member_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			비밀번호 찾기
		</div>
	</c:if>
		<ul class="auth_id">
		<c:if test="${mo ne null}">
			<li ${io eq null?"style='width:50%'":""}>
				<span class="icon_mobile"></span>
				<input type="radio" id="pw_auth_select01" name="pw_auth_select" value="hp" checked>
				<label for="pw_auth_select01">
					<span></span>
					휴대폰 인증
				</label>
			</li>
	    </c:if>
	    <c:if test="${io ne null}">
			<li ${mo eq null?"style='width:50%'":""}>
				<span class="icon_gpin"></span>
				<input type="radio" id="pw_auth_select02" name="pw_auth_select" value="ipin">
				<label for="pw_auth_select02">
					<span></span>
					I-PIN인증
				</label>
			</li>
	    </c:if>
			<li ${(io eq null) and (mo eq null)?"style='width:100%'":""} ${(io eq null) or (mo eq null)?"style='width:50%'":""}>
				<span class="icon_email"></span>
				<input type="radio" id="pw_auth_select03" name="pw_auth_select" value="email">
				<label for="pw_auth_select03">
					<span></span>
					이메일
				</label>
			</li>
		</ul>
		<div id="div_id_01" style="display: none;">
		<ul class="pw_auth_form" >
			<li class="auth_id_form" id="input_id" <c:if test="${mode ne 'pass'}" >style="display: none;"</c:if>><input type="text" id="login_id" placeholder="아이디"></li>
			<!-- 이메일인증시 -->
			<li class="auth_email_form">
				<input type="text" id="login_name" name="login_name" placeholder="이름">
			</li>
			<li class="auth_email_form">
				<input type="text" id="select_id_birth" placeholder="생년월일 (ex.19890805)">
			</li>
			<li class="auth_email_form">
				<input type="text" id="email01" placeholder="이메일 (abcd@efg.com)">
			</li>
			<!--// 이메일인증시 -->
			<div class="id_btn_area" style="margin-top:10px">
			<button type="button" class="btn_auth_go" id="btn_search_confirm">확인</button>
			<span>※ 입력하신 정보는 본인확인 용도 외에 사용되거나 저장되지 않습니다.</span>
		    </div>
		</ul>
		</div>


		<!--step2-->
        <div id="div_id_02" style="display: none;">
            <div class="id_search_result" id ="result_id"></div>
            <div class="result_btn_area">
				<button type="button" class="btn_pw_search" id="btn_password_search">비밀번호 찾기</button>
				<button type="button" class="btn_login02" onclick="move_page('login');">로그인</button>
			</div>
        </div>
        <!--//step2-->

        <!--인증완료 비밀번호 변경-->
        <div id="div_id_03" style="display: none;">
            <div class="pw_auth_success">
			비밀번호 찾기 인증에 성공하셨습니다.<br>
			비밀번호를 재설정해주세요.
			</div>
			<ul class="pw_auth_form">
				<li><input type="password" id="newPw" name="newPw" maxlength="16" placeholder="비밀번호 재설정"></li>
				<li><input type="password" id="newPw_check" name="newPw_check" maxlength="16" placeholder="비밀번호 재확인"></li>
			</ul>
			<div class="id_btn_area" style="margin-top:10px">
				<button type="button" id="btn_change_pw" class="btn_auth_go">변경하기</button>
			</div>
        </div>
        <!--//step2-->

        <!--step3-->
        <div id="div_id_04" style="display: none;">
            <div class="pw_auth_success">
				회원님의 비밀번호가 성공적으로 변경되었습니다.<br>
				새로운 비밀번호로 로그인해 주시기 바랍니다.
			</div>
			<div class="id_btn_area" style="margin-top:10px;padding:0 3%">
				<button type="button" class="btn_pw_change" onclick="move_page('login');">로그인</button>
				<button type="button" class="btn_pw_change_next" onclick="move_page('main');">메인으로 이동</button>
			</div>
        </div>
        <!--//step3-->

	</div>
	<!---// 03.LAYOUT:CONTENTS --->

    </form:form>
    <form name="reqDRMOKForm" method="post">
        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
        <input type="hidden" name="cpid" value = "${mo.cpid}" />
        <input type="hidden" name="design" value="mobile"/>
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