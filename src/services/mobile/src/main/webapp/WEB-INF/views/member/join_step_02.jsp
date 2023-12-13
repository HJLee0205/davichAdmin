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
	<t:putAttribute name="title">약관동의</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
		$(document).ready(function(){
		    $('#all_rule_agree').on('click',function (){
		       var checkObj = $("input[type='checkbox']");
		       if($('#all_rule_agree').is(':checked')) {
		           checkObj.prop("checked",true);
		       }else{
		           checkObj.prop("checked",false);
		       }
		    });

		    $('#btn_join_ok').on('click',function(){

		        if($('#rule01_agree').is(':checked') == false) {
		        	$(".agree_check_alert").text("쇼핑몰 이용약관에 동의해야 합니다.");
		        	$.blockUI({
		    			message:$('#popup_agress_alert')
		    			,css:{
		    				width:     '100%',
		    				height:    '200px',
		    				position:  'fixed',
		    				top:       '50px',
		    				left:      '0',
		    			}
		    			,onOverlayClick: $.unblockUI
		    		});
		            //Dmall.LayerUtil.alert("쇼핑몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }
		        if($('#rule02_agree').is(':checked') == false) {
		        	$(".agree_check_alert").text("개인정보 수집 및 이용 약관에 동의해야 합니다.");
		        	$.blockUI({
		    			message:$('#popup_agress_alert')
		    			,css:{
		    				width:     '100%',
		    				height:    '200px',
		    				position:  'fixed',
		    				top:       '50px',
		    				left:      '0',
		    			}
		    			,onOverlayClick: $.unblockUI
		    		});
		        	//Dmall.LayerUtil.alert("개인정보 수집 및 이용 약관에 동의해야 합니다.", "알림");
		            return;
                }
		        if($('#rule03_agree').is(':checked') == false) {
		        	$(".agree_check_alert").text("개인정보처리방침에 동의해야 합니다.");
		        	$.blockUI({
		    			message:$('#popup_agress_alert')
		    			,css:{
		    				width:     '100%',
		    				height:    '200px',
		    				position:  'fixed',
		    				top:       '50px',
		    				left:      '0',
		    			}
		    			,onOverlayClick: $.unblockUI
		    		});
		        	//Dmall.LayerUtil.alert("개인정보처리방침에 동의해야 합니다.", "알림");
                    return;
                }
                //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.
                $('#paramRule01Agree').val("Y");
                $('#paramRule02Agree').val("Y");
                $('#paramRule03Agree').val("Y");
                
		        var data = $('#form_id_join').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
		        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/member-insert-form', param);
		    });
		});
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
    <form:form id="form_id_join">
    <input type="hidden" name="mode" id="mode" value="j"/>
    <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/>
    <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
    <input type="hidden" name="memberNm" id="memberNm" value="${so.memberNm}"/>
    <input type="hidden" name="birth" id="birth" value="${so.birth}"/>
    <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}"/>
    <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/>
    <input type="hidden" name="memberGbCd" id="memberGbCd" value="${so.memberGbCd}"/>
    <input type="hidden" name="rule01Agree" id="paramRule01Agree" value=""/>
    <input type="hidden" name="rule02Agree" id="paramRule02Agree" value=""/>
    <input type="hidden" name="rule03Agree" id="paramRule03Agree" value=""/>
    
    </form:form>
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
			<li class="selected">
				<span class="icon_steps02"></span>
				<span class="title">약관동의</span>
			</li>
			<li>
				<span class="icon_steps03"></span>
				<span class="title">회원정보입력</span>
			</li>
			<li>
				<span class="icon_steps04"></span>
				<span class="title">가입완료</span>
			</li>
		</ul>
		<div class="join_detail_area">
			<div class="agree_check_all">
				<div class="checkbox">			
					<label>
						<input type="checkbox" name="all_rule_agree" id="all_rule_agree">
						<span></span>
					</label>					
					<label for="agree_all"><b>전체동의</b></label>
				</div>
			</div>
			<div class="agree_check_one">
				<ul class="agree_check_list">
					<li>
						<div class="checkbox">			
							<label>
								<input type="checkbox" name="rule01_agree" id="rule01_agree">
								<span></span>
							</label>					
							<label for="rules_agree01">쇼핑몰 이용약관 동의</label>
						</div>
						<button type="button" class="btn_view_rules">내용보기<span class="icon_agree_arrow"></span></button>
						<div class="rules_area">
							 ${term_03.data.content}
						</div>
					</li>
					<li>
						<div class="checkbox">			
							<label>
								<input type="checkbox" name="rule02_agree" id="rule02_agree">
								<span></span>
							</label>					
							<label for="rules_agree02">개인정보 수집 및 이용 동의</label>
						</div>						
						<button type="button" class="btn_view_rules">내용보기<span class="icon_agree_arrow"></span></button>
						<div class="rules_area">
							 ${term_05.data.content}
						</div>
					</li>
					<li>
						<div class="checkbox">			
							<label>
								<input type="checkbox" name="rule03_agree" id="rule03_agree">
								<span></span>
							</label>					
							<label for="rules_agree03">개인정보 취급방침 동의</label>
						</div>							
						<button type="button" class="btn_view_rules">내용보기<span class="icon_agree_arrow"></span></button>
						<div class="rules_area">
							${term_04.data.content}
						</div>
					</li>
					 <c:if test="${ term_07.data.useYn eq 'Y'}">
					<li>
						<div class="checkbox">			
							<label>
								<input type="checkbox" name="rule04_disagree" id="rule04_agree">
								<span></span>
							</label>					
							<label for="rules_agree04">개인정보 제 3자 제공 동의(선택)</label>
						</div>							
						<button type="button" class="btn_view_rules">내용보기<span class="icon_agree_arrow"></span></button>
						<div class="rules_area">
							${term_07.data.content}
						</div>
					</li>
					</c:if>
				 	<c:if test="${ term_08.data.useYn eq 'Y'}">
					<li>
						<div class="checkbox">			
							<label>
								<input type="checkbox" name="rule05_disagree" id="rule05_agree">
								<span></span>
							</label>					
							<label for="rules_agree05">개인정보 취급 위탁 동의(선택)</label>
						</div>							
						<button type="button" class="btn_view_rules">내용보기<span class="icon_agree_arrow"></span></button>
						<div class="rules_area">
							${term_08.data.content}
						</div>
					</li>
					</c:if>
				</ul>
				<button type="button" class="btn_go_nextsteps"  id="btn_join_ok">다음단계</button>
			</div>
		</div>		
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    
    <!--- 얼럿창 --->
<div id="popup_agress_alert" class="popup" style="height:200px">
	<div class="popup_head">
		<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
	</div>
	<div class="agree_check_alert">
		<!-- 개인정보 취급방침 약관에 동의해야 합니다. -->
		개인정보 수집 및 이용 약관에 동의해야 합니다.
		<!-- 쇼핑몰 이용약관에 동의해야 합니다. -->
	</div>
	<div class="popup_btn_area">
		<button type="button" class="btn_popup_ok closepopup">확인</button>
	</div>
</div>

<!---// 얼럿창 --->
    
    
	</t:putAttribute>
</t:insertDefinition>