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
	<t:putAttribute name="title">다비치마켓 :: 휴대폰인증</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){

    	//모바일
        var _mobile = '${resultModel.data.mobile}';
        var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
        $('#mobile01').val(temp_mobile[0]);
        $('#mobile02').val(temp_mobile[1]);
        $('#mobile03').val(temp_mobile[2]);

      	//휴대전화인증
        $('.btn_mobile_check').on('click',function (){
        	//간편회원 체크
        	if($('#integrationMemberGbCd').val() == null || $('#integrationMemberGbCd').val() == '' || $('#integrationMemberGbCd').val() == '02'){
        		Dmall.LayerUtil.alert("간편회원은 정회원 전환을 진행해주세요.", "확인");
        		return false;
        	}
        	//인증완료 여부 체크
        	if($('#realnmCertifyYn').val() == 'Y'){
        		Dmall.LayerUtil.alert("이미 휴대폰 인증이 완료되었습니다.", "확인");
        		return false;
        	}
        	
        	if($('#mobile02').val() == '' || $('#mobile03').val() == ''){
        		Dmall.LayerUtil.alert("휴대전화를 입력해주세요.", "확인");
        		return false;
        	}
            var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
            var url = '${_MOBILE_PATH}/front/member/send-sms-certify';
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
				var certifyPoint = 500;
				var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
				var url = '${_MOBILE_PATH}/front/member/certify-update';
				var param = {
		            	mobile : mobile,
		            	realnmCertifyYn : 'Y',
		            	certifyPoint : certifyPoint
		            }
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                    	 Dmall.LayerUtil.confirm("휴대폰인증이 완료되었습니다.<br>적립된 마켓포인트는 마이페이지에서<br>확인 가능합니다.",
     							function() {
     								location.href= "${_MOBILE_PATH}/front/member/savedmoney-list";
     							},'','','','닫기','마이페이지'
     						);
                    	 Dmall.LayerPopupUtil.close('popup_mobile_check');
                     }
                })
			}else{
				Dmall.LayerUtil.alert("인증번호가 일치하지 않습니다.<br>다시 확인해주세요.", "알림");
			}
		});
		
        //휴대전화인증 재전송
		$('#btn_mobile_resend').click(function(){
			$('#certify_key').val('');
			var mobile = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();
            var url = '${_MOBILE_PATH}/front/member/send-sms-certify';
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
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
	<div class="mypage_middle">	
    	<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			휴대폰 인증
		</div>
		
		<form name="reqDRMOKForm" method="post">
	        <input type="hidden" name="req_info" value ="${mo.reqInfo}" />
	        <input type="hidden" name="rtn_url" value ="${mo.rtnUrl}" />
	        <input type="hidden" name="cpid" value = "${mo.cpid}" />
	        <input type="hidden" name="design" value="pc"/>
	    </form>
			
		<div class="cont_body">
           	<div class="check_my_information">
				<p class="tit">"${resultModel.data.memberNm} 님의 <em>휴대전화 번호</em>를 입력후 인증받기 버튼을 눌러주세요."</p>
				<form:form id="form_id_certify" commandName="so">
					<input type="hidden" id="integrationMemberGbCd" value="${resultModel.data.integrationMemberGbCd}"/><!-- 통합회원등급 -->
					<input type="hidden" id="realnmCertifyYn" value="${resultModel.data.realnmCertifyYn}"/><!-- 실명인증여부 -->

					<table class="tInsert">
						<caption>개인회원 정보입력 폼입니다.</caption>
						<colgroup>
							<col style="width:80px">
							<col style="">
						</colgroup>
						<tbody>
							<tr>
								<th>휴대전화</th>
								<td>
									<select id="mobile01" class="phone">
										<code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
									</select>
									<span class="bar">-</span>
									<input type="text" class="phone" id="mobile02" maxlength="4" onKeydown="return onlyNumDecimalInput(event);" >
									<span class="bar">-</span>
									<input type="text" class="phone" id="mobile03" maxlength="4" onKeydown="return onlyNumDecimalInput(event);" >
								</td>
							</tr>
						</tbody>
					</table>
				</form:form>
				<div class="btn_membership_area">
					<button type="button" class="btn_check_okay btn_mobile_check" id="btn_mobile_check">인증받기</button>
				</div>
			</div>	
		</div><!-- //cont_body -->
    </div>
    
    <!--- popup 모바일 인증 --->
    <div id="popup_mobile_check" style="display:none;">
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
		                	<input type="text" id="certify_key" maxLength="6" style="width:30%;">
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
    </t:putAttribute>
</t:insertDefinition>