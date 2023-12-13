<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_banner(){
	document.kioskForm.action="/kiosk/bannerList.do";
	document.kioskForm.submit();
}
function fn_message(){
	document.kioskForm.action="/kiosk/messageList.do";
	document.kioskForm.submit();
}

function fn_call_time(){
	document.kioskForm.action="/kiosk/callTime.do";
	document.kioskForm.submit();
}

function fn_call_time_save(){
	
	var v_auto_clear = "";
	var v_call_time = $("#call_time").val();
	
	$("input:radio[name='auto_clear']").each(function(e){
		if($(this).is(":checked") == true) v_auto_clear = $(this).val();
	});
	
	if(v_call_time == '') v_call_time = "0";
	
	if(v_auto_clear == 'Y'){
		if(Number(v_call_time) < 10){
			alert("자동해제인 경우 10초 이상을 입력해주세요.");
			$("#call_time").focus();
			return false;
		}
	}
	
	$.ajax({
		type : "POST",
		url : "/kiosk/bookingCallTimeUpdate.do",    	
		data : {
			str_code 	: $('#store_no').val(),
			call_time	: v_call_time,
			auto_clear	: v_auto_clear
		},
		dataType : "xml",
		success : function(result) {
		},
		error : function(result, status, err) {
			alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+error);
		},
		beforeSend: function() {		    
		},
		complete: function(){	
			alert("저장하였습니다.");
		}
	});
}
</script>
<div id="wrap">
	<div id="header" class="bdr_none">
		<a href="/kiosk/start.do" class="go_back">이전</a>
		<h1 class="standby">화면설정</h1>
	</div>
	<div id="content_wrap">
		<div class="content">
			<ul class="tab_wrap">
				<li><a href="#none" onclick="fn_banner();">대기화면</a></li>
				<li><a href="#none" onclick="fn_message();">안내문구</a></li>
				<li class="active"><a href="#none" onclick="fn_call_time();">호출타임</a></li>
			</ul>
			<div class="setting_commnet2">
				대기현황판 호출신호 해제시간을 설정합니다.
				<ul class="timeout">
					<li><input type="radio" id="auto_clear1" name="auto_clear" value="Y" class="book_radio" <c:if test="${monitorVO.auto_clear == 'Y'}">checked</c:if>><label for="auto_clear1"><span></span>자동해제</label> <input type="text" id="call_time" name="call_time" value="${monitorVO.call_time}" onkeyup="isNumberChk(this);">초 후 해제</li>
					<li><input type="radio" id="auto_clear2" name="auto_clear" value="N" class="book_radio" <c:if test="${monitorVO.auto_clear == 'N'}">checked</c:if>><label for="auto_clear2"><span></span>수동해제</label></li>
				</ul>
			</div>
		</div><!-- //content -->
		<div class="comment_btn_area2">
			<button type="button" class="btn_confirm2" onclick="fn_call_time_save();">저장하기</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->