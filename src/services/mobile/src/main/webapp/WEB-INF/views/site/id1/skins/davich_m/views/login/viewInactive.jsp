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
	<t:putAttribute name="title">다비치마켓 :: 로그인</t:putAttribute>


	<t:putAttribute name="script">
		<script>
			jQuery(document).ready(function() {
				 //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

			    <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
			    VarMobile.server = '${server}';

				jQuery('#div_id_email').hide();

				Dmall.validate.set('form_id_email');

								//휴대전화 인증 클릭
				jQuery('button.btn_login_auth_mobile').on('click', function() {
					/*openDRMOKWindow();*/
					jQuery('#div_id_hp').show();
					jQuery('#div_id_hp_mask').show();
					jQuery('#searchEmail').val('');
					jQuery('#certifyValue_email').val('');
					jQuery('#div_id_email').hide();
					jQuery('#div_id_email_mask').hide();
					jQuery('#certifyValue_email').removeClass('check_ok');
					$('#email_confirm').text('전송');
					$('#mobile_confirm').text('전송');

                    $('#mobile_confirm').trigger('click');
				});
				//이메일 인증 클릭
				jQuery('button.btn_login_auth_email').on('click', function() {
					jQuery('#div_id_hp').hide();
					jQuery('#div_id_hp_mask').hide();
					jQuery('#div_id_email').show();
					jQuery('#div_id_email_mask').show();
					jQuery('#searchMobile').val('');
					jQuery('#certifyValue_mobile').val('');
					jQuery('#certifyValue_mobile').removeClass('check_ok');
					$('#email_confirm').text('전송');
					$('#mobile_confirm').text('전송');

					$('#email_confirm').trigger('click');

				});


				//레이어 취소 버튼 클릭
				jQuery('.btn_check_cancel').on('click', function() {
					$(this).parents('.pop_email_check').hide();
					jQuery('.mask').hide();
				});

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
				//이메일,문자 인증 전송 버튼 클릭
				$("#email_confirm,#mobile_confirm").click(function(){
					var _id= $(this).attr("id");

					var searchMethod = "";
					var certifyMethodCd="";
					if(_id == 'email_confirm'){
					  searchMethod = "email";
					  certifyMethodCd ="EMAIL";
					  if($('#searchEmail').val() == ''){
						Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
						return false;
						}
					}else{
					  searchMethod = "mobile";
					  certifyMethodCd ="MOBILE";
					  if($('#searchMobile').val() == ''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력해 주세요.", "확인");
						return false;
						}
					}


					//var url = '/front/login/account-detail';
					var url = '${_MOBILE_PATH}/front/login/inactive-member-detail';
					var param = {
							searchLoginId : '${loginId}',
                            email : jQuery('#searchEmail').val(),
                            searchMobile : jQuery('#searchMobile').val(),
                            certifyMethodCd : certifyMethodCd
                    };
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
						if(result.length > 0) {
							$("#memberNo").val(result[0].memberNo);
							$("#loginId").val(result[0].loginId);
							 var url = '${_MOBILE_PATH}/front/login/send-cetifyvalue';

							 param = {
								 searchMethod : searchMethod,
								 email : result[0].email,
								 mobile : result[0].mobile,
								 memberNo : result[0].memberNo,
								 loginId : result[0].loginId
							 };

							 Dmall.AjaxUtil.getJSON(url, param, function(result) {
								 if(result.success) {
									 //Dmall.LayerUtil.alert("인증번호 발송 성공 하였습니다.", "알림");
									 $("[id^=confirm_number]").show();
									 var confirm_txt = "";
									 if(searchMethod == 'email'){
										 confirm_txt = "인증번호가 전송되었습니다.<br>인증번호를 확인하신 다음 입력해 주세요.";
										 $('#text_check_email').html(confirm_txt);
										 $('#email_confirm').text('재전송');
									 }else{
										 confirm_txt = "인증번호가 전송되었습니다.<br>인증번호를 확인하신 다음 입력해 주세요.";
										 $('#text_check_mobile').html(confirm_txt);
										 $('#mobile_confirm').text('재전송');
									 }
                                     $('#sendCertifyValue').val('Y');
								 }else{
									 Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");
								 }
							 });

						 }else{
							 Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
							 $('#searchEmail').val('');
							 $('#searchMobile').val('');
						 }
					});
				});

				//인증번호 입력시
                $('#certifyValue_email,#certifyValue_mobile').on('focusout', function () {

                    if($(this).val()==''){
                        Dmall.LayerUtil.alert("인증번호를 입력하세요.", "알림");
                        return false;
                    }
					var url = '${_MOBILE_PATH}/front/login/confirm-email';
					var _id = $(this).attr("id");

					var emailCertifyValue="";

					if($('#sendCertifyValue').val()=='N'){
						Dmall.LayerUtil.alert("본인인증을 먼저 진행해 주세요.", "확인");
						return false;
                    }

					if(_id == 'certifyValue_email'){
					  if($('#searchEmail').val() == ''){
						Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
						return false;
					  }
					  emailCertifyValue =jQuery('#certifyValue_email').val();
					}else{
					  if($('#searchMobile').val() == ''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력해 주세요.", "확인");
						return false;
                      }
					  emailCertifyValue =jQuery('#certifyValue_mobile').val();
					}

					$(this).addClass('check_ok');

                    param = {
                        memberNo : jQuery('#memberNo').val(),
                        emailCertifyValue :emailCertifyValue
                    };
                    var confirm_txt ="";
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data != null){
                                 confirm_txt = "인증번호가 확인되었습니다.";
                                 if(_id=="certifyValue_email"){
								 	$('#text_check_email').html(confirm_txt);
								 }else{
								 	$('#text_check_mobile').html(confirm_txt);
								 }
								 $('#certifyYn').val('Y');
                            }else{
                                Dmall.LayerUtil.alert("인증실패 하였습니다.", "알림");
                            }
                        }else{
                            confirm_txt = "인증번호가 일치하지 않습니다.";
                            if(_id=="certifyValue_email"){
								$('#text_check_email').html(confirm_txt);
							 }else{
								$('#text_check_mobile').html(confirm_txt);
							 }
                        }
                    });
                });

                $('#number_confirm_email,#number_confirm_mobile').on('click', function () {
                    var _id = $(this).attr("id");

                    if($('#certifyYn').val()=='N'){
						Dmall.LayerUtil.alert("본인인증을 먼저 진행해 주세요.", "확인");
						return false;
                    }

                    if(_id == 'number_confirm_email'){
					  if($('#searchEmail').val() == ''){
						Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
						return false;
					  }
					}else{
					  if($('#searchMobile').val() == ''){
						Dmall.LayerUtil.alert("휴대폰 번호를 입력해 주세요.", "확인");
						return false;
                      }
					}

                    var push_agreeYn = "";
                    if($('#push_agree_email').prop("checked")){
                        push_agreeYn ="Y";
                    }
                    if($('#push_agree_mobile').prop("checked")){
                        push_agreeYn ="Y";
                    }
					var url = '${_MOBILE_PATH}/front/member/dormant-member-update';
                    var param = $('#form_id_identity').serializeArray();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(push_agreeYn=="Y"){
                                var url = "${_MOBILE_PATH}/front/member/app-info-collect";
                                var param = {eventGb: "1",memberNo:"${memberNo}"};

                                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                                    if (result.success) {
                                        window.location.href = '/front/login/member-login';
                                    }
                                });
                            }else{
                                 window.location.href = '/front/login/member-login';
                            }
                        }
                    });
                });
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

		    function checkDigit(num){
                var Digit = "1234567890";
                var string = num;
                var len = string.length
                var retVal = "";
                for (i = 0; i < len; i++){
                    if (Digit.indexOf(string.substring(i, i+1)) >= 0){
                        retVal = retVal + string.substring(i, i+1);
                    }
                }
                return retVal;
            }

            function phone_format(type, num){
                if(type==1){
                    return num.replace(/([0-9]{4})([0-9]{4})/,"$1-$2");
                }else if(type==2){
                    return num.replace(/([0-9]{2})([0-9]+)([0-9]{4})/,"$1-$2-$3");
                }else{
                    return num.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
                }
            }

		    //전화번호 형식 체크 및 자동 하이픈 넣기
            function chk_tel(str, field){
                var str;
                str = checkDigit(str);
                len = str.length;

                if(len==8){
                    if(str.substring(0,2)==02){
                    }else{
                        field.value  = phone_format(1,str);
                    }
                }else if(len==9){
                    if(str.substring(0,2)==02){
                        field.value = phone_format(2,str);
                    }else{
                        error_numbr(str, field);
                    }
                }else if(len==10){
                    if(str.substring(0,2)==02){
                        field.value = phone_format(2,str);
                    }else{
                        field.value = phone_format(3,str);
                    }
                }else if(len==11){
                    if(str.substring(0,2)==02){
                        error_numbr(str, field);
                    }else{
                        field.value  = phone_format(3,str);
                    }
                }
            }
            // 문자인증 자동인식 호출 script
            window.App = {
			  receivedSms: function(authCode) {
				 $('#certifyValue_mobile').val(authCode);
				 $('#certifyValue_mobile').trigger('focusout');
			  }
			};
		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<form name="form_id_identity" id="form_id_identity">
			<input type="hidden" name="memberNo" id="memberNo"/>
			<input type="hidden" name="loginId" id="loginId" value="${loginId}"/>
			<input type="hidden" name="certifyYn" id="certifyYn" value="N"/>
			<input type="hidden" name="sendCertifyValue" id="sendCertifyValue" value="N"/>
		</form>
    <div id="middle_area">
        <div class="product_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            휴면계정 해지
        </div>
        <div class="cont_body" id="loginLayer">
            <div class="inactivity_login_box">
                <div class="inactivity_text01">
                    회원님의 계정은 휴면상태입니다.
                </div>
                <div class="inactivity_text02">
                    회원님의 계정은 장기간 다비치마켓을 이용하지 않아 휴면 상태로 전환 되었습니다.
                    <em>본인 확인 후 다시 이용하실 수 있습니다.</em>
                </div>

                <button type="button" class="btn_go_inactivity email btn_login_auth_email">이메일로 인증하기<span>가입시 사용했던 계정 이메일로 인증</span></button>
                <%--<c:if test="${mo ne null}">--%>
                <button type="button" class="btn_go_inactivity mobile btn_login_auth_mobile">문자로 인증하기<span>미리 등록한 휴대전화가 있을때 사용가능</span></button>
                <%--</c:if>--%>

                <div class="inactivity_text02">
                    다비치마켓은 회원님의 개인정보보호를 위하여<br> 장기간 로그인 하지 않은 계정을<br>
                    휴면 계정으로 전환 하여 <br>개인정보를 안전 하게 분리 보관하고 있습니다.<br>
                    위 수단으로 본인 확인이 되지 않으면 <br>휴면 계정 해제에 도움을 드리기 어렵습니다.
                </div>
            </div>
        </div>
    </div>
     <!-- popup 이메일 인증 -->
    <div  id="div_id_email" class="popup pop_email_check" style="display: none;">
        <h1 class="pop_tit"><i class="email"></i>이메일로 인증하기</h1>
        <div class="inactivity_text03">
            회원님의 계정 이메일로 휴면계정 해제를 위한 인증번호를 발송하였습니다.<br>
            메일에 포함된 인증번호를 입력해주세요.
        </div>
        <div class="email_check_inner">
            <div class="form_send_area">
                <input type="text" id="searchEmail" name="email" value="${email}" placeholder="ex) davich@davichmarket.com">
                <button type="button" id="email_confirm" name="email_confirm" class="btn_send_again">전송</button>
            </div>
            <input type="text" id="certifyValue_email" name="certifyValue" value=""> <%--class="check_ok"--%>
            <p id="text_check_email"  class="text_check_ok">
                <%--인증번호를 입력해주세요.--%>
                <%--인증번호가 확인되었습니다.--%>
            </p>

            <input type="checkbox" id="push_agree_email" name="push_agree_email" class="agree_check" value="Y">
            <label for="push_agree_email">
                <span></span>
                쿠폰, 기획전, 이벤트, 앱 푸시수신에 동의합니다.
                <p class="check_marginL">(선택사항)</p>
            </label>

            <div class="btn_area">
                <button type="button" class="btn_check_cancel">취소</button>
                <button type="button" id="number_confirm_email" name="number_confirm" class="btn_check_ok">완료</button>
            </div>
        </div>
    </div>
    <div id="div_id_email_mask" class="mask" style="display:none;"></div>

    <!--// popup 이메일 인증 -->
    <!-- popup 문자 인증 -->
    <div id="div_id_hp" class="popup pop_email_check" style="display: none;">
        <h1 class="pop_tit"><i class="sms"></i>문자로 인증하기</h1>
        <div class="inactivity_text03">
            회원님의 휴대전화 번호로 휴면 계정 해제를 위한 인증번호를 발송하였습니다.<br>
            문자에 포함된 인증번호를 입력해주세요.
        </div>
        <div class="email_check_inner">
            <div class="form_send_area">
                <input type="text" id="searchMobile" name="mobile" value="${mobile}" onblur="chk_tel(this.value,this);" numberOnly="true" placeholder="'-'를 포함하여 입력해주세요">
                <button type="button" id="mobile_confirm" name="mobile_confirm" class="btn_send_again">전송</button>
            </div>
            <input type="text" id="certifyValue_mobile" name="certifyValue" value=""> <%--class="check_ok" --%>
            <p id="text_check_mobile" class="text_check_ok">
            <%--인증번호를 입력해주세요.--%>
            <%--인증번호가 확인되었습니다.--%>
            </p>

            <input type="checkbox" id="push_agree_mobile" name="push_agree_mobile" class="agree_check" value="Y">
            <label for="push_agree_mobile">
                <span></span>
                쿠폰, 기획전, 이벤트, 앱 푸시수신에 동의합니다.
                <p class="check_marginL">(선택사항)</p>
            </label>

            <div class="btn_area">
                <button type="button" class="btn_check_cancel">취소</button>
                <button type="button" id="number_confirm_mobile" name="number_confirm" class="btn_check_ok">완료</button>
            </div>
        </div>
        <div class="mask"></div>
    </div>
    <div id="div_id_hp_mask" class="mask" style="display:none;"></div>
    <!--// popup 휴대폰 인증 -->


















		<!--- contents --->
		<%--<div class="contents fixwid">
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
                    &lt;%&ndash;이메일인증은 기획상 아예 삭제하기로 합의하였지만 추후 또 무슨 얘기가 나올지 모르므로 버튼만 감춰놓는다&ndash;%&gt;
					&lt;%&ndash; <button type="button" class="btn_login_auth_email">이메일 인증</button> &ndash;%&gt;
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
		</div>--%>
	</t:putAttribute>
</t:insertDefinition>