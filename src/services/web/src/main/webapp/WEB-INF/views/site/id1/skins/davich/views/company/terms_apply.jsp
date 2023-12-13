<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">다비치마켓 :: 이용약관 동의</t:putAttribute>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	<c:if test="${param.keyData ne null and param.keyData ne ''}">
		var url = '/front/terms-apply-signinfo';
		var param = $('#form_id_join').serializeArray();
		Dmall.AjaxUtil.getJSON(url, param, function(result) {
			 if(result.signImg != null ) {
			 	var affHtml = '';
				 affHtml += '<img src="data:image/png;base64,'+result.signImg+'" alt="싸인" onerror="this.src=\'/front/img/common/no_image.png\'">';
				 $('#signImg').html(affHtml);
				 $('#signImg').show();

			 }
		 });
		</c:if>
        $('.btn_view_agree01').click(function () {
				$('.layer_agree_view.view01').show();
			});
			$('.btn_view_agree02').click(function () {
				$('.layer_agree_view.view02').show();
			});
			$('.btn_view_agree03').click(function () {
				$('.layer_agree_view.view03').show();
			});
			$('.btn_view_agree04').click(function () {
				$('.layer_agree_view.view04').show();
			});
			$('.btn_view_agree05').click(function () {
				$('.layer_agree_view.view05').show();
			});
		    $('.btn_close_agree').click(function () {
				$('.layer_agree_view').hide();
			});

        $('#all_rule_agree').bind('click',function (){
           var checkObj = $("input[type='checkbox']");
           if($('#all_rule_agree').is(':checked')) {
               checkObj.prop("checked",true);
           }else{
               checkObj.prop("checked",false);
           }
        });

        $('.btn_go_next').on('click',function(){
                if($('#sms_get').is(":checked") == true){
					$('#smsRecvYn').val('Y');
					$('#emailRecvYn').val('Y');
                }else{
                    $('#smsRecvYn').val('N');
                    $('#emailRecvYn').val('N');
                }

                if($('#keyData').val() == '') {
		            Dmall.LayerUtil.alert("약관동의 인증키 값이 유효하지 않습니다.", "알림");
		            return;
		        }

                if($('#agree_check01').is(':checked') == false) {
		            Dmall.LayerUtil.alert("개인 정보 처리방침에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#agree_check02').is(':checked') == false) {
		            Dmall.LayerUtil.alert("위치 정보 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#agree_check03').is(':checked') == false) {
		            Dmall.LayerUtil.alert("청소년 보호정책에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#agree_check04').is(':checked') == false) {
		            Dmall.LayerUtil.alert("멤버쉽 회원 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }

                if($('#agree_check05').is(':checked') == false) {
		            Dmall.LayerUtil.alert("온라인 몰 이용약관에 동의해야 합니다.", "알림");
		            return;
		        }
                $('#paramRule04Agree').val("Y");
                $('#paramRule22Agree').val("Y");
                $('#paramRule21Agree').val("Y");
                $('#paramRule09Agree').val("Y");
                $('#paramRule10Agree').val("Y");

		        var param = $('#form_id_join').serializeArray();
                var url = '/front/member-terms-apply';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Dmall.LayerUtil.alert(result.message);
                         //window.close();
						 window.open('about:blank', '_self').close();
                     }
                 });

                //Dmall.FormUtil.submit('/front/member/member-terms-apply', param);
		        //Dmall.FormUtil.submit('/front/member/member-insert-form', param);
		    });
    })
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
         <!--- contents --->
		<div class="alrim_talk">
			<form:form id="form_id_join">
				<input type="hidden" name="keyData" id="keyData" value="${param.keyData}"/>
				<input type="hidden" name="memberCardNo" id="memberCardNo" value="${param.memberCardNo}"/>
				<input type="hidden" name="rule04Agree" id="paramRule04Agree" value=""/>
				<input type="hidden" name="rule22Agree" id="paramRule22Agree" value=""/>
				<input type="hidden" name="rule21Agree" id="paramRule21Agree" value=""/>
				<input type="hidden" name="rule09Agree" id="paramRule09Agree" value=""/>
				<input type="hidden" name="rule10Agree" id="paramRule10Agree" value=""/>
				<input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
	        	<input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
			</form:form>
		<h1>고객님 환영합니다!</h1>
		<div class="text">
			<p>본 약관은 다비치안경체인 서비스의 이용과 <br>
			관련하여 필요한 사항을 규정합니다. </p>

			귀하께서는 개인정보 수집 이용에 대한 <br>
			동의를 거부하실 수 있으나, <br>
			동의를 거부하실 경우 회원가입, 서비스 이용 등을
			하실 수 없습니다.
	    </div>
		<c:if test="${applyCnt<1}">
		<div class="alrim_talk_all">
			<input type="checkbox" class="agree_check" name="all_rule_agree" id="all_rule_agree">
			<label for="all_rule_agree"><span></span>약관 전체동의</label>
		</div>
		</c:if>
		<div class="alrim_talk_check">
			<c:if test="${applyCnt<1}">
			<input type="checkbox" class="agree_check" name="rule04Agree" id="agree_check01" value="Y">
			</c:if>
			<label for="agree_check01"><span></span>개인정보 처리방침<c:if test="${applyCnt<1}">(필수)</c:if></label>
			<a href="#none" class="btn_view_agree01">내용보기</a>
		</div>
		<div class="alrim_talk_check">
			<c:if test="${applyCnt<1}">
			<input type="checkbox" class="agree_check" name="rule22Agree" id="agree_check02" value="Y">
			</c:if>
			<label for="agree_check02"><span></span>위치 정보 이용약관<c:if test="${applyCnt<1}">(필수)</c:if></label>
			<a href="#none" class="btn_view_agree02">내용보기</a>
		</div>
		<div class="alrim_talk_check">
			<c:if test="${applyCnt<1}">
			<input type="checkbox" class="agree_check" name="rule21Agree" id="agree_check03" value="Y">
			</c:if>
			<label for="agree_check03"><span></span>청소년보호정책<c:if test="${applyCnt<1}">(필수)</c:if></label>
			<a href="#none" class="btn_view_agree03">내용보기</a>
		</div>
		<div class="alrim_talk_check">
			<c:if test="${applyCnt<1}">
			<input type="checkbox" class="agree_check" name="rule09Agree" id="agree_check04" value="Y">
			</c:if>
			<label for="agree_check04"><span></span>멤버십 회원약관<c:if test="${applyCnt<1}">(필수)</c:if></label>
			<a href="#none" class="btn_view_agree04">내용보기</a>
		</div>
		<div class="alrim_talk_check">
			<c:if test="${applyCnt<1}">
			<input type="checkbox" class="agree_check" name="rule10Agree" id="agree_check05" value="Y">
			</c:if>
			<label for="agree_check05"><span></span>온라인몰 이용약관<c:if test="${applyCnt<1}">(필수)</c:if></label>
			<a href="#none" class="btn_view_agree05">내용보기</a>
		</div>
		<c:if test="${applyCnt<1}">
		<div class="alrim_talk_check" style="border-bottom:none">
			<input type="checkbox" id="sms_get" name="sms_get" class="agree_check">
			<label for="sms_get">
				<span></span>E-mail 및 SNS 광고성 정보 수신 동의<c:if test="${applyCnt<1}">(선택)</c:if>
				<p>다양한 프로모션 소식 및 신규 매장 정보를 보내드립니다.</p>
			</label>
		</div>
		</c:if>
		<c:if test="${applyCnt>0}">
		<div id="signImg" style="float:right;display:none;">
		<%--<img src="data:image/png;base64,${signImg.signImg}">--%>
		</div>
		</c:if>
		<c:if test="${applyCnt<1}">
		<button type="button" class="btn_talk_agree btn_go_next">동의하기</button>
		</c:if>
	</div>

	<!--- popup 개인정보 처리방침 --->
	<div class="layer_agree_view view01" style="display: none">
		<button type="button" class="btn_close_agree">창닫기</button>
		<div class="agree_content">
			${term_04.data.content}
		</div>
	</div>
	<!---// popup --->

	<!--- popup 위치 정보 이용약관 --->
	<div class="layer_agree_view view02" style="display: none">
		<button type="button" class="btn_close_agree">창닫기</button>
		<div class="agree_content">
			${term_22.data.content}
		</div>
	</div>
	<!---// popup --->

	<!--- popup 청소년보호정책 --->
	<div class="layer_agree_view view03" style="display: none">
		<button type="button" class="btn_close_agree">창닫기</button>
		<div class="agree_content">
			${term_21.data.content}
		</div>
	</div>
	<!---// popup --->

	<!--- popup 멤버십 회원약관 --->
	<div class="layer_agree_view view04" style="display: none">
		<button type="button" class="btn_close_agree">창닫기</button>
		<div class="agree_content">
			${term_09.data.content}
		</div>
	</div>
	<!---// popup --->

	<!--- popup 온라인몰 이용약관 --->
	<div class="layer_agree_view view05" style="display: none">
		<button type="button" class="btn_close_agree">창닫기</button>
		<div class="agree_content">
			${term_10.data.content}
		</div>
	</div>
    </t:putAttribute>
</t:insertDefinition>