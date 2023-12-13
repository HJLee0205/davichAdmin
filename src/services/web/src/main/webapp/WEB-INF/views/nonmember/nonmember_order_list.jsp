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
	<t:putAttribute name="title">비회원 주문/배송조회</t:putAttribute>


	<t:putAttribute name="script">
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
    <div class="contents fixwid">
        <div id="mypage_location">
            <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 쇼핑<span>&gt;</span>비회원 주문/배송조회
        </div>
        <h2 class="sub_title">비회원 주문/배송조회<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 비회원 주문/배송조회 왼쪽 메뉴 --->
            <!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    주문/배송조회
                    <span class="row_info_text">주문내역 및 배송현황을 확인할 수 있습니다.</span>
                </h3>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문내역 및 배송현황 목록입니다.</h1>
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
                                        <li><button type="button" class="btn_mypage_s02" onclick="order_detail('${resultList.orderInfoVO.ordNo}', '${so.nonOrdrMobile}');">상세보기</button></li>
                                    </ul>
                                </td>
                                <td class="pix_img2">
                                    <img src="${goodsList.imgPath}">
                                </td>
                                </c:if>
                                <td class="textL f12">
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
                                    ${resultList.orderInfoVO.paymentAmt}원
                                </td>
                                </c:if>
                                <td class="f12">
                                    <ul class="mypage_s_list f12">
                                        <li>${goodsList.ordDtlStatusNm}</li>
                                        <!--배송완료버튼(배송중,배송완료,구매확정)-->
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                        <li><button type="button" class="btn_mypage_s02" onclick="trackingDelivery('05','694217343793')">배송조회</button></li>
                                        </c:if>
                                    </ul>
                                </td>
                                <td>
                                    <ul class="mypage_s_list">
                                    <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                        <li><button type="button" class="btn_mypage_s03" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')">구매확정</button></li>
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
                                <td colspan="7">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->
                </br></br>
                <!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
                <h3 class="mypage_con_tit">
                    주문취소/교환/환불내역
                    <span class="row_info_text">고객님께서 신청한 주문취소/교환/환불 처리내역을 확인 하실 수 있습니다.</span>
                </h3>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문내역 및 배송현황 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:112px">
                        <col style="width:45px">
                        <col style="width:">
                        <col style="width:80px">
                        <col style="width:82px">
                        <col style="width:74px">
                        <col style="width:110px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문일자<br>[주문번호]</th>
                            <th colspan="2">주문상품정보</th>
                            <th>주문금액<br>/수량</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                            <th>취소반품/문의</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                        <c:when test="${order_cancel_list.resultList ne null && fn:length(order_cancel_list.resultList) gt 0}">
                        <c:set var="grpId" value=""/>
                        <c:set var="preGrpId" value=""/>
                        <c:forEach var="resultList" items="${order_cancel_list.resultList}" varStatus="status">
                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>
                            <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
                            <tr>
                                <c:if test="${grpId ne preGrpId }">
                                <td rowspan="${fn:length(resultList.orderGoodsVO)}">
                                    <ul class="mypage_s_list f11">
                                        <li>${fn:substring(resultList.orderInfoVO.ordAcceptDttm, 0, 10)}<br>[${resultList.orderInfoVO.ordNo}]</li>
                                        <li><button type="button" class="btn_mypage_s02" onclick="order_detail('${resultList.orderInfoVO.ordNo}', '${so.nonOrdrMobile}');">상세보기</button></li>
                                    </ul>
                                </td>
                                </c:if>
                                <td class="pix_img2">
                                    <img src="${goodsList.imgPath}">
                                </td>
                                <td class="textL f12">
                                    <ul>
                                        <li>${goodsList.goodsNm}</li>
                                        <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
                                        <li>[${optionList.addOptNm}]</li>
                                        </c:forEach>
                                    </ul>
                                </td>
                                <td class="f12">
                                    <ul>
                                        <li><fmt:formatNumber value="${goodsList.saleAmt}" type="number"/>원</li>
                                        <li>/ ${goodsList.ordQtt}개</li>
                                    </ul>
                                </td>
                                <c:if test="${grpId ne preGrpId }">
                                <td rowspan="${fn:length(resultList.orderGoodsVO)}" class="f12">
                                    ${resultList.orderInfoVO.paymentAmt}원
                                </td>
                                </c:if>
                                <td class="f12">
                                    ${goodsList.ordDtlStatusNm}
                                </td>
                                <td>
                                    <ul class="mypage_s_list">
                                        <c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_cancel_pop('${resultList.ordNo}');">주문취소</button></li>
                                        </c:if>
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_exchange_pop('${resultList.ordNo}');">반품/교환</button></li>
                                        <li><button type="button" class="btn_mypage_s03" onclick="order_refund_pop('${resultList.ordNo}');">반품/환불</button></li>
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
                                <td colspan="7">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            <!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->
        </div>
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