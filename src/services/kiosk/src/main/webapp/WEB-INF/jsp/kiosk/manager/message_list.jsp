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

function fn_message_save(){
	$.ajax({
		type : "POST",
		url : "/kiosk/bookingMsgUpdate.do",    	
		data : {
			str_code: $('#store_no').val(),
			msg1	: $('#msg1').val(),
			msg2	: $('#msg2').val(),
			msg3	: $('#msg3').val(),
			msg4	: $('#msg4').val(),
			msg5	: $('#msg5').val()
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
				<li class="active"><a href="#none" onclick="fn_message();">안내문구</a></li>
				<li><a href="#none" onclick="fn_call_time();">호출타임</a></li>
			</ul>
			<div class="setting_commnet">
				대기현황판 하단 안내문구를 등록해 주세요.<br>전체 등록문구가 돌아가며 공개됩니다.
			</div>
			<ul class="notice_add">
				<li>1. <input type="text" class="notice_input" id="msg1" name="msg1" value="${messageVO.msg1}" readonly></li>
				<li>2. <input type="text" class="notice_input" id="msg2" name="msg2" value="${messageVO.msg2}"></li>
				<li>3. <input type="text" class="notice_input" id="msg3" name="msg3" value="${messageVO.msg3}"></li>
				<li>4. <input type="text" class="notice_input" id="msg4" name="msg4" value="${messageVO.msg4}"></li>
				<li>5. <input type="text" class="notice_input" id="msg5" name="msg5" value="${messageVO.msg5}"></li>
			</ul>
		</div><!-- //content -->
		<div class="comment_btn_area2">
			<button type="button" class="btn_confirm2" onclick="fn_message_save();">저장하기</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->