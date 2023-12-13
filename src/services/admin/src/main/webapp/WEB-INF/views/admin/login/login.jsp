<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<!doctype html>
<html lang="ko">
<head>
	<title>다비치마켓 관리자 로그인</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" CONTENT="0">
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta name="_csrf" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<jsp:include page="/WEB-INF/include/common.jsp" />
	<style>
		.input {
			background-color: #0135c2 !important;
		}
	</style>
	<script type="text/javascript">
		var captcha = false;
		$(document).ready(function () {
			$("#loginBtn").on('click', function (e) {
				Dmall.EventUtil.stopAnchorAction(e);
				console.log(document.loginForm);
				//saveId(document.loginForm);

				jQuery('#div_id_errorMsg').html('');
				if (!checkId()) return;
				if (!chkPwd()) return;

				var options = {
					url: "<spring:url value='/admin/login/loginprocess' />"
					, data: $("#loginForm").serialize()
					, callBack: function (data) {
						if (data.resultCode == 'S') {
							location.href = data.returnUrl;
						} else {
							Dmall.waiting.stop();
							alert(data.resultMsg);
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
					url: options.url
					, type: options.type
					, dataType: options.dataType
					, contentType: options.contentType
					, cache: false
					, data: options.data
				})
						.done(function (data, textStatus, jqXHR) {
							try {
								var obj = data;

								if (obj.exCode != null && obj.exCode != undefined && obj.exCode != "") {
									Dmall.waiting.stop();
									if (obj.exMsg) {
										Dmall.LayerUtil.alert(obj.exMsg);
									}
									if (captcha) {
										viewCaptcha();
									} else {
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
						.always(function () {
							Dmall.waiting.stop();
						})
						.then(function (data, textStatus, jqXHR) {

						});
			});

			$("#loginId").on('keydown keyup', function (event) {
				//Dmall.EventUtil.setOnlyNumAphabetValue(jQuery(this), event);
			});

			$("#password").keydown(function (event) {
				if (event.keyCode == 13) {
					$('#loginBtn').click();
					return false;
				}
			});

			getId(document.loginForm);

			if ("" != document.loginForm.loginId.value) {
				$('#password').focus();
			}

			$('input[type=text], input[type=password]').on('input', function () {
				if(($('input[type=text]').val().length + $('input[type=password]').val().length) > 0) {
					$('#loginBtn').addClass('input');
				} else {
					$('#loginBtn').removeClass('input');
				}
			});
		});

		function viewCaptcha() {
			var captcha = '<li><img src="/admin/common/capcha" id="span_id_captcha" /><button type="button" style="width:27px; height:27px; line-height:24px; margin-left:10px; vertical-align:top;" id="btn_id_reload"><img src="/admin/img/common/reload.png" alt="새로고침"></button></li>'
			captcha += '<li><span class="login_form_input"><input type="text" class="s_ipt" name="captcha" placeholder="자동입력 방지문자를 입력해주세요."></span></li>';
			jQuery('#captcha').html(captcha);

			$('#btn_id_reload').on('click', function () {
				$('#span_id_captcha').attr('src', '/admin/common/capcha?dummy=' + new Date());
			});
		}

		function setCookie(name, value, expires) {
			document.cookie = name + "=" + escape(value) + "; path=/; expires=" + expires.toGMTString();
		}

		function getCookie(Name) {
			var search = Name + "=",
					offset,
					end;
			if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
				offset = document.cookie.indexOf(search);
				if (offset != -1) { // 쿠키가 존재하면
					offset += search.length;
					// set index of beginning of value
					end = document.cookie.indexOf(";", offset);
					// 쿠키 값의 마지막 위치 인덱스 번호 설정
					if (end == -1)
						end = document.cookie.length;

					return unescape(document.cookie.substring(offset, end));
				}
			}
			return "";
		}

		function saveId(form) {
			var expdate = new Date();
			// 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
			if (form.checkId.checked)
				expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
			else
				expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건

			setCookie("dmallAdmSaveId", form.loginId.value, expdate);
		}

		function getId(form) {
			var checked = "" != (form.loginId.value = getCookie("dmallAdmSaveId"));
			if (checked) {
				jQuery('#checkId').prop('checked', checked).parents('label').addClass('on');
			}
		}

		function checkId() {
			var id = jQuery.trim(jQuery('#loginId').val()),
					isEngNum = /^[0-9a-zA-Z]+$/.test(id);

			if (id === '') {
				jQuery('#div_id_errorMsg').html('아이디를 입력해주세요.');
				return false;
			}

			/*if(!isEngNum) {
				jQuery('#div_id_errorMsg').html('아이디는 영문 소문자와 숫자로만 입력해주세요.');
				return false;
			}*/

			if (id.length < 5 || id.length > 20) {
				jQuery('#div_id_errorMsg').html('아이디는 5자리 ~ 20자리 이내로 입력해주세요.');
				return false;
			}
			if (id.search(/\s/) != -1) {
				jQuery('#div_id_errorMsg').html('아이디는 공백없이 입력해주세요.');
				return false;
			}

			return true;
		}

		function chkPwd() {
			var pw = jQuery('#password').val();
			var num = pw.search(/[0-9]/g);
			var eng = pw.search(/[a-z]/ig);
			var spe = pw.search(/[`~!@@#$%^&*|\\\'\";:\/?]/gi);

			if (pw.length < 8 || pw.length > 16) {
				jQuery('#div_id_errorMsg').html('비밀번호는 8자리 ~ 16자리 이내로 입력해주세요.');
				return false;
			}
			if (pw.search(/\s/) != -1) {
				jQuery('#div_id_errorMsg').html('비밀번호는 공백없이 입력해주세요.');
				return false;
			}
			if ((num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0)) {
				jQuery('#div_id_errorMsg').html('영문, 숫자, 특수문자 중 2가지 이상을 혼합하여 입력해주세요.');
				return false;
			}

			return true;
		}
	</script>
</head>
<body class="bgw">
<div class="login_bg">
	<img class="login_bg_img" src="/admin/img/common/new/login_bg.png" alt="로그인 배경화면">
	<img class="login_logo" src="/admin/img/common/new/logo_DAVICHMarket.png" alt="로그인 배경화면">
</div>
<!-- login_wrap -->
<div class="login_wrap">
	<h1 class="logo">다비치마켓 관리자 로그인</h1>
	<fieldset>
		<legend class="blind">로그인</legend>
		<form name="loginForm" id="loginForm" method="post" role="form" onsubmit="return false;">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			<div class="login_entry">
				<span class="intxt">
					<label for="loginId" class="hidden">아이디</label>
					<input name="loginId" id="loginId" type="text" style="ime-mode:disabled;" title="아이디" placeholder="ID">
				</span>
				<span class="intxt">
					<label for="password" class="hidden">비밀번호</label>
					<input class="mt10"  name="password" id="password" type="password" title="비밀번호" value="" autocomplete="false" placeholder="PASSWORD">
				</span>
				<button class="btn" id="loginBtn">LOGIN</button>
			</div>
			<ul id="captcha"></ul>
			<%--<label for="checkId" class="chack mr20">
				<span class="ico_comm"><input type="checkbox" name="checkId" id="checkId" onchange="saveId(this.form);"></span> 아이디저장</label>
			<a href="#none" class="link"><span class="ico_comm"></span> 아이디 / 비밀번호 찾기</a>--%>
			<!-- TODO: 홈페이지로 링크 해야함 -->
		</form>
		<div id="div_id_errorMsg" class="point_c6"></div>
	</fieldset>
</div>
<div class="login_footer">COPYRIGHT (C) 2022. DAVICH OPTICAL. All  RIGHTS RESERVED.</div>
</body>
<div class="calendar" id="DmallCalDiv"><div class="head"><span class="left">YEAR</span><span class="right">MONTH</span></div><div class="day"><div class="year"><button class="pre"><span class="btn_comm">이전년</span></button><span class="num">2015</span><button class="nex"><span class="btn_comm">다음년</span></button></div><div class="month"><button class="pre"><span class="btn_comm">이전달</span></button><span class="num">4</span><button class="nex"><span class="btn_comm">다음달</span></button></div></div><table><caption>달력</caption><colgroup><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"><col width="14.29%"></colgroup><thead><tr><th>SUN</th><th>MON</th><th>TUE</th><th>WED</th><th>THU</th><th>FRI</th><th>SAT</th></tr></thead><tbody></tbody></table></div></body></html>
</html>
