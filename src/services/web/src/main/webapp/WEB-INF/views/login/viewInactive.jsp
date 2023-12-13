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
		<script>
			jQuery(document).ready(function() {
			    <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
			    VarMobile.server = '${server}';

				jQuery('#div_id_email').hide();

				Dmall.validate.set('form_id_email');

					jQuery('div.btn_area button.btn_login_auth_mobile').on('click', function() {
					openDRMOKWindow();
					jQuery('#div_id_email').hide();
				});
				jQuery('div.btn_area button.btn_login_auth_Ipin').on('click', function() {
					openIPINWindow();
					jQuery('#div_id_email').hide();
				});
				jQuery('div.btn_area button.btn_login_auth_email').on('click', function() {
					jQuery('#div_id_email').show();
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
						year = jQuery('#select_id_year option:selected').val(),
						month = jQuery('#select_id_month option:selected').val(),
						date = jQuery('#select_id_date option:selected').val(),
						param = {
					        certifyMethodCd : 'EMAIL',
							memberNm : jQuery('#login_name').val(),
							birth : '' + year + month.df(2) + date.df(2),
							email : jQuery('#email01').val() + '@' + jQuery('#email02').val()
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

			var VarMobile = {
                server:''
            };

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
		<!--- contents --->
		<div class="contents fixwid">
			<div id="member_location">
				<a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span>
			</div>
			<div class="inactivity_login_box">
				<div class="inactivity_text01">
					회원님의 계정은 <em>현재 휴면 상태</em> 입니다. <br>
					개인정보 보호를 위해 1년 이상 또는 로그인 이력이 없으신 회원님의 개인정보는 별도 보관 처리 됩니다.
				</div>
				<div class="inactivity_text02">
					회원가입 시 사용한 본인인증 방식을 통해 본인인증을 완료하면 서비스를 정상적으로 이용하실 수 있습니다.<br>
					아래 방법 중 회원가입 시 사용한 인증방식을 선택하여 본인인증을 진행해 주세요.
				</div>
				<!--step1-->
				<div class="btn_area" style="height:140px">
                    <c:if test="${mo ne null}">
					   <button type="button" class="btn_login_auth_mobile" style="margin-right:6px">휴대폰 인증</button>
                    </c:if>

                    <c:if test="${io ne null}">
					   <button type="button" class="btn_login_auth_Ipin" style="margin-right:6px">I-PIN 인증</button>
                    </c:if>
                    <%--이메일인증은 기획상 아예 삭제하기로 합의하였지만 추후 또 무슨 얘기가 나올지 모르므로 버튼만 감춰놓는다--%>
					<%-- <button type="button" class="btn_login_auth_email">이메일 인증</button> --%>
				</div>
				<!--//step1-->

				<!--이메일 인증일 경우-->
				<div id="div_id_email">
					<h2 class="sub_title" style="height:48px;margin-top:56px">이메일 인증</h2>
					<div class="pw_search_info">
						회원가입 시 입력한 이메일주소를 입력해주세요.
					</div>
                    <form:form id="form_id_identity" >
                    <input type="hidden" id="loginId" name="loginId"/>
                    <input type="hidden" id="memberDi" name="memberDi"/>
                    </form:form>
					<form id="form_id_email">
					<ul class="login_form">
						<li>
							<span class="login_form_tit">이름</span>
							<span class="login_form_input"><input type="text" id="login_name" name="memberNm" maxlength="50" data-validation-engine="validate[required, maxSize[50]]"></span>
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
							<span class="login_form_input"><input type="text" id="email01" class="email" data-validation-engine="validate[required]"> @ <input type="text" id="email02" class="email" data-validation-engine="validate[required]">
							<div class="select_box select_box_email">
								<label for="select_id_email">직접입력</label>
								<select class="select_option" title="select option" id="select_id_email">
									<option value="etc" selected="selected">직접입력</option>
									<option value="naver.com">naver.com</option>
									<option value="daum.net">daum.net</option>
									<option value="nate.com">nate.com</option>
									<option value="hotmail.com">hotmail.com</option>
									<option value="yahoo.com">yahoo.com</option>
									<option value="empas.com">empas.com</option>
									<option value="korea.com">korea.com</option>
									<option value="dreamwiz.com">dreamwiz.com</option>
									<option value="gmail.com">gmail.com</option>
								</select>
							</div></span>
						</li>
					</ul>
					</form>
					<div class="pw_search_info02">
						<button type="button" class="btn_popup_login" style="margin-top:22px" id="button_id_confirm">확인</button>
					</div>
				</div>
				<!--//이메일 인증일 경우-->
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
	</t:putAttribute>
</t:insertDefinition>