<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_banner(){
	document.kioskForm.action="/kiosk/bannerList.do";
	document.kioskForm.submit();
}
function fn_message(){
	document.kioskForm.action="/kiosk/messageList.do";
	document.kioskForm.submit();
}

function fn_call_time(){
	document.kioskForm.action="/kiosk/callTime.do";
	document.kioskForm.submit();
}

function fn_banner_view(v_banner_no){
	$(".popup01").show();
	$("#banner_no").val(v_banner_no);
}

function fn_banner_save(){
	var v_str_code = $("#store_no").val();
	var v_banner_no = $("#banner_no").val();
	
	if( $("#attach_file").val() == "" ){
		alert("이미지를 선택해주세요.");
		return false;
	}
	
	if( $("#attach_file").val() != "" ){
		// 사이즈체크
        var maxSize  = 20 * 1024 * 1024    //20MB
        var fileSize = 0;
		var file = document.kioskForm.attach_file;
		
		// 브라우저 확인
		var browser=navigator.appName;
		// 익스플로러일 경우
		if (browser=="Microsoft Internet Explorer"){
			var oas = new ActiveXObject("Scripting.FileSystemObject");
			fileSize = oas.getFile( file.value ).size;
		}else{// 익스플로러가 아닐경우
			fileSize = file.files[0].size;
		}
		
		if(fileSize > maxSize){
            alert("첨부파일 사이즈는 20MB 이내로 등록 가능합니다.");
            $("#attach_file").replaceWith($("#attach_file").clone(true));
            return false;
        }
	}
	
	var formData = new FormData();
	formData.append("str_code", v_str_code);	
	formData.append("banner_no", v_banner_no);	
	for(var i=0; i<$("input[name=attach_file]").length; i++){
		formData.append("attach_file"+i,$("input[name=attach_file]")[i].files[0]);
	}
	
	$.ajax({
		type : "POST",
		url  : "/kiosk/managerBanner.do",   
		data : formData,
		processData: false,
	    contentType: false,
		dataType : "xml",
		success : function(result) {			
		},
		error : function(result, status, err) {
			alert(result.status + " / " + status + " / " + err);
		},
		beforeSend: function() {
		    
		},
		complete: function(){
			fn_banner();
		}
	});
}

function fn_is_view(obj, v_banner_no){
	var v_is_view = "N";
	var v_msg = "";
	
	if(obj.checked == true){
		v_is_view = "Y";
		v_msg = "보여주기로 설정하였습니다.";
	}else{
		v_is_view = "N";
		v_msg = "보여주기를 취소하였습니다.";
	}
	
	$.ajax({
		type : "POST",
		url : "/kiosk/managerBannerIsView.do",    	
		data : {
			str_code : $('#store_no').val(),
			banner_no: v_banner_no,
			is_view	 : v_is_view
		},
		dataType : "xml",
		success : function(result) {
			alert(v_msg);
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

function fn_banner_del(v_banner_no){
	if(confirm("삭제하시겠습니까?")){
		$.ajax({
			type : "POST",
			url : "/kiosk/managerBannerDel.do",    	
			data : {
				str_code : $('#store_no').val(),
				banner_no: v_banner_no
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
				fn_banner();
			}
		});
	}
}
</script>
<div id="wrap">
	<div id="header" class="bdr_none">
		<a href="/kiosk/start.do" class="go_back">이전</a>
		<h1 class="standby">화면설정</h1>
	</div>
	<div id="content_wrap">
		<div class="content">
			<ul class="tab_wrap">
				<li class="active"><a href="#none" onclick="fn_banner();">대기화면</a></li>
				<li><a href="#none" onclick="fn_message();">안내문구</a></li>
				<li><a href="#none" onclick="fn_call_time();">호출타임</a></li>
			</ul>
			<div class="setting_commnet">
				대기화면용 이미지를 등록해 주세요.<br>‘보여주기’에 체크한 이미지만 돌아가며 공개됩니다.
			</div>
			<ul class="banner_add">
				<c:set var="cnt" value="0"></c:set>
				<c:forEach var="result" items="${bannerList}" varStatus="status">
					<li>
						<div class="thum_img" onclick="fn_banner_view(${result.banner_no});"><img src="/kiosk/data_img/${result.file_nm}"></div>
						<div class="thum_select">
							<input type="checkbox" name="thum_check" id="thum_check${status.count}" class="thum_check" <c:if test="${result.is_view == 'Y'}">checked</c:if> onclick="fn_is_view(this, ${result.banner_no});">
							<label for="thum_check${status.count}"><span></span>보여주기</label>
						</div>
						<div class="thum_del" onclick="fn_banner_del(${result.banner_no})">삭제하기</div>
					</li>
					<c:set var="cnt" value="${status.count}"></c:set>
				</c:forEach>
				<c:if test="${cnt < 6}">
					<c:forEach var="i" begin="${cnt+1}" end="6" step="1">
						<li>
							<div class="thum_img" onclick="fn_banner_view(0);"></div>
						</li>
					</c:forEach>
				</c:if>
			</ul>
		</div><!-- //content -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->
<div class="popup01" style="display: block;">
	<button type="button" class="btn_close_popup" onclick="$('.popup01').hide(); $('#banner_no').val(0);">창닫기</button>
	<div class="inner cancel">
		<div class="popup_head">
			<h1 class="tit">이미지 등록</h1>
		</div>
		<div class="popup_body"> 
			<ul class="pop_form">
				<li>					
					<input type="file" id="attach_file" name="attach_file" class="upload">
					<input type="hidden" id="banner_no" name="banner_no" value="0">
				</li>
			</ul>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01" onclick="$('.popup01').hide(); $('#banner_no').val(0);">취소</button>
			<button type="button" class="btn_pop02" onclick="fn_banner_save();">등록</button>
		</div>
	</div>
</div><!-- //popup01 -->