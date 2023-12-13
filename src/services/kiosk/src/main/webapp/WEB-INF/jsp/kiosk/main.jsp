<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_login(){
	var v_str_code = trim($("#store_no").val());
	var v_login_id = trim($("#pop_login_id").val());
	var v_login_pw = trim($("#login_pw").val());
	
	if(v_str_code == ""){
		alert("매장코드가 없습니다.");
		document.location.href='/kiosk/login.do';
		return false;
	}
	
	if(v_login_id == ""){
		alert("아이디를 입력하세요.");
		$("#login_id").focus();
		return false;
	}
	
	if(v_login_pw == ""){
		alert("비밀번호를 입력하세요.");
		$("#login_pw").focus();
		return false;
	}
	
	$.ajax({
		type : "POST",
		url : "/kiosk/loginProc.do",    	
		data : {
			strCode : v_str_code,
			loginId : v_login_id,
			loginPw	: v_login_pw
		},
		dataType : "xml",
		success : function(result) {
			var rtn = "";
			var msg = "";
			$("row",result).each(function(){
				rtn = $("rtn",this).text();
				msg = $("msg",this).text();
			});
			
			if(rtn == "true"){
				document.location.href = "/kiosk/start.do";
			}else{
				alert(msg);
				$("#str_code").val('');
				$("#login_id").val('');
				$("#login_pw").val('');
				$("#str_code").focus();
			}
			
		},
		error : function(result, status, err) {
			alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+error);
		},
		beforeSend: function() {
		    
		},
		complete: function(){
		}
	});
}
</script>
<div id="wrap">
	<div id="header">
		<h1><span class="logo">다비치안경체인</span></h1>
		<a href="#" class="shop pop_shop_view">${loginVo.strName}</a>
	</div>
	<div id="content_wrap">
		<div class="content">
			<div id="main_visual">
			<div class="bx-wrapper">
				<div class="bx-viewport">
					<ul class="main_visual_slider" >
						<c:forEach var="result" items="${bannerList}" varStatus="status">
						<li><a href="#none"><img src="/kiosk/data_img/${result.file_nm}" alt="모바일메인비쥬얼${status.count}"></a></li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div><!-- //main_visual -->
			<div class="waiting_btn_wrap">
				<div class="waiting_btn01">
					<a href="javascript:alert('준비중입니다.');">
						<span class="txt">안경/렌즈 착용해보기</span>
						<p>가상착장</p>
						<span class="icon"></span>
						<span class="go"></span>
					</a>
				</div>
				<div class="waiting_btn02">
					<a href="/kiosk/customerSearch.do">
						<span>제품구매 또는 상담</span>
						<p>예약확인/접수</p>
						<span class="icon"></span>
						<span class="go"></span>
					</a>
				</div>
			</div>
		</div><!-- //content -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->	

<div class="popup01" style="display: block;">
	<button type="button" class="btn_close_popup">창닫기</button>
	<div class="inner cancel">
		<div class="popup_head">
			<h1 class="tit">${loginVo.strName}</h1>
		</div>
		<div class="popup_body"> 
			<ul class="pop_form">
				<li>
					<label for="">아이디</label>
					<input type="text" id="pop_login_id" name="pop_login_id">
				</li>
				<li>
					<label for="">비밀번호</label>
					<input type="password" id="login_pw" name="login_pw">
				</li>
			</ul>
		</div>
		<div class="popup_btn_area">
			<button type="button" type="button" class="btn_pop01" onclick="$('.popup01').hide();">취소</button>
			<button type="button" type="button" class="btn_pop02" onclick="fn_login();">확인</button>
		</div>
	</div>
</div><!-- //popup01 -->