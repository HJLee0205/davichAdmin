<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 비전체크</t:putAttribute>
	<t:putAttribute name="script">	
	<script type="text/javascript">
	function fn_select_step3_g(obj){			
		if($(obj).hasClass('active')){
			$(obj).removeClass('active');		
		}else{
			$(obj).addClass('active');
		}
		
		var target = 'check_list';
		var step3Cd = '';
		$('.'+target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(step3Cd != '') step3Cd += ',';
				step3Cd += $(this).attr('data-step3Cd');
			}
		});
		
		$("#step3Cd").val(step3Cd);
	}
	
	function fn_select_step3_c(step3_cd, idx){			
		var step3_target = 'check_list_3';			
		
		$('.'+step3_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+step3_target).find('li:eq('+idx+')').addClass('active');
		
		$('#step3Cd').val(step3_cd);
	}
	
	function fn_select_step10(step10_cd, idx){			
		var step10_target = 'check_list_10';			
		
		$('.'+step10_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+step10_target).find('li:eq('+idx+')').addClass('active');
		
		$('#step10Cd').val(step10_cd);
	}
	
	// 추천결과보기
	$(".btn_view_recomm").click(function(){                	
    	
		//data setting
		if($("#step3Cd").val() == ''){
			if($("#visionGb").val() == 'G'){
				Dmall.LayerUtil.alert("불편사항을 선택해 주세요.","확인");
			}else if($("#visionGb").val() == 'C'){
				Dmall.LayerUtil.alert("평균 착용시간을 선택해 주세요.","확인");
			}
			return false;
		}
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
		
		Dmall.FormUtil.submit('/front/vision/vision-check2-s4', param);
			
    });
	
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">
		<div class="lens_head">
			<h2 class="lens_tit">렌즈추천</h2>
		</div>
		<form:form id="form_vision_check" name="form_vision_check" method="post">
			<input type="hidden" name="visionGb" id="visionGb" value="${visionStepVO.visionGb}">
			<input type="hidden" name="ageCd" id="ageCd" value="${visionStepVO.ageCd}">
			<input type="hidden" name="ageNm" id="ageNm" value="${visionStepVO.ageNm}">
			<input type="hidden" name="step1Cd" id="step1Cd" value="${visionStepVO.step1Cd}">
			<input type="hidden" name="step2Cd" id="step2Cd" value="${visionStepVO.step2Cd}">
			<input type="hidden" name="step3Cd" id="step3Cd" value="">
			<input type="hidden" name="step10Cd" id="step10Cd" value="">			
        </form:form>
		<div class="lens_type_area">

			<!-- 안경렌즈영역 -->
			<div id="g_type_area" style="display: block;">
				<c:if test="${visionStepVO.visionGb == 'G'}">
				<!-- 3안경착용시 불편사항 -->
				<div class="g_type_step2">
					<h3>현재 시력에 불편한 점이 있으신가요?</h3>
					<ul class="check_list">
						<c:forEach var="result" items="${step3List}" varStatus="status">
							<li onclick="fn_select_step3_g(this);" data-step3Cd="${result.step3Cd}">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step3_${result.step3Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step3Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm">다음</button>
					</div>
				</div>
				<!-- //3안경착용시 불편사항 -->
				</c:if>
				
				<c:if test="${visionStepVO.visionGb == 'C'}">
				<!-- 3콘택트렌즈종류 -->
				<div class="c_type_step1">
					<h3>콘택트렌즈의 평균 착용시간은 얼마나 되시나요?</h3>
					<ul class="check_list check_list_3 l3">
						<c:forEach var="result" items="${step3List}" varStatus="status">
							<li onclick="fn_select_step3_c('${result.step3Cd}', ${status.count-1});">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step3_${result.step3Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step3Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<h3>콘택트렌즈 일주일 평균 착용 기간은 얼마나 되시나요?</h3>
					<ul class="check_list check_list_10 l3">
						<c:forEach var="result" items="${step10List}" varStatus="status">
							<li onclick="fn_select_step10('${result.step10Cd}', ${status.count-1});">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step10_${result.step10Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step10Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm">다음으로</button>
					</div>
				</div>
				<!-- //3콘택트렌즈종류 -->
				</c:if>
			</div>
			<!-- //안경렌즈영역 -->			
		</div>
	</t:putAttribute>
</t:insertDefinition>