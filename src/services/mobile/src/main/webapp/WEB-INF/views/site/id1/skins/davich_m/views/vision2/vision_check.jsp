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
	<t:putAttribute name="title">비전체크</t:putAttribute>
	<t:putAttribute name="script">
	<script type="text/javascript">
	function fn_lens_type(v_lens_type, v_idx){
		var nowImg, srcName, newSrc;
		var type_target = 'lens_type_new';	
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
		var newSrc = srcName.substring(0, srcName.lastIndexOf('.'));
		$('.'+type_target).find('li:eq('+v_idx+')').find('img').attr('src', newSrc+ '_over.' + /[^.]+$/.exec(srcName));
		
		$('.lens_age_new').hide();
		$('.' + v_lens_type).show();		
		
		$('#lensType').val(v_lens_type);
	}
	
	function fn_age(v_lens_type, v_age_cd, v_idx, v_age_nm){
		var nowImg, srcName, newSrc;
		var type_target = v_lens_type;	
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
		
		if(v_lens_type == "G"){
			$('#ageCdG').val(v_age_cd);
			$('#ageCdGNm').val(v_age_nm);
		}else{
			$('#ageCdC').val(v_age_cd);
			$('#ageCdCNm').val(v_age_nm);
		}
	}
		
	$(".btn_view_recomm_new").click(function(){  	
		if($('#lensType').val() == 'G'){
			if($('#ageCdG').val() == '0') {
                Dmall.LayerUtil.alert("나이를 선택해주세요.", "확인");
                return false;
            }
		}

		if($('#lensType').val() == 'C'){
			if($('#ageCdC').val() == '0') {
                Dmall.LayerUtil.alert("나이를 선택해주세요.", "확인");
                return false;
            }
		}

		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
        
        if($('#lensType').val() == 'G'){
        	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/vision2/vision-check-g1', param);
        }else if($('#lensType').val() == 'C'){
        	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/vision2/vision-check-c1', param);	
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
			<input type="hidden" name="lensType" id="lensType" value="${lensType}">
			<input type="hidden" name="ageCdG" id="ageCdG" value="${ageCdG}">
			<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${ageCdGNm}">
			<input type="hidden" name="ageCdC" id="ageCdC" value="${ageCdC}">
			<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${ageCdCNm}">
        </form:form>
		<div class="cont_body">

			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">나에게 맞는 렌즈는 어떤 것일까?</p>
				고객님의 나이와 생활환경을 고려하여 편안하게 착용하실 수 있는 최적의 렌즈를 추천해 드립니다.<br>
				추천 받으실 렌즈의 종류와 연령대를 선택해 주세요.
			</div>			
			<ul class="lens_type_new">
				<li <c:if test="${lensType == 'G'}">class="active"</c:if> onclick="fn_lens_type('G', 0);">
					<img src="${_SKIN_IMG_PATH}/vision2/start/vision_check_g<c:if test="${lensType == 'G'}">_over</c:if>.gif" alt="안경렌즈">
					<span>안경렌즈</span>
				</li>
				<li <c:if test="${lensType == 'C'}">class="active"</c:if> onclick="fn_lens_type('C', 1);">
					<img src="${_SKIN_IMG_PATH}/vision2/start/vision_check_c<c:if test="${lensType == 'C'}">_over</c:if>.gif" alt="콘택트 렌즈">
					<span>콘택트 렌즈</span>
				</li>
			</ul>

			<ul class="lens_age_new G" <c:if test="${lensType == 'C'}">style="display:none"</c:if>>
				<c:forEach var="result" items="${ageListG}" varStatus="status">
					<li <c:if test="${ageCdG == result.cd}">class="active"</c:if> onclick="fn_age('G', '${result.cd}', ${status.count-1}, '${result.cdNm}');">
						<img src="${_SKIN_IMG_PATH}/vision2/start/age_g_${result.cd}<c:if test="${ageCdG == result.cd}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>	
			<ul class="lens_age_new C" <c:if test="${lensType == 'G'}">style="display:none"</c:if>>
				<c:forEach var="result" items="${ageListC}" varStatus="status">
					<li <c:if test="${ageCdC == result.cd}">class="active"</c:if> onclick="fn_age('C', '${result.cd}', ${status.count-1}, '${result.cdNm}');">
						<img src="${_SKIN_IMG_PATH}/vision2/start/age_c_${result.cd}<c:if test="${ageCdC == result.cd}">_over</c:if>.gif" alt="${result.cdNm}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<div class="btn_lens_area_new">
				<button type="button" class="btn_view_recomm_new">다음으로</button>
			</div>

			<!--// 렌즈추천 -->
		</div>
		<!-- //cont_body -->
	</div>	
	</t:putAttribute>
</t:insertDefinition>