<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<link href="<c:url value='/kiosk/css/jquery-ui.min.css' />" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="/kiosk/js/common.js"></script> 
<script type="text/javascript" src="/kiosk/js/common_tts.js"></script> 

<script type="text/javascript">
var _this = this;
var page_unit = ${simpleDataVO.page_unit};
var page_index1 = 1;
var page_index2 = 1;
var page_index3 = 1;
var page_index4 = 1;
var page_index5 = 1;
function fn_stand_by_list(purpose,page_index){
	$.ajax({
		type : "POST",
		url : "/kiosk/simpleDataListMonitor.do",    	
		data : {
			str_code : $('#store_no').val(),
			purpose : purpose,
			page_index :page_index,
			page_unit:page_unit,
		},
		dataType : "xml",
		success : function(result) {
			page_index = Number($(result).find('page_index').text()) + 1;
			var total_count = Number($(result).find('total_count').text());
			var index = 0;
			var count = 0;
			if(total_count == 0){
				index = 0;
				count = 0;
			}else{
				index = page_index-1;
				count = Math.floor(total_count/page_unit);	
				if(total_count%page_unit != 0){
					count = count + 1;	
				}
			}
			
			
			var tot_append_str = "";
			if(purpose == 4){
				/* tot_append_str += "<tr><th>구분</th><th>이름</th><th>예약</th><th>방문</th></tr>"; */
				tot_append_str += "<tr><th>이름</th><th>예약</th><th>방문</th></tr>";
			}else{
				/* tot_append_str += "<tr><th>구분</th><th>순번</th><th>이름</th><th>상태</th></tr>"; */	
				tot_append_str += "<tr><th>순번</th><th>이름</th><th>상태</th></tr>";	
			}
			$("tot_row",result).each(function(){
				tot_append_str += "<tr>";
				/* if(purpose == 4){
					tot_append_str += "	<td style=\"letter-spacing:0px;\">예약</td>";
				}else if(purpose == 1){
					tot_append_str += "	<td style=\"letter-spacing:0px;\">안경</td>";
				}else if(purpose == 2){
					tot_append_str += "	<td style=\"letter-spacing:0px;\">콘택트</td>";
				}else if(purpose == 3){
					tot_append_str += "	<td style=\"letter-spacing:0px;\">AS/기타</td>";
				}else if(purpose == 5){
					tot_append_str += "	<td style=\"letter-spacing:0px;\">제품수령</td>";
				} */
				
				
				if(purpose == 4){
										//3번째 글자 : 이면 글자 자간 정상화 (간격 좁이면 이상하게 됨)
					/* if($("nm_cust",this).text().substr(2,1) == ":"){
						tot_append_str += "	<td style=\"letter-spacing:0px;\">"+$("nm_cust",this).text()+"</td>";
					}else{
						tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";	
					} */
					tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";
					
					var bookTime = $("book_time",this).text();
					if(bookTime){
						bookTime = $("book_time",this).text().substr(0,2) +":"+ $("book_time",this).text().substr(2,2);
					}
					tot_append_str += "	<td style=\"letter-spacing:0px;\">"+bookTime+"</td>";
					
					
					var inputTime = $("input_time",this).text();
					if(inputTime){
						inputTime = $("input_time",this).text().substr(0,2) +":"+ $("input_time",this).text().substr(2,2);
					}
					tot_append_str += "	<td style=\"letter-spacing:0px;\">"+inputTime+"</td>";
					
				}else{
					tot_append_str += "	<td>"+$("seq_no",this).text()+"</td>";
					//3번째 글자 : 이면 글자 자간 정상화 (간격 좁이면 이상하게 됨)
					/* if($("nm_cust",this).text().substr(2,1) == ":"){
						tot_append_str += "	<td style=\"letter-spacing:0px;\">"+$("nm_cust",this).text()+"</td>";
					}else{
					tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";	
					} */
					tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";	
					
					tot_append_str += "	<td>"+$("status",this).text()+"</td>";	
				}
				
				tot_append_str += "</tr>";
			});
			if(purpose == 1){
				$('.glassess').html(tot_append_str);
				$('.div1 .count').text(index+"/"+count);
				page_index1 = page_index;
			}else if(purpose == 2){
				$('.contact').html(tot_append_str);
				$('.div2 .count').text(index+"/"+count);
				page_index2 = page_index;
			}else if(purpose == 3){
				$('.as').html(tot_append_str);
				$('.div3 .count').text(index+"/"+count);
				page_index3 = page_index;
			}else if(purpose == 4){
				$('.book').html(tot_append_str);
				$('.div4 .count').text(index+"/"+count);
				page_index4 = page_index;
			}else if(purpose == 5){
				$('.simple').html(tot_append_str);
				$('.div5 .count').text(index+"/"+count);
				page_index5 = page_index;
			}
		},
		error : function(result, status, err) {
		}
	});
}

