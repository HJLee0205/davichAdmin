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
    $(document).ready(function(){
        $( "div.my_shopping_view" ).hide();
        $( "div.my_shopping_view:first" ).show();
        
        $("ul.my_shopping_menu li").click(function () {
            var rel = $(this).attr("rel");
            $("ul.my_shopping_menu li").removeClass("active");
            $(this).addClass("active");
            $("div.my_shopping_view").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
            
           /*  if(rel=="view02"){
              
              var pageIndex = 1;
              var param = param = "page="+pageIndex;
              
              var url = '${_MOBILE_PATH}/front/order/order-cancel-list?'+param;
              
              Dmall.AjaxUtil.load(url, function(result) {
                   if('${so.totalPageCount}'==pageIndex){
                       $('#div_id_paging').hide();
                   }
                   $("#page").val(pageIndex);
                   $('.list_page_view em').text(pageIndex);
                       $("#" + activeTab).html(result);
              })
            } */
            
        });
    });
    function order_detail(idx){
        location.href = "/front/order/nomember-order-detail";
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 비회원 주문/배송조회 메인  --->
    <!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">
        <div class="mypage_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            나의 쇼핑내역
        </div>
        <div class="my_shopping_top">
            <ul class="my_shopping_info">
                <li>최근 2개월간 고객님의 주문내역입니다.</li>
                <li>주문번호를 클릭하시면 상세조회를 하실 수 있습니다.</li>
                <li>이전 내역 조회는 PC용 사이트에서 이용하실 수 있습니다.</li>
            </ul>        
        </div>
        <ul class="my_shopping_menu">
            <li class="active" rel="view01">전체주문내역</li>
            <li rel="view02">주문 취소/반품/교환 내역</li>
        </ul>
        <form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />
        <div class="my_shopping_view" id="view01">
            <c:set var="ordNo" value="0"/>
            <c:choose>
            <c:when test="${order_list.resultList ne null && fn:length(order_list.resultList) gt 0}">
                <div class="my_shopping_view_body">
                <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
                    <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
                        <!-- 구매내역 1set -->
                        <div class="my_order">
                            <a href="#" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">
                              <c:if test="${ordNo!= resultList.orderInfoVO.ordNo}">
                                <div class="my_order_no">
                                    주문번호 : ${resultList.orderInfoVO.ordNo}
                                </div>
                               </c:if>
                                <ul class="my_order_info_top">
                                    <li class="my_order_product_pic"><img src="${goodsList.imgPath}" alt=""></li>
                                    <li class="my_order_product_title">${goodsList.goodsNm}</li>
                                </ul>
                                <ul class="my_order_info_text">
                                   <c:forEach var="optionList" items="${goodsList.goodsAddOptList}" varStatus="status">
                                  <li>[${optionList.addOptNm}]</li>
                                   </c:forEach>
                                  <%--   <c:if test="${resultList.itemNm ne null}">
                                    <li>
                                        <span class="option_title">[기본옵션:${resultList.itemNm}]/${resultList.ordQtt}개</span>
                                        <span class="option_price"><em><fmt:formatNumber value="${resultList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                                    </li>
                                    </c:if>
                                     <c:forEach var="addOptionList" items="${order_info.resultList}" varStatus="status">
                                        <c:if test="${addOptionList.addOptYn eq 'Y' && resultList.ordNo == addOptionList.ordNo && resultList.itemNo == addOptionList.itemNo}">
                                            <li>
                                                <span class="option_title">[추가옵션:${addOptionList.goodsNm}]/${resultList.ordQtt}개</span>
                                                <span class="option_price"><em><fmt:formatNumber value="${resultList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                                            </li>
                                        </c:if>
                                    </c:forEach> --%>
                                </ul>
                                <ul class="my_order_detail">
                                    <li>
                                        <span class="title">주문상태</span>
                                        <p class="detail">
                                           ${goodsList.ordDtlStatusNm}
                                        </p>
                                    </li>
                                    <li>
                                        <span class="title">결제금액</span>
                                        <p class="detail">
                                            ${resultList.orderInfoVO.paymentAmt}원
                                        </p>
                                    </li>
                                </ul>
                            </a>
                            <div class="my_order_area">
                                <!-- 주문취소(주문완료,결제확인)-->
                                <c:if test="${(goodsList.ordDtlStatusCd eq '10' || goodsList.ordDtlStatusCd eq '20') && (resultList.orderInfoVO.ordStatusCd eq '10' || resultList.orderInfoVO.ordStatusCd eq '20')}">
                                <button type="button" class="btn_order_cancel" onclick="order_cancel_pop('${resultList.orderInfoVO.ordNo}');">주문취소</button>
                                </c:if>
                                <!-- 반품/교환(배송준비,배송중,배송완료) -->
                                <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                <button type="button" class="btn_order_cancel" onclick="order_exchange_pop('${resultList.orderInfoVO.ordNo}');">반품/교환</button>
                                <button type="button" class="btn_order_cancel" onclick="order_refund_pop('${resultList.orderInfoVO.ordNo}');">반품/환불</button>
                                </c:if>
                                <!-- 구매확정(배송중,배송완료)-->
                                <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                                     <button type="button" class="btn_order_ok" onclick="updateBuyConfirm('${goodsList.ordNo}','${goodsList.ordDtlSeq}','orderlist')">구매확정</button>
                                </c:if>
                                <!--상품평(배송중,배송완료,구매확정)-->
                                <c:if test="${goodsList.ordDtlStatusCd eq '50' || goodsList.ordDtlStatusCd eq '90'}">
                                    <button type="button" class="btn_review_go" onclick="goods_detail('${goodsList.goodsNo}');">상품평쓰기</button>
                                </c:if>
                                <button type="button" class="btn_review_go" onclick="goods_detail('${goodsList.goodsNo}');">문의하기</button>
                            </div>
                        </div>
                        <!--// 구매내역 1set -->
                    <c:set var="ordNo" value="${resultList.orderInfoVO.ordNo}"/>
                    </c:forEach>  
               </c:forEach>
            </div>    
               </c:when>
              <c:otherwise>
                 <!-- 주문상품이 없을 경우 -->
            <div class="no_order_history">
                조회 기간 동안 주문하신 상품이 없습니다.
            </div>
            <!--// 주문상품이 없을 경우 -->
              </c:otherwise>
          </c:choose>
            <!---- 페이징 ---->
            <div class="my_list_bottom" id="div_id_paging">
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!----// 페이징 ---->
        </div>
        <div class="my_shopping_view" id="view02">
	        <div class="my_shopping_view_body">
			    <ul class="my_cancel_history">
			        <c:choose>
			        <c:when test="${order_cancel_list.resultList ne null && fn:length(order_cancel_list.resultList) gt 0}">
                        <c:forEach var="resultList" items="${order_cancel_list.resultList}" varStatus="status">
                            <c:set var="grpId" value="${resultList.orderInfoVO.ordNo}"/>
                            <c:forEach var="goodsList" items="${resultList.orderGoodsVO}" varStatus="status">
			                <li>
			                    <div class="my_cancel_history_area">
			                        <span class="cancel_date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></span>
			                        주문번호 <a href="#1" onclick="move_order_detail('${resultList.orderInfoVO.ordNo}');">${resultList.orderInfoVO.ordNo}</a>
			                        <span class="${goodsList.ordDtlStatusCd =='11'?"label_cancel":"label_replace"}">${goodsList.ordDtlStatusNm}</span>
			                        <span class="cancel_price"><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span>
			                        <div class="my_cancel_title">
			                            ${goodsList.goodsNm}
			                        </div>
			                    </div>
			                </li>
			                 </c:forEach>
			             </c:forEach>
			         </c:when>
			         <c:otherwise>
			             <!-- 주문상품이 없을 경우 -->
			            <div class="no_order_history">
			                조회 기간 동안 주문하신 상품이 없습니다.
			            </div>
			            <!--// 주문상품이 없을 경우 -->
			           </c:otherwise>
			       </c:choose>
			        
			    </ul>
			     
			</div>
        
        </div>
          </form:form>    
    </div>    
    <!---// 03.LAYOUT:CONTENTS --->
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
    </t:putAttribute>
</t:insertDefinition>