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
	function fn_purp(obj){
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
		
		var v_purp_cd = '';
		var v_purp_nm = '';
		$('.'+type_target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(v_purp_cd != '') v_purp_cd += ',';
				v_purp_cd += $(this).attr('data-purpCd');

				if(v_purp_nm != '') v_purp_nm += ' ';
				v_purp_nm += $(this).attr('data-purpCdNm');
			}
		});
		
		$('#contactPurpCd').val(v_purp_cd);
		$('#contactPurpCdNm').val(v_purp_nm);
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
        
        if($("#wearCd").val() == "01"){
        	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/vision2/vision-check-cr', param); //처음착용
        }else{
        	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/vision2/vision-check-c6', param); //현재 착용 중
        }
			
    });
	</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			렌즈추천
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
			<input type="hidden" name="contactPurpCd" id="contactPurpCd" value="${classesPO.contactPurpCd}">		
			<input type="hidden" name="contactPurpCdNm" id="contactPurpCdNm" value="${classesPO.contactPurpCdNm}">	
        </form:form>
		<div class="cont_body">

			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">콘택트렌즈 착용목적은 무엇인가요?</p>
			</div>			
			<ul class="check_list_new l4">
				<c:forEach var="result" items="${purpList}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_purp(this);" data-purpCd="${result.cd}" data-purpCdNm="${result.cdNm}">
						<img src="${_SKIN_IMG_PATH}/vision2/contact/contact_purp_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<div class="btn_lens_area_new">
				<c:choose>
					<c:when test="${classesPO.wearCd == '01'}"><button type="button" class="btn_view_recomm_new">결과보기</button></c:when>
					<c:when test="${classesPO.wearCd == '02'}"><button type="button" class="btn_view_recomm_new">다음으로</button></c:when>
				</c:choose>
			</div>
			<!--// 렌즈추천 -->	
		</div>		
	</div>
	</t:putAttribute>
</t:insertDefinition>