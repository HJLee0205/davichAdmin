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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">마이페이지</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){

        $("#btn_modify_delivery").on('click', function() {
            location.href ="/front/member/delivery-list";
        });
        $("#btn_modify_email").on('click', function() {
            location.href ="/front/member/information-update-form";
        });
        $("#btn_modify_mobile").on('click', function() {
            location.href ="/front/member/information-update-form";
        });
        $(".my_point01").on('click', function() {
            location.href ="/front/member/savedmoney-list";
        });
        $(".my_point02").on('click', function() {
            location.href ="/front/member/point";
        });
        $(".my_point03").on('click', function() {
            location.href ="/front/coupon/coupon-list";
        });
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <div class="mypage_top">
                    <div class="my_benefit">
                        <h4>나의 혜택</h4>
                        <dl class="my_point01">
                            <dt>마켓포인트</dt>
                            <dd><span><fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</dd>
                        </dl>
                        <dl class="my_point02">
                            <dt>다비치포인트</dt>
                            <dd><span><fmt:formatNumber value="${member_info.data.prcPoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>P</dd>
                        </dl>
                        <dl class="my_point03" >
                            <dt>할인쿠폰</dt>
                            <dd><span>${member_info.data.cpCnt}</span>장</dd>
                        </dl>
                    </div>
                    <div class="my_order">
                        <h4>주문현황</h4>
                        <ul class="my_order_steps">
                            <li>
                                <span class="icon_my_order_steps01"></span>
                                <span class="labelB">주문접수</span>
                                <div class="my_order_steps_no">
                                    <span>${order_cnt_info.data.receiveOrderCount}</span>건
                                </div>
                            </li>
                            <li>
                                <span class="icon_my_order_steps02"></span>
                                <span class="labelB">상품준비</span>
                                <div class="my_order_steps_no">
                                    <span>${order_cnt_info.data.prepareOrderCount}</span>건
                                </div>
                            </li>
                            <li>
                                <span class="icon_my_order_steps03"></span>
                                <span class="labelB">배송중</span>
                                <div class="my_order_steps_no">
                                    <span>${order_cnt_info.data.deliveryOrderCount}</span>건
                                </div>
                            </li>
                            <li>
                                <span class="icon_my_order_steps04"></span>
                                <span class="labelB">배송완료</span>
                                <div class="my_order_steps_no">
                                    <span>${order_cnt_info.data.completeOrderCount}</span>건
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <h3 class="mypage_con_stit">
                    최근 주문/배송현황
                    <span>(최근 30일)</span>
                    <button type="button" class="btn_myorder_view" onclick="move_order();"></button>
                </h3>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">최근 주문/배송현황 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:112px">
                        <col style="width:45px">
                        <col style="width:">
                        <col style="width:80px">
                        <col style="width:82px">
                        <col style="width:74px">
                        <col style="width:70px">
                        <col style="width:70px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문일자<br>[주문번호]</th>
                            <th colspan="2">주문상품정보</th>
                            <th>주문금액<br>/수량</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                            <th>구매확정<br>/상품평</th>
                            <th>취소반품<br>/문의</th>
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
                            <tr>
                                <c:if test="${grpId ne preGrpId }">
                                <td rowspan="${fn:length(resultList.orderGoodsVO)}">
                                    <ul class="mypage_s_list f11">
                                        <li><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>[${resultList.orderInfoVO.ordNo}]</li>
                                        <li><button type="button" class="btn_mypage_s02" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">상세보기</button></li>
                                    </ul>
                                </td>
                                </c:if>
                                <td colspan="2" class="textL f12">
                                    <ul>
                                        <li>${goodsList.goodsNm}</li>
                                        <c:if test="${!empty goodsList.itemNm}">
                                        <li>[기본옵션-<c:out value="${goodsList.itemNm}"/>]</li>
                                        </c:if>
                                        <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
                                        <li>[추가옵션-${optionList.addOptNm}]</li>
                                        </c:forEach>
                                    </ul>
                                </td>
                                <td class="f12"><fmt:formatNumber value="${goodsList.saleAmt}" type="number"/><br>/${goodsList.ordQtt}</td>
                                <c:if test="${grpId ne preGrpId }">
                                <td rowspan="${fn:length(resultList.orderGoodsVO)}" class="f12">
                                ${resultList.orderInfoVO.paymentAmt}
                                </td>
                                </c:if>
                                <td class="f12">
                                    <ul class="mypage_s_list">
                                        <li>${goodsList.ordDtlStatusNm}</li>
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                        <li>
                                            <button type="button" class="btn_mypage_s02" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
                                        </li>
                                        </c:if>
                                    </ul>
                                </td>
                                <td>
                                    <ul class="mypage_s_list">
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                            <li><button type="button" class="btn_mypage_s03" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')"onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','mypage')">구매확정</button></li>
                                        </c:if>
                                        <c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                            <li><button type="button" class="btn_mypage_s03" onclick="goods_detail('${goodsList.goodsNo}');">상품평쓰기</button></li>
                                        </c:if>
                                    </ul>
                                </td>
                                <td>
                                    <ul class="mypage_s_list">
                                        <c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button></li>
                                        </c:if>
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">반품/교환</button></li>
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품/환불</button></li>
                                        </c:if>
                                        <li><button type="button" class="btn_mypage_s03" onclick="goods_detail('${goodsList.goodsNo}');">문의하기</button></li>
                                    </ul>
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
                <h3 class="mypage_con_stit">
                    관심상품 (<em>${interest_cnt}</em>)
                    <button type="button" class="btn_myfavorite_view" onclick="move_page('interest');"></button>
                </h3>
                <!--- 관심상품 --->
                <ul class="myfavorite_list">
                    <c:choose>
                        <c:when test="${!empty interest_goods}">
                            <data:goodsList value="${interest_goods}" displayTypeCd="01" headYn="N" iconYn="Y" topYn="Y"/>
                        </c:when>
                        <c:otherwise>
                            <p class="no_blank">등록된 상품이 없습니다.</p>
                        </c:otherwise>
                    </c:choose>
                </ul>
                <!---// 관심상품 --->

                <h3 class="mypage_con_stit" style="margin-top:5px">
                    확인해 주세요!
                </h3>
                <ul class="my_info_check">
                    <li class="box01">
                        <span class="tit">ADDRESS</span>
                        기본 배송지 설정
                        <button type="button" class="btn_mypage_s" id="btn_modify_delivery">수정</button>
                        <div class="my_info_check_text">
                        <c:forEach var="deliveryList" items="${delivery_list.resultList}" varStatus="status" end="4">
                        <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                            <c:if test="${deliveryList.memberGbCd eq '20'}" >
                            ${deliveryList.frgAddrCountry}&nbsp;${deliveryList.frgAddrState}&nbsp;${deliveryList.frgAddrCity}<br>
                            ${deliveryList.frgAddrDtl1}&nbsp;${deliveryList.frgAddrDtl2}
                            </c:if>
                            <c:if test="${deliveryList.memberGbCd eq '10'}" >
                            ${deliveryList.strtnbAddr}&nbsp;${deliveryList.roadAddr}&nbsp;${deliveryList.dtlAddr}
                            </c:if>
                        </c:if>
                        </c:forEach>
                        </div>
                    </li>
                    <li class="box02">
                        <span class="tit">EMAIL</span>
                        이메일 설정
                        <div class="my_info_check_text">
                            ${member_info.data.email}
                            <button type="button" class="btn_mypage_s" id="btn_modify_email">수정</button>
                        </div>
                    </li>
                    <li class="box03">
                        <span class="tit">MOBILE</span>
                        휴대폰 번호설정
                        <div class="my_info_check_text">
                            ${member_info.data.mobile}
                            <button type="button" class="btn_mypage_s" id="btn_modify_mobile">수정</button>
                        </div>
                    </li>
                </ul>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!-- 상품이미지 미리보기 팝업 -->
    <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "SM" />
    <%@ include file="/WEB-INF/views/include/popupLayer2.jsp" %>

    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
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
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>