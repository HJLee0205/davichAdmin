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
    <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
    <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
    <script>
		var captcha = false;
		var state = "";
		$(document).ready(function(){
			$('.btn_go_prev').on('click',function(){
		        history.back();
		    });

		    $("#btn_join_ok").click(function(){
		        location.href="${_MOBILE_PATH}/front/member/terms-apply";
		    });
		    $("#btn_join_ok_n").click(function(){
		        location.href="${_MOBILE_PATH}/front/member/terms-apply";
		    });

			$("#loginBtn").click(function(){
			     loginProc();
			  /*   if(jQuery('#loginId').val() === '') {
			        Dmall.LayerUtil.alert("아이디 항목은 필수 입력값입니다.", "확인");
			        return false;
			    }
			    if(jQuery('#password').val() === '') {
			        Dmall.LayerUtil.alert("비밀번호 항목은 필수 입력값입니다.", "확인");
			        return false;
			    }

				saveId(document.loginForm);

				var options = {
					url : "<spring:url value='${_MOBILE_PATH}/front/login/loginprocess' />"
					, data : $("#loginForm").serialize()
					, callBack : function(data) {
						if(data.resultCode == 'S') {
						    if(data.returnUrl.indexOf('order-form') > -1 ) {
						        $('#orderForm').submit();
						    } else {
						        location.href = data.returnUrl;
						    }
						} else {
							if(data.resultMsg) {
								alert(data.resultMsg);
							}
							$('#password').focus();
							return;
						}
					}
				};

				Dmall.waiting.start();

				jQuery.ajaxSettings.traditional = true;

				options.contentType = options.contentType || "application/x-www-form-urlencoded;charset=UTF-8";
				options.type = options.type || "POST";
				options.dataType = options.dataType || "json";

				$.ajax({
							url : options.url
							, type : options.type
							, dataType : options.dataType
							, contentType : options.contentType
							, cache : false
							, data : options.data
						})
						.done(function(data, textStatus, jqXHR){
								try {
									var obj = data;

									if(obj.exCode != null && obj.exCode != undefined && obj.exCode != ""){
										Dmall.waiting.stop();
										if(obj.exMsg) {
											Dmall.LayerUtil.alert(obj.exMsg);
										}
										if(captcha) {
											viewCaptcha();
										} else {
											if(obj.exCode === 'INACTIVE') {
												window.location.href = HTTPS_SERVER_URL + obj.redirectUrl;
											}
											if (obj.exCode === "L") {
												viewCaptcha();
												captcha = true;
											}
										}
									} else {
										options.callBack(data);
									}
								} catch (e) {
									options.callBack(data);
								}
						})
						.fail(function( xhr, status, error ){
							if(xhr.status == 1000) {
								location.replace("/login/view-no-session");
							} else {
								alert("오류가 발생되었습니다. 관리자에게 문의하십시요.["+xhr.status+"]["+error+"]");
							}
						})
						.always(function(){
						    Dmall.waiting.stop();
						})
						.then(function(data, textStatus, jqXHR ) {

						}); */
			});

			// 비회원구매하기
			$("#nomember").click(function(){
			    var returnUrl = '${param.returnUrl}';
			    var adult_product = '${param.type}';
			    if(adult_product  == 'adult'){
			        Dmall.LayerUtil.alert("비회원은 성인상품을 구매하실수 없습니다.<br>회원가입후 이용해주시기 바랍니다.", "확인");
                    return false;
			    }else{
			        if(returnUrl.indexOf('order-form') > -1) {
			            $('#orderForm').submit();
			        } else {
			            location.href = '${param.returnUrl}';
			        }
			    }
			});

			/* $("#password").keydown(function(event) {
				if(event.keyCode == 13) {
					$('#loginBtn').click();
					return false;
				}
			});

			getId(document.loginForm); */
			getId(document.loginForm);

			if ( "" != document.loginForm.loginId.value ) {
				$('#password').focus();
			}

			/* $("#loginId").val("customer");
			$("#password").val("customer"); */

            $("#ordNo, #ordrMobile").keydown(function(e){
                if(e.keyCode == 13){
                    if($('#ordNo').val() === '') {
                        Dmall.LayerUtil.alert("주문번호를 입력해주세요.", "확인");
                        return false;
                    }
                    if($('#ordrMobile').val() === '') {
                        Dmall.LayerUtil.alert("모바일번호를 입력해주세요.", "확인");
                        return false;
                    }
                    nonMember_order_list();//비회원주문내역으로 이동
                }
            });


			//비회원 로그인
			$("#btn_nonmember_login").click(function(){
			    if($('#ordNo').val() === '') {
			        Dmall.LayerUtil.alert("주문번호를 입력해주세요.", "확인");
			        return false;
			    }
			    if($('#ordrMobile').val() === '') {
			        Dmall.LayerUtil.alert("모바일번호를 입력해주세요.", "확인");
			        return false;
			    }
			    nonMember_order_list();//비회원주문내역으로 이동
			});

			// #ID SERACH_FORM
            $("#btn_id_search").click(function(){
                move_page('id_search');
            });
            // #PASSWORD SEARCH
            $("#btn_password_search").click(function(){
                move_page('pass_search');
            });

			var naver = new naver_id_login("${snsMap.get('naverClientId')}", location.origin+"${_MOBILE_PATH}/front/login/naver-login-return");
			state = naver.getUniqState();
		});

        function loginProc() {
            if(jQuery('#loginId').val() === '') {
                Dmall.LayerUtil.alert("아이디 항목은 필수 입력값입니다.", "확인");
                return false;
            }
            if(jQuery('#password').val() === '') {
                Dmall.LayerUtil.alert("비밀번호 항목은 필수 입력값입니다.", "확인");
                return false;
            }

            saveId(document.loginForm);

            var options = {
                url : "<spring:url value='/front/login/loginprocess' />"
                , data : $("#loginForm").serialize()
                , callBack : function(data) {
                    if(data.resultCode == 'S') {
                        if(data.resultMsg) {
                            alert(data.resultMsg);
                        }
                        if(data.returnUrl.indexOf('order-form') > -1 ) {
                            $('#orderForm').submit();
                        } else {
                            location.href = data.returnUrl;
                        }
                    } else {
                        if(data.resultMsg) {
                            alert(data.resultMsg);
                        }
                        $('#password').focus();

                    }
                }
            };

            Dmall.waiting.start();

            jQuery.ajaxSettings.traditional = true;

            options.contentType = options.contentType || "application/x-www-form-urlencoded;charset=UTF-8";
            options.type = options.type || "POST";
            options.dataType = options.dataType || "json";

            $.ajax({
                        url : options.url
                        , type : options.type
                        , dataType : options.dataType
                        , contentType : options.contentType
                        , cache : false
                        , data : options.data
                    })
                    .done(function(data, textStatus, jqXHR){
                            try {
                                var obj = data;

                                if(obj.exCode != null && obj.exCode != undefined && obj.exCode != ""){
                                    Dmall.waiting.stop();
                                    if(obj.exMsg) {
                                        Dmall.LayerUtil.alert(obj.exMsg);
                                    }
                                    if(captcha) {
                                        viewCaptcha();
                                    } else {
                                        if(obj.exCode === 'INACTIVE') {
                                            $('#inactiveLoginId').val($('#loginId').val());
                                            $('#inactiveForm').attr('action', HTTPS_SERVER_URL + obj.redirectUrl);
                                            $('#inactiveForm').submit();
                                        }
                                        if (obj.exCode === "L") {
                                            viewCaptcha();
                                            captcha = true;
                                        }
                                    }
                                } else {
                                    options.callBack(data);
                                }
                            } catch (e) {
                                options.callBack(data);
                            }
                    })
                    .fail(function( xhr, status, error ){
                        if(xhr.status == 1000) {
                            location.replace("/login/view-no-session");
                        } else {
                            alert("오류가 발생되었습니다. 관리자에게 문의하십시요.["+xhr.status+"]["+error+"]");
                        }
                    })
                    .always(function(){
                        Dmall.waiting.stop();
                    })
                    .then(function(data, textStatus, jqXHR ) {

                    });
        }

		function return_auth(){
		    Dmall.LayerPopupUtil.close('password_search_pop');
            Dmall.LayerPopupUtil.open('password_chage_pop');
		}

		function viewCaptcha() {
			var captcha = '<li><img src="${_MOBILE_PATH}/front/common/capcha" id="img_id_captcha"> <button type="button" class="btn_reload" id="img_id_reload">새로고침</button></li>';
				captcha += '<li><input type="text" name="captcha" placeholder="자동입력 방지문자를 입력해주세요"></li>';
			/* var captcha = '<li><span class="login_form_notit"></span><span class="login_form_input_n"><img src="/front/common/capcha" id="img_id_captcha" /><button type="button" style="width:27px; height:27px; margin-left:10px; vertical-align:top" id="img_id_reload"><img src="/front/img/common/reload.png" alt="새로고침"></button></span></li>'
			captcha += '<li><span class="login_form_notit"></span><span class="login_form_input"><input type="text" class="s_ipt" name="captcha" placeholder="자동입력 방지문자를 입력해주세요."></span></li>' */
			jQuery('.id_save_check').nextUntil('#li_id_loginBtn').remove();
			jQuery('.id_save_check').after(captcha);

			$('#img_id_reload').on('click', function() {

				$('#img_id_captcha').attr('src', '${_MOBILE_PATH}/front/common/capcha?dummy=' + new Date());
			});
		}

		function saveId(form) {
			var expdate = new Date();
			// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
			if (form.checkId.checked)
				expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
			else
				expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건

			setCookie("dmallSaveId", form.loginId.value, expdate);
		}

		function getId(form) {
			var checked = "" != (form.loginId.value = getCookie("dmallSaveId"));
			if(checked) {
				jQuery('#id_save').prop('checked', checked);
			}
		}

		//SNS로그인
		function snsLogin(snsType) {
		    switch(snsType){
		        case 'facebook':
		            loginFacebook();
		            break;
		        case 'naver':
		            loginNaver();
		            break;
		        case 'kakao':
		            loginKakao();
	            break;
		    }
		}

		function snsLoginProcess(accessToken, path){

		    Dmall.waiting.start();

            var data = {'accessToken':accessToken, 'path':path};
            var url = "/m/front/login/sns-login";
            Dmall.AjaxUtil.getJSON(url, data, function(result){
                if(result.success){
                    var param = {sns_add_info_Yn : result.data.firstJoinYn};
                    var url = HTTP_SERVER_URL + '${_MOBILE_PATH}/front/main-view';
                    Dmall.FormUtil.submit(url, param);
                    Dmall.waiting.stop();
                } else {
                    Dmall.LayerUtil.alert("로그인에 실패하였습니다.");
                    Dmall.waiting.stop();
                }
            });

		}

		//네이버
		function loginNaver() {

            var state_value = state;
            var url_SnsNaverLogin = "";
            var redirectUrl = location.origin+"${_MOBILE_PATH}/front/login/naver-login-return";
            var naverClientId = "${snsMap.get('naverClientId')}";
            url_SnsNaverLogin = "https://nid.naver.com/oauth2.0/authorize?client_id="+naverClientId+"&response_type=token&redirect_uri="+redirectUrl+"&state="+state_value;
            var winOpen = window.open(url_SnsNaverLogin, "naverlogin", "titlebar=1, resizable=1, scrollbars=yes, width=600, height=550");
		}

        //페이스북
        function loginFacebook() {
            //initializes the facebook API
            FB.init({
               appId:"${snsMap.get('fbAppId')}",
               cookie:true,
               status:true,
               xfbml:true,
               version:'v2.6' // use version 2.6
            });

            FB.login(handelStatusChange,{scope:'public_profile, email',auth_type: 'rerequest'});
        }

        var fbUid = "";
        var fbName = "";
        var fbEmail = "";
        var indexUrl = "${_MOBILE_PATH}/front/main-view";

        function handelStatusChange(response) {
            if (response && response.status == 'connected') {
                var accessToken = response.authResponse.accessToken;
                var code = response.authResponse.code;
                snsLoginProcess(accessToken, 'FB');
            } else if (response.status == 'not_authorized' || response.status == 'unknown') {
                alert("연결을 취소 하였습니다.");
            }else{
                alert("연결을 취소 하였습니다.");
            }
        }

        (function(d, s, id){
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {return;}
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/ko_KR/sdk.js#xfbml=1&version=v2.6&appId=${snsMap.get('fbAppId')}";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));

        // 카카오톡
        Kakao.init("${snsMap.get('javascriptKey')}");
        function loginKakao() {
            // 로그인 창을 띄웁니다.
            Kakao.Auth.login({
                success: function(authObj) {
                    var accessToken = authObj.access_token;
                    var code = "";
                    snsLoginProcess(accessToken, 'KT');
                },
                fail: function(err) {
                    alert("사용자 연결취소 하였습니다.");
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
			로그인
		</div>
		<ul class="login_menu">
			<li class="active" rel="login_select01">회원</li>
			<li rel="login_select02">소셜로그인</li>
			<li rel="login_select03">비회원</li>
		</ul>
		<!-- 회원 로그인시 -->
		<div class="login_content" id="login_select01">

		<form name="loginForm" id="loginForm" method="post" role="form">
            <input type="hidden" name="returnUrl" value="${param.returnUrl}" />
			<ul class="member_login_form">
				<li><input type="text" name="loginId" id="loginId" value="${user.session.loginId}" placeholder="아이디"></li>
				<li id="li_id_pw"><input type="password" name="password" id="password" placeholder="비밀번호" autocomplete="off"></li>

				<li class="id_save_check">
					<div class="checkbox">
						<label>
							<input type="checkbox" name="auto_login" value="Y" ${user.session.loginId!=""?checked:""}>
							<span></span>
						</label>
						<label for="auto_login"><b>자동로그인</b></label>
					</div>
					<div class="checkbox">
						<label>
							<input type="checkbox" name="checkId" id="id_save">
							<span></span>
						</label>
						<label for="id_save"><b>아이디저장</b></label>
					</div>
				</li>
				<span id="li_id_loginBtn"></span>
			</ul>
		</form>

			<!--- 성인인증 --->
			<c:if test="${param.type eq 'adult'}">
			<div class="age_warning_area">
				<div class="warning_19">
					<span class="title" style="text-align:center">
						<em>19세 이상만</em> 조회/구매가 가능한 상품입니다.
					</span>
					<span style="text-align:center">이 컨텐츠는 청소년 유해매체물로서 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 청소년보호법 규정에 의하여 19세미만의 청소년이 이용할 수 없습니다.</span>
					<div class="warning_19_bottom">
						로그인 후 상품 조회/구매 가능합니다.<br>
						비회원일 경우에는 회원가입을 해주세요.
					</div>
				</div>
			</div>
			</c:if>
			<!---// 성인인증 --->
			<ul class="member_login_form" style="margin-top:15px">
				<li><button type="button" class="btn_member_login" id="loginBtn">로그인</button></li>
				<c:if test="${orderYn eq 'Y'}">
 				<li><button type="button" class="btn_nonmember_checkout" id="nomember">비회원으로 구매하기</button></li>
 				</c:if>
				<li class="login_smenu">
					<a href="#" id="btn_id_search">아이디 찾기</a>
					<a href="#" id="btn_password_search">비밀번호 찾기</a>
					<a href="#" id="btn_join_ok">회원가입</a>
				</li>
			</ul>
		</div>
		<!--// 회원 로그인시 -->
		<!-- 소셜 로그인시 -->
		<div class="login_content" id="login_select02">
			<div class="sns_login_info">
				페이스북, 네이버, 카카오 계정을 이용하셔도<br>
				다양한 서비스를 이용할 수 있습니다.
				<div class="sns_btn_area">
				<c:forEach var="snsList" items="${snsOutsideLink.resultList}" varStatus="status">
				<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '01'}">
					<button type="button" class="btn_login_sns">
						<a href="javascript:snsLogin('facebook');" ><img src="${_MOBILE_PATH}/front/img/member/login_facebook.png" alt="페이스북으로 로그인"></a>
					</button>
				</c:if>
				<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '02'}">
					<button type="button" class="btn_login_sns">
						<a href="javascript:snsLogin('naver');" ><img src="${_MOBILE_PATH}/front/img/member/login_naver.png" alt="네이버로 로그인"></a>
					</button>
				</c:if>
				<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '03'}">
					<button type="button" class="btn_login_sns">
						<a href="javascript:snsLogin('kakao');" ><img src="${_MOBILE_PATH}/front/img/member/login_kakao.png" alt="카카오로 로그인"></a>
					</button>
				</c:if>
				</c:forEach>
				</div>
			</div>
            <button type="button" class="btn_member_login" id="btn_sns">임시-소셜로그인시 정보기입창</button><!--개발시 삭제해주세요-->
		</div>
		<!--// 소셜 로그인시 -->
		<!-- 비회원 로그인시 -->
		<div class="login_content" id="login_select03">
		<form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
			<ul class="member_login_form">
				<li><input type="text" id="ordNo" name="ordNo" placeholder="주문번호"></li>
				<li><input type="text" id="ordrMobile" name="ordrMobile" placeholder="주문고객 휴대폰"></li>
				<li><button type="button" id="btn_nonmember_login" class="btn_nonmember_checkout">비회원 주문조회</button></li>
				<li><button type="button" class="btn_member_login" id="btn_join_ok_n">회원가입</button></li>
			</ul>
		</form>
		</div>
		<!--// 비회원 로그인시 -->
	</div>

	<!--- alert form --->
	<div id="popup_agress_alert" class="popup">
		<div class="popup_head">
			알림
			<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
		</div>
		<div>
			<p class="popup_alert_txt">자동 입력 방지를 올바르게 입력하셨는지 확인바랍니다.</p>
            <!--p class="popup_alert_txt">아이디 항목은 필수 입력값입니다.</p-->
            <!--p class="popup_alert_txt">입력하신 정보로 가입된 내역이 없습니다.</p-->
            <!--p class="popup_alert_txt">비밀번호 항목은 필수 입력값입니다.</p-->
            <!--p class="popup_alert_txt">로그인 정보가 올바르지 않습니다.</p-->
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_popup_cancel closepopup">확인</button>
		</div>
	</div>
	<!---// alert form --->

    <!--- popup_소셜로그인 정보기입 --->
	<div id="popup_snsinfo_select" class="popup">
		<div class="popup_head">
			소셜로그인 부가정보 입력
			<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
		</div>
		<div class="popup_snsinfo">
			<ul>
                <li>
                    <span class="sns_info_stit">휴대폰</span>
                    <div>
                        <select style="width:calc(31% - 5px)">
                            <option>선택</option>
                        </select>
                        <input type="text" style="width:calc(32% - 5px)">
                        <input type="text" style="width:calc(32% - 5px)">
                    </div>
                </li>
                <li>
                	<span class="sns_info_stit">주소</span>
                    <div>
                        <input type="text" style="width:calc(30% - 12px)">
                        <button type="button" class="btn_ppost">우편번호</button>
                        <input type="text" placeholder="(지번)" class="address" style="width:calc(100% - 12px) ;">
                        <input type="text" placeholder="(도로명)"  class="address" style="width:calc(100% - 12px) ;">
                        <input type="text" placeholder="(공통 상세주소)"  class="address" style="width:calc(100% - 12px) ;">
                    </div>
                </li>
                <li>
                	※ 상단 정보는 배송을 위한 기본정보 입니다.
                </li>
            </ul>

		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_popup_ok">확인</button>
            <button type="button" class="btn_popup_cancel closepopup">취소</button>
		</div>
	</div>
	<!---// popup_소셜로그인 정보기입 --->

    <!---// 03.LAYOUT:CONTENTS --->
	<c:if test="${orderYn eq 'Y'}">
        <form name="orderForm" id="orderForm" action="${_MOBILE_PATH}/front/order/order-form" method="post">
            <c:forEach var="itemArr" items="${itemArr}" varStatus="status">
            <input type="hidden" name="itemArr" value="${itemArr}">
            </c:forEach>
        </form>
	</c:if>
	</t:putAttribute>

</t:insertDefinition>