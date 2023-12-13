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
.content_simple_monitor {text-align: center; height: 100%;}
.content_simple_monitor .div1,.content_simple_monitor .div2,.content_simple_monitor .div3 {background: rgb(16,37,63);  }
.content_simple_monitor .div1,.content_simple_monitor .div2 {width: 32.8%; height:40%; float: left; border: 2px solid #ccc;}
.content_simple_monitor .div3 {width: calc(98.4% + 8px); height:18.7%; float: left; border: 2px solid #ccc;}
.content_simple_monitor .div1{margin-left: 0.5%;}
.content_simple_monitor .div3{margin-left: 0.5%;}
.information{background:rgb(250, 235, 215); height:100px; width: 280px; margin: 0 auto; line-height: 100px; color: black;}
.informationTop{margin-top: 5%; }
.informationBottom{margin-top: 10px;}
.information2{background:rgb(250, 235, 215); height:100px; width: 280px; line-height: 100px; color: black; display: inline-block;}
.div3Div1{display: block;}
.div3Div2{margin-top: 10px; margin-right: 10px;}
.div3Div3{margin-top: 10px;}
.spanTitle{ margin-top: 5%; display: block;}
@media(max-width: 1320px) {
	body{font-size:23px;}
}}
</style>
<div id="wrap2" class="bgwhite" style="min-width: 1090px;">
	<div class="content_simple_monitor">
		<div class="div1" >
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
			</div>
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