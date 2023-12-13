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
	<t:putAttribute name="title">비밀번호 변경</t:putAttribute>


	<t:putAttribute name="script">
		<script>
			jQuery(document).ready(function() {
				jQuery('#div_id_stap3').hide();

				Dmall.validate.set('form_id_password');

				jQuery('#btn_id_save').on('click', function() {
				    if( $('#newPw').val() !=  $('#newPw_check').val()){
                        Dmall.LayerUtil.alert("입력한 비밀번호가 동일하지 않습니다.<br/>확인 후 다시 입력하여 주십시오.", "알림");
                        return;
                    }
                    if ($('#newPw').val().length<8 || jQuery('#newPw').val().length>16){
                        Dmall.LayerUtil.alert("비밀번호는 8~16자입니다.", "확인");
                        return false;
                    }
                    if(/(\w)\1\1/.test($('#newPw').val())){
                        Dmall.LayerUtil.alert("동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
                        return false;
                    }

                    var url = '/front/member/update-password';
                    var param = $('#form_id_password').serializeArray();
					Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if(result.success) {
							jQuery('#div_id_stap2').hide();
							jQuery('#div_id_stap3').show();
						}
					});
				});
				jQuery('#btn_id_login').on('click', function() {
					window.location.href = HTTPS_SERVER_URL + '/front/login/member-login';
				});
				jQuery('#btn_id_main').on('click', function() {
					window.location.href = HTTP_SERVER_URL + '/front';
				});

			});

		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<!--- contents --->
		<div id="member_container">
    		<!--div id="member_location">
    			<a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span>
    		</div-->

    		<div class="password_change_box">
    			<!--step2-->
    			<div id="div_id_stap2">
    				<h2 class="sub_title">비밀번호 입력</h2>
    				<div class="pw_search_info">
    					회원님의 정보가 확인되었습니다.
    					새로운 비밀번호를 입력해 주세요.
    				</div>
    				<form id="form_id_password">
    				<ul class="login_form">
                        <li>
                            <span class="login_form_tit">현재 비밀번호</span>
                            <span class="login_form_input"><input type="password" name="nowPw" id="nowPw" maxlength="16" autocomplete="off"></span>
                        </li>
    					<li>
    						<span class="login_form_tit">새 비밀번호</span>
    						<span class="login_form_input"><input type="password" name="newPw" id="newPw" maxlength="16" autocomplete="off"></span>
    					</li>
    					<li>
    						<span class="login_form_tit">비밀번호 확인</span>
    						<span class="login_form_input"><input type="password" name="newPw_check" id="newPw_check" maxlength="16" autocomplete="off"></span>
    					</li>
    				</ul>
    				</form>
    				<div class="pw_search_info02">
    					비밀번호는 영문과 숫자를 포함하여, 최소 8자~ 최대 16자로 만들어주세요.<br>
    					변경 전 비밀번호와 동일한 비밀번호로는 변경하실 수 없습니다.
    				</div>
					<div class="btn_change_area">						
    					<button type="button" class="btn_change_now" id="btn_id_save">확인</button>
					</div>
    			</div>
    			<!--//step2-->

    			<!--step3-->
    			<div id="div_id_stap3">
    				<h2 class="sub_title">비밀번호 변경완료</h2>
    				<div class="password_change_text01">
    					회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>
    					로그인 시, 새로운 비밀번호로 로그인해 주시기 바랍니다.<br/>
    				</div>
    				<div class="btn_change_area">
    					<button type="button" class="btn_change_now" id="btn_id_login">로그인</button>
    					<button type="button" class="btn_change_next" id="btn_id_main">메인으로 이동</button>
    				</div>
    			</div>
    			<!--//step3-->

    		</div>
        </div>
		<!---// contents --->
	</t:putAttribute>
</t:insertDefinition>