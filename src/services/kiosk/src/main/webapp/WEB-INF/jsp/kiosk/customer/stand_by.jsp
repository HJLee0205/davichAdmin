<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_show_stand(v_nm_cust, v_dates, v_str_code, v_times){	
	$('#del_name').html(v_nm_cust);
	$('#dates').val(v_dates);
	$('#str_code').val(v_str_code);
	$('#times').val(v_times);
	$('.popup01').show();
}

function fn_hide_stand(){
	$('#del_name').html('');
	$('#dates').val('');
	$('#str_code').val('');
	$('#times').val('');
	$('.popup01').hide();
}

function fn_stand_del(){
	$.ajax({
		type : "POST",
		url : "/kiosk/standByFlagUpdate.do",    	
		data : {
			dates 	 : $('#dates').val(),
			str_code : $('#str_code').val(),
			times 	 : $('#times').val(),
			flag 	 : '2'
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
			fn_stand_by_list();
			fn_hide_stand();
		}
	});
}

function fn_stand_by_list(){
	$.ajax({
		type : "POST",
		url : "/kiosk/standByXmlAll.do",    	
		data : {
			store_no : $('#store_no').val()
		},
		dataType : "xml",
		success : function(result) {
			var v_tot_cnt = $(result).find('tot_cnt').text();
			var v_n_cnt = $(result).find('n_cnt').text();
			var v_y_cnt = $(result).find('y_cnt').text();
			
			$("#tot_cnt").html(v_tot_cnt);	
			$("#n_cnt").html(v_n_cnt);	
			$("#y_cnt").html();	
			
			$('#n_booking_list').find("tr").remove();
			
			var cnt = 1;
			var n_append_str = "";
			if(v_n_cnt == 0 ){
				n_append_str = "<tr>";
				n_append_str += "	<td colspan='3'><b>고객이 없습니다.</b></td>";
				n_append_str += "</tr>";				
				$('#n_booking_list').append(n_append_str);
			}else{				
				$("n_row",result).each(function(){
					n_append_str = "<tr onclick=\"fn_show_stand('"+$("nm_cust",this).text()+"','"+$("dates",this).text()+"','"+$("str_code",this).text()+"','"+$("times",this).text()+"')\">";
					n_append_str += "	<td>"+cnt+"</td>";
					n_append_str += "	<td><b>"+$("nm_cust",this).text()+"</b></td>";
					n_append_str += "	<td>"+$("purpose",this).text()+"</td>";
					n_append_str += "</tr>";				
					$('#n_booking_list').append(n_append_str);
					cnt++;
				});
			}			
			
			cnt = 1;
			$('#y_booking_list').find("tr").remove();
			
			var y_append_str = "";
			if(v_y_cnt == 0 ){
				y_append_str = "<tr>";
				y_append_str += "	<td colspan='4'><b>고객이 없습니다.</b></td>";
				y_append_str += "</tr>";				
				$('#y_booking_list').append(y_append_str);
			}else{				
				$("y_row",result).each(function(){
					
					var v_book_time = $("book_time",this).text().substring(0,2) + ":" + $("book_time",this).text().substring(2,4);
					
					y_append_str = "<tr onclick=\"fn_show_stand('"+$("nm_cust",this).text()+"','"+$("dates",this).text()+"','"+$("str_code",this).text()+"','"+$("times",this).text()+"')\">";
					y_append_str += "	<td>"+cnt+"</td>";
					y_append_str += "	<td><b>"+$("nm_cust",this).text()+"</b></td>";
					y_append_str += "	<td>"+$("purpose",this).text()+"</td>";
					y_append_str += "	<td>"+v_book_time+"</td>";
					y_append_str += "</tr>";				
					$('#y_booking_list').append(y_append_str);
					cnt++;
				});
			}
		},
		error : function(result, status, err) {
			alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
		},
		beforeSend: function() {
		    
		},
		complete: function(){
			
		}
	});
}
</script>
<input type="hidden" name="dates" id="dates" value="">
<input type="hidden" name="str_code" id="str_code" value="">
<input type="hidden" name="times" id="times" value="">

<div id="wrap">
	<div id="header" class="bdr_none">
		<a href="/kiosk/start.do" class="go_back">이전</a>
		<h1 class="standby">대기고객 관리</h1>
		<span class="total">전체 대기인원 <em id="tot_cnt">${tot_cnt}</em></span>
	</div>
	<div id="content_wrap">
		<div class="content">
			<div class="table_wrap_left" style="width: 100%">
				<table class="tb_type02">
					<caption>
						<h1 class="blind">일반대기 고객명단</h1>
					</caption>
					<colgroup>
						<col style="width:15%">
						<col style="width:35%">
						<col style="">
					</colgroup>
					<thead>
						<tr>
							<th colspan="3">일반대기 (<em id="n_cnt">${n_cnt}</em>)</th>
						</tr>
					</thead>
					<tbody id="n_booking_list">
					<c:forEach var="result" items="${list}" varStatus="status">
						<tr onclick="fn_show_stand('${result.nm_cust}','${result.dates}','${result.str_code}','${result.times}')">
							<td>${status.count}</td>
							<td><b>${result.nm_cust}</b></td>
							<td>${result.purpose}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div><!-- //table_wrap_left-->
			<%-- <div class="table_wrap_right">
				<table class="tb_type03">
					<caption>
						<h1 class="blind">예약대기 고객명단</h1>
					</caption>
					<colgroup>
						<col style="width:15%">
						<col style="width:34%">
						<col style="width:33%">
						<col style="">
					</colgroup>
					<thead>
						<tr>
							<th colspan="4">예약대기 (<em id="y_cnt">${y_cnt}</em>)</th>
						</tr>
					</thead>
					<tbody id="y_booking_list">
						<c:forEach var="result" items="${listY}" varStatus="status">
							<tr onclick="fn_show_stand('${result.nm_cust}','${result.dates}','${result.str_code}','${result.times}')">
								<td>${status.count}</td>
								<td><b>${result.nm_cust}</b></td>
								<td>${result.purpose}</td>
								<td>${fn:substring(result.book_time,0,2)}:${fn:substring(result.book_time,2,4)}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div> --%><!-- //table_wrap_right-->

		</div><!-- //content -->
	
		<!-- <a class="pop_alert">대기목록 삭제팝업(PPT참조)</a> -->
		
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	
<div id="footer">
	<span class="logo">다비치안경체인</span>
</div><!---//footer --->
<div class="popup01" style="display:none;">
	<button type="button" class="btn_close_popup" onclick="fn_hide_stand();">창닫기</button>
	<div class="inner cancel" style="display:;">
		<div class="popup_body"> 
			<p class="pop_txt1">
				<em id="del_name"></em>님을<br/>
				대기고객 목록에서 삭제할까요?
			</p>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01" onclick="fn_hide_stand();">아니오</button>
			<button type="button" class="btn_pop02" onclick="fn_stand_del();">예</button>
		</div>
	</div>
</div><!-- //popup01 -->