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
	<t:putAttribute name="title">회원가입</t:putAttribute>
	<t:putAttribute name="script">

        <script>
            $(document).ready(function(){
                $(".tabs_member_content").hide();
                $(".tabs_member_content:first").show();

                // 개인회원 / 사업자회원 Tab..
                $("ul.tabs_member li").click(function () {

                    var tabIdx =$(this).index();
                    if(tabIdx == 0){

                        $("#memberTypeCd").val("01");
                        $("#member01 input").val('');
                        $("#member01 input").prop("disabled",false);
                        $("#member01 select").removeAttr("disabled")
                        $("#member01 button").prop("disabled",false);

                        $("#member02 input").val('');
                        $("#member02 input").prop("disabled",true);
                        $("#member02 select").prop("disabled",true);
                        $("#member02 button").prop("disabled",true);

                    }else if(tabIdx == 1){
                        $("#memberTypeCd").val("02");

                        $("#member02 input").val('');
                        $("#member02 input").prop("disabled",false);
                        $("#member02 select").removeAttr("disabled")
                        $("#member02 button").prop("disabled",false);

                        $("#member01 input").val('');
                        $("#member01 input").prop("disabled",true);
                        $("#member01 select").prop("disabled",true);
                        $("#member01 button").prop("disabled",true);
                    }else{
                        Dmall.LayerUtil.alert("개인회원/사업자회원 체크오류입니다.", "알림");
                        return false;
                    }
                    $('.member_warning').hide();
                    $('.member_alert').hide();
                    $("ul.tabs_member li").removeClass("active");
                    $(this).addClass("active");
                    $(".tabs_member_content").hide()
                    var activeTab = $(this).attr("rel");
                    $("#" + activeTab).fadeIn();


                });

                //인증 요청
                /*$(".btn_member_check").click(function(){

                    if(InputCheck()){
                        var url = '${_MOBILE_PATH}/front/member/send-email';
                        param = {
                            email : jQuery('#email').val(),
                            memberTypeCd :jQuery('input[name=memberTypeCd]').val(),
                            bizRegNo : jQuery('#searchBizNo').val()
                        };

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                $(".member_warning").hide();
                                $(".member_alert").show();
                                /!*Dmall.LayerUtil.alert("인증번호 발송 성공 하였습니다.", "알림");*!/

                            }else{
                                $(".member_alert").hide();
                                $(".member_warning").show();
                                /!*Dmall.LayerUtil.alert("인증번호 발송 실패 하였습니다.", "알림");*!/
                            }
                        });
                    }
                    return false;
                });*/

                //다음
                $(".btn_member_check").click(function(e){
                	e.preventDefault();
                    e.stopPropagation();
                    var url = '${_MOBILE_PATH}/front/member/member-insert-form';
                    var param = {
                        memberTypeCd :jQuery('input[name=memberTypeCd]').val()
                    };
                    Dmall.FormUtil.submit(url, param);
                });


                /* 이메일 선택 */
                var emailSelect = $('[name=email03]');
                var emailTarget = $('[name=email02]');
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


            });
            function InputCheck() {

                var tabIdx =$("#memberTypeCd").val();

                //사업자 회원

                if(tabIdx == '02'){

                    if (Dmall.validation.isEmpty($('#bizNo01').val()) || Dmall.validation.isEmpty($('#bizNo02').val()) || Dmall.validation.isEmpty($('#bizNo03').val())) {
                        Dmall.LayerUtil.alert("사업자번호를 입력해주세요.");
                        $('#bizNo01').focus();
                        return false;
                    }

                    jQuery('#searchBizNo').val($('#bizNo01').val()+$('#bizNo02').val()+$('#bizNo03').val());

                    if (jQuery('#searchBizNo').val().length<10){
                        Dmall.LayerUtil.alert("사업자 번호는 10자리 입니다.", "확인");
                        return false;
                    }
                }



                var email01 = $("#member"+tabIdx+" [name=email01]").val();
                var email02 = $("#member"+tabIdx+" [name=email02]").val();

                if (Dmall.validation.isEmpty(email01) || Dmall.validation.isEmpty(email02)) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.");
                    jQuery("#member"+tabIdx+" [name=email01]").focus();
                    return false;
                }
                $('#email').val(email01+"@"+email02);

                if (jQuery('#email').val().length>50){
                    Dmall.LayerUtil.alert("이메일 주소는 50자 이하 입니다.", "확인");
                    return false;
                }
              	//이메일 정규식 체크
                var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
                if (!regExp.test($('#email').val())){
                	Dmall.LayerUtil.alert("형식이 어긋난 이메일 주소입니다.", "확인");
                    return false
              	}

                return true;
            }

        </script>
	</t:putAttribute>
	<t:putAttribute name="content">
		<div id="middle_area">
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				가입안내
			</div>
			
	        <div class="cont_body">
	
				<h3 class="member_sub_tit marginT15">다비치마켓에 오신 것을 환영합니다.</h3>
				<div class="member_info">
					<p>
						<b>회원안내</b><br>
						다비치마켓(온라인쇼핑몰)과 다비치안경원과의 통합회원 가입으로
						전국 250여개의 다비치 안경원에 근무하는 전문 안경사 및 청력사를 통한
						안경, 안경렌즈, 콘텍트렌즈, 보청기의 차별화된 최상의 서비스를 
						경험하실 수 있습니다.<br><br>
						<b>서비스</b><br>
						  - 안경테, 안경렌즈, 콘텍트렌즈, 보청기 컨설팅<br>
						  - 방문예약 서비스<br>
						  - 쇼핑몰 구매상품 <b>DDS(다비치 다이렉트 서비스</b>, 매장 픽업) 서비스<br>
						  - 포인트 결제(온라인, 오프라인) 서비스<br>
						  - 추가할인 서비스<br>
						  - 각종 행사 안내 서비스<br>
						  <span class="tooltiptext">DDS(다비치 다이렉트 서비스)<br>온라인에서 주문하고 가까운 다비치 매장에서 수령<br>다비치안경의 전문적인 피팅 서비스<br>다비치안경 AI GO VCS를 통한 차별화된 비전 컨설팅 시스템</span>
					</p>
				</div>
				<%--<div class="member_info_bottom">
					다비치마켓은<br><em>이메일 계정</em>을 회원 아이디로 사용합니다.<br>
					보다 편리하고 안정된 서비스 이용을 위해<br><em>반드시 사용중인 이메일 계정으로 가입</em>해주세요.
				</div>--%>
	
	            <ul class="tabs_member">
	                <li class="active" rel="member01">개인회원</li>
	                <li rel="member02">사업자회원</li>
	            </ul>
	            <form:form id="form_id_insert_member">
	            <input type="hidden" name="email" id="email" value="">
	            <input type="hidden" name="memberTypeCd" id="memberTypeCd" value="01">
	            <!-- tab01 개인회원 --->
	            <div class="tabs_member_content" id="member01" style="display: block;">
	
	                <%--<div class="form_member_check">
	                    <span class="title">이메일</span><label for="">이메일</label>
	                    <input type="text" name="email01" value="">
	                    <span>@</span>
	                    <input type="text" name="email02" value="">
	                    <select name="email03" class="select_option" title="select option">
	                        <option value="etc" selected="selected">직접입력</option>
	                        <option value="naver.com">naver.com</option>
	                        <option value="hanmail.net">hanmail.net</option>
	                        <option value="daum.net">daum.net</option>
	                        <option value="gmail.com">gmail.com</option>
	                        <option value="nate.com">nate.com</option>
	                    </select>
	                </div>--%>
	
	                <div class="btn_member_area">
	                    <button type="text" class="btn_member_check">다음</button>
	                </div>
	
	                <p class="member_warning" style="display: none;">이미 가입되어 있는 이메일 계정입니다.</p><!-- 계정이 있을경우 -->
	                <p class="member_alert" style="display: none;">입력하신 계정으로 인증 메일이 전송되었습니다.<br>30분 이내에 이메일로 전송된 주소를 클릭하여 나머지 가입절차를 진행해 주세요.</p>
	            </div>
	            <!--// tab01 개인회원 --->
	
	            <!-- tab02 사업자회원 --->
	            <div class="tabs_member_content" id="member02">
	                <p class="member_business_info">사업자번호당 1개의 아이디만 등록 가능하며, 가입시 사업자등록증 사본 파일이 필요합니다. 미리 준비해 주세요.</p>
	                <%--<div class="form_member_check business">
	                    <span class="title">사업자번호</span><label for="">사업자번호</label>
	                    <input type="hidden" id="searchBizNo" name="searchBizNo">
	                    <input type="text" id="bizNo01" name="bizNo01" maxlength="3">
	                    <span>-</span>
	                    <input type="text" id="bizNo02" name="bizNo02" maxlength="2">
	                    <span>-</span>
	                    <input type="text" id="bizNo03" name="bizNo03" maxlength="5">
	                </div>--%>
	                <%--<div class="form_member_check business">
	                    <span class="title">이메일</span><label for="">이메일</label>
	                    <input type="text" name="email01" value="" style="width:calc(50% - 12px);">
	                    <span>@</span>
	                    <input type="text" name="email02" value="" style="width:calc(50% - 12px);">
	                    <select name="email03" class="select_option" title="select option">
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
	                </div>--%>
	                <div class="btn_member_area">
	                    <button type="text" class="btn_member_check">다음</button>
	                </div>
	
	                <p class="member_warning" style="display: none;">이미 가입되어 있는 사업자번호입니다.</p><!-- 계정이 있을경우 -->
	                <p class="member_alert" style="display: none;">입력하신 계정으로 인증 메일이 전송되었습니다.<br>30분 이내에 이메일로 전송된 주소를 클릭하여 나머지 가입절차를 진행해 주세요.</p>
	
	            </div>
	            <!--// tab02 사업자회원 --->
	            </form:form>
	
	        </div>
		</div>
	</t:putAttribute>
</t:insertDefinition>