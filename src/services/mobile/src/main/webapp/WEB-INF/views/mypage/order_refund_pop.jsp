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
    <t:putAttribute name="title">환불신청</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">    
    </t:putAttribute>
    
    <t:putAttribute name="content">
<!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">  
        <div class="mypage_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            환불신청
        </div>
        <div class="my_order_no">
            주문번호 : ${so.ordNo}
        </div>
        
       <form:form id="form_id_refund" >
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
            <span>환불 사유</span>
            </h2>
		    <ul class="my_order_detail">
                <li>
                    <p class="textarea" style="width:100%">
                         <select name="claimReasonCd" id="claimReasonCd">
	                    <code:option codeGrp="CLAIM_REASON_CD" />
	                    </select>
                    </p>
                </li>
            </ul>
		    <h2 class="my_stit">
            <span>상세 사유</span>
            </h2>
            <ul class="my_order_detail">
                <li>
                    <p class="textarea" style="width:100%">
                         <textarea style="width:97.5%;height:128px" id="claimDtlReason" name="claimDtlReason"></textarea>
                    </p>
                </li>
            </ul>
		     
		    
		    <!-- 무통장입금일 경우만 환불계좌 입력란 노출 -->
		    <c:forEach var="orderPayVO_Bank" items="${order_info.orderPayVO}" varStatus="status">
		    <c:if test="${orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22'}">
		        <input type="hidden" id="paymentWayCd" name="paymentWayCd" value="${orderPayVO_Bank.paymentWayCd}"/>
		        <h2 class="my_stit">
	            <span>환불방법</span>
	            </h2>
		        
		        <ul class="my_order_detail">
		            <c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'Y'}">
		                 <c:if test="${!empty refund_account.data.holderNm}">
		                 <input type="hidden" id="holderNm" name="holderNm" value="${refund_account.data.holderNm}"/>
		                 <input type="hidden" id="bankNm" name="bankNm" value="${refund_account.data.bankNm}"/>
		                 <input type="hidden" id="actNo" name="actNo" value="${refund_account.data.actNo}"/>
		                <li>
		                    <span class="title">예금주</span>
		                    <p class="detail">
		                    ${refund_account.data.holderNm}        
		                    </p>
		                </li>
		                <li>
		                    <span class="title">은행명</span>
		                    <p class="detail">
		                         ${refund_account.data.bankNm}
		                    </p>
		                </li>
		                <li>
		                    <span class="title">계좌번호</span>
		                    <p class="detail">
		                        ${refund_account.data.actNo}  
		                    </p>
		                </li>
		                </c:if>
		                <c:if test="${empty refund_account.data}">
		                    <li>등록된 환불 계좌가 없습니다.(환불/입금계좌 관리에서 등록해주세요)</li>
		                </c:if>
		            </c:if>
		            <c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'N'}">
		                <li>
		                    <span class="title">예금주</span>
		                    <p class="detail">
		                    <input type="text" id="holderNm" name="holderNm" style="width:calc(100% - 12px);">        
		                    </p>
		                </li>
		                <li>
		                    <span class="title">은행명</span>
		                    <p class="detail">
		                       <select name="bankCd" id="bankCd">
		                           <code:option codeGrp="BANK_CD"/>
		                       </select>
		                    </p>
		                </li>
		                <li>
		                    <span class="title">계좌번호</span>
		                    <p class="detail">
		                    <input type="text" id="actNo" name="actNo" placeholder="'-'없이 등록하세요" style="width:calc(100% - 12px);">  
		                    </p>
		                </li>
		                <li>
		                    <span class="title">주거래계좌</span>
		                    <div class="checkbox" style="margin-top:10px;color:#000">           
		                        <label>
		                            <input type="checkbox" name="select_order">
		                            <span></span>
		                        </label>
		                        주거래 계좌로 설정
		                    </div>
		                </li>
		            
		            </c:if>
		            </ul>
		    </c:if>
		    </c:forEach>
		    <h2 class="my_stit">
            <span>배송비 안내</span>
            </h2>
            
            <ul class="my_order_detail">
                <li>
                    <span class="title">
                            반품
                            <img src="${_MOBILE_PATH}/front/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                            환불
                    </span>
                    <p class="detail f100B">
                         반품 시 배송비는 반품의 원인을 제공한 자가 부담합니다.<br>
                            구매자의 변심으로 반품을 원할 경우에는 구매자가 배송비를 지불
                    </p>
                </li>
                <li>
                    <span class="title">
                            반품
                            <img src="${_MOBILE_PATH}/front/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                            교환
                    </span>
                    <p class="detail f100B">
                         상품 교환 시 배송비는 교환의 원인을 제공한 자가 부담합니다.<br>
                            구매자의 변심으로 교환을 원할 경우에는 구매자가 배송비를 지불
                    </p>
                </li>
            </ul>
            
		     
            <div class="all_btn_cancel_area">
                <button type="button" class="btn_cancel_go" onclick="claim_refund();">환불신청</button>
            </div>
        </div>  
      </form:form>
    </div>  
    <!---// 03.LAYOUT:CONTENTS --->
    </t:putAttribute>
</t:insertDefinition>