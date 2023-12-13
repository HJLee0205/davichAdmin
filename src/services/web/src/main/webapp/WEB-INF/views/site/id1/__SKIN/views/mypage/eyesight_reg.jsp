<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 시력정보</t:putAttribute>


 <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	$("#btn_cancel_eyesight_reg").on("click", function() {
    		// view 화면으로 이동
    		document.location.href = "/front/mypage/eyesight";
    	});
    	$("#btn_save_eyesight").on("click", function() {
    		// 저장
    		var url = "/front/mypage/eyesight_reg";
    		var param = $("#eyesight_form").serialize();
    		Dmall.AjaxUtil.getJSON(url, param, function(result) {
    			if(result.success) {
    				document.location.href = "/front/mypage/eyesight";
    			}
    		});
    	});
    	$("#btn_store_eyesight").on("click", function() {
    		// 다비치 안경점 시력 정보 조회
    		var url = "/front/mypage/store_eyesight";
    		var param = "";
    		Dmall.AjaxUtil.getJSON(url, param, function(result) {
    			if(result.success) {
    				var testDate = result.data.testDate;
    				if(testDate != null && testDate.length == 8) {
	    				var testYear = testDate.substring(0, 4);
	    				var testMonth = testDate.substring(4, 6);
	    				var testDay = testDate.substring(6, 8);
	    				testDate = testYear + "-" + testMonth + "-" + testDay;
    				}
    				
    				$("#eyesight_form").find("[name=checkupDt]").val(testDate);
    				$("#eyesight_form").find("[name=checkupInstituteNm]").val("다비치안경 " + result.data.testStrNm);
    				$("#eyesight_form").find("[name=sphL]").val(maskWord(result.data.sphL));
    				$("#eyesight_form").find("[name=sphR]").val(maskWord(result.data.sphR));
    				$("#eyesight_form").find("[name=cylL]").val(maskWord(result.data.cylL));
    				$("#eyesight_form").find("[name=cylR]").val(maskWord(result.data.cylR));
    				$("#eyesight_form").find("[name=axisL]").val(maskWord(result.data.axisL));
    				$("#eyesight_form").find("[name=axisR]").val(maskWord(result.data.axisR));
    				$("#eyesight_form").find("[name=prismL]").val(maskWord(result.data.prismL));
    				$("#eyesight_form").find("[name=prismR]").val(maskWord(result.data.prismR));
    				$("#eyesight_form").find("[name=baseL]").val(maskWord(result.data.baseL));
    				$("#eyesight_form").find("[name=baseR]").val(maskWord(result.data.baseR));
    				$("#eyesight_form").find("[name=addL]").val(maskWord(result.data.addL));
    				$("#eyesight_form").find("[name=addR]").val(maskWord(result.data.addR));
    				$("#eyesight_form").find("[name=pdL]").val("**");
    				$("#eyesight_form").find("[name=pdR]").val("**");
    			}
    		});
    	});
    });
    
    function maskWord(s) {
    	if(s == "") return
		var newString = '';
		var dot = false;
		var strArray = s.split("");
		
		if(s.indexOf(".") != -1){
			for(var i=0; i<strArray.length;i++){
				if(dot) newString += '*';
				else newString += strArray[i];
				
				if(strArray[i] == '.') dot = true;
			} 
		}else{
			newString = '**';		
		}
		
		return newString;
	}

    </script>
    </t:putAttribute>
    
    
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->
    
    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	
    
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
	            
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
				<div class="mypage_body">
					<h3 class="my_tit">시력정보 등록/수정</h3>
					
					<form id="eyesight_form">
						<ul class="my_eye_date">
							<li>
								<p class="tit"><span class="dot">검사일</span></p>
								<p class="form"><input type="text" name="checkupDt" class="date datepicker" value="${eyesightInfo.checkupDt}"></p>
							</li>
							<li>
								<p class="tit"><span class="dot">검사기관</span></p>
								<p class="form"><input type="text" name="checkupInstituteNm" class="form_agency" value="${eyesightInfo.checkupInstituteNm}"></p>
							</li>
						</ul>
						<table class="tProduct_Board">
							<caption>
								<h1 class="blind">내 시력정보 목록입니다.</h1>
							</caption>
							<colgroup>
								<col style="width:">
								<col style="width:125px">
								<col style="width:125px">
								<col style="width:125px">
								<col style="width:125px">
								<col style="width:125px">
								<col style="width:125px">
								<col style="width:125px">
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>SPH</th>
									<th>CYL</th>
									<th>AXIS</th>
									<th>PRISM</th>
									<th>BASE</th>
									<th>ADD</th>
									<th>PD</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>R</td>							
									<td><input type="text" class="form_vision" name="sphR" value="${eyesightInfo.sphR}"></td>
									<td><input type="text" class="form_vision" name="cylR" value="${eyesightInfo.cylR}"></td>
									<td><input type="text" class="form_vision" name="axisR" value="${eyesightInfo.axisR}"></td>
									<td><input type="text" class="form_vision" name="prismR" value="${eyesightInfo.prismR}"></td>
									<td><input type="text" class="form_vision" name="baseR" value="${eyesightInfo.baseR}"></td>
									<td><input type="text" class="form_vision" name="addR" value="${eyesightInfo.addR}"></td>
									<td><input type="text" class="form_vision" name="pdR" value="**"></td>
									
								</tr>
								<tr>
									<td>L</td>							
									<td><input type="text" class="form_vision" name="sphL" value="${eyesightInfo.sphL}"></td>
									<td><input type="text" class="form_vision" name="cylL" value="${eyesightInfo.cylL}"></td>
									<td><input type="text" class="form_vision" name="axisL" value="${eyesightInfo.axisL}"></td>
									<td><input type="text" class="form_vision" name="prismL" value="${eyesightInfo.prismL}"></td>
									<td><input type="text" class="form_vision" name="baseL" value="${eyesightInfo.baseL}"></td>
									<td><input type="text" class="form_vision" name="addL" value="${eyesightInfo.addL}"></td>
									<td><input type="text" class="form_vision" name="pdL" value="**"></td>	
								</tr>
							</tbody>
						</table>
					</form>				
	
					<div class="btn_davichi_area">
						<button type="button" class="btn_info_cancel" id="btn_cancel_eyesight_reg">취소</button>
						<button type="button" class="btn_info_modify" id="btn_save_eyesight">저장</button>
						<button type="button" class="btn_info_import" id="btn_store_eyesight">가져오기</button>
					</div>
				</div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
	</div>

    </t:putAttribute>
</t:insertDefinition>