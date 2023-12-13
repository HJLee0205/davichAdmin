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
	<t:putAttribute name="title">주문/배송조회</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $(function() {
            $( ".datepicker" ).datepicker();
        });
        //검색
        $('.btn_date').on('click', function() {
            if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/order/order-list', param);
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
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 쇼핑<span>&gt;</span>주문/배송 조회
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
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <h3 class="mypage_con_tit">
                    주문/배송조회
                    <span class="row_info_text">주문내역 및 배송현황을 확인할 수 있습니다.</span>
                </h3>
                <div class="date_select_area">
                    <p class="date_select_title">- 기간검색</p>
                    <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                    <input type="text" name="ordDayS" id="ordDayS" class="datepicker date" style="margin-left:8px" value="${so.ordDayS}" readonly="readonly" onkeydown="return false"> ~ <input type="text" name="ordDayE" id="ordDayE" class="datepicker date" value="${so.ordDayE}" readonly="readonly" onkeydown="return false">
                    <button type="button" class="btn_date" style="margin-left:8px">조회하기</button>
                </div>
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
                                    <ul class="mypage_s_list f12">
                                        <li>${goodsList.ordDtlStatusNm}</li>
                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                        <li><button type="button" class="btn_mypage_s02" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button></li>
                                        </c:if>
                                    </ul>
                                </td>
                                <td>
                                    <ul class="mypage_s_list">
                                       <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                       <li><button type="button" class="btn_mypage_s03" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')">구매확정</button></li>
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
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${order_list}" />
                </div>
                <!----// 페이징 ---->
                </form:form>

            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
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
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>