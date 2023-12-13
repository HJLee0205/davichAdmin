<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_stand_by_list(){
	$.ajax({
		type : "POST",
		url : "/kiosk/simpleMonitorData.do", 	
		dataType : "json",
		data: {store_no : $('#store_no').val()},
		success : function(result) { 
			var data = result.data;
			$("#CNT_1").text(data.cnt_1);
			$("#CNT_2").text(data.cnt_2);
			$("#CNT_3").text(data.cnt_3);
			$("#CNT_4").text(data.cnt_4);
			$("#CNT_5").text(data.cnt_5);
			$("#CNT_6").text(data.cnt_6);
			$("#CNT_7").text(data.cnt_7);
			
			$("#SEQ_NO2_1").text(data.seq_no2_1);
			$("#SEQ_NO2_2").text(data.seq_no2_2);
			$("#SEQ_NO2_3").text(data.seq_no2_3);
			$("#SEQ_NO2_4").text(data.seq_no2_4);
			$("#SEQ_NO2_5").text(data.seq_no2_5);
			$("#SEQ_NO2_6").text(data.seq_no2_6);
			$("#SEQ_NO2_7").text(data.seq_no2_7);
			
		},
		error : function(result, status, err) {
			/* alert("code:"+result.status+"\n"+"error:"+err); */
		},
		beforeSend: function() {		    
		},
		complete: function(){
			
		}
	});
}

$(document).ready(function() {
	setInterval(function(){		
		fn_stand_by_list();
		}, 
	5000);
});

