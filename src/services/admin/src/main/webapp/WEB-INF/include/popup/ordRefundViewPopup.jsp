<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="layout_refund" class="layer_popup">
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">반품환불 관리 [<label id="label_refundOrdNo"></label>]</h2>            
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
                            <col width="26%">
                            <col width="8%">
                            <col width="12%">
                            <col width="16%">
                            <col width="14%">
                            <col width="10%">
                            <col width="12%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>
                                    &nbsp;
                                </th>
                                <th>주문상품</th>
                                <th>수량</th>
                                <th>판매가</th>
                                <th>할인금액</th>
                                <th>배송</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                            </tr>
                        </thead>
                        <tbody id = "ajaxRefundGoodsList">
                        </tbody>
                    </table>
                    <!--  <a href="#" class="btn_gray2 change_btn mt20" id="btn_refund_go">환불금액확인</a> -->
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
                
                
                <!--주문취소상품-->
                <h3 class="tlth3">주문취소상품</h3>
                <!-- tblh -->
                <input type="hidden" name="preCheckGoods" id="preCheckGoods" value="0"/>
                <input type="hidden" name="curCheckGoods" id="curCheckGoods" value="0"/>
                <input type="hidden" name="cancelType" id="cancelType" value="02"/>
                <input type="hidden" name="restAmt" id="restAmt" />
                <input type="hidden" name="orgReserveAmt" id="orgReserveAmt" />
                <input type="hidden" name="partCancelYn" id="partCancelYn" value="N"/>
                
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 주문취소상품 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="32%">
                            <col width="6%">
                            <col width="17%">
                            <col width="15%">
                            <col width="15%">
                            <col width="15%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>주문상품취소</th>
                                <th>취소수량</th>
                                <th>취소접수일시</th>
                                <th>취소완료일시</th>
                                <th>처리상태</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_refund_data">
                        <form:form id="form_refund_list">
                            <input type="hidden" name="siteNo" value="${siteNo}" />
                            <tr id="tr_refund_data_template">
                                <td class="txtl">
                                <input type="hidden" name="refundOrdStatusCd" id="refundOrdStatusCd" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd"//>
                                <input type="hidden" name="refundOrdNo" id="refundOrdNo" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordNo"/>
                                <input type="hidden" name="refundOrdDtlSeq" id="refundOrdDtlSeq" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlSeq"/>
                                <input type="hidden" name="refundDlvrAmt" id="refundtotalDlvrAmt" />
                                
                                
                                <div class="item_box">
                                    <a href="#none" class="goods_img"><img src="" alt="" data-bind="refundInfo" data-bind-type="img" data-bind-value="imgPath"/></a>
                                    <a href="#none" class="goods_txt">
                                        <span class="tlt"><input type="text" width="100%" readOnly name="goodsNm" id="goodsNm" data-bind="refundInfo" data-bind-type="Text" data-bind-value="goodsNm"></span>
                                        <span class="option">
                                            <span class="ico01">옵션</span>
                                            <span name="itemNm" id="itemNm" data-bind="refundInfo" data-bind-type="string" data-bind-value="itemNm"></span>
                                        </span>
                                        <span class="code">[상품코드 : <span name="goodsNo" id="goodsNo" data-bind="refundInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]</span>
                                    </a>
                                </div>
                                </td>
                                <td data-bind="refundInfo" data-bind-value="claimQtt" data-bind-type="number"></td>
                                <td data-bind="refundInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>
                                <td data-bind="refundInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>                             
                                <td data-bind="refundInfo" data-bind-value="ordDtlStatusNm"  data-bind-type="String"></td>
                                </td>
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
                            <tr>
                                <th>처리 상태</th>
                                <td  colspan=3>
                                    반품 상태
                                    <span class="select" id="span_refundReturnCd_template">
                                        <label for="refundReturnCd" id="refundReturnCd2" ></label>
                                        <select name="refundReturnCd" id="refundReturnCd" >
                                            <option value="11">반품신청
                                            <option value="12">반품완료
                                            <option value="-">요청철회
                                        </select>
                                    </span>&nbsp;&nbsp;
                                    환불 상태
                                    <span class="select" id="span_refundClaimCd_template">
                                        <label for="refundClaimCd" id="refundClaimCd2"></label>
                                        <select name="refundClaimCd" id="refundClaimCd" >
                                            <option value="11">환불신청
                                            <option value="12">환불완료
                                        </select>
                                    </span>
                                </td>   
                            </tr>
                            
                            <tr id="bankInfo" >
                                <th>계좌 정보</th>
                                <td colspan="3">
                                은행
                                <span class="select " id="span_bankCd_template">
                                    <label for="bankCd" id="bankCd2"></label>
                                      <select name="bankCd" id="bankCd">
                                          <code:option codeGrp="BANK_CD" />
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
                                <span class="select" id="span_refundReasonCd_template">
                                    <label for="refundReasonCd" id="refundReasonCd2"></label>
                                    <select name="refundReasonCd" id="refundReasonCd">
                                        <code:option codeGrp="CLAIM_REASON_CD" />
                                    </select>
                                    </label>
                                </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상세사유</th>
                                <td colspan="3">
                                    <div class="txt_area" style="height: auto;">
                                        <textarea name="refundDtlReason" id="refundDtlReason" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>관리메모</th>
                                <td>
                                    <div class="txt_area">
                                        <textarea name="refundMemo" id="refundMemo"></textarea>
                                    </div>
                                </td>
                                <th class="line">처리로그</th>
                                <td>
                                    <div class="disposal_log">
                                     <ul id='ajaxRefundLogList'>
                                     </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <div class="btn_box txtc">
                    <button class="btn green" id="btn_refund_reg">완료</button>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->
