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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">다비치마켓 :: 로그인</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
		<script>
			var orderYn='${param.orderYn}';
			var visionYn='${param.visionYn}';
			var rsvOnlyYn = '${param.rsvOnlyYn}';
			jQuery(document).ready(function() {


				jQuery('#btn_id_pwchange').on('click', function () {
					if(orderYn=='Y'){
						$('#orderForm').attr("action",HTTPS_SERVER_URL + '${_MOBILE_PATH}/front/login/change-password-step2');
						$('#orderForm').submit();
					}else{
						if(visionYn=='Y'){
							$('#form_vision_check').attr("action",HTTPS_SERVER_URL + '${_MOBILE_PATH}/front/login/change-password-step2');
							$('#form_vision_check').submit();
						}else{
							$('#returnForm').attr("action",HTTPS_SERVER_URL + '${_MOBILE_PATH}/front/login/change-password-step2');
							$('#returnForm').submit();
						}
					}
				});


				jQuery('#btn_id_next').on('click', function () {
					var url ='${_MOBILE_PATH}/front/login/password-nextchange-update';
					var param = {};
					Dmall.AjaxUtil.getJSON(url, param, function(result){
						if(result.success){
							if(orderYn=='Y'){
								if(rsvOnlyYn=='Y'){
									$('#orderForm').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/visit/visit-book');
								}
								$('#orderForm').submit();
							}else{
								if(visionYn=='Y'){
									$('#form_vision_check').submit();
								}else{
									if('${param.returnUrl}'==''){
										$('#returnForm').attr("action",'/front');
										$('#returnForm').submit();
									}else {
										$('#returnForm').submit();
									}
								}
							}
						} else {
						}
					});

					//window.location.href = '/front/login/password-nextchange-update';
				});
			});
		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
	<!-- PC버전  -->
    <link rel="stylesheet" type="text/css" href="${_MOBILE_PATH}/front/css/include.css" /> <!--- 공통 css ---->
	<!-- <link rel="stylesheet" type="text/css" href="/front/css/web/custom.css" />  --><!--- 개발 추가 css ---->
	<!-- //PC버전  -->
		<!--- contents --->
		<form name="orderForm" id="orderForm" action="${_MOBILE_PATH}/front/order/order-form" method="post">
			<input type="hidden" name="orderYn" value="Y">
			<input type="hidden" name="rsvOnlyYn" value="${param.rsvOnlyYn}">

			<c:forEach var="itemArr" items="${param.itemArr}" varStatus="status">
				<input type="hidden" name="itemArr" value="${itemArr}">
			</c:forEach>
		</form>
		<form:form id="form_vision_check" name="form_vision_check" method="post" action="${param.returnUrl}">
			<input type="hidden" name="visionYn" value="Y">
			<input type="hidden" name="lensType" id="lensType" value="${param.lensType}">
			<input type="hidden" name="ageCdG" id="ageCdG" value="${param.ageCdG}">
			<input type="hidden" name="ageCdC" id="ageCdC" value="${param.ageCdC}">
			<input type="hidden" name="ageCdGNm" id="ageCdGNm" value="${param.ageCdGNm}">
			<input type="hidden" name="ageCdCNm" id="ageCdCNm" value="${param.ageCdCNm}">
			<input type="hidden" name="wearCd" id="wearCd" value="${param.wearCd}">
			<input type="hidden" name="wearCdNm" id="wearCdNm" value="${param.wearCdNm}">
			<input type="hidden" name="contactTypeCd" id="contactTypeCd" value="${param.contactTypeCd}">
			<input type="hidden" name="contactTypeCdNm" id="contactTypeCdNm" value="${param.contactTypeCdNm}">
			<input type="hidden" name="wearTimeCd" id="wearTimeCd" value="${param.wearTimeCd}">
			<input type="hidden" name="wearTimeCdNm" id="wearTimeCdNm" value="${param.wearTimeCdNm}">
			<input type="hidden" name="wearDayCd" id="wearDayCd" value="${param.wearDayCd}">
			<input type="hidden" name="wearDayCdNm" id="wearDayCdNm" value="${param.wearDayCdNm}">
			<input type="hidden" name="incon1Cd" id="incon1Cd" value="${param.incon1Cd}">
			<input type="hidden" name="incon1CdNm" id="incon1CdNm" value="${param.incon1CdNm}">
			<input type="hidden" name="contactPurpCd" id="contactPurpCd" value="${param.contactPurpCd}">
			<input type="hidden" name="contactPurpCdNm" id="contactPurpCdNm" value="${param.contactPurpCdNm}">
			<input type="hidden" name="incon2Cd" id="incon2Cd" value="${param.incon2Cd}">
			<input type="hidden" name="incon2CdNm" id="incon2CdNm" value="${param.incon2CdNm}">
			<input type="hidden" name="lifestyleCd" id="lifestyleCd" value="${param.lifestyleCd}">
			<input type="hidden" name="lifestyleCdNm" id="lifestyleCdNm" value="${param.lifestyleCdNm}">
			<input type="hidden" name="returnUrl" value="${param.returnUrl}"/>
		</form:form>

		<form id="returnForm" action="${param.returnUrl}" method="post">
			<input type="hidden" name="refererType" id="refererType" value="${param.refererType}"/>
			<input type="hidden" name="returnUrl" value="${param.returnUrl}"/>
		</form>

		<div id="middle_area">
			<div class="member_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				비밀번호 변경안내
			</div>
			<div class="password_change_box">
				<!--step1-->
				<div id="div_id_stap1">
					<div class="password_change_text01">
						고객님님의 소중한 정보 보호를 위해<br>
						<em>비밀번호를 변경</em>해 주세요.
					</div>
					<div class="password_change_text02">
						개인정보 유출로 인한 피해 사례를 막기 위해
						회원님의 소중한 개인정보를 보호하고자 비밀번호 변경 안내를 시행하고 있습니다.<br>
						타 사이트와 동일한 비밀번호를 사용할 경우,개인정보 도용에 노출될 가능성이 높습니다.<br>
						불편하시더라도 비밀번호를 자주 변경해주시기 바랍니다.						
					</div>
					<p class="password_change_text03">* 다음에 변경하기를 눌러 변경을 연기하시면 <span class="point_red">${siteInfo.pwChgGuideCycle}</span>일 후 다시 안내해드립니다.</p>
					<div class="btn_change_area">
						<button type="button" class="btn_pw_change" id="btn_id_pwchange">지금변경하기</button>
						<button type="button" class="btn_pw_change_next" id="btn_id_next">다음에 변경하기</button>
					</div>
				</div>
				<!--//step1-->
			</div>
		</div>
		<!---// contents --->
	</t:putAttribute>
</t:insertDefinition>