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
    <t:putAttribute name="title">회원정보입력</t:putAttribute>
    <t:putAttribute name="script">
    <script src="${_MOBILE_PATH}/front/js/member.js" type="text/javascript" charset="utf-8"></script>
    <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
    <script>
        $(document).ready(function(){
            Dmall.validate.set('form_id_insert_member');
            // 우편번호
            jQuery('#btn_post').on('click', function(e) {
            	/* $.blockUI({ message:$('#popup_post')
        			,css:{
        				width:     '100%',
        				position:  'fixed',
        				top:       '50px',
        				left:      '0',
        			}
        			,onOverlayClick: $.unblockUI
        		}); */
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
                    emailTarget.attr('readonly'
                            , false);
                    emailTarget.val('').change();
                    emailTarget.focus();
                } else {
                    emailTarget.attr('readonly', true);
                    emailTarget.val('').change();
                }
            });

            $('#btn_id_check').on('click',function (){
                $("#id_check").val( $('#loginId').val());
                Dmall.LayerPopupUtil.open($('#popup_id_duplicate_check'));
                $('.btn_id_duplicate_check').click();
            })

            var check_id;
            $('.btn_id_duplicate_check').on('click',function (){
                var url = '${_MOBILE_PATH}/front/member/duplication-id-check';
                var loginId = $('#id_check').val();
                if(Dmall.validation.isEmpty($("#id_check").val())) {
                    $('#id_success_div').attr('style','display:none;')
                    Dmall.LayerUtil.alert("아이디를 입력해주세요.", "알림");
                    return false;
                }else{
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
            })

            //아이디 사용하기
            $('.btn_popup_login').on('click',function (){
                Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
                $('#loginId').val(check_id);
            })

            //회원가입
            $('.btn_go_nextsteps').on('click',function (){
                if(!Dmall.validate.isValid('form_id_insert_member')) {
                    return false;
                }
                if(Dmall.validation.isEmpty($("#memberNm").val())) {
                    Dmall.LayerUtil.alert("이름을 입력해주세요.", "알림");
                    return false;
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
                $('#memberGbCd').val($('input:radio[name=shipping]:checked').val()); //회원 국내/해외 여부
                if(customerInputCheck()){
                    if(passwordCheck(jQuery("#pw").val())){
		                var url = '${_MOBILE_PATH}/front/member/duplication-id-check';
		                var loginId = $('#id_check').val();
		                var param = {loginId : loginId}
		                Dmall.AjaxUtil.getJSON(url, param, function(result) {
		                    if(result.success) {
                               var data = $('#form_id_insert_member').serializeArray();
                               var param = {};
                               $(data).each(function(index,obj){
                                   param[obj.name] = obj.value;
                               });
                               Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/member-insert', param);
                           }
		                });
                    }
                }                
            })

            //취소하기
            $('.btn_join_cancel').on('click',function (){
                location.href = "${_MOBILE_PATH}/front/main-view";
            })
            
	        $('.radio_chack_a').on('click', function(){
				$('li#radio_con_a').show();
				$('li#radio_con_b').hide();
			})
			
			$('.radio_chack_b').on('click', function(){
				$('li#radio_con_b').show();
				$('li#radio_con_a').hide();
			})
        });

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
	<!--- 03.LAYOUT: MIDDLE AREA --->
	<div id="middle_area">
		<div class="cart_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			회원가입
		</div>	
		<ul class="join_steps">
			<li>
				<span class="icon_steps01"></span>
				<span class="title">본인인증</span>
			</li>
			<li>
				<span class="icon_steps02"></span>
				<span class="title">약관동의</span>
			</li>
			<li class="selected">
				<span class="icon_steps03"></span>
				<span class="title">회원정보입력</span>
			</li>
			<li>
				<span class="icon_steps04"></span>
				<span class="title">가입완료</span>
			</li>
		</ul>
		<div class="join_detail_area">
		<form:form id="form_id_insert_member">
	        
	        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/><!-- 국적구분코드 -->
	        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/><!-- 인증방법코드 -->
	        <input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
	        <input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
	        <input type="hidden" name="birth" id="birth" value="${so.birth}" />
	        <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}" />
	        <input type="hidden" name="tel" id="tel"/><!-- 전화번호 -->
	        <input type="hidden" name="mobile" id="mobile"/><!-- 모바일 -->
	        <input type="hidden" name="email" id="email"/><!-- email -->
	        <input type="hidden" name="realnmCertifyYn" id="realnmCertifyYn"/><!-- 실명인증여부 -->
	        <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
	        
	        <input type="hidden" name="frgMemberYn" id="frgMemberYn"/><!-- 해외회원여부 -->
	        <input type="hidden" name="memberGbCd" id="memberGbCd"/><!-- 해외회원여부 -->
			<h2 class="join_stit">
				<span>기본정보</span>
				<div class="join_form_info"><em>*</em>필수 입력사항입니다.</div>
			</h2>
			<ul class="join_form_list">
				<li class="form">
					<span class="title"><em>*</em>이름</span>
					<p class="detail">
						<input type="text" style="width:60px" id="memberNm" name="memberNm" value="${so.memberNm}" ${(so.memberNm ne null) and (so.memberNm ne "")?"readonly=\"readonly\"":""}>
					</p>
				</li>
				<li class="form">
					<span class="title"><em>*</em>아이디</span>
					<p class="detail">
						<input type="text" id="loginId" name="loginId"  maxlength="20" style="width:calc(100% - 120px)">
						 <button type="button" id="btn_id_check" class="btn_post">중복확인</button>
					</p>
				</li>
				<li class="form">
					<span class="title"><em>*</em>비밀번호</span>
					<p class="detail">
						<input type="password" id="pw" name="pw" maxlength="16" style="width:calc(100% - 12px)">
						<span id="passCheck"></span>
						<span class="password_info">* 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.</span>
					</p>
				</li>
				<li class="form">
					<span class="title"><em>*</em>비밀번호확인</span>
					<p class="detail">
						<input type="password" id="pw_check" name="pw_check" maxlength="16" style="width:calc(100% - 12px)">
					</p>
				</li>
				<li class="form">
					<span class="title"><em>*</em>거주지</span>
					<p class="detail">
						<input type="radio" id="shipping_internal" name="shipping" checked="checked" value="10">
                        <label for="shipping_internal" class="radio_chack_a" style="margin-right:15px">
                            <span></span>
                            국내
                        </label>
                        <input type="radio" id="shipping_oversea" name="shipping" value="20">
                        <label for="shipping_oversea" class="radio_chack_b" style="margin-right:15px" >
                            <span></span>
                            해외
                        </label>
					</p>
				</li>
				<!--국내 선택시 default-->
				<li class="form" id="radio_con_a" style="display:;">
					<span class="title">주소</span>
					<p class="detail_address">
						<input type="text" id="newPostNo" name="newPostNo" readonly="readonly" style="width:65px">
						<button type="button" id="btn_post" class="btn_post">우편번호 찾기</button><br>
						<label for="address_01" class="address_title">지번</label><input type="text" id="roadAddr" name="roadAddr" readonly="readonly" style="width:calc(100% - 64px)">
						<label for="address_02" class="address_title">도로명</label><input type="text" id="strtnbAddr" name="strtnbAddr" readonly="readonly" style="width:calc(100% - 64px)">
						<label for="address_03" class="address_title">상세</label><input type="text" id="dtlAddr" name="dtlAddr" style="width:calc(100% - 64px)">
					</p>
				</li>	
				 <!--//국내 선택시 default-->
				  <!--해외 선택시-->
				 <li class="form" id="radio_con_b" style="display:none;">
					<span class="title">주소</span>
					<p class="detail_address">
                        <span for="address_01" class="address_title">Country</span>
	                      <select id="frgAddrCountry" class="select_option" title="select option" style="width:calc(100% - 64px)">
	                          <code:optionUDV codeGrp="COUNTRY_CD" />
	                      </select>
                        <span for="address_02" class="address_title">Zip</span><input type="text" id="frgAddrZipCode" name="frgAddrZipCode" style="width:calc(100% - 64px)">
                        <span for="address_03" class="address_title">State</span><input type="text" id="frgAddrState" name="frgAddrState" style="width:calc(100% - 64px)">
                        <span for="address_04" class="address_title">City</span><input type="text" id="frgAddrCity" name="frgAddrCity" style="width:calc(100% - 64px)">
                        <span for="address_05" class="address_title">address1</span><input type="text" id="frgAddrDtl1" name="frgAddrDtl1" style="width:calc(100% - 64px)">
                        <span for="address_06" class="address_title">address2</span><input type="text" id="frgAddrDtl2" name="frgAddrDtl2" style="width:calc(100% - 64px)">
					</p>
				</li>	
				  <!--//해외 선택시-->
                
				<li class="form">
					<span class="title"><em>*</em>이메일</span>
					<p class="detail">
						<!-- <input type="text" id="email01" style="width:calc(100% - 12px)"> -->
						<input type="text" id="email01" style="width:80px;"> @ <input type="text" id="email02" style="width:90px;">
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
					</p>
				</li>				
				<li class="form">
					<span class="title"><em>*</em>이메일수신여부</span>
					<p class="detail">
						<input type="radio" id="email_get" name="email_get" checked="checked">
						<label for="email_check_yes" style="margin-right:15px">
							<span></span>
							수신동의
						</label>
						<input type="radio"  id="email_no" name="email_get">
						<label for="email_check_no">
							<span></span>
							수신거부
						</label>	
						<span class="email_check_info">* 동의하셔야 쇼핑몰에서 제공하는 이벤트 소식을 이메일로 받으실 수 있습니다.</span>
					</p>
				</li>
				<li class="form">
					<span class="title">전화번호</span>
					<p class="detail total">
						<!-- <select style="width:60px">
							<option>선택</option>
							<option>010</option>
						</select> -
						<input type="text" style="width:40px"> -
						<input type="text" style="width:40px"> -->
						 <select id="tel01" style="width:60px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                        </select>
                        -
                        <input type="text" id="tel02" style="width:40px" maxlength="4">
                        -
                        <input type="text" id="tel03" style="width:40px" maxlength="4">
					</p>
				</li>
				<li class="form">
					<span class="title"><em>*</em>휴대폰번호</span>
					<p class="detail total">
						<!-- <select style="width:60px">
							<option>선택</option>
							<option>010</option>
						</select> -
						<input type="text" style="width:40px"> -
						<input type="text" style="width:40px"> -->
						<select id="mobile01" style="width:60px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                        </select>
                        -
                        <input type="text" id="mobile02" style="width:40px" maxlength="4">
                        -
                        <input type="text" id="mobile03" style="width:40px" maxlength="4">
					</p>
				</li>
				<li class="form">
					<span class="title">SMS수신여부</span>
					<p class="detail">
						<input type="radio" id="sms_get" name="sms_get" checked="checked">
						<label for="sms_check_yes" style="margin-right:15px">
							<span></span>
							수신동의
						</label>
						<input type="radio" id="sms_no" name="sms_get">
						<label for="sms_check_no">
							<span></span>
							수신거부
						</label>	
						<span class="email_check_info">* 동의하셔야 쇼핑몰에서 제공하는 이벤트 소식을 SMS로 받으실 수 있습니다.</span>
					</p>
				</li>
				<li style="padding:15px 3%">	
					<button type="button" class="btn_go_nextsteps">확인</button>
				</li>
			</ul>
		 </form:form>
		</div>		
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
      <!--- popup 아이디 중복확인 --->
    <div id="popup_id_duplicate_check" style="width:100%;left:0px;display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">아이디 중복확인</h1>
            <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <div class="pw_search_info" style="width:100%">
                아이디는 영문, 숫자 가능하며 6~20자 이내로 입력해주세요.
            </div>
            <ul class="id_duplicate_check">
                <li>
                    <input type="text" id="id_check" maxlength="20">
                    <button type="button" class="btn_id_duplicate_check">중복확인</button>
                </li>
            </ul>
            <div>
                 <div class="id_duplicate_check_info" ></div>
                 <div class="textC" id="id_success_div" style="display: none;">
                     <button type="button" class="btn_popup_login" style="margin-top:22px">사용하기</button>
                 </div>
            </div>
        </div>
    </div>
    <!---// popup 아이디 중복확인 --->
    </t:putAttribute>
</t:insertDefinition>