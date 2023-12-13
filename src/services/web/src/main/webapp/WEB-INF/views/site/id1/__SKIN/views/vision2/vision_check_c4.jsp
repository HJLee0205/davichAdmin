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
	function fn_incon1(obj, v_option){
		var nowImg, srcName, newSrc;
		if($(obj).hasClass('active')){
			$(obj).removeClass('active');	
			nowImg = $(obj).find('img');  //호버한 부분의 img파일 찾기
			srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
			newSrc = srcName.replaceAll('_over','');
			$(obj).find('img').attr('src', newSrc);
		}else{
			$(obj).addClass('active');
			nowImg = $(obj).find('img');  //호버한 부분의 img파일 찾기
			srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
			newSrc = srcName.substring(0, srcName.lastIndexOf('.'));
			$(obj).find('img').attr('src', newSrc+ '_over.' + /[^.]+$/.exec(srcName));
		}		
		
		var type_target = "check_list_new";	
		
		if(v_option == "N"){
			$('.'+type_target).find('li').each(function(){
				$(this).removeClass('active');
				
				nowImg = $(this).find('img');  //호버한 부분의 img파일 찾기
				srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
				newSrc = srcName.replaceAll('_over','');
				$(this).find('img').attr('src', newSrc);
			});
			
			$(obj).addClass('active');
			nowImg = $(obj).find('img');  //호버한 부분의 img파일 찾기
			srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
			newSrc = srcName.substring(0, srcName.lastIndexOf('.'));
			$(obj).find('img').attr('src', newSrc+ '_over.' + /[^.]+$/.exec(srcName));
		}else{
			$('.'+type_target).find('li').each(function(){
				nowImg = $(this).find('img');  //호버한 부분의 img파일 찾기
				if(nowImg.attr('data-option') == 'N'){
					$(this).removeClass('active');					
					srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
					newSrc = srcName.replaceAll('_over','');
					$(this).find('img').attr('src', newSrc);
				}
			});
		}
		
		var v_incon1_cd = '';
		var v_incon1_nm = '';
		$('.'+type_target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(v_incon1_cd != '') v_incon1_cd += ',';
				v_incon1_cd += $(this).attr('data-incon1Cd');

				if(v_incon1_nm != '') v_incon1_nm += ' ';
				v_incon1_nm += $(this).attr('data-incon1CdNm');
			}
		});
		
		
		$('#incon1Cd').val(v_incon1_cd);
		$('#incon1CdNm').val(v_incon1_nm);
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
        
        Dmall.FormUtil.submit('/front/vision2/vision-check-c5', param);
			
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
				<input type="hidden" name="incon1Cd" id="incon1Cd" value="${classesPO.incon1Cd}">		
				<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${classesPO.incon1CdNm}">		
	        </form:form>
			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">현재 시력에 불편한 점이 있으신가요?</p>
			</div>
			<ul class="check_list_new l4">
				<c:forEach var="result" items="${incon1List}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_incon1(this, '${result.userDefine2}');" data-incon1Cd="${result.cd}" data-incon1CdNm="${result.cdNm}">
						<img src="${_SKIN_IMG_PATH}/vision2/contact/incon1_c_${classesPO.wearCd}_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}" data-option="${result.userDefine2}">
						<%-- <c:choose>
							<c:when test="${result.cd == '02'}">
								<c:choose>
									<c:when test="${classesPO.ageCdC == '12'}"><span>${result.cdShortNm}</span></c:when>
									<c:otherwise><span>${result.cdNm}</span></c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise><span>${result.cdNm}</span></c:otherwise>
						</c:choose> --%>
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