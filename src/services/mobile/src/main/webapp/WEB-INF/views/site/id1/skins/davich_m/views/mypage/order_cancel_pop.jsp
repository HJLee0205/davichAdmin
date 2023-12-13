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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">주문취소신청</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	</t:putAttribute>

	<t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			주문취소
		</div>
		<div class="my_order_no">
			주문번호 : ${so.ordNo}
		</div>

		<form:form id="form_id_cancel">
		<input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
		<input type="hidden" name="cancelType" id="cancelType" value="01"/>
		<input type="hidden" name="ordStatusCd" id="ordStatusCd" value="${orderVO.orderInfoVO.ordStatusCd}"/>
		<input type="hidden" name="memberOrdYn" id="memberOrdYn" value="${orderVO.orderInfoVO.memberOrdYn}"/>
		<c:set var="escrowYn" value="N"/>
		<c:set var="paycoYn" value="N"/>
		<c:forEach var="payList" items="${orderVO.orderPayVO }" varStatus="status">
			<c:if test="${payList.paymentPgCd eq '01' || payList.paymentPgCd eq '02' || payList.paymentPgCd eq '03' || payList.paymentPgCd eq '04'}">
				<c:if test="${payList.escrowYn eq 'Y'}">
					<c:set var="escrowYn" value="Y"/>
				</c:if>
			</c:if>
			<c:if test="${payList.paymentPgCd eq '41'}">
				<c:set var="paycoYn" value="Y"/>
			</c:if>
		</c:forEach>
		<input type="hidden" name="escrowYn" id="escrowYn" value="${escrowYn}"/>
		<input type="hidden" name="paycoYn" id="paycoYn" value="${paycoYn}"/>
		<div class="myshopping_all_view_area">
			<c:choose>
			<c:when test="${orderVO.orderGoodsVO ne null}">
			<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
			<c:if test="${goodsList.addOptYn eq 'N'}">
			<div class="my_order" data-ord-no="${goodsList.ordNo}"  data-ord-dtl-seq="${goodsList.ordDtlSeq}">
				<c:set var="disabled" value=""/>
				<c:if test="${goodsList.ordDtlStatusCd gt '20' }">
					<c:set var="disabled" value="disabled"/>
				</c:if>
				<div class="checkbox cancel_order_check">
					<label for="itemNoArr_${status.index}">
						<input type="checkbox" name="itemNoArr" id="itemNoArr_${status.index}" ${disabled}>
						<span></span>
						<input type="hidden" name="itemNoArr" value="${goodsList.itemNo}"/>
						<input type="hidden" name="claimQttArr" value="${goodsList.ordQtt}"/>
					</label>

				</div>
				<ul class="my_order_info_top cancel_order_list">
					<li class="my_order_product_pic">
						<c:if test="${empty goodsList.imgPath}">
						<img src="${_MOBILE_PATH}/front/img/product/cart_img01.gif">
						</c:if>
						<c:if test="${!empty goodsList.imgPath}">
						<img src="${goodsList.imgPath}">
						</c:if>
					</li>
					<li class="my_order_product_title">
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
						<ul class="my_order_info_text">
							<li>
								<span class="option_title_check">[옵션] ${goodsList.itemNm} / ${goodsList.ordQtt}개</span>
								<span class="option_price"><em><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> </em>원</span>
							</li>
							<c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
								<c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
								<li>
									<span class="option_title_check">
									[추가옵션] (${amtFlag})- ${addOptList.ordQtt}개]
									</span>
									<span class="option_price"><em><fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
								</li>
								</c:if>
							</c:forEach>
						</ul>
					</li>
				</ul>
				
				<ul class="my_order_detail">
					<li>
						<span class="title">배송비</span>
						<p class="detail f100B">
							<fmt:formatNumber value="${goodsList.realDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						</p>
					</li>
					<li>
						<span class="title">주문상태</span>
						<p class="detail">
							${goodsList.ordDtlStatusNm}
						</p>
					</li>
				</ul>
				<ul class="my_order_detail2">
					<li>
						<span class="title">결제금액</span>
						<p class="detail">
							<em><fmt:formatNumber value="${goodsList.payAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
						</p>
					</li>
				</ul>

			 </div>
			 </c:if>
			</c:forEach>
			</c:when>
			<c:otherwise>
				<li>등록된 상품이 없습니다.</li>
			</c:otherwise>
			</c:choose>



	<!-- 무통장입금일 경우만 환불계좌 입력란 노출 -->
	<c:forEach var="orderPayVO_Bank" items="${orderVO.orderPayVO}" varStatus="status">
	<c:if test="${(orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22') && orderVO.orderInfoVO.ordStatusCd eq '20'}">
		<input type="hidden" id="paymentWayCd" name="paymentWayCd" value="${orderPayVO_Bank.paymentWayCd}"/>
			<h2 class="my_stit"><span>환불방법</span></h2>
			<ul class="my_order_detail">
			<c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'Y'}">
				 <c:if test="${!empty refundModel.data.holderNm}">
				 <input type="hidden" id="holderNm" name="holderNm" value="${refundModel.data.holderNm}"/>
				 <input type="hidden" id="bankNm" name="bankNm" value="${refundModel.data.bankNm}"/>
				 <input type="hidden" id="bankCd" name="bankCd" value="${refundModel.data.bankCd}"/>
				 <input type="hidden" id="actNo" name="actNo" value="${refundModel.data.actNo}"/>
				 <input type="hidden" id="paymentNo" name="paymentNo" value="${orderPayVO_Bank.paymentNo }"/>
				<li>
					<span class="title">예금주</span>
					<p class="detail">
						 ${refundModel.data.holderNm}
					</p>
				</li>
				<li>
					<span class="title">은행명</span>
					<p class="detail">
						 ${refundModel.data.bankNm}
					</p>
				</li>
				<li>
					<span class="title">계좌번호</span>
					<p class="detail">
						${refundModel.data.actNo}
					</p>
				</li>
				</c:if>
				<c:if test="${empty refundModel.data}">
					<li><a href="${_MOBILE_PATH}/front/member/refund-account">등록된 환불 계좌가 없습니다.(환불/입금계좌 관리에서 등록해주세요)</a></li>
				</c:if>
			</c:if>
			<c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'N'}">
				<li>
					<span class="title">예금주</span>
					<p class="detail">
					<input type="text" id="holderNm" name="holderNm" style="width:calc(100% - 12px);">
					</p>
				</li>
				<li>
					<span class="title">은행명</span>
					<p class="detail">
					   <select name="bankCd" id="bankCd">
						   <code:option codeGrp="BANK_CD"/>
					   </select>
					</p>
				</li>
				<li>
					<span class="title">계좌번호</span>
					<p class="detail">
					<input type="text" id="actNo" name="actNo" placeholder="'-'없이 등록하세요" style="width:calc(100% - 12px);">
					</p>
				</li>
				<!-- <li>
					<span class="title">주거래계좌</span>
					<div class="checkbox" style="margin-top:10px;color:#000">
						<label>
							<input type="checkbox" name="select_order">
							<span></span>
						</label>
						주거래 계좌로 설정
					</div>
				</li> -->

			</c:if>
			</ul>
	</c:if>
	</c:forEach>
			<h2 class="my_stit">
			취소사유
			</h2>
			<div class="re_box">
				<select class="select_option" name="claimReasonCd" id="claimReasonCd" title="select option">
							<code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="true"  mode="S" usrDfn1Val="ALWAYS" />
						</select>
			</div>
			<h2 class="my_stit">
			상세사유
			</h2>
			<div class="re_box">
					<textarea  name="claimDtlReason" id="claimDtlReason" rows="4" placeholder="상세사유를 남겨주세요." ></textarea>
			</div>


			<!-- <h2 class="my_stit"><span>취소사유</span></h2>
			<ul class="my_order_detail">
				<li>
					<span class="title">취소사유</span>
					<p class="detail">
						<select class="select_option" name="claimReasonCd" id="claimReasonCd" title="select option">
							<code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="true"  mode="S"/>
						</select>
					</p>
				</li>
				<li>
					<span class="title">상세사유</span>
					<p class="textarea">
						<textarea  name="claimDtlReason" id="claimDtlReason" style="width:calc(100% - 12px);height:80px" placeholder="상세사유를 남겨주세요." ></textarea>
					</p>
				</li>
			</ul> -->
			<div class="order_cancel_warning">
				<span>※ 알아두세요!</span>
				- 신용카드로 주문/결제하신 경우 카드사에 따라 부분취소가 불가능할 수 있으니 이 경우에는 잔여상품에 대해 재 결제를 하셔야 합니다.
			</div>
			<div class="all_btn_cancel_area">
				<button type="button" class="btn_cancel_go" onclick="order_cancel();">취소신청</button>
				<!-- <button type="button" class="btn_cancel_close">닫기</button> -->
			</div>
		</div>
	  </form:form>
	</div>
	<!---// 03.LAYOUT:CONTENTS --->
	</t:putAttribute>
</t:insertDefinition>