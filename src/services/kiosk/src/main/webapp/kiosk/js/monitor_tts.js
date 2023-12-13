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
						tot_append_str += "	<td style='color:red; font-size:2rem;'>"+$("seq_no",this).text()+"</td>";
					}else{
						tot_append_str += "	<td style='font-size:2rem;'>"+$("seq_no",this).text()+"</td>";
						
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
		}
	});
}

function ttsList(){
	$.ajax({
		type : "POST",
		url : "/kiosk/selectStrBookingListTestComplete.do",    	
		data : {
			store_no : $('#store_no').val(),
			login_id : $('#login_id').val()
		},
		dataType : "xml",
		success : function(result) {
			_this.flag = false;
			var name = "";
			var seq_no = "";
			var phoneNum = "";
			$("tot_row",result).each(function(){
				if($("tts",this).text() == "1"){
					tts_01($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text(),$("book_yn",this).text());
				}else if($("tts",this).text() == "2"){
					tts_02($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text());
				}else{
					ttsTest($("nm_cust",this).text(),$("seq_no",this).text(),$("phoneNum",this).text());
				}
				
			})
		},
		error : function(result, status, err) {
		}
	});
}

$(document).ready(function() {
	
	setInterval(function(){		
		fn_stand_by_list();
		ttsList();
		}, 
	5000);
	
	 /*$("#test2").click(function () {
		 ttsTest2();
	});*/
	 
	/*$("#speed").click(function(){
		$("#speedRate").text($("#speed").val()); 
	});*/
	
	/*$("#close").click(function(){
		$(".option").css("display","none");
		$("#open").css("display","");
	});
	$("#open").click(function(){
		$(".option").css("display","");
		$("#open").css("display","none");
	});	*/
	
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

