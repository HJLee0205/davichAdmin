<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="layout_payCancel" class="layer_popup">
    <!-- 이전 -->
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">결제취소 신청[<label id="label_exchangeOrdNo"></label>]</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <h3 class="tlth3">주문상품</h3>
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="2%">
                            <col width="">
                            <col width="8%">
                            <col width="8%">
                            <col width="10%">
                            <col width="10%">
                            <col width="8%">
                            <col width="9%">
                            <col width="8%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>
                                <label for="" class="chack mr10" >
                                    <span class="ico_comm"><input type="checkbox" name="" id="" class="blind" /></span>
                                </label>
                            </th>
                            <th>주문상품</th>
                            <th>수량</th>
                            <c:if test="${refundType eq 'M'}">
                                <th>취소가능수량</th>
                            </c:if>
                            <c:if test="${refundType eq 'V'}">
                                <th>취소수량</th>
                            </c:if>
                            <th>판매가</th>
                            <th>할인금액</th>
                            <th>배송</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                        </tr>
                        </thead>
                        <tbody id = "ajaxPayCancelGoodsList">
                        </tbody>
                    </table>
                    <div class="bottom_lay">
                        <div class="pop_btn txtc">
                            <a class="btn_gray2 change_btn mt20" id="btn_payCancel_go">선택</a>
                        </div>
                    </div>
                </div>
                <!-- tbl_cancel -->
                <div class="tbl_cancel tblmany" style="position:relative;">
                    <table summary="이표는 주문상품 환불 표 입니다. 구성은  입니다.">
                        <caption>주문상품 환불</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="15%">
                            <col width="15%">
                            <col width="6%">
                            <col width="49%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>환불예상금액</th>
                            <th>환불조정금액</th>
                            <th>최종환불금액</th>
                            <th rowspan="2" class="line_no">=</th>
                            <th style="text-align:left; padding-left:45px;">
                                <span class="select">
                                    <label for="pgType1" id="pgtype1"></label>
                                    <select name="pgType" id="pgType">
                                        <tags:option codeStr="01:무통장 환불;02:PG 환불"/>
                                    </select>
                                </span>
                                <span class="intxt shot"><input type="text" name="pgAmt" id="pgAmt"/></span>
                                <span class="point_c5"><b>최초 결제금액 <label id="tempPgAmt">0</label>원</b></span>
                            </th>
                        </tr>
                        <tr>
                            <td class="point_c5" id="estimateAmt">0</td>
                            <td><span class="intxt shot"><input type="text" name="modifyAmt" id="modifyAmt" style="border:none" readonly/></span> 원</td>
                            <td><span class="intxt shot"><input type="text" name="refundAmt" id="refundAmt" style="border:none" readonly/></span> 원</td>
                            <td style="text-align:left; padding-left:45px;">
                                마켓포인트 환불 : <span class="intxt shot" style="margin-left:39px;"><input type="text" name="payReserveAmt" id="payReserveAmt" readonly/></span>
                                <span class="point_c5"><b>최초 결제금액 <label id="tempReserveAmt">0</label>원</b></span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tbl_cancel -->


                <!--결제취소상품-->
                <h3 class="tlth3">결제취소상품</h3>
                <!-- tblh -->
                <input type="hidden" name="preCheckGoods" id="preCheckGoods" value="0"/>
                <input type="hidden" name="curCheckGoods" id="curCheckGoods" value="0"/>
                <input type="hidden" name="cancelType" id="cancelType" value="02"/>
                <input type="hidden" name="restAmt" id="restAmt" />
                <input type="hidden" name="orgReserveAmt" id="orgReserveAmt" />
                <input type="hidden" name="partCancelYn" id="partCancelYn" />

                <input type="hidden" name="claimQttArr" id="claimQttArr"/>

                <input type="hidden" name="exchangePayPgCd" id="exchangePayPgCd" />
                <input type="hidden" name="exchangePayPgWayCd" id="exchangePayPgWayCd" />
                <input type="hidden" name="exchangePayPgAmt" id="exchangePayPgAmt" />
                <input type="hidden" name="exchangePayUnpgCd" id="exchangePayUnpgCd" />
                <input type="hidden" name="exchangePayUnpgWayCd" id="exchangePayUnpgWayCd"/>
                <input type="hidden" name="exchangePayUnpgAmt" id="exchangePayUnpgAmt" />
                <input type="hidden" name="exchangePayReserveWayCd" id="exchangePayReserveWayCd" />
                <input type="hidden" name="orgCnt" id="orgCnt" />
                <input type="hidden" name="realDlvrAmt" id="realDlvrAmt" />

                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 주문취소상품 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="32%">
                            <col width="6%">
                            <col width="17%">
                            <col width="15%">
                            <col width="15%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>상품</th>
                            <th>수량</th>
                            <th>취소접수일시</th>
                            <th>취소완료일시</th>
                            <th>처리상태</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_exchange_data">
                        <form:form id="form_exchange_list">
                            <input type="hidden" name="siteNo" value="${siteNo}" />
                            <tr id="tr_exchange_data_template">
                                <input type="hidden" name="exchangeOrdStatusCd" id="exchangeOrdStatusCd" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd" value=""/>
                                <input type="hidden" name="exchangeOrdNo" id="exchangeOrdNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordNo" value=""/>
                                <input type="hidden" name="exchangeOrdDtlSeq" id="exchangeOrdDtlSeq" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value=""/>
                                <input type="hidden" name="exchangeDlvrAmt" id="exchangetotalDlvrAmt" />
                                <input type="hidden" name="exchangeClaimQtt" id="exchangeClaimQtt" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimQtt" value=""/>
                                <input type="hidden" name="exchangeClaimNo" id="exchangeClaimNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimNo" value=""/>
                                <td class="txtl">
                                    <div class="item_box">
                                        <a href="#none" class="goods_img"><img src="" alt="" data-bind="exchangeInfo" data-bind-type="img" data-bind-value="imgPath"/></a>
                                        <a href="#none" class="goods_txt">
                                            <span class="tlt">
                                                <span data-bind="exchangeInfo" data-bind-type="String" data-bind-value="goodsNm"></span>
                                                <input type="hidden" name="goodsNm" id="goodsNm" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="goodsNm">
                                            </span>
                                            <span class="option">
                                                <span id="itemNm" data-bind="exchangeInfo" data-bind-type="string" data-bind-value="itemNm"></span>
                                            </span>
                                            <span class="code">[상품코드 : <span id="goodsNo" data-bind="exchangeInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]</span>
                                        </a>
                                    </div>
                                </td>
                                <td data-bind="exchangeInfo" data-bind-value="claimQtt" data-bind-type="number"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="ordDtlStatusNm"  data-bind-type="String"></td>
                            </tr>
                        </form:form>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!--//주문취소상품-->

                <h3 class="tlth3">결제취소정보</h3>
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 결제취소정보 리스트 표 입니다. 구성은 계좌 정보, 상세사유, 관리메모 입니다.">
                        <caption>결제취소정보 리스트</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                        <tr id="bankInfo" style="display:none">
                            <th>계좌 정보</th>
                            <td colspan="3">
                                은행
                                <span class="select" id="span_bankCd_template">
                                    <label for="bankCd" id="bankCd2"></label>
                                      <select name="bankCd" id="bankCd" >
                                          <code:option codeGrp="BANK_CD" includeTotal="true" />
                                      </select>
                                    </label>
                                </span>
                                계좌번호
                                <span class="intxt long2  mr20"><input type="text" name="actNo" id="actNo" /></span>
                                예금주
                                <span class="intxt"><input type="text" name="holderNm" id="holderNm" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>취소사유</th>
                            <td colspan="3">
                                <span class="select" id="span_claimReasonCd_template">
                                    <label for="claimReasonCd" id="claimReasonCd2"></label>
                                    <select name="claimReasonCd" id="claimReasonCd" >
                                        <option value=""> 선택
                                        <code:option codeGrp="CLAIM_REASON_CD" />
                                    </select>
                                    </label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>상세사유</th>
                            <td colspan="3">
                                <div class="txt_area">
                                    <textarea name="claimDtlReason" id="claimDtlReason"></textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>관리메모</th>
                            <td>
                                <div class="txt_area">
                                    <textarea name="claimMemo" id="claimMemo"></textarea>
                                </div>
                            </td>
                            <th class="line">처리로그</th>
                            <td>
                                <div class="disposal_log">
                                    <ul id='ajaxPayCancelLogList'>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <div class="btn_box txtc">
                    <c:if test="${refundType eq 'M'}">
                        <button class="btn green" id="btn_payCancel_reg" claimCd="23">
                            결제 취소 신청
                        </button>
                    </c:if>
                    <c:if test="${refundType eq 'V'}">
                        <button class="btn green" id="btn_payCancel_reg" claimCd="21">
                            결제 취소
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>

    <!-- 신규 -->
<%--    <div class="pop_wrap size3">--%>
<%--        <div class="pop_tlt">--%>
<%--            <h2 class="tlth2">결제취소신청</h2>--%>
<%--            <button class="close ico_comm">닫기</button>--%>
<%--        </div>--%>
<%--        <form action="">--%>
<%--            <div class="pop_con">--%>
<%--                <div class="tblw">--%>
<%--                    <table>--%>
<%--                        <colgroup>--%>
<%--                            <col width="25%">--%>
<%--                            <col width="75%">--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                        <tr>--%>
<%--                            <th>주문번호</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>환불 예상 금액</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>환불 조정 금액</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="modifyAmt" id="pop_modifyAmt">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>최종 환불 금액</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="refundAmt" id="pop_refundAmt">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>포인트 환불</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>쿠폰 환불</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th rowspan="3">환불 계좌 정보</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <select name="bankCd" id="pop_bankCd">--%>
<%--                                        <code:optionUDV codeGrp="BANK_CD"/>--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="actNo" id="pop_actNo">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="holderNm" id="pop_holderNm">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>결제 취소 / 교환 / 환불</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>취소상품</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>수량</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>취소사유</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <select name="" id="">--%>
<%--                                        <code:option codeGrp="CLAIM_REASON_CD" />--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>상세사유</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="claimDtlReason">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>관리메모</th>--%>
<%--                            <td>--%>
<%--                                <div class="txt_area">--%>
<%--                                    <textarea name="claimMemo" id="" cols="30" rows="10"></textarea>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>처리로그</th>--%>
<%--                            <td>--%>
<%--                                <div class="disposal_log">--%>
<%--                                    <ul></ul>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--                <div class="btn_box txtc">--%>
<%--                    <button type="button" class="btn--blue_small" id="btn_exchange_reg">결제 취소 신청</button>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </form>--%>
<%--    </div>--%>
</div>
<!-- //layer_popup1 -->