function fn_stand_by_list_test(purpose,page_index){
	$.ajax({
		type : "POST",
		url : "/kiosk/simpleDataListMonitor_test.do",    	
		data : {
			str_code : $('#store_no').val(),
			purpose : purpose,
			page_index :page_index,
			page_unit:page_unit,
		},
		dataType : "xml",
		success : function(result) {
			page_index = Number($(result).find('page_index').text()) + 1;
			var total_count = Number($(result).find('total_count').text());
			var index = 0;
			var count = 0;
			if(total_count == 0){
				index = 0;
				count = 0;
			}else{
				index = page_index-1;
				count = Math.floor(total_count/page_unit);	
				if(total_count%page_unit != 0){
					count = count + 1;	
				}
			}
			
			
			var tot_append_str = "";
			if(purpose == 4){
				tot_append_str += "<tr><th>구분</th><th>순번</th><th>이름</th><th>상태</th></tr>";	
			}else{
				tot_append_str += "<tr><th>이름</th><th>예약</th><th>방문</th></tr>";
			}
			$("tot_row",result).each(function(){
				tot_append_str += "<tr>";
				var gubun = "";
				/* WHEN SEQ_NO BETWEEN   1 AND  99 THEN '5' 
				  WHEN SEQ_NO BETWEEN 101 AND 199 THEN '1' 
 				  WHEN SEQ_NO BETWEEN 201 AND 299 THEN '2' 
				  WHEN SEQ_NO BETWEEN 301 AND 399 THEN '3' 
				  WHEN SEQ_NO BETWEEN 401 AND 499 THEN '4' */
				/* if($("seq_no",this).text()>=101 && $("seq_no",this).text()<=199){
					//1
					gubun="안경";
				}else if($("seq_no",this).text()>=301 && $("seq_no",this).text()<=399){
					//3
					gubun="AS/기타";
				}else if($("seq_no",this).text()>=1 && $("seq_no",this).text()<=99){
					//5
					gubun="제품수령";
				} */
				if($("seq_no",this).text()>=401 && $("seq_no",this).text()<=499){
					//4
					gubun="예약";
				}else if($("seq_no",this).text()>=301 && $("seq_no",this).text()<=399){
					//3
					gubun="AS/기타";
				}else if($("seq_no",this).text()>=1 && $("seq_no",this).text()<=99){
					//5
					gubun="제품수령";
				} 
				tot_append_str += "	<td style=\"letter-spacing:0px;\">"+gubun+"</td>";
				if(purpose == 4){
										//3번째 글자 : 이면 글자 자간 정상화 (간격 좁이면 이상하게 됨)
					if($("nm_cust",this).text().substr(2,1) == ":"){
						tot_append_str += "	<td style=\"letter-spacing:0px;\">"+$("nm_cust",this).text()+"</td>";
					}else{
						tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";	
					}
					var bookTime = $("book_time",this).text();
					if(bookTime){
						bookTime = $("book_time",this).text().substr(0,2) +":"+ $("book_time",this).text().substr(2,2);
					}
					tot_append_str += "	<td style=\"letter-spacing:0px;\">"+bookTime+"</td>";
					
					
					var inputTime = $("input_time",this).text();
					if(inputTime){
						inputTime = $("input_time",this).text().substr(0,2) +":"+ $("input_time",this).text().substr(2,2);
					}
					tot_append_str += "	<td style=\"letter-spacing:0px;\">"+inputTime+"</td>";
					
				}else{
					tot_append_str += "	<td>"+$("seq_no",this).text()+"</td>";
					//3번째 글자 : 이면 글자 자간 정상화 (간격 좁이면 이상하게 됨)
					if($("nm_cust",this).text().substr(2,1) == ":"){
						tot_append_str += "	<td style=\"letter-spacing:0px;\">"+$("nm_cust",this).text()+"</td>";
					}else{
						tot_append_str += "	<td>"+maskingName($("nm_cust",this).text())+"</td>";	
					}
					
					tot_append_str += "	<td>"+$("status",this).text()+"</td>";	
				}
				
				tot_append_str += "</tr>";
			});
			if(purpose == 1){
				$('.glassess').html(tot_append_str);
				$('.div1 .count').text(index+"/"+count);
				page_index1 = page_index;
			}else if(purpose == 2){
				$('.contact').html(tot_append_str);
				$('.div2 .count').text(index+"/"+count);
				page_index2 = page_index;
			}else if(purpose == 3){
				$('.as').html(tot_append_str);
				$('.div3 .count').text(index+"/"+count);
				page_index3 = page_index;
			}else if(purpose == 4){
				$('.book').html(tot_append_str);
				$('.div4 .count').text(index+"/"+count);
				page_index4 = page_index;
			}else if(purpose == 5){
				$('.simple').html(tot_append_str);
				$('.div5 .count').text(index+"/"+count);
				page_index5 = page_index;
			}
		},
		error : function(result, status, err) {
		}
	});
}

