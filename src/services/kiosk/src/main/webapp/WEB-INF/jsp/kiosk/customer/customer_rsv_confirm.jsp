<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_confirm(){	
	if($('#rsv_no').val() != ''){
		$.ajax({
			type : "POST",
			url : "/kiosk/customerStrBooking.do",    	
			data : {
				member_no 	: $('#member_no').val(),
				rsv_no 		: $('#rsv_no').val(),
				str_code 	: $('#store_no').val(),
				nm_cust 	: $('#member_nm').val(),
				handphone 	: $('#mobile').val(),
				flag 		: '1',
				purpose 	: $('#req_matr').val(),
				book_yn 	: 'Y',
				book_time 	: $('#rsv_time').val()
			},
			dataType : "xml",
			success : function(result) {
				$("row",result).each(function(){
					
				});
			},
			error : function(result, status, err) {
				alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+error);
			},
			beforeSend: function() {
			    
			},
			complete: function(){	
				document.location.href="/kiosk/customerSearch.do";
			}
		});
	}else{
		alert("예약정보가 없습니다.");	
	}
}
</script>
<input type="hidden" name="member_no" id="member_no" value="${customerVO.member_no}">
<input type="hidden" name="member_nm" id="member_nm" value="${customerVO.member_nm}">
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="rsv_no" id="rsv_no" value="${customerVO.rsv_no}">
<input type="hidden" name="req_matr" id="req_matr" value="${customerVO.visit_purpose_nm}">
<input type="hidden" name="rsv_time" id="rsv_time" value="${customerVO.rsv_time}">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head">
				예약정보가 확인되었습니다.
			</div>
			<div class="comment_box customer_bg03">
				<p><em>${customerVO.secret_nm}</em> 고객님, 반갑습니다.</p>
				<span class="commnet_txt1">
					예약순서에 따라<br>
					현황판을 통해 안내해 드리겠습니다.<br>
					잠시만 기다려 주세요.
				</span>
			</div>

		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_confirm" onclick="fn_confirm()">확인</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	