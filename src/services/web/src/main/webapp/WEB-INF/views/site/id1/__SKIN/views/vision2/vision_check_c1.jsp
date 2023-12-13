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
	function fn_wear(v_wear_cd, v_idx, v_wear_nm){
		var nowImg, srcName, newSrc;
		var type_target = "check_list_new";	
		$('.'+type_target).find('li').each(function(){
			$(this).removeClass('active');
			
			nowImg = $(this).find('img');  //호버한 부분의 img파일 찾기
			srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
			newSrc = srcName.replaceAll('_over','');
			$(this).find('img').attr('src', newSrc);
		});
		
		$('.'+type_target).find('li:eq('+v_idx+')').addClass('active');
		
		nowImg = $('.'+type_target).find('li:eq('+v_idx+')').find('img');
		srcName = nowImg.attr('src');
		newSrc = srcName.substring(0, srcName.lastIndexOf('.'));
		$('.'+type_target).find('li:eq('+v_idx+')').find('img').attr('src', newSrc+ '_over.' + /[^.]+$/.exec(srcName));
		
		$('#wearCd').val(v_wear_cd);
		$('#wearCdNm').val(v_wear_nm);
	}	
		
	$(".btn_view_recomm_new").click(function(){  		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
        
        Dmall.FormUtil.submit('/front/vision2/vision-check-c2', param); 
			
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
				<input type="hidden" name="lensType" id="lensType" value="${classesPO.lensType}">
				<input type="hidden" name="ageCdC" id="ageCdC" value="${classesPO.ageCdC}">
				<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${classesPO.ageCdCNm}">				
				<input type="hidden" name="wearCd" id="wearCd" value="${classesPO.wearCd}">				
				<input type="hidden" name="wearCdNm" id="wearCdNm" value="${classesPO.wearCdNm}">	
	        </form:form>
			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">콘택트렌즈를 착용하시나요?</p>
			</div>
			<ul class="check_list_new l2">
				<c:forEach var="result" items="${wearList}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_wear('${result.cd}', ${status.count-1}, '${result.cdNm}');">
						<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_c_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<div class="btn_lens_area_new">
				<button type="button" class="btn_view_recomm_new">다음으로</button>
			</div>
			<!--// 렌즈추천 -->			
		</div>
	</t:putAttribute>
</t:insertDefinition>