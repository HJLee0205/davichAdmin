<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<link href="<c:url value='/kiosk/css/jquery-ui.min.css' />" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="/kiosk/js/common.js"></script> 
<script type="text/javascript" src="/kiosk/js/common_tts.js"></script> 

<script type="text/javascript">
$(document).ready(function() {
	//기초값
	$("#range").val(${simpleDataVO.page_unit});
	$("#rate").text(${simpleDataVO.page_unit});
	
	$("#range").on('input', function() {
	    $("#rate").text($(this).val()); 
	});	
	
	$("#save").on('click', function() {
		if(!$('#store_no').val() || !$('#login_id').val()){
			alert("매장정보와 로그인 정보가 이상합니다. 재로그인 후 재 설정 부탁드립니다.");
		}else{
			$.ajax({
				type : "POST",
				url : "/kiosk/insertSimpleDataOption.do",    	
				data : {
					str_code : $('#store_no').val(),
					login_id : $('#login_id').val(),
					unit_size: $('#range').val(), 
				},
				dataType : "xml",
				complete : function(result) {
					alert("저장되었습니다.");
					location.href="/kiosk/start.do";
				}
			});
		}
	});	
	
	$("#home").on('click', function() {
	    location.href="/kiosk/start.do";
	});	
	
});

</script>
<style>
.toTalDiv{float:left; width: calc(20% - 1px); height: 100%; }
.div1{border-right: 1px #06b6e7 solid;}
.div2{border-right: 1px #06b6e7 solid;}
.div3{border-right: 1px #06b6e7 solid;}
.div4{border-right: 1px #06b6e7 solid;}
.div5{}

.contentDiv{color: black; height: calc(99.5% - 80px);}
.divTitle{width:90%;text-align: center; background: rgb(220,230,242); margin: 0 auto; margin-top: 5px; font-size: 20px; font-weight: bold;}
.content8{text-align: center; font-size: 22px;  background: rgb(183,222,232); width: 80%; margin: auto;height:95%;position: absolute; top: 0px; bottom : 0px; right : 0px; left : 0px; font-weight: bold;}
.waitingNumber{color: rgb(149,55,53); font-size: 100px; text-align: center; font-weight: bold;}
.waitingPeople{color: black; font-size: 30px; text-align: center;}
.test1{display: table; margin: 0 auto; height: 60%;}
.test2{display: table-cell; vertical-align: middle;}

@media all and (min-width: 1920px) {
	.divTitle{font-size:40px;}
	.waitingNumber{font-size:100px;}
	.waitingPeople{font-size:20px;}
}

@media all and (max-width: 1440px) and (min-width: 1400px) {
	.content8{font-size:20px;}
}

@media all and (max-width: 1400px) and (min-width: 1025px) {
	.divTitle{font-size:24px;}
	.waitingNumber{font-size:100px;}
	.waitingPeople{font-size:20px;}
	.content8{font-size:20px;}
}

@media all and (max-width: 1024px) {
	.divTitle{font-size:22px;}
	.waitingNumber{font-size:95px;}
	.waitingPeople{font-size:20px;}
	.content8{font-size:20px;}
}
.tableCss{
	width: 100%; 
	margin-top: 25px; 
	letter-spacing:-5px; 
	text-align: center;
}
.buttonCSS{
	border: 1px solid black;
	width:100px;
	cursor: pointer;
	text-align: center;
	display: inline-block;
}
.buttonCSSLeft{
	margin-left: 44%;
}
</style>
<div id="wrap2" class="bgwhite" style="min-width: 1024px;">
	<div id="header" class="bdr_none" style="height:80px;">
		<span class="logo">다비치안경체인</span>
		<h1 class="standby2" style="margin-top: 0px;">순번고객옵션</h1>
	</div>
	<div class="content_simple_monitor contentDiv">
	
		<p style="text-align:  center;">2명에서 10명까지 세팅 (설정안한 경우 5명으로 체크한다) - 계정 당 설정임!!</p>
		<div style="width:550px; margin: 0 auto;">최고값 2 <input type="range" min="2" max="10" step="1" id="range" style="width:300px;"> 최대값 10</div>
		<br/>
		<p style="text-align: center;">현재값 : <span id="rate" style="color:black;"></span></p>
		<div id="save" class="buttonCSS buttonCSSLeft">저장</div><div id="home" class="buttonCSS">홈으로</div>
	</div>
</div><!-- //wrap -->

<script type="text/javascript">

</script>		