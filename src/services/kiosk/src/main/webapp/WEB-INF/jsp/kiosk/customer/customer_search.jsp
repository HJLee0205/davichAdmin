<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>
<script type="text/javascript">
function fn_search(){
	var v_mobile = trim($('#mobile1').val()+""+$('#mobile2').val()+""+$('#mobile3').val());
	if(v_mobile == ""){
		alert("휴대전화번호를 입력하세세요.");
		$('#mobile1').focus();
	}else{

		var v_count = 0;
		var v_msg = "";
		
		$.ajax({
			type : "POST",
			url : "/kiosk/customerCheckCount.do",    	
			data : {
				store_no : $('#store_no').val(),
				mobile	 : insertTelHyphen(v_mobile)
			},
			dataType : "xml",
			success : function(result) {
				$("row",result).each(function(){
					v_count = $("count",this).text();
					v_msg = $("msg",this).text();
				});
			},
			error : function(result, status, err) {
				alert("code:"+result.status+"\n"+"message:"+result.responseText+"\n"+"error:"+error);
			},
			beforeSend: function() {
			    
			},
			complete: function(){	
				if(Number(v_count) > 0){
					if(v_msg == 'visit'){
						$('#mobile').val(insertTelHyphen(v_mobile));
						document.kioskForm.action="/kiosk/customerReservation.do";
						document.kioskForm.submit();
					}else{
						$('#mobile').val(insertTelHyphen(v_mobile));
						document.kioskForm.action="/kiosk/customerCheck.do";
						document.kioskForm.submit();
					}
				}else{
					$('#mobile').val(insertTelHyphen(v_mobile));
					document.kioskForm.action="/kiosk/customerFirst.do";
					document.kioskForm.submit();
				}			
			}
		});
	}
}

function fn_focus(obj, v_focus, v_length){
	if(obj.value.length == v_length){
		$('#'+v_focus).focus();
	}
}
</script>
<input type="hidden" name="mobile" id="mobile" value="">
<div id="wrap">
	<div id="content_wrap">		
		<div class="content">
			<div class="comment_head">
				안녕하세요. 다비치안경입니다.
			</div>
			<div class="comment_box">				
				예약확인 또는 접수를 위해 고객님의<br>휴대폰 번호 입력 후 '확인'을 눌러주세요.<br><br>
				<input type="text" class="sell_form" id="mobile1" name="mobile1" onkeyup="isNumberChk(this); fn_focus(this, 'mobile2', 3);" value="010" maxlength="3">
				<input type="password" class="sell_form" id="mobile2" name="mobile2" onkeyup="isNumberChk(this); fn_focus(this, 'mobile3', 4);" maxlength="4">
				<input type="text" class="sell_form" id="mobile3" name="mobile3" onkeyup="isNumberChk(this);" maxlength="4"><br>
			</div>
		</div><!-- //content -->
		<div class="comment_btn_area">
			<button type="button" class="btn_confirm" onclick="fn_search();">확인</button>
		</div><!-- ///comment_btn_area -->
	</div><!-- //content_wrap -->
</div><!-- //wrap -->