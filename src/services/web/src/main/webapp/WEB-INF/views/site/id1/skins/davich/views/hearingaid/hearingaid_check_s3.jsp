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
	function fn_select_step3(haType, idx, flg){
		$('#haType').val(haType);
		$('#step3CdFlg').val(flg);	
		
		var ha_target = 'check_list';
		
		$('.'+ha_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+ha_target).find('li:eq('+idx+')').addClass('active');			
	};
		
		// 추천결과보기
		$(".btn_view_recomm").click(function(){                	
        	
			//data setting
			if($("#haType").val() == ''){
				Dmall.LayerUtil.alert("선호하시는 타입을 선택해 주세요.","확인");
				return false;
			}
			
			var data = $('#form_ha_check').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
				param[obj.name] = obj.value;
			});
			
			Dmall.FormUtil.submit('/front/hearingaid/hearingaid-recommend', param);
				
        });
		
		
		//다시하기	
		$(".btn_view_recomm2").click(function(){
			document.location.href="/front/hearingaid/hearingaid-check";
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
			<input type="hidden" name="step1Cd" id="step1Cd" value="${hearingaidVO.step1Cd}">
			<input type="hidden" name="step1CdFlg" id="step1CdFlg" value="${hearingaidVO.step1CdFlg}">
			<input type="hidden" name="ringing" id="ringing" value="${hearingaidVO.ringing}">
			<input type="hidden" name="step2CdFlg" id="step2CdFlg" value="${hearingaidVO.step2CdFlg}">
			<input type="hidden" name="haType" id="haType" value="">
			<input type="hidden" name="step3CdFlg" id="step3CdFlg" value="">
			<input type="hidden" name="relateActivity" id="relateActivity" value="${hearingaidVO.relateActivity}">
		</form:form>
		<div class="lens_type_area">
			<div class="g_type_step1">
				<div class="lens_info_area">		
					<p class="tit">선호하시는 타입을 선택해 주세요.</p>
				</div>
				<ul class="check_list">
					<c:forEach var="result" items="${hearingaidStep3}" varStatus="status">
						<li onclick="fn_select_step3('${result.cd}', ${status.count-1}, '${result.userDefine3}');">
							<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_step3_${result.cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
							<span>${result.cdNm}<i>check</i></span>
						</li>
					</c:forEach>
				</ul>
				<div class="btn_lens_area">
					<button type="button" class="btn_view_recomm2">다시하기</button>
					<button type="button" class="btn_view_recomm">결과보기</button>
				</div>
			</div>
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>