</script>
<style>
.toTalDiv{float:left; width: 24.5%; height: 50%; }
.div1{border-bottom: 1px #06b6e7 solid; border-right: 1px #06b6e7 solid; margin-left:1%;}
.div2{border-bottom: 1px #06b6e7 solid; border-right: 1px #06b6e7 solid;}
.div3{border-bottom: 1px #06b6e7 solid; border-right: 1px #06b6e7 solid;}
.div4{border-bottom: 1px #06b6e7 solid; }
.div5{border-right: 1px #06b6e7 solid; margin-left:1%;}
.div6{border-right: 1px #06b6e7 solid;}
.div7{border-right: 1px #06b6e7 solid;}
.div8{position: relative;}
.contentDiv{color: black; height: calc(99.5% - 170px);}
.divTitle{width:90%;text-align: center; background: rgb(220,230,242); margin: 0 auto; margin-top: 5px; font-size: 20px; font-weight: bold;}
.content8{text-align: center; font-size: 22px;  background: rgb(183,222,232); width: 80%; margin: auto;height:95%;position: absolute; top: 0px; bottom : 0px; right : 0px; left : 0px; font-weight: bold;}
.waitingNumber{color: rgb(149,55,53); font-size: 100px; text-align: center; font-weight: bold;}
.waitingPeople{color: black; font-size: 30px; text-align: center;}
.test1{display: table; margin: 0 auto; height: 60%;}
.test2{display: table-cell; vertical-align: middle;}
/* @media(max-width: 1320px) {
	body{font-size:23px;}
}} */

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

</style>
<div id="wrap2" class="bgwhite" style="min-width: 1024px;">
	<div id="header" class="bdr_none">
		<span class="logo">다비치안경체인</span>
		<h1 class="standby2">대기고객현황</h1>
		<p class="h1_btm">다비치에 방문하신 것을 환영합니다!  </p>
	</div>
	<div class="content_simple_monitor contentDiv">
		<div class="toTalDiv div1">
			<div class="divTitle">
				안경, 선글라스</br>
				구입 정밀검사 (15분소요)
			</div>
			<div class="test1">
				<div class="test2">
					<div class = "waitingNumber"><span id="SEQ_NO2_1"></span></div>
					<div class = "waitingPeople">대기인수: <span id="CNT_1">0</span></div>
				</div>
			</div>
		</div>
		<div class="toTalDiv div2">
			<div class="divTitle">
				안경, 선글라스</br>
				시력검사 생략 구매
			</div>
			<div class="test1">
				<div class="test2"> 
					<div class = "waitingNumber" ><span id="SEQ_NO2_2"></span></div>
					<div class = "waitingPeople">대기인수: <span id="CNT_2">0</span></div>
				</div>	
			</div>
		</div>
		<div class="toTalDiv div3">
			<div class="divTitle">
				안경, 선글라스</br>
				구입 제품 수령 고객
			</div>
			<div class="test1">
				<div class="test2">
					<div class = "waitingNumber" ><span id="SEQ_NO2_3"></span></div>
					<div class = "waitingPeople" >대기인수: <span id="CNT_3">0</span></div>
				</div>
			</div>
		</div>
		<div class="toTalDiv div4">
			<div class="divTitle">
				A/S, 안경조정(피팅),</br>
				부속교체 
			</div>
			<div class="test1">
				<div class="test2">
					<div class = "waitingNumber" ><span id="SEQ_NO2_7"></span></div>
					<div class = "waitingPeople" >대기인수: <span id="CNT_7">0</span></div>
				</div>
			</div>
		</div>
		
		<div class="toTalDiv div5">
			<div class="divTitle">
				콘택트렌즈</br>
				구입 정밀검사 (15분소요)
			</div>
			<div class="test1">
				<div class="test2">
					<div class = "waitingNumber" ><span id="SEQ_NO2_4"></span></div>
					<div class = "waitingPeople" >대기인수: <span id="CNT_4">0</span></div>
					
				</div>
			</div>
		</div>
		<div class="toTalDiv div6">
			<div class="divTitle">
				콘택트렌즈</br>
				시력검사 생략 구매
			</div>
			<div class="test1">
				<div class="test2">
					<div class ="waitingNumber" ><span id="SEQ_NO2_5"></span></div>
					<div class ="waitingPeople" >대기인수: <span id="CNT_5">0</span></div>
					
				</div>
			</div>
		</div>
		<div class="toTalDiv div7">
			<div class="divTitle">
				콘택트렌즈</br>
				구입 제품 수령 고객
			</div>
			<div class="test1">
				<div class="test2">
					<div class = "waitingNumber" ><span id="SEQ_NO2_6"></span></div>
					<div class = "waitingPeople" >대기인수: <span id="CNT_6">0</span></div>
				</div>
			</div>
		</div>
		<div class="toTalDiv div8">
			<div class="content8">
				번호표를 들고 계시면 </br>
				순서대로 </br>
				응대 도와 드리겠습니다.</br>
				</br>
				기다리시는 동안 </br>
				다온 카페를 </br>
				이용 해 주세요.</br>
			</div>
		</div>
		<!-- <div class="div1" >
			<span class="spanTitle">안경,선글라스 구입 정밀검사(15분)</span>
			<div class="information informationTop">대기인수 <span id="CNT_1">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_1" style="color:red"></span>
			</div>
		</div>
		<div class="div2" ><span class="spanTitle">안경,선글라스 시력 검사 생략 구매</span>
			<div class="information informationTop">대기인수 <span id="CNT_2">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_2" style="color:red"></span>
			</div>
		</div>
		<div class="div2" ><span class="spanTitle">안경, 선글라스 구입 제품 수령 고객</span>
			<div class="information informationTop">대기인수 <span id="CNT_3">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_3" style="color:red"></span>
			</div>
		</div>
		<div class="div1" ><span class="spanTitle">콘택트렌즈 구입 정밀검사 (15분)</span>
			<div class="information informationTop">대기인수 <span id="CNT_4">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_4" style="color:red"></span>
			</div>
		</div>
		<div class="div2" ><span class="spanTitle">콘택트렌즈 시력검사 생략 구매</span>
			<div class="information informationTop">대기인수 <span id="CNT_5">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_5" style="color:red"></span>
			</div>
		</div>
		<div class="div2" ><span class="spanTitle">콘택트렌즈 구입 제품 수령 고객</span>
			<div class="information informationTop">대기인수 <span id="CNT_6">0</span>
			</div>
			<div class="information informationBottom">
				<span id="SEQ_NO2_6" style="color:red"></span>
			</div>
		</div>
		<div class="div3" ><span class="div3Div1">A/S, 안경조정(피팅), 부속교체</span>
			<div class="information2 div3Div3">대기인수 <span id="CNT_7">0</span>
			</div>	
			<div class="information2 div3Div2">
				<span id="SEQ_NO2_7" style="color:red"></span>
			</div> -->
		</div>
	</div>
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