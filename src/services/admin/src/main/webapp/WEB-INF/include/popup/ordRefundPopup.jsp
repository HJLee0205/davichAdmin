<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="layout_refund" class="layer_popup">
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
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">반품환불 관리 [<label id="label_refundOrdNo"></label>]</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <form:form id="form_refund_list">
        <input type="hidden" name="siteNo" value="${siteNo}" />
        <input type="hidden" name="preCheckGoods" id="preCheckGoods" value="0"/>
        <input type="hidden" name="curCheckGoods" id="curCheckGoods" value="0"/>
        <input type="hidden" name="cancelType" id="cancelType" value="02"/>
        <input type="hidden" name="restAmt" id="restAmt" />
        <input type="hidden" name="orgReserveAmt" id="orgReserveAmt" />
        <input type="hidden" name="partCancelYn" id="partCancelYn" value="N"/>

        <input type="hidden" name="ordDtlSeqArr" id="ordDtlSeqArr"/>
        <input type="hidden" name="claimQttArr" id="claimQttArr"/>
        <input type="hidden" name="claimNoArr" id="claimNoArr"/>
        <input type="hidden" name="claimMemo" id="claimMemo"/>
        <input type="hidden" name="claimDtlReason" id="claimDtlReason"/>
        <input type="hidden" name="orgPgAmt" id="orgPgAmt"/>
        <input type="hidden" name="claimReasonCd" id="claimReasonCd"/>
        <input type="hidden" name="returnCd" id="returnCd"/>
        <input type="hidden" name="claimCd" id="claimCd"/>
        <input type="hidden" name="ordNo" id="ordNo"/>
        <input type="hidden" name="cancelStatusCd" id="cancelStatusCd"/>
        <input type="hidden" name="realDlvrAmt" id="realDlvrAmt" />
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
                                <th>&nbsp;</th>
                                <th>주문상품</th>
                                <th>수량</th>
                                <c:if test="${refundType eq 'M'}">
                                    <th>반품가능수량</th>
                                </c:if>
                                <c:if test="${refundType eq 'V'}">
                                    <th>반품수량</th>
                                </c:if>
                                <th>판매가</th>
                                <th>할인금액</th>
                                <th>배송</th>
                                <th>결제금액</th>
                                <th>주문상태</th>
                            </tr>
                        </thead>
                        <tbody id="ajaxRefundGoodsList">
                        </tbody>
                    </table>

                     <a href="#" class="btn_gray2 change_btn mt20" id="btn_refund_go" refundType="${refundType}">선택</a>
                </div>

                <!--반품/환불상품-->
                <h3 class="tlth3">반품/환불상품</h3>
                <!-- tblh -->
                <div class="tblh mt0 tblmany line_no">
                    <table summary="이표는 반품/환불상품 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                        <caption>주문내역서 리스트</caption>
                        <colgroup>
                            <col width="*">
                            <col width="8%">
                            <col width="15%">
                            <col width="15%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>상품</th>
                                <th>수량</th>
                                <th>접수일시</th>
                                <th>완료일시</th>
                                <th>반품상태</th>
                                <th>환불상태</th>
                                <th>반품정보</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_refund_data">
                            <tr id="tr_refund_data_template">
                                <input type="hidden" name="refundOrdStatusCd" id="refundOrdStatusCd" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd"/>
                                <input type="hidden" name="refundOrdNo" id="refundOrdNo" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordNo"/>
                                <input type="hidden" name="refundOrdDtlSeq" id="refundOrdDtlSeq" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value=""/>
                                <input type="hidden" name="refundDlvrAmt" id="refundtoftalDlvrAmt" />
                                <input type="hidden" name="refundClaimQtt" id="refundClaimQtt" data-bind="refundInfo" data-bind-type="Text" data-bind-value="claimQtt" value=""/>
                                <input type="hidden" name="refundClaimNo" id="refundClaimNo" data-bind="refundInfo" data-bind-type="Text" data-bind-value="claimNo" value=""/>
                                <td class="txtl">
                                    <div class="item_box">
                                        <a href="#none" class="goods_img"><img src="" alt="" data-bind="refundInfo" data-bind-type="img" data-bind-value="imgPath" onerror="this.src='/admin/img/design/noImage.jpg'"/></a>
                                        <a href="#none" class="goods_txt">
                                            <span class="tlt" style="width:200px">
                                                <span data-bind="refundInfo" data-bind-type="String" data-bind-value="goodsNm"></span>
                                                <input type="hidden" readOnly name="goodsNm" id="goodsNm" data-bind="refundInfo" data-bind-type="Text" data-bind-value="goodsNm">
                                            </span>
                                            <span class="option">
                                                <%--<span class="ico01">옵션</span>--%>
                                                <span id="itemNm" data-bind="refundInfo" data-bind-type="string" data-bind-value="itemNm"></span>
                                            </span>
                                            <span class="code">[상품코드 : <span id="goodsNo" data-bind="refundInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]</span>
                                        </a>
                                    </div>
                                </td>
                                <td data-bind="refundInfo" data-bind-value="claimQtt" data-bind-type="number"></td>
                                <td data-bind="refundInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>
                                <td data-bind="refundInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>
                                <td data-bind="refundInfo" data-bind-value="returnNm"  data-bind-type="String"></td>
                                <td data-bind="refundInfo" data-bind-value="claimNm"  data-bind-type="String"></td>
                                <td>
                                	<a class="btn_gray2 change_btn mt20" data-bind="refundInfo" data-bind-value="claimContentChk" data-bind-type="function" data-bind-function="fn_claimContentChkView" >보기</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!--//반품/환불상품-->

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
                                <span class="intxt shot"><input type="text" name="pgAmt" id="pgAmt" /></span>
                                <span class="point_c5"><b>최초 결제금액 <label id="tempPgAmt">0</label>원</b></span>
                            </th>
                        </tr>
                        <tr>
                            <td class="point_c5" id="estimateAmt">0</td>
                            <td><span class="intxt shot"><input type="text" name="modifyAmt" id="modifyAmt" style="border:none" readonly/></span>원</td>
                            <td><span class="intxt shot"><input type="text" name="refundAmt" id="refundAmt" style="border:none" readonly/></span>원</td>
                            <td style="text-align:left; padding-left:45px;">
                                마켓포인트 환불 : <span class="intxt shot"><input type="text" name="payReserveAmt" id="payReserveAmt" readonly/></span>
                                <span class="point_c5"><b>최초 결제금액 <label id="tempReserveAmt">0</label>원</b></span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tbl_cancel -->

                    <h3 class="tlth3">결제취소정보</h3>
                    <!-- tblw -->
                    <div class="tblw mt0" style="max-height: unset !important;">
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
                                    <input type="hidden" name="orgRefundReturnCd" id="orgRefundReturnCd" value="">
                                    <span class="select" id="span_refundReturnCd_template">
                                        <label for="refundReturnCd" id="refundReturnCd2" ></label>
                                        <select name="refundReturnCd" id="refundReturnCd" >
                                            <option value="11">반품신청</option>
                                        <c:if test="${refundType eq 'V'}">
                                            <option value="12">반품완료</option>
                                            <option value="13">요청철회</option>
                                        </c:if>
                                        </select>
                                    </span>&nbsp;&nbsp;
                                    환불 상태
                                    <span class="select" id="span_refundClaimCd_template">
                                        <label for="refundClaimCd" id="refundClaimCd2"></label>
                                        <select name="refundClaimCd" id="refundClaimCd" >
                                            <option value="11">환불신청</option>
                                        <c:if test="${refundType eq 'V'}">
                                            <option value="12">환불완료</option>
                                        </c:if>
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
                        <button type="button" class="btn green" id="btn_refund_reg">완료</button>
                        <button type="button" class="btn green" id="btn_refund_close">닫기</button>
                    </div>
                </div>
            </div>
            <!-- //pop_con -->
        </form:form>
    </div>

    <!-- 신규 -->
<%--    <div class="pop_wrap size3">--%>
<%--        <div class="pop_tlt">--%>
<%--            <h2 class="tlth2">반품 사유</h2>--%>
<%--            <button class="close ico_comm">닫기</button>--%>
<%--        </div>--%>
<%--        <form:form id="form_refund_list">--%>
<%--            <input type="hidden" name="siteNo" value="${siteNo}" />--%>
<%--            <input type="hidden" name="preCheckGoods" id="preCheckGoods" value="0"/>--%>
<%--            <input type="hidden" name="curCheckGoods" id="curCheckGoods" value="0"/>--%>
<%--            <input type="hidden" name="cancelType" id="cancelType" value="02"/>--%>
<%--            <input type="hidden" name="restAmt" id="restAmt" />--%>
<%--            <input type="hidden" name="orgReserveAmt" id="orgReserveAmt" />--%>
<%--            <input type="hidden" name="partCancelYn" id="partCancelYn" value="N"/>--%>
<%--            <input type="hidden" name="ordDtlSeqArr" id="ordDtlSeqArr"/>--%>
<%--            <input type="hidden" name="claimQttArr" id="claimQttArr"/>--%>
<%--            <input type="hidden" name="claimNoArr" id="claimNoArr"/>--%>
<%--            <input type="hidden" name="claimMemo" id="claimMemo"/>--%>
<%--            <input type="hidden" name="claimDtlReason" id="claimDtlReason"/>--%>
<%--            <input type="hidden" name="orgPgAmt" id="orgPgAmt"/>--%>
<%--            <input type="hidden" name="claimReasonCd" id="claimReasonCd"/>--%>
<%--            <input type="hidden" name="returnCd" id="returnCd"/>--%>
<%--            <input type="hidden" name="claimCd" id="claimCd"/>--%>
<%--            <input type="hidden" name="ordNo" id="ordNo"/>--%>
<%--            <input type="hidden" name="cancelStatusCd" id="cancelStatusCd"/>--%>
<%--            <!-- pop_con -->--%>
<%--            <div class="pop_con">--%>
<%--                <div class="tblw">--%>
<%--                    <table>--%>
<%--                        <colgroup>--%>
<%--                            <col width="25%">--%>
<%--                            <col width="75%">--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                        <tr>--%>
<%--                            <th>환불 예상 금액</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>환불 조정 금액</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="modifyAmt" id="refund_modifyAmt">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>최종 환불 금액</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="refundAmt" id="refund_refundAmt">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>포인트 환불</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="" id="">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>쿠폰 환불</th>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="" id="">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th rowspan="3">환불 계좌 정보</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <select name="bankCd" id="refund_bankCd">--%>
<%--                                        <code:optionUDV codeGrp="BANK_CD"/>--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="actNo" id="refund_actNo">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <td>--%>
<%--                                <span class="intxt long">--%>
<%--                                    <input type="text" name="holderNm" id="refund_holderNm">--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        </tbody>--%>
<%--                    </table>--%>
<%--                </div>--%>
<%--                <div class="tblw mt20">--%>
<%--                    <table>--%>
<%--                        <colgroup>--%>
<%--                            <col width="25%">--%>
<%--                            <col width="75%">--%>
<%--                        </colgroup>--%>
<%--                        <tbody>--%>
<%--                        <tr>--%>
<%--                            <th>주문 번호</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>반품 번호</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>반품 사유</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>상세 사유</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>이미지</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>결제 취소 / 교환 / 환불</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>환불 상품</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>수량</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>금액</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>반품상태</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <select name="" id="">--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>환불상태</th>--%>
<%--                            <td>--%>
<%--                                <span class="select">--%>
<%--                                    <select name="" id="">--%>
<%--                                    </select>--%>
<%--                                </span>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>접수일</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>완료일시</th>--%>
<%--                            <td></td>--%>
<%--                        </tr>--%>
<%--                        <tr>--%>
<%--                            <th>관리메모</th>--%>
<%--                            <td>--%>
<%--                                <div class="txt_area">--%>
<%--                                    <textarea name="" id="" cols="30" rows="10"></textarea>--%>
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
<%--                    <button type="button" class="btn--blue_small" id="btn_save">저장</button>--%>
<%--                </div>--%>


<%--    &lt;%&ndash;            <div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <h3 class="tlth3">주문상품</h3>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <div class="tblh mt0 tblmany line_no">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <caption>주문내역서 리스트</caption>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="2%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="8%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="8%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="10%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="10%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="8%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="9%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="8%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <thead>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>&nbsp;</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>주문상품</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>수량</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <c:if test="${refundType eq 'M'}">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <th>반품가능수량</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </c:if>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <c:if test="${refundType eq 'V'}">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <th>반품수량</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </c:if>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>판매가</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>할인금액</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>배송</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>결제금액</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>주문상태</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </thead>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tbody id="ajaxRefundGoodsList">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    </table>&ndash;%&gt;--%>

<%--    &lt;%&ndash;                     <a href="#" class="btn_gray2 change_btn mt20" id="btn_refund_go" refundType="${refundType}">선택</a>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                </div>&ndash;%&gt;--%>

<%--    &lt;%&ndash;                <!--반품/환불상품-->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <h3 class="tlth3">반품/환불상품</h3>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!-- tblh -->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <div class="tblh mt0 tblmany line_no">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <table summary="이표는 반품/환불상품 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <caption>주문내역서 리스트</caption>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="*">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="8%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="10%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="10%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="10%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <thead>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>상품</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>수량</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>접수일시</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>완료일시</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>반품상태</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>환불상태</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>반품정보</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </thead>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tbody id="tbody_refund_data">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr id="tr_refund_data_template">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundOrdStatusCd" id="refundOrdStatusCd" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlStatusCd"/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundOrdNo" id="refundOrdNo" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordNo"/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundOrdDtlSeq" id="refundOrdDtlSeq" data-bind="refundInfo" data-bind-type="Text" data-bind-value="ordDtlSeq" value=""/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundDlvrAmt" id="refundtoftalDlvrAmt" />&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundClaimQtt" id="refundClaimQtt" data-bind="refundInfo" data-bind-type="Text" data-bind-value="claimQtt" value=""/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <input type="hidden" name="refundClaimNo" id="refundClaimNo" data-bind="refundInfo" data-bind-type="Text" data-bind-value="claimNo" value=""/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td class="txtl">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <div class="item_box">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <a href="#none" class="goods_img"><img src="" alt="" data-bind="refundInfo" data-bind-type="img" data-bind-value="imgPath" onerror="this.src='/admin/img/design/noImage.jpg'"/></a>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <a href="#none" class="goods_txt">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <span class="tlt" style="width:200px">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                                <span data-bind="refundInfo" data-bind-type="String" data-bind-value="goodsNm"></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                                <input type="hidden" readOnly name="goodsNm" id="goodsNm" data-bind="refundInfo" data-bind-type="Text" data-bind-value="goodsNm">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <span class="option">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                                &lt;%&ndash;<span class="ico01">옵션</span>&ndash;%&gt;&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                                <span id="itemNm" data-bind="refundInfo" data-bind-type="string" data-bind-value="itemNm"></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <span class="code">[상품코드 : <span id="goodsNo" data-bind="refundInfo" data-bind-value="goodsNo" data-bind-type="string" ></span>]</span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </a>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td data-bind="refundInfo" data-bind-value="claimQtt" data-bind-type="number"></td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td data-bind="refundInfo" data-bind-value="claimAcceptDttm"  data-bind-type="String"></td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td data-bind="refundInfo" data-bind-value="claimCmpltDttm"  data-bind-type="String"></td>                             &ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td data-bind="refundInfo" data-bind-value="returnNm"  data-bind-type="String"></td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td data-bind="refundInfo" data-bind-value="claimNm"  data-bind-type="String"></td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                	<a class="btn_gray2 change_btn mt20" data-bind="refundInfo" data-bind-value="claimContentChk" data-bind-type="function" data-bind-function="fn_claimContentChkView" >보기</a>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    </table>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!-- //tblh -->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!--//반품/환불상품-->&ndash;%&gt;--%>

<%--    &lt;%&ndash;                <!-- tbl_cancel -->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <div class="tbl_cancel tblmany" style="position:relative;">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <div class="order_add_plus"></div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <table summary="이표는 주문상품 환불 표 입니다. 구성은  입니다.">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <caption>주문상품 환불</caption>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="6%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="49%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <th>환불예상금액</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <th>환불조정금액</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <th>최종환불금액</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <th rowspan="2" class="line_no">=</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <th style="text-align:left; padding-left:45px;">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <span class="select">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <label for="pgType1" id="pgtype1"></label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <select name="pgType" id="pgType">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <tags:option codeStr="01:무통장 환불;02:PG 환불"/>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </select>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="intxt shot"><input type="text" name="pgAmt" id="pgAmt" /></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="point_c5"><b>최초 결제금액 <label id="tempPgAmt">0</label>원</b></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <td class="point_c5" id="estimateAmt">0</td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <td><span class="intxt shot"><input type="text" name="modifyAmt" id="modifyAmt" /></span> 원</td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <td><span class="intxt shot"><input type="text" name="refundAmt" id="refundAmt" /></span> 원</td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <td style="text-align:left; padding-left:45px;">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                마켓포인트 환불 : <span class="intxt shot"><input type="text" name="payReserveAmt" id="payReserveAmt" /></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="point_c5"><b>최초 결제금액 <label id="tempReserveAmt">0</label>원</b></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    </table>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!-- //tbl_cancel -->&ndash;%&gt;--%>

<%--    &lt;%&ndash;                <h3 class="tlth3">결제취소정보</h3>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!-- tblw -->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <div class="tblw mt0">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <table summary="이표는 결제취소정보 리스트 표 입니다. 구성은 계좌 정보, 상세사유, 관리메모 입니다.">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <caption>결제취소정보 리스트</caption>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="35%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="15%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <col width="35%">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </colgroup>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        <tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>처리 상태</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td  colspan=3>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    반품 상태&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <input type="hidden" name="orgRefundReturnCd" id="orgRefundReturnCd" value="">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <span class="select" id="span_refundReturnCd_template">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <label for="refundReturnCd" id="refundReturnCd2" ></label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <select name="refundReturnCd" id="refundReturnCd" >&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <option value="11">반품신청</option>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <c:if test="${refundType eq 'V'}">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <option value="12">반품완료</option>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <option value="13">요청철회</option>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </c:if>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </select>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </span>&nbsp;&nbsp;&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    환불 상태&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <span class="select" id="span_refundClaimCd_template">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <label for="refundClaimCd" id="refundClaimCd2"></label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <select name="refundClaimCd" id="refundClaimCd" >&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <option value="11">환불신청</option>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <c:if test="${refundType eq 'V'}">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                            <option value="12">환불완료</option>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </c:if>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        </select>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>   &ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            &ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr id="bankInfo" >&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>계좌 정보</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td colspan="3">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                은행&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="select " id="span_bankCd_template">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <label for="bankCd" id="bankCd2"></label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                      <select name="bankCd" id="bankCd">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                          <code:option codeGrp="BANK_CD" />&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                      </select>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                계좌번호&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="intxt long2  mr20"><input type="text" name="actNo" id="actNo" /></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                예금주&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="intxt"><input type="text" name="holderNm" id="holderNm" /></span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            &ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>취소사유</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td colspan="3">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <span class="select" id="span_refundReasonCd_template">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <label for="refundReasonCd" id="refundReasonCd2"></label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <select name="refundReasonCd" id="refundReasonCd">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <code:option codeGrp="CLAIM_REASON_CD" />&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </select>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </label>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </span>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>상세사유</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td colspan="3">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <div class="txt_area" style="height: auto;">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <textarea name="refundDtlReason" id="refundDtlReason" class="blind"></textarea>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            <tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th>관리메모</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <div class="txt_area">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                        <textarea name="refundMemo" id="refundMemo"></textarea>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <th class="line">처리로그</th>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                <td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    <div class="disposal_log">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                     <ul id='ajaxRefundLogList'>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                     </ul>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                                </td>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                            </tr>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                        </tbody>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    </table>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <!-- //tblw -->&ndash;%&gt;--%>
<%--    &lt;%&ndash;                <div class="btn_box txtc">&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <button type="button" class="btn green" id="btn_refund_reg">완료</button>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                    <button type="button" class="btn green" id="btn_refund_close">닫기</button>&ndash;%&gt;--%>
<%--    &lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--    &lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--            </div>--%>
<%--            <!-- //pop_con -->--%>
<%--        </form:form>--%>
<%--    </div>--%>
</div>
<!-- //layer_popup1 -->
