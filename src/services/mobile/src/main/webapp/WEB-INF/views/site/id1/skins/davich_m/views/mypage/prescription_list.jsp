<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">처방전관리</t:putAttribute>

    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){

    	// 기존 이벤트 제거
    	$(".btn_go_exchange").off("click");
   		// 등록 화면 팝업
    	$("#btn_pop_prescription_reg").on("click", function() {
    		var url = "${_MOBILE_PATH}/front/mypage/prescription_reg_form";
    		
    		Dmall.AjaxUtil.load(url, function(result) {
				$("#prescription_popup").html(result);
    		});
    	});
   		
   		// 삭제
    	$(".btn_del_presc").on("click", function() {
    		var prescriptionNo = $(this).siblings("[name=prescriptionNo]").val();

    		var yesFunc = function() {
        		var url = "${_MOBILE_PATH}/front/mypage/prescription_del";
        		var param = "prescriptionNo=" + prescriptionNo;
        		Dmall.AjaxUtil.getJSON(url, param, function(result) {
        			if(result.success) {
        				document.location.href = "${_MOBILE_PATH}/front/mypage/prescription";
        			}
        		});
    		};
    		Dmall.LayerUtil.confirm("삭제하시겠습니까?", yesFunc, null, "삭제확인", "");
    	});

   		// 처방전 이미지 팝업
    	$(".offline_good_name").on("click", function() {
    		var fileId = $(this).siblings("[name=prescriptionFileId]").val();
    		var url = "${_IMAGE_DOMAIN}/image/image-view?type=PRESCRIPTION&id1=" + fileId;
    		var win = window.open(url, "_blank", "");
    	});
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			처방전 관리
		</div>
		<div class="order_cancel_info">					
			<span class="icon_purpose mypage">처방전은 상품 추천시 참조자료로 활용되며, 최대 10개까지 등록가능합니다.</span>
		</div>
		<div class="cont_body marginT15">			
			<table class="tProduct_Board offline prescription">
				<caption>
					<h1 class="blind">처방전 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:20%">
					<col style="width:30%">
					<col style="width:20%">
					<col style="width:30%">
				</colgroup>
				<tbody>
				<c:forEach var="prescription" items="${prescriptionList}">
					<tr>
						<th class="textL" colspan="4">
							<span class="offline_date">처방일 : ${prescription.checkupDt}</span>
							<p class="offline_good_name">${prescription.prescriptionOrgFileNm}<span class="icon_img">첨부파일</span></p>	
							<input type="hidden" name="prescriptionFileId" value="${prescription.prescriptionFileId}" />
							<button type="button" class="btn_del_presc">삭제</button>
							<input type="hidden" name="prescriptionNo" value="${prescription.prescriptionNo}" />
						</th>
					</tr>
					<tr>	
						<td class="stit">발급기관</td>
						<td>${prescription.checkupInstituteNm}</td>
						<td class="stit">등록일자</td>
						<td><fmt:formatDate value="${prescription.regDttm}" pattern="yyyy-MM-dd" /></td>
					</tr>
					<!-- <tr>	
						<td colspan="4">
							
						</td>
					</tr> -->
				</c:forEach>
				</tbody>
			</table>
			<div class="btn_discount_area">
				<button type="button" class="btn_go_exchange" id="btn_pop_prescription_reg">처방전 등록</button>
			</div>
		</div><!-- //cont_body -->

	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
	
	<div class="popup" id="prescription_popup">
	</div>
    </t:putAttribute>
</t:insertDefinition>