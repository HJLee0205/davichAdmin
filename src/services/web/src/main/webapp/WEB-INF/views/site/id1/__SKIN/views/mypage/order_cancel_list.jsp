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
	<t:putAttribute name="title">다비치마켓 :: 주문취소/교환/환불내역</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $(function() {
            $( ".datepicker" ).datepicker();
        });
        //검색
        $('.btn_form').on('click', function() {
            if($("#event_start").val() == '' || $("#event_end").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('/front/order/order-cancel-list', param);
        });
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
    <div class="mypage_middle">	

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <form:hidden path="period" id="period" />
                
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
				<div class="mypage_body">
					<h3 class="my_tit">주문취소/교환/반품 현황</h3>
					<div class="filter_datepicker date_select_area">
						<input type="text" class="date datepicker" id="ordDayS" name="ordDayS" value="${so.ordDayS}" >
						~
						<input type="text" class="date datepicker" id="ordDayE" name="ordDayE" value="${so.ordDayE}">
						<span class="btn_date_area">
							<button type="button" style="display:none"></button>
							<button type="button" <c:if test="${so.period eq '1' }">class="active"</c:if> >15일</button>
							<button type="button" <c:if test="${so.period eq '2' }">class="active"</c:if> >1개월</button>
							<button type="button" <c:if test="${so.period eq '3' }">class="active"</c:if> >3개월</button>
							<button type="button" <c:if test="${so.period eq '4' }">class="active"</c:if> >6개월</button>
							<button type="button" <c:if test="${so.period eq '5' }">class="active"</c:if> >1년</button>
						</span>
						<button type="button" class="btn_form">조회하기</button>
					</div>
					<table class="tCart_Board Mypage">
						<caption>
							<h1 class="blind">주문배송조회 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:140px">
							<col style="width:102px">
							<col style="width:">
							<col style="width:70px">
							<col style="width:120px">
							<col style="width:140px">
							<col style="width:110px">
						</colgroup>
						<thead>
							<tr>
								<th>주문일자/주문번호</th>
								<th colspan="2">상품/옵션/수량</th>
								<th>신청수량</th>
								<th>주문/환불금액</th>
								<th>상태(수량)</th>
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
											<a href="javascript:;" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');" class="order_no">[${resultList.orderInfoVO.ordNo}]</a>
											<c:if test="${resultList.orderInfoVO.orgOrdNo eq null}">
												<button type="button" class="btn_order_detail" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">주문상세내역</button>
											</c:if>
											<c:if test="${resultList.orderInfoVO.orgOrdNo ne null}">
												<button type="button" class="btn_order_detail" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">교환</button>
                                            </c:if>
										</td>
										</c:if>
										<td class="noline">
											<div class="cart_img">
												<img src="${_IMAGE_DOMAIN}${goodsList.imgPath}">
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
												${goodsList.claimQtt}

										</td>
		                                <c:if test="${grpId ne preGrpId }">

											<td rowspan="${fn:length(resultList.orderGoodsVO)}">
												<span class="price"><fmt:formatNumber value="${resultList.orderInfoVO.orgPaymentAmt}" type="number"/></span>원<br>/<br>
												<span class="price"><fmt:formatNumber value="${resultList.orderInfoVO.refundAmt}" type="number"/></span>원
											</td>
		                                </c:if>
										<td>
											<c:choose>
												<c:when test="${goodsList.returnCd eq '' and goodsList.claimCd eq ''}">
													${goodsList.ordDtlStatusNm}
													<c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
														<button type="button" class="btn_shipping" onclick="trackingDelivery('${goodsList.rlsCourierCd}','${goodsList.rlsInvoiceNo}')">배송조회</button>
													</c:if>
												</c:when>
												<c:otherwise>
													<c:set var="claimCd" value="${fn:split(goodsList.claimCd,',')}"/>
													<c:set var="claimNm" value="${fn:split(goodsList.claimNm,',')}"/>
													<c:set var="returnCd" value="${fn:split(goodsList.returnCd,',')}"/>
													<c:set var="returnNm" value="${fn:split(goodsList.returnNm,',')}"/>
													<c:set var="pClaimQtt" value="${fn:split(goodsList.pclaimQtt,',')}"/>
													<c:forEach var="claimNm" items="${claimNm}" varStatus="g">
														<c:choose>
															<c:when test="${claimCd eq '11'}">반품신청</c:when>
															<c:when test="${claimCd eq '12'}">반품완료</c:when>
															<c:otherwise>${claimNm}</c:otherwise>
														</c:choose>
														 (${pClaimQtt[g.index]})<br>
													</c:forEach>
													<%--${goodsList.ordDtlStatusNm}--%>
												</c:otherwise>
											</c:choose>
										</td>
										<td>
	                                        <%--<c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
	                                        	<button type="button" class="btn_ordered" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
	                                        </c:if>
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<c:if test="${goodsList.ordQtt > goodsList.claimQtt}">
												<button type="button" class="btn_refund" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">반품/교환</button><br>
												<button type="button" class="btn_refund" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품/환불</button>
												</c:if>
	                                        </c:if>--%>
	                                        <button type="button" class="btn_cancel_view" onclick="order_cancel_detail('${resultList.orderInfoVO.ordNo}','${goodsList.ordDtlSeq}','${goodsList.ordDtlStatusCd}');">상세보기</button>
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
					<!-- pageing -->
					<div class="tPages" id="div_id_paging"> 
	                    <grid:paging resultListModel="${order_list}" />
					</div>
					<!--// pageing -->
					
	                </form:form>
				</div>
			</div>		
			<!--// content -->	            
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

    <!-- 상세보기 레이어 팝업 -->
    <div id="div_order_cancel_layer" style="display: none;">
        <div class="popup_my_order_cancel_detail" id ="popup_my_order_cancel_layer"></div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>