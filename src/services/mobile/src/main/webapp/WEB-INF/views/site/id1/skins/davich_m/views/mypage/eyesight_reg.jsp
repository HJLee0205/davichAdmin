<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">내시력정보</t:putAttribute>

    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
    <style>
    	.btn_davichi_area button {
    		width: 30%;
    	}
    	.btn_davichi_area button:nth-child(2) {
    		margin-right: 3%;
    	}
    </style>
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	$("#btn_cancel_eyesight_reg").on("click", function() {
    		// view 화면으로 이동
    		document.location.href = "${_MOBILE_PATH}/front/mypage/eyesight";
    	});
    	$("#btn_save_eyesight").on("click", function() {
    		// 저장
    		var url = "${_MOBILE_PATH}/front/mypage/eyesight_reg";
    		var param = $("#eyesight_form").serialize();
    		Dmall.AjaxUtil.getJSON(url, param, function(result) {
    			if(result.success) {
    				document.location.href = "${_MOBILE_PATH}/front/mypage/eyesight";
    			}
    		});
    	});
    	$("#btn_store_eyesight").on("click", function() {
    		// 다비치 안경점 시력 정보 조회
    		var url = "${_MOBILE_PATH}/front/mypage/store_eyesight";
    		var param = "";
    		Dmall.AjaxUtil.getJSON(url, param, function(result) {
    			console.log(result);
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
    

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			시력정보 등록/수정
		</div>
		<div class="cont_body">		
			<form id="eyesight_form">	
				<ul class="my_eye_date">
					<li>
						<p class="tit"><span class="dot">검사일</span></p>
						<p class="text"><input type="text" class="date datepicker" name="checkupDt" value="${eyesightInfo.checkupDt}" readonly></p>
						<style type="text/css">
							.ui-datepicker	{left:20%;}
						</style>
					</li>
					<li>
						<p class="tit"><span class="dot">검사기관</span></p>
						<p class="text"><input type="text" class="form_agency" name="checkupInstituteNm" value="${eyesightInfo.checkupInstituteNm}"></p>
					</li>
				</ul>
				<table class="tProduct_Board my_davich">
					<caption>
						<h1 class="blind">내 시력정보 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:30%">
						<col style="width:35%">
						<col style="width:35%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>R</th>
							<th>L</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>SPH</th>
							<td><input type="text" class="form_vision" name="sphR" value="${eyesightInfo.sphR}"></td>
							<td><input type="text" class="form_vision" name="sphL" value="${eyesightInfo.sphL}"></td>
						</tr>
						<tr>
							<th>CYL</th>
							<td><input type="text" class="form_vision" name="cylR" value="${eyesightInfo.cylR}"></td>
							<td><input type="text" class="form_vision" name="cylL" value="${eyesightInfo.cylL}"></td>
						</tr>
						<tr>
							<th>AXIS</th>
							<td><input type="text" class="form_vision" name="axisR" value="${eyesightInfo.axisR}"></td>
							<td><input type="text" class="form_vision" name="axisL" value="${eyesightInfo.axisL}"></td>
						</tr>
						<tr>
							<th>PRISM</th>
							<td><input type="text" class="form_vision" name="prismR" value="${eyesightInfo.prismR}"></td>
							<td><input type="text" class="form_vision" name="prismL" value="${eyesightInfo.prismL}"></td>
						</tr>
						<tr>
							<th>BASE</th>
							<td><input type="text" class="form_vision" name="baseR" value="${eyesightInfo.baseR}"></td>
							<td><input type="text" class="form_vision" name="baseL" value="${eyesightInfo.baseL}"></td>
						</tr>
						<tr>
							<th>ADD</th>
							<td><input type="text" class="form_vision" name="addR" value="${eyesightInfo.addR}"></td>
							<td><input type="text" class="form_vision" name="addL" value="${eyesightInfo.addL}"></td>
						</tr>
						<tr>
							<th>PD</th>
							<td><input type="text" class="form_vision" name="pdR" value="**"></td>
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
		</div><!-- //cont_body -->

	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    </t:putAttribute>
</t:insertDefinition>