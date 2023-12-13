<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_confirm(){	
	document.kioskForm.action="/kiosk/customerPurpose.do";
	document.kioskForm.submit();
}
</script>
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head">
				일치하는 정보가 없습니다.
			</div>
			<div class="comment_box customer_bg02">
				<p>처음 방문하셨나요?</p>
			</div>
		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_cancel floatL" onclick="document.location.href='/kiosk/customerSearch.do'">다시찾기</button>
			<button type="button" class="btn_confirm floatR" onclick="fn_confirm();">예</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->