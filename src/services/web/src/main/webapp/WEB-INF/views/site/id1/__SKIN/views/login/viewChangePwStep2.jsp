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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 비밀번호 변경</t:putAttribute>


	<t:putAttribute name="script">
		<script>
			var orderYn='${param.orderYn}';
			var visionYn='${param.visionYn}';
			var rsvOnlyYn = '${param.rsvOnlyYn}';

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

							if(orderYn=='Y'){
								var text01 = "회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>주문서 페이지로 이동합니다. <br/> 잠시만 기다려주십시오.<br/>";

    							jQuery('#div_id_stap3 .password_change_text01').html(text01);
								jQuery('#div_id_stap3 .btn_change_area').hide();
								if(rsvOnlyYn=='Y'){
									text01 = "회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>방문예약 페이지로 이동합니다. <br/> 잠시만 기다려주십시오.<br/>";
									$('#orderForm').attr('action',HTTPS_SERVER_URL+'/front/visit/visit-book');
								}
								$('#orderForm').submit();
							}else{

								if(visionYn=='Y'){
									var text01 = "회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>렌즈추천 페이지로 이동합니다. <br/> 잠시만 기다려주십시오.<br/>";
    								jQuery('#div_id_stap3 .password_change_text01').html(text01);
									jQuery('#div_id_stap3 .btn_change_area').hide();
									$('#form_vision_check').submit();
								}else{
									if('${param.returnUrl}'==''){
										var text01 = "회원님의 비밀번호가 성공적으로 변경되었습니다.<br/>메인 페이지로 이동합니다. <br/> 잠시만 기다려주십시오.<br/>";
										jQuery('#div_id_stap3 .password_change_text01').html(text01);
										jQuery('#div_id_stap3 .btn_change_area').hide();
										$('#returnForm').attr("action",'/front');
										$('#returnForm').submit();
									}else {
										var text01 = "회원님의 비밀번호가 성공적으로 변경되었습니다.<br/> 페이지 이동 중입니다. <br/> 잠시만 기다려주십시오.<br/>";
										jQuery('#div_id_stap3 .password_change_text01').html(text01);
										jQuery('#div_id_stap3 .btn_change_area').hide();
										$('#returnForm').submit();
									}
								}
							}
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
		<form name="orderForm" id="orderForm" action="/front/order/order-form" method="post">
			<c:forEach var="itemArr" items="${param.itemArr}" varStatus="status">
				<input type="hidden" name="itemArr" value="${itemArr}">
			</c:forEach>
		</form>
		<form:form id="form_vision_check" name="form_vision_check" method="post" action="${param.returnUrl}">
			<input type="hidden" name="lensType" id="lensType" value="${param.lensType}">
			<input type="hidden" name="ageCdG" id="ageCdG" value="${param.ageCdG}">
			<input type="hidden" name="ageCdC" id="ageCdC" value="${param.ageCdC}">
			<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${param.ageCdGNm}">
			<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${param.ageCdCNm}">
			<input type="hidden" name="wearCd" id="wearCd" value="${param.wearCd}">
			<input type="hidden" name="wearCdNm" id="wearCdNm" value="${param.wearCdNm}">
			<input type="hidden" name="contactTypeCd" id="contactTypeCd" value="${param.contactTypeCd}">
			<input type="hidden" name="contactTypeCdNm" id="contactTypeCdNm" value="${param.contactTypeCdNm}">
			<input type="hidden" name="wearTimeCd" id="wearTimeCd" value="${param.wearTimeCd}">
			<input type="hidden" name="wearTimeCdNm" id="wearTimeCdNm" value="${param.wearTimeCdNm}">
			<input type="hidden" name="wearDayCd" id="wearDayCd" value="${param.wearDayCd}">
			<input type="hidden" name="wearDayCdNm" id="wearDayCdNm" value="${param.wearDayCdNm}">
			<input type="hidden" name="incon1Cd" id="incon1Cd" value="${param.incon1Cd}">
			<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${param.incon1CdNm}">
			<input type="hidden" name="contactPurpCd" id="contactPurpCd" value="${param.contactPurpCd}">
			<input type="hidden" name="contactPurpCdNm" id="contactPurpCdNm" value="${param.contactPurpCdNm}">
			<input type="hidden" name="incon2Cd" id="incon2Cd" value="${param.incon2Cd}">
			<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${param.incon2CdNm}">
			<input type="hidden" name="lifestyleCd" id="lifestyleCd" value="${param.lifestyleCd}">
			<input type="hidden" name="lifestyleCdNm" id="lifestyleCdNm" value="${param.lifestyleCdNm}">
			<input type="hidden" name="returnUrl" value="${param.returnUrl}"/>
		</form:form>

		<form id="returnForm" action="${param.returnUrl}" method="post">
			<input type="hidden" name="refererType" id="refererType" value="${param.refererType}"/>
			<input type="hidden" name="returnUrl" value="${param.returnUrl}"/>
		</form>

		<!--- contents --->
		<div class="contents fixwid">
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
    				<ul class="login_form pw">
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
    				<h2 class="sub_title" style="height:56px;margin-top:56px">비밀번호 변경완료</h2>
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