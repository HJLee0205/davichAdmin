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
	<t:putAttribute name="title">주문상세페이지</t:putAttribute>
	
	
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){

    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <sec:authentication var="user" property='details'/>
	<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
	<input type="hidden" id="hiddenUserId" value="${user.session.memberNo}"/>

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			주문상세
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
                <c:set var="sumCpAmt" value="0"/>
                <c:set var="sumDcAmt" value="0"/>
                <c:set var="sumMileage" value="0"/>
                <c:set var="sumDlvrAmt" value="0"/>
                <c:set var="sumPayAmt" value="0"/>
                <c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
                <c:set var="goodsNm" value=""/>
                <c:set var="rowPayAmt" value=""/>
                
                <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
				<c:if test="${orderGoodsVo.addOptYn eq 'N'}">
				
				<ul class="my_order_info_top">
					<li class="my_order_product_pic">
						<img src="${orderGoodsVo.imgPath}" alt="">
					</li>
					<li class="my_order_product_title">${orderGoodsVo.goodsNm}</li>
					<c:set var="goodsNm" value="${orderGoodsVo.goodsNm}"/>
				</ul>
				</c:if>
				<c:if test="${status.first}">
					<ul class="my_order_info_text">
				</c:if>
				 <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
				 <c:set var="rowPayAmt" value=""/>
					 <c:if test="${orderGoodsVo.itemNm ne ''}">
						<li>
							<span class="option_title">[옵션] ${orderGoodsVo.itemNm} / ${orderGoodsVo.ordQtt}개</span>
							<span class="option_price">
								<%-- <fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>*${orderGoodsVo.ordQtt} = --%>
								<fmt:formatNumber value="${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 
								(-<fmt:formatNumber value="${orderGoodsVo.ordQtt*orderGoodsVo.dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
								 <em><fmt:formatNumber value="${orderGoodsVo.saleAmt*orderGoodsVo.ordQtt-orderGoodsVo.ordQtt*orderGoodsVo.dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em> 원
								<c:set var="rowPayAmt" value="${rowPayAmt+orderGoodsVo.payAmt }"/>
							</span>
						</li>
					 </c:if>
						 <li>[상품코드 : ${orderGoodsVo.goodsNo}]</li>
                     <c:if test="${orderGoodsVo.freebieNm ne ''}">
                         <li>사은품<c:out value="${orderGoodsVo.freebieNm}"/></li>
                     </c:if>
				 </c:if>
				 
		 	 	 <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
		 	 	 <c:set var="totalRow" value="${totalRow - 1}"/>
					<li>
						<span class="option_title">${orderGoodsVo.goodsNm} / ${orderGoodsVo.ordQtt}개</span>
						<span class="option_price"><em><fmt:formatNumber value="${orderGoodsVo.payAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em> 원</span>
					</li>
					<c:set var="rowPayAmt" value="${rowPayAmt+orderGoodsVo.payAmt }"/>
				</c:if>
				<c:if test="${status.last}">
				</ul>
				</c:if>
				<c:if test="${orderGoodsVo.addOptYn eq 'N'}">
					<c:set var="dlvrcPaymentNm" value="${orderGoodsVo.dlvrcPaymentNm}"></c:set>
					<c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                        <c:if test="${orderGoodsVo.dlvrcPaymentCd ne '01' and orderGoodsVo.dlvrcPaymentCd ne '04'}">
                       	 <c:set var="dlvrAmt" value="${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}"></c:set>
                        </c:if>
                    </c:if>
					<c:set var="ordDtlStatusNm" value="${orderGoodsVo.ordDtlStatusNm}"></c:set>
					<c:set var="payAmt" value="${orderGoodsVo.payAmt}"></c:set>
					<%-- <c:set var="배송정보" value="${orderGoodsVo.배송정보}"></c:set> --%>
				</c:if>	
				<c:if test="${order_info.orderGoodsVO[status.index+1].addOptYn=='N' or status.last}">
				<ul class="my_order_detail">
					<li>
						<span class="title">배송비</span>
						<p class="detail f100B">
                           <fmt:formatNumber value="${dlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원 &nbsp;${dlvrcPaymentNm}     
						</p>
					</li>
					<li>
						<span class="title">주문상태</span>
						<p class="detail">
							 ${ordDtlStatusNm}
						</p>
					</li>
					<li>
						<span class="title">결제금액</span>
						<p class="detail">
							<fmt:formatNumber value="${rowPayAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</p>
					</li>
					<c:if test="${orderGoodsVo.rlsCourierNm!='null' and orderGoodsVo.rlsCourierNm!=''}">
					<li>
						<span class="title">택배정보</span>
						<p class="detail f100B">
							${orderGoodsVo.rlsCourierNm}<span class="bar_margin">|</span> ${orderGoodsVo.rlsInvoiceNo}  
							<%-- <c:set property="" value="${orderGoodsVo.payAmt}"></c:set> --%>
						</p>
					</li>
					</c:if>
				</ul>
				</c:if>
				
				<c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
                <c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
                <c:set var="sumCpAmt" value="${sumCpAmt +orderGoodsVo.cpUseAmt}"/>
                <c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt*orderGoodsVo.ordQtt}"/>
                <c:set var="sumMileage" value="${sumMileage + orderGoodsVo.addedAmountAmt}"/>
                <c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt}"/>
                <c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
                </c:forEach>
			</div>
			<!--// 주문상품 내용 -->

			<!-- 구매자 내용 -->
			<div class="my_order my_order_content" id="my_order02">
				<ul class="my_order_detail ">
					<li>
						<span class="title">주문하신 분</span>
						<p class="detail f100B">
							${order_info.orderInfoVO.ordrNm}
						</p>
					</li>
					<li>
						<span class="title">이메일 주소</span>
						<p class="detail f100B">
							${order_info.orderInfoVO.ordrEmail}
						</p>
					</li>
					<li>
						<span class="title">전화번호</span>
						<p class="detail f100B">
							${su.phoneNumber(order_info.orderInfoVO.ordrTel)}
						</p>
					</li>
					<li>
						<span class="title">휴대폰 번호</span>
						<p class="detail f100B">
							${su.phoneNumber(order_info.orderInfoVO.ordrMobile)}
						</p>
					</li>
				</ul>	
			</div>
			<!--// 구매자 내용 -->

			<!-- 결제 내용 -->
			<div class="my_order my_order_content" id="my_order03">	
				<ul class="my_order_detail">
					<li>
						<span class="title">결제방법</span>
						<p class="detail f100B">
							<c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
                            ${orderPayVO.paymentWayNm}
                            </c:forEach>
						</p>
					</li>
					<li>
						<span class="title">결제확인일시</span>
						<p class="detail f100B">
						
							<fmt:formatDate value="${order_info.orderInfoVO.paymentCmpltDttm}" pattern="yyyy-MM-dd HH:mm:ss" />
						</p>
					</li>
					<li>
						<span class="title">마켓포인트 사용금액</span>
						<p class="detail f100B">
							<fmt:formatNumber value='${sumMileage}' type='number'/> 원
						</p>
					</li>
					<li>
						<span class="title">쿠폰 사용금액</span>
						<p class="detail f100B">
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
						<p class="detail f100B">
							<fmt:formatNumber value="${sumPayAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</p>
					</li>
					<li>
						<span class="title">마켓포인트액</span>
						<p class="detail f100B">
							<fmt:formatNumber value="${order_info.orderInfoVO.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</p>
					</li>
				</ul>	
			</div>
			<!--// 결제 내용 -->

			<!-- 배송지 내용 -->
			<div class="my_order my_order_content" id="my_order04">
				<ul class="my_order_detail">
					<li>
						<span class="title">받으시는 분</span>
						<p class="detail f100B">
							${order_info.orderInfoVO.adrsNm}
						</p>
					</li>
					<li>
						<span class="title">상품정보</span>
						<p class="detail f100B">
							${goodsNm} 
							<c:if test="${totalRow-1>0 }">
							외 ${totalRow-1 } 개
							</c:if>
						</p>
					</li>
					<li>
						<span class="title">전화번호</span>
						<p class="detail f100B">
							 ${su.phoneNumber(order_info.orderInfoVO.adrsMobile)}
						</p>
					</li>
					<li>
						<span class="title">휴대폰 번호</span>
						<p class="detail f100B">
							${su.phoneNumber(order_info.orderInfoVO.adrsTel)}
						</p>
					</li>
					<li>
						<span class="title">주소</span>
						<p class="my_address_detail">
							지번주소: ${order_info.orderInfoVO.numAddr}<br>
                            도로명주소: ${order_info.orderInfoVO.roadnmAddr}<br>
                            상세주소: ${order_info.orderInfoVO.dtlAddr}<br>
						</p>
					</li>
					<li>
						<span class="title">배송 유의사항</span>
						<p class="detail f100B">
							${order_info.orderInfoVO.dlvrMsg}
						</p>
					</li>
				</ul>	
			</div>
			<!-- 배송지 내용 -->

			<h2 class="my_stit"><span>총 결제금액</span></h2>		
			<ul class="my_order_detail">
				<li>
					<span class="title">주문상품 수</span>
					<p class="detail f100B">
						${totalRow }종 (${sumQty }개)
					</p>
				</li>
				<li>
					<span class="title">마켓포인트</span>
					<p class="detail f100B">
						<fmt:formatNumber value='${sumMileage}' type='number'/>
					</p>
				</li>
				<li>
					<span class="title">상품 총 금액</span>
					<p class="detail f100B">
						<fmt:formatNumber value="${sumSaleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
					</p>
				</li>
				<%-- <li>
					<span class="title">총 할인 금액</span>
					<p class="detail f100B">
						<fmt:formatNumber value="${sumDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
					</p>
				</li> --%>
				
				<li>
					<span class="title">총 합계 금액</span>
					<p class="detail">
						<fmt:formatNumber value="${sumPayAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
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