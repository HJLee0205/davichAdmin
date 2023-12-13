<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">나의 쿠폰</t:putAttribute>
    
    
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));
            $('.more_view').on('click', function() {
            	var pageIndex = Number($('#page').val())+1;
              	var param = param = "page="+pageIndex;
           		var url = '/front/coupon/coupon-list?'+param;
              	 Dmall.AjaxUtil.load(url, function(result) {
	               	if('${so.totalPageCount}'==pageIndex){
	               		$('#div_id_paging').hide();
	               	}
	               	$("#page").val(pageIndex);
	               	$('.list_page_view em').text(pageIndex);
	                $('#tbody').append(result);
              	 });
             });
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <jsp:useBean id="toDay" class="java.util.Date" />
	<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="today"/>
	<fmt:parseNumber value="${toDay.time /(1000*60*60*24)}" integerOnly="true" var="nowDays" scope="request" />
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
	<form:form id="form_id_list" commandName="so">
    <form:hidden path="page" id="page" />       
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			보유한 쿠폰
		</div>
		<table class="tMypage_list">
			<colgroup>	
				<col style="width:50%">		
				<col style="width:28%">
				<col style="width:22%">
			</colgroup>
			<thead>
				<tr>
					<th>쿠폰명/제한사항</th>
					<th>할인혜택</th>
					<th>남은날짜</th>
				</tr>
			</thead>
			<tbody id="tbody">
 			<c:choose>
            <c:when test="${fn:length(resultListModel.resultList) > 0}">
            <c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">			
				<tr>
					<td class="textL">
						${couponList.couponNm}
						<span class="coupon_detail">
 							<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상
                            구매시
						</span>
					</td>
					<td>
						<span class="coupon_no">
							${couponList.couponBnfValue}${couponList.bnfUnit}할인
	                        <c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
	                        <br>(최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
	                        </c:if>
						</span>
					</td>
					<td>
					
					<fmt:parseDate value="${couponList.cpApplyEndDttm}" pattern="yyyy-MM-dd" var="endDay"/>
					<fmt:formatDate value="${endDay}" pattern="yyyy-MM-dd" var="dd"/>
					<fmt:parseNumber value="${endDay.time /(1000*60*60*24)}" integerOnly="true" var="oldDays" scope="request" />
						<c:choose>
						<c:when test="${oldDays-nowDays>0 }">
						${oldDays-nowDays} 일
						</c:when>
						<c:otherwise>
						 기간 만료
						</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
            </c:when>
            <c:otherwise>
            	<tr>
               		<td colspan="3">조회된 데이터가 없습니다.</td>
            	</tr>
             </c:otherwise>
             </c:choose>
			</tbody>
		</table>
		<!---- 페이징 ---->
         <div class="my_list_bottom" id="div_id_paging">
             <grid:paging resultListModel="${resultListModel}" />
         </div>
         <!----// 페이징 ---->
 </form:form>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->

    </t:putAttribute>
</t:insertDefinition>