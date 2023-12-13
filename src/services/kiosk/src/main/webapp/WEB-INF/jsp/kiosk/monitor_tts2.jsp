<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
var _this = this;
var v_tot_page_index = 1;
function fn_stand_by_list(){
	$.ajax({
		type : "POST",
		url : "/kiosk/standByXml_booking.do",    	
		data : {
			store_no : $('#store_no').val(),
			tot_page_index : v_tot_page_index
		},
		dataType : "xml",
		success : function(result) {
			var v_tot_cnt = $(result).find('tot_cnt').text();
			var waiting_cnt = $(result).find('waiting_cnt').text();
			
			v_tot_page_index = Number($(result).find('tot_page_index').text()) + 1;
			$("#pageNo").text(Number(v_tot_page_index)-1);
			//사람 나오는 숫자가 5명 이상인 경우 해당 5로 된값 변경해야한다.
			$("#totalPageNo").text(Math.ceil(Number(v_tot_cnt)/5));
			$("#cnt").text(waiting_cnt);
			$('#tot_booking_list').find("tr").remove();
			
			var cnt = 1;
			var tot_append_str = "";
			if(v_tot_cnt == 0 ){
				$("#pageNo").text(0);
			}else{				
				$("tot_row",result).each(function(){
					tot_append_str = "<tr>";
					if($("seq_no",this).text() == '예약'){
						tot_append_str += "	<td style='color:red;'>"+$("seq_no",this).text()+"</td>";
					}else{
						tot_append_str += "	<td>"+$("seq_no",this).text()+"</td>";
					}
					
					tot_append_str += "	<td class=\"textL\">"+maskingName($("nm_cust",this).text())+"</td>";
					tot_append_str += "	<td class=\"textL textEllipsis\">"+$("purpose",this).text()+"</td>";
					var status = Number($("status",this).text());
					for(var i=0;i<=status;i++){
						if(status == 0){
							tot_append_str += "	<td class=\"waiting\"></td>";							
						}else if(i == 6 && status == 6){
							tot_append_str += "	<td class=\"completeWaiting\"></td>";
						}else if(i == 7){
							//7번이면 안경완성이다.							
							
						}else{
							tot_append_str += "	<td class=\"going\"></td>";	
						}
					}
					
					//6번이면 안경완성 오렌지색으로 7번이면 파란색으로 변경
					if(status == 7){
						status = 6;
					}
					
					for(var i=0;i<6-status;i++){
						tot_append_str += "	<td></td>";	
					}
					var book_time = $("book_time",this).text();
					if(book_time != null && book_time != ''){
						book_time = $("book_time",this).text().substring(0,2) + ":" + $("book_time",this).text().substring(2,4);
					}
					tot_append_str += "	<td>"+book_time+"</td>";
					tot_append_str += "</tr>";
				
					$('#tot_booking_list').append(tot_append_str);
					cnt++;
				});
			}			
		},
		error : function(result, status, err) {
			/* alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err); */
		}
	});
}

function ttsList(){
	$.ajax({
		type : "POST",
		url : "/kiosk/selectStrBookingListComplete.do",    	
		data : {
			store_no : $('#store_no').val()
		},
		dataType : "xml",
		success : function(result) {
			_this.flag = false;
			var name = "";
			var seq_no = "";
			var phoneNum = "";
			$("tot_row",result).each(function(){
				ttsTest($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text());
				/* name += maskingName($("nm_cust",this).text());
				seq_no += $("seq_no",this).text();
				phoneNum += $("phoneNum",this).text(); */
				
			})
			/* if(name != ""){
				alarmPopup(name ,seq_no,phoneNum);
			} */
			
		},
		error : function(result, status, err) {
		}
	});
}

msg = new SpeechSynthesisUtterance();

