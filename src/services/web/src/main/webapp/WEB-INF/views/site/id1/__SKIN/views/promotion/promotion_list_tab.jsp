<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="du" class="dmall.framework.common.util.DateUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'),ajaxPromotionList);
    });
</script>
<form id="form_id_search">
	<input type="hidden" id="page" name="page" value="${so.page }">
	<input type="hidden" id="prmtNo" name="prmtNo" ${so.prmtNo }>
<div class="planning_top_area">
	<span class="text">총 <em>${resultListModel.filterdRows}</em> 개의 기획전이 있습니다.</span>
	<select name="ageCd" id="searchAgeCd" class="select_planning" onchange="clickTab(this.value);" style="width: 250px;margin-left: 10px;">
		<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대이상;" value="${so.ageCd }"/>
	</select>
	<select class="select_planning" name="prmtStatusCd" onchange="clickTab(this.value);" style="width: 250px;margin-left: 10px;">
			<option value="00" <c:if test="${so.prmtStatusCd eq '00'}" >selected="selected"</c:if>>전체</option>
			<option value="02" <c:if test="${so.prmtStatusCd eq '02'}" >selected="selected"</c:if>>진행중인 기획전</option>
			<option value="03" <c:if test="${so.prmtStatusCd eq '03'}" >selected="selected"</c:if>>지난 기획전</option>
	</select>
</div>
<ul class="planning_list">
    <c:if test="${resultListModel.resultList ne null}">
    <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
	<li>
		<a href="javascript:detailPromotion('${resultModel.prmtNo}');">
			<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${resultModel.prmtWebBannerImgPath}&id1=${resultModel.prmtWebBannerImg}" alt="" onerror="this.src='../img/promotion/promotion_ing01.jpg'">
			<p class="tit">${resultModel.prmtNm}</p>
			<span class="date">${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</span>
		</a>
	</li>
   </c:forEach>
   </c:if>
</ul>
<c:if test="${resultListModel.resultList eq null}">
    <c:if test="${so.prmtStatusCd eq '02'}" ><p class="no_blank">진행중인 기획전이 없습니다.</p></c:if>
    <c:if test="${so.prmtStatusCd ne '02'}" ><p class="no_blank">해당 기획전이 없습니다.</p></c:if>
</c:if>
<!---- 페이징 ---->
<div class="tPages" id="div_id_paging">
    <grid:paging resultListModel="${resultListModel}" />
</div>
<!----// 페이징 ---->
</form>
