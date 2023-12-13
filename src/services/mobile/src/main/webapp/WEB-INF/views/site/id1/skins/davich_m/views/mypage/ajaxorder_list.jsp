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
	<c:set var="ordNo" value="0"/>
    <c:choose>
    	<c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">

		<c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
			<c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
				<!-- 구매내역 1set -->
				<div class="my_order">
					<a href="javascript:;" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">
						<c:if test="${ordNo!= resultList.orderInfoVO.ordNo}">
							<div class="my_order_no">
								주문번호 : ${resultList.orderInfoVO.ordNo}
							</div>
						</c:if>
						<ul class="my_order_info_top">
							<li class="my_order_product_pic"><img src="${goodsList.imgPath}" alt=""></li>
							<li class="my_order_product_title">
								<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
								<ul class="my_order_info_text">
									<c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
										<li>[${optionList.addOptNm}]</li>
									</c:forEach>
								</ul><!--// my_order_info_text -->
								<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
								<c:if test="${goodsList.freebieNm ne null}">
									<p class="option_title">사은품 : <c:out value="${goodsList.freebieNm}"/></p>
								</c:if>
								<!-- //사은품추가 2018-09-27 -->
									<%-- <button type="button" class="btn_review_go" onclick="goods_detail('${goodsList.goodsNo}', 'inquiry');">문의하기</button> --%>
								<button type="button" class="btn_review_go" onclick="open_question_pop('${goodsList.goodsNo}');">문의하기</button>
							</li>
						</ul>

						<ul class="my_order_detail">
							<li>
								<span class="title">주문상태</span>
								<p class="detail">
										${goodsList.ordDtlStatusNm}
								</p>
							</li>
							<li>
								<span class="title">결제금액</span>
								<p class="detail">
									<fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/>원
								</p>
							</li>
						</ul>
					</a>
					<div class="my_order_area">
						<!-- 주문취소(주문완료,결제확인)-->
						<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
							<button type="button" class="btn_order_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
						</c:if>
						<!-- 반품/교환(배송준비,배송중,배송완료) -->
						<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
							<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
								<button type="button" class="btn_order_cancel" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button>
								<button type="button" class="btn_order_cancel" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
							</c:if>
						</c:if>
						<!-- 구매확정(배송중,배송완료)-->
						<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
							<button type="button" class="btn_order_ok" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','orderlist')">구매확정</button>
						</c:if>
						<!--상품평(배송중,배송완료,구매확정)-->
						<c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
							<%-- <button type="button" class="btn_review_go" onclick="goods_detail('${goodsList.goodsNo}', 'review');">상품평쓰기</button> --%>
							<button type="button" class="btn_review_go" onclick="open_review_pop('${goodsList.goodsNo}');">상품평쓰기</button>
						</c:if>
					</div>
				</div>
				<!--// 구매내역 1set -->
				<c:set var="ordNo" value="${resultList.orderInfoVO.ordNo}"/>
			</c:forEach>
		</c:forEach>

	   </c:when>
	  <c:otherwise>
	  </c:otherwise>
  </c:choose>