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
	<t:putAttribute name="title">비회원 주문/배송조회</t:putAttribute>
	<t:putAttribute name="style">
        <link href="/front/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>


	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	<script src="/front/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
    <script>
    function order_detail(no, ordrMobile){
        Dmall.FormUtil.submit('/front/order/nomember-order-detail', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile});
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <form action="" id="nonOrderForm">
    </form>
    <!--- 비회원 주문/배송조회 메인  --->
    <div id="category_header">
		<div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>
					비회원 주문/배송조회
				</li>
			</ul>
		</div>
    </div>
	
	<div class="mypage_middle">       
		<!--- 비회원 주문/배송조회 왼쪽 메뉴 -->
		<%@ include file="include/nonmember_left_menu.jsp" %>
		<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->           
           
		<!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
		<div id="mypage_content">
			<div class="mypage_body">
				<h3 class="my_tit">비회원 주문/배송조회</h3>

				<h4 class="my_stit">주문/배송조회</h4>
				<table class="tCart_Board Mypage">
					<caption>
						<h1 class="blind">주문내역 및 배송현황 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:110px">
						<col style="width:45px">
						<col style="width:">
						<col style="width:80px">
						<col style="width:82px">
						<col style="width:74px">
						<col style="width:70px">
						<col style="width:100px">
					</colgroup>
					<thead>
							<tr>
								<th>주문일자/주문번호</th>
								<th colspan="2">상품/옵션/수량</th>
								<th>주문금액</th>
								<th>상태</th>
								<th>처리</th>
							</tr>
						</thead>
						<tbody>
		                    <c:choose>
		                        <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
		                        <c:set var="grpId" value=""/>
		                        <c:set var="preGrpId" value=""/>
		                        <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
		                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>
		                            <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
									<tr class="end_line">
		                                <c:if test="${grpId ne preGrpId }">
		                                <td rowspan="${fn:length(resultList.orderGoodsVO)}" class="textL">
											<span class="order_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
											<a href="javascript:;" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');" class="order_no">[${resultList.orderInfoVO.ordNo}]</a>
											<c:if test="${resultList.orderInfoVO.orgOrdNo eq null}">
												<button type="button" class="btn_order_detail" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');">주문상세내역</button>
											</c:if>
											<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
												<button type="button" class="btn_order_detail" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
                                            </c:if>
										</td>
										</c:if>
										<td class="noline">
											<div class="cart_img">
												<img src="${goodsList.imgPath}">
											</div>
										</td>
										<td class="textL vaT">
										
											<a href="/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}
		                                        <c:if test="${empty goodsList.itemNm}">
														&nbsp;&nbsp; ${goodsList.ordQtt} 개
		                                        </c:if>
											</a>
	                                        <c:if test="${!empty goodsList.itemNm}">
	                                        	<p class="option"><c:out value="${goodsList.itemNm}"/> ${goodsList.ordQtt} 개</p>
	                                        </c:if>
					                        <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
					                            <p class="option_s">
					                                ${optionList.addOptNm} (
					                                <c:choose>
					                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
					                                    +
					                                    </c:when>
					                                    <c:otherwise>

					                                    </c:otherwise>
					                                </c:choose>
					                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
					                                           ${optionList.addOptBuyQtt} 개
					                            </p>
					                        </c:forEach>

											<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
											<c:if test="${goodsList.freebieNm ne null}">
												<p class="option_s">사은품 : <c:out value="${goodsList.freebieNm}"/></p>
											</c:if>

											<!-- //사은품추가 2018-09-27 -->
										</td>
										
		                                <c:if test="${grpId ne preGrpId }">
											<td rowspan="${fn:length(resultList.orderGoodsVO)}">
												<span class="price"><fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/></span>원
											</td>
		                                </c:if>
										<td>
											<c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
                                                <span class="label_reservation">예약전용</span>
                                            </c:if>
                                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
    											${goodsList.ordDtlStatusNm}
                                                <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                                    <button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
                                                </c:if>
                                            </c:if>
										</td>
										<td>
                                            <c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
                                                <span class="label_reservation">예약전용</span>
                                            </c:if>
                                            <c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
		                                    <%--<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
		                                     	<button type="button" class="btn_go_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
		                                    </c:if>--%>
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
												<button type="button" class="btn_ordered" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')"onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','mypage')">구매확정</button><br>
												</c:if>
	                                        </c:if>
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<button type="button" class="btn_refund" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button><br>
												<button type="button" class="btn_refund" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
	                                        </c:if>
	                                        <%-- <c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
	                                            <button type="button" class="btn_refund" onclick="open_review_pop('${goodsList.goodsNo}');">상품평쓰기</button>
	                                        </c:if> --%>
	                                        <%-- <button type="button" class="btn_refund" onclick="open_question_pop('${goodsList.goodsNo}');">문의하기</button> --%>
                                            </c:if>
										</td>
									</tr>
		                            <c:set var="preGrpId" value="${grpId}"/>
									</c:forEach>
		                        </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="8">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>							
						</tbody>
				</table>
					
				<h4 class="my_stit">주문취소/교환/환불내역</h4>
				<table class="tCart_Board Mypage">
					<caption>
						<h1 class="blind">주문내역 및 배송현황 목록입니다.</h1>
					</caption>
					<colgroup>
							<col style="width:140px">
							<col style="width:102px">
							<col>
							<col style="width:100px">
							<col style="width:120px">
							<col style="width:110px">
							<col style="width:120px">
						</colgroup>
						<thead>
							<tr>
								<th>주문일자/주문번호</th>
								<th colspan="2">상품/옵션/수량</th>
								<th>신청가능수량</th>
								<th>환불가능금액</th>
								<th>상태</th>
								<th>처리</th>
							</tr>
						</thead>
						<tbody>
		                    <c:choose>
		                        <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
		                        <c:set var="grpId" value=""/>
		                        <c:set var="preGrpId" value=""/>
		                        <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
		                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>
									<c:set var="claimNo" value="${resultList.orderInfoVO.claimNo}"/>
		                            <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">

									<tr class="end_line">
		                                <c:if test="${grpId ne preGrpId }">
		                                <td rowspan="${fn:length(resultList.orderGoodsVO)}" class="textL">
											<span class="order_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
											<a href="javascript:;" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');" class="order_no">[${resultList.orderInfoVO.ordNo}]</a>
											<c:if test="${resultList.orderInfoVO.orgOrdNo eq null}">
												<button type="button" class="btn_order_detail" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');">주문상세내역</button>
											</c:if>
											<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
												<button type="button" class="btn_order_detail" onclick="move_nonmember_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
                                            </c:if>
										</td>
										</c:if>
										<td class="noline">
											<div class="cart_img">
												<img src="${goodsList.imgPath}">
											</div>
										</td>
										<td class="textL vaT">
										
											<a href="/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}
		                                        <c:if test="${empty goodsList.itemNm}">
														&nbsp;&nbsp; ${goodsList.ordQtt} 개
		                                        </c:if>
											</a>
	                                        <c:if test="${!empty goodsList.itemNm}">
	                                        	<p class="option"><c:out value="${goodsList.itemNm}"/> ${goodsList.ordQtt} 개</p>
	                                        </c:if>
					                        <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
					                            <p class="option_s">
					                                ${optionList.addOptNm} (
					                                <c:choose>
					                                    <c:when test="${optionList.addOptAmtChgCd eq '1'}">
					                                    +
					                                    </c:when>
					                                    <c:otherwise>

					                                    </c:otherwise>
					                                </c:choose>
					                                <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
					                                           ${optionList.addOptBuyQtt} 개
					                            </p>
					                        </c:forEach>
										</td>
										<td>
											<c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
												<span class="label_reservation">예약전용</span>
											</c:if>
											<c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
												${goodsList.ordQtt-goodsList.claimQtt}
											</c:if>
										</td>
		                                <c:if test="${grpId ne preGrpId }">
											<td rowspan="${fn:length(resultList.orderGoodsVO)}">
                                                <span class="price"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}" type="number"/></span>원
											</td>
		                                </c:if>
										<td>
											<c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
												<span class="label_reservation">예약전용</span>
											</c:if>
											<c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
											<c:if test="${goodsList.ordQtt ne goodsList.claimQtt}">
											${goodsList.ordDtlStatusNm}
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
												<button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
											</c:if>
											</c:if>
											<c:if test="${goodsList.ordQtt eq goodsList.claimQtt}">
												<c:choose>
													<c:when test="${goodsList.ordDtlStatusCd ne '40' and goodsList.ordDtlStatusCd ne '50' and goodsList.ordDtlStatusCd ne '90'}">
														${goodsList.ordDtlStatusNm}
													</c:when>
													<c:otherwise>
														-
													</c:otherwise>
												</c:choose>
											</c:if>
											</c:if>
										</td>
										<td>
											<c:if test="${goodsList.rsvOnlyYn eq 'Y'}">
												<span class="label_reservation">예약전용</span>
											</c:if>
											<c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
                                                <c:set var="claimCd" value="${fn:split(goodsList.claimCd,',')}"/>
                                                <c:set var="claimNm" value="${fn:split(goodsList.claimNm,',')}"/>
                                                <c:set var="returnCd" value="${fn:split(goodsList.returnCd,',')}"/>
                                                <c:set var="returnNm" value="${fn:split(goodsList.returnNm,',')}"/>

                                                <c:set var="pClaimQtt" value="${fn:split(goodsList.pclaimQtt,',')}"/>

												<c:if test="${claimNo eq null}">
													<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
														<button type="button" class="btn_go_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
													</c:if>
													<%--<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
														<button type="button" class="btn_ordered" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')"onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','mypage')">구매확정</button><br>
													</c:if>--%>

													<%-- 반품/교환/취소 신청가능여부--%>
													<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '67' || goodsList.ordDtlStatusCd eq '75'}">
														<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
														<button type="button" class="btn_refund" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button><br>
														<button type="button" class="btn_refund" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
														</c:if>
													</c:if>
                                                    <c:if test="${goodsList.ordQtt eq goodsList.claimQtt}">
                                                        <c:forEach var="claimNm" items="${claimNm}" varStatus="g">
                                                            <%--${returnNm[g.index]}/--%>${claimNm} (${pClaimQtt[g.index]})<br>
                                                        </c:forEach>
                                                    </c:if>
												</c:if>
												<c:if test="${claimNo ne null}">
													<c:if test="${goodsList.claimNm ne null}">
                                                    <c:forEach var="claimNm" items="${claimNm}" varStatus="g">
                                                        ${returnNm[g.index]}/${claimNm} (${pClaimQtt[g.index]})<br>
                                                    </c:forEach>
                                                    </c:if>
												</c:if>
											</c:if>
										</td>
									</tr>
		                            <c:set var="preGrpId" value="${grpId}"/>
									</c:forEach>
		                        </c:forEach>
		                        </c:when>
		                        <c:otherwise>
		                            <tr>
		                                <td colspan="9">조회된 데이터가 없습니다.</td>
		                            </tr>
		                        </c:otherwise>
		                    </c:choose>								
						</tbody>
				</table>
			</div>
		</div>
        <!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->
    </div>
    <!-- 취소팝업 -->
    <div id="div_order_cancel" style="display: none;">
        <div class="popup_my_order_cancel" id ="popup_my_order_cancel"></div>
    </div>
    <!-- 교환팝업 -->
    <div id="div_order_exchange" style="display: none;">
        <div class="popup_my_order_replace" id ="popup_my_order_replace"></div>
    </div>
    <!-- 환불팝업 -->
    <div id="div_order_refund" style="display: none;">
        <div class="popup_my_order_refund" id ="popup_my_order_refund"></div>
    </div>
    <!---// 비회원 주문/배송조회 메인 --->
    </t:putAttribute>
</t:insertDefinition>