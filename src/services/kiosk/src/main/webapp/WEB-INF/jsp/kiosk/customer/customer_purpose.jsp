<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%><script type="text/javascript">
function fn_confirm(){
	
	if($('#purpose_no').val() == '5' || $('#purpose_no').val() == '6'){
		document.kioskForm.action="/kiosk/customerFirstInfo.do";
	}else{
		document.kioskForm.action="/kiosk/customerPurposeEtc.do";
	}
	document.kioskForm.submit();
}

function fn_set_purpose(v_purpose, v_purpose_no){
	$('#purpose').val(v_purpose);
	$('#purpose_no').val(v_purpose_no);
	fn_confirm();
}
</script>
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="member_nm" id="member_nm" value="${customerVO.member_nm}">
<input type="hidden" name="cd_cust" id="cd_cust" value="${customerVO.cd_cust}">
<input type="hidden" name="purpose" id="purpose" value="">
<input type="hidden" name="purpose_no" id="purpose_no" value="">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head">
				다비치안경 첫 방문을 환영합니다.
			</div>
			<div class="comment_box">
				<p>고객님, 반갑습니다.</p>
				원하시는 제품 또는 서비스를 선택해 주세요.
			</div>

			<div class="select_btn_wrap">
				<button type="button" class="select_btn01" onclick="fn_set_purpose('안경', 1)">안경</button>
				<button type="button" class="select_btn01" onclick="fn_set_purpose('콘택트렌즈', 2)">콘택트렌즈</button>
				<button type="button" class="select_btn01" onclick="fn_set_purpose('선글라스', 3)">선글라스</button>
				<button type="button" class="select_btn01" onclick="fn_set_purpose('A/S안경테조정', 4)">A/S안경테조정</button>
				<button type="button" class="select_btn01" onclick="fn_set_purpose('제품수령', 5)">제품수령</button>
				<button type="button" class="select_btn01" onclick="fn_set_purpose('기타', 6)">기타</button>
			</div>

		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_confirm" onclick="fn_confirm();">다음<i></i></button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	