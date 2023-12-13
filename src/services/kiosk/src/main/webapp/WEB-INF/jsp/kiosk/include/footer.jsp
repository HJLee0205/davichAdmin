<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<div id="footer">
	<%-- <c:choose>
	    <c:when test="${checkData == true}">
	    	<button type="button" class="btn_home" onclick="document.location.href='/kiosk/start.do'">홈화면</button>
	    </c:when>
	    <c:otherwise> --%>
	    	<button type="button" class="btn_home" onclick="document.location.href='/kiosk/customerSearch.do'">첫화면</button>
	    <%-- </c:otherwise>
	</c:choose> --%>
	<span class="logo" style="color:white;">다비치안경체인</span>
	<!-- <button type="button" class="btn_alram pop_alram" onclick="fn_booking_call('Y')">직원호출</button> -->
	<button type="button" class="btn_home2" onclick="document.location.href='/kiosk/start.do'">메인화면</button>
</div><!--//footer -->
<div class="popup01" style="display: block;">
	<button type="button" class="btn_close_popup">창닫기</button>
	<!-- 직원호출 클릭시 -->
	<div class="inner cancel" style="display:;">
		<div class="popup_body"> 
			<p class="pop_txt1">
				직원을 호출하였습니다.<br>잠시만 기다려 주세요.
			</p>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01" onclick="fn_booking_call('N')">호출취소</button>
			<button type="button" class="btn_pop02" onclick="$('.popup01').hide();">확인</button>
		</div>
	</div>
	<!-- //직원호출 클릭시 -->
	<!-- 직원호출 중단완료시 -->
	<div class="inner cancel" style="display:none;">
		<div class="popup_body"> 
			<p class="pop_txt1">
				직원호출이 중단되었습니다.<br>
			</p>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01">다시호출</button>
			<button type="button" class="btn_pop02">확인</button>
		</div>
	</div>
	<!-- //직원호출 중단완료시 -->
	<!-- 직원호출 중단시 -->
	<div class="inner cancel" style="display:none;">
		<div class="popup_body"> 
			<p class="pop_txt1">
				직원 호출중입니다.<br>호출을 중단할까요?
			</p>
		</div>
		<div class="popup_btn_area">
			<button type="button" class="btn_pop01">아니오</button>
			<button type="button" class="btn_pop02">예</button>
		</div>
	</div>
	<!-- //직원호출 중단시 -->
</div><!-- //popup01 -->
<script type="text/javascript">
function fn_booking_call(v_call_yn){
	$.ajax({
		type : "POST",
		url : "/kiosk/bookingCall.do",    	
		data : {
			str_code : $('#store_no').val(),
			call_yn : v_call_yn
		},
		dataType : "xml",
		success : function(result) {
			
		},
		error : function(result, status, err) {
			alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+err);
		},
		beforeSend: function() {		    
		},
		complete: function(){
			
		}
	});
	
	if(v_call_yn == 'Y'){
		$(".pop_txt1").html("직원을 호출하였습니다.<br>잠시만 기다려 주세요.");
	}else{
		$(".pop_txt1").html("직원호출이 중단되었습니다.");
	}
}
</script>