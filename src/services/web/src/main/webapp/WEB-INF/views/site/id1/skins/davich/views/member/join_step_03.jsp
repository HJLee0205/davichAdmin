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
    <t:putAttribute name="title">다비치마켓 :: 회원정보입력</t:putAttribute>
    <t:putAttribute name="script">
    <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="/front/js/inko.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/front/js/jquery.inputLettering.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
        var totalFileLength=0;
        $(document).ready(function(){
            Dmall.validate.set('form_id_insert_member');
            // 우편번호
            jQuery('.btn_post').on('click', function(e) {
                Dmall.LayerPopupUtil.zipcode(setZipcode);
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
                    emailTarget.attr('readonly', false);
                    emailTarget.val('').change();
                    emailTarget.focus();
                } else {
                    emailTarget.attr('readonly', true);
                    emailTarget.val('').change();
                }
            });

			function validateEmail(sEmail) {
				var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
				if (filter.test(sEmail)) {
					return true;
				} else {
					return false;
				}
			}
			//아이디 중복 체크
            $('.btn_id_check').on('click',function (){
                $("#id_check").val( $('#loginId').val());
                Dmall.LayerPopupUtil.open($('#popup_id_duplicate_check'));
                if(!Dmall.validation.isEmpty($("#id_check").val())) {
                    $('#btn_id_duplicate_check').click();
                }
            });

            $('.loginId').on('focusout', function () {
            	var _this = $(this);
            	var loginId = $(this).val();
            	$(this).parents('tr').find('.error_text').remove();
            	var errorHtml ='<p class="error_text">이메일 형식이 아닙니다.</p>';
            	if (validateEmail(loginId)) {
            	/*if (true) {*/
            		$(this).removeClass('error');
            		$(this).addClass('check_ok');
            		$(this).parents('tr').find('.error_text').remove();

            		var url = '/front/member/duplication-id-check';
					if(Dmall.validation.isEmpty(loginId)) {
						$(this).removeClass('check_ok');
						$(this).addClass('error');
						errorHtml ='<p class="error_text">아이디를 입력해주세요.</p>';
						$(this).after(errorHtml);
						return false;
					}else{
						var param = {loginId : loginId}
						Dmall.AjaxUtil.getJSON(url, param, function(result) {
							 if(result.success) {
							 	$('.loginId').removeClass('error');
								$('.loginId').addClass('check_ok');
								$('.loginId').parents('tr').find('.error_text').remove();
							 }else{
							 	$('.loginId').removeClass('check_ok');
								$('.loginId').addClass('error');
								errorHtml ='<p class="error_text">이미 사용중인 아이디 입니다.</p>';
								$('.loginId').after(errorHtml);
 							 	$('#loginId').val('');
 							 	$('#inPw').val('');
 							 	$('#pw').val('');
 							 	$(".pwview").html('');
 							 	$("#inPw").parent().parents('tr').find('.error_text').remove();
							 }
						 });
					}
				}else {
					$(this).removeClass('check_ok');
					$(this).addClass('error');
            		$(this).after(errorHtml);
				}

			});

			$('.memberNm').on('focusout', function () {
			    var str = $(this).val();
			    var pattern_num = /[0-9]/;	// 숫자
                var pattern_eng = /[a-zA-Z]/;	// 문자
                var pattern_spc = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
                var pattern_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; // 한글체크
                var pattern = /([^가-힣\x20])/i; // 자음 모음
                var errorHtml ='';

                $(this).parents('tr').find('.error_text').remove();
                if(Dmall.validation.isEmpty(str)) {
					//Dmall.LayerUtil.alert("이름을 입력해주세요.", "알림");
					 errorHtml = '<p class="error_text">이름을 입력해주세요.</p>';
					 $(this).removeClass('check_ok');
					 $(this).addClass('error');
					 $(this).after(errorHtml);
					return false;
				}else {
                    if (pattern_num.test(str) || pattern_spc.test(str)) {
                        errorHtml = '<p class="error_text">이름 형식이 아닙니다.</p>';
                        $(this).removeClass('check_ok');
                        $(this).addClass('error');
                        $(this).after(errorHtml);
                        return false;
                    } else {
                        if (pattern_kor.test(str)) {
                            if (pattern.test(str)) {
                                errorHtml = '<p class="error_text">이름을 정확히 입력하세요.</p>';
                                $(this).removeClass('check_ok');
                                $(this).addClass('error');
                                $(this).after(errorHtml);
                                return false;
                            } else {
                                $(this).removeClass('error');
                                $(this).addClass('check_ok');
                                $(this).parents('tr').find('.error_text').remove();
                            }
                        }

                        if (pattern_eng.test(str)) {
                            $(this).removeClass('error');
                            $(this).addClass('check_ok');
                            $(this).parents('tr').find('.error_text').remove();
                        }
                    }
                }
            });

            $('.mobile02').on('focusout', function () {
                 if(Dmall.validation.isEmpty($("#mobile02").val())) {
						 $("#mobile02").parents('tr').find('.error_text').remove();
						 errorHtml = '<p class="error_text">휴대폰 번호를 입력해주세요.</p>';
                         $("#mobile02").removeClass('check_ok');
                         $("#mobile02").addClass('error');
                         $(".btn_mobile_check").after(errorHtml);
						return false;
					}else{
					     var str = $("#mobile02").val();
                         var pattern_num = /[0-9]/;	// 숫자
                         if( !(pattern_num.test(str))  || str.length<3 ) {
                            $("#mobile02").parents('tr').find('.error_text').remove();
                            errorHtml ='<p class="error_text">휴대폰 번호를 정확하게 입력하세요.</p>';
                            $("#mobile02").removeClass('check_ok');
                            $("#mobile02").addClass('error');
                            $(".btn_mobile_check").after(errorHtml);
                            return false;
                         }else{
                            $("#mobile02").removeClass('error');
                            $("#mobile02").addClass('check_ok');
                            $(".btn_mobile_check").parents('tr').find('.error_text').remove();
                         }
					}
            });

            $('.mobile03').on('focusout', function () {
                if(Dmall.validation.isEmpty($("#mobile03").val())) {
                     $("#mobile03").parents('tr').find('.error_text').remove();
                     errorHtml = '<p class="error_text">휴대폰 번호를 입력해주세요.</p>';
                     $("#mobile03").removeClass('check_ok');
                     $("#mobile03").addClass('error');
                     $(".btn_mobile_check").after(errorHtml);
                    return false;
                }else{
                     var str = $("#mobile03").val();
                     var pattern_num = /[0-9]/;	// 숫자
                     if( !(pattern_num.test(str)) || str.length<4) {
                        $("#mobile03").parents('tr').find('.error_text').remove();
                        errorHtml ='<p class="error_text">휴대폰 번호를 정확하게 입력하세요.</p>';
                        $("#mobile03").removeClass('check_ok');
                        $("#mobile03").addClass('error');
                        $(".btn_mobile_check").after(errorHtml);
                        return false;
                     }else{
                        $("#mobile03").removeClass('error');
                        $("#mobile03").addClass('check_ok');
                        $(".btn_mobile_check").parents('tr').find('.error_text').remove();
                     }
                }
             });







			$('#inPw').on('focusout', function () {
				var errorHtml="";
					if(Dmall.validation.isEmpty($("#pw").val())) {
						//Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호를 입력해주세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}
					var len_num = $("#pw").val().search(/[0-9]/g);
					var len_eng = $("#pw").val().search(/[a-z]/g);
					var len_asc = $("#pw").val().search(/[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi);
					var level_check = false;
					if( (len_eng > -1&&len_num > -1) || (len_eng > -1&&len_asc > -1) ){
						level_check = true;
					}
					if(len_num > -1 && len_eng > -1 && len_asc > -1){
						level_check = true;
					}
					if(!level_check){
						//Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인")
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}

					if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
						//Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}
					if(/(\w)\1\1/.test($('#pw').val())){
						//Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}

                    var _loginId= "";
                    try{
                        _loginId = $('#loginId').val().split('@')[0];
                    }catch(e){
                        _loginId =$('#loginId').val();
                    }
					if ($('#pw').val().indexOf($('#loginId').val()) > -1 || $('#pw').val().indexOf(_loginId) > -1) {

						//Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">ID가 포함된 비밀번호는 사용하실 수 없습니다.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}
			});

            //휴대전화인증
            $('.btn_mobile_check').on('click',function (){
            	if($('#mobile02').val() == '' || $('#mobile03').val() == ''){
            		Dmall.LayerUtil.alert("휴대전화를 입력해주세요.", "확인");
            		return false;
            	}
                var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
                var url = '/front/member/send-sms-certify';
                var param = {
                	mobile : mobile
                }
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	if(result.success) {
                		var certifyKey = result.extraString;
                		$('#certify_key').val('');
                		$('#certify_key').data('certifyKey',certifyKey);
                		fnCountDown();
                		$('#div_mobile_check').css('display','block');
        				$('#div_mobile_check_fail').css('display','none');
                		Dmall.LayerPopupUtil.open($('#popup_mobile_check'));
                	}
                });
                
            });
            
          	//휴대전화인증 인증확인
            $('#btn_mobile_confirm').click(function(){
    			if($('#certify_key').val() == $('#certify_key').data('certifyKey')){
    				$('#mobileCertifyYn').val('Y');
    				Dmall.LayerUtil.alert("인증이 완료되었습니다.", "알림");
    				Dmall.LayerPopupUtil.close('popup_mobile_check');
    			}else{
    				Dmall.LayerUtil.alert("인증번호가 일치하지 않습니다.<br>다시 확인해주세요.", "알림");
    				$('#mobileCertifyYn').val('N');
    			}
    		});
    		
            //휴대전화인증 재전송
    		$('#btn_mobile_resend').click(function(){
    			$('#certify_key').val('');
    			var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
                var url = '/front/member/send-sms-certify';
                var param = {
                	mobile : mobile
                }
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	if(result.success) {
                		var certifyKey = result.extraString;
                		$('#certify_key').data('certifyKey',certifyKey);
                		stopCountDown();
                		fnCountDown();
                	}
                });
    		});
            
            $('#btnRecomChk').click(function(){
            	var recomId = $('#recomMemberId').val();
            	
                var hanExp = jQuery('#recomMemberId').val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
                if( hanExp > -1 ){
                    Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
                    return false;
                }
                
                var url = '/front/member/recomMember-id-check';
                var param = {recomId : recomId};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                	if(result.success) {
                		Dmall.LayerUtil.alert("확인되었습니다.", "확인");
                		$('#recomMemberNo').val(result.extraString);
                	}else{
                		Dmall.LayerUtil.alert("등록되지 않은 아이디입니다. 확인 후 다시 입력해주세요.", "확인");
                	}
                });
            	
            });

            var check_id;
            $('#btn_id_duplicate_check').on('click',function (){
                var url = '/front/member/duplication-id-check';
                var loginId = $('#id_check').val();
                if(Dmall.validation.isEmpty($("#id_check").val())) {
                    $('#id_success_div').attr('style','display:none;')
                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                    return false;
                }else{
                    if(idCheck(loginId)){
                    var param = {loginId : loginId}
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                         if(result.success) {
                             check_id = loginId;
                             $('#id_success_div').attr('style','display:block;')
                             $('.id_duplicate_check_info').html('사용 가능한 아이디 입니다.')
                         }else{
                             $('.id_duplicate_check_info').html('사용불가능한 아이디 입니다.')
                             $('#id_success_div').attr('style','display:none;')
                             $('#loginId').val('');
                         }
                     });
                   }
                }
            });

            //아이디 사용하기
            $('#btn_popup_login').on('click',function (){
                Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
                $('#loginId').val(check_id);
            })
            
            $('.btn_close_popup').on('click',function (){
                $('#id_check').val('');
            })

            //회원가입
            $('.btn_go_next').on('click',function (){
                var errorHtml="";

            	if($('#age_limit_check').is(':checked') == true) {
		            Dmall.LayerUtil.alert("만 14세 미만 고객님은<br>해당 서비스를 이용하실 수 없습니다.", "알림");
		            return;
		        }

                if(!Dmall.validate.isValid('form_id_insert_member')) {
                    return false;
                }

				<c:if test="${so.memberTypeCd eq '01'}">
				    if(Dmall.validation.isEmpty($("#loginId").val())) {
						//Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
    					 $("#loginId").parents('tr').find('.error_text').remove();
						 errorHtml = '<p class="error_text">아이디를 입력해주세요.</p>';
                         $("#loginId").removeClass('check_ok');
                         $("#loginId").addClass('error');
                         $("#loginId").after(errorHtml);
						return false;
					}else{

					    $("#loginId").parents('tr').find('.error_text').remove();
					    errorHtml ='<p class="error_text">이메일 형식이 아닙니다.</p>';
                        if (validateEmail($("#loginId").val())) {
                            $("#loginId").removeClass('error');
                            $("#loginId").addClass('check_ok');
                            $("#loginId").parents('tr').find('.error_text').remove();
                            $('#email').val($('#loginId').val().trim());
                        }else {
                            $("#loginId").removeClass('check_ok');
                            $("#loginId").addClass('error');
                            $("#loginId").after(errorHtml);
                            return false;
                        }

					}

					if(Dmall.validation.isEmpty($("#pw").val())) {
						//Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호를 입력해주세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}
					var len_num = $("#pw").val().search(/[0-9]/g);
					var len_eng = $("#pw").val().search(/[a-z]/g);
					var len_asc = $("#pw").val().search(/[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi);
					var level_check = false;
					if( (len_eng > -1&&len_num > -1) || (len_eng > -1&&len_asc > -1) ){
						level_check = true;
					}
					if(len_num > -1 && len_eng > -1 && len_asc > -1){
						level_check = true;
					}
					if(!level_check){
						//Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인")
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}

					if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
						//Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}
					if(/(\w)\1\1/.test($('#pw').val())){
						//Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}

					var _loginId= "";
                    try{
                        _loginId = $('#loginId').val().split('@')[0];
                    }catch(e){
                        _loginId =$('#loginId').val();
                    }
					if ($('#pw').val().indexOf($('#loginId').val()) > -1 || $('#pw').val().indexOf(_loginId) > -1) {

						//Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
						$("#inPw").parent().parents('tr').find('.error_text').remove();
						errorHtml = '<p class="error_text">ID가 포함된 비밀번호는 사용하실 수 없습니다.</p>';
                         $("#inPw").parent().removeClass('check_ok');
                         $("#inPw").parent().addClass('error');
                         $("#inPw").parent().after(errorHtml);
						return false;
					}else{
					     $("#inPw").parent().removeClass('error');
                         $("#inPw").parent().addClass('check_ok');
                         $("#inPw").parent().parents('tr').find('.error_text').remove();

					}

					if(Dmall.validation.isEmpty($("#memberNm").val())) {
					    $("#memberNm").parents('tr').find('.error_text').remove();
                		//Dmall.LayerUtil.alert("이름을 입력해주세요.", "알림");
                		 errorHtml = '<p class="error_text">이름을 입력해주세요.</p>';
                         $("#memberNm").removeClass('check_ok');
                         $("#memberNm").addClass('error');
                         $("#memberNm").after(errorHtml);
                		return false;
					}else{
						$("#memberNm").val( $("#memberNm").val().trim() );

						var str = $("#memberNm").val();
                        var pattern_num = /[0-9]/;	// 숫자
                        var pattern_eng = /[a-zA-Z]/;	// 문자
                        var pattern_spc = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
                        var pattern_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; // 한글체크
                        var pattern = /([^가-힣\x20])/i; // 자음 모음
                        var errorHtml ='';

                        $("#memberNm").parents('tr').find('.error_text').remove();
                        if( pattern_num.test(str) || pattern_spc.test(str)) {
                            errorHtml = '<p class="error_text">이름 형식이 아닙니다.</p>';
                            $("#memberNm").removeClass('check_ok');
                            $("#memberNm").addClass('error');
                            $("#memberNm").after(errorHtml);
                            return false;
                        }else{
                            if(pattern_kor.test(str)) {
                                if (pattern.test(str)) {
                                   errorHtml = '<p class="error_text">이름을 정확히 입력하세요.</p>';
                                   $("#memberNm").removeClass('check_ok');
                                   $("#memberNm").addClass('error');
                                   $("#memberNm").after(errorHtml);
                                   return false;
                                }else{
                                    $("#memberNm").removeClass('error');
                                    $("#memberNm").addClass('check_ok');
                                    $("#memberNm").parents('tr').find('.error_text').remove();
                                }
                            }

                            if(pattern_eng.test(str)) {
                                $("#memberNm").removeClass('error');
                                $("#memberNm").addClass('check_ok');
                                $("#memberNm").parents('tr').find('.error_text').remove();
                            }
                        }
					}


                    if(Dmall.validation.isEmpty($("#mobile02").val())) {
						 $("#mobile02").parents('tr').find('.error_text').remove();
						 errorHtml = '<p class="error_text">휴대폰 번호를 입력해주세요.</p>';
                         $("#mobile02").removeClass('check_ok');
                         $("#mobile02").addClass('error');
                         $(".btn_mobile_check").after(errorHtml);
						return false;
					}else{
					     var str = $("#mobile02").val();
                         var pattern_num = /[0-9]/;	// 숫자
                         if( !(pattern_num.test(str))  || str.length<3 ) {
                            $("#mobile02").parents('tr').find('.error_text').remove();
                            errorHtml ='<p class="error_text">휴대폰 번호를 정확하게 입력하세요.</p>';
                            $("#mobile02").removeClass('check_ok');
                            $("#mobile02").addClass('error');
                            $(".btn_mobile_check").after(errorHtml);
                            return false;
                         }else{
                            $("#mobile02").removeClass('error');
                            $("#mobile02").addClass('check_ok');
                            $(".btn_mobile_check").parents('tr').find('.error_text').remove();
                         }
					}

					if(Dmall.validation.isEmpty($("#mobile03").val())) {
						 $("#mobile03").parents('tr').find('.error_text').remove();
						 errorHtml = '<p class="error_text">휴대폰 번호를 입력해주세요.</p>';
                         $("#mobile03").removeClass('check_ok');
                         $("#mobile03").addClass('error');
                         $(".btn_mobile_check").after(errorHtml);
						return false;
					}else{
					     var str = $("#mobile03").val();
                         var pattern_num = /[0-9]/;	// 숫자
                         if( !(pattern_num.test(str)) || str.length<4) {
                            $("#mobile03").parents('tr').find('.error_text').remove();
                            errorHtml ='<p class="error_text">휴대폰 번호를 정확하게 입력하세요.</p>';
                            $("#mobile03").removeClass('check_ok');
                            $("#mobile03").addClass('error');
                            $(".btn_mobile_check").after(errorHtml);
                            return false;
                         }else{
                            $("#mobile03").removeClass('error');
                            $("#mobile03").addClass('check_ok');
                            $(".btn_mobile_check").parents('tr').find('.error_text').remove();

                            $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
                         }
					}

					$('#mobileCertifyYn').val('Y')
					/*if($('#mobileCertifyYn').val() != 'Y'){
						Dmall.LayerUtil.alert("휴대전화 인증을 해주세요.", "확인");
						return false;
					}*/

					if($('#sms_get').is(":checked") == true){
						$('#smsRecvYn').val('Y');
					}else{
						$('#smsRecvYn').val('N');
					}
					if($('#email_get').is(":checked") == true){
						$('#emailRecvYn').val('Y');
					}else{
						$('#emailRecvYn').val('N');
					}

				</c:if>


				<c:if test="${so.memberTypeCd eq '02'}">

                if(Dmall.validation.isEmpty($("#id_check").val())) {
                    $('#id_success_div').attr('style','display:none;')
                    Dmall.LayerUtil.alert("아이디 중복확인을 해주세요.", "알림");
                    return false;
                }

                if(Dmall.validation.isEmpty($("#memberNm").val())) {
              		Dmall.LayerUtil.alert("업체명을 입력해주세요.", "알림");
                    return false;
                }else{
                	$("#memberNm").val( $("#memberNm").val().trim() );
                }
                
                if(Dmall.validation.isEmpty($("#loginId").val())) {
                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#pw").val())) {
                    Dmall.LayerUtil.alert("비밀번호를 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#pw_check").val())) {
                    Dmall.LayerUtil.alert("비밀번호 확인을 입력해주세요.", "알림");
                    return false;
                }
                if( $('#pw').val() !=  $('#pw_check').val()){
                    Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                    return false;
                }

                if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
                    Dmall.LayerUtil.alert("비밀번호 형식이 잘못되었습니다.\n 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.", "확인");
                    return false;
                }
                if(/(\w)\1\1/.test($('#pw').val())){
                    Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번이상 반복하여 사용하실 수 없습니다.", "확인");
                    return false;
                }
                if ($('#pw').val().indexOf($('#loginId').val()) > -1) {
                    Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "확인");
                    return false;
                }

                //사업자등록증
				if(totalFileLength < 1){
					Dmall.LayerUtil.alert("사업자등록증 사본을 등록해주세요.", "확인");
					return false;
				}
				//담당자명
				if( $('#managerNm').val() == '' ){
					Dmall.LayerUtil.alert("담당자명을 입력해주세요.", "확인");
					return false;
				}
                
                if($('#mobileCertifyYn').val() != 'Y'){
                	Dmall.LayerUtil.alert("휴대전화 인증을 해주세요.", "확인");
                	return false;
                }

                if($('input:radio[name=gender]').length > 0) {
                    $('#genderGbCd').val($('input:radio[name=gender]:checked').val());
                }

                </c:if>
                $('#memberGbCd').val($('input:radio[name=shipping]:checked').val()); //회원 국내/해외 여부
                /*사업자*/
                <c:if test="${so.memberTypeCd eq '02'}">
                if(customerInputCheck()){
                    if(passwordCheck(jQuery("#pw").val())){
                </c:if>
                    	//이름,휴대전화번호로 기존회원 여부 체크
                    	var url = '/front/member/duplication-mem-check';
                    	var memberNm = $('#memberNm').val();
                    	var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
        				var param = {memberNm : memberNm, mobile : mobile}
        				Dmall.AjaxUtil.getJSON(url, param, function(result) {
        					if(result.length > 0){
        						var html = '';
                            	var loginId = '';
                            	var integration = '01';
                            	for(var i=0; i<result.length;i++){
                            		if(html != '') html += ", ";
                            		if(result[i].joinPathCd == 'NV'){
                            			loginId = '네이버 로그인';
                            		}else if(result[i].joinPathCd == 'KT'){
                            			loginId = '카카오톡 로그인';
                            		}else if(result[i].joinPathCd == 'FB'){
                            			loginId = '페이스북 로그인';
                            		}else{
	                            		loginId = result[i].loginId;
	                            		loginId = loginId.substring(0,loginId.length - 3);
	                            		loginId += '***';
                            		}
                            		html += loginId;
                            		
                            		if(result[i].integrationMemberGbCd == '03') {
                            			var integration = '03';
                            		}
                            	}
                            	if(integration == '03'){
                            		$('#txt_integration').text('이미 통합 된 아이디가 있습니다.');
                            	}else{
                            		$('#txt_integration').text('이미 가입 된 정회원 아이디가 있습니다.');
                            	}
                            	html = '(' + html + ')';
                            	$('#mem_dulicate_id_list').html(html);
                            	
                            	Dmall.LayerPopupUtil.open($('#popup_mem_duplicate_check'));
                            	
                            	/* $('#mem_duplicate_continue').click(function(){
                            		Dmall.LayerPopupUtil.close('popup_mem_duplicate_check');
                            		
                            		memberInsert();
                            	}); */
        					}else{
        						
        						Dmall.LayerUtil.confirm('\'확인\' 버튼을 누르시면 회원가입을 완료됩니다.', function() {
        							memberInsert();
        						});
        					}
        					
        				});
                <c:if test="${so.memberTypeCd eq '02'}">
                /* 사업자 */
                    }
                }
                </c:if>


            })

            //취소하기
            $('.btn_join_cancel').on('click',function (){
                location.href = "/front/main-view";
            });

            //파일 변경
            var num = 1;
            jQuery(document).on('change',"input[type=file]", function(e) {
                var bbsId = "${so.bbsId}";
                var fileSize = 0;
                if(jQuery(this).attr('id') == "input_id_image"){
                    return;
                }
                
                var fileSize = $(this)[0].files[0].size;
                var maxSize = <spring:eval expression="@front['system.upload.file.size']"/>;
                
                if(fileSize > maxSize){
                	var maxSize_MB = maxSize / (1024*1024);
                	Dmall.LayerUtil.alert('파일 용량 '+maxSize_MB.toFixed(2)+' Mb 이내로 등록해 주세요.','','');
                	return;
                }

                var ext = jQuery(this).val().split('.').pop().toLowerCase();
                //'pptx','ppt','xls','xlsx','doc','docx','hwp', 제외
                if($.inArray(ext, ['pdf','gif','png','jpg']) == -1) {
                    Dmall.LayerUtil.alert('jpg, png, gif, pdf 형식의 파일만 업로드 할 수 있습니다.','','');
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#input_id_files"+num).val("");
                    return;
                }

                var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
                totalFileLength = totalFileLength+1;

                if(totalFileLength>1){
                    Dmall.LayerUtil.alert('첨부파일는 최대 1개까지 등록 가능합니다.');
                    totalFileLength = totalFileLength-1;
                    $("#input_id_files"+num).replaceWith( $("#input_id_files"+num).clone(true) );
                    $("#input_id_files"+num).val("");
                    return;
                }

                document.getElementById("fileSpan"+num).style.display = "none";

                var text = "<span class='file_add'  name='_fileNm"+num+"' id='_fileNm"+num+"'>" +
                                "<span id='tes"+num+"'>"+fileNm+"</span>" +
                                "<button type='button' onclick= 'return delNewFileNm("+num+","+fileSize+")' class='btn_del'>" +
                                "</button>" +
                            "</span>";

                $( "#viewFileInsert" ).append( text );
                num = num+1;
                $( "#fileSetList" ).append(
                    "<span id=\"fileSpan"+num+"\" style=\"visibility: visible\">"+
                    "<label for=\"input_id_files"+num+"\">파일등록</label>"+
                    "<input class=\"upload-hidden\" name=\"files"+num+"\" id=\"input_id_files"+num+"\" type=\"file\">"+
                    " </span>"
                );
            });
            
            $('#btn_mobile_close').click(function(){
            	Dmall.LayerPopupUtil.close('popup_mobile_check');
            });

        });

        //숫자만 입력 가능 메소드
        function onlyNumDecimalInput(event){
            var code = window.event.keyCode;

            if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
                window.event.returnValue = true;
                return;
            }else{
                window.event.returnValue = false;
                return false;
            }
        }

        //파일 삭제
        function delNewFileNm(fileNo, fileSize){
            totalFileLength = totalFileLength-1;
            $("#_fileNm"+fileNo).remove();
            $("#input_id_files"+fileNo).remove();
            return false;
        }
        
        //생년월일 유효성 체크
        function isValidDate(dateStr) {
             var year = Number(dateStr.substr(0,4)); 
             var month = Number(dateStr.substr(4,2));
             var day = Number(dateStr.substr(6,2));
             var today = new Date(); // 날자 변수 선언
             var yearNow = today.getFullYear();
             if (month < 1 || month > 12) { 
                  alert("달은 1월부터 12월까지 입력 가능합니다.");
                  return false;
             }
            if (day < 1 || day > 31) {
                  alert("일은 1일부터 31일까지 입력가능합니다.");
                  return false;
             }
             if ((month==4 || month==6 || month==9 || month==11) && day==31) {
                  alert(month+"월은 31일이 존재하지 않습니다.");
                  return false;
             }
             if (month == 2) {
                  var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
                  if (day>29 || (day==29 && !isleap)) {
                       alert(year + "년 2월은  " + day + "일이 없습니다.");
                       return false;
                  }
             }
             
             if (year > yearNow) {
            	 alert("년도를 확인하세요. 생년월일 형식이 잘못되었습니다.");
                 return false;
             }

             if(calcAge(dateStr) < 14){
                Dmall.LayerUtil.alert("만 14세 미만 고객님은<br>해당 서비스를 이용하실 수 없습니다.", "알림");
		         return false;
             }
             
             return true;
        }



        function calcAge(birth){
          var age_year = birth.substr(0, 4)
          var age_month = birth.substr(4, 2);
          var age_day = birth.substr(6, 2);

          var date = new Date();
          var today_year = date.getFullYear();
          var today_month = (date.getMonth() + 1);
          var today_day =date.getDate();

          var birth = new Date(age_year, age_month, age_day);
          var today_orgin = new Date(today_year, today_month, today_day);
          var time = today_orgin.getTime() - birth.getTime();
          var sec =  parseFloat( time / 1000).toFixed(2);
          var min = parseFloat(sec /60).toFixed(2);
          var hour = parseFloat(min /60).toFixed(2);
          var day = parseFloat(hour / 24).toFixed(2);
          var year = Math.floor(day / 365);//소수점 버림.

          return year;
        }

        function memberInsert(){
        	
       		Dmall.waiting.start();
           	$('#form_id_insert_member').ajaxSubmit({
                url : "/front/member/member-insert",
                dataType : 'json',
                success : function(result){
                	Dmall.waiting.stop();
                    Dmall.validate.viewExceptionMessage(result, 'form_id_insert_member');
                    if(result.success){
                        var data = result.data;
                        var param = {
                        		'memberNm' : $('#memberNm').val()
                        		,'memberCardNo' : data.memberCardNo
                        };
                        Dmall.LayerUtil.alert(result.message).done(function(){
                            Dmall.FormUtil.submit('/front/member/member-join-complete', param);
                        });
                    } else {
                        Dmall.LayerUtil.alert(result.message);
                    }
                }
            });
        }
        
        var min = 0;
        var sec = 0;
        var time = 0;
        var runCount;
        function fnCountDown(){
        	time = 180;
        	runCount = setInterval(startCountDown, 1000);
        }
        
        function startCountDown(){
        	//hour = parseInt(time/3600);
			min = parseInt((time%3600)/60);
			sec = time%60;
			if(sec < 10){
				sec = '0' + sec;
			}
			$("#certify_timer").text(min+"분 "+sec+"초");
			if(parseInt(time) == 0){
				stopCountDown();
				$('#div_mobile_check').css('display','none');
				$('#div_mobile_check_fail').css('display','block');
			} else {
				time--;
			}
        }
        
        function stopCountDown() {
        	clearInterval(runCount);
		}


		$(function() {
                $('.password_form').letteringInput({
                    inputClass: 'digit',
                    hiddenInputWrapperID: 'testWrapper',
                    hiddenInputName: 'pw',
                    onLetterKeyup: function ($item, event) {
                        console.log($item, event);



                    },
                    onSet: function ($el, event, value) {
                        console.log($el, event, value);
                        $('.pwview').text($('input[name="pw"]', '#testWrapper').val());
                    },
                });
            });

		/*if (window.jQuery) {
			(function ($) {
				$.fn.passwordify = function (opts) {
					var settings = $.extend({
						maxLength: 16,
						numbersOnly: false,
						alphaOnly: false,
						alNumOnly: false,
						notKor:false,
						enterKeyCallback: null
					}, opts);

					var rePattern = '\\s\\S';
					if (settings.numbersOnly) rePattern = '0-9';
					if (settings.alphaOnly) rePattern = 'A-z';
					if (settings.alNumOnly) rePattern = '0-9A-z';
					if (settings.notKor) rePattern = '/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/';

					var maskPlaceholder = "";
					for (var i = 0; i < settings.maxLength; i++)
					{
						maskPlaceholder = maskPlaceholder + 'Z';
					}

					return this.on('keyup', function (e) {
						var me = $(this);
						switch (e.which) {
							case 8: // Handle backspace
							    if($(this).val()==''){
                                    $(this).data('val', '');
                                }else{
								    $(this).data('val', $(this).data('val').slice(0, -1));
								}
								break;
							case 13: // Handle enter key
								if (typeof settings.enterKeyCallback == 'function') settings.enterKeyCallback(me);
								break;
							case 229:
							    var pattern_kor = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/; // 한글체크
                                var str = $(this).val();

                                if( pattern_kor.test(str)){
                                   Dmall.LayerUtil.alert("한글은 입력하실 수 없습니다.", "확인");
                                   $(this).val( $(this).val().replace( /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '' ) );
                                   return false;
                                }
							    if ($(this).data('val').length < settings.maxLength) {
                                    $(this).data('val', $(this).data('val') + inko.ko2en($(this).val().replaceAll('\\*', '')));
                                }
    							break;
							case undefined:
								$(this).data('val', inko.ko2en($(this).val()));
    							break;
                        default: // All other input
                            if($(this).val()==''){
                                $(this).data('val', '');
                            }
                            var regex = new RegExp("^[" + rePattern + "]$");
                            if (regex.exec(e.key) && $(this).data('val').length < settings.maxLength) {
                                $(this).data('val', $(this).data('val') + e.key);
                            }
						}

						$('#pw').val($(this).data('val'));
					    $(".pwview").html($(this).data('val'));

						setTimeout(function () {
							var inpVal = me.val();
							me.val(inpVal.replace(/./gi, '*'));

							me.trigger('change');
						}, 300);
					}).mask(maskPlaceholder, {
						translation: {
							'Z': {pattern: "[" + rePattern + "\*]"}
						}
					});
				}
			})(jQuery);
		} else {
			console.log("Passwordify.js: This class requies jQuery > v3!");
		}*/
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <%-- logCorpAScript --%>
     <%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
     <c:set var="http_SO" value="REGF" scope="request"/>
     <%--// logCorpAScript --%>

     <!--- 02.LAYOUT: MIDDLE AREA --->
	<div id="member_container">
		<div class="table_top_area">
			<c:choose>
	            <c:when test="${so.memberTypeCd eq '02'}">
					사업자회원 정보입력
	            </c:when>
	            <c:otherwise>
	            	개인회원 정보입력
	            </c:otherwise>
			</c:choose>
		</div>

		<!--- 기본정보 --->
        <form:form id="form_id_insert_member">
        <c:set var="bornYear" value=""/>
        <c:set var="bornMonth" value=""/>
        <c:if test="${!empty so.birth}">
            <c:set var="bornYear" value="${fn:substring(so.birth,0,4)}"/>
            <c:set var="bornMonth" value="${fn:substring(so.birth,4,6)}"/>
        </c:if>
        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/><!-- 국적구분코드 -->
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/><!-- 인증방법코드 -->
        <input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
        <input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
        <input type="hidden" name="bornYear" id="bornYear" value="${bornYear}" />
        <input type="hidden" name="bornMonth" id="bornMonth" value="${bornMonth}" />
        <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}" />
        <input type="hidden" name="tel" id="tel"/><!-- 전화번호 -->
        <input type="hidden" name="mobile" id="mobile"/><!-- 모바일 -->
        <input type="hidden" name="email" id="email" value=""/><!-- email -->
        <input type="hidden" name="realnmCertifyYn" id="realnmCertifyYn"/><!-- 실명인증여부 -->
        <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
        <input type="hidden" name="frgMemberYn" id="frgMemberYn"/><!-- 해외회원여부 -->
        <input type="hidden" name="memberGbCd" id="memberGbCd" value="10"><!-- 해외회원여부 국내(10),해외(20)-->
        <input type="hidden" name="memberTypeCd" id="memberTypeCd" value="${so.memberTypeCd}"/><!-- 회원 유형 (개인/사업자) 코드 -->

		<input type="hidden" name="rule04Agree" id="paramRule04Agree" value="${so.rule04Agree}"/>
        <input type="hidden" name="rule22Agree" id="paramRule22Agree" value="${so.rule22Agree}"/>
        <input type="hidden" name="rule21Agree" id="paramRule21Agree" value="${so.rule21Agree}"/>
        <input type="hidden" name="rule09Agree" id="paramRule09Agree" value="${so.rule09Agree}"/>
        <input type="hidden" name="rule10Agree" id="paramRule10Agree" value="${so.rule10Agree}"/>


        <input type="hidden" id="mobileCertifyYn" value="N"/>
		<c:if test="${so.memberTypeCd eq '01'}">
		<table class="tInsert tmember_join">
			<caption>개인회원 정보입력 폼입니다.</caption>
			<colgroup>
				<col style="width:224px">
				<col style="">
			</colgroup>
			<tbody>
				<tr>
					<th>아이디(이메일)<em>*</em></th>
					<td>
						<input type="text" id="loginId" name="loginId" class="loginId">
					</td>
					<%--<td><input type="text" class="check_ok" value="davich@davich.com"></td>
					<td>
						<input type="text" class="error" value="davich@davich.com">
						<p class="error_text">이메일 형식이 아닙니다.</p>
					</td>--%>
				</tr>
				<tr>
					<th>비밀번호<em>*</em></th>
					<td>
					    <div class="password_form">
						  <input type="password" id="inPw" name="inPw" <%--onkeyup="passwordInputCheck2();"--%> data-val="" value="" maxlength="16" class="digit" placeholder="영문, 숫자, 특수문자 8~16자">
						  <div id="testWrapper">
						  <label for="inPw" class="pwview"></label>
						  <input type="password" id="pw" name="pw" style="display:none;">
						  </div>
						</div>
                    </td>
                    <%--<td>
					    <div class="password_form check_ok">
						  <input type="password" id="" placeholder="영문, 숫자, 특수문자 8~16자">
						  <label for="" class="pwview">1225124!@</label>
						</div>
                    </td>
                    <td>
						<div class="password_form error">
						  <input type="password" id="" placeholder="영문, 숫자, 특수문자 8~16자">
						  <label for="" class="pwview">1225124!@</label>
						</div>
						<p class="error_text">비밀번호는 8~20자 이내로 입력하셔야 합니다.</p>
					</td>--%>
				</tr>
				<tr>
					<th>이름<em>*</em></th>
					<td><input type="text" id="memberNm" name="memberNm" value="${so.memberNm}" <c:if test="${!empty so.certifyMethodCd}">readonly="readonly"</c:if> class="memberNm"></td>
					<%--<td><input type="text" class="check_ok" value="다비치"></td>
					<td><input type="text" class="error" value="다비치"></td>--%>
				</tr>
				<tr>
					<th>휴대전화<em>*</em></th>
					<td>
						<select id="mobile01" class="phone check_ok">
							<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
						</select>
						<span class="bar">-</span>
						<input type="text" id="mobile02" maxlength="4" class="phone mobile02" onKeydown="return onlyNumDecimalInput(event);">
						<span class="bar">-</span>
						<input type="text" id="mobile03" maxlength="4" class="phone mobile03" onKeydown="return onlyNumDecimalInput(event);">
						<button type="button" class="btn_form btn_mobile_check">인증받기</button>
					</td>
					<%--<td>
						<select class="phone check_ok">
							<option>010</option>
						</select>
						<span class="bar">-</span>
						<input type="text" class="phone check_ok" value="0000">
						<span class="bar">-</span>
						<input type="text" class="phone check_ok" value="0000">
						<button type="button" class="btn_form">인증받기</button>
					</td>
					<td>
						<select class="phone error">
							<option>010</option>
						</select>
						<span class="bar">-</span>
						<input type="text" class="phone error" value="0000">
						<span class="bar">-</span>
						<input type="text" class="phone error" value="0000">
						<button type="button" class="btn_form">인증받기</button>
					</td>--%>
				</tr>
				<tr>
					<th class="vaT">사용자 연령제한</th>
					<td>
						<input type="checkbox" id="age" name="age" class="agree_check">
						<label for="age"><span></span>만 14세 미만입니다.</label>
					</td>
				</tr>
				<tr>
					<th class="vaT">마케팅수신동의</th>
					<td>
						<input type="checkbox" id="email_get" name="email_get" class="agree_check">
                        <label for="email_get"><span></span>이메일</label>
                        <input type="checkbox" id="sms_get" name="sms_get" class="agree_check">
                        <label for="sms_get" class="marginL20"><span></span>SMS</label>
						<p class="info">* 약관변경, 주문/배송 등과 같이 주요 정책, 정보에 대한 안내는 수신동의 여부와 무관하게 발송됩니다.</p>
					</td>
				</tr>
			</tbody>
		</table>
		</c:if>
		<c:if test="${so.memberTypeCd eq '02'}">
		<table class="tInsert">
            <caption>개인회원 정보입력 폼입니다.</caption>
            <colgroup>
                <col style="width:224px">
                <col style="">
            </colgroup>
            <tbody>
            <tr>
                <th>아이디 <span class="important">*</span></th>
                <td>
                    <input type="text" id="loginId" name="loginId" style="width:232px;margin-right:5px" value="" maxlength="20" data-validation-engine="validate[required, maxSize[20]]">
                    <button type="button" class="btn_form btn_id_check">중복확인</button>
                    <span class="insert_guide">(영문, 숫자 사용가능하며, 6~20자 가능)</span>
                </td>
            </tr>
            <tr>
                <th>비밀번호 <span class="important">*</span></th>
                <td>
                    <input type="password" id="pw" name="pw" onkeyup="passwordInputCheck();" maxlength="16" placeholder="영문,숫자,특수문자 8~16자">&nbsp;<span id="passCheck"></span>
                </td>
            </tr>
            <tr>
                <th>비밀번호 확인 <span class="important">*</span></th>
                <td>
                    <input type="password" id="pw_check" name="pw_check" maxlength="16" placeholder="비밀번호재입력">

                </td>
            </tr>
			<tr>
				<th>사업자등록번호<span class="important">*</span></th>
				<td>
					<input type="text" id="bizRegNo" name="bizRegNo" value="" maxlength="10" data-validation-engine="validate[required, maxSize[10]]">
				</td>
			</tr>
			<tr>
				<th>사업자등록증 사본<span class="important">*</span></th>
				<td>
					<div class="filebox">
						<span id = "fileSetList">
							<span id="fileSpan1" style="visibility: visible">
								<label for="input_id_files1">파일등록</label>
								<%--<input disabled="disabled" class="upload-name" value="">--%>

								<input class="upload-hidden" name="files1" id="input_id_files1" type="file">
							</span>
						</span>
						<span id="viewFileInsert"></span>

						<%--<button type="button" class="btn_del"></button>--%><!--삭제버튼:불러온 이미지 이름 바로 옆에 붙게 해주세요 -->
					</div>
					<br>
					<spring:eval expression="@front['system.upload.file.size']" var="maxSize" />
					<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
					<p>(jpg, png, gif, pdf 형식 ${maxSize_MB }Mb 이내)</p>
				</td>
			</tr>
			<tr>
			<th>업체명 <span class="important">*</span></th>
				<td><input type="text" id="memberNm" name="memberNm" style="width:232px;" value="${so.memberNm}" <c:if test="${!empty so.certifyMethodCd}">readonly="readonly"</c:if> data-validation-engine="validate[required, maxSize[20]]"></td>
			</tr>
			<th>대표자명</th>
				<td><input type="text" id="ceoNm" name="ceoNm" maxlength="10" ></td>
			</tr>
            <tr>
                <th class="vaT">주소</th>
                <td>
                    <input type="text" id="newPostNo" name="newPostNo" style="width:124px;margin-right:5px" readonly="readonly">
                    <button type="button" class="btn_form btn_post">우편번호</button>
                    <input type="hidden" id="strtnbAddr" name="strtnbAddr" class="form_address"readonly="readonly">
                    <input type="text" id="roadAddr" name="roadAddr" class="form_address" readonly="readonly">
                    <br>
                    <input type="text" id="dtlAddr" name="dtlAddr" class="form_address" placeholder="상세주소">
                </td>
            </tr>
			<tr>
				<th>담당자명 <span class="important">*</span></th>
				<td>
					<input type="text" id="managerNm" name="managerNm" maxlength="10" >
				</td>
			</tr>
			<tr>
				<th>휴대전화 <span class="important">*</span></th>
				<td>
					<select id="mobile01" class="phone">
						<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
					</select>
					<span class="bar">-</span>
					<input type="text" class="phone" id="mobile02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
					<span class="bar">-</span>
					<input type="text" class="phone" id="mobile03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
					<button type="button" class="btn_form btn_mobile_check">휴대전화 인증</button>
				</td>
			</tr>
			<tr>
				<th>이메일 <span class="important">*</span></th>
				<td>
					<input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
					<select id="email03" class="select_option" title="select option">
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
				</td>
			</tr>
			<tr>
            	<th>사용자 연령제한</th>
            	<td>
            		<input type="checkbox" id="age_limit_check" class="agree_check">
                    <label for="age_limit_check"><span></span>만 14세 미만입니다.</label>
            	</td>
            </tr>
            <tr>
                <th class="vaT">마케팅수신동의</th>
                <td>
                    <input type="checkbox" id="email_get" name="email_get" class="agree_check">
                    <label for="email_get"><span></span>이메일</label>
                    <input type="checkbox" id="sms_get" name="sms_get" class="agree_check">
                    <label for="sms_get" class="marginL20"><span></span>SMS</label>
                    <p class="info">* 약관변경, 주문/배송 등과 같이 주요 정책, 정보에 대한 안내는 수신동의 여부와 무관하게 발송됩니다.</p>
                </td>
            </tr>
            </tbody>
        </table>
		</c:if>
		</form:form>
		<div class="btn_member_area insert">
			<button type="button" class="btn_go_next">회원가입</button>
		</div>
	</div>
	<!---// 02.LAYOUT: MIDDLE AREA --->