//음성관련 js 추가 작업 start



//음성관련 js 추가 작업 end



$(document).ready(function() {
	var num =0;
	var listNum3= [];
	var listNum4= [];
	var listNum5= [];
	
	 $.ajax({
			type : "POST",
			url : "/kiosk/nullJudg.do",    	
			data : {
				str_code : $('#store_no').val()
			},
			dataType : "xml",
			success : function(result) {

				var gubun = "";
				$("tot_row",result).each(function(){
					  
					 if($("seq_no",this).text()>=401 && $("seq_no",this).text()<=499){  // 예약
					 listNum4.push($("seq_no",this).text());
					}else if($("seq_no",this).text()>=301 && $("seq_no",this).text()<=399){ //as
					 listNum3.push($("seq_no",this).text());
					}else if($("seq_no",this).text()>=1 && $("seq_no",this).text()<=99){ //수령
					 listNum5.push($("seq_no",this).text());
					}   
					
				}
			);
			}
		}).done(function(){
			console.log(listNum3.length);
			console.log(listNum4.length);
			console.log(listNum5.length);
		})
	
 	setInterval(function(){		
 		//원래코드
		/* fn_stand_by_list_test(1,page_index1);  
		fn_stand_by_list(2,page_index2);  
		fn_stand_by_list(4,page_index4); */
		
		//수정 20220307
		fn_stand_by_list(1,page_index1);  
		fn_stand_by_list(2,page_index2);
		

		  $.ajax({
				type : "POST",
				url : "/kiosk/nullJudg.do",    	
				data : {
					str_code : $('#store_no').val()
				},
				dataType : "xml",
				success : function(result) {

					var gubun = "";
					$("tot_row",result).each(function(){
						  
						 if($("seq_no",this).text()>=401 && $("seq_no",this).text()<=499){  // 예약
						 listNum4.push($("seq_no",this).text());
						}else if($("seq_no",this).text()>=301 && $("seq_no",this).text()<=399){ //as
						 listNum3.push($("seq_no",this).text());
						}else if($("seq_no",this).text()>=1 && $("seq_no",this).text()<=99){ //수령
						 listNum5.push($("seq_no",this).text());
						}   
						
					}
				);
				}
			}).done(function(){
				console.log(listNum3.length);
				console.log(listNum4.length);
				console.log(listNum5.length);
			})
		
		
		if(num==0){
			if(listNum3.length == 0 && listNum4.length == 0 && listNum5.length == 0 ){ //
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
			}else if(listNum3.length != 0 && listNum4.length == 0 && listNum5.length == 0){//3
				fn_stand_by_list(3,page_index3);
				$(".div3").css("display",'');
				$(".div4").css("display",'none');
				num=1;
			}else if(listNum3.length != 0 && listNum4.length != 0 && listNum5.length == 0){//3,4
				fn_stand_by_list(3,page_index3);
				$(".div3").css("display",'');
				$(".div4").css("display",'none');
				num=1;
			}else if(listNum3.length != 0 && listNum4.length == 0 && listNum5.length != 0){//3,5
				fn_stand_by_list(3,page_index3);
				$(".div3").css("display",'');
				$(".div5").css("display",'none');
				$(".div4").css("display",'');
				num=1;
			}else if(listNum3.length != 0 && listNum4.length != 0 && listNum5.length != 0){//3,4,5
				fn_stand_by_list(3,page_index3);
				$(".div3").css("display",'');
				$(".div4").css("display",'none');
				$(".div5").css("display",'none');
				num=1;
			}else if(listNum3.length == 0 && listNum4.length != 0 && listNum5.length == 0){//4
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
			}else if(listNum3.length == 0 && listNum4.length != 0 && listNum5.length != 0){//4,5
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
				$(".div5").css("display",'none');
				num=1;
			}else if(listNum3.length == 0 && listNum4.length == 0 && listNum5.length != 0){//5
				fn_stand_by_list(4,page_index4);
				$(".div5").css("display",'none');
				$(".div4").css("display",'');
				num=1;
			}
			
			listNum3.length = 0;
			listNum4.length = 0;
			listNum5.length = 0;
		}else if(num==1){
			if(listNum3.length != 0 && listNum4.length != 0 && listNum5.length == 0){//3,4
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
				$(".div3").css("display",'none');
				num=0;
			}else if(listNum3.length != 0 && listNum4.length == 0 && listNum5.length != 0){//3,5
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
				$(".div3").css("display",'none');
				$(".div5").css("display",'');
				num=2;
			}else if(listNum3.length != 0 && listNum4.length != 0 && listNum5.length != 0){ //3,4,5
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
				$(".div3").css("display",'none');
				num=2;
			}else if(listNum3.length == 0 && listNum4.length != 0 && listNum5.length != 0){//4,5
				fn_stand_by_list(5,page_index5);
				$(".div4").css("display",'none');
				$(".div5").css("display",'');
				num=0;
			}else if(listNum3.length != 0 && listNum4.length == 0 && listNum5.length == 0){//3
				fn_stand_by_list(4,page_index4);
				$(".div4").css("display",'');
				$(".div3").css("display",'none');
				num=0;
			}else if(listNum3.length == 0 && listNum4.length == 0 && listNum5.length != 0){//5
				fn_stand_by_list(5,page_index5);
				$(".div4").css("display",'none');
				$(".div5").css("display",'');
				num=0;
			}
			listNum3.length = 0;
			listNum4.length = 0;
			listNum5.length = 0;
			
		}else if(num==2){
			
			if(listNum3.length != 0 && listNum4.length != 0 && listNum5.length != 0){//3,4,5
				fn_stand_by_list(5,page_index5);
				$(".div5").css("display",'');
				$(".div4").css("display",'none');
				$(".div3").css("display",'none');
				num=0;
			}else if(listNum3.length != 0 && listNum4.length == 0 && listNum5.length != 0){//3,5
				fn_stand_by_list(5,page_index5);
				$(".div5").css("display",'');
				$(".div4").css("display",'none');
				$(".div3").css("display",'none');
				num=0;
			}
			listNum3.length = 0;
			listNum4.length = 0;
			listNum5.length = 0;
			
		}  
	
		ttsList();
		}, 
	5000); 
	
	
	

	
	
	$(".logo").click(function(){
		var html =  "<div id = 'testtesttest'>"+
						"테스트 버튼  <img class=\"option\" id=\"test2\" src=\"/kiosk/images/speaker2.png\" style=\"position: absolute; right: 5px; top: 10px; width:50px;\" />"+
						"<br/>"+
						"<div class=\"option\" style=\"position: absolute; right: 5px; top: 50px;\">"+
							"<span id=\"speedRate\" style=\"color:black;\"></span>"+
							"<input type=\"range\" min=\"0.1\" max=\"3\" step=\"0.1\" id=\"speed2\" value =\"1.2\" style='width:170px;'>"+
							"<div id=\"saveSpeed\" style=\"color:white; background:blue; font-size:15px; display: inline-block; padding-left:10px; padding-right:10px; cursor: pointer;\">쿠키저장</div>"+
						"</div>"+
						"<div id=\"close\" style=\"position: absolute; right: 5px; bottom: 10px;\">닫기</div>"+
					"</div>";
		
		$(html).dialog({
			modal: true,
			title: "설정",
			height: 250,
			width:  300
		});
		$(".ui-dialog-titlebar-close").css("display","none");
		
		var speed = getCookie("speed");
		if(speed) {
			$("#speed2").val(getCookie("speed"));
			$("#speedRate").text(getCookie("speed"));
		}else{
			$("#speed2").val(1.2);
			$("#speedRate").text(1.2);
		}		
		
		$("#speed2").on('input', function() {
	          $("#speedRate").text($(this).val()); 
	      });
		
		$("#saveSpeed").click(function(){
			 setCookie("speed", $("#speed2").val(), 3000);
			 $("#speed").val($("#speed2").val());
		 });
		
		$("#close").click(function(){
			$("#testtesttest").dialog('destroy');
			$("#testtesttest").remove();
		});
		
		$("#test2").click(function () {
			 ttsTest2();
		});
	});
	
	function setCookie(cookieName, value, exdays){
		   var exdate = new Date();
		   exdate.setDate(exdate.getDate() + exdays);
		   var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
		   document.cookie = cookieName + "=" + cookieValue;
		}

		function deleteCookie(cookieName){
		   var expireDate = new Date();
		   expireDate.setDate(expireDate.getDate() - 1);
		   document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
		}

		function getCookie(cookieName) {
		   cookieName = cookieName + '=';
		   var cookieData = document.cookie;
		   var start = cookieData.indexOf(cookieName);
		   var cookieValue = '';
		   if(start != -1){
		      start += cookieName.length;
		      var end = cookieData.indexOf(';', start);
		      if(end == -1)end = cookieData.length;
		      cookieValue = cookieData.substring(start, end);
		   }
			return unescape(cookieValue);
		}
				
		$(function(){
			var speed = getCookie("speed");
			if(speed) {
				$("#speed").val(getCookie("speed"));
				$("#speedRate").text(getCookie("speed"));
			}else{
				$("#speed").val(1.2);
				$("#speedRate").text(1.2);
			}		
			$("#saveSpeed").click(function(){
				 setCookie("speed", $("#speed").val(), 3000); 
			 });
			});
	
});

