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
 <div class="my_shopping_view_body">
	<ul class="my_cancel_history">
		<c:set var="ordNo" value="0"/>
        <c:choose>
        <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
        <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
        <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
				<li>
					<div class="my_cancel_history_area">
						<span class="cancel_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
						주문번호 <a href="#1" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">${resultList.orderInfoVO.ordNo}</a>
						<span class="${goodsList.ordDtlStatusCd =='11'?"label_cancel":"label_replace"}">${goodsList.ordDtlStatusNm}</span>
						<span class="cancel_price"><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span>
						<div class="my_cancel_title">
							<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
						</div>
					</div>
				</li>
		</c:forEach>
         </c:forEach>
         </c:when>
         <c:otherwise>
             <!-- 주문상품이 없을 경우 -->
			<div class="no_order_history">
				조회 기간 동안 주문하신 상품이 없습니다.
			</div>
			<!--// 주문상품이 없을 경우 -->
           </c:otherwise>
       </c:choose>
		
	</ul>
	 
</div>
<c:if test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 10}">
<!---- 페이징 ---->
<div class="my_list_bottom" id="div_id_paging">
    <grid:paging resultListModel="${order_list}" />
</div>
<!----// 페이징 ---->
</c:if>
