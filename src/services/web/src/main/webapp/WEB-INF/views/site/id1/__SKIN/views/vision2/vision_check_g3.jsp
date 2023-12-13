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
	function fn_incon2(obj, v_option){
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
		
		if(v_option == "N" || v_option == "E"){
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
			
			if(v_option == "E"){
				$(".vision_write_area").slideDown('200');
			}else{
				$("#etc_input").val("");
				$(".vision_write_area").slideUp('200');
			}
		}else{
			$('.'+type_target).find('li').each(function(){
				nowImg = $(this).find('img');  //호버한 부분의 img파일 찾기
				if(nowImg.attr('data-option') == 'N' || nowImg.attr('data-option') == 'E'){
					$(this).removeClass('active');					
					srcName = nowImg.attr('src');  //호버한 부분의 이미지 주소값 src가지고오기
					newSrc = srcName.replaceAll('_over','');
					$(this).find('img').attr('src', newSrc);
				}
			});
			
			$("#etc_input").val("");
			$(".vision_write_area").slideUp('200');
		}
		
		var v_incon2_cd = '';
		var v_incon2_nm = '';
		$('.'+type_target).find('li').each(function(){
			if($(this).hasClass('active')){
				if(v_incon2_cd != '') v_incon2_cd += ',';
				v_incon2_cd += $(this).attr('data-incon2Cd');

				if(v_incon2_nm != '') v_incon2_nm += ' ';
				v_incon2_nm += $(this).attr('data-incon2CdNm');
			}
		});
		
		
		$('#incon2Cd').val(v_incon2_cd);
		$('#incon2CdNm').val(v_incon2_nm);	
		
	}	
	
	$(".btn_vision_close").click(function(){  	
		$("#etc_input").val("");
	});	
	
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
		
		if($("#etc_input").val() != ""){
			$("#incon2CdNm").val($("#etc_input").val());
		}
		
		var data = $('#form_vision_check').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
			param[obj.name] = obj.value;
		});
        
        Dmall.FormUtil.submit('/front/vision2/vision-check-g4', param);		
			
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
				<input type="hidden" name="ageCdG" id="ageCdG" value="${classesPO.ageCdG}">
				<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${classesPO.ageCdGNm}">				
				<input type="hidden" name="wearCd" id="wearCd" value="${classesPO.wearCd}">				
				<input type="hidden" name="wearCdNm" id="wearCdNm" value="${classesPO.wearCdNm}">							
				<input type="hidden" name="incon1Cd" id="incon1Cd" value="${classesPO.incon1Cd}">				
				<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${classesPO.incon1CdNm}">						
				<input type="hidden" name="incon2Cd" id="incon2Cd" value="${classesPO.incon2Cd}">				
				<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${classesPO.incon2CdNm}">
	        </form:form>
			<!-- 렌즈추천 -->
			<div class="lens_info_area_new">	
				<p class="tit">현재 시력에 불편한 점이 있으신가요?</p>
			</div>
			<ul class="check_list_new l4">
				<c:forEach var="result" items="${incon2List}" varStatus="status">
					<li <c:if test="${status.count == 1}">class="active"</c:if> onclick="fn_incon2(this, '${result.userDefine2}');" data-incon2Cd="${result.cd}" data-incon2CdNm="${result.cdNm}">
						<img src="${_SKIN_IMG_PATH}/vision2/glasses/incon2_g_${classesPO.ageCdG}_${result.cd}<c:if test="${status.count == 1}">_over</c:if>.gif" alt="${result.cdNm}" data-option="${result.userDefine2}">
						<span>${result.cdNm}</span>
					</li>
				</c:forEach>
			</ul>
			<!-- 직접입력 폼영역 -->
			<div class="vision_write_area">
				<button type="button" class="btn_vision_close">창닫기</button>
				<textarea id="etc_input" placeholder="직접 입력 내용을 적어주세요"></textarea>
			</div>
			<!--// 직접입력 폼영역 -->
			<div class="btn_lens_area_new">
				<button type="button" class="btn_view_recomm_new">다음으로</button>
			</div>
			<!--// 렌즈추천 -->	
		</div>
	</t:putAttribute>
</t:insertDefinition>