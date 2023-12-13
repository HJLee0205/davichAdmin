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
	function fn_lifestyle(obj){
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
		
		var v_lifestyle_cd = '';
		var v_lifestyle_nm = '';
		$('.'+type_target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(v_lifestyle_cd != '') v_lifestyle_cd += ',';
				v_lifestyle_cd += $(this).attr('data-lifestyleCd');

				if(v_lifestyle_nm != '') v_lifestyle_nm += ' ';
				v_lifestyle_nm += $(this).attr('data-lifestyleCdNm');
			}
		});
		
		
		$('#lifestyleCd').val(v_lifestyle_cd);
		$('#lifestyleCdNm').val(v_lifestyle_nm);	
		
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
        
        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/vision2/vision-check-gr', param);		
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
			<input type="hidden" name="ageCdG" id="ageCdG" value="${classesPO.ageCdG}">
			<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${classesPO.ageCdGNm}">				
			<input type="hidden" name="wearCd" id="wearCd" value="${classesPO.wearCd}">				
			<input type="hidden" name="wearCdNm" id="wearCdNm" value="${classesPO.wearCdNm}">							
			<input type="hidden" name="incon1Cd" id="incon1Cd" value="${classesPO.incon1Cd}">				
			<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${classesPO.incon1CdNm}">						
			<input type="hidden" name="incon2Cd" id="incon2Cd" value="${classesPO.incon2Cd}">				
			<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${classesPO.incon2CdNm}">				
			<input type="hidden" name="lifestyleCd" id="lifestyleCd" value="${classesPO.lifestyleCd}">				
			<input type="hidden" name="lifestyleCdNm" id="lifestyleCdNm" value="${classesPO.lifestyleCdNm}">
        </form:form>
		<div class="cont_body">

			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">해당하는 라이프 스타일을 모두 선택 해 주세요.</p>
			</div>
			<ul class="check_list_new l4">
				<c:forEach var="result" items="${lifestyleList}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_lifestyle(this);" data-lifestyleCd="${result.cd}" data-lifestyleCdNm="${result.cdNm}">
						<img src="${_SKIN_IMG_PATH}/vision2/glasses/lifestyle_${classesPO.ageCdG}_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<div class="btn_lens_area_new">
				<button type="button" class="btn_view_recomm_new">결과보기</button>
			</div>
			<!--// 렌즈추천 -->	
		</div>
	</div>
	</t:putAttribute>
</t:insertDefinition>