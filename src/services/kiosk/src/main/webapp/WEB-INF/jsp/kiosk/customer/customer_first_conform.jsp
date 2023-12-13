<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head">
				접수가 완료되었습니다.
			</div>
			<div class="comment_box customer_bg03">
				<p><em>${customerVO.member_nm}</em> 고객님</p>
				<span class="commnet_txt1">
					접수순서에 따라<br>
					<em>현황판을 통해 안내</em>해 드리겠습니다.<br>
					잠시만 기다려 주세요.
				</span>
			</div>

		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_confirm" onclick="document.location.href='/kiosk/customerSearch.do'">확인</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	