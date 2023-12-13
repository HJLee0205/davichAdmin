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
    <t:putAttribute name="title">교환신청</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">    
    </t:putAttribute>
    
    <t:putAttribute name="content">
    <!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">  
        <div class="mypage_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            교환신청
        </div>
        <div class="my_order_no">
            주문번호 : ${so.ordNo}
        </div>
        
       <form:form id="form_id_exchage" commandName="so">
        <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
        <div class="myshopping_all_view_area">  
            <c:choose>
            <c:when test="${orderVO.orderGoodsVO ne null}">
            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:if test="${goodsList.addOptYn eq 'N'}">
            <div class="my_order" data-ord-no="${goodsList.ordNo}"  data-ord-dtl-seq="${goodsList.ordDtlSeq}">
                <!-- <ul class="my_order_detail" style="border-top:none">
                    <li>
                        <span class="title">배송지</span>
                        <p class="my_address_detail">
                            (100-809) 서울특별시 중구 명동길 74-2 (명동2가) 123123
                        </p>
                    </li>
                </ul> -->
                <ul class="my_order_info_top">
                    <li class="my_order_product_pic">
                         <div class="checkbox">          
                            <label for="itemNoArr_${status.index}">
                                <input type="checkbox" name="itemNoArr" id="itemNoArr_${status.index}">
                                <span></span>
                            </label>
                            <input type="hidden" name="itemNoArr" value="${goodsList.itemNo}"/>
                        </div>
                        <c:if test="${empty goodsList.imgPath}">
                        <img src="${_MOBILE_PATH}/front/img/product/cart_img01.gif">
                        </c:if>
                        <c:if test="${!empty goodsList.imgPath}">
                        <img src="${goodsList.imgPath}">
                        </c:if>
                    </li>
                    <li class="my_order_product_title">${goodsList.goodsNm}</li>
                </ul>
                <ul class="my_order_info_text">
                    <li>
                        <span class="option_title_check">[옵션] ${goodsList.itemNm} / ${goodsList.ordQtt}개</span>
                        <span class="option_price"><em><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> </em>원</span>
                    </li>
                    <c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
                        <c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
                        <li>
                            <span class="option_title_check">
                            [추가옵션] (${amtFlag})- ${addOptList.ordQtt}개]
                            </span>
                            <span class="option_price"><em><fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                        </li>
                        </c:if>
                    </c:forEach>
                </ul>
                <ul class="my_order_detail">
                    <li>
                        <span class="title">배송비</span>
                        <p class="detail f100B">
                            <fmt:formatNumber value="${goodsList.realDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                        </p>
                    </li>
                    <li>
                        <span class="title">주문상태</span>
                        <p class="detail">
                            ${goodsList.ordDtlStatusNm}
                            
                        </p>
                    </li>
                    <li>
                        <span class="title">결제금액</span>
                        <p class="detail">
                            <fmt:formatNumber value="${goodsList.payAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </p>
                    </li>
                    <li>
                        <span class="title">교환사유</span>
                        <p class="detail">
                        <select class="select_option" title="select option" name="claimReasonCd_${status.index}" id="claimReasonCd_${status.index}">
                            <code:optionUDV codeGrp="CLAIM_REASON_CD" />
                        </select>
                        </p>
                    </li>
                </ul>
                </div> 
            </c:if>
             
            </c:forEach>
            </c:when>
            <c:otherwise>
                <li>등록된 상품이 없습니다.</li>
            </c:otherwise>
            </c:choose>                
                   
            <h2 class="my_stit">
            <span>
            반품주소 <br><br>
                (136 - 130) 서울특별시 성북구 하월곡동 228번지 꿈의숲푸르지오 104동 603호
            </span>
            </h2>      
            <ul class="my_order_detail">
                <li>
                    <span class="title">상세사유</span>
                    <p class="textarea">
                         <textarea style="width:100%;height:128px" id="claimDtlReason" id="claimDtlReason"></textarea>
                    </p>
                </li>
            </ul>
            <div class="all_btn_cancel_area">
                <button type="button" class="btn_cancel_go" onclick="claim_exchange()">교환신청</button>
            </div>
        </div>  
      </form:form>
    </div>  
    <!---// 03.LAYOUT:CONTENTS --->

    </t:putAttribute>
</t:insertDefinition>