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
	<t:putAttribute name="title">비회원 주문상세</t:putAttribute>
	
	
	
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
    	
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <sec:authentication var="user" property='details'/>
	<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
   
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			비회원 주문상세
		</div>
		<div class="my_order_no">
			주문번호 : ${so.ordNo}
		</div>
		<ul class="my_order_menu">
			<li class="active" rel="my_order01">주문상품</li>
			<li rel="my_order02">구매자</li>
			<li rel="my_order03">결제</li>
			<li rel="my_order04">배송지</li>
		</ul>
		<div class="myshopping_all_view_area">	
			<!-- 주문상품 내용 -->
			<div class="my_order my_order_content" id="my_order01">
                <c:set var="sumQty" value="0"/>
                <c:set var="sumSaleAmt" value="0"/>
                <c:set var="sumTotalSaleAmt" value="0"/>
                <c:set var="sumDcAmt" value="0"/>
                <c:set var="sumMileage" value="0"/>
                <c:set var="sumDlvrAmt" value="0"/>
                <c:set var="sumPayAmt" value="0"/>
                <c:set var="preGrpCd" value=""/>
                <c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
                <c:set var="sumAddAptAmt" value="0"/>
                <c:set var="sumAreaAddDlvrc" value="0"/>
                
                <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
				<%--<c:if test="${orderGoodsVo.addOptYn eq 'N'}">--%>
				
				<ul class="my_order_info_top">
					<li class="my_order_product_pic">
						<img src="${orderGoodsVo.imgPath}" alt="">
					</li>
					<li class="my_order_product_title">
					
					<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${orderGoodsVo.goodsNo}">${orderGoodsVo.goodsNm}</a>
					<!-- 옵션시작 -->
						<%--<c:if test="${status.first}">--%>
						<ul class="my_order_info_text">
							<%--</c:if>--%>
							 <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
							 <c:set var="rowPayAmt" value=""/>
								 <c:if test="${orderGoodsVo.itemNm ne null}">
									<li>
										<span class="option_title">
										[옵션] ${orderGoodsVo.itemNm} / ${orderGoodsVo.ordQtt}개
										</span>
                                        <c:forEach var="optionList" items="${orderGoodsVo.goodsAddOptList}" varStatus="status">
                                        <span class="option_title">
                                            ${optionList.addOptNm} (
                                            <c:choose>
                                                <c:when test="${optionList.addOptAmtChgCd eq '1'}">
                                                    +
                                                </c:when>
                                                <c:otherwise>
                                                </c:otherwise>
                                            </c:choose>
                                            <fmt:formatNumber value="${optionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>) ${optionList.addOptBuyQtt} 개
                                            <c:set var="sumAddAptAmt" value="${sumAddAptAmt + (optionList.addOptAmt*optionList.addOptBuyQtt)}"/>
                                            </span>
                                        </c:forEach>

										<span class="option_price">
											<%-- <fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>*${orderGoodsVo.ordQtt} = --%>
											<%-- <fmt:formatNumber value="${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt+sumAddAptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> --%>
											<c:if test="${orderGoodsVo.dcAmt>0}">
											(-<fmt:formatNumber value="${orderGoodsVo.dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                            </c:if>
											 <em><fmt:formatNumber value="${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt-orderGoodsVo.dcAmt+sumAddAptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em> 원
										</span>
									</li>
								 </c:if>
								 <c:if test="${empty orderGoodsVo.itemNm}">
									<li>
										<span class="option_title">${orderGoodsVo.ordQtt} 개</span>
									</li>
                                 </c:if>
									 <!-- <li>[상품코드 : ${orderGoodsVo.goodsNo}]</li> -->
								 <c:if test="${orderGoodsVo.freebieNm ne null}">
									 <li>사은품<c:out value="${orderGoodsVo.freebieNm}"/></li>
								 </c:if>
                                 <c:set var="rowPayAmt" value="${rowPayAmt+orderGoodsVo.payAmt }"/>
							 </c:if>
							 
							 <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
							 <c:set var="totalRow" value="${totalRow - 1}"/>
								<li>
									<span class="option_title">${orderGoodsVo.goodsNm} / ${orderGoodsVo.ordQtt}개</span>
									<span class="option_price"><em><fmt:formatNumber value="${orderGoodsVo.payAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em> 원</span>
								</li>
								<c:set var="rowPayAmt" value="${rowPayAmt+orderGoodsVo.payAmt }"/>
							</c:if>
						</ul><!-- //my_order_info_text -->
						<%--<c:if test="${status.last}">--%>
						</li>
						<%--</c:if>--%>
						<!--// 옵션끝 -->
					<c:set var="goodsNm" value="${orderGoodsVo.goodsNm}"/>
				</ul><!-- //my_order_info_top -->
				<%--</c:if>--%>
                    <%-- **** 배송비 계산 **** --%>
                    <c:choose>
                        <c:when test="${orderGoodsVo.dlvrSetCd eq '1' && orderGoodsVo.dlvrcPaymentCd eq '01'}">
                            <c:set var="grpId" value="${orderGoodsVo.sellerNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                        </c:when>
                        <c:when test="${orderGoodsVo.dlvrSetCd eq '1' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%--or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                            <c:set var="grpId" value="${orderGoodsVo.sellerNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                        </c:when>
                        <c:when test="${orderGoodsVo.dlvrSetCd eq '4' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%-- or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                            <c:set var="grpId" value="${orderGoodsVo.goodsNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                        </c:when>
                        <c:when test="${orderGoodsVo.dlvrSetCd eq '6' && (orderGoodsVo.dlvrcPaymentCd eq '02')}"><%-- or orderGoodsVo.dlvrcPaymentCd eq '04'--%>
                            <c:set var="grpId" value="${orderGoodsVo.goodsNo}**${orderGoodsVo.dlvrSetCd}**${orderGoodsVo.dlvrcPaymentCd}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="dlvrcPaymentCd" value="${orderGoodsVo.dlvrcPaymentCd}"/>
                            <c:if test="${orderGoodsVo.dlvrcPaymentCd eq null}">
                                <c:set var="dlvrcPaymentCd" value="null"/>
                            </c:if>
                            <c:set var="grpId" value="${orderGoodsVo.itemNo}**${orderGoodsVo.dlvrSetCd}**${dlvrcPaymentCd}"/>
                        </c:otherwise>
                    </c:choose>


				<%--<c:if test="${order_info.orderGoodsVO[status.index+1].addOptYn=='N' or status.last}">--%>
				<ul class="my_order_detail3">
					<%-- <li>
						<span class="title">배송비</span>
						<p class="detail f100B">
                            <c:if test="${preGrpId ne grpId }">
                            <c:choose>
                                <c:when test="${dlvrPriceMap.get(grpId) eq '0' || empty dlvrPriceMap.get(grpId)}">
                                    <c:choose>
                                        <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                        <span class="label_reservation">예약전용</span> /${orderGoodsVo.sellerNm}
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '03'}">
                                                    무료 / 착불 / ${orderGoodsVo.sellerNm}
                                                </c:when>
                                                <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '04'}">
                                                    무료 / <span class="label_shop">매장픽업</span> / ${orderGoodsVo.sellerNm}
                                                </c:when>
                                                <c:otherwise>
                                                    무료 / ${orderGoodsVo.sellerNm}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
                                            <span class="label_reservation">예약전용</span> / ${orderGoodsVo.sellerNm}
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '03'}">
                                                    (<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                                                    / 착불 / ${orderGoodsVo.sellerNm}
                                                </c:when>
                                                <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '04'}">
                                                    <fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                                    / <span class="label_shop">매장픽업</span> / ${orderGoodsVo.sellerNm}
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                                    / ${orderGoodsVo.sellerNm}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${orderGoodsVo.dlvrcPaymentCd ne '03'}" >
                                <c:set var="sumDlvrAmt" value="${sumDlvrAmt+ dlvrPriceMap.get(grpId)}"/>
                            </c:if>
                        </c:if>
                        <c:set var="preGrpId" value="${grpId}"/>
						</p>
					</li> --%>
					<li>
						<span class="title">주문상태</span>
						<p class="detail">
							<c:if test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
								<span class="label_reservation">예약전용</span>
							</c:if>
							<c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
								${orderGoodsVo.ordDtlStatusNm}
								<c:if test="${orderGoodsVo.dlvrcPaymentCd eq '04'}"><span class="label_shop marginL05">매장픽업</span></c:if>
                                <c:if test="${orderGoodsVo.ordDtlStatusCd eq '40' || orderGoodsVo.ordDtlStatusCd eq '50' || orderGoodsVo.ordDtlStatusCd eq '90'}">
			                        <c:forEach var="dlvrList" items="${order_info.deliveryVOList}" varStatus="status">
		                                <c:if test="${orderGoodsVo.ordDtlSeq eq dlvrList.ordDtlSeq}">
											&nbsp;&nbsp;<button type="button" class="btn_delivery_go" onclick="trackingDelivery('${dlvrList.rlsCourierCd}','${dlvrList.rlsInvoiceNo}')">배송조회</button>
										</c:if>	                        	
			                        </c:forEach>
                                </c:if>
							</c:if>

						</p>
					</li>
					<li>
						<span class="title">상품금액</span>
						<p class="detail">
							<fmt:formatNumber value='${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt+sumAddAptAmt}' type='number'/>원
						</p>
					</li>
					<li>
						<span class="title">할인금액</span>
						<p class="detail">
							<c:if test="${orderGoodsVo.dcAmt ne 0}">-</c:if>
							<fmt:formatNumber value='${orderGoodsVo.dcAmt}' type='number'/>원
						</p>
					</li>
					<li>
						<span class="title">주문금액</span>
						<p class="detail">
							<c:if test="${orderGoodsVo.rsvOnlyYn eq 'Y'}">
								<span class="label_reservation">예약전용</span>
							</c:if>
							<c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
                            	<fmt:formatNumber value='${(orderGoodsVo.saleAmt*orderGoodsVo.ordQtt+sumAddAptAmt)-orderGoodsVo.dcAmt}' type='number'/>원
							</c:if>
						</p>
					</li>
					<c:if test="${orderGoodsVo.rlsCourierNm!='null' and orderGoodsVo.rlsCourierNm!=''}">
					<li>
						<span class="title">택배정보</span>
						<p class="detail f100B">
						    <c:choose>
						    <c:when test="${orderGoodsVo.rlsCourierNm ne null }">
                                ${orderGoodsVo.rlsCourierNm}
                            </c:when>
                            <c:otherwise>
                                -
                            </c:otherwise>
                            </c:choose>

                            <c:choose>
                            <c:when test="${orderGoodsVo.rlsInvoiceNo ne null }">
                                <span class="bar_margin">|</span> ${orderGoodsVo.rlsInvoiceNo}
                            </c:when>
                            <c:otherwise>

                            </c:otherwise>
                            </c:choose>

							<%-- <c:set property="" value="${orderGoodsVo.payAmt}"></c:set> --%>
						</p>
					</li>
					</c:if>
				</ul><!-- //my_order_detail2 -->
				<%--</c:if>--%>
					<c:if test="${orderGoodsVo.rsvOnlyYn ne 'Y'}">
						<c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
						<c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)+sumAddAptAmt}"/>
						<c:set var="sumTotalSaleAmt" value="${sumTotalSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
						<c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt}"/>
						<%--<c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc}"/>--%>
						<c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
						<c:set var="sumAreaAddDlvrc" value="${sumAreaAddDlvrc + orderGoodsVo.areaAddDlvrc}"/>
					</c:if>
                </c:forEach>
			</div>
			<!--// 주문상품 내용 -->

			<!-- 구매자 내용 -->
			<div class="my_order my_order_content" id="my_order02">
				<ul class="my_order_detail4">
					<li>
						<span class="title">주문하신 분</span>
						<p class="detail">
							${order_info.orderInfoVO.ordrNm}
						</p>
					</li>
					<li>
						<span class="title">이메일 주소</span>
						<p class="detail">
							${order_info.orderInfoVO.ordrEmail}
						</p>
					</li>
					<li>
						<span class="title">전화번호</span>
						<p class="detail">
							${su.phoneNumber(order_info.orderInfoVO.ordrTel)}
						</p>
					</li>
					<li>
						<span class="title">휴대폰 번호</span>
						<p class="detail">
							${su.phoneNumber(order_info.orderInfoVO.ordrMobile)}
						</p>
					</li>
				</ul>	
			</div>
			<!--// 구매자 내용 -->

			<!-- 결제 내용 -->
			<div class="my_order my_order_content" id="my_order03">
				<ul class="my_order_detail4">
					<li>
						<span class="title">결제방법</span>
						<p class="detail">
							<c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
								${orderPayVO.paymentWayNm}
								<c:if test="${orderPayVO.paymentWayCd eq '11' || orderPayVO.paymentWayCd eq '22'}">
									<br>${orderPayVO.bankNm}&nbsp; (${orderPayVO.actNo})&nbsp; ${orderPayVO.holderNm}
									<c:choose>
										<c:when test="${orderPayVO.ordStatusCd eq '10'}">
											<fmt:parseDate var="dpstScdDt" value="${orderPayVO.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
											<br>입금마감 : <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" />
										</c:when>
										<c:when test="${orderPayVO.ordStatusCd eq '20'}">
											<br>입금확인일시 : ${orderPayVO.paymentCmpltDttm}
										</c:when>
									</c:choose>
								</c:if>
                            </c:forEach>
						</p>
					</li>
					<li>
						<span class="title">결제확인일시</span>
						<p class="detail">
							<c:if test="${order_info.orderInfoVO.paymentCmpltDttm ne null}">
							<fmt:formatDate value="${order_info.orderInfoVO.paymentCmpltDttm}" pattern="yyyy-MM-dd HH:mm:ss" />
							</c:if>
							<c:if test="${order_info.orderInfoVO.paymentCmpltDttm eq null}">
							-
							</c:if>
						</p>
					</li>
					<li>
						<span class="title">마켓포인트 사용금액</span>
						<p class="detail">
                            <c:forEach var="pVO" items="${order_info.orderPayVO}" varStatus="status">
                                <c:if test="${pVO.paymentWayCd eq '01'}" >
                                    <c:set var="sumMileage" value="${sumMileage + pVO.paymentAmt}"/>
                                </c:if>
                            </c:forEach>
                            <fmt:formatNumber value='${sumMileage}' type='number'/>원
						</p>
					</li>
					<li>
						<span class="title">쿠폰 사용금액</span>
						<p class="detail">
							<fmt:formatNumber value="${order_info.orderInfoVO.cpUseAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</p>
					</li>
					<!-- <li>
						<span class="title">기타 할인금액</span>
						<p class="detail f100B">
							0원(PC버전 미구현)
						</p>
					</li> -->
					<li>
						<span class="title">총 결제 금액</span>
						<p class="detail">
							<em><fmt:formatNumber value='${sumPayAmt + sumAddAptAmt-sumMileage}' type='number'/></em> 원
						</p>
					</li>
					<li>
						<span class="title">마켓포인트 적립금액</span>
						<p class="detail">
							<fmt:formatNumber value="${order_info.orderInfoVO.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</p>
					</li>
				</ul>	
			</div>
			<!--// 결제 내용 -->

			<!-- 배송지 내용 -->
			<div class="my_order my_order_content" id="my_order04">
				<ul class="my_order_detail4">
					<li>
						<span class="title">받으시는 분</span>
						<p class="detail">
							${order_info.orderInfoVO.adrsNm}
						</p>
					</li>
					<li>
						<span class="title">상품정보</span>
						<p class="detail">
							${goodsNm} 
							<c:if test="${totalRow-1>0 }">
							외 ${totalRow-1 } 개
							</c:if>
						</p>
					</li>
					<li>
						<span class="title">전화번호</span>
						<p class="detail">
							${order_info.orderInfoVO.adrsTel eq null?'-':su.phoneNumber(order_info.orderInfoVO.adrsTel)}
						</p>
					</li>
					<li>
						<span class="title">휴대폰 번호</span>
						<p class="detail">
							${su.phoneNumber(order_info.orderInfoVO.adrsMobile)}
						</p>
					</li>
					<li>
						<span class="title">지번주소</span>
						<p class="detail">${order_info.orderInfoVO.numAddr}</p>
					</li>
					<li>
						<span class="title">도로명주소</span>
						<p class="detail">${order_info.orderInfoVO.roadnmAddr eq null?'-':order_info.orderInfoVO.roadnmAddr}</p>
					</li>
					<li>
						<span class="title">상세주소</span>
						<p class="detail">${order_info.orderInfoVO.dtlAddr}</p>
					</li>
					<li>
						<span class="title">배송 유의사항</span>
						<p class="detail">
							${order_info.orderInfoVO.dlvrMsg}
						</p>
					</li>
				</ul>	
			</div>
			<!-- //배송지 내용 -->

			<h2 class="my_stit">총 결제금액</h2>		
			<!-- <ul class="my_order_detail"> -->
			<ul class="order_price_detail_list">
				<li class="form">
					<span class="title">주문상품 수</span>
					<p class="detail f100B">
						${totalRow }종 (${sumQty }개)
					</p>
				</li>
				<li class="form">
					<span class="title">마켓포인트</span>
					<p class="detail f100B">
                        <c:forEach var="pVO" items="${order_info.orderPayVO}" varStatus="status">
                            <c:if test="${pVO.paymentWayCd eq '01'}" >
                                <c:set var="sumMileage" value="${sumMileage + pVO.paymentAmt}"/>
                            </c:if>
                        </c:forEach>
                        <fmt:formatNumber value='${sumMileage}' type='number'/>
					</p>
				</li>
				<li class="form">
					<span class="title">상품 총 금액</span>
					<p class="detail f100B">
						<fmt:formatNumber value="${sumSaleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
					</p>
				</li>
				 <li class="form">
					<span class="title">총 할인 금액</span>
					<p class="detail f100B">
					 <c:if test="${sumDcAmt ne 0}">
                       -
                     </c:if>
						<fmt:formatNumber value="${sumDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
					</p>
				</li>
                <li class="form">
                    <span class="title">배송비</span>
                    <p class="detail f100B">
                        <fmt:formatNumber value='${sumDlvrAmt}' type='number'/>원
                    </p>
                </li>
                <li class="form">
                    <span class="title">추가 배송비</span>
                    <p class="detail f100B">
                        <fmt:formatNumber value='${sumAreaAddDlvrc}' type='number'/>원
                    </p>
                </li>
				
				<li class="form">
					<span class="title">총 합계 금액</span>
					<p class="detail total">
						<em><fmt:formatNumber value='${sumPayAmt + sumAddAptAmt-sumMileage}' type='number'/></em> 원
					</p>
				</li>
			</ul>
			<c:if test="${order_info.orderInfoVO.ordStatusCd eq '10' || order_info.orderInfoVO.ordStatusCd eq '20'}">
            <div class="all_btn_cancel_area">
                <button type="button" class="btn_all_cancel" onclick="order_cancel_pop('${so.ordNo}');">주문취소</button>
            </div>
            
            </c:if>
			
		</div>	
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->

    </t:putAttribute>
</t:insertDefinition>