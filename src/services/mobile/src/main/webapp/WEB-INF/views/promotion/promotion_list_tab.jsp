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
        
        $('.more_view').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
          	var param = "page="+pageIndex;
     		var url = '${_MOBILE_PATH}/front/promotion/ajax-promotion-paging?prmtStatusCd=02&'+param;
	        Dmall.AjaxUtil.load(url, function(result) {
		    	if('${so.totalPageCount}'==pageIndex){
		        	$('#div_id_paging').hide();
		        }
		        $("#page").val(pageIndex);
		        $('.list_page_view em').text(pageIndex);
		        $('.promotion_view_list').append(result);
	        })
         }); 
        
    });

</script>
<!--- tab01: 진행중인 기획전 영역 --->
<form:form id="form_id_search" commandName="so" >
<form:hidden path="page" id="page" />
<form:hidden path="prmtStatusCd" id="prmtStatusCd" />
<form:hidden path="prmtNo" id="prmtNo" />
<%-- # ${so.prmtStatusCd} # --%>
<ul class="promotion_view_list">
    <c:choose>
    <c:when test="${resultListModel.resultList ne null}">
    <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
    <li>
        <a href="javascript:detailPromotion('${resultModel.prmtNo}');">
            <dl class="promotion_list_info">
                <dt>
                	<img src="/image/image-view?type=EXHIBITION&path=${resultModel.prmtMobileBannerImgPath}&id1=${resultModel.prmtMobileBannerImg}" onerror="this.src='../img/promotion/promotion_ing01.jpg'">
                </dt>
                <dd>
                    <%-- <c:if test="${so.prmtStatusCd eq '02'}" ><span class="label_ing">진행중</span></c:if>
                    <c:if test="${so.prmtStatusCd ne '02'}" ><span class="label_end">종료</span></c:if> --%>
                    <h2 class="promotion_stit">${resultModel.prmtNm}</h2>
                    <span class="promotion_date">기간 : ${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</span>
                </dd>
            </dl>
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
<!---- 페이징 ---->
<div class="tPages" id="div_id_paging">
    <grid:paging resultListModel="${resultListModel}" />
</div>
<!----// 페이징 ---->
</form:form>