<%--


    <!--- contents --->
    <div id="member_container" style="margin-top:0;">
        <div class="com_head">
        	<c:choose>
	            <c:when test="${so.memberTypeCd eq '02'}">
					<h2 class="com_tit">사업자회원 정보입력</h2>
	            </c:when>
	            <c:otherwise>
	            	<h2 class="com_tit">개인회원 정보입력</h2>
	            </c:otherwise>
			</c:choose>
        </div>
        <!--- 기본정보 --->
        <form:form id="form_id_insert_member">
        <c:set var="bornYear" value=""/>
        <c:set var="bornMonth" value=""/>
        <c:if test="${!empty so.birth}">
            <c:set var="bornYear" value="${fn:substring(so.birth,0,4)}"/>
            <c:set var="bornMonth" value="${fn:substring(so.birth,4,6)}"/>
        </c:if>
        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/><!-- 국적구분코드 -->
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/><!-- 인증방법코드 -->
        <input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
        <input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
        <input type="hidden" name="bornYear" id="bornYear" value="${bornYear}" />
        <input type="hidden" name="bornMonth" id="bornMonth" value="${bornMonth}" />
        <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}" />
        <input type="hidden" name="tel" id="tel"/><!-- 전화번호 -->
        <input type="hidden" name="mobile" id="mobile"/><!-- 모바일 -->
        <input type="hidden" name="email" id="email" value=""/><!-- email -->
        <input type="hidden" name="realnmCertifyYn" id="realnmCertifyYn"/><!-- 실명인증여부 -->
        <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
        <input type="hidden" name="frgMemberYn" id="frgMemberYn"/><!-- 해외회원여부 -->
        <input type="hidden" name="memberGbCd" id="memberGbCd" value="10"><!-- 해외회원여부 국내(10),해외(20)-->
        <input type="hidden" name="memberTypeCd" id="memberTypeCd" value="${so.memberTypeCd}"/><!-- 회원 유형 (개인/사업자) 코드 -->
        <input type="hidden" id="mobileCertifyYn" value="N"/>
        <table class="tInsert">
            <caption>개인회원 정보입력 폼입니다.</caption>
            <colgroup>
                <col style="width:224px">
                <col style="">
            </colgroup>
            <tbody>
            <tr>
                <th>아이디 <span class="important">*</span></th>
                <td>
                    &lt;%&ndash;${so.email}&ndash;%&gt;
                    <input type="text" id="loginId" name="loginId" style="width:232px;margin-right:5px" value="" maxlength="20" data-validation-engine="validate[required, maxSize[20]]">
                    <button type="button" class="btn_form btn_id_check">중복확인</button>
                    <span class="insert_guide">(영문, 숫자 사용가능하며, 6~20자 가능)</span>
                </td>
            </tr>
            <tr>
                <th>비밀번호 <span class="important">*</span></th>
                <td>
                    <input type="password" id="pw" name="pw" onkeyup="passwordInputCheck();" maxlength="16" placeholder="영문,숫자,특수문자 8~16자">&nbsp;<span id="passCheck"></span>
                </td>
            </tr>
            <tr>
                <th>비밀번호 확인 <span class="important">*</span></th>
                <td>
                    <input type="password" id="pw_check" name="pw_check" maxlength="16" placeholder="비밀번호재입력">

                </td>
            </tr>
            <c:if test="${so.memberTypeCd eq '01'}">
            	<th>이름 <span class="important">*</span></th>
            	<td><input type="text" id="memberNm" name="memberNm" style="width:232px;" value="${so.memberNm}" <c:if test="${!empty so.certifyMethodCd}">readonly="readonly"</c:if> data-validation-engine="validate[required, maxSize[20]]"></td>
            <c:choose>
            <c:when test="${so.memberDi != '' && so.memberDi ne null}">
                <tr>
                    <th>성별 <span class="important">*</span></th>
                    <td>
                        <c:if test="${so.genderGbCd eq 'M'}">남</c:if>
                        <c:if test="${so.genderGbCd eq 'F'}">여</c:if>
                    </td>
                </tr>
                <tr>
                    <th>생년월일 <span class="important">*</span></th>
                    <td>
                            ${so.birth.substring(0,4)}년 ${so.birth.substring(4,6)}월 ${so.birth.substring(6,8)}일
                    </td>
                </tr>

            </c:when>
            <c:otherwise>
                <tr>
                    <th>성별 <span class="important">*</span></th>
                    <td>
                    	<input type="radio" id="female" name="gender" class="member_join" value="F" checked>
                        <label for="female"><span></span>여성</label>
                        <input type="radio" id="male" name="gender" class="member_join" value="M">
                        <label for="male" class="marginL20"><span></span>남성</label>
                    </td>
                </tr>
                <tr>
                    <th>생년월일 <span class="important">*</span></th>
                    <td>
                    	<input type="text" name="birth" id="birth" placeholder="ex.19950315" value="${so.birth}" onKeydown="return onlyNumDecimalInput(event);" maxlength="8">
                    	* 만14세 이상 가입이 가능합니다
                        &lt;%&ndash; <div id="birth_year" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_birth_year">- 선택 -</label>
                            <select class="select_option" id="select_birth_year" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthYear" begin="1950" end="2016">
                                    <fmt:formatNumber var="timePattern" value="${birthYear}" pattern="0000"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        년
                        <div id="birth_month" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_birth_month">- 선택 -</label>
                            <select class="select_option" id="select_birth_month" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthMonth" begin="1" end="12">
                                    <fmt:formatNumber var="timePattern" value="${birthMonth}" pattern="00"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        월
                        <div id="birth_day" class="select_box28" style="width:67px;display:inline-block">
                            <label for="select_birth_day">- 선택 -</label>
                            <select class="select_option" id="select_birth_day" title="select option">
                                <option value="" selected>- 선택 -</option>
                                <c:forEach var="birthDay" begin="01" end="31">
                                    <fmt:formatNumber var="timePattern" value="${birthDay}" pattern="00"/>
                                    <option value="${timePattern}">${timePattern}</option>
                                </c:forEach>
                            </select>
                        </div>
                        일 &ndash;%&gt;
                    </td>
                </tr>
            </c:otherwise>
            </c:choose>
            </c:if>
            <c:if test="${so.memberTypeCd eq '02'}">
                <tr>
                    <th>사업자등록번호<span class="important">*</span></th>
                    <td>
                        &lt;%&ndash;${so.searchBizNo.substring(0,3)}- ${so.searchBizNo.substring(3,5)}-${so.searchBizNo.substring(5,10)}&ndash;%&gt;
                        <input type="text" id="bizRegNo" name="bizRegNo" value="" maxlength="10" data-validation-engine="validate[required, maxSize[10]]">
                    </td>
                </tr>
                <tr>
                    <th>사업자등록증 사본<span class="important">*</span></th>
                    <td>
                        <div class="filebox">
                            <span id = "fileSetList">
                                <span id="fileSpan1" style="visibility: visible">
                                    <label for="input_id_files1">파일등록</label>
                                    &lt;%&ndash;<input disabled="disabled" class="upload-name" value="">&ndash;%&gt;

                                    <input class="upload-hidden" name="files1" id="input_id_files1" type="file">
                                </span>
                            </span>
                            <span id="viewFileInsert"></span>

                            &lt;%&ndash;<button type="button" class="btn_del"></button>&ndash;%&gt;<!--삭제버튼:불러온 이미지 이름 바로 옆에 붙게 해주세요 -->
                        </div>
                        <br>
                        <spring:eval expression="@front['system.upload.file.size']" var="maxSize" />
						<fmt:parseNumber value="${maxSize / (1024*1024) }" var="maxSize_MB" integerOnly="true" />
                        <p>(jpg, png, gif, pdf 형식 ${maxSize_MB }Mb 이내)</p>
