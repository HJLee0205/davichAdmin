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

<t:insertDefinition name="davichLayout">

	<t:putAttribute name="title">다비치마켓 :: 마이페이지</t:putAttribute>
	<t:putAttribute name="style">
		<link href="/front/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
	</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
		<script src="/front/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
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

	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
				<div class="mypage_body">
					<h4 class="my_stit">주문현황</h4>
					<div class="order_process">
						<ul class="left">
							<li><p>입금대기</p> <em>${order_cnt_info.data.receiveDepositCount}</em>건</li>
							<li><p>결제완료</p> <em>${order_cnt_info.data.receiveOrderCount}</em>건</li>
							<li><p>배송준비중</p> <em>${order_cnt_info.data.prepareOrderCount}</em>건</li>
							<li><p>배송중</p> <em>${order_cnt_info.data.deliveryOrderCount}</em>건</li>
							<li><p>배송완료</p> <em>${order_cnt_info.data.completeOrderCount}</em>건</li>
						</ul>
						<ul class="right">
							<li>취소 <em>${order_cnt_info.data.cancleOrderCount}</em></li>
							<li>교환 <em>${order_cnt_info.data.exchangeOrderCount}</em></li>
							<li>반품 <em>${order_cnt_info.data.returnOrderCount}</em></li>
						</ul>
					</div>
	            
					<h4 class="my_stit">
						최근 30일 주문현황
						<a href="javascript:void(0);" class="btn_view_alllist" onclick="move_order();">전체보기</a>
					</h4>
	            
					<table class="tCart_Board Mypage">
						<caption>
							<h1 class="blind">최근 30일 주문현황 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:140px">
							<col style="width:102px">
							<col style="width:">
							<col style="width:120px">
							<col style="width:110px">
							<col style="width:110px">
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
											<a href="/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">
												${goodsList.goodsNm}<c:if test="${empty goodsList.itemNm}">&nbsp;&nbsp;${goodsList.ordQtt}개</c:if>
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
	                                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<button type="button" class="btn_ordered" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}')"onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','mypage')">구매확정</button><br>
	                                        </c:if>
	                                       <%-- <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
												<button type="button" class="btn_refund" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">교환신청</button><br>
												<button type="button" class="btn_refund" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품신청</button>
	                                        </c:if>--%>
												<button type="button" class="btn_refund" onclick="goods_detail('${goodsList.goodsNo}', 'inquiry');">문의하기</button>
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
	
					<h4 class="my_stit top_margin">
						관심상품
						<a href="javascript:void(0);" class="btn_view_alllist" onclick="move_page('interest')">전체보기</a>
					</h4>
					<ul class="mypage_fav_product">
                        <c:forEach var="iList" items="${interest_goods}" varStatus="status">
							<li>
								<a href="/front/goods/goods-detail?goodsNo=${iList.goodsNo}">
									<div class="img_area">        
										<img src="${_IMAGE_DOMAIN}${iList.goodsDispImgS}" alt="">
									</div> 
									<div class="text_area">
										<p class="name"> ${iList.goodsNm} </p>
										<p class="price"><fmt:formatNumber value="${iList.salePrice}" type="number"/></p>
									</div>
								</a>
							</li> 
                        </c:forEach>
					</ul>					
				</div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
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