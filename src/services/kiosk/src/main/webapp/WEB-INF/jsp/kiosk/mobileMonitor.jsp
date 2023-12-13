<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title></title>
	<meta name="viewport" content="initial-scale=1.0, width=device-width">
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">

<!-- 20190930  -->
	<link href="<c:url value='/kiosk/css/jquery-ui.min.css' />" rel="stylesheet" type="text/css"/>
	<link href="<c:url value='/kiosk/css/jquery.mobile-1.4.5.min.css' />" rel="stylesheet" type="text/css"/>
	<link href="<c:url value='/kiosk/css/mobile.css' />" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="<c:url value='/kiosk/js/jquery-1.7.1.js' />"></script>
	<script type="text/javascript">
	$(document).bind("mobileinit",function(){
		 $.support.touchOverflow = true;
		 $.mobile.touchOverflowEnabled = true;
	});
	</script>
	<c:if test = "${loginVo.loginId == '' || loginVo.loginId == null}">
	<script type="text/javascript">
		alert("로그인 하세요.");
		location.href = "/kiosk/login.do";
	</script>
	</c:if>
	<script type="text/javascript" src="<c:url value='/kiosk/js/jquery.mobile-1.4.5.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/kiosk/js/jquery-ui.min.js' />"></script>
	<style>
		th{font-size: 1rem !important; font-weight: bold !important;}
		td{font-size: 1rem !important;}
		#tot_booking_list tr:nth-child(odd)  {background-color : #fcfcfc !important;}
		td  {background : none !important;}
		
		.Button1 {
			box-shadow:inset 0px 1px 0px 0px #fff6af;
			background:linear-gradient(to bottom, #ffec64 5%, #ffab23 100%) !important;
			background-color:#ffec64 !important;
			border-radius:10px;
			border:1px solid #ffaa22;
			cursor:pointer;
			color:#333333;
			font-family:Arial;
			/* font-size:15px;
			font-weight:bold;
			text-decoration:none; */
			text-shadow:0px 1px 0px #ffee66;
		}
		.Button1:hover {
			background:linear-gradient(to bottom, #ffab23 5%, #ffec64 100%) !important;
			background-color:#ffab23 !important;
		}
		.Button1:active {
			position:relative;
			top:1px;
		}
		
		.Button2 {
			box-shadow:inset 0px 1px 0px 0px #f7c5c0;
			background:linear-gradient(to bottom, #fc8d83 5%, #e4685d 100%) !important;
			background-color:#fc8d83 !important;
			border-radius:10px;
			border:1px solid #d83526;
			cursor:pointer;
			color:#ffffff;
			font-family:Arial;
			font-size:15px;
			font-weight:bold;
			padding:6px 24px;
			text-decoration:none;
			text-shadow:0px 1px 0px #b23e35;
		}
		.Button2:hover {
			background:linear-gradient(to bottom, #e4685d 5%, #fc8d83 100%) !important;
			background-color:#e4685d !important;
		}
		.Button2:active {
			position:relative;
			top:1px;
		}
		
		.Button3 {
			box-shadow:inset 0px 1px 0px 0px #dcecfb;
			background:linear-gradient(to bottom, #bddbfa 5%, #80b5ea 100%) !important;
			background-color:#bddbfa !important;
			border-radius:15px;
			border:1px solid #84bbf3;
			cursor:pointer;
			color:#ffffff;
			font-family:Arial;
			font-size:15px;
			font-weight:bold;
			padding:6px 24px;
			text-decoration:none;
			text-shadow:0px 1px 0px #528ecc;
		}
		.Button3:hover {
			background:linear-gradient(to bottom, #80b5ea 5%, #bddbfa 100%) !important;
			background-color:#80b5ea !important;
		}
		.Button3:active {
			position:relative;
			top:1px;
		}
		.explainDiv{
			margin: 2px;
			border: 1px solid black;
		}
		.blueText{
			color:blue;
		}
	</style>
	
	<script type="text/javascript">
	var v_tot_page_index = 1;
	function fn_stand_by_list(){
		$.ajax({
			type : "POST",
			url : "/kiosk/standByMobileXml.do",    	
			data : {
				store_no : $('#store_no').val(),
				tot_page_index : v_tot_page_index
			},
			dataType : "xml",
			success : function(result) {
				$('#tot_booking_list').find("tr").remove();
				var cnt = 1;
				var tot_append_str = "";
				$("tot_row",result).each(function(){
					tot_append_str = "<tr>";
					if($("seq_no",this).text() == '예약'){
						tot_append_str += "	<td style='color:red;'>"+$("seq_no",this).text()+"</td>";
					}else{
						tot_append_str += "	<td>"+$("seq_no",this).text()+"</td>";
					}
					
					tot_append_str += "	<td style=\"font-weight:bold;\" class=\"textL\">"+$("nm_cust",this).text()+"</td>";
					var status = Number($("status",this).text());
					var times = $("times",this).text();
					var dates = $("dates",this).text();
					var seq_no =  $("seq_no",this).text();
					var seq_no3 =  $("seq_no3",this).text();
					var rsv_seq = $("rsv_seq",this).text();
					var cd_cust = $("cd_cust",this).text();
					var book_yn = $("book_yn",this).text();
					
					var statusNm = "";
					if(status == -1){
						statusNm = "예약"
					}
					if(status == 0){
						statusNm = "대기"
					}
					if(status == 1){
						statusNm = "상담시작"
					}
					if(status == 2){
						statusNm = "검사중"
					}
					if(status == 3){
						statusNm = "검사완료"
					}
					if(status == 4){
						statusNm = "상담중"
					}
					if(status == 5){
						statusNm = "상담완료"
					}
					if(status == 6){
						statusNm = "제조중"
					}
					if(status == 7){
						statusNm = "안경완성"
					}
					
					tot_append_str += "<td>"+statusNm+"</td>";
					
					//호출버튼
					if(status == 0 && book_yn =="Y"){
						//예약자 호출
						tot_append_str += "<td  class=\"resCall Button1\" times=\""+times+"\"  dates=\""+dates+"\" seq_no=\""+seq_no+"\" seq_no3=\""+seq_no3+"\" cd_cust=\""+cd_cust+"\">예약자 호출</td>";	
					}else{
						tot_append_str += "<td class=\"call Button2\" times=\""+times+"\"  dates=\""+dates+"\" seq_no=\""+seq_no+"\" seq_no3=\""+seq_no3+"\" cd_cust=\""+cd_cust+"\">호출</td>";
					}
					//안경완성 버튼
					if(status == 6){
						tot_append_str += "<td  class=\"complete Button3\" times=\""+times+"\"  dates=\""+dates+"\" cd_cust=\""+cd_cust+"\">선택</td>";	
					}else{
						tot_append_str += "<td></td>";
					}
					//퇴장 버튼
					tot_append_str += "<td  class=\"remove Button1\" times=\""+times+"\"  dates=\""+dates+"\">선택</td>";	
					
					
					tot_append_str += "</tr>";
				
					$('#tot_booking_list').append(tot_append_str);
					cnt++;
				});
			},
			error : function(result, status, err) {
				 console.log("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
			}
		});
	}


	$(document).ready(function() {
		var timer = "${ttsOptionVO.timer}";
		fn_stand_by_list();
		setInterval(function(){	
			fn_stand_by_list();
			}, 
		timer);
		//시간 값 디비 세팅후 처리 예정
		
		//퇴장처리
		$(document).on("click", ".remove", function() {
			$.ajax({
				type : "POST",
				url : "/kiosk/updateMallStrBookingFlag.do",    	
				data : {
					times : $(this).attr("times"),
					dates : $(this).attr("dates"),
					str_code : $('#store_no').val(),
				},
				dataType : "xml",
				success : function(result) {
					location.reload(true);
				},error : function(result, status, err) {
					console.log("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
				}
			});
		});
		
		//예약자 호출 버튼
		$(document).on("click", ".resCall", function() {
			$.ajax({
				type : "POST",
				url : "/kiosk/resCall.do",    	
				data : {
					times : $(this).attr("times"),
					seq_no : $(this).attr("seq_no"),
					seq_no3 : $(this).attr("seq_no3"),
					dates : $(this).attr("dates"),
					cd_cust : $(this).attr("cd_cust"),
					str_code : $('#store_no').val()
				},
				dataType : "xml",
				success : function(result) {
					if($("result",result).text() == "0"){
						alert("PUSH알림에 성공했습니다.");
					}else if($("result",result).text() == "1"){
						alert("PUSH알림에 실패했습니다. 알림 미동의 고객입니다.");
					}else if($("result",result).text() == "2"){
						alert("PUSH알림에 실패했습니다. 토큰값이 오류입니다.");
					}else{
						alert("PUSH알림에 실패했습니다.");
					}
					fn_stand_by_list();
					//location.reload(true);
				},
				error : function(result, status, err) {
					console.log("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
				}
			});
		});
		
		//간단호출 버튼
		$(document).on("click", ".call", function() {
			$.ajax({
				type : "POST",
				url : "/kiosk/simpleCall.do",    	
				data : {
					times : $(this).attr("times"),
					seq_no : $(this).attr("seq_no"),
					seq_no2 : $(this).attr("seq_no2"),
					seq_no3 : $(this).attr("seq_no3"),
					dates : $(this).attr("dates"),
					cd_cust : $(this).attr("cd_cust"),
					str_code : $('#store_no').val()
				},
				dataType : "xml",
				success : function(result) {
					if($("result",result).text() == "0"){
						alert("PUSH알림에 성공했습니다.");
					}else if($("result",result).text() == "1"){
						alert("PUSH알림에 실패했습니다. 알림 미동의 고객입니다.");
					}else if($("result",result).text() == "2"){
						alert("PUSH알림에 실패했습니다. 토큰값이 오류입니다.");
					}else{
						alert("PUSH알림에 실패했습니다.");
					}
					fn_stand_by_list();
					//location.reload(true);
				},
				error : function(result, status, err) {
					console.log("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
				}
			});
		});
		
		//안경완성 호출
		$(document).on("click", ".complete", function() {
			$.ajax({
				type : "POST",
				url : "/kiosk/complete.do",    	
				data : {
					times : $(this).attr("times"),
					dates : $(this).attr("dates"),
					cd_cust : $(this).attr("cd_cust"),
					str_code : $('#store_no').val(),
				},
				dataType : "xml",
				success : function(result) {
					if($("result",result).text() == "0"){
						alert("PUSH알림에 성공했습니다.");
					}else if($("result",result).text() == "1"){
						alert("PUSH알림에 실패했습니다. 알림 미동의 고객입니다.");
					}else if($("result",result).text() == "2"){
						alert("PUSH알림에 실패했습니다. 토큰값이 오류입니다.");
					}else{
						alert("PUSH알림에 실패했습니다.");
					}
					fn_stand_by_list();
					//location.reload(true);
				},
				error : function(result, status, err) {
					console.log("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
				}
			});
		});
		
	$(document).on("click", "#refresh", function() {
			location.reload(true);
		})
	});
	</script>
	
</head>
<body>
	<div id="mask"><div class="circle"></div></div>
	<jsp:include page="/WEB-INF/jsp/kiosk/header.jsp" />
	<input type="hidden" name="store_no" id="store_no" value="${loginVo.strCode}">
	<input type="hidden" name="login_id" id="login_id" value="${loginVo.loginId}">
	<div role="main" class="ui-content">
		<button id="refresh" style="width: 33%">새로고침</button>
		<div class="explainDiv">
			<span class="blueText">안경/선글라스</span> : 100~199번<br/>
			<span class="blueText">콘택트렌즈</span> : 200~299번<br/>
			<span class="blueText">AS/피팅/기타</span> : 300~399번<br/>
			<span class="blueText">예약방문</span> : 예약시간/방문시간<br/>
			<span class="blueText">제품 수령</span> : 1~99번
		</div>
		</br>
		<table class="tb_type04">
			<caption>
				<h1 class="blind">고객명단 제목</h1>
			</caption>
			<colgroup>
				<col style="width:10%">
				<col style="width:25">
				<col style="width:20%">
				<col style="width:15%">
				<col style="width:15%">
				<col style="width:15%;">
			</colgroup>
			<thead>
				<tr>
					<th>순번</th>
					<th class="textL">이름</th>
					<th class="stit">상태</th>
					<th class="stit">호출</th>
					<th class="stit">안경완성</th>
					<th class="stit">퇴장</th>
				</tr>
			</thead>
		</table>
		<table class="tb_type05">
			<caption>
				<h1 class="blind">고객명단 리스트</h1>
			</caption>
			<colgroup>
				<col style="width:10%">
				<col style="width:25">
				<col style="width:20%">
				<col style="width:15%">
				<col style="width:15%">
				<col style="width:15%">
			</colgroup>
			<tbody id="tot_booking_list"></tbody>
		</table>			
	</div> 
	</div><!-- /content -->
		<%-- <jsp:include page="/WEB-INF/jsp/kiosk/rightMenu.jsp" /> --%>
</body>


</html>