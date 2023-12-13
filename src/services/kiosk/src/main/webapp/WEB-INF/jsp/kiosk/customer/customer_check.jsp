<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_first_visit(){	
	$('#member_no').val(0);
	document.kioskForm.action="/kiosk/customerPurpose.do";
	document.kioskForm.submit();
}

function fn_show_confirm(v_secret_nm, v_member_nm, v_cd_cust){
	/* $('.popup02').show(); */
	$('#con_name').html(v_secret_nm);
	$('#member_nm').val(v_member_nm);
	$('#cd_cust').val(v_cd_cust);
	fn_confirm();
	
}

function fn_hide_confirm(){
	$('.popup02').hide();
	$('#con_name').html('');
	$('#member_nm').val('');
	$('#cd_cust').val('');
	$('#check_name').val('');
}
function fn_confirm(){
	var v_check_name = $("#check_name").val();
	var v_member_nm = $("#member_nm").val();
	document.kioskForm.action="/kiosk/customerPurpose.do";
	document.kioskForm.submit();
}
</script>
<input type="hidden" name="mobile" id="mobile" value="${customerVO.mobile}">
<input type="hidden" name="member_nm" id="member_nm" value="">
<input type="hidden" name="cd_cust" id="cd_cust" value="">
<style>
/* .table_scroll::-webkit-scrollbar{
display: none;
} */
</style>
<div id="wrap">
	<div id="content_wrap">
		<div class="content">
			<div class="comment_head" style="padding-top: 90px; margin-bottom: 20px;">
				일치하는 정보가 <em>${tot_cnt}건</em> 있습니다.<br>
				아래 명단에서 선택해 주세요.
			</div>
			<div class="table_wrap">
				<table class="tb_type01" style="border-bottom: none;">
					<caption>
						<h1 class="blind">고객명단 제목</h1>
					</caption>
					<colgroup>
						<col style="width:20%">
						<col style="width:40%">
						<col style="width:40%">
					</colgroup>
					<thead>
						<tr>
							<th style="border-bottom: none;">최근방문</th>
							<th style="border-bottom: none;">고객명</th>
							<th style="border-bottom: none;">고객유형</th>
						</tr>
					</thead>
				</table>
				<div class="table_scroll" style="overflow-y: auto">
					<table class="tb_type01">
						<caption>
							<h1 class="blind">고객명단 리스트</h1>
						</caption>
						<colgroup>
							<col style="width:20%">
							<col style="width:40%">
							<col style="width:40%">
						</colgroup>
						<tbody>
						<c:forEach var="result" items="${searchList}" varStatus="status">
							<tr  onclick="fn_show_confirm('${result.secret_nm}','${result.member_nm}','${result.cd_cust}')">
								<td>${result.recent_str_name}</td>
								<td><b>${result.member_nm}</b></td>
								<td><b>${result.customerGubun}</b></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div><!-- //content -->
		<div class="comment_btn_area" style='margin: 40px auto 0;'>
			<button type="button" class="btn_cancel floatL" onclick="document.location.href='/kiosk/customerSearch.do';">다시찾기</button>
			<button type="button" class="btn_confirm floatR" onclick="fn_first_visit();">처음방문</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	

<div class="popup02" style="display:none">
	<button type="button" class="btn_close_popup" onclick="fn_hide_confirm();">창닫기</button>
	<div class="inner cancel">
		<div class="popup_body"> 
			<!-- 첫번째 -->
			<div class="pop_txt2">
				<em><span id="con_name"></span> 고객님</em>
				확인을 위해 고객명 전체를<br>다시한 번 입력해주세요.<br><br>
				<input type="text" id="check_name" name="check_name" value="">
			</div>
			<!-- //첫번째 -->
			<!-- 두번째 -->
			<div class="pop_txt2" style="display:none">
				고객명이 일치하지 않습니다.
			</div>
			<!-- //두번째 -->
			
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01" onclick="fn_hide_confirm();">취소</button>
			<button type="button" class="btn_pop02" onclick="fn_confirm();">확인</button>
		</div>
	</div>
</div><!-- //popup01 -->