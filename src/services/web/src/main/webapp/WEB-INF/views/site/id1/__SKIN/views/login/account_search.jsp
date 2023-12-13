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
    <t:putAttribute name="title">다비치마켓 :: 아이디/패스워드찾기</t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/member.js" type="text/javascript" charset="utf-8"></script>
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
                    	if($('#mobile01').val() == '' || $('#mobile02').val() == '' || $('#mobile03').val() == ''){
                    		Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
                            return false;
                    	}else{
                    		jQuery('#searchMobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());		
                    	}
                    	jQuery('#searchBizName').val('');
                    	jQuery('#searchBizNo').val('');
                    }else{
                    	if($('#searchBizName').val() == ''){
                    		Dmall.LayerUtil.alert("업체명을 입력해 주세요.", "확인");
                            return false;
                    	}
                    	if($('#bizNo01').val() == '' || $('#bizNo02').val() == '' || $('#bizNo03').val() == ''){
                    		Dmall.LayerUtil.alert("사업자번호를 입력해 주세요.", "확인");
                            return false;
                    	}else{
                    		jQuery('#searchBizNo').val($('#bizNo01').val()+$('#bizNo02').val()+$('#bizNo03').val());		
                    	}
                    	jQuery('#searchName').val('');
                    	jQuery('#searchMobile').val('');
                    }

                    if(Dmall.validate.isValid('form_id_accoutn_search')){
                        var url = '/front/login/account-detail';

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
                            	$('#result_id').html(html);
                            	$("#userNm").html(param.searchName==""?param.searchBizName:param.searchName);
                            	
                            	//$("#loginId").val(result.data.loginId);
                                //$("#memberNo").val(result.data.memberNo);
                                    
                                $('[id^=id_login_form]').hide();
                                $(".no_member_search").hide();
                                $("#div_id_02").show();
                                $('html, body').animate({ scrollTop: $('#div_id_02').offset().top }, 'slow');

							}else{
                                //$("[id^=div_id_02]").hide();
                                //$('[id^=id_login_form]').hide();
                                //Dmall.LayerUtil.alert("등록된 정보가 없습니다.", "알림");
                                $(".no_member_search").show();
                                $('#searchName').val('');
                                $('#searchBizName').val('');
                                $('#mobile01').val('');
                                $('#mobile02').val('');
                                $('#mobile03').val('');
                                $('#bizNo01').val('');
                                $('#bizNo02').val('');
                                $('#bizNo03').val('');
                                //$('html, body').animate({ scrollTop: $('.no_member_search').offset().top }, 'slow');

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
	                        	if($('#email01').val() == '' || $('#email02').val() == ''){
	                        		Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}else{
	                        	if($('#mobile01').val() == '' || $('#mobile02').val() == '' || $('#mobile03').val() == ''){
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
	                        	if($('#email01').val() == '' || $('#email02').val() == ''){
	                        		Dmall.LayerUtil.alert("이메일을 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}else{
	                        	if($('#mobile01').val() == '' || $('#mobile02').val() == '' || $('#mobile03').val() == ''){
	                        		Dmall.LayerUtil.alert("휴대전화번호를 입력해 주세요.", "확인");
	                                return false;
	                        	}
                        	}
                        	if($('#bizNo01').val() == '' || $('#bizNo02').val() == '' || $('#bizNo03').val() == ''){
                        		Dmall.LayerUtil.alert("사업자번호를 입력해 주세요.", "확인");
                                return false;
                        	}else{
                        		jQuery('#searchBizNo').val($('#bizNo01').val()+$('#bizNo02').val()+$('#bizNo03').val());
                        	}
                        	jQuery('#searchName').val('');
                        }

                        jQuery('#searchEmail').val($('#email01').val()+"@"+$('#email02').val());
                        jQuery('#searchMobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());

                        var searchMethod= $("input[name=searchMethod]:checked").val();

                        var url = '/front/login/account-detail';

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
                                 //setDefault();
                                 //$("#div_id_03").show();
                                 $("[id^=type_choice_]").show();

                                 var url = '/front/login/send-email';
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
                                         $('html, body').animate({ scrollTop: $('[id^=confirm_number]').offset().top }, 'slow');
                                     }else{
                                         Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");
                                     }
                                 });

                             }else{
                                 $(".no_member_search").show();
                                 //$('html, body').animate({ scrollTop: $('.no_member_search').offset().top }, 'slow');
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

                    var url = '/front/login/send-email';
                    param = {
                        email : jQuery('#email').val(),
                        memberNo : jQuery('#memberNo').val(),
                    };

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            //Dmall.LayerUtil.alert("인증번호 발송 성공 하였습니다.", "알림");
                            $("[id^=confirm_number]").show();
                            $('html, body').animate({ scrollTop: $('[id^=confirm_number]').offset().top }, 'slow');
                        }else{
                            Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");
                        }
                    });

                });

                $("#number_confirm").click(function(){
                    var url = '/front/login/confirm-email';
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
                                $('html, body').animate({ scrollTop: $('#div_id_03').offset().top }, 'slow');
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
                        var url = '/front/login/update-password';
                        var param = $('#form_id_accoutn_search').serializeArray();
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                $("#div_id_01").hide();
                                $("#div_id_03").hide();
                                $("#div_id_04").show();
                                $('html, body').animate({ scrollTop: $('#div_id_04').offset().top }, 'slow');
                            }else{
                                Dmall.LayerUtil.alert(result.message, "알림");
                            }
                        });
                    }
                });

                $("input[name=memberTypeCd]").click(function(){
                    var _val= $(this).val();
                    
                    $("#searchName").val('');
                    $("#searchMobile").val('');
                    $("#mobile01").val('');
                    $("#mobile02").val('');
                    $("#mobile03").val('');
                    
                    $("#searchBizName").val('');
                    $("#searchBizNo").val('');
                    $("#bizNo01").val('');
                    $("#bizNo02").val('');
                    $("#bizNo03").val('');
                    
                    $("#email01").val('');
                    $("#email02").val('');
                    $("#email03").val('etc');
                    
                    if(_val=='01'){
                        $('li[name=bizLi]').hide();
                        $('li[name=perLi]').show();
                    }else{
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

            // 다시찾기
            function retry_search(){
            	
            }
            
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
                var url = '/front/login/account-detail';
                param = {memberDi : jQuery('#memberDi').val(),certifyMethodCd : jQuery('#certifyMethodCd').val()};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        if(result.data != null){
                            $("#loginId").val(result.data.loginId);
                            $("#memberNo").val(result.data.memberNo);
                            //setDefault();
                            if( $("#mode").val()=="id" ){
                                $("#result_id").html("고객님의 아이디는 <b>["+result.data.loginId+"]</b>입니다.");
                                $("#div_id_02").show();
                                $('html, body').animate({ scrollTop: $('#div_id_02').offset().top }, 'slow');
                            }else{
                                $("#div_id_03").show();
                                $('html, body').animate({ scrollTop: $('#div_id_03').offset().top }, 'slow');
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
    <div id="member_container">
        <ul class="tabs_member id_search">
            <li <c:if test="${mode == 'id'}" >class="active"</c:if> rel="tab_login01" onclick="setMode('id');">아이디찾기</li>
            <li <c:if test="${mode == 'pass'}" >class="active"</c:if> rel="tab_login02" onclick="setMode('pass');">비밀번호찾기</li>
        </ul>
        <c:if test="${mode eq 'id'}">
        <!-- tab01 아이디찾기 -->
        <div class="tabs_member_content" id="div_id_01">

            <ul class="form_idsearch" id="id_login_form">
                <li>
                    <div class="radio_area">
                        <code:radio name="memberTypeCd" codeGrp="MEMBER_TYPE_CD"  idPrefix="memberTypeCd" classNm="member_join" value="01" exceptCd="03"/>
                    </div>
                </li>
                <!-- form: 개인회원 -->
                <li name="perLi">
                    <label for="">이름</label>
                    <input type="text" id="searchName" name="searchName">
                </li>
                <li name="perLi">
                    <label for="">휴대전화번호</label>
                    <input type="hidden" id="searchMobile" name="searchMobile">
                    <select class="phone" id="mobile01">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" includeTotal="true" mode="S"/>
                    </select>
                    <span class="bar"></span>
                    <input type="number" id="mobile02" class="phone" maxlength="4">
                    <span class="bar">-</span>
                    <input type="number" id="mobile03" class="phone" maxlength="4" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}">
                </li>
                <!--// form: 개인회원 -->
                <!-- form: 사업자회원 -->
                <li name="bizLi" style="display: none;">
                    <label for="">업체명</label>
                    <input type="text" id="searchBizName" name="searchBizName">
                </li>
                <li name="bizLi" style="display: none;">
                    <input type="hidden" id="searchBizNo" name="searchBizNo">
                    <label for="">사업자번호</label>
                    <input type="text" id="bizNo01" name="bizNo01" class="busi" maxlength="3">
                    <span class="bar02">-</span>
                    <input type="text" id="bizNo02" name="bizNo02" class="busi" maxlength="2">
                    <span class="bar02">-</span>
                    <input type="text" id="bizNo03" name="bizNo03" class="busi" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}" maxlength="5">
                </li>
                <!--// form: 사업자회원 -->
                <li class="btn_area"><button type="button" class="btn_ok" id="btn_search_confirm">확인</button></li>
            </ul>
            
            <!-- 아이디 찾기 결과 없음 -->
            <!-- 회원정보 없는 경우 -->
            <p class="no_member_search" style="display: none;">
                입력하신 내용과 일치하는 회원정보를 찾을 수 없습니다.<br>
                다시 한번 정확한 내용을 입력해 주세요.
            </p>
            <!--// 회원정보 없는 경우 -->
            <!--// 아이디 찾기 결과 없음 -->

            <div class="guide_membership_left" id="id_login_form">
                <p>아직 다비치마켓의 회원이 아니신가요?<br>
                    온오프라인 통합멤버쉽, 맞춤서비스, 다비치포인트, 마켓포인트 등 다비치마켓의 풍성한 혜택을 모두 제공받으시려면!</p>
                <a href="/front/member/terms-apply"><button type="button" class="btn_go_sign">회원가입</button></a>
            </div>
            
            <!-- 결과화면 -->
	        <div class="view_idsearch" id="div_id_02" style="display: none;" >
	            <p class="member_name"><em id="userNm"></em> 님의 다비치마켓 회원아이디는 아래와 같습니다.</p>
	            <p class="member_id" id ="result_id"></p>
	            <div class="btn_member_area">
	                <button type="button" class="btn_go_home" onclick="move_page('main');">홈화면으로</button>
	                <button type="button" class="btn_go_login" onclick="move_page('login');">로그인하기</button>
	            </div>
	        </div>
        	<!--// 결과화면 -->

        </div>
        
        <!--// tab01 아이디찾기 -->
        </c:if>
        <c:if test="${mode eq 'pass'}">
        <!-- tab02 비밀번호찾기 -->
        <div class="tabs_member_content" id="div_id_01">
            <input type="hidden" name="authType" value="email">
            <!-- form: 개인회원 -->
            <ul class="form_pwsearch">
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
                	<label for="">아이디</label>
                	<input type="text" id="searchLoginId" name="searchLoginId">
                </li>
                <li id="email_li">
                    <label for="">이메일</label>
                    <input type="hidden" id="searchEmail" name="searchEmail">
                    <input type="text" class="email" id="email01">
                    <span class="bar">@</span>
                    <input type="text" id="email02" class="email" onkeydown="if(event.keyCode == 13){$('#btn_search_pass').click();}">
                    <span class="bar02"></span>
                    <select id="email03" class="email">
                        <option value="etc" selected="selected">직접입력</option>
                        <option value="naver.com">naver.com</option>
                        <option value="hanmail.net">hanmail.net</option>
                        <option value="daum.net">daum.net</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="nate.com">nate.com</option>
                        <!-- <option value="hotmail.com">hotmail.com</option>
                        <option value="yahoo.com">yahoo.com</option>
                        <option value="empas.com">empas.com</option>
                        <option value="korea.com">korea.com</option>
                        <option value="dreamwiz.com">dreamwiz.com</option> -->
                    </select>
                </li>
                <li id="mobile_li" style="display:none;">
                    <label for="">휴대전화번호</label>
                    <input type="hidden" id="searchMobile" name="searchMobile">
                    <select class="phone" id="mobile01">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" includeTotal="true" mode="S"/>
                    </select>
                    <span class="bar"></span>
                    <input type="number" id="mobile02" class="phone" maxlength="4">
                    <span class="bar">-</span>
                    <input type="number" id="mobile03" class="phone" maxlength="4" onkeydown="if(event.keyCode == 13){$('#btn_search_confirm').click();}">
                </li>
                <li name="perLi">
                    <label for="">이름</label>
                    <input type="text" id="searchName" name="searchName">
                </li>
                <li name="bizLi" style="display:none;">
                    <label for="">사업자번호</label>
                    <input type="hidden" id="searchBizNo" name="searchBizNo">
                    <input type="text" id="bizNo01" name="bizNo01" class="busi" maxlength="3">
                    <span class="bar02">-</span>
                    <input type="text" id="bizNo02" name="bizNo02" class="busi" maxlength="2">
                    <span class="bar02">-</span>
                    <input type="text" id="bizNo03" name="bizNo03" class="busi" onkeydown="if(event.keyCode == 13){$('#btn_search_pass').click();}" maxlength="5">
                </li>

                <li class="btn_area"><button type="button" class="btn_ok" id="btn_search_pass">확인</button></li>
            </ul>
            <!--// form: 개인회원 -->
            <!-- 회원정보 없는 경우 -->
            <p class="no_member_search" style="display: none;">
                입력하신 내용과 일치하는 회원정보를 찾을 수 없습니다.<br>
                다시 한번 정확한 내용을 입력해 주세요.
            </p>
            <!--// 회원정보 없는 경우 -->
            
            <!-- 이메일 인증 절차 -->
	        <div class="guide_email_pw" id="confirm_number_01" style="display:none;">
	            <p class="text" id="confirm_txt"></p>
	            <input type="text" id="emailCertifyValue" name="emailCertifyValue" placeholder="인증번호 입력" class="form_email_no">
	            <button type="button" class="btn_no_checking" id="number_confirm">인증번호확인</button>
	            <div class="wrong_no"></div>
	        </div>
	        <!--// 이메일 인증 절차 -->
        
        </div>
        <!--// tab02 비밀번호찾기 -->

        </c:if>
        <!-- 새 비밀번호 설정 -->
        <div class="new_pw_area" id="div_id_03"  style="display: none;">
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
	</div>
    </t:putAttribute>
</t:insertDefinition>