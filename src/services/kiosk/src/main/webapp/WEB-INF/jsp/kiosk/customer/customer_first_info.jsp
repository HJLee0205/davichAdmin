<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_confirm(){
	var v_member_nm = trim($('#member_nm').val());
	if(v_member_nm == ""){
		alert("성함을 입력해 주십시오.");
		$('#member_nm').focus();
	}else{
		document.kioskForm.action="/kiosk/customerFirstConform.do";
		document.kioskForm.submit();
	}
}

function fn_back(){	
	document.kioskForm.action="/kiosk/customerPurposeEtc.do";
	document.kioskForm.submit();
}
</script>
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="purpose" id="purpose" value="${customerVO.purpose}">
<input type="hidden" name="purpose_no" id="purpose_no" value="${customerVO.purpose_no}">
<input type="hidden" name="purpose_etc" id="purpose_etc" value="${customerVO.purpose_etc}">
<input type="hidden" name="cd_cust" id="cd_cust" value="${customerVO.cd_cust}">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head">
				선택이 완료되었습니다.
			</div>
			<div class="comment_box">
				<div class="comment_check pdt-20">
					<i></i> ${customerVO.purpose}
				</div>
				<span class="pdt-20">
					대기명단 등록을 위해<br>고객정보를 입력해 주세요.
				</span>
	

				<ul class="customer_form">
				<li>
					<label for="">휴대폰</label>
					<c:set var="mobile_view" value="${fn:split(customerVO.mobile,'-')}"/>
					<input type="text" class="sell_form" id="mobile1" name="mobile1" style="width:125px;" maxlength="3" value="${mobile_view[0]}" readonly>
					<input type="password" class="sell_form" id="mobile2" name="mobile2" style="width:130px;" maxlength="4" value="${mobile_view[1]}" readonly>
					<input type="text" class="sell_form" id="mobile3" name="mobile3" style="width:140px;" maxlength="4" value="${mobile_view[2]}" readonly>
				</li>
				<li>
					<label for="">고객명</label>
					<input type="text" name="member_nm" id="member_nm" value="${customerVO.member_nm}">
					<input type="hidden" name="member_no" id="member_no" value="${customerVO.member_no}">
				</li>
			</ul>
			</div>

		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_cancel floatL" onclick="fn_back()"><i></i>이전</button>
			<button type="button" class="btn_confirm floatR" onclick="fn_confirm()">다음<i></i></button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->