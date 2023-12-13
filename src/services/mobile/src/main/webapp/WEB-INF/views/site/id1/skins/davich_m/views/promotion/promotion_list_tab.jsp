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

        var $div_id_detail = $('#div_id_detail');
     	var $totalPageCount = $('#totalPageCount');
     	var totalPageCount = Number('${so.totalPageCount}');
     	var $list_page_view_em = $('.list_page_view em');
     	// 페이지 번호에 따른 페이징div hide
		if(totalPageCount == Number($('#page').val())){
 			$('.list_bottom').hide();
		}
		$list_page_view_em.text(Number($('#page').val()));
        $totalPageCount.text(totalPageCount);
        
		// 더보기 버튼 클릭시 append 이벤트
        $('.more_view').off('click').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
        	if(totalPageCount >= pageIndex){
        		$("#page").val(pageIndex);
        		var prmtStatusCd = $('#prmtStatusCd').val();
        		var ageCd = $('#searchAgeCd').val();
	          	var param = "page="+pageIndex;
	          	var url = '${_MOBILE_PATH}/front/promotion/ajax-promotion-paging?prmtStatusCd='+prmtStatusCd+'&ageCd='+ageCd+'&'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
		        	$list_page_view_em.text(pageIndex);
		        	
		        	$div_id_detail.append(result);
		        	
		        	if(totalPageCount == pageIndex){
		        		$('.list_bottom').hide();
		        	}
		        });
	        }else{
 				$('.list_bottom').hide();	
	        }
        });
    
    });

</script>
<!--- tab01: 진행중인 기획전 영역 --->
<form:form id="form_id_search" commandName="so" >
<form:hidden path="page" id="page" />
<%--<form:hidden path="prmtStatusCd" id="prmtStatusCd" />--%>
<form:hidden path="prmtNo" id="prmtNo" />
<%-- # ${so.prmtStatusCd} # --%>
<div class="list_head top_line_none">
	<%--총 ${resultListModel.filterdRows}개의 기획전이 있습니다.--%>
	<select name="ageCd" id="searchAgeCd" class="select_align floatR" onchange="clickTab(this.value);" style="width: 50%;">
		<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대이상;" value="${so.ageCd }"/>
	</select>
	<select class="select_align" id="prmtStatusCd" name="prmtStatusCd" onchange="clickTab(this.value);" style="width:49%">
		<option value="00" <c:if test="${so.prmtStatusCd eq '00'}" >selected</c:if>>전체</option>
			<option value="02" <c:if test="${so.prmtStatusCd eq '02'}" >selected</c:if>>진행중인 기획전</option>
			<option value="03" <c:if test="${so.prmtStatusCd eq '03'}" >selected</c:if>>지난 기획전</option>
		<%--<c:if test="${so.prmtStatusCd eq '02'}" >
			<option value="">전체</option>
			<option value="02">진행중인 기획전</option>
			<option value="03">지난 기획전</option>
		</c:if>
		<c:if test="${so.prmtStatusCd ne '02'}" >
			<option value="">전체</option>
			<option value="03">지난 기획전</option>
			<option value="02">진행중인 기획전</option>
		</c:if>--%>
	</select

</div>
<ul class="event_product_list floatC" id="div_id_detail">
    <c:choose>
    <c:when test="${resultListModel.resultList ne null}">
    <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
		<li>
			<a href="javascript:detailPromotion('${resultModel.prmtNo}');">			
				<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.prmtMobileBannerImg}" onerror="this.src='../img/promotion/promotion_ing01.jpg'">
				<div class="text">
					<em>${resultModel.prmtNm}</em>
					<p>${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</p>
				</div>
			</a>
		</li>
   </c:forEach>
   </c:when>
   <c:otherwise>
   <li>
       <dl class="promotion_list_info" style="text-align: center;">등록된 기획전이 없습니다.</dl>
    </li>
   </c:otherwise>
   </c:choose>
</ul>
<!--- 페이징 --->
<div class="list_bottom">
	<a href="javascript:;" class="more_view">
		더보기<span class="icon_more_view"></span>
	</a>            
	<div class="list_page_view">
		<em></em> / <span id="totalPageCount"></span>
	</div>
</div>
<!---// 페이징 --->
</form:form>
