<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
$(document).ready(function(){
	//기획전리스트 바로가기
	$('.btn_view_more').on('click', function(e) {
	    location.href = "${_MOBILE_PATH}/front/promotion/promotion-list";
	});
});
function detailPromotion(idx){
    $('#prmtNo').val(idx);
    var url = '${_MOBILE_PATH}/front/promotion/promotion-detail?prmtNo='+idx+'&prmtStatusCd=02&';
    location.href = url;
}
</script>
<!-- 기획전 영역 -->	
<form:form id="form_id_search" commandName="so" >
<form:hidden path="page" id="page" />
<form:hidden path="prmtStatusCd" id="prmtStatusCd" />
<form:hidden path="prmtNo" id="prmtNo" />
<!--<h2 class="main_tit promotit">기획전<button type="button" class="btn_view_more">더보기</button></h2> 20190128 -->
<c:set var="viewAll" value="N"/>
<c:choose>
	<c:when test="${exhibitionListModel.resultList ne null}">
		<c:forEach var="resultModel" items="${exhibitionListModel.resultList}" varStatus="status">
			<c:if test="${resultModel.prmtMainExpsPst eq prmtMainExpsPst }">
				<div class="main_product_list">
					<a href="javascript:detailPromotion('${resultModel.prmtNo}');" class="img_area">
						<%--<c:if test="${status.index eq 0}">
						<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.prmtMobileBannerImg}">
						</c:if>--%>
						<%--<c:if test="${status.index ne 0}">--%>
						<img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.prmtMobileBannerImg}">
						<%--</c:if>--%>
					</a>
					<div class="text_area">
						<a href="javascript:detailPromotion('${resultModel.prmtNo}');">
							<p class="promo_tit">${resultModel.prmtNm}</p>
							<%-- <p>${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</p> --%>
							<p class="promo_sale">${resultModel.prmtDscrt }</p>
						</a>
					</div>
				</div>
				<c:set var="viewAll" value="Y"/>
			</c:if>
		</c:forEach>
		<c:if test="${fn:length(exhibitionListModel.resultList ) >0}">
		<c:if test="${viewAll eq 'Y'}">
		<!-- 20190128 수정 -->
		<div class="more_promo_area">
			<button type="button" class="btn_view_more">기획전 전체보기<span>&gt;</span></button>
		</div>
		</c:if>
		</c:if>
		<!--// 20190128 -->
		</c:when>
		<c:otherwise>
		<div class="main_product_list">
		    <p>등록된 기획전이 없습니다.</p>
		</div>
		</c:otherwise>	
</c:choose>	

</form:form>
 			<!-- //기획전 영역 -->