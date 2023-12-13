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
		function fn_select_gb(vision_gb, idx){
			$('#visionGb').val(vision_gb);
			var gb_target = 'lens_type2';
			
			$('.'+gb_target).find('li').each(function(){
				$(this).removeClass('active');
			});
			$('.'+gb_target).find('li:eq('+idx+')').addClass('active');
			
			fn_get_age(vision_gb);
		}
		
		function fn_get_age(vision_gb){
			var url = "/front/vision/select-age-ajax";
            var param = {visionGb:vision_gb};
            Dmall.AjaxUtil.getJSON(url, param, function(data) {
            	$('.lens_age').empty();
            	var html = '';
            	for(var i=0;i<data.length;i++){
            		html +="<li onclick=\"fn_select_age('"+ data[i].ageCd +"', "+i+");\"><span ";
            		
            		if(vision_gb == 'G'){
            			if(data[i].ageCd == $("#memberAgeGcd").val()) html +="class='active'";
            		}else if(vision_gb == 'C'){
            			if(data[i].ageCd == $("#memberAgeCcd").val()) html +="class='active'";
            		}
            		
            		html +=">"+ data[i].ageNm +"</span></li>";
            	}
            	
            	$('.lens_age').html(html);
                $('.lens_age').show();
                
                if(vision_gb == 'G'){
                	$("#ageCd").val($("#memberAgeGcd").val());
                	$("#ageNm").val($("#memberAgeGcdNm").val());
                }else if(vision_gb == 'C'){
                	$("#ageCd").val($("#memberAgeCcd").val());
                	$("#ageNm").val($("#memberAgeCcdNm").val());
                }
            });
		}
	
		function fn_select_age(age_cd, idx){			
			var age_target = 'lens_age';			
			
			$('.'+age_target).find('li').each(function(){
				$(this).children('span').removeClass('active');
			});
			
			$('.'+age_target).find('li:eq('+idx+')').children('span').addClass('active');
			
			$('#ageCd').val(age_cd);
			
			var age_nm = $('.'+age_target).find('li:eq('+idx+')').children('span').text();			
			$('#ageNm').val(age_nm);
		}
		
		// 추천결과보기
		$(".btn_view_recomm").click(function(){                	
        	
			//data setting
			if($("#visionGb").val() == ''){
				Dmall.LayerUtil.alert("렌즈를 선택해 주세요.","확인");
				return false;
			}
			
			if($("#ageCd").val() == ''){
				Dmall.LayerUtil.alert("연령대를 선택해 주세요.","확인");
				return false;
			}
			
			var data = $('#form_vision_check').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
				param[obj.name] = obj.value;
			});
			
			Dmall.FormUtil.submit('/front/vision/vision-check2-s1', param);
				
        });
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<!--- 02.LAYOUT: 카테고리 메인 --->
	<c:set var="memberAgeGcd" value="01" />
	<c:set var="memberAgeGcdNm" value="20대 미만" />
	<c:set var="memberAgeCcd" value="10" />
	<c:set var="memberAgeCcdNm" value="10대" />
	<c:choose>
		<c:when test="${memberAge < 20}"><c:set var="memberAgeGcd" value="01" /><c:set var="memberAgeGcdNm" value="20대 미만" /></c:when>
		<c:when test="${memberAge >= 20 and memberAge < 39}"><c:set var="memberAgeGcd" value="02" /><c:set var="memberAgeGcdNm" value="20세 ~ 38세" /></c:when>
		<c:when test="${memberAge >= 39}"><c:set var="memberAgeGcd" value="03" /><c:set var="memberAgeGcdNm" value="39세 이상" /></c:when>
	</c:choose>
	<c:choose>
		<c:when test="${memberAge < 20}"><c:set var="memberAgeCcd" value="10" /><c:set var="memberAgeCcdNm" value="10대" /></c:when>
		<c:when test="${memberAge >= 20 and memberAge < 40}"><c:set var="memberAgeCcd" value="11" /><c:set var="memberAgeCcdNm" value="20 ~ 30대" /></c:when>
		<c:when test="${memberAge >= 40}"><c:set var="memberAgeCcd" value="12" /><c:set var="memberAgeCcdNm" value="40대 이상" /></c:when>
	</c:choose>	
	<input type="hidden" name="memberAgeGcd" id="memberAgeGcd" value="${memberAgeGcd}">
	<input type="hidden" name="memberAgeCcd" id="memberAgeCcd" value="${memberAgeCcd}">
	<input type="hidden" name="memberAgeGcd" id="memberAgeGcdNm" value="${memberAgeGcdNm}">
	<input type="hidden" name="memberAgeCcd" id="memberAgeCcdNm" value="${memberAgeCcdNm}">
    <div class="category_middle">
		<div class="lens_head">
			<h2 class="lens_tit">렌즈추천</h2>
		</div>
		<form:form id="form_vision_check" name="form_vision_check" method="post">
			<input type="hidden" name="visionGb" id="visionGb" value="${visionGb}">
			<c:choose>
				<c:when test="${visionGb == 'G'}">
					<input type="hidden" name="ageCd" id="ageCd" value="${memberAgeGcd}">
					<input type="hidden" name="ageNm" id="ageNm" value="${memberAgeGcdNm}">
				</c:when>
				<c:when test="${visionGb == 'C'}">
					<input type="hidden" name="ageCd" id="ageCd" value="${memberAgeCcd}">
					<input type="hidden" name="ageNm" id="ageNm" value="${memberAgeCcdNm}">
				</c:when>
				<c:otherwise>
					<input type="hidden" name="ageCd" id="ageCd" value="">
					<input type="hidden" name="ageNm" id="ageNm" value="">
				</c:otherwise>
			</c:choose>
        </form:form>
		<div class="lens_type_area">

			<!-- 안경렌즈영역 -->
			<div id="g_type_area" style="display: block;">
				<!-- 렌즈추천메인 -->
				<div class="g_type_main">
					<div class="lens_info_area">
						<p class="tit">나에게 맞는 렌즈는 어떤 것일까?</p>
						고객님의 나이와 생활환경을 고려하여 편안하게 착용하실 수 있는 최적의 렌즈를 추천해 드립니다.<br>
						추천 받으실 렌즈의 종류와 연령대를 선택해 주세요.
					</div>
					<ul class="lens_type2">
						<li <c:if test="${visionGb == 'G'}">class="active"</c:if> onclick="fn_select_gb('G', 0)">
							<img src="${_SKIN_IMG_PATH}/vision/img_vision_g.png">
							<span>안경렌즈<i></i></span>
						</li>
						<li <c:if test="${visionGb == 'C'}">class="active"</c:if> onclick="fn_select_gb('C', 1)">
							<img src="${_SKIN_IMG_PATH}/vision/img_vision_c.png">
							<span>콘택트 렌즈<i></i></span>
						</li>
					</ul>
					<!-- 1안경렌즈 연령대 -->
					<ul class="lens_age glass_age">
						<c:forEach var="result" items="${ageList}" varStatus="status">
							<li onclick="fn_select_age('${result.ageCd}', ${status.count-1});">
								<span 
									<c:choose>
										<c:when test="${visionGb == 'G'}">
											<c:if test="${memberAgeGcd == result.ageCd}">class="active"</c:if>
										</c:when>
										<c:when test="${visionGb == 'C'}">
											<c:if test="${memberAgeCcd == result.ageCd}">class="active"</c:if>
										</c:when>
									</c:choose>
								>${result.ageNm}</span>
							</li>
						</c:forEach>
					</ul>
					<!--// 1안경렌즈 연령대 -->
					<div class="btn_lens_area">
						<button type="button" class="btn_view_recomm">다음</button>
					</div>
				</div>
				<!-- //렌즈추천메인 -->					
			</div>
			<!-- //안경렌즈영역 -->			
		</div>
	</t:putAttribute>
</t:insertDefinition>