<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript" src="/kiosk/js/monitor_tts.js"></script> 
<div id="wrap2" class="bgwhite">
	<div id="header" class="bdr_none">
		<span class="logo">다비치안경체인</span>
		<div id="open" style="position: absolute; right: 5px; top: 50px; background:blue; font-size:15px; display: none; padding-left:10px; padding-right:10px; cursor: pointer;">열기</div>
		<img class="option" id="test2" src="/kiosk/images/speaker2.png" style="position: absolute; right: 5px; top: 10px; width:50px;" />
		<div class="option" style="position: absolute; right: 5px; top: 50px;">
			<span id="speedRate" style="color:black;"></span>
			<input type="range" min="0.1" max="3" step="0.1" id="speed" value ="1.2">
			<div id="saveSpeed" style="background:blue; font-size:15px; display: inline-block; padding-left:10px; padding-right:10px; cursor: pointer;">쿠키저장</div>
			<div id="close" style="background:blue; font-size:15px; display: inline-block; padding-left:10px; padding-right:10px; cursor: pointer;">닫기</div>
		</div>
		<h1 class="standby2">대기고객현황</h1>
		<p class="leftPageNo h1_btm">페이지: <span id = pageNo></span>/<span id = totalPageNo></span> </p>
		<p class="h1_btm">다비치에 방문하신 것을 환영합니다!  </p>
		<p class="rightCnt h1_btm">현재 대기고객 수:<span id="cnt"></span>명  </p>
	</div>
	<div id="content_wrap" class="monitor-wrap">
		<div class="content">
			<div id="alarmPopup" style="color: black; /* position: absolute; top: 43%; right: 30%; */ z-index: 1; text-align:center;"></div>
			<div class="table_wrap02">
				<table class="tb_type04">
					<caption>
						<h1 class="blind">고객명단 제목</h1>
					</caption>
					<colgroup>
						<col style="width:6%">
						<col style="width:19.5%">
						<col style="width:19.5%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:7.05%">
					</colgroup>
					<thead>
						<tr>
							<th>순번</th>
							<th class="textL">이름</th>
							<th class="textL">목적</th>
							<th class="stit">대기</th>
							<th class="stit">상담시작</th>
							<th class="stit">검사중</th>
							<th class="stit">검사완료</th>
							<th class="stit">상담중</th>
							<th class="stit">상담완료</th>
							<th class="stit">안경완성</th>
							<th class="stit">예약시간</th>
						</tr>
					</thead>
				</table>
				<table class="tb_type05">
					<caption>
						<h1 class="blind">고객명단 리스트</h1>
					</caption>
					<colgroup>
						<col style="width:6%">
						<col style="width:19.5%">
						<col style="width:19.5%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:6.85%">
						<col style="width:7.05%">
					</colgroup>
					<tbody id="tot_booking_list"></tbody>
				</table>
			</div>
		</div><!-- //content -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->

<script type="text/javascript">
<!--
var el = $('.innerfade li'),
i = 0;
$(el[0]).show();

(function loop() {
    el.delay(4000).fadeOut(0).eq(++i%el.length).fadeIn(0, loop);
}());

//-->
</script>		