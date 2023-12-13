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
	<t:putAttribute name="title">보청기 추천</t:putAttribute>
	<t:putAttribute name="script">	
	<script type="text/javascript">
		function fn_select_ha(haUse, idx){
			$('#haUse').val(haUse);
			var ha_target = 'lens_type2';
			
			$('.'+ha_target).find('li').each(function(){
				$(this).removeClass('active');
			});
			$('.'+ha_target).find('li:eq('+idx+')').addClass('active');			
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
			
			Dmall.FormUtil.submit('${_MOBILE_PATH}/front/hearingaid/hearingaid-check-s1', param);
				
        });
	</script>
	</t:putAttribute>	
	<t:putAttribute name="content">
	<div class="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			보청기 추천
		</div>
		<form:form id="form_ha_check" name="form_ha_check" method="post">
			<input type="hidden" name="haUse" id="haUse" value="${haUse}">
		</form:form>	
		<div class="cont_body">		
			<div class="lens_type_area">
				<div id="g_type_area">
					<div class="g_type_main">
						<div class="lens_info_area">
							<p class="tit">나에게 맞는 보청기는 어떤 것일까?</p>
							고객님의 나이와 불편사항을 고려하여 편하게 사용하실 수 있는 최적의 보청기를 추천해 드립니다.
							<p class="tit">보청기 착용은 처음이신가요?</p>
						</div>
						<ul class="lens_type2">
							<li <c:if test="${haUse == 'N'}">class="active"</c:if> onclick="fn_select_ha('N', 0)">
								<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_n.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>보청기 경험 없음 <i>check</i></span>
							</li>
							<li <c:if test="${haUse == 'Y'}">class="active"</c:if> onclick="fn_select_ha('Y', 1)">
								<img src="${_SKIN_IMG_PATH}/hearingaid/img_hearingaid_y.png" onerror="this.src='${_SKIN_IMG_PATH}/mypage/vision_img_sample.png'">
								<span>보청기 착용경험 있음 <i>check</i></span>
							</li>
						</ul>	
						
						<div class="btn_lens_area">
							<button type="button" class="btn_view_recomm">다음</button>
						</div>				
					</div>
				</div>
			</div>
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>