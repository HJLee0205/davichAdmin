<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_confirm(){
	var cnt = 0;
	$("input:radio[name='book_list']").each(function(e){
		if($(this).is(":checked") == true) cnt++;
	});
	
	if(cnt > 0){
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
				book_time 	: $('#rsv_time').val(),
				cd_cust 	: $('#cd_cust').val()
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
		alert("예약정보를 선택해주세요.");	
	}
}

function fn_set_info(v_rsv_no, v_req_matr, v_rsv_time, v_member_no){
	$('.select_confirm').show();
	
	$('#rsv_no').val(v_rsv_no);
	$('#req_matr').val(v_req_matr);
	$('#rsv_time').val(v_rsv_time);
	$('#member_no').val(v_member_no);
}
</script>
<input type="hidden" name="member_no" id="member_no" value="${customerVO.member_no}">
<input type="hidden" name="member_nm" id="member_nm" value="${customerVO.member_nm}">
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="rsv_no" id="rsv_no" value="">
<input type="hidden" name="req_matr" id="req_matr" value="">
<input type="hidden" name="rsv_time" id="rsv_time" value="">
<input type="hidden" name="cd_cust" id="cd_cust" value="${customerVO.cd_cust}">
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head" style="margin-bottom: 10px;">
				예약정보가 확인되었습니다.
			</div>
			<div class="comment_box">
				<p><em>${customerVO.member_nm}</em> 고객님, 반갑습니다.</p>
				<span>
					오늘 예약내용 중 원하시는 서비스를 선택해 주세요.
				</span>
			</div>
			<div class="table_scroll2" style="height: 210px;">
				<ul class="book_list">
				<c:forEach var="result" items="${visitList}" varStatus="status">
					<li>
						<input type="radio" id="book${status.count}" name="book_list" value="${result.rsv_no}" class="book_radio" onclick="fn_set_info(${result.rsv_no}, '${result.visit_purpose_nm}', '${result.rsv_time}', '${result.member_no}')"><label for="book${status.count}"><span></span>${fn:substring(result.visit_purpose_nm,0,20)}</label>
						<div class="book_time">${fn:substring(result.rsv_time,0,2)}:${fn:substring(result.rsv_time,2,4)}</div>
					</li>
				</c:forEach>				
				</ul>
			</div>
		</div><!-- //content -->
		<div class="select_confirm" style="display:none">
			<div class="comment_bottom">
				예약순서에 따라 현황판을 통해 안내해 드리겠습니다.<br>잠시만 기다려 주세요.
			</div>
			<div class="comment_btn_area" style="0  auto 0">
				<button type="button" class="btn_confirm" onclick="fn_confirm()">확인</button>
			</div><!-- ///comment_btn_area -->
		</div>
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	