<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<!--- popup 주문취소신청 --->
<div class="popup_header">
    <h1 class="popup_tit">
        주문취소신청
        <span class="popup_order_no">[주문번호: ${so.ordNo}]</span>
    </h1>
    <button type="button" class="btn_close_popup" onclick="close_cancel_pop();"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>
<form:form id="form_id_cancel">
<input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
<input type="hidden" name="cancelType" id="cancelType" value="01"/>
<input type="hidden" name="ordStatusCd" id="ordStatusCd" value="${orderVO.orderInfoVO.ordStatusCd}"/>
<input type="hidden" name="memberOrdYn" id="memberOrdYn" value="${orderVO.orderInfoVO.memberOrdYn}"/>
<c:set var="escrowYn" value="N"/>
<c:set var="paycoYn" value="N"/>
<c:forEach var="payList" items="${orderVO.orderPayVO }" varStatus="status">
    <c:if test="${payList.paymentPgCd eq '01' || payList.paymentPgCd eq '02' || payList.paymentPgCd eq '03' || payList.paymentPgCd eq '04'}">
        <c:if test="${payList.escrowYn eq 'Y'}">
            <c:set var="escrowYn" value="Y"/>
        </c:if>
    </c:if>
    <c:if test="${payList.paymentPgCd eq '41'}">
        <c:set var="paycoYn" value="Y"/>
    </c:if>
</c:forEach>
<input type="hidden" name="escrowYn" id="escrowYn" value="${escrowYn}"/>
<input type="hidden" name="paycoYn" id="paycoYn" value="${paycoYn}"/>
<div class="popup_content_scroll">
    <h3 class="mypage_con_stit" style="margin-top:0px">
        취소상품 등록
        <span>취소할 상품을 선택하고 취소 수량을 등록하세요.</span>
        <c:if test="${btn_all_delte eq 'Y'}">
        <button type="button" class="btn_order_all_cancel floatR" style="margin-top:-10px" onclick="order_cancel_all();">주문 전체취소</button>
        </c:if>
    </h3>

    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">취소상품 등록 목록 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:40px">
            <col style="width:68px">
            <col style="width:">
            <col style="width:104px">
            <col style="width:70px">
            <col style="width:98px">
        </colgroup>
        <tbody>
            <tr>
                <th>선택</th>
                <th colspan="2">진행상태/상품정보</th>
                <th>주문금액</th>
                <th>수량</th>
                <th>주문금액<br>/취소금액</th>
            </tr>
            <c:choose>
            <c:when test="${orderVO.orderGoodsVO ne null}">
            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:if test="${goodsList.addOptYn eq 'N'}">
            <tr data-ord-no="${goodsList.ordNo}"  data-ord-dtl-seq="${goodsList.ordDtlSeq}">
                <c:set var="disabled" value=""/>
                <c:if test="${goodsList.ordDtlStatusCd gt '20' }">
                    <c:set var="disabled" value="disabled"/>
                </c:if>
                <td>
                    <div class="mypage_check">
                        <label for="itemNoArr_${status.index}">
                            <input type="checkbox" name="itemNoArr" id="itemNoArr_${status.index}" ${disabled}>
                            <span></span>
                        </label>
                        <input type="hidden" name="itemNoArr" value="${goodsList.itemNo}"/>
                    </div>
                </td>
                <td style="padding:30px 0" class="pix_img">
                    <c:if test="${empty goodsList.imgPath}">
                    <img src="/front/img/product/cart_img01.gif">
                    </c:if>
                    <c:if test="${!empty goodsList.imgPath}">
                    <img src="${goodsList.imgPath}">
                    </c:if>
                </td>
                <td class="textL">
                    <ul class="mypage_s_list">
                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                        <li class="icon"><img src="/front/img/mypage/icon_shipping_ok.png" alt="출고완료"></li>
                        </c:if>
                        <li>${goodsList.goodsNm}</li>
                        <c:if test="${!empty goodsList.itemNm }">
                        <li>[옵션:${goodsList.itemNm}]</li>
                        </c:if>
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
                    <fmt:formatNumber value="${goodsList.payAmt}" type="number"/>원
                </td>
                <td>
                    <ul class="mypage_s_list">
                        <li>${goodsList.ordQtt}</li>
                    </ul>
                </td>
                <td class="textR">
                    <ul class="mypage_s_list">
                        <li><fmt:formatNumber value="${goodsList.payAmt}" type="number"/>원</li>
                        <li>(-) ${goodsList.payAmt}원</li>
                    </ul>
                </td>
            </tr>
            </c:if>
            </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="6">등록된 상품이 없습니다.</td>
                </tr>
            </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 무통장입금일 경우만 환불계좌 입력란 노출 -->
    <c:forEach var="orderPayVO_Bank" items="${orderVO.orderPayVO}" varStatus="status">
    <c:if test="${(orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22') && orderVO.orderInfoVO.ordStatusCd eq '20'}">
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
                    <c:if test="${!empty refundModel.data.holderNm}">
                        <input type="hidden" id="holderNm" name="holderNm" value="${refundModel.data.holderNm}"/>
                        <input type="hidden" id="bankNm" name="bankNm" value="${refundModel.data.bankNm}"/>
                        <input type="hidden" id="bankCd" name="bankCd" value="${refundModel.data.bankCd}"/>
                        <input type="hidden" id="actNo" name="actNo" value="${refundModel.data.actNo}"/>
                        <input type="hidden" id="paymentNo" name="paymentNo" value="${orderPayVO_Bank.paymentNo }"/>
                        <tr>
                            <td>${refundModel.data.bankNm}</td>
                            <td>${refundModel.data.holderNm}</td>
                            <td>${refundModel.data.actNo}</td>
                        </tr>
                    </c:if>
                    <c:if test="${empty refundModel.data}">
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
    <h3 class="mypage_con_stit">취소사유</h3>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">취소사유 등록 폼 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:130px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th class="textL">취소사유</th>
                <td class="form">
                    <div class="select_box28" style="width:243px;display:inline-block">
                        <label for="select_option">- 선택 -</label>
                        <select class="select_option" name="claimReasonCd" id="claimReasonCd" title="select option">
                            <code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="true"  mode="S"/>
                        </select>
                    </div>
                </td>
            </tr>
            <tr>
                <th class="textL" style="vertical-align:top">상세사유</th>
                <td class="form">
                    <textarea style="width:100%;height:67px" name="claimDtlReason" id="claimDtlReason"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</div>
</form:form>
<div class="popup_btn_area">
    <button type="button" class="btn_mypage_ok" onclick="order_cancel();">취소신청</button>
</div>
<div class="popup_bottom_attention">
    <span class="attention_title">알아두세요!</span>
    <ul class="popup_slist02">
        <li>신용카드로 주문/결제하신 경우 카드사에 따라 부분취소가 불가능할 수 있으니 이 경우에는 잔여상품에 대해 재 결제를 하셔야 합니다.</li>
        <li>주문 취소는 배송상태가 주문접수, 결제완료 상태인 상품에 대해서만 취소를 할 수 있습니다.</li>
    </ul>
</div>
<!---// popup 주문취소신청 --->