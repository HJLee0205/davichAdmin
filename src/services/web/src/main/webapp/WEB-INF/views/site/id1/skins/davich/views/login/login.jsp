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
		<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
		<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
		<script>
            var captcha = false
            var state = "";

            var type='${param.type}';


            $(document).ready(function(){

				 $(".btn_go_nomember").click(function(){
                   $("#tab1").hide();
                   $("#tab2").show();
                   $("#tab3").hide();
                });

                $(".btn_rsv_nomember").click(function(){
                   $("#tab1").hide();
                   $("#tab2").hide();
                   $("#tab3").show();
                });
				if(type==''){
				  $("#tab1").show();
				  $("#tab2").hide();
                  $("#tab3").hide();
				}
                if(type=='nomemOrd'){
            	 $(".btn_go_nomember").trigger('click');
				}

				if(type=='nomemRsv'){
					$(".btn_rsv_nomember").trigger('click');
				}



                $("#btn_join_ok").click(function(){
                    location.href="/front/member/terms-apply";
                });


                $("#loginId, #password").keydown(function(e){
                    var doPrevent = false;

                    if(e.keyCode == 13){
                        var d = e.srcElement || e.target;
                        if ((d.tagName.toUpperCase() === 'INPUT' &&
                                (
                                    d.type.toUpperCase() === 'TEXT' ||
                                    d.type.toUpperCase() === 'PASSWORD' ||
                                    d.type.toUpperCase() === 'FILE' ||
                                    d.type.toUpperCase() === 'SEARCH' ||
                                    d.type.toUpperCase() === 'EMAIL' ||
                                    d.type.toUpperCase() === 'NUMBER' ||
                                    d.type.toUpperCase() === 'DATE' )
                            ) ||
                            d.tagName.toUpperCase() === 'TEXTAREA') {
                            doPrevent = d.readOnly || d.disabled;
                            Dmall.EventUtil.stopAnchorAction(e);
                            loginProc();
                        } else {
                            doPrevent = true;
                        }

                        if (doPrevent) {
                            Dmall.EventUtil.stopAnchorAction(e);
                        }
                    }
                });

                $("#loginBtn").click(function(){
                    loginProc();
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

                getId(document.loginForm);

                if ( "" != document.loginForm.loginId.value ) {
                    $('#password').focus();
                }

                //$("#loginId").val("customer");
                //$("#password").val("customer");

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
                        Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "확인");
                        return false;
                    }
                    nonMember_order_list();//비회원주문내역으로 이동
                });

                //비회원 방문예약 조회
                $("#btn_nonmember_rsv").click(function(){

                    if($('#rsvName').val() === '') {
                        Dmall.LayerUtil.alert("이름을 입력해주세요.", "확인");
                        return false;
                    }

                    if($('#rsvNo').val() === '') {
                        Dmall.LayerUtil.alert("예약번호를 입력해주세요.", "확인");
                        return false;
                    }
                    if($('#rsvMobile').val() === '') {
                        Dmall.LayerUtil.alert("휴대폰번호를 입력해주세요.", "확인");
                        return false;
                    }
                    nonMember_rsv_list();//비회원 방문예약 내역으로 이동
                });

                // #ID SERACH_FORM
                $("#btn_id_search").click(function(){
                    move_page('id_search');
                });
                // #PASSWORD SEARCH
                $("#btn_password_search").click(function(){
                    move_page('pass_search');
                });

                var naver = new naver_id_login("${snsMap.get('naverClientId')}", location.origin+"/front/login/naver-login-return");
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

						var visionYn = "${visionYn}";

						if (data.resultCode == 'S') {
							if (data.resultMsg) {
								alert(data.resultMsg);
							}
							if (data.returnUrl.indexOf('order-form') > -1) {
								$('#orderForm').submit();

							} else if (data.returnUrl.indexOf('vision-check') > -1) {

								if (visionYn == 'Y') {
									$('#form_vision_check').submit();

								} else {
									$('#returnForm').attr("action", data.returnUrl);
									$('#returnForm').submit();
									//location.href = data.returnUrl;
								}
							} else {
								<c:if test="${orderYn eq 'Y'}">
								$('#orderForm').attr("action", data.returnUrl + "?orderYn=Y");
								$('#orderForm').submit();
								</c:if>
								<c:if test="${orderYn ne 'Y'}">
								if (visionYn == 'Y') {
									$('#form_vision_check').attr("action", data.returnUrl + "?visionYn=Y");
									$('#form_vision_check').submit();

								} else {
									<c:if test="${orderYn ne 'Y'}">
									$('#returnForm').attr("action", data.returnUrl);
									$('#returnForm').submit();
									</c:if>
								}
								</c:if>
							}
						} else {
							if (data.resultMsg) {
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
                var captcha = '<li><span class="login_form_notit"></span><span class="login_form_input_n"><img src="/front/common/capcha" id="img_id_captcha" /><button type="button" style="width:27px; height:27px; margin-left:10px; vertical-align:top" id="img_id_reload"><img src="/front/img/common/reload.png" alt="새로고침"></button></span></li>'
                captcha += '<li><span class="login_form_notit"></span><span class="login_form_input"><input type="text" class="s_ipt" name="captcha" placeholder="자동입력 방지문자를 입력해주세요."></span></li>'
                jQuery('#li_id_pw').nextUntil('#li_id_loginBtn').remove();
                jQuery('#li_id_pw').after(captcha);

                $('#img_id_reload').on('click', function() {
                    $('#img_id_captcha').attr('src', '/front/common/capcha?dummy=' + new Date());
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

                var data = {'accessToken':accessToken, 'path':path};
                var url = "/front/login/sns-login"
                Dmall.AjaxUtil.getJSON(url, data, function(result){
                    if(result.success){
                        var param = {sns_add_info_Yn : result.data.firstJoinYn}
                        var url = HTTP_SERVER_URL + '/front/main-view';
                        Dmall.FormUtil.submit(url, param);
                    } else {
                        //Dmall.LayerUtil.alert(result.message);
                    	cancel_member_leave(result.extraString, accessToken, path);
                    }
                });

            }
            
            function cancel_member_leave(loginId, accessToken, path){
            	Dmall.LayerUtil.confirm("회원탈퇴된 계정입니다.<br>재로그인 시 회원탈퇴 신청이 취소됩니다.<br>로그인 하시겠습니까?",function() {
                    var url = '/front/member/withdrawal-member-update';
                    var data = {'loginId':loginId};
                    Dmall.AjaxUtil.getJSON(url, data, function(result) {
                       if(result.success) {
                    	   snsLoginProcess(accessToken, path);
                       }else{
                    	   Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');
                           return;
                       }
                    });
                })
            }

            //네이버
            function loginNaver() {

                var state_value = state;
                var url_SnsNaverLogin = "";
                var redirectUrl = location.origin+"/front/login/naver-login-return";
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
            var indexUrl = "/front/main-view";

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

            //페이스북 api
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
            };

		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<!--- contents --->
		<c:set var="snsTabHideCnt" value="0"/>
		<c:set var="linkOperYnCnt" value="0"/>
		<c:forEach var="snsList" items="${snsOutsideLink.resultList}" varStatus="status">
			<c:if test="${snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd ne '04'}">
				<c:set var="linkOperYnCnt" value="${linkOperYnCnt + 1}"/>
			</c:if>

			<c:if test="${snsList.linkUseYn ne 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '01'}">
				<c:set var="snsTabHideCnt" value="${snsTabHideCnt + 1}"/>
			</c:if>
			<c:if test="${snsList.linkUseYn ne 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '02'}">
				<c:set var="snsTabHideCnt" value="${snsTabHideCnt + 1}"/>
			</c:if>
			<c:if test="${snsList.linkUseYn ne 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '03'}">
				<c:set var="snsTabHideCnt" value="${snsTabHideCnt + 1}"/>
			</c:if>
		</c:forEach>

		<c:set var="tabWidth" value="0"/>
		<c:choose>
			<c:when test="${snsTabHideCnt eq linkOperYnCnt}"><c:set var="tabWidth" value="49.5"/></c:when>
			<c:otherwise><c:set var="tabWidth" value="33"/></c:otherwise>
		</c:choose>
		<div id="member_container">
			<div class="tab_content" id="tab1" style="display:none;">
				<h3 class="login_stit">
					로그인
					<div class="login_off_info">					
						<span class="icon_off_info">오프라인 매장에서 가입하셨나요?</span>
						<p>다비치 안경 매장에서 회원으로 가입하신 경우 로그인 <em>아이디</em>는 본인의 <em>휴대폰번호</em>입니다.</br>
						비밀번호는 <a href="javascript:;" onClick="move_page('pass_search');"><em>비밀번호 찾기</em></a>를 이용해 재설정 가능합니다.</p>
					</div>
				</h3>
				<c:if test="${param.type eq 'adult'}">
					<div class="login_adult">
						<p><strong><span class="fRed">19세 이상만</span> 조회/구매가 가능한 상품입니다.</strong></p>
						<p class="txt1">이 컨텐츠는 청소년 유해매체물로서 정보통신망 이용촉진 및 정보보호 등에 관한 법률 및 <br/>
							청소년보호법 규정에 의하여 19세 미만의 청소년이 이용할 수 없습니다.</p>
						<p class="txt2">로그인 후 상품 조회/구매 가능합니다.<br/>
							비회원일 경우에는 회원가입을 해주세요.</p>
					</div>
				</c:if>
				<div class="login_area">
					<form name="loginForm" id="loginForm" method="post" role="form">
						<input type="hidden" name="returnUrl" value="${param.returnUrl}" />
						<input type="hidden" name="refererType" value="${param.refererType}" />
						<ul class="form_login">
							<li><label for="">아이디</label><input type="text" name="loginId" id="loginId" placeholder="아이디"></li>
							<li><label for="">비밀번호</label><input type="password" name="password" id="password" placeholder="영문,숫자,특수문자 4~16자" autocomplete="off"></li>
							<li><button type="button" class="btn_login" id="loginBtn" class="btn_login">로그인</button></li>

							<li class="login_check_area">
								<div class="left_check">
									<input type="checkbox" class="idsave_check" name="checkId" id="id_save">
									<label for="id_save"><span></span>아이디저장</label>
								</div>
								<div class="right_link">
									<a href="#" id="btn_id_search">아이디찾기</a>
									<a href="#" id="btn_password_search">비밀번호찾기</a>
								</div>
							</li>
							<c:if test="${orderYn eq 'Y' and !fn:contains(param.returnUrl,'/visit/visit-book')}">
								<li class="login_button"><button type="button" id="nomember" class="btn_nonmember_login">비회원으로 구매하기</button></li>
								<li class="warning_row">
									비회원으로 구매하시면 ${site_info.siteNm} 쇼핑 혜택을 받으실 수 없으며, <br>
									할인이벤트, 경품이벤트 등 다양한 회원이벤트도 참여하실 수 없습니다.
								</li>
							</c:if>
						</ul>
					</form>
					<p class="login_guide">
						별도의 회원가입 없이 <b>네이버, 카카오, 페이스북</b> 계정으로도 로그인 하실 수 있습니다.<br>
						단, 다비치마켓의 마켓포인트가 지급되지 않으며, 예약 등 일부 서비스도 제한됩니다.
					</p>
					<div class="login_sns">
						<c:forEach var="snsList" items="${snsOutsideLink.resultList}" varStatus="status">
							<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '02'}">
								<button type="button" id="naver_id_login" class="btn_login_naver" onclick="javascript:snsLogin('naver');"><i></i>네이버</button>
							</c:if>
							<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '03'}">
								<button type="button" class="btn_login_kakao" onclick="javascript:snsLogin('kakao');"><i></i>카카오톡</button>
							</c:if>
							<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '01'}">
								<button type="button" class="btn_login_fbook" onclick="javascript:snsLogin('facebook');"><i></i>페이스북</button>
							</c:if>
						</c:forEach>
					</div>

					<p class="guide_membership">
						온오프라인 통합멤버쉽, 맞춤서비스, 다비치포인트, 마켓포인트 등 다비치마켓의 풍성한 혜택을 모두 제공받으시려면!
						<button type="button" class="btn_go_sign" id="btn_join_ok">회원가입</button>
					</p>
					<p class="guide_membership">
						회원가입 없이 비회원으로 주문 하셨다면!

						<button type="button" class="btn_go_nomember">비회원주문조회</button>

						<button type="button" class="btn_rsv_nomember">비회원방문예약조회</button>
					</p>
				</div>
			</div>

			<!--- tab03: 비회원 영역 --->
			<div class="tab_content" id="tab2" style="display:none;">
				<div class="nonmemberlogin_box">
					<h3 class="login_stit">
						비회원로그인
						<span>비회원이더라도 주문번호와, 휴대폰 번호만 있으면 다양한 서비스를 이용할 수 있습니다.<br>
				아래 정보를 입력 하면 주문조회 페이지가 열립니다.</span>
					</h3>
					<form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
						<ul class="login_form">
							<li>
								<span class="login_form_tit">주문번호</span>
								<span class="login_form_input"><input type="text" id="ordNo" name="ordNo"></span>
							</li>
							<li>
								<span class="login_form_tit">휴대폰번호</span>
								<span class="login_form_input"><input type="text" id="ordrMobile" name="ordrMobile"></span>
							</li>
							<li class="login_button"><button type="button" id="btn_nonmember_login" class="btn_login">비회원 주문조회</button></li>
							<li class="warning_row">
								※ 주문번호 및 주문하실때 등록한 휴대폰 번호를 입력해 주시기 바랍니다.
							</li>
						</ul>
					</form>
				</div>
			</div>

			<div class="tab_content" id="tab3" style="display:none;">
				<div class="nonmemberlogin_box">
					<h3 class="login_stit">
						비회원 예약조회
						<span>
							  비회원으로 방문예약하신 고객님을 위한 로그인 페이지입니다.<br>
							  아래 정보를 입력하시면 비회원 방문예약 조회 페이지가 열립니다.
						</span>
					</h3>
					<form name="nonMemberRsvForm" id="nonMemberRsvForm" method="post" role="form">
						<ul class="login_form">
							<li>
								<span class="login_form_tit">이름</span>
								<span class="login_form_input"><input type="text" id="rsvName" name="rsvName"></span>
							</li>
							<li>
								<span class="login_form_tit">예약번호</span>
								<span class="login_form_input"><input type="text" id="rsvNo" name="rsvNo"></span>
							</li>
							<li>
								<span class="login_form_tit">휴대폰번호</span>
								<span class="login_form_input"><input type="text" id="rsvMobile" name="rsvMobile"></span>
							</li>
							<li class="login_button"><button type="button" id="btn_nonmember_rsv" class="btn_login">비회원 방문예약 조회</button></li>
							<li class="warning_row">
								※ 비회원 방문예약하실 때 등록한 이름과 휴대폰번호를  <br> 입력해 주시기 바랍니다.
							</li>
						</ul>
					</form>
				</div>
			</div>
			<!---// tab03: 비회원 영역 --->

			<!---// contents --->
			<c:if test="${orderYn eq 'Y'}">
				<form name="orderForm" id="orderForm" action="/front/order/order-form" method="post">
					    <input type="hidden" name="orderYn" value="Y">
					    <input type="hidden" name="rsvOnlyYn" value="${param.rsvOnlyYn}">
					<c:forEach var="itemArr" items="${itemArr}" varStatus="status">
						<input type="hidden" name="itemArr" value="${itemArr}">
					</c:forEach>
				</form>
			</c:if>
			<c:if test="${visionYn eq 'Y'}">
				<form:form id="form_vision_check" name="form_vision_check" method="post" action="${visionMap.returnUrl}">
					<input type="hidden" name="visionYn" value="Y">
					<input type="hidden" name="lensType" id="lensType" value="${visionMap.lensType}">
					<input type="hidden" name="ageCdG" id="ageCdG" value="${visionMap.ageCdG}">
					<input type="hidden" name="ageCdC" id="ageCdC" value="${visionMap.ageCdC}">
					<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${visionMap.ageCdGNm}">
					<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${visionMap.ageCdCNm}">
					<input type="hidden" name="wearCd" id="wearCd" value="${visionMap.wearCd}">
					<input type="hidden" name="wearCdNm" id="wearCdNm" value="${visionMap.wearCdNm}">
					<input type="hidden" name="contactTypeCd" id="contactTypeCd" value="${visionMap.contactTypeCd}">
					<input type="hidden" name="contactTypeCdNm" id="contactTypeCdNm" value="${visionMap.contactTypeCdNm}">
					<input type="hidden" name="wearTimeCd" id="wearTimeCd" value="${visionMap.wearTimeCd}">				
					<input type="hidden" name="wearTimeCdNm" id="wearTimeCdNm" value="${visionMap.wearTimeCdNm}">		
					<input type="hidden" name="wearDayCd" id="wearDayCd" value="${visionMap.wearDayCd}">		
					<input type="hidden" name="wearDayCdNm" id="wearDayCdNm" value="${visionMap.wearDayCdNm}">		
					<input type="hidden" name="incon1Cd" id="incon1Cd" value="${visionMap.incon1Cd}">		
					<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${visionMap.incon1CdNm}">				
					<input type="hidden" name="contactPurpCd" id="contactPurpCd" value="${visionMap.contactPurpCd}">		
					<input type="hidden" name="contactPurpCdNm" id="contactPurpCdNm" value="${visionMap.contactPurpCdNm}">	
					<input type="hidden" name="incon2Cd" id="incon2Cd" value="${visionMap.incon2Cd}">		
					<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${visionMap.incon2CdNm}">
					<input type="hidden" name="lifestyleCd" id="lifestyleCd" value="${visionMap.lifestyleCd}">
					<input type="hidden" name="lifestyleCdNm" id="lifestyleCdNm" value="${visionMap.lifestyleCdNm}">
					<input type="hidden" name="returnUrl" value="${visionMap.returnUrl}"/>
		        </form:form>
			</c:if>
			
			<form id="inactiveForm" method="post">
				<input type="hidden" id="inactiveLoginId" name="inactiveLoginId"/>
			</form>

			<form id="returnForm" method="post">
				<input type="hidden" name="refererType" id="refererType" value="${param.refererType}"/>
				<input type="hidden" name="returnUrl" value="${param.returnUrl}" />
			</form>
		</div>

	</t:putAttribute>
</t:insertDefinition>