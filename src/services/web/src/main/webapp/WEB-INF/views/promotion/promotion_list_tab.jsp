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
<form:form id="form_id_search" commandName="so" >
<form:hidden path="page" id="page" />
<form:hidden path="prmtStatusCd" id="prmtStatusCd" />
<form:hidden path="prmtNo" id="prmtNo" />
<ul class="promotion_list">
    <c:if test="${resultListModel.resultList ne null}">
    <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
    <li>
        <a href="javascript:detailPromotion('${resultModel.prmtNo}');">
            <dl class="promotion_list_info">
                <dt><img src="/image/image-view?type=EXHIBITION&path=${resultModel.prmtWebBannerImgPath}&id1=${resultModel.prmtWebBannerImg}" alt=""></dt>
                <dd>
                    <c:if test="${so.prmtStatusCd eq '02'}" ><span class="label_ing">진행중</span></c:if>
                    <c:if test="${so.prmtStatusCd ne '02'}" ><span class="label_end">종료</span></c:if>
                    <h4 class="promotion_stit">${resultModel.prmtNm}</h4>
                    <span class="promotion_date">기간 : ${resultModel.applyStartDttm.substring(0,10)} ~ ${resultModel.applyEndDttm.substring(0,10)}</span>
                </dd>
            </dl>
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
</form:form>
