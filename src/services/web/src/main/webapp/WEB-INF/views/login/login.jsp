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
    <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
    <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
    <script>
		var captcha = false
		var state = "";
		$(document).ready(function(){
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

		    Dmall.waiting.start();

            var data = {'accessToken':accessToken, 'path':path};
            var url = "/front/login/sns-login"
            Dmall.AjaxUtil.getJSON(url, data, function(result){
                if(result.success){
                    var param = {sns_add_info_Yn : result.data.firstJoinYn}
                    var url = HTTP_SERVER_URL + '/front/main-view';
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
		<div class="contents fixwid">
			<div id="member_location">
				<a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>로그인
			</div>

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
			<ul class="tabs">

                <li class="active" rel="tab1" style="width:${tabWidth}%">회원</li>
                <c:if test="${snsTabHideCnt ne linkOperYnCnt}">
                    <li rel="tab2" style="width:33.4%">소셜로그인</li>
                </c:if>
                <li rel="tab3" style="width:${tabWidth}%">비회원</li>
            </ul>

			<!--- tab01: 회원 영역 --->
			<div class="tab_content" id="tab1">
				<div class="login_box">
					<h3 class="login_stit">
						로그인
						<span>방문해주셔서 감사합니다. 다양한 혜택과 편리한 이용을 위한 로그인해주세요.</span>
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

					<form name="loginForm" id="loginForm" method="post" role="form">
						<input type="hidden" name="returnUrl" value="${param.returnUrl}" />
						<ul class="login_form">
							<li>
								<span class="login_form_tit">ID</span>
								<span class="login_form_input"><input type="text" name="loginId" id="loginId"></span>
							</li>
							<li id="li_id_pw">
								<span class="login_form_tit">PASSWORD</span>
								<span class="login_form_input"><input type="password" name="password" id="password" autocomplete="off"></span>
								<div class="login_id_check">
									<label>
										<input type="checkbox" name="checkId" id="id_save">
										<span></span>
									</label>
									<label for="id_save">아이디저장</label>
								</div>
							</li>
							<li class="login_button" id="li_id_loginBtn"><button type="button" id="loginBtn" class="btn_login">로그인</button></li>
                            <c:if test="${orderYn eq 'Y'}">
   							<li class="login_button"><button type="button" id="nomember" class="btn_nonmember_login">비회원으로 구매하기</button></li>
   							<li class="warning_row">
   								비회원으로 구매하시면 ${site_info.siteNm} 쇼핑 혜택을 받으실 수 없으며, <br>
   								할인이벤트, 경품이벤트 등 다양한 회원이벤트도 참여하실 수 없습니다.
   							</li>
                            </c:if>
						</ul>
					</form>
				</div>
				<ul class="login_select">
					<li>
						<div class="login_join_info">
							아직 회원이 아니세요?
							<span>회원이 되시면 다양한 서비스 이용이 가능합니다.</span>
							<button type="button" class="btn_join_ok" id="btn_join_ok">회원가입</button>
						</div>
					</li>
					<li>
						<div class="view_id_search">
							아이디를 잊어 버리셨나요?
							<button type="button" id="btn_id_search">아이디 찾기</button>
						</div>
						<div class="view_pw_search">
							비밀번호를 잊어 버리셨나요?
							<button type="button" id="btn_password_search">비밀번호 찾기</button>
						</div>
					</li>
					<li class="snslogin_infotext">
						<div class="login_sns_join_info">
							소셜 로그인 안내
							<span>별도의 회원가입 없이 페이스북, 네이버, 카카오계정을 이용하셔도 ${site_info.siteNm}의 다양한 서비스를 이용할 수 있습니다.</span>
						</div>
					</li>
				</ul>
			</div>
			<!---// tab01: 회원 영역 --->

            <!--- tab02: sns 로그인 영역 --->
            <div class="tab_content" id="tab2">
                <div class="snslogin_box">
                    <h3 class="login_stit">
                        소셜로그인
                <span>SNS 계정으로 쉽고 빠르게 다양한 서비스를 이용할 수 있습니다.<br>
                아래 버튼을 클릭 하면 로그인 페이지가 열립니다.</span>
                    </h3>
                    <div class="sns_login_link">
                    <c:forEach var="snsList" items="${snsOutsideLink.resultList}" varStatus="status">
                        <c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '01'}">
                        <a href="javascript:snsLogin('facebook');" ><img src="/front/img/member/login_sns_facebook.png" alt="페이스북으로 로그인하기"></a>
                        </c:if>
                        <c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '02'}">
                        <a href="javascript:snsLogin('naver');" ><img  src="/front/img/member/login_sns_naver.png" id="naver_id_login" alt="네이버로 로그인하기"></a>
                        </c:if>
                        <c:if test="${snsList.linkUseYn eq 'Y' && snsList.linkOperYn eq 'Y' && snsList.outsideLinkCd eq '03'}">
                        <a href="javascript:snsLogin('kakao');" ><img src="/front/img/member/login_sns_kakao.png" alt="카카오로 로그인하기"></a>
                        </c:if>
                    </c:forEach>
                    </div>
                </div>
            </div>
            <!---// tab02: sns 로그인 영역 --->

			<!--- tab03: 비회원 영역 --->
			<div class="tab_content" id="tab3">
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
			<!---// tab03: 비회원 영역 --->
		</div>
		<!---// contents --->
        <c:if test="${orderYn eq 'Y'}">
        <form name="orderForm" id="orderForm" action="/front/order/order-form" method="post">
            <c:forEach var="itemArr" items="${itemArr}" varStatus="status">
            <input type="hidden" name="itemArr" value="${itemArr}">
            </c:forEach>
        </form>
        </c:if>
        <form id="inactiveForm" method="post">
            <input type="hidden" id="inactiveLoginId" name="inactiveLoginId"/>
        </form>
	</t:putAttribute>
</t:insertDefinition>