&lt;%&ndash;

                        <input type="text" id="filename02" class="floatL" readonly="readonly" style="width:280px;">
                        <div class="file_up">
                                <span id = "fileSetList">
                                    <span id="fileSpan1" style="visibility: visible">
                                        <button type="button" class="btn_fileup" value="Search files">file</button>
                                        <input type="file" name="files1" id="input_id_files1" style="width:100%">
                                    </span>
                                </span>
                        </div>
                        <div id="viewFileInsert"></div>
&ndash;%&gt;

                    </td>
                </tr>
                <tr>
                <th>업체명 <span class="important">*</span></th>
	                <td><input type="text" id="memberNm" name="memberNm" style="width:232px;" value="${so.memberNm}" <c:if test="${!empty so.certifyMethodCd}">readonly="readonly"</c:if> data-validation-engine="validate[required, maxSize[20]]"></td>
	            </tr>
	            <th>대표자명</th>
	                <td><input type="text" id="ceoNm" name="ceoNm" maxlength="10" ></td>
	            </tr>
            </c:if>
            &lt;%&ndash; <tr>
                <th>일반전화</th>
                <td>
                    <select id="tel01" style="width:69px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" includeTotal="true" mode="S"/>
                    </select>
                    <span class="bar">-</span>
                    <input type="text" id="tel02" class="phone" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                    <span class="bar">-</span>
                    <input type="text" id="tel03" class="phone" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                </td>
            </tr> &ndash;%&gt;
            <c:if test="${so.memberTypeCd eq '01'}">
            	<tr>
                	<th>휴대전화 <span class="important">*</span></th>
	                <td>
	                    <select id="mobile01" class="phone">
	                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
	                    </select>
	                    <span class="bar">-</span>
	                    <input type="text" class="phone" id="mobile02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
	                    <span class="bar">-</span>
	                    <input type="text" class="phone" id="mobile03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
	                    <button type="button" class="btn_form btn_mobile_check">인증받기</button>
	                </td>
	            </tr>
	            <tr>
	                <th>이메일 <span class="important">*</span></th>
	                <td>
	                    <input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
	                    <select id="email03" class="select_option" title="select option">
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
	                </td>
	            </tr>
			</c:if>
            <tr>
                <th class="vaT">주소</th>
                <td>
                    <input type="text" id="newPostNo" name="newPostNo" style="width:124px;margin-right:5px" readonly="readonly">
                    <button type="button" class="btn_form btn_post">우편번호</button>
                    <input type="hidden" id="strtnbAddr" name="strtnbAddr" class="form_address"readonly="readonly">
                    <input type="text" id="roadAddr" name="roadAddr" class="form_address" readonly="readonly">
                    <br>
                    <input type="text" id="dtlAddr" name="dtlAddr" class="form_address" placeholder="상세주소">
                </td>
            </tr>
            <c:if test="${so.memberTypeCd eq '02'}">
            	<tr>
                    <th>담당자명 <span class="important">*</span></th>
                    <td>
                        <input type="text" id="managerNm" name="managerNm" maxlength="10" >
                    </td>
                </tr>
                <tr>
                	<th>휴대전화 <span class="important">*</span></th>
	                <td>
	                    <select id="mobile01" class="phone">
	                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
	                    </select>
	                    <span class="bar">-</span>
	                    <input type="text" class="phone" id="mobile02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
	                    <span class="bar">-</span>
	                    <input type="text" class="phone" id="mobile03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
	                    <button type="button" class="btn_form btn_mobile_check">휴대전화 인증</button>
	                </td>
	            </tr>
	            <tr>
	                <th>이메일 <span class="important">*</span></th>
	                <td>
	                    <input type="text" id="email01" style="width:124px;"> @ <input type="text" id="email02" style="width:124px;">
	                    <select id="email03" class="select_option" title="select option">
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
	                </td>
	            </tr>
			</c:if>
			<tr>
            	<th>사용자 연령제한</th>
            	<td>
            		<input type="checkbox" id="age_limit_check" class="agree_check">
                    <label for="age_limit_check"><span></span>만 14세 미만입니다.</label>
            	</td>
            </tr>
            <tr>
                <th class="vaT">마케팅수신동의</th>
                <td>
                    <input type="checkbox" id="email_get" name="email_get" class="agree_check">
                    <label for="email_get"><span></span>이메일</label>
                    <input type="checkbox" id="sms_get" name="sms_get" class="agree_check">
                    <label for="sms_get" class="marginL20"><span></span>SMS</label>
                    <p class="info">* 약관변경, 주문/배송 등과 같이 주요 정책, 정보에 대한 안내는 수신동의 여부와 무관하게 발송됩니다.</p>
                </td>
            </tr>
            &lt;%&ndash; <tr>
            	<th class="vaT">추천인 아이디</th>
            	<td>
            		<input type="text" id="recomMemberId" style="width:232px;" data-validation-engine="validate[maxSize[20]]">
            		<button type="button" class="btn_form" id="btnRecomChk">아이디 확인</button>
            		<input type="hidden" id="recomMemberNo" name="recomMemberNo">
            	</td>
            </tr> &ndash;%&gt;
            </tbody>
        </table>
        </form:form>
        <div class="btn_member_area insert">
            <button type="button" class="btn_go_next">회원가입</button>
            <!-- <button type="button" class="btn_join_cancel">취소하기</button> -->
        </div>
    </div>
