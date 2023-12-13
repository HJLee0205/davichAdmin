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
    <t:putAttribute name="title">주문완료</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
        <c:if test="${paymentList.paymentPgCd eq '04'}">
          <script language=javascript>
          // 올더게이트 "지불처리중"팝업창 닫는 부분
          var openwin = window.open("about:blank","popup","width=300,height=160");
          openwin.close();
          </script>
        </c:if>
    </c:forEach>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 00.LAYOUT: MIDDLE AREA --->
    <!--- order content area --->
    <div id="middle_area">
        <div class="cart_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            주문완료
        </div>
        <ul class="order_steps">
            <li>
                <span class="icon_steps01"></span>
                <span class="title">장바구니</span>
            </li>
            <li>
                <span class="icon_steps02"></span>
                <span class="title">주문결제</span>
            </li>
            <li class="selected">
                <span class="icon_steps03"></span>
                <span class="title">주문완료</span>
            </li>
        </ul>

        <!--- 주문 목록 --->
        <div class="cart_detail_area">
            <div class="ordered_info">
                주문이 완료되었습니다.
                <span class="ordered_info02">
                    이용해 주셔서 감사합니다.<br>
                    (주문번호 : ${orderVO.orderInfoVO.ordNo})
                </span>
            </div>
            <h2 class="cart_stit"><span>주문상품 정보</span></h2>
            <ul class="order_list">
                <c:set var="payAmt" value="0" />
                <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                <c:set var="payAmt" value="${goodsList.payAmt}" />
                <c:if test="${goodsList.addOptYn eq 'N'}">
                <li style="margin-top:-1px">
                    <div class="order_product_info02">
                        <ul class="order_info_top">
                            <li class="order_product_pic"><img src="${goodsList.imgPath}" alt=""></li>
                            <li class="order_product_title">${goodsList.goodsNm}</li>
                        </ul>

                        <ul class="ordered_info_text">
                            <li>
                                <span class="option_title">${goodsList.itemNm} / <fmt:formatNumber value="${goodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 개</span>
                                <span class="option_price"><em><fmt:formatNumber value="${goodsList.saleAmt*goodsList.ordQtt-goodsList.dcAmt+addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                            </li>
                            <c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
                                <c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
                                    <c:choose>
                                        <c:when test="${addOptList.saleAmt gt 0}">
                                            <c:set var="amtFlag" value="+"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="amtFlag" value="-"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <li>
                                        <span class="option_title">${addOptList.addOptNm}/ ${addOptList.ordQtt} 개</span>
                                        <span class="option_price"><em>(${amtFlag})<fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                                        <c:set var="payAmt" value="${payAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                        <c:set var="addOptAmt" value="${addOptAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                    </li>
                                </c:if>
                            </c:forEach>
                        </ul>

                    </div>
                </li>
                </c:if>
                </c:forEach>
            </ul>
            <div class="order_price_area">
                <span>
                    총 결제금액    <em><fmt:formatNumber value="${orderVO.orderInfoVO.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em><b>원</b>
                </span>
            </div>
            <ul class="order_price_detail_list">
                <li class="form">
                    <span class="title">상품 금액 합</span>
                    <p class="detail total">
                        <fmt:formatNumber value="${orderVO.orderInfoVO.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                    </p>
                </li>
                <li class="form">
                    <span class="title">할인금액 합</span>
                    <p class="detail">
                        <span class="icon_price_minus"></span>
                        <c:set var="dcAmt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            <c:set var="dcAmt" value="${dcAmt+goodsList.dcAmt}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                    </p>
                </li>
                <li class="form">
                    <span class="title">배송비 합</span>
                    <p class="detail">
                        <span class="icon_price_plus"></span>
                        <c:set var="goodsDlvrAmt" value="0"/>
                        <c:set var="areaAddDlvrAmt" value="0"/>
                        <c:set var="dlvrAmt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                            <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                            <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${dlvrAmt == 0}">
                                무료
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${dlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                <br>
                                배송비: <fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                <br>
                                지역 추가 배송비:<fmt:formatNumber value="${areaAddDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            </c:otherwise>
                        </c:choose>
                    </p>
                </li>
                <li class="form">
                    <span class="title">합계</span>
                    <p class="detail total">
                        <em><fmt:formatNumber value="${orderVO.orderInfoVO.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
                    </p>
                </li>
            </ul>
            <h2 class="cart_stit"><span>결제정보</span></h2>
            <ul class="order_detail_list" style="margin-top:-1px">
                <li class="form">
                    <span class="title">결제수단</span>
                    <p class="detail">
                        <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
                           <c:if test="${status.index != 0}">
                           ,
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '23'}"> <%-- 신용카드 --%>
                           ${paymentList.paymentWayNm}_${paymentList.cardNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '01'}"> <%-- 마켓포인트 --%>
                           ${paymentList.paymentWayNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '11'}"> <%-- 무통장 --%>
                           <fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
                           ${paymentList.paymentWayNm}_${paymentList.bankNm}&nbsp;${paymentList.actNo} / ${paymentList.holderNm} / <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd HH:mm:ss" />까지 (<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '21'}"> <%-- 실시간계좌이체 --%>
                           ${paymentList.paymentWayNm}_${paymentList.bankNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '22'}"> <%-- 가상계좌 --%>
                           <fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
                           ${paymentList.paymentWayNm}_${paymentList.bankNm}&nbsp;${paymentList.actNo} / <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd HH:mm:ss" />까지 (<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '24'}"> <%-- 핸드폰결제 --%>
                           ${paymentList.paymentWayNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '31'}"> <%-- 간편결제(PAYCO) --%>
                           ${paymentList.paymentWayNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                           <c:if test="${paymentList.paymentWayCd eq '41'}"> <%-- PAYPAL --%>
                           ${paymentList.paymentWayNm}(<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                           </c:if>
                       </c:forEach>
                    </p>
                </li>
                <li class="form">
                    <span class="title">적립혜택</span>
                    <p class="detail">
                       <c:choose>
                            <c:when test="${orderVO.orderInfoVO.pvdSvmn != 0}">
                                구매확정 시 :마켓포인트 <fmt:formatNumber value="${orderVO.orderInfoVO.pvdSvmn}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            </c:when>
                            <c:otherwise>
                                <span class="fRed">적립혜택이 없습니다.</span>
                            </c:otherwise>
                       </c:choose>
                    </p>
                </li>
            </ul>
            <h2 class="cart_stit"><span>배송지 정보</span></h2>
            <ul class="order_detail_list" style="margin-top:-1px">
                <li class="form">
                    <span class="title">받는분</span>
                    <p class="detail">
                        ${orderVO.orderInfoVO.adrsNm}
                    </p>
                </li>
                <li class="form">
                    <span class="title">전화</span>
                    <p class="detail">
                        ${orderVO.orderInfoVO.adrsTel}
                    </p>
                </li>
                <li class="form">
                    <span class="title">휴대폰</span>
                    <p class="detail">
                        ${orderVO.orderInfoVO.adrsMobile}
                    </p>
                </li>
                <!-- <li class="form">
                    <span class="title">이메일</span>
                    <p class="detail">
                        moya1006@nate.com
                    </p>
                </li> -->
                <li class="form">
                    <span class="title">배송지</span>
                    <p class="address_detail">
                     <c:choose>
                        <c:when test="${orderVO.orderInfoVO.memberGbCd eq '10'}">
                            우편번호 : ${orderVO.orderInfoVO.postNo}<br>
                            지번주소 : ${orderVO.orderInfoVO.numAddr}<br>
                            도로명 주소 : ${orderVO.orderInfoVO.roadnmAddr}<br>
                            상세주소 : ${orderVO.orderInfoVO.dtlAddr}<br>
                        </c:when>
                        <c:otherwise>
                            COUNTRY : ${orderVO.orderInfoVO.frgAddrCountry}<br>
                            CITY : ${orderVO.orderInfoVO.frgAddrCity}<br>
                            STATE : ${orderVO.orderInfoVO.frgAddrState}<br>
                            ZIPCODE : ${orderVO.orderInfoVO.frgAddrZipCode}<br>
                            상세주소1 : ${orderVO.orderInfoVO.frgAddrDtl1}<br>
                            상세주소2 : ${orderVO.orderInfoVO.frgAddrDtl2}<br>
                        </c:otherwise>
                    </c:choose>
                    </p>
                </li>
                <li class="form">
                    <span class="title">배송메세지</span>
                    <p class="detail">
                        ${orderVO.orderInfoVO.dlvrMsg}
                    </p>
                </li>
            </ul>
            <div class="orderd_btn_area">
                <button type="button" class="btn_shopping_go" onclick="location.href='/m/front/main-view'">쇼핑계속하기</button>
            </div>
        </div>
    </div>
    <!---// order content area --->
    <!---// 00.LAYOUT: MIDDLE AREA --->

    </t:putAttribute>
</t:insertDefinition>