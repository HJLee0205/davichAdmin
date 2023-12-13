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
	function fn_time(v_time_cd, v_idx, v_time_nm){
		var nowImg, srcName, newSrc;
		var type_target = "check_list_time";	
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
		
		$('#wearTimeCd').val(v_time_cd);
		$('#wearTimeCdNm').val(v_time_nm);
	}
	
	function fn_day(v_day_cd, v_idx, v_day_nm){
		var nowImg, srcName, newSrc;
		var type_target = "check_list_day";	
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
		
		$('#wearDayCd').val(v_day_cd);
		$('#wearDayCdNm').val(v_day_nm);
	}	
		
	$(".btn_view_recomm_new").click(function(){  		
		
		var chk = false;
		$('.check_list_new li').each(function(){
			if($(this).hasClass('active')){
				chk = true;
				return;
			}
		});
		
		if(!chk){
			Dmall.LayerUtil.alert("항목을 1개 이상 선택해주세요.", "확인");
			return false;
		}
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
        
        Dmall.FormUtil.submit('/front/vision2/vision-check-c4', param);
			
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
				<input type="hidden" name="contactTypeCd" id="contactTypeCd" value="${classesPO.contactTypeCd}">				
				<input type="hidden" name="contactTypeCdNm" id="contactTypeCdNm" value="${classesPO.contactTypeCdNm}">	
				<input type="hidden" name="wearTimeCd" id="wearTimeCd" value="${classesPO.wearTimeCd}">				
				<input type="hidden" name="wearTimeCdNm" id="wearTimeCdNm" value="${classesPO.wearTimeCdNm}">		
				<input type="hidden" name="wearDayCd" id="wearDayCd" value="${classesPO.wearDayCd}">		
				<input type="hidden" name="wearDayCdNm" id="wearDayCdNm" value="${classesPO.wearDayCdNm}">	
	        </form:form>
			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">콘택트렌즈의 평균 착용시간은 얼마나 되시나요?</p>
			</div>
			<ul class="check_list_new l3 check_list_time">
				<c:forEach var="result" items="${timeList}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_time('${result.cd}', ${status.count-1}, '${result.cdNm}');">
						<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_time_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<div class="l3_divice_line"></div>			
			<div class="lens_info_area_new">	
				<p class="tit">콘택트렌즈 일주일 평균 착용 기간은 얼마나 되시나요?</p>
			</div>
			<ul class="check_list_new l3 check_list_day">
				<c:forEach var="result" items="${dayList}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_day('${result.cd}', ${status.count-1}, '${result.cdNm}');">
						<img src="${_SKIN_IMG_PATH}/vision2/contact/wear_day_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}">
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