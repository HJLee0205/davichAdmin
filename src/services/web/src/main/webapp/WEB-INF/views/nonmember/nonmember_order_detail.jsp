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
	<t:putAttribute name="title">비회원 주문/배송상세</t:putAttribute>


	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //재구매
        $('#btn_rebuy').on('click',function(){
            $('#order_form').attr('action','/front/order/order-form');
            $('#order_form').attr('method','post');
            $('#order_form').submit();
        });
    });

    function order_list(no, ordrMobile){
        Dmall.FormUtil.submit('/front/order/nomember-order-list', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile});
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 비회원 주문/배송조회 메인  --->
    <div class="contents fixwid">
    <form name="form_id_order_info" id="form_id_order_info">
        <input type="hidden" name="useGbCd" id="useGbCd"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="telNo" id="telNo"/>
        <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
        <c:choose>
            <c:when test="${fn:length(order_info.orderGoodsVO) gt 1}">
            <input type="hidden" name="goodsNm" id="goodsNm" value="${order_info.orderGoodsVO[0].goodsNm} 외 ${fn:length(order_info.orderGoodsVO)-1}건">
            </c:when>
            <c:otherwise>
            <input type="hidden" name="goodsNm" id="goodsNm" value="${order_info.orderGoodsVO[0].goodsNm}">
            </c:otherwise>
        </c:choose>
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 쇼핑<span>&gt;</span>주문/배송 조회
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">비회원 주문/배송조회<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 비회원 주문/배송조회 왼쪽 메뉴 --->
            <!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    주문/배송상세
                    <span class="row_info_text">(주문번호 ${so.ordNo})</span>
                </h3>
                <div class="warning_box">
                    <h4 class="warning_title">매번 같은 제품의 구매를 선호하시나요? !</h4>
                    <span>기존의 주문내역을 이용하여 간편하게 재주문 하세요. </span>
                    <button type="button" class="btn_myqna1" id="btn_rebuy">현재 상품 재주문하기</button>
                </div>
                <h3 class="mypage_con_stit">주문자정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">주문자정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">주문자명</th>
                            <td class="text12L">${order_info.orderInfoVO.ordrNm}</td>
                            <th class="textL">이메일</th>
                            <td class="text12L">${order_info.orderInfoVO.ordrEmail}</td>
                        </tr>
                        <tr>
                            <th class="textL">핸드폰</th>
                            <td class="text12L">${order_info.orderInfoVO.ordrMobile}</td>
                            <th class="textL">전화번호</th>
                            <td class="text12L">${order_info.orderInfoVO.ordrTel}</td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="mypage_con_stit">주문상품정보</h3>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문상품정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:37px">
                        <col style="width:68px">
                        <col style="width:">
                        <col style="width:58px">
                        <col style="width:120px">
                        <col style="width:82px">
                        <col style="width:124px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="3">상품명</th>
                            <th>수량</th>
                            <th>상품금액</th>
                            <th>배송비</th>
                            <th>주문/배송상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="sumQty" value="0"/>
                        <c:set var="sumSaleAmt" value="0"/>
                        <c:set var="sumDcAmt" value="0"/>
                        <c:set var="sumMileage" value="0"/>
                        <c:set var="sumDlvrAmt" value="0"/>
                        <c:set var="sumPayAmt" value="0"/>
                        <c:set var="preGrpCd" value=""/>
                        <c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
                        <c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
                        <tr>
                            <td class="padding3012">
                            <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
                                <img src="/front/img/product/icon_addition.png" alt="추가상품">
                            </c:if>
                            <c:if test="${orderGoodsVo.addOptYn ne 'Y'}">
                                ${orderGoodsVo.ordDtlSeq}
                            </c:if>
                            </td>
                            <td class="padding3012 pix_img">
                                <img src="${orderGoodsVo.imgPath}">
                            </td>
                            <td class="textL padding3012">
                                <ul class="mypage_s_list">
                                <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
                                        <li>${orderGoodsVo.goodsNm}</li>
                                </c:if>
                                <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                                    <li>${orderGoodsVo.goodsNm}</li>
                                    <c:if test="${!empty orderGoodsVo.itemNm}">
                                        <li>[기본옵션-<c:out value="${orderGoodsVo.itemNm}"/>]</li>
                                    </c:if>
                                    <li>[상품코드 : ${orderGoodsVo.goodsNo}]</li>
                                    <c:if test="${!empty orderGoodsVo.freebieNm}">
                                        <li>사은품<c:out value="${orderGoodsVo.freebieNm}"/></li>
                                    </c:if>
                                </c:if>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li>${orderGoodsVo.ordQtt}</li>
                                    <c:if test="${orderGoodsVo.saleAmt < 0}">
                                    <li><span class="fRed">(-${orderGoodsVo.ordQtt})</span></li>
                                    </c:if>
                                </ul>
                            </td>
                            <td class="padding3012">
                                <ul class="mypage_s_list">
                                    <li><fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="number"/>원</li>
                                    <c:if test="${orderGoodsVo.saleAmt < 0}">
                                    <li><span class="fRed">(-<fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="number"/>)</span></li>
                                    </c:if>
                                </ul>
                            </td>
                            <td class="padding3012" rowspan="${orderGoodsVo.cnt}">
                            <c:set var="dlvrText" value=""/>
                            <c:choose>
                                <c:when test="${orderGoodsVo.dlvrcPaymentCd eq '02' }">
                                    <c:set var="dlvrText" value="선불"/>
                                    <c:if test="${orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc == 0}">
                                        <c:set var="dlvrText" value="무료"/>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="dlvrText" value="${orderGoodsVo.dlvrcPaymentNm}"/>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                                ${dlvrText}
                                <c:if test="${orderGoodsVo.dlvrcPaymentCd ne '01' && orderGoodsVo.dlvrcPaymentCd ne '04' && orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc gt 0}">
                                <br><fmt:formatNumber value='${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}' type='number'/>원
                                </c:if>
                            </c:if>
                            </td>
                            <td class="padding3012" rowspan="${orderGoodsVo.cnt}">
                            ${orderGoodsVo.ordDtlStatusNm}
                            </td>
                        </tr>
                        <c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
                        <c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
                        <c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt}"/>
                        <c:set var="sumMileage" value="${sumMileage + orderGoodsVo.addedAmountAmt}"/>
                        <c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt}"/>
                        <c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
                        <%-- 재주문 관련 --%>
                        <c:set var="itemArr" value=""/>
                        <c:set var="optArr" value=""/>
                        <c:if test="${orderGoodsVo.itemNo ne preGrpCd && orderGoodsVo.addOptYn eq 'N'}">
                            <c:set var="itemArr" value="${orderGoodsVo.goodsNo}▦${orderGoodsVo.itemNo}^${orderGoodsVo.ordQtt}^${orderGoodsVo.dlvrcPaymentCd}▦"/>
                            <c:forEach var="optList" items="${order_info.orderGoodsVO }" varStatus="status2">
                                <c:if test="${optList.addOptYn eq 'Y' && optList.itemNo eq orderGoodsVo.itemNo}">
                                    <c:if test="${!empty optArr}">
                                        <c:set var="optArr" value="${optArr}*"/>
                                    </c:if>
                                    <c:set var="optArr" value="${optArr}${optList.addOptNo}^${optList.addOptDtlSeq}^${optList.ordQtt}"/>
                                </c:if>
                            </c:forEach>
                        <input type="hidden" name="itemArr" value="${itemArr}${optArr}▦${orderGoodsVo.ctgNo}">
                        </c:if>
                        <c:set var="preGrpCd" value="${orderGoodsVo.itemNo}"/>
                        </c:forEach>
                    </tbody>
                </table>

                <h3 class="mypage_con_stit">결제정보</h3>
                <div class="payment_info_area">
                    <ul class="payment_info">
                        <li>
                            총 상품금액
                            <span><fmt:formatNumber value='${sumSaleAmt}' type='number'/>원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_minus.png" alt="빼기">
                        </li>
                        <li>
                            총 할인금액
                            <span><fmt:formatNumber value="${sumDcAmt}" type="number"/>원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_plus.png" alt="더하기">
                        </li>
                        <li>
                            배송비 합계
                            <span><fmt:formatNumber value="${sumDlvrAmt}" type="number"/>원</span>
                        </li>
                        <li class="icon">
                            <img src="/front/img/mypage/icon_pay_total.png" alt="합계">
                        </li>
                        <li class="total">
                            최종 결제 금액 / 결제수단
                            <span class="price"><em><fmt:formatNumber value="${sumPayAmt}" type="number"/></em>원</span>
                            <span class="payment_method">
                            (
                            <c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
                            ${orderPayVO.paymentWayNm}
                            </c:forEach>
                            )</span>
                        </li>
                    </ul>
                </div>
                <br>
                <!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->
                <c:forEach var="orderPayVO_Bank" items="${order_info.orderPayVO}" varStatus="status">
                <c:if test="${orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22'}">
                <h3 class="mypage_con_stit">입금은행정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">입금은행정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">입금정보</th>
                            <td class="text12L">${orderPayVO_Bank.bankNm} ${orderPayVO_Bank.confirmNo} (입금자:${orderPayVO_Bank.dpsterNm})</td>
                        </tr>
                        <tr>
                            <fmt:parseDate var="dpstScdDt" value="${orderPayVO_Bank.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
                            <th class="textL">입금할 금액</th>
                            <td class="text12L"><em><fmt:formatNumber value="${orderPayVO_Bank.paymentAmt}" type="number"/>원</em> (<fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd HH:mm:ss" /> 까지)</td>
                        </tr>
                    </tbody>
                </table>
                </c:if>
                </c:forEach>
                <!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->

                <h3 class="mypage_con_stit">배송지 정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">배송지 정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">받는사람</th>
                            <td class="text12L">${order_info.orderInfoVO.adrsNm}</td>
                        </tr>
                        <tr>
                            <th class="textL">핸드폰 번호/연락처</th>
                            <td class="text12L">${order_info.orderInfoVO.adrsMobile} / ${order_info.orderInfoVO.adrsTel} </td>
                        </tr>
                        <tr>
                            <th class="textL">배송메모</th>
                            <td class="text12L">${order_info.orderInfoVO.dlvrMsg}</td>
                        </tr>
                        <tr>
                            <th class="textL">주소</th>
                            <td class="text12L">
                                <ul class="mypage_s_list">
                                    <li>우편번호: ${order_info.orderInfoVO.postNo}</li>
                                    <li>지번주소: ${order_info.orderInfoVO.numAddr}</li>
                                    <li>도로명주소: ${order_info.orderInfoVO.roadnmAddr}</li>
                                    <li>상세주소: ${order_info.orderInfoVO.dtlAddr}</li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="btn_area">
                    <c:if test="${billYn eq 'Y'}">
                    <c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
                        <c:if test="${orderPayVO.paymentWayCd eq '23'}">
                            <!-- 신용카드영수증 조회 -->
                            <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/><BR>
                            <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>" readonly="readonly"/><BR>
                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/><BR>
                            <button type="button" class="btn_prev_page" onclick="show_card_bill();">신용카드 영수증조회</button>
                        </c:if>
                        <c:if test="${orderPayVO.paymentWayCd eq '11' || orderPayVO.paymentWayCd eq '21' || orderPayVO.paymentWayCd eq '22'}">
                            <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/><BR>
                            <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>"readonly="readonly"/><BR>
                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/><BR>
                            <!-- 현금영수증발급신청 -->
                            <c:if test="${cash_bill_info.data.ordNo ne 'N' && tax_bill_info.data.ordNo ne 'N'}">
                            <button type="button" class="btn_prev_page" onclick="cash_receipt_pop();">현금영수증 발급신청</button>
                            <!-- 세금계산서발급신청 -->
                            <button type="button" class="btn_prev_page" onclick="tax_bill_pop();">세금계산서 발급신청</button>
                            </c:if>
                            <c:if test="${!empty cash_bill_info.data.linkTxNo}">
                            <input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}"/>
                            <!-- 현금영수증발급조회 -->
                            <button type="button" class="btn_prev_page" onclick="show_cash_receipt();">현금영수증조회</button>
                            </c:if>
                            <c:if test="${!empty tax_bill_info.data.linkTxNo}">
                            <!-- 세금계산서발급조회 -->
                            <button type="button" class="btn_prev_page" onclick="show_tax_bill();">세금계산서조회</button>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    </c:if>
                    <button type="button" class="btn_prev_page" onclick="order_list('${so.ordNo}', '${so.nonOrdrMobile}');">이전 페이지로</button>
                </div>
            </div>
            <!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->

            <!--- popup 현금영수증 발급신청 --->
            <div class="popup_my_cash" id="popup_my_cash" style="display: none;">
                <div class="popup_header">
                    <h1 class="popup_tit">현금영수증 발급신청</h1>
                    <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
                </div>
                <div class="popup_content">
                    <table class="tMypage_Board" style="margin-top:15px">
                        <caption>
                            <h1 class="blind">현금영수증 발급신청 폼 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:110px">
                            <col style="width:">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textL">발행용도</th>
                                <td class="textL">
                                    <input type="radio" id="cash_personal" name="my_cash" checked="checked">
                                    <label for="cash_personal" style="margin-right:44px">
                                        <span></span>
                                        개인 소득공제용
                                    </label>
                                    <input type="radio" id="cash_business" name="my_cash">
                                    <label for="cash_business">
                                        <span></span>
                                        사업자지출 증빙용
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">인증번호</th>
                                <td class="form">
                                    <input type="text" id="issueWayNo" name="issueWayNo"><span class="popup_text_info">휴대폰번호 or 사업자번호('-'없이 입력 해주세요)</span>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">주문자명</th>
                                <td class="form">
                                    <input type="text" id="applicantNm" name="applicantNm" value="${order_info.orderInfoVO.ordrNm}" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">이메일</th>
                                <td class="form">
                                    <input type="text" id="cash_email01" style="width:124px;"> @ <input type="text" id="cash_email02" style="width:124px;">
                                    <div class="select_box28" style="display:inline-block">
                                        <label for="cash_email03"></label>
                                        <select class="select_option" id="cash_email03" title="select option">
                                            <option value="" selected="selected">- 이메일 선택 -</option>
                                            <option value="naver.com">naver.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="etc">직접입력</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">전화번호</th>
                                <td class="form">
                                    <input type="text" id="cashTelNo" name="cashTelNo"><span class="popup_text_info">('-'없이 입력 해주세요)</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="btn_area">
                        <button type="button" class="btn_mypage_ok" onclick="apply_cash_receipt();">발급신청</button>
                        <button type="button" class="btn_mypage_cancel" onclick="close_cash_receipt_pop();">닫기</button>
                    </div>
                </div>
            </div>
            <!---// popup 현금영수증 발급신청 --->
            <!--- popup 세금계산서 발급신청 --->
            <div class="popup_my_cash" id="popup_my_tax" style="display: none;height:inherit">
                <div class="popup_header">
                    <h1 class="popup_tit">세금계산서 발급신청</h1>
                    <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
                </div>
                <div class="popup_content">
                    <table class="tMypage_Board" style="margin-top:15px">
                        <caption>
                            <h1 class="blind">세금계산서 발급신청 폼 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:110px">
                            <col style="width:">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textL">발행용도</th>
                                <td class="textL">
                                    <input type="radio" id="tax_Yes" name="my_tax" checked="checked">
                                    <label for="tax_yes" style="margin-right:44px">
                                        <span></span>
                                        과세 세금계산서
                                    </label>
                                    <input type="radio" id="tax_no" name="my_tax">
                                    <label for="tax_no">
                                        <span></span>
                                        비과세 세금계산서
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">상호명</th>
                                <td class="form">
                                    <input type="text" id="companyNm" name="companyNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">사업자번호</th>
                                <td class="form">
                                    <input type="text" id="bizNo" name="bizNo">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">대표자명</th>
                                <td class="form">
                                    <input type="text" id="ceoNm" name="ceoNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">업태/업종</th>
                                <td class="form">
                                    <input type="text" id="bsnsCdts" name="bsnsCdts"> / <input type="text" id="item" name="item">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL" rowspan="4">주소</th>
                                <td class="form">
                                    <input type="text" id="postNo" name="postNo" readonly="readonly"> <button type="button" class="btn_mypage_s03" id="btn_post">우편번호</button>
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(도로명)</span> <input type="text" id="roadnmAddr" name="roadnmAddr" class="t_input" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(지번)</span> <input type="text" id="numAddr" name="numAddr" class="t_input" readonly="readonly">
                                </td>
                            </tr>
                            <tr>
                                <td class="form">
                                    <span class="popup_text_info t_blank">(상세주소)</span> <input type="text" id="dtlAddr" name="dtlAddr" class="t_input">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">담당자명</th>
                                <td class="form">
                                    <input type="text" id="managerNm" name="managerNm">
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">담당자이메일</th>
                                <td class="form">
                                    <input type="text" id="tax_email01" style="width:124px;"> @ <input type="text" id="tax_email02" style="width:124px;">
                                    <div class="select_box28" style="display:inline-block">
                                        <label for="tax_email03"></label>
                                        <select class="select_option" id="tax_email03" title="select option">
                                            <option value="" selected="selected">- 이메일 선택 -</option>
                                            <option value="naver.com">naver.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="etc">직접입력</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th class="textL">전화번호</th>
                                <td class="form">
                                    <input type="text" id="taxTelNo" name="taxTelNo">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="btn_area">
                        <button type="button" class="btn_mypage_ok" onclick="apply_tax_bill();">발급신청</button>
                        <button type="button" class="btn_mypage_cancel" onclick="close_tax_bill_pop();">닫기</button>
                    </div>
                </div>
            </div>
            <!---// popup 세금계산서 발급신청 --->
        </div>
    </form>
    </div>
    <!---// 비회원 주문/배송조회 메인 --->
    </t:putAttribute>
</t:insertDefinition>