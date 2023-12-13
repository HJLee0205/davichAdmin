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
	function fn_select_step1(step1_cd, idx){			
		var step1_target = 'check_list';			
		
		$('.'+step1_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+step1_target).find('li:eq('+idx+')').addClass('active');
		
		$('#step1Cd').val(step1_cd);
	}
	

	
	// 추천결과보기
	$(".btn_view_recomm").click(function(){                	
    	
		//data setting
		if($("#step1Cd").val() == ''){
			Dmall.LayerUtil.alert("착용여부를 선택해 주세요.","확인");
			return false;
		}
		
		if($('#step1Cd').val() == '01' || $('#step1Cd').val() == '10'){
			if($('#step1Cd').val() == '01'){
				$('#step2Cd').val('01');
			}else if($('#step1Cd').val() == '10'){
				$('#step2Cd').val('10');
			}
		}
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
        
        if($('#step1Cd').val() == '01'){
        	Dmall.FormUtil.submit('/front/vision/vision-check2-s3', param);
        }else{
        	Dmall.FormUtil.submit('/front/vision/vision-check2-s2', param);	
        }
		
			
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
			<input type="hidden" name="step1Cd" id="step1Cd" value="">
			<input type="hidden" name="step2Cd" id="step2Cd" value="">
        </form:form>
		<div class="lens_type_area">

			<!-- 안경렌즈영역 -->
			<div id="g_type_area" style="display: block;">
				<!-- 2안경착용 여부 -->
				<div class="g_type_step1">
					<c:if test="${visionStepVO.visionGb == 'G'}"><h3>안경을 착용 하시나요?</h3></c:if>
					<c:if test="${visionStepVO.visionGb == 'C'}"><h3>콘택트렌즈를 착용 하시나요?</h3></c:if>
					<ul class="check_list l2">
						<c:forEach var="result" items="${step1List}" varStatus="status">
							<li onclick="fn_select_step1('${result.step1Cd}', ${status.count-1});">
								<img src="${_SKIN_IMG_PATH}/vision/img_vision_step1_${result.step1Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step1Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm">다음</button>
					</div>
				</div>
				<!-- //2안경착용 여부 -->			
			</div>
			<!-- //안경렌즈영역 -->			
		</div>
	</t:putAttribute>
</t:insertDefinition>