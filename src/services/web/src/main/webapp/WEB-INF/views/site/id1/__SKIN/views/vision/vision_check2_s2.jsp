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
	function fn_select_step2_g(obj){			
		if($(obj).hasClass('active')){
			$(obj).removeClass('active');		
		}else{
			$(obj).addClass('active');
		}
		
		var target = 'check_list';
		var step2Cd = '';
		$('.'+target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(step2Cd != '') step2Cd += ',';
				step2Cd += $(this).attr('data-step2Cd');
			}
		});
		
		$("#step2Cd").val(step2Cd);
	}
	
	function fn_select_step2_c(step2_cd, idx){			
		var step2_target = 'check_list';			
		
		$('.'+step2_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+step2_target).find('li:eq('+idx+')').addClass('active');
		
		$('#step2Cd').val(step2_cd);
	}
	
	// 추천결과보기
	$(".btn_view_recomm").click(function(){                	
    	
		//data setting
		if($("#step2Cd").val() == ''){
			if($("#visionGb").val() == 'G'){
				Dmall.LayerUtil.alert("불편사항을 선택해 주세요.","확인");
			}else if($("#visionGb").val() == 'C'){
				Dmall.LayerUtil.alert("렌즈종류를 선택해 주세요.","확인");
			}
			return false;
		}
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
		
		Dmall.FormUtil.submit('/front/vision/vision-check2-s3', param);
			
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
			<input type="hidden" name="step2Cd" id="step2Cd" value="">
        </form:form>
		<div class="lens_type_area">

			<!-- 안경렌즈영역 -->
			<div id="g_type_area" style="display: block;">
				<c:if test="${visionStepVO.visionGb == 'G'}">
				<!-- 3안경착용시 불편사항 -->
				<div class="g_type_step2">
					<h3>안경 착용 시 어떤 점이 불편하신가요?</h3>
					<ul class="check_list">
						<c:forEach var="result" items="${step2List}" varStatus="status">
							<li onclick="fn_select_step2_g(this);" data-step2Cd="${result.step2Cd}">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step2_${result.step2Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step2Nm}<i></i></span>
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
					<h3>어떤 종류의 콘택트렌즈를 착용 하시나요?</h3>
					<ul class="check_list l2">
						<c:forEach var="result" items="${step2List}" varStatus="status">
							<li onclick="fn_select_step2_c('${result.step2Cd}', ${status.count-1});">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step2_${result.step2Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step2Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm">다음</button>
					</div>
				</div>
				<!-- //3콘택트렌즈종류 -->
				</c:if>
			</div>
			<!-- //안경렌즈영역 -->			
		</div>
	</t:putAttribute>
</t:insertDefinition>