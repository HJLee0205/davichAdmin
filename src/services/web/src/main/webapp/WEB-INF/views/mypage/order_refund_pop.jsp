<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<!--- popup 환불신청 --->
<div class="popup_header">
    <h1 class="popup_tit">
        환불신청
        <span class="popup_order_no">[주문번호: ${so.ordNo}]</span>
    </h1>
    <button type="button" class="btn_close_popup" onclick="close_refund_pop();"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>

<div class="popup_content_scroll">
    <h3 class="mypage_con_stit" style="margin-top:0px">
        환불은 주문상품 전체에 대해서만 가능합니다.
    </h3>
    <form:form id="form_id_refund">
    <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
    <input type="hidden" name="memberOrdYn" id="memberOrdYn" value="${orderVO.orderInfoVO.memberOrdYn}"/>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">환불신청 상품 목록 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:68px">
            <col style="width:">
            <col style="width:85px">
            <col style="width:70px">
        </colgroup>
        <thead>
            <tr>
                <th colspan="2">상품정보</th>
                <th>주문수량</th>
                <th>반품수량</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
            <c:when test="${orderVO.orderGoodsVO ne null}">
            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:if test="${goodsList.addOptYn eq 'N'}">
            <tr>
                <td class="pix_img">
                    <c:if test="${empty goodsList.imgPath}">
                    <img src="/front/img/product/cart_img01.gif">
                    </c:if>
                    <c:if test="${!empty goodsList.imgPath}">
                    <img src="${goodsList.imgPath}">
                    </c:if>
                </td>
                <td class="textL" style="padding:30px 12px">
                    <ul class="mypage_s_list">
                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                        <li class="icon"><img src="/front/img/mypage/icon_shipping_ok.png" alt="출고완료"></li>
                        </c:if>
                        <li>${goodsList.goodsNm}</li>
                        <li>[옵션:${goodsList.itemNm}]</li>
                        <li>
                            <c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
                                <c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
                                    <li>
                                        [추가옵션 :
                                        (${amtFlag}<fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                        - ${addOptList.ordQtt}개]
                                    </li>
                                </c:if>
                            </c:forEach>
                        </li>
                    </ul>
                </td>
                <td>
                    ${goodsList.ordQtt}
                </td>
                <td>
                    ${goodsList.ordQtt}
                </td>
            </tr>
            </c:if>
            </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4">등록된 상품이 없습니다.</td>
                </tr>
            </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <h3 class="mypage_con_stit">환불 사유</h3>
    <table class="tMypage_Board" style="border:none">
        <caption>
            <h1 class="blind">환불 사유 등록 폼 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:">
        </colgroup>
        <tbody>
            <select name="claimReasonCd" id="claimReasonCd">
            <code:option codeGrp="CLAIM_REASON_CD" />
            </select>
        </tbody>
    </table>
    <h3 class="mypage_con_stit">상세 사유</h3>
    <table class="tMypage_Board" style="border:none">
        <caption>
            <h1 class="blind">상세 사유 등록 폼 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <td class="textL" style="border:none;padding:0">
                    <textarea style="width:97.5%;height:128px" id="claimDtlReason" name="claimDtlReason"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
    <!-- 무통장입금일 경우만 환불계좌 입력란 노출 -->
    <c:forEach var="orderPayVO_Bank" items="${orderVO.orderPayVO}" varStatus="status">
    <c:if test="${orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22'}">
        <input type="hidden" id="paymentWayCd" name="paymentWayCd" value="${orderPayVO_Bank.paymentWayCd}"/>
        <h3 class="mypage_con_stit">환불방법</h3>
        <table class="tMypage_Board">
            <caption>
                <h1 class="blind">환불방법 등록 폼 입니다.</h1>
            </caption>
            <colgroup>
                <col style="width:30%">
                <col style="width:30%">
                <col style="width:40%">
            </colgroup>
            <tbody>
                <tr>
                    <th>은행</th>
                    <th>예금주</th>
                    <th>계좌번호</th>
                </tr>
                <c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'Y'}">
                    <c:if test="${!empty refund_account.data.holderNm}">
                        <input type="hidden" id="holderNm" name="holderNm" value="${refund_account.data.holderNm}"/>
                        <input type="hidden" id="bankNm" name="bankNm" value="${refund_account.data.bankNm}"/>
                        <input type="hidden" id="actNo" name="actNo" value="${refund_account.data.actNo}"/>
                        <tr>
                            <td>${refund_account.data.bankNm}</td>
                            <td>${refund_account.data.holderNm}</td>
                            <td>${refund_account.data.actNo}</td>
                        </tr>
                    </c:if>
                    <c:if test="${empty refund_account.data}">
                        <tr>
                            <td colspan="3">등록된 환불 계좌가 없습니다.(환불/입금계좌 관리에서 등록해주세요)</td>
                        </tr>
                    </c:if>
                </c:if>
                <c:if test="${orderVO.orderInfoVO.memberOrdYn eq 'N'}">
                <tr>
                    <td>
                        <div class="select_box28">
                            <select name="bankCd" id="bankCd">
                                <code:option codeGrp="BANK_CD"/>
                            </select>
                        </div>
                    </td>
                    <td>
                        <input type="text" id="holderNm" name="holderNm" style="width:144px">
                    </td>
                    <td>
                        <input type="text" id="actNo" name="actNo"  style="width:200px">
                    </td>
                </tr>
                </c:if>
            </tbody>
        </table>
    </c:if>
    </c:forEach>
    <h3 class="mypage_con_stit">배송비 안내</h3>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">배송비 안내 내용 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:147px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th>구분</th>
                <th>안내</th>
            </tr>
            <tr>
                <td>
                    반품
                    <img src="/front/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                    환불
                </td>
                <td class="textL">
                    반품 시 배송비는 반품의 원인을 제공한 자가 부담합니다.<br>
                    구매자의 변심으로 반품을 원할 경우에는 구매자가 배송비를 지불
                </td>
            </tr>
            <tr>
                <td>
                    반품
                    <img src="/front/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                    교환
                </td>
                <td class="textL">
                    상품 교환 시 배송비는 교환의 원인을 제공한 자가 부담합니다.<br>
                    구매자의 변심으로 교환을 원할 경우에는 구매자가 배송비를 지불
                </td>
            </tr>
        </tbody>
    </table>
    </form:form>
</div>
<div class="popup_btn_area">
    <button type="button" class="btn_mypage_ok" onclick="claim_refund();">환불신청</button>
</div>
<!---// popup 환불신청 --->