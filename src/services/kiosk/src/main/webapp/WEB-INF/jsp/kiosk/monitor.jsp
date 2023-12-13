<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
var v_tot_page_index = 1;
function fn_stand_by_list(){
	$.ajax({
		type : "POST",
		url : "/kiosk/standByXml.do",    	
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
					tot_append_str += "	<td>"+$("seq_no",this).text()+"</td>";
					tot_append_str += "	<td class=\"textL\">"+$("nm_cust",this).text()+"</td>";
					tot_append_str += "	<td class=\"textL\">"+$("purpose",this).text()+"</td>";
					var status = Number($("status",this).text());
					for(var i=0;i<=status;i++){
						if(status == 0){
							tot_append_str += "	<td class=\"waiting\"></td>";							
						}else{
							tot_append_str += "	<td class=\"going\"></td>";	
						}
					}
					for(var i=0;i<5-status;i++){
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
<div id="wrap2" class="bgwhite">
	<div id="header" class="bdr_none">
		<span class="logo">다비치안경체인</span>
		<h1 class="standby2">대기고객현황</h1>
		<p class="leftPageNo h1_btm">페이지: <span id = pageNo></span>/<span id = totalPageNo></span> </p>
		<p class="h1_btm">다비치에 방문하신 것을 환영합니다!  </p>
		<p class="rightCnt h1_btm">현재 대기고객 수:<span id="cnt"></span>명  </p>
	</div>
	<div id="content_wrap" class="monitor-wrap">
		<div class="content">
			<div class="table_wrap02">
				<table class="tb_type04">
					<caption>
						<h1 class="blind">고객명단 제목</h1>
					</caption>
					<colgroup>
						<col style="width:6%">
						<col style="width:19.6%">
						<col style="width:19.6%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:8%">
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
						<col style="width:19.6%">
						<col style="width:19.6%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:7.8%">
						<col style="width:8%">
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