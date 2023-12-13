<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    function fn_claimContentChkView(data, obj, fieldName) {
        if(data[fieldName] == null || data[fieldName] == "") {
            $(obj).hide();
        } else {
            $(obj).off("click").on("click", function() {
                var url = "/admin/order/refund/refund-check-popup?claimNo=" + data.claimNo + "&ordNo=" + data.ordNo + "&ordDtlSeq=" + data.ordDtlSeq;
                window.open(url, "refundCheck", "width=1024,height=815");
            });
        }
    }
</script>
<div id="layout_exchange" class="layer_popup">
    <!-- 이전 -->
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">반품/교환 관리 [<label id="label_exchangeOrdNo"></label>]</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <form:form id="form_exchange_list">
            <input type="hidden" name="siteNo" value="${siteNo}"/>
            <input type="hidden" name="ordNoArr" id="ordNoArr"/>
            <input type="hidden" name="ordDtlGoodsNoArr" id="ordDtlGoodsNoArr"/>
            <input type="hidden" name="ordDtlItemNoArr" id="ordDtlItemNoArr"/>
            <input type="hidden" name="claimReasonCdArr" id="claimReasonCdArr"/>
            <input type="hidden" name="claimReturnCdArr" id="claimReturnCdArr"/>
            <input type="hidden" name="claimExchangeCdArr" id="claimExchangeCdArr"/>
            <input type="hidden" name="curOrdStatusCd" id="curOrdStatusCd"/>

            <%--//claimDtlReason
            //claimMemo--%>

            <input type="hidden" name="ordDtlSeqArr" id="ordDtlSeqArr"/>
            <input type="hidden" name="claimQttArr" id="claimQttArr"/>
            <input type="hidden" name="claimNoArr" id="claimNoArr"/>
            <%--<input type="hidden" name="claimReasonCd" id="claimReasonCd"/>--%>
            <input type="hidden" name="returnCd" id="returnCd"/>
            <input type="hidden" name="claimCd" id="claimCd"/>
            <input type="hidden" name="ordNo" id="ordNo"/>

            <!-- pop_con -->
            <div class="pop_con">
                <div>
                    <h3 class="tlth3">주문상품</h3>
                    <!-- tblh -->
                    <div class="tblh mt0 tblmany line_no">
                        <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                            <caption>주문내역서 리스트</caption>
                            <colgroup>
                                <col width="2%">
                                <col width="">
                                <col width="8%">
                                <col width="8%">
                                <col width="10%">
                                <col width="8%">
                                <col width="8%">
                                <col width="9%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>&nbsp;</th>
                                <th>주문상품</th>
                                <th>수량</th>
                                <c:if test="${exchangeType eq 'M'}">
                                    <th>교환가능수량</th>
                                </c:if>
                                <c:if test="${exchangeType eq 'V'}">
                                    <th>교환수량</th>
                                </c:if>
                                <th>판매가</th>
                                <th>할인금액</th>
                                <th>배송</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                            </tr>
                            </thead>
                            <tbody id = "ajaxExchangeGoodsList">
                            </tbody>
                        </table>
                        <a href="javascript:;" class="btn_gray2 change_btn mt20" id="btn_exchange_go" refundType="${refundType}">선택</a>
                    </div>
                    <!-- //tblh -->
                    <h3 class="tlth3">반품/교환정보</h3>
                    <!-- tblh -->
                    <div class="tblh mt0 line_no">
                        <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                            <caption>주문내역서 리스트</caption>
                            <colgroup>
                                <col width="*">
                                <col width="5%">
                                <col width="5%">
                                <col width="8%">
                                <col width="8%">
                                <col width="8%">
                                <col width="8%">
                                <col width="8%">
                                <col width="5%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>상품</th>
                                <th>수량</th>
                                <th>옵션</th>
                                <th>접수일시</th>
                                <th>완료일시</th>
                                <th>교환사유</th>
                                <th>반품상태</th>
                                <th>교환상태</th>
                                <th>반품정보</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_exchange_data_edit1">
                            <tr id="tr_exchange_data_template_edit1">
                                <input type="hidden" name="exchangeOrdStatusCd" id="exchangeOrdStatusCd" />
                                <input type="hidden" name="exchangeOrdNo" id="exchangeOrdNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordNo" value="">
                                <input type="hidden" name="exchangeOrdDtlSeq" id="exchangeOrdDtlSeq" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value="">
                                <input type="hidden" name="exchangeOrdDtlGoodsNo" id="exchangeOrdDtlGoodsNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="goodsNo" value="">
                                <input type="hidden" name="exchangeOrdDtlItemNo" id="exchangeOrdDtlItemNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="itemNo" value="">
                                <input type="hidden" name="exchangeClaimMemo" id="exchangeClaimMemo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimMemo" value="">
                                <input type="hidden" name="exchangeClaimQtt" id="exchangeClaimQtt" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimQtt" value=""/>
                                <input type="hidden" name="exchangeClaimNo" id="exchangeClaimNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimNo" value=""/>

                                <td class="txtl">
                                    <div class="item_box">
                                        <a href="javascript:;" class="goods_img"><img src="" alt="" data-bind="exchangeInfo" data-bind-type="img" data-bind-value="imgPath"/></a>
                                        <a href="javascript:;" class="goods_txt">
                                            <span class="tlt">
                                                    <span data-bind="exchangeInfo" data-bind-type="String" data-bind-value="goodsNm"></span>
                                                <input type="hidden" width="100%" readOnly name="goodsNm" id="goodsNm" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="goodsNm">
                                            </span>
                                            <span class="option">
                                                <%--<span class="ico01">옵션</span>--%>
                                                <span id="itemNm" data-bind="exchangeInfo" data-bind-type="string" data-bind-value="itemNm"></span><br>
                                                <%--<input type="text" width="100%" readOnly name="itemNm" id="itemNm" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="itemNm">--%>
                                                <%--<input type="text" width="100%" readOnly name="itemNo" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="itemNo">--%>
                                                 <span class="code">
                                                [상품코드 : <span id="goodsNo" data-bind="exchangeInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]
                                                <%--<input type="text" width="100%" readOnly name="goodsNo" id="goodsNo" data-bind="exchangeInfo" data-bind-value="goodsNo" data-bind-type="Text" >--%>
                                                </span>
                                            </span>
                                        </a>
                                    </div>
                                </td>
                                <td data-bind="exchangeInfo" data-bind-value="claimQtt" data-bind-type="number"></td>
                                <td>
                                    <span class="select">
                                        <label for="exchangeOrdDtlItemNo"></label>
                                        <select name="exchangeOrdDtlItemNo" id="select_exchangeOrdDtlItemNo" data-bind="exchangeInfo" data-bind-type="labelselect" data-bind-value="itemNo">
                                            <option value="">옵션선택</option>
                                        </select>
                                    </span>
                                </td>
                                <td data-bind="exchangeInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>
                                <td>
                                    <span class="select" id="span_claimReasonCd_template">
                                        <label for="claimReasonCd" id="claimReasonCd2"></label>
                                        <select name="claimReasonCd" id="claimReasonCd" data-bind="exchangeInfo" data-bind-value="claimReasonCd" data-bind-type="labelselect">
                                            <option value="">선택</option>
                                            <code:option codeGrp="CLAIM_REASON_CD" value=""/>
                                        </select>
                                    </span>
                                </td>
                                <td data-bind="exchangeInfo" data-bind-value="returnNm"  data-bind-type="String"></td>
                                <td data-bind="exchangeInfo" data-bind-value="claimNm"  data-bind-type="String"></td>
                                <td>
                                    <a class="btn_gray2 change_btn mt20" data-bind="exchangeInfo" data-bind-value="claimContentChk" data-bind-type="function" data-bind-function="fn_claimContentChkView" >보기</a>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- tblw -->
                    <div class="tblw tblmany mt0" style="border-top:0;">
                        <table summary="이표는 반품/교환정보 리스트 표 입니다. 구성은 반품사유, 처리상태 입니다.">
                            <caption>반품/교환정보 리스트</caption>
                            <colgroup>
                                    <%--<col width="15%">
                                    <col width="30%">--%>
                                <col width="15%">
                                <col>
                            </colgroup>
                            <tbody>
                                <%--<tbody id="tbody_exchange_data_edit2">--%>
                            <tr>
                                    <%--<tr id="tr_exchange_data_template_edit2">--%>
                                    <%--<th>반품사유</th>
                                    <td>
                                        <span class="select" id="span_claimReasonCd_template">
                                            <label for="claimReasonCd" id="claimReasonCd2"></label>
                                            <select name="claimReasonCd" id="claimReasonCd" data-bind="exchangeInfo" data-bind-value="claimReasonCd" data-bind-type="labelselect">
                                                <option value=""> 선택</option>
                                                <code:option codeGrp="CLAIM_REASON_CD" />
                                            </select>
                                        </span>
                                    </td>--%>
                                <th class="line">처리상태</th>
                                <td>
                                    <span class="select">
                                        <label for="claimReturnCd" id="claimReturnCd2"></label>
                                        <select name="claimReturnCd" id="claimReturnCd" data-bind="exchangeInfo" data-bind-value="returnCd" data-bind-type="labelselect">
                                            <%--<c:if test="${exchangeType eq 'M'}">--%>
                                            <option value="11">반품신청</option>
                                            <%--</c:if>--%>
                                            <c:if test="${exchangeType eq 'V'}">
                                                <option value="12">반품완료</option>
                                                <option value="13">요청철회</option>
                                            </c:if>
                                        </select>
                                    </span>
                                    <span class="select">
                                        <label for="claimExchangeCd" id="claimExchangeCd2"></label>
                                        <select name="claimExchangeCd" id="claimExchangeCd" data-bind="exchangeInfo" data-bind-value="claimCd" data-bind-type="labelselect">
                                            <%--<c:if test="${exchangeType eq 'M'}">--%>
                                                <option value="21" selected>교환신청</option>
                                            <%--</c:if>--%>
                                            <c:if test="${exchangeType eq 'V'}">
                                                <option value="22">교환완료</option>
                                            </c:if>
                                        </select>
                                    </span>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 반품/교환정보 리스트 표 입니다. 구성은 상세사유, 관리메모 입니다.">
                            <caption>반품/교환정보 리스트</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="35%">
                                <col width="15%">
                                <col width="35%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상세사유</th>
                                <td colspan="3">
                                    <div class="txt_area" style="height: auto;">
                                        <textarea name="claimDtlReason" id="claimDtlReason" class="blind"></textarea>
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
                                        <ul id='ajaxExchangeLogList'>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <div class="btn_box txtc">
                        <button type="button" class="btn green" id="btn_exchange_reg">완료</button>
                        <button type="button" class="btn green" id="btn_exchange_close">닫기</button>
                    </div>
                </div>
            </div>

<%--            <div class="pop_con">--%>
<%--                <!-- tblh -->--%>
<%--                <div class="tblh mt0" style="border-top: 0;">--%>
<%--                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">--%>
<%--                        <caption>주문내역서 리스트</caption>--%>
<%--                        <colgroup>--%>
<%--                            <col width="2%">--%>
<%--                            <col width="">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="10%">--%>
<%--                            <col width="10%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="9%">--%>
<%--                            <col width="8%">--%>
<%--                        </colgroup>--%>
<%--                        <thead>--%>
<%--                        <tr>--%>
<%--                            <th>&nbsp;</th>--%>
<%--                            <th>주문상품</th>--%>
<%--                            <th>수량</th>--%>
<%--                            <c:if test="${exchangeType eq 'M'}">--%>
<%--                                <th>교환가능수량</th>--%>
<%--                            </c:if>--%>
<%--                            <c:if test="${exchangeType eq 'V'}">--%>
<%--                                <th>교환수량</th>--%>
<%--                            </c:if>--%>
<%--                            <th>판매가</th>--%>
<%--                            <th>할인금액</th>--%>
<%--                            <th>배송</th>--%>
<%--                            <th>결제금액</th>--%>
<%--                            <th>주문상태</th>--%>
<%--                        </tr>--%>
<%--                        </thead>--%>
<%--                        <tbody id="ajaxExchangeGoodsList">--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                    <a href="#" class="btn_gray2 change_btn mt20" id="btn_exchange_go">선택</a>--%>
<%--                </div>--%>
<%--                <!-- //tblh -->--%>
<%--                <h3 class="tlth3">반품/교환정보</h3>--%>
<%--                <!-- tblh -->--%>
<%--                <div class="tblh mt0 line_no">--%>
<%--                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">--%>
<%--                        <caption>주문내역서 리스트</caption>--%>
<%--                        <colgroup>--%>
<%--                            <col width="*">--%>
<%--                            <col width="5%">--%>
<%--                            <col width="5%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="8%">--%>
<%--                            <col width="8%">--%>
<%--                        </colgroup>--%>
<%--                        <thead>--%>
<%--                        <tr>--%>
<%--                            <th>상품</th>--%>
<%--                            <th>수량</th>--%>
<%--                            <th>옵션</th>--%>
<%--                            <th>접수일시</th>--%>
<%--                            <th>완료일시</th>--%>
<%--                            <th>교환사유</th>--%>
<%--                            <th>반품상태</th>--%>
<%--                            <th>교환상태</th>--%>
<%--                        </tr>--%>
<%--                        </thead>--%>
<%--                        <tbody id="tbody_exchange_data_edit1">--%>
<%--                        <tr id="tr_exchange_data_template_edit1">--%>
<%--                            <input type="hidden" name="exchangeOrdStatusCd" id="exchangeOrdStatusCd"/>--%>
<%--                            <input type="hidden" name="exchangeOrdNo" id="exchangeOrdNo" data-bind="exchangeInfo"--%>
<%--                                   data-bind-type="Text" data-bind-value="ordNo" value="">--%>
<%--                            <input type="hidden" name="exchangeOrdDtlSeq" id="exchangeOrdDtlSeq"--%>
<%--                                   data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value="">--%>
<%--                            <input type="hidden" name="exchangeOrdDtlGoodsNo" id="exchangeOrdDtlGoodsNo"--%>
<%--                                   data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="goodsNo" value="">--%>
<%--                            <input type="hidden" name="exchangeOrdDtlItemNo" id="exchangeOrdDtlItemNo"--%>
<%--                                   data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="itemNo" value="">--%>
<%--                            <input type="hidden" name="exchangeClaimMemo" id="exchangeClaimMemo"--%>
<%--                                   data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="claimMemo" value="">--%>
<%--                            <input type="hidden" name="exchangeClaimQtt" id="exchangeClaimQtt" data-bind="exchangeInfo"--%>
<%--                                   data-bind-type="Text" data-bind-value="claimQtt" value=""/>--%>
<%--                            <input type="hidden" name="exchangeClaimNo" id="exchangeClaimNo" data-bind="exchangeInfo"--%>
<%--                                   data-bind-type="Text" data-bind-value="claimNo" value=""/>--%>

<%--                            <td class="txtl">--%>
<%--                                <div class="item_box">--%>
<%--                                    <a href="#none" class="goods_img"><img src="" alt="" data-bind="exchangeInfo"--%>
<%--                                                                           data-bind-type="img"--%>
<%--                                                                           data-bind-value="imgPath"/></a>--%>
<%--                                    <a href="#none" class="goods_txt">--%>
<%--                                                <span class="tlt">--%>
<%--                                                        <span data-bind="exchangeInfo" data-bind-type="String"--%>
<%--                                                              data-bind-value="goodsNm"></span>--%>
<%--                                                    <input type="hidden" width="100%" readOnly name="goodsNm"--%>
<%--                                                           id="goodsNm" data-bind="exchangeInfo" data-bind-type="Text"--%>
<%--                                                           data-bind-value="goodsNm">--%>
<%--                                                </span>--%>
<%--                                        <span class="option">--%>
<%--                                                    &lt;%&ndash;<span class="ico01">옵션</span>&ndash;%&gt;--%>
<%--                                                    <span id="itemNm" data-bind="exchangeInfo" data-bind-type="string"--%>
<%--                                                          data-bind-value="itemNm"></span>--%>
<%--                                                    &lt;%&ndash;<input type="text" width="100%" readOnly name="itemNm" id="itemNm" data-bind="exchangeInfo" data-bind-type="Text" data-bind-value="itemNm">&ndash;%&gt;--%>
<%--                                                </span>--%>
<%--                                        <span class="code">--%>
<%--                                                [상품코드 : <span id="goodsNo" data-bind="exchangeInfo"--%>
<%--                                                              data-bind-value="goodsNo" data-bind-type="string"></span>]--%>
<%--                                                &lt;%&ndash;<input type="text" width="100%" readOnly name="goodsNo" id="goodsNo" data-bind="exchangeInfo" data-bind-value="goodsNo" data-bind-type="Text" >&ndash;%&gt;--%>
<%--                                                </span>--%>
<%--                                    </a>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                            <td data-bind="exchangeInfo" data-bind-value="claimQtt" data-bind-type="number"></td>--%>
<%--                            <td>--%>
<%--                                        <span class="select">--%>
<%--                                            <label for="exchangeOrdDtlItemNo"></label>--%>
<%--                                            <select name="exchangeOrdDtlItemNo" id="select_exchangeOrdDtlItemNo"--%>
<%--                                                    data-bind="exchangeInfo" data-bind-type="labelselect"--%>
<%--                                                    data-bind-value="itemNo">--%>
<%--                                                <option value="">옵션선택</option>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                            </td>--%>
<%--                            <td data-bind="exchangeInfo" data-bind-value="claimAcceptDttm" data-bind-type="String"></td>--%>
<%--                            <td data-bind="exchangeInfo" data-bind-value="claimCmpltDttm" data-bind-type="String"></td>--%>
<%--                            <td>--%>
<%--                                        <span class="select" id="span_claimReasonCd_template">--%>
<%--                                            <label for="claimReasonCd" id="claimReasonCd2"></label>--%>
<%--                                            <select name="claimReasonCd" id="claimReasonCd" data-bind="exchangeInfo"--%>
<%--                                                    data-bind-value="claimReasonCd" data-bind-type="labelselect">--%>
<%--                                                <option value="">선택</option>--%>
<%--                                                <code:option codeGrp="CLAIM_REASON_CD" value=""/>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                            </td>--%>
<%--                            <td data-bind="exchangeInfo" data-bind-value="returnNm" data-bind-type="String"></td>--%>
<%--                            <td data-bind="exchangeInfo" data-bind-value="claimNm" data-bind-type="String"></td>--%>
<%--                        </tr>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--                <!-- //tblh -->--%>
<%--                <!-- tblw -->--%>
<%--                <div class="tblw tblmany mt0" style="border-top:0;">--%>
<%--                    <table summary="이표는 반품/교환정보 리스트 표 입니다. 구성은 반품사유, 처리상태 입니다.">--%>
<%--                        <caption>반품/교환정보 리스트</caption>--%>
<%--                        <colgroup>--%>
<%--                                &lt;%&ndash;<col width="15%">--%>
<%--                                <col width="30%">&ndash;%&gt;--%>
<%--                            <col width="15%">--%>
<%--                                &lt;%&ndash;<col width="40%">&ndash;%&gt;--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                            &lt;%&ndash;<tbody id="tbody_exchange_data_edit2">&ndash;%&gt;--%>
<%--                        <tr>--%>
<%--                                &lt;%&ndash;<tr id="tr_exchange_data_template_edit2">&ndash;%&gt;--%>
<%--                                &lt;%&ndash;<th>반품사유</th>--%>
<%--                                <td>--%>
<%--                                    <span class="select" id="span_claimReasonCd_template">--%>
<%--                                        <label for="claimReasonCd" id="claimReasonCd2"></label>--%>
<%--                                        <select name="claimReasonCd" id="claimReasonCd" data-bind="exchangeInfo" data-bind-value="claimReasonCd" data-bind-type="labelselect">--%>
<%--                                            <option value=""> 선택</option>--%>
<%--                                            <code:option codeGrp="CLAIM_REASON_CD" />--%>
<%--                                        </select>--%>
<%--                                    </span>--%>
<%--                                </td>&ndash;%&gt;--%>
<%--                            <th class="line">처리상태</th>--%>
<%--                            <td>--%>
<%--                                        <span class="select">--%>
<%--                                            <label for="claimReturnCd" id="claimReturnCd2"></label>--%>
<%--                                            <select name="claimReturnCd" id="claimReturnCd" data-bind="exchangeInfo"--%>
<%--                                                    data-bind-value="returnCd" data-bind-type="labelselect">--%>
<%--                                                &lt;%&ndash;<c:if test="${exchangeType eq 'M'}">&ndash;%&gt;--%>
<%--                                                <option value="11" disabled>반품신청</option>--%>
<%--                                                &lt;%&ndash;</c:if>&ndash;%&gt;--%>
<%--                                                <c:if test="${exchangeType eq 'V'}">--%>
<%--                                                    <option value="12">반품완료</option>--%>
<%--                                                    <option value="13">요청철회</option>--%>
<%--                                                </c:if>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                                <span class="select">--%>
<%--                                            <label for="claimExchangeCd" id="claimExchangeCd2"></label>--%>
<%--                                            <select name="claimExchangeCd" id="claimExchangeCd" data-bind="exchangeInfo"--%>
<%--                                                    data-bind-value="claimCd" data-bind-type="labelselect">--%>
<%--                                                &lt;%&ndash;<c:if test="${exchangeType eq 'M'}">&ndash;%&gt;--%>
<%--                                                    <option value="21">교환신청</option>--%>
<%--                                                &lt;%&ndash;</c:if>&ndash;%&gt;--%>
<%--                                                <c:if test="${exchangeType eq 'V'}">--%>
<%--                                                    <option value="22">교환완료</option>--%>
<%--                                                </c:if>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>

<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--                <!-- //tblw -->--%>
<%--                <div class="tblw mt0">--%>
<%--                    <table summary="이표는 반품/교환정보 리스트 표 입니다. 구성은 상세사유, 관리메모 입니다.">--%>
<%--                        <caption>반품/교환정보 리스트</caption>--%>
<%--                        <colgroup>--%>
<%--                            <col width="15%">--%>
<%--                            <col width="35%">--%>
<%--                            <col width="15%">--%>
<%--                            <col width="35%">--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                        <tr>--%>
<%--                            <th>상세사유</th>--%>
<%--                            <td colspan="3">--%>
<%--                                <div class="txt_area" style="height: auto;">--%>
<%--                                    <textarea name="claimDtlReason" id="claimDtlReason" class="blind"></textarea>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>관리메모</th>--%>
<%--                            <td>--%>
<%--                                <div class="txt_area">--%>
<%--                                    <textarea name="claimMemo" id="claimMemo"></textarea>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                            <th class="line">처리로그</th>--%>
<%--                            <td>--%>
<%--                                <div class="disposal_log">--%>
<%--                                    <ul id='ajaxExchangeLogList'>--%>
<%--                                    </ul>--%>
<%--                                </div>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--                <!-- //tblw -->--%>
<%--                <div class="btn_box txtc">--%>
<%--                    <button type="button" class="btn green" id="btn_exchange_reg">완료</button>--%>
<%--                    <button type="button" class="btn green" id="btn_exchange_close">닫기</button>--%>
<%--                </div>--%>
<%--            </div>--%>
        </form:form>
    </div>
</div>