//logo();

</script>
<style>
.toTalDiv{float:left; width: calc(33% - 1px); height: 100%; }
.div1{border-right: 1px #06b6e7 solid;}
.div2{border-right: 1px #06b6e7 solid;}
.div3{}
.div4{}
.div5{}

.contentDiv{color: black; height: calc(99.5% - 80px);}
.divTitle{width:90%;text-align: center; background: rgb(220,230,242); margin: 0 auto; margin-top: 5px; font-size: 30px; font-weight: bold;}
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
.tableCss{
	width: 100%; 
	margin-top: 25px; 
	letter-spacing:-5px; 
	text-align: center;
	font-size:40px;
}
</style>
<div id="wrap2" class="bgwhite" style="min-width: 1024px;">
	<div id="header" class="bdr_none" style="height:80px;">
		<span class="logo">다비치안경체인</span>
		<h1 class="standby2" style="margin-top: 0px;">순번고객현황</h1>
	</div>
	<div class="content_simple_monitor contentDiv">
		<input type="hidden" min="0.1" max="3" step="0.1" id="speed" value ="1.2">
		<div id="alarmPopup" style="color: black; /* position: absolute; top: 43%; right: 30%; */ z-index: 1; text-align:center;"></div>
		<div class="toTalDiv div1" style="position: relative;">
			<div class="divTitle">
				안경, 선글라스</br>
				고객님
			</div>
			<span class = "count" style="font-size:25px; position: absolute; right: 10px;">1/1</span>
			<table class="glassess tableCss">
			</table>
		</div>
		<div class="toTalDiv div2" style="position: relative;">
			<div class="divTitle">
				콘택트렌즈</br>
				고객님
			</div>
			<span class = "count" style="font-size:25px; position: absolute; right: 10px;">1/1</span>
			<table class="contact tableCss">
			</table>
		</div>
	    <div class="toTalDiv div3" style="position: relative; display:none;">
			<div class="divTitle">
				A/S &#183; 피팅 &#183; 기타</br>
				고객님
			</div>
			<span class = "count" style="font-size:25px; position: absolute; right: 10px;">1/1</span>
			<table class="as tableCss">
			</table>
		</div> 
		<div class="toTalDiv div4" style="position: relative; ">
			<div class="divTitle">
				예약 방문</br> 고객님
			</div>
			<span class = "count" style="font-size:25px; position: absolute; right: 10px;">1/1</span>
			<table class="book tableCss">
			</table>
		</div> 
		<div class="toTalDiv div5" style="position: relative; display:none;">
			<div class="divTitle">
				구매 제품 수령</br>
				고객님
			</div>
			<span class = "count" style="font-size:25px; position: absolute; right: 10px;">1/1</span>
			<table class="simple tableCss">
			</table>
		</div>    
		
		</div>
	</div>
</div><!-- //wrap -->

<script type="text/javascript">

</script>		