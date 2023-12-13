<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglibs.jsp"%>


<link rel="stylesheet" type="text/css" href="/kiosk/css/common.css" />
<link rel="stylesheet" type="text/css" href="/kiosk/css/content.css" />
<link rel="stylesheet" type="text/css" href="/kiosk/css/font.css" />
<link rel="stylesheet" type="text/css" href="/kiosk/css/mobile.css" />
<script type="text/javascript">
function fn_login(){
	var v_str_code = trim($("#str_code").val());
	var v_login_id = trim($("#login_id").val());
	var v_login_pw = trim($("#login_pw").val());
	
	if(v_str_code == ""){
		alert("매장코드를 입력하세요.");
		$("#str_code").focus();
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
		complete: function(result){
		}
	});
}
</script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Google Onscreen Keyboard API
     /*  google.load("elements", "1", {
          packages: "keyboard"
      });

      function onLoad() {
        var kbd = new google.elements.keyboard.Keyboard(
          [google.elements.keyboard.LayoutCode.KOREAN],
          ['login_id']);
      }
      
      google.setOnLoadCallback(onLoad); */
    </script>
    <style type="text/css">
    #kbd .goog-button{
    	width: 72px;
    	height: 72px;
    	border-radius: 10px;
    	font-size: 25px;
    }
    #K32{
   	 	width: 810px !important;
    }
    #K273{
   	 	width: 110px !important;
    }
    #K16{
    	width: 146px !impornt;
    }
    #K10{
    	width: 145px !impornt;
    }
    #K220{
    
    }
    </style>
<h1 class="login"><span>다비치 안경체인</span><p>고객맞이 시스템</p></h1>
<div id="login_box">	
	<ul class="login_form">
		<li><!-- 상단배경 --></li>
		<li>
			<p style="font-size:17px; color:red; font-weight: bold; text-align: center;" >※복층 매장의 경우 로그인 아이디를 서로 다르게 로그인해주세요.</p><br/>
			<label for="str_code">매장선택</label>
			<!-- input type="text" name="str_code" id="str_code" onkeypress="if( event.keyCode==13 ){$('#login_id').focus();}" class="icon_shop"-->
			<div class="select_login_wrap">
				<i>매장아이콘</i>
				<select name="str_code" id="str_code" class="select_login">
					<option value="">--선택--</option>
					<option value="8888">테스트점</option>
					<option value="9000">테스트2호점</option>
					<c:forEach var="result" items="${strList}" varStatus="status">
						<option value="${result.strCode}">${result.strName}</option>
					</c:forEach>
					<option value="8888">테스트점</option>
					<option value="4055">청라점</option>
				</select>
			</div>
		</li>
		<li>
			<label for="login_id">아이디</label>
			<input type="text" name="login_id" id="login_id" onkeypress="if( event.keyCode==13 ){$('#login_pw').focus();}" class="icon_id">
		</li>
		<li>
			<label for="login_pw">비밀번호</label>
			<input type="password" name="login_pw" id="login_pw" onkeypress="if( event.keyCode==13 ){fn_login();}" class="icon_pw">
		</li>
		<li>
			<input type="checkbox" name="purpost_check" id="purpose_check01" class="order_check">
			<label for="purpose_check01"><span></span>로그인정보 저장</label>
		</li>
		<li><button type="button" class="login_btn" onclick="fn_login();">로그인</button></li>
		<li><!-- 하단배경 --></li>
	</ul>		
</div><!---// login_box --->