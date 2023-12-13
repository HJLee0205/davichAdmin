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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">로그인</t:putAttribute>
	<t:putAttribute name="script">
		<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
		<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
		<script>
            var captcha = false
            var state = "";
            $(document).ready(function(){
                $("#btn_join_ok").click(function(){
                    location.href="${_MOBILE_PATH}/front/member/terms-apply";
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
                getSetup(document.loginForm);

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

                var naver = new naver_id_login("${snsMap.get('naverClientId')}", location.origin+"/front/login/naver-login-return");
                state = naver.getUniqState();

                $("#nomember_search").click(function(){
                   $("#loginLayer").hide();
                    $("#noLoginLayer").show();

                });

        		// 앱에서 모바일웹 자동로그인을 숨긴다.
//         		if(isAndroidWebview() || isIOSWebview()){
//                     $('label[for=auto_login]').hide();
//                 }
        		
                $('#auto_login').change(function() {
                    if(this.checked) {
                    	$('#auto_login').val("Y");
                    } else {
                    	$('#auto_login').val("N");
                    }
                });        		
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
                saveSetup(document.loginForm);

                var options = {
                    url : "<spring:url value='/front/login/loginprocess' />"
                    , data : $("#loginForm").serialize()
                    , callBack : function(data) {
                        if(data.resultCode == 'S') {
                            if(data.resultMsg) {
                                alert(data.resultMsg);
                            }
                            
                			//client에서 쿠키 정보를 다시 한번 세팅
                   			cookieSetup();	
                            
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
            
            
            function saveSetup(form) {
                var expdate = new Date();
    	        //$.cookie("dmld", "", {domain:".davichmarket.com", path:"/"});
                
                if (form.auto_login.checked)
                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 365); // 1년
                else
                    expdate.setTime(expdate.getTime() + 1000 * 1800 ); 

                setCookie("dmallAutoLoginYn", form.auto_login.value, expdate);
                //setCookie("dmld", form.loginId.value, expdate);
            }

            function getId(form) {
                var checked = "" != (form.loginId.value = getCookie("dmallSaveId"));
                if(checked) {
                    jQuery('#id_save').prop('checked', checked);
                }
            }

            function getSetup(form) {
                var checked = getCookie("dmallAutoLoginYn");
                if(checked == "Y") {
                    jQuery('#auto_login').prop('checked', checked);
                }
            }
            
            //SNS로그인
            function snsLogin(snsType) {
            	saveSetup(document.loginForm);
            	
    	    	if (isAndroidWebview()) {
    		       davichapp.bridge_sns_login(snsType);
    		    } 	    	
    		    	
    		    if (isIOSWebview()) {
   			 	    window.webkit.messageHandlers.davichapp.postMessage({
   				   	       func: 'bridge_sns_login',
   				   	       param1: snsType,
   			   	   });    	
    		    }	            	
            }

            function snsLoginProcess(accessToken, path){

                Dmall.waiting.start();
                
                //var expdate = new Date();
                //setCookie("dmld", "", expdate);

                var data = {'accessToken':accessToken, 'path':path};
                var url = "/m/front/login/sns-login"
                Dmall.AjaxUtil.getJSON(url, data, function(result){
                    if(result.success){
            			//client에서 쿠키 정보를 다시 한번 세팅
               			cookieSetup();	
                    	
                        var param = {sns_add_info_Yn : result.data.firstJoinYn}
                        var url = HTTP_SERVER_URL + '${_MOBILE_PATH}/front/main-view';
                        Dmall.FormUtil.submit(url, param);
                        Dmall.waiting.stop();
                    } else {
                        Dmall.LayerUtil.alert(result.message);
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
            
            function cookieSetup() {
                var expdate = new Date();
    	        
    			var jds = $.cookie("_JDS");
    			var auto = $.cookie("dmallAutoLoginYn");
    			
                if (auto == "Y")
                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 365); // 1년
                else
                    expdate.setTime(expdate.getTime() + 1000 * 1800 ); 

                setCookie("jdsc", jds, expdate);
            }            

		</script>
	</t:putAttribute>
	<t:putAttribute name="content">


	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			로그인
		</div>

		<div class="cont_body">
			<form name="loginForm" id="loginForm" method="post" role="form">
				<input type="hidden" name="returnUrl" value="${param.returnUrl}" />
				<ul class="login_form" id="loginLayer">
					<li><span>아이디</span><input type="text" name="loginId" id="loginId" value="" placeholder="아이디"></li>
					<li><span>비밀번호</span><input type="password" name="password" id="password" placeholder="영문,숫자,특수문자 4~16자" autocomplete="off"></li>
					<li><button type="button" class="btn_login" id="loginBtn">로그인</button></li>
					<li>
						<input type="checkbox" class="size15" id="auto_login" name="auto_login" value="N">
						<label for="auto_login"><span></span>자동로그인</label>

						<input type="checkbox" class="size15" name="checkId" id="id_save">
						<label for="id_save"><span></span>아이디저장</label>
					</li>
					<li class="alignC">
						<a href="#" class="btn_id_search" id="btn_id_search">아이디 찾기</a>
						<a href="#" class="btn_pw_search" id="btn_password_search">비밀번호 찾기</a>
						<a href="#" class="btn_signup" id="btn_join_ok">회원가입</a>
					</li>
					<li>
						<p class="login_guide">
							별도의 회원가입 없이 <b>네이버, 카카오, 페이스북</b> 계정으로도 로그인 하실 수 있습니다.<br>
							단, 다비치마켓의 마켓포인트가 지급되지 않으며, 예약 등 일부 서비스도 제한됩니다.
						</p>
					</li>
					<c:forEach var="snsList" items="${snsOutsideLink.resultList}" varStatus="status">
						<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '01'}">
							<li><button type="button" class="btn_login_facebook" onclick="javascript:snsLogin('facebook');"><i></i>페이스북으로 로그인</button></li>
						</c:if>
						<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '02'}">
							<li><button type="button" id="naver_id_login" class="btn_login_naver" onclick="javascript:snsLogin('naver');"><i></i>네이버로 로그인</button></li>
						</c:if>
						<c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '03'}">
							<li><button type="button" class="btn_login_kakao" onclick="javascript:snsLogin('kakao');"><i></i>카카오로 로그인</button></li>
						</c:if>
					</c:forEach>

					<c:if test="${orderYn eq 'Y'}">
						<li><button type="button" class="btn_nonmember_checkout" id="nomember">비회원으로 구매하기</button></li>
					</c:if>
					<li><button type="button" id="nomember_search" class="btn_login_nomember">비회원 주문조회</button></li>
				</ul>
			</form>

			<div id="noLoginLayer" style="display:none ;" class="sub_content">
				<form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
					<h3 class="sub_stit">비회원 조회</h3>
					<ul class="no_member_form">
						<form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
							<li><input type="text" id="ordNo" name="ordNo" placeholder="주문번호"></li>
							<li><input type="text" id="ordrMobile" name="ordrMobile" placeholder="휴대폰번호(- 생략)"></li>
							<li><button type="button" id="btn_nonmember_login" class="btn_order_check">비회원 주문조회</button></li>
						</form>
					</ul>
					<p class="check_info">
						<em>주문번호</em> 및 주문하실때 등록한 <em>휴대폰 번호</em>를 <em>입력</em>해 주시기 바랍니다.
					</p>
				</form>
			</div>
		</div><!-- //cont_body -->
		<!---// contents --->
		<c:if test="${orderYn eq 'Y'}">
			<form name="orderForm" id="orderForm" action="${_MOBILE_PATH}/front/order/order-form" method="post">
				<c:forEach var="itemArr" items="${itemArr}" varStatus="status">
					<input type="hidden" name="itemArr" value="${itemArr}">
				</c:forEach>
			</form>
		</c:if>
		<form id="inactiveForm" method="post">
			<input type="hidden" id="inactiveLoginId" name="inactiveLoginId"/>
		</form>
	</div>

	</t:putAttribute>
</t:insertDefinition>