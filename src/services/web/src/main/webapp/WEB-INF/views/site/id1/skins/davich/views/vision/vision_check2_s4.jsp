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
	function fn_select_step4(obj){			
		if($(obj).hasClass('active')){
			$(obj).removeClass('active');		
		}else{
			$(obj).addClass('active');
		}
		
		var target = 'check_list';
		var step4Cd = '';
   		var relateActivity = '';
   		
		$('.'+target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(step4Cd != '') step4Cd += ',';
				step4Cd += $(this).attr('data-step4Cd');
				
				if(relateActivity != '') relateActivity += ',';
				relateActivity += $(this).children('span').text();
			}
		});
		
		$("#step4Cd").val(step4Cd);
   		$('#relateActivity').val(relateActivity);
	}
	
	//다시하기	
	$(".btn_view_recomm2").click(function(){
		document.location.href="/front/vision/vision-check2";
	});
	
	// 추천결과보기
	$(".btn_view_recomm").click(function(){                	
    	
		//data setting
		if($("#step4Cd").val() == ''){
			if($("#visionGb").val() == 'G'){
				Dmall.LayerUtil.alert("라이프 스타일을 선택해 주세요.","확인");
			}else if($("#visionGb").val() == 'C'){
				Dmall.LayerUtil.alert("불편한점을 선택해 주세요.","확인");
			}
			return false;
		}		
		
		var checkNo = '';
		var target = 'check_list';
		
		if($("#visionGb").val() == 'G'){
			
			$('.'+target).find('li').each(function(){
				if($(this).hasClass('active')){
					if(checkNo != '') checkNo += ",";
  					checkNo += $(this).attr('data-checkNo');
				}
			});			

			$("#checkNos").val(checkNo);
        }
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
		
        if($("#visionGb").val() == 'G'){
			Dmall.FormUtil.submit('/front/vision/recommend-lens2', param);
        }else if($("#visionGb").val() == 'C'){
        	Dmall.FormUtil.submit('/front/vision/vision-check2-s5', param);
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
			<input type="hidden" name="step1Cd" id="step1Cd" value="${visionStepVO.step1Cd}">
			<input type="hidden" name="step2Cd" id="step2Cd" value="${visionStepVO.step2Cd}">
			<input type="hidden" name="step3Cd" id="step3Cd" value="${visionStepVO.step3Cd}">
			<input type="hidden" name="step4Cd" id="step4Cd" value="">			
			<input type="hidden" name="step10Cd" id="step10Cd" value="${visionStepVO.step10Cd}">	
			<input type="hidden" name="checkNos" id="checkNos" value="">
			<input type="hidden" name="relateActivity" id="relateActivity" value="">
        </form:form>
		<div class="lens_type_area">			
			<!-- 안경렌즈영역 -->
			<div id="g_type_area" style="display: block;">
				<c:if test="${visionStepVO.visionGb == 'G'}">
				<!-- 3안경착용시 불편사항 -->
				<div class="g_type_step2">
					<h3>해당하는 라이프 스타일을 모두 선택 해 주세요.</h3>
					<ul class="check_list">
						<c:forEach var="result" items="${step4List}" varStatus="status">
							<li onclick="fn_select_step4(this);" data-step4Cd="${result.step4Cd}" data-checkNo="${result.checkNos}">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step4_${result.step4Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step4Nm}<i></i></span>
							</li>
						</c:forEach>
					</ul>
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm2">다시하기</button>
						<button type="button" class="btn_view_recomm">결과보기</button>
					</div>
				</div>
				<!-- //3안경착용시 불편사항 -->
				</c:if>
				
				<c:if test="${visionStepVO.visionGb == 'C'}">
				<!-- 3콘택트렌즈종류 -->
				<div class="c_type_step1">
					<h3>콘택트렌즈 착용 시 어떤 점이 불편하신가요?</h3>
					<ul class="check_list">
						<c:forEach var="result" items="${step4List}" varStatus="status">
							<li onclick="fn_select_step4(this);" data-step4Cd="${result.step4Cd}">
								<img  src="${_SKIN_IMG_PATH}/vision/img_vision_step4_${result.step4Cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>${result.step4Nm}</span>
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