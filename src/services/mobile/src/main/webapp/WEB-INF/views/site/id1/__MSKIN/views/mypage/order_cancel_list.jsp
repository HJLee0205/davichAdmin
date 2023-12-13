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
 <!-- <div class="my_shopping_view_body"> -->
	<!-- <ul class="my_cancel_history"> -->
	<div class="my_shopping_view_body">
		<c:set var="ordNo" value="0"/>
        <c:choose>
        <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
        <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
        <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
			<div class="my_order">
				<a href="javascript:;" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">
					<c:if test="${ordNo!= resultList.orderInfoVO.ordNo}">
					<div class="my_order_no">
						<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
						<button type="button" class="btn_review_go" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
						</c:if>
						주문번호 :${resultList.orderInfoVO.ordNo}
					</div>
					</c:if>
				</a>

				<ul class="my_order_info_top">
					<li class="my_order_product_pic"><a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}"><img src="${_IMAGE_DOMAIN}${goodsList.imgPath}" alt=""></a></li>
					<li class="my_order_product_title"><a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>

					<br>
					<c:choose>
						<c:when test="${goodsList.returnCd eq '' and goodsList.claimCd eq ''}">
						<span class="${goodsList.ordDtlStatusCd =='11'?"label_cancel":"label_replace"}">
							${goodsList.ordDtlStatusNm}
							<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
								<button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
							</c:if>
						</span>
						</c:when>
						<c:otherwise>
							<%--${goodsList.returnNm}<br>${goodsList.claimNm}--%>
							<c:set var="claimCd" value="${fn:split(goodsList.claimCd,',')}"/>
							<c:set var="claimNm" value="${fn:split(goodsList.claimNm,',')}"/>
							<c:set var="returnCd" value="${fn:split(goodsList.returnCd,',')}"/>
							<c:set var="returnNm" value="${fn:split(goodsList.returnNm,',')}"/>

							<c:set var="pClaimQtt" value="${fn:split(goodsList.pclaimQtt,',')}"/>

							<c:forEach var="claimNm" items="${claimNm}" varStatus="g">

							<span class="${goodsList.ordDtlStatusCd =='11'?"label_cancel":"label_replace"}">
								<c:choose>
									<c:when test="${claimCd eq '11'}">반품신청</c:when>
									<c:when test="${claimCd eq '12'}">반품완료</c:when>
									<c:otherwise>${claimNm}</c:otherwise>
								</c:choose>
								(${pClaimQtt[g.index]})
							</span>
							</c:forEach>
						</c:otherwise>
					</c:choose>

					</li>
				</ul>

				<ul class="my_order_detail6">
					<li>
						<span class="title">신청일</span>
						<p class="detail">
							<span class="cancel_date">${resultList.orderInfoVO.claimAcceptDttm}</span>
						</p>
					</li>
					<li>
						<span class="title">주문금액</span>
						<p class="detail">
							<fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/>원
						</p>
					</li>
					<li>
						<span class="title">환불금액</span>
						<p class="detail">
							<fmt:formatNumber value="${resultList.orderInfoVO.refundAmt}" type="number"/>원
						</p>
					</li>
				</ul>

				<!-- <div class="my_cancel_title">
					<img src="${goodsList.imgPath}" alt=""><a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
				</div> -->
				<!-- <span class="cancel_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
				주문번호 <a href="#1" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">${resultList.orderInfoVO.ordNo}</a> -->


				<!-- <span class="${goodsList.ordDtlStatusCd =='11'?"label_cancel":"label_replace"}">
				<c:choose>
					<c:when test="${goodsList.returnCd eq '' and goodsList.claimCd eq ''}">
						${goodsList.ordDtlStatusNm}
						<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
							<button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
						</c:if>
					</c:when>
					<c:otherwise>
						<%--${goodsList.returnNm}<br>${goodsList.claimNm}--%>
						<c:set var="claimCd" value="${fn:split(goodsList.claimCd,',')}"/>
						<c:set var="claimNm" value="${fn:split(goodsList.claimNm,',')}"/>
						<c:set var="returnCd" value="${fn:split(goodsList.returnCd,',')}"/>
						<c:set var="returnNm" value="${fn:split(goodsList.returnNm,',')}"/>

						<c:set var="pClaimQtt" value="${fn:split(goodsList.pclaimQtt,',')}"/>

						<c:forEach var="claimNm" items="${claimNm}" varStatus="g">
							<%--${returnNm[g.index]}/--%>${claimNm} (${pClaimQtt[g.index]})<br>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				<%--${goodsList.ordDtlStatusNm}--%>
				</span> -->
				<!-- <span class="cancel_price">
				결제금액 : <fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/>원
				<c:if test="${resultList.orderInfoVO.refundAmt>0}">
				환불금액 : <fmt:formatNumber value="${resultList.orderInfoVO.refundAmt}" type="number"/>원
				</c:if> -->
				<!-- <%--<fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span>--%> -->
				<!-- <div class="my_cancel_title">
					<img src="${goodsList.imgPath}" alt=""><a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
				</div> -->
			</div><!-- //my_order -->
			<c:set var="ordNo" value="${resultList.orderInfoVO.ordNo}"/>
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
		
	</div><!-- //my_shopping_view_body -->
	 
<!-- </div> -->
<c:if test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 10}">
<!---- 페이징 ---->
<div class="my_list_bottom" id="div_id_paging">
    <grid:paging resultListModel="${order_list}" />
</div>
<!----// 페이징 ---->
</c:if>
