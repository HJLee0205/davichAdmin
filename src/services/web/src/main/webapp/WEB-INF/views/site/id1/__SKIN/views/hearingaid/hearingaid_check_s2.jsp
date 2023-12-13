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
	function fn_select_step2(ringing, idx, flg){
		$('#ringing').val(ringing);
		$('#step2CdFlg').val(flg);		
		
		var ha_target = 'lens_type2';
		
		$('.'+ha_target).find('li').each(function(){
			$(this).removeClass('active');
		});
		$('.'+ha_target).find('li:eq('+idx+')').addClass('active');			
	};
		
		// 추천결과보기
		$(".btn_view_recomm").click(function(){                	
        	
			//data setting
			if($("#ringing").val() == ''){
				Dmall.LayerUtil.alert("이명 소리 여부를 선택해 주세요.","확인");
				return false;
			}
			
			var data = $('#form_ha_check').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
				param[obj.name] = obj.value;
			});
			
			Dmall.FormUtil.submit('/front/hearingaid/hearingaid-check-s3', param);
				
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
			<input type="hidden" name="ringing" id="ringing" value="">
			<input type="hidden" name="step2CdFlg" id="step2CdFlg" value="">
			<input type="hidden" name="relateActivity" id="relateActivity" value="${hearingaidVO.relateActivity}">
		</form:form>
		<div class="lens_type_area">
			<div class="g_type_step1">
				<div class="lens_info_area">		
					<p class="tit">이명 소리가 자주 들리시나요? (귀에서 "삐~"와 같이 나는 소리)</p>
				</div>
				<ul class="lens_type2">
					<c:forEach var="result" items="${hearingaidStep2}" varStatus="status">
						<li onclick="fn_select_step2('${result.cd}', ${status.count-1}, '${result.userDefine3}');">
							<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_step2_${result.cd}.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
							<span>${result.cdNm}<i>check</i></span>
						</li>
					</c:forEach>
				</ul>
				<div class="btn_lens_area">
					<button type="button" class="btn_view_recomm">다음</button>
				</div>
			</div>
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>