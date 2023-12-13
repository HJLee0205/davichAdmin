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
                        <c:when test="${resultListModel.resultList ne null && fn:length(resultListModel.resultList) gt 0}">
			<div class="my_shopping_view_body">
                        <c:forEach var="resultList" items="${resultListModel.resultList}" varStatus="status">
                        <c:if test="${resultList.addOptYn eq 'N'}">
				<!-- 구매내역 1set -->
				<div class="my_order">
					<a href="#" onclick="move_order_detail('${resultList.ordNo}');">
					<c:if test="${ordNo!= resultList.ordNo}">
						<div class="my_order_no">
							주문번호 : ${resultList.ordNo}
						</div>
					</c:if>
						<ul class="my_order_info_top">
							<li class="my_order_product_pic"><img src="./front/img/cart/product_150_150.gif" alt=""></li>
							<li class="my_order_product_title">${resultList.goodsNm}</li>
						</ul>
						<ul class="my_order_info_text">
							<c:if test="${resultList.itemNm ne null}">
							<li>
								<span class="option_title">[기본옵션:${resultList.itemNm}]/${resultList.ordQtt}개</span>
								<span class="option_price"><em><fmt:formatNumber value="${resultList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
							</li>
							</c:if>
 							<c:forEach var="addOptionList" items="${order_info.resultList}" varStatus="status">
	                            <c:if test="${addOptionList.addOptYn eq 'Y' && resultList.ordNo == addOptionList.ordNo && resultList.itemNo == addOptionList.itemNo}">
									<li>
										<span class="option_title">[추가옵션:${addOptionList.goodsNm}]/${resultList.ordQtt}개</span>
										<span class="option_price"><em><fmt:formatNumber value="${resultList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
									</li>
								</c:if>
                            </c:forEach>
						</ul>
						<ul class="my_order_detail">
							<li>
								<span class="title">주문상태</span>
								<p class="detail">
									${resultList.ordDtlStatusNm}
								</p>
							</li>
							<li>
								<span class="title">결제금액</span>
								<p class="detail">
									<fmt:formatNumber value="${resultList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
								</p>
							</li>
						</ul>
					</a>
					<div class="my_order_area">
						<!-- 주문취소(주문완료,결제확인)-->
                        <c:if test="${resultList.ordDtlStatusCd eq '10' || resultList.ordDtlStatusCd eq '20'}">
						<button type="button" class="btn_order_cancel">주문취소</button>
						</c:if>
						<!-- 반품/교환(배송준비,배송중,배송완료) -->
                        <c:if test="${resultList.ordDtlStatusCd eq '30' || resultList.ordDtlStatusCd eq '40' || resultList.ordDtlStatusCd eq '50'}">
                        <button type="button" class="btn_order_cancel">반품/교환</button>
                        </c:if>
						<!-- 구매확정(배송중,배송완료)-->
                        <c:if test="${resultList.ordDtlStatusCd eq '40' || resultList.ordDtlStatusCd eq '50'}">
                         	<button type="button" class="btn_order_ok">구매확정</button>
                        </c:if>
                        <!--상품평(배송중,배송완료,구매확정)-->
                        <c:if test="${resultList.ordDtlStatusCd eq '40' || resultList.ordDtlStatusCd eq '50' || resultList.ordDtlStatusCd eq '30'}">
                            <button type="button" class="btn_review_go" onclick="goods_detail('${resultList.goodsNm}');">상품평쓰기</button>
                        </c:if>
						<button type="button" class="btn_review_go" onclick="goods_detail('${resultList.goodsNm}');">문의하기</button>
					</div>
				</div>
				<!--// 구매내역 1set -->
				</c:if>
		 			<c:set var="ordNo" value="${resultList.ordNo}"/>
               </c:forEach>	
			</div>	
               </c:when>
              <c:otherwise>
              </c:otherwise>
          </c:choose>
			 
			
		 