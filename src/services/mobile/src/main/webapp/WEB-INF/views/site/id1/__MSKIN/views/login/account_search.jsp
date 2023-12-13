<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">아이디/패스워드찾기</t:putAttribute>
    <t:putAttribute name="script">
        <script src="${_MOBILE_PATH}/front/js/member.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function(){
                Dmall.validate.set('form_id_accoutn_search');
                <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
                VarMobile.server = '${server}';


                // 아이디찾기
                $("#btn_search_confirm").click(function(){
                	
                	var memberTypeCd= $("input[name=memberTypeCd]:checked").val();

                    if(memberTypeCd == '01'){
                    	if($('#searchName').val() == ''){
                    		Dmall.LayerUtil.alert("이름을 입력해 주세요.", "확인");
                            return false;
                    	}
                    	if($('#searchMobile').val() == ''){
                    		Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
                            return false;
                    	}
                    	jQuery('#searchBizName').val('');
                    	jQuery('#searchBizNo').val('');
                    }else{
                    	if($('#searchBizName').val() == ''){
                    		Dmall.LayerUtil.alert("업체명을 입력해 주세요.", "확인");
                            return false;
                    	}
                    	if($('#searchBizNo').val() == ''){
                    		Dmall.LayerUtil.alert("사업자번호를 입력해 주세요.", "확인");
                            return false;
                    	}
                    	jQuery('#searchName').val('');
                    	jQuery('#searchMobile').val('');
                    }

                    if(Dmall.validate.isValid('form_id_accoutn_search')){
                        var url = '${_MOBILE_PATH}/front/login/account-detail';

                        param = {
                            mode : jQuery('#mode').val(),
                            searchName : jQuery('#searchName').val(),
                            searchMobile : jQuery('#searchMobile').val(),
                            searchBizName : jQuery('#searchBizName').val(),
                            searchBizNo : jQuery('#searchBizNo').val(),
                            memberTypeCd : memberTypeCd,
                            certifyMethodCd : 'MOBILE'
                        };

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        	if(result.length > 0) {
                        		var html = '';
                            	var loginId = '';
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
	                            		/* loginId = loginId.substring(0,loginId.length - 3);
	                            		loginId += '***'; */
                            		}
                            		html += loginId;
                            	}
                            	
	                            //$("#loginId").val(result.data.loginId);
	                            //$("#memberNo").val(result.data.memberNo);
	
	                            setDefault();
	                            
	                            $('#div_id_01').hide();
	                            $("#div_id_02").show();
	                            
	                            $('#result_id').html(html);
	                            $("#userNm").html(param.searchName==""?param.searchBizName:param.searchName);
                            }else{
                            	/* $('#div_id_01').hide();
                            	$("#div_id_02").show();
                            	$(".member_name").hide();
                                //$("#result_id").html('입력하신 내용과 일치하는<br>회원정보를 찾을 수 없습니다.');*/
                            	$(".no_member_search").show();
                            }
                        });
                    }
                });

                // 비밀번호찾기
                $("#btn_search_pass").click(function(){
                    if(Dmall.validate.isValid('form_id_accoutn_search')){
						var memberTypeCd= $("input[name=memberTypeCd]:checked").val();
						var searchMethod= $("input[name=searchMethod]:checked").val();
                        
                        if(memberTypeCd == '01'){
                        	if($('#searchLoginId').val() == ''){
                        		Dmall.LayerUtil.alert("아이디를 입력해 주세요.", "확인");
                                return false;
                        	}
                        	if(searchMethod == 'email'){
	                        	if($('#searchEmail').val() == ''){
	                        		Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}else{
	                        	if($('#searchMobile').val() == ''){
	                        		Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}
                        	if($('#searchName').val() == ''){
                        		Dmall.LayerUtil.alert("이름을 입력해 주세요.", "확인");
                                return false;
                        	}
                        	jQuery('#searchBizNo').val('');
                        }else{
                        	if($('#searchLoginId').val() == ''){
                        		Dmall.LayerUtil.alert("아이디를 입력해 주세요.", "확인");
                                return false;
                        	}
                        	if(searchMethod == 'email'){
	                        	if($('#searchEmail').val() == ''){
	                        		Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}else{
	                        	if($('#searchMobile').val() == ''){
	                        		Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}
                        	if($('#searchBizNo').val() == ''){
                        		Dmall.LayerUtil.alert("사업자번호를 입력해 주세요.", "확인");
                                return false;
                        	}
                        	jQuery('#searchName').val('');
                        }
                        
                        var searchMethod= $("input[name=searchMethod]:checked").val();
                        console.log("searchMethod="+searchMethod)

                        var url = '${_MOBILE_PATH}/front/login/account-detail';

                        param = {
                            mode : jQuery('#mode').val(),
                            searchName : jQuery('#searchName').val(),
                            searchLoginId : jQuery('#searchLoginId').val(),
                            searchMethod : searchMethod,
                            searchEmail : jQuery('#searchEmail').val(),
                            searchMobile : jQuery('#searchMobile').val(),
                            searchBizNo : jQuery('#searchBizNo').val(),
                            memberTypeCd : memberTypeCd,
                            certifyMethodCd : 'PASSWORD'
                        };

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        	if(result.length > 0) {
                                $(".no_member_search").hide();
                                $("#loginId").val(result[0].loginId);
                                $("#memberNo").val(result[0].memberNo);
                                $("#mobile").val(result[0].mobile);
                                $("#email").val(result[0].email);
                                $("#mobileNum").text(result[0].mobile);
                                $("#emailAddr").text(result[0].email);
                                setDefault();
                                //$("#div_id_03").show();
                                $("[id^=type_choice_]").show();

                                var url = '${_MOBILE_PATH}/front/login/send-email';
                                param = {
                               		searchMethod : searchMethod,
                               		email : jQuery('#searchEmail').val(),
                                    mobile : jQuery('#searchMobile').val(),
                                    memberNo : jQuery('#memberNo').val(),
                                    memberNm : jQuery('#searchName').val(),
                                    loginId : jQuery('#searchLoginId').val()
                                    
                                };

                                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                    if(result.success) {
                                        //Dmall.LayerUtil.alert("인증번호 발송 성공 하였습니다.", "알림");
                                        $("[id^=confirm_number]").show();
                                        var confirm_txt = "";
                                        if(searchMethod == 'email'){
                                       	 confirm_txt = "입력하신 이메일 계정으로 비밀번호 재설정을 위한 인증번호가 전송되었습니다.<br>인증번호를 확인하신 다음 아래란에 입력해 주세요."
                                        }else{
                                       	 confirm_txt = "입력하신 휴대폰 번호로 비밀번호 재설정을 위한 인증번호가 전송되었습니다.<br>인증번호를 확인하신 다음 아래란에 입력해 주세요.";
                                        }
                                        $('#confirm_txt').html(confirm_txt);
                                    }else{
                                        Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");
                                    }
                                });

                            }else{
                                $(".no_member_search").show();
                                //Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                                $('#searchName').val('');
                                $('#email01').val('');
                                $('#email02').val('');
                                $('#email03').val('etc');
                                $('#bizNo01').val('');
                                $('#bizNo02').val('');
                                $('#bizNo03').val('');
                            }
                        });
                    }
                });

                //인증수단 선택
                $(".btn_checking_go").click(function(){

                    var url = '${_MOBILE_PATH}/front/login/send-email';
                    param = {
                        email : jQuery('#email').val(),
                        memberNo : jQuery('#memberNo').val(),
                    };

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            //Dmall.LayerUtil.alert("인증번호 발송 성공 하였습니다.", "알림");
                            $("[id^=confirm_number]").show();
                        }else{
                            Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");
                        }
                    });

                });

                $("#number_confirm").click(function(){
                    var url = '${_MOBILE_PATH}/front/login/confirm-email';
                    param = {
                        memberNo : jQuery('#memberNo').val(),
                        emailCertifyValue : jQuery('#emailCertifyValue').val()
                    };
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data != null){
                                //Dmall.LayerUtil.alert("인증성공 하였습니다.\n 새로운 비밀번호를 설정하세요.", "알림");
                                $('#pw_login_form').hide();
                                $("[id^=type_choice_]").hide();
                                $("[id^=confirm_number]").hide();
                                $("#div_id_03").show();
                            }else{
                                Dmall.LayerUtil.alert("인증실패 하였습니다.", "알림");
                            }
                        }else{
                            var wrongText = '<p class="left_text"><em>인증번호가 일치하지 않습니다.</em> 인증번호 수신에 문제가 있는 경우 <b> 재전송요청 </b>버튼을 눌러 다시 시도해 주세요.</p>\n' +
                                '<button type="button" class="btn_tryagin" onclick="javascript: $(\'#btn_search_pass\').trigger(\'click\');">재전송요청</button>';
                            $('.wrong_no').html(wrongText);
                            //Dmall.LayerUtil.alert("인증실패 하였습니다.", "알림");
                        }
                    });
                });

                $("#btn_change_pw").click(function(){
                    if( $('#newPw').val() !=  $('#newPw_check').val()){
                        Dmall.LayerUtil.alert("비밀번호 입력/확인이 일치하지 않습니다.", "알림");
                        return;
                    }
                    if(passwordCheck($('#newPw').val())){
                        var url = '${_MOBILE_PATH}/front/login/update-password';
                        var param = $('#form_id_accoutn_search').serializeArray();
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                $("#div_id_01").hide();
                                $("#div_id_03").hide();
                                $("#div_id_04").show();
                            }else{
                                Dmall.LayerUtil.alert(result.message, "알림");
                            }
                        });
                    }
                });

                $("input[name=memberTypeCd]").click(function(){
                    var _val= $(this).val();
                    if(_val=='01'){
                        $('li[name=bizLi]').hide();
                        $("#searchName").val('');
                        $("#searchMobile").val('');

                        $("#email01").val('');
                        $("#email02").val('');
                        $("#email03").val('etc');

                        $('li[name=perLi]').show();
                    }else{
                        $("#searchBizName").val('');
                        $("#searchBizNo").val('');

                        $("#email01").val('');
                        $("#email02").val('');
                        $("#email03").val('etc');

                        $('li[name=bizLi]').show();
                        $('li[name=perLi]').hide();
                    }
                });
                
                $('input[name=searchMethod]').click(function(){
                	var _val= $(this).val();
                	
                	if(_val=='email'){
                		$('#email_li').show();
                		$('#mobile_li').hide();
                	}else{
                		$('#email_li').hide();
                		$('#mobile_li').show();
                	}
                });

                /* 이메일 선택 */
                var emailSelect = $('#email03');
                var emailTarget = $('#email02');
                emailSelect.bind('change', function() {
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

                Dmall.common.phoneNumber();
            });

            var VarMobile = {
                server:''
            };

            //# display default-setting(tab-click)
            function setMode(mode){
                $('#mode').val(mode);
                if(mode == 'id'){
                    move_page('id_search');
                }else{
                    move_page('pass_search');
                }
            }

            //#div default-setting(인정 bitton click)
            function setDefault(){
                $("#div_id_01").hide();
                $("#div_id_02").hide();
                $("#div_id_03").hide();
                $("#div_id_04").hide();
                $("#newPw").val('');
                $("#newPw_check").val('');
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
                window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
                document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
                document.reqIPINForm.target = "popupIPIN2";
                document.reqIPINForm.submit();
            }

            function successIdentity(){
                var url = '${_MOBILE_PATH}/front/login/account-detail';
                param = {memberDi : jQuery('#memberDi').val(),certifyMethodCd : jQuery('#certifyMethodCd').val()};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        if(result.data != null){
                            $("#loginId").val(result.data.loginId);
                            $("#memberNo").val(result.data.memberNo);
                            setDefault();
                            if( $("#mode").val()=="id" ){
                                $("#result_id").html("고객님의 아이디는 <b>["+result.data.loginId+"]</b>입니다.");
                                $("#div_id_02").show();
                            }else{
                                $("#div_id_03").show();
                            }
                        }else{
                            Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                        }
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <form:form id="form_id_accoutn_search">
    <input type="hidden" name="mode" id="mode" value="${mode}"/>
    <input type="hidden" name="certifyMethodCd" id="certifyMethodCd"/>
    <input type="hidden" name="memberDi" id="memberDi"/>
    <input type="hidden" name="memberNo" id="memberNo"/>
    <input type="hidden" name="loginId" id="loginId"/>
    <input type="hidden" name="name" id="name"/>
    <input type="hidden" name="mobile" id="mobile"/>
    <input type="hidden" name="email" id="email"/>
    <div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			로그인 정보 찾기
		</div>
		<div class="cont_body">
			<div class="id_pw_menu">
				<a href="javascript:setMode('id');" <c:if test="${mode == 'id'}" >class="active"</c:if> style="width:49%;">아이디 찾기</a>
				<a href="javascript:setMode('pass');" <c:if test="${mode == 'pass'}" >class="active"</c:if> style="width:49%;">비밀번호 찾기</a>
			</div>
	        <!-- 아이디 찾기 -->
	        <c:if test="${mode eq 'id'}">
		        <div id="div_id_01">
					<!-- 개인회원일경우 -->
					<ul class="login_form">
						<li>
							<div class="radio_area">
								<code:radio name="memberTypeCd" codeGrp="MEMBER_TYPE_CD"  idPrefix="memberTypeCd" classNm="member_join" value="01" exceptCd="03"/>
							</div>
						</li>
						<li name="perLi">
							<span>이름</span>
							<input type="text" id="searchName" name="searchName" style="width:69%;">
						</li>
						<li name="perLi">
							<span>휴대폰번호</span>
							<input type="text" id="searchMobile" name="searchMobile" class="phoneNumber" placeholder="- 생략" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}" maxlength="13" autocomplete="off" style="width:69%;">
						</li>
					<!--// 개인회원일경우 -->
					<!-- 사업자일경우 -->
						<li name="bizLi" style="display: none;">
							<span>업체명</span>
							<input type="text" id="searchBizName" name="searchBizName" style="width:69%;">
						</li>
						<li name="bizLi" style="display: none;">
							<span>사업자번호</span>
							<input type="text" id="searchBizNo" name="searchBizNo" class="phoneNumber" placeholder="- 생략" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}" maxlength="10" autocomplete="off" style="width:69%;">
		                </li>
					</ul>
					<!-- //사업자일경우 -->
					<div class="btn_member_area">
						<button type="button" class="btn_go_next" id="btn_search_confirm">확인</button>
					</div>
				</div>
				
				<!-- 아이디 찾기 결과 -->
				<div id="div_id_02" style="display:none;" class="id_fine_result btn_area">
					<p class="member_name"><em id="userNm"></em> 님의 다비치마켓 회원아이디는<br> 아래와 같습니다.</p>
	            	<p class="member_id" id ="result_id"></p>
					<div class="btn_area" id="no_result02" style="margin-top:15px;">
						<button type="button" class="btn_prev" onclick="move_page('main');">홈화면으로</button>
	                	<button type="button" class="btn_go_signup02" onclick="move_page('login');">로그인하기</button>
					</div>				
				</div>
				<!--// 아이디 찾기 결과 -->
				
				<!-- 회원정보 없는 경우 -->
	            <p class="no_member_search" style="display: none;">
	                입력하신 내용과 일치하는 회원정보를 찾을 수 없습니다.<br>
	                다시 한번 정확한 내용을 입력해 주세요.
	            </p>
	            <!--// 회원정보 없는 경우 -->
			</c:if>
			<!--// 아이디 찾기 -->
			
			<!--// 비밀번호 찾기 -->
        	<c:if test="${mode eq 'pass'}">
        		<div id="div_id_01">
					<!-- 개인회원일경우 -->
					<ul class="login_form">
						<li>
							<div class="radio_area">
                        		<input type="radio" name="searchMethod" id="searchMethod_1" checked="checked" value="email" class="member_join">
								<label for="searchMethod_1"><span></span>이메일</label>
								<input type="radio" name="searchMethod" id="searchMethod_2" value="mobile" class="member_join">
								<label for="searchMethod_2" class="marginL20"><span></span>휴대폰</label>
							</div>
		            	</li>
						<li>
							<div class="radio_area">
								<code:radio name="memberTypeCd" codeGrp="MEMBER_TYPE_CD"  idPrefix="memberTypeCd" classNm="member_join" value="01" exceptCd="03"/>
							</div>
						</li>
						<li>
							<span>아이디</span>
							<input type="text" id="searchLoginId" name="searchLoginId" style="width:69%;">
						</li>
						<li id="email_li">
							<span>이메일</span>
							<input type="text" id="searchEmail" name="searchEmail" style="width:69%;">
						</li>
						<li id="mobile_li" style="display:none;">
							<span>휴대폰번호</span>
							<input type="text" id="searchMobile" name="searchMobile" class="phoneNumber" placeholder="- 생략" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}" maxlength="13" autocomplete="off" style="width:69%;">
						</li>
						<li name="perLi">
							<span>이름</span>
							<input type="text" id="searchName" name="searchName" style="width:69%;">
						</li>
					<!--// 개인회원일경우 -->
					<!-- 사업자일경우 -->
						<li name="bizLi" style="display: none;">
							<span>사업자번호</span>
							<input type="text" id="searchBizNo" name="searchBizNo" class="phoneNumber" placeholder="- 생략" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}" maxlength="10" autocomplete="off" style="width:69%;">
		                </li>
					</ul>
					<!-- //사업자일경우 -->
					<div class="btn_member_area">
						<button type="button" class="btn_go_next" id="btn_search_pass">확인</button>
					</div>
					
					<!-- 회원정보 없는 경우 -->
		            <p class="no_member_search" style="display: none;">
		                입력하신 내용과 일치하는 회원정보를 찾을 수 없습니다.<br>
		                다시 한번 정확한 내용을 입력해 주세요.
		            </p>
		            <!--// 회원정보 없는 경우 -->
            
				</div>
		        <!--// 비밀번호찾기 -->
		
		        <!-- 이메일 인증 절차 -->
		        <div class="guide_email_pw" id="confirm_number_01" style="display:none;">
		            <p class="text" id="confirm_txt"></p>
		            <input type="text" id="emailCertifyValue" name="emailCertifyValue" placeholder="인증번호 입력" class="form_email_no">
		            <button type="button" class="btn_no_checking" id="number_confirm">인증번호확인</button>
		            <div class="wrong_no"></div>
		        </div>
		        <!--// 이메일 인증 절차 -->
	        </c:if>
	        <!-- 새 비밀번호 설정 -->
	        <div class="new_pw_area" id="div_id_03"  style="display: none;margin-top:40px;">
	            <h3 class="member_sub_tit">"새로운 비밀번호를 설정해 주세요."</h3>
	            <ul class="form_newpw">
	                <li><label for="">새비밀번호</label><input type="password" id="newPw" name="newPw" maxlength="16" placeholder="영문,숫자,특수문자 8~16자"></li>
	                <li><label for="">새비밀번호 확인</label><input type="password" id="newPw_check" name="newPw_check" maxlength="16" onkeydown="if(event.keyCode == 13){$('#btn_change_pw').click();}" placeholder="비밀번호 재입력"></li>
	                <li class="btn_area"><button type="button" id="btn_change_pw" class="btn_ok">확인</button></li>
	            </ul>
	        </div>
	        <!--// 새 비밀번호 설정 -->
	
	        <!-- 결과화면 -->
	        <div class="view_new_pw" id="div_id_04" style="display: none;">
	            <p class="completed">변경완료</p>
	            <p class="text">새로운 비밀번호로 변경 완료 되었습니다.<br> 지금 바로 새로운 비밀번호로 서비스에 로그인 하실 수 있습니다.</p>
	            <div class="btn_member_area">
	                <button type="button" class="btn_go_home" onclick="move_page('main');">홈화면으로</button>
	                <button type="button" class="btn_go_login" onclick="move_page('login');">로그인하기</button>
	            </div>
	        </div>
	        <!--// 결과화면 -->
    	</form:form>
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
    </t:putAttribute>
</t:insertDefinition>