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
	<t:putAttribute name="title">다비치마켓 :: 보청기 추천</t:putAttribute>
	<t:putAttribute name="script">	
	<script type="text/javascript">
		function fn_select_step1(obj){			
			if($(obj).hasClass('active')){
				$(obj).removeClass('active');		
			}else{
				$(obj).addClass('active');
			}
			
			var target = 'select_list';
			var step1Cd = '';
	   		var step1CdNm = '';
			var step1CdFlg = '';
			var relateActivity = '';
			
			$('#'+target).find('li').each(function(){
				if($(this).hasClass('active')){
					if(step1Cd != '') step1Cd += ',';
					step1Cd += $(this).attr('data-step1Cd');					
										
					if(step1CdFlg != '') step1CdFlg += ',';
					step1CdFlg += $(this).attr('data-step1CdFlg');
					
					if(relateActivity != '') relateActivity += ',';
					relateActivity += $(this).attr('data-step1CdActivity');
				}
			});
			
			$("#step1Cd").val(step1Cd);			
			$("#relateActivity").val(relateActivity);
			
			if($('#haUse').val() == "N"){
				if(step1Cd.indexOf("01,02") > -1 || step1Cd.indexOf("02,03") > -1 || step1Cd.indexOf("03,04") > -1 || step1Cd.indexOf("01,04") > -1){
					$("#step1CdFlg").val($("#step1Mix").val());
				}else{
					if(step1CdFlg.indexOf(",") > 0){
						var v_tmp = step1CdFlg.split(",");
						$("#step1CdFlg").val(v_tmp[0]);
					}else{
						$("#step1CdFlg").val(step1CdFlg);
					}
				}
			}else{
				$("#step1CdFlg").val(step1CdFlg);
			}
		};
		
		// 추천결과보기
		$(".btn_view_recomm").click(function(){                	
        	
			//data setting
			if($("#haUse").val() == ''){
				Dmall.LayerUtil.alert("보청기 경험을 선택해 주세요.","확인");
				return false;
			}
			
			var data = $('#form_ha_check').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
				param[obj.name] = obj.value;
			});
			
			Dmall.FormUtil.submit('/front/hearingaid/hearingaid-check-s2', param);
				
        });
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<div class="category_middle">
		<div class="lens_head">
			<h2 class="lens_tit">보청기 추천</h2>
		</div>		
		<form:form id="form_ha_check" name="form_ha_check" method="post">
			<input type="hidden" name="haUse" id="haUse" value="${hearingaidVO.haUse}">
			<input type="hidden" name="step1Cd" id="step1Cd" value="">
			<input type="hidden" name="step1CdFlg" id="step1CdFlg" value="">
			<input type="hidden" name="relateActivity" id="relateActivity" value="">
		</form:form>
		<div class="lens_type_area">
			<div class="g_type_step1">
				<c:if test="${hearingaidVO.haUse == 'N'}">
					<div class="lens_info_area">
						<p class="tit">소리를 듣는 것에 대한 대표적인 불편사항은 무엇인가요? (중복 가능)</p>
					</div>
					<ul class="lens_type2" id="select_list">
						<c:forEach var="result" items="${hearingaidStep1}" varStatus="status">
							<c:choose>
								<c:when test="${result.cdNm == '-'}"><input type="hidden" name="step1Mix" id="step1Mix" value="${result.userDefine3}"></c:when>
								<c:otherwise>
									<li onclick="fn_select_step1(this);" data-step1Cd="${result.cd}" data-step1CdFlg="${result.userDefine3}" data-step1CdActivity="${result.cdNm}">
										<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_step1_${result.cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
										<span style="bottom:7px; font-size:17px; color:#888888;">${result.cdNm}<i>check</i></span>
									</li>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</ul>
				</c:if>
				<c:if test="${hearingaidVO.haUse == 'Y'}">	
					<div class="lens_info_area">		
						<p class="tit">고객님이 원하시는 보청기의 기능 및 특성을 체크해 주세요.</p>
					</div>
					<ul class="check_list" id="select_list">
						<c:forEach var="result" items="${hearingaidStep1}" varStatus="status">
						<li onclick="fn_select_step1(this);" data-step1Cd="${result.cd}" data-step1CdFlg="${result.userDefine3}" data-step1CdActivity="${result.cdNm}">
							<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_step1_${result.cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
							<span style="bottom:7px; font-size:17px; color:#888888;">${result.cdNm}<i>check</i></span>
						</li>
						</c:forEach>
					</ul>
				</c:if>
				<div class="btn_lens_area">
					<button type="button" class="btn_view_recomm">다음</button>
				</div>
			</div>
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>