--%>

    <!--- popup 아이디 중복확인 --->
    <div id="popup_id_duplicate_check" style="width:500px;display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">아이디 중복확인</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <div class="pw_search_info" style="width:100%">
                아이디는 영문, 숫자 가능하며 6~20자 이내로 입력해주세요.
            </div>
            <ul class="id_duplicate_check">
                <li>
                    <input type="text" id="id_check" maxlength="20">
                    <button type="button" class="btn_id_duplicate_check" id="btn_id_duplicate_check">중복확인</button>
                </li>
            </ul>
            <div>
                <div class="id_duplicate_check_info" ></div>
                <div class="textC" id="id_success_div" style="display: none;">
                    <button type="button" class="btn_popup_login" id="btn_popup_login" style="margin-top:22px">사용하기</button>
                </div>
            </div>
        </div>
    </div>
    <!---// popup 아이디 중복확인 --->
    
    <!--- popup 회원 중복확인 --->
    <div id="popup_mem_duplicate_check" class="layer_popup popup_total_member" style="display:none;">
        <div class="pop_wrap">
            <button type="button" class="btn_close_popup"></button>
	        <div class="popup_content">
	        	<div class="total_member_tit">
	        		<span id="txt_integration">
	        			이미 가입 된 정회원 아이디가 있습니다.
	        		</span>
					<p class="total_id_box" id="mem_dulicate_id_list"></p>
				</div>
				<div class="total_member_text">
					비밀번호를 잊어버리셨다면 <a href="javascript:Dmall.FormUtil.submit('/front/login/account-search?mode=pass');" >비밀번호찾기</a>를 이용해주세요.
					<br>ID 변경을 원하시는 경우 마이페이지에서 변경 가능합니다.(1회)
				</div>
				<!-- <p class="total_member_ing">신규 등록을 원하시는 경우 <a href="javascript:;" id="mem_duplicate_continue">계속하기</a></p> -->
	        </div>
		</div>
    </div>
    <!---// popup 회원 중복확인 --->
    
    <!--- popup 모바일 인증 --->
    <div id="popup_mobile_check" style="width:500px;display:none;">
        <div class="popup_header">
            <h1 class="popup_tit">휴대전화 인증</h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
        	<div class="mobile_certify_info" id="div_mobile_check" style="width:100%">휴대전화 문자메세지로 전송된 인증번호 6자리를</br>입력하신 후 확인 버튼을 눌러주세요.
        		<div style="padding:10px 0;">
		            <ul>
		                <li>
		                	<span class="insert_guide">인증번호</span>
		                	<input type="text" id="certify_key" maxLength="6">
		                	<button type="button" class="btn_mobile_certify_resend" id="btn_mobile_resend">재전송</button>
		                </li>
		                <li>
		                	<div style="padding:10px 0;">
		                		( 남은시간 <span id="certify_timer" style="color:red;">3분 00초</span> )
		                		<button type="button" class="btn_mobile_certify_timer_reset" onClick="javascript:stopCountDown();fnCountDown();">시간연장</button>
		                	</div>
		                </li>
		                <li>
		                	<div style="padding:10px 0;">
		                		<button type="button" class="btn_mobile_certify_confirm" id="btn_mobile_confirm">확인</button>
		                	</div>
		                </li>
		            </ul>
				</div>
			</div>
            <div class="mobile_certify_info" id="div_mobile_check_fail" style="width:100%;display:none;">인증시간 만료되었습니다. 다시 시도해주세요.
            	<div style="padding:30px 0 0 0;">
            		<button type="button" class="btn_mobile_certify_close" id="btn_mobile_close">닫기</button>
            	</div>
            </div>
        </div>
    </div>
    <!---// popup 모바일 인증 --->

    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>