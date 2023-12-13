<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_main(){
	document.kioskForm.action="/kiosk/customerSearch.do";
	document.kioskForm.submit();
}
function fn_monitor_booking(){
	document.kioskForm.action="/kiosk/booking_monitor.do";
	document.kioskForm.submit();
}
function fn_monitor_tts_test(){
	document.kioskForm.action="/kiosk/tts_monitor_test.do";
	document.kioskForm.submit();
}

function fn_mobile(){
	document.kioskForm.action="/kiosk/mobileMonitor.do";
	document.kioskForm.submit();
}
function fn_simple_data_monitor(){
	document.kioskForm.action="/kiosk/simpleDataMonitor.do";
	document.kioskForm.submit();
}
function fn_simple_data_monitor_test(){
	document.kioskForm.action="/kiosk/simpleDataMonitor_test.do";
	document.kioskForm.submit();
}
function fn_simple_data_option(){
	document.kioskForm.action="/kiosk/simpleDataOption.do";
	document.kioskForm.submit();
}
$(document).ready(function() {
	$.ajax({url: "<c:url value='/kiosk/selectAm010tblTestCount.do' />",
		data : {
			str_code : $('#store_no').val(),
			test_code : "A033"
		},
		dataType: "json",
		type: "post",
		async: false,
		success: function(result) {
			if(result.count > 0){
				$("#test").html("<li style=\"height: 8.5rem !important; float:none; width: 100% !important; \"><button type=\"button\" class=\"start_btn02\" onclick=\"fn_simple_data_monitor_test();\"><span></span>순번고객(신)전광판화면</spa></button></li>");
				$(".start_btn_list").append("<li style=\"height: 8.5rem;\"><button type=\"button\" class=\"start_btn03\" onclick=\"fn_simple_data_option();\">순번고객 옵션<span></span></button></li>");
				/* $(".start_btn_list").append("<li style=\"height: 8.5rem;\"><button type=\"button\" class=\"start_btn03\" onclick=\"fn_simple_data_monitor_test();\">순번 고객 테스트<span></span></button></li>"); */
			}
		}
	});	
});
</script>
<div id="wrap">
	<div id="header" class="bg">
		<h1>
			다비치안경 <em>${loginVo.strName}</em>
			<span>고객맞이 시스템입니다.</span>
		</h1>
		<a href="/kiosk/logout.do" class="logout">로그아웃</a>
	</div>
	<div id="content_wrap">
		<div class="coment_area01">실행화면을 선택해 주세요.</div>
		<ul class="start_btn_list">
			<li class="liCss1"><button type="button" class="start_btn01" onclick="fn_main();"><span></span>고객접수</button></li>
			<div class="liDiv">
			<li style="height: 8.5rem; float:none; width: 100% !important;"><button type="button" class="start_btn02" onclick="fn_monitor_tts_test();"><span></span>대기고객관리 음성지원</button></li>
			<li style="height: 8.5rem !important; float:none; width: 100% !important; "><button type="button" class="start_btn02" onclick="fn_monitor_booking();"><span></span>대기고객관리 <spa>음성 미지원</spa></button></li>
			<div id="test"></div>
			</div>
			<li style="height: 8.5rem;"><button type="button" class="start_btn03" onclick="fn_mobile();">모바일 대기고객 관리<span></span></button></li>
		</ul>
	</div><!-- //content_wrap -->
</div>
<!-- <div id="footer">
	<span class="logo">다비치안경체인</span>
</div> --><!---//footer --->