function ttsTest(name, seq_no, phoneNum){ 
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
	msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    soundName = "";
    for (var i = 0; i < name.length; i++) {
		soundName += name[i]+" "
	}
    /* msg.text = soundName+" 고객님  안경 가공이 완료되었습니다. 전광판을 확인 해 주세요"; */
    phoneNum = String(phoneNum).slice(-4);
    msg.text = getHangul(seq_no)+ "번 "+soundName+" 고객님 "+getHangul2(phoneNum)+" 안경 가공이 완료되었습니다. 전광판을   확인 해 주세요";
   	speechSynthesis.speak(msg); 
   	msg.onstart = function(event) {
   		alarmPopup(maskingName(name), seq_no, phoneNum);
   	}
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
    msg.onerror = function(event) {
        console.log('An error has occurred with the speech synthesis: ' + event.error);
      }
}


function alarmPopup(name, seq, num){ 
	 var text = "";
	if(seq == null){
		text =  " <span class=\'test\'>"+ name +" 고객님</span>"+
		"<span style='color:blue; font-size:48px; font-weight:bold;'> 안경제작이 완료되어</span> </br>"+
		"<span>지금 수령이 가능하십니다.</span>";		
	}else{
		text =  " <span class=\'test\'>"+seq+"번 "+ name +" 고객님 "+num+" </span>"+
		"<span style='color:blue; font-size:48px; font-weight:bold;'>안경제작이 완료되어</span> </br>"+
		"<span>지금 수령이 가능하십니다.</span>";	
	}
    var html2 = "<div style=\'background:rgb(255, 230, 153); padding:10px; font-size:45px;\' >"+
			    text
			    +"</div>";
    $("#alarmPopup").html(html2);
    /* setTimeout(function () {
    	$("#alarmPopup").html("")
	} ,5000); */
}
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}
function getHangul(num) {
    var numberic = ["","일","이","삼","사","오","육","칠","팔","구"];
    var numunit = ["","","십","백","천","만","십만","백만","천만","억","십억","백억","천억"];
    var str = "", tmp = "";
 
    var splited = [];
    for(var i = 0; i < String(num).length; i ++) {
        splited.push(String(num).substring(i, i+1));
    }
 
    for(var i = 0, x = String(num).length; x > 0; -- x, ++ i) {
        tmp = numberic[splited[i]];
        if(tmp) {
            if(x > 4 && numberic[splited[i + 1]]) {
                tmp += numunit[x].substring(0, 1);
            } else {
                tmp += numunit[x];
            }
        }
        str += tmp;
    }
    str = str.replaceAll("일십","십").replaceAll("일백","백").replaceAll("일천","천");
 	
    return str;
};


function getHangul2(num) {
    var numberic = ["공","일","이","삼","사","오","육","칠","팔","구"];
    var numunit = ["","","십","백","천","만","십만","백만","천만","억","십억","백억","천억"];
    var str = "", tmp = "";
    var splited = [];
    for(var i = 0; i < String(num).length; i ++) {
        splited.push(String(num).substring(i, i+1));
    }
    for(var i = 0, x = String(num).length; x > 0; -- x, ++ i) {
        tmp = numberic[splited[i]];
        str += tmp+",";
    }
    return str;
};


function ttsTest2(){ 
	msg = new SpeechSynthesisUtterance();
	msg.lang = 'ko-KR';
    msg.rate = $("#speed").val(); // 0.1 ~ 10  1.2
    msg.pitch = 0.8; // 0 ~ 2   0.8
    msg.text= null;
    msg.text = getHangul(9337)+ "번 다비치 고객님 "+getHangul2("0001")+" 안경 가공이 완료되었습니다. 전광판을   확인 해 주세요";
    speechSynthesis.speak(msg);
    alarmPopup(maskingName('다비치'),9337,'0001');
    msg.onend = function(event) {
   		$("#alarmPopup").html("");
   	  } 
}

$(document).ready(function() {
	setInterval(function(){		
		fn_stand_by_list();
		ttsList();
		}, 
	5000);
	
	 $("#test2").click(function () {
		 ttsTest2();
	});
	 
	$("#speed").click(function(){
		$("#speedRate").text($("#speed").val()); 
	});
	
	$("#speed").click(function(){
		$("#speedRate").text($("#speed").val()); 
	});
	
	$("#close").click(function(){
		$(".option").css("display","none");
		$("#open").css("display","");
	});
	$("#open").click(function(){
		$(".option").css("display","");
		$("#open").css("display","none");
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
</script>
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