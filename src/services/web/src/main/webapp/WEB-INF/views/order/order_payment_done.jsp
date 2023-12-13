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
    <t:putAttribute name="title">주문완료</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
        <c:if test="${paymentList.paymentPgCd eq '04'}">
          <script language=javascript>
          // 올더게이트 "지불처리중"팝업창 닫는 부분
          var openwin = window.open("about:blank","popup","width=300,height=160");
          openwin.close();
          </script>
        </c:if>
    </c:forEach>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>주문완료
            </div>
        </div>
        <!---// category header --->

        <!--- cart --->
        <div id="cart">
            <h2 class="sub_title">주문완료<span>주문이 완료되었습니다. 마이페이지에서 주문을 확인하세요</span></h2>
            <ul class="checkout_steps">
                <li>장바구니</li>
                <li>주문결제</li>
                <li class="thisstep">주문완료</li>
            </ul>

            <h3 class="product_stit" >
                주문자 정보
                <!-- <button type="button" class="btn_address_plus floatR">새배송지 등록</button> -->
            </h3>
            <table class="tProduct_Insert">
                <caption>
                    <h1 class="blind">주문고객/배송지 정보 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:160px">
                    <col style="width:">
                    <col style="width:160px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">주문자명</th>
                        <td class="f12">${orderVO.orderInfoVO.ordrNm}</td>
                        <th class="order_tit">이메일</th>
                        <td class="f12">${orderVO.orderInfoVO.ordrEmail}</td>
                    </tr>
                    <tr>
                        <th class="order_tit">핸드폰</th>
                        <td class="f12">${orderVO.orderInfoVO.ordrMobile}</td>
                        <th class="order_tit">전화번호</th>
                        <td class="f12">${orderVO.orderInfoVO.ordrTel}</td>
                    </tr>
                </tbody>
            </table>

            <h3 class="product_stit">주문번호</h3>
            <table class="tProduct_Insert">
                <caption>
                    <h1 class="blind">주문고객/배송지 정보 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:160px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">주문번호</th>
                        <td class="f12">${orderVO.orderInfoVO.ordNo}</td>
                    </tr>
                </tbody>
            </table>

            <h3 class="product_stit">결제정보</h3>
            <table class="tProduct_Insert">
                <caption>
                    <h1 class="blind">결제정보 내용 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:160px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">상품금액 합계</th>
                        <td class="f12"><fmt:formatNumber value="${orderVO.orderInfoVO.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                    </tr>
                    <tr>
                        <th class="order_tit">배송비 합계</th>
                        <td class="f12">
                        <c:set var="goodsDlvrAmt" value="0"/>
                        <c:set var="areaAddDlvrAmt" value="0"/>
                        <c:set var="dlvrAmt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                            <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                            <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${dlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        (배송비: <fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원, 지역 추가 배송비:<fmt:formatNumber value="${areaAddDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">총 할인금액</th>
                        <td class="f12">
                        <c:set var="dcAmt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            <c:set var="dcAmt" value="${dcAmt+goodsList.dcAmt}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </td>
                    </tr>
                    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
                    <c:if test="${paymentList.paymentWayCd eq '01'}">
                    <tr>
                        <th class="order_tit">사용 마켓포인트</th>
                        <td class="f12">
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </td>
                    </tr>
                    </c:if>
                    </c:forEach>
                    <c:set var="payText" value="최종 결제금액/수단"/>
                    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
                        <c:if test="${paymentList.paymentWayCd eq '11' || paymentList.paymentWayCd eq '22'}">
                        <c:set var="payText" value="입금할금액/정보/날짜"/>
                        </c:if>
                    </c:forEach>
                    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
                    <c:if test="${paymentList.paymentWayCd ne '01' }">
                    <tr>
                        <th class="order_tit">결제수단</th>
                        <td class="f12">${paymentList.paymentWayNm}</td>
                    </tr>
                    <tr>
                        <th class="order_tit">${payText}</th>
                        <td class="f12">
                            <c:if test="${paymentList.paymentWayCd eq '23'}"> <%-- 신용카드 --%>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}_${paymentList.cardNm}
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '11'}"> <%-- 무통장 --%>
                            <fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}_${paymentList.bankNm}&nbsp;${paymentList.actNo}&nbsp;${paymentList.holderNm} / <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" />까지
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '21'}"> <%-- 실시간계좌이체 --%>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}_${paymentList.bankNm}
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '22'}"> <%-- 가상계좌 --%>
                            <fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}_${paymentList.bankNm}&nbsp;${paymentList.actNo} / <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" />까지
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '24'}"> <%-- 핸드폰결제 --%>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '31'}"> <%-- 간편결제(PAYCO) --%>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}
                            </c:if>
                            <c:if test="${paymentList.paymentWayCd eq '41'}"> <%-- PAYPAL --%>
                            <fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 / ${paymentList.paymentWayNm}
                            </c:if>
                        </td>
                    </tr>
                    </c:if>
                    </c:forEach>
                    <tr>
                        <th class="order_tit">적립혜택</th>
                        <td class="f12">
                        <c:choose>
                            <c:when test="${orderVO.orderInfoVO.pvdSvmn != 0}">
                            구매확정 시 :마켓포인트 <fmt:formatNumber value="${orderVO.orderInfoVO.pvdSvmn}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            </c:when>
                            <c:otherwise>
                            <span class="fRed">적립혜택이 없습니다.</span>
                            </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>

            <h3 class="product_stit">주문상품정보</h3>
            <table class="tCart_Board">
                <caption>
                    <h1 class="blind">장바구니 목록입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:68px">
                    <col style="width:">
                    <col style="width:220px">
                    <col style="width:85px">
                    <col style="width:95px">
                    <col style="width:85px">
                    <col style="width:107px">
                    <col style="width:75px">
                </colgroup>
                <thead>
                    <tr>
                        <th colspan="2">상품명</th>
                        <th>옵션</th>
                        <th>수량</th>
                        <th>상품금액</th>
                        <th>할인금액</th>
                        <th>합계</th>
                        <th>배송비</th>
                    </tr>
                </thead>
                <tbody>
                <c:set var="grpId" value=""/>
                <c:set var="preGrpId" value=""/>
                <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                    <c:set var="addOptAmt" value="0" />
                    <c:set var="payAmt" value="${goodsList.payAmt}" />
                    <c:if test="${goodsList.addOptYn eq 'N'}">
                    <tr>
                        <td class="pix_img">
                            <img src="${goodsList.imgPath}">
                        </td>
                        <td class="textL">
                            <a href="#">${goodsList.goodsNm}</span>
                        </td>
                        <td class="textL">
                            <ul class="cart_s_list">
                                <li>${goodsList.itemNm}</li>
                                <c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
                                    <c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
                                        <c:choose>
                                            <c:when test="${addOptList.saleAmt gt 0}">
                                                <c:set var="amtFlag" value="+"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="amtFlag" value="-"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <li>
                                            추가옵션 : ${addOptList.addOptNm}
                                            (${amtFlag}<fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                            - ${addOptList.ordQtt}개
                                        </li>
                                        <c:set var="payAmt" value="${payAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                        <c:set var="addOptAmt" value="${addOptAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </td>
                        <td class="textC"><fmt:formatNumber value="${goodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                        <td>
                            <ul class="cart_s_list">
                                <li><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</li>
                            </ul>
                        </td>
                        <td><fmt:formatNumber value="${goodsList.dcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                        <td><fmt:formatNumber value="${goodsList.saleAmt*goodsList.ordQtt-goodsList.dcAmt+addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                        <%-- 배송비 계산 --%>
                        <c:set var="grpId" value="${goodsList.dlvrSeq}"/>
                        <fmt:parseNumber var="realDlvrAmt" type="number" value="${goodsList.realDlvrAmt}"/>
                        <c:if test="${preGrpId ne grpId }">
                            <c:choose>
                                <c:when test="${realDlvrAmt == 0}">
                                    <c:choose>
                                        <c:when test="${goodsList.dlvrcPaymentCd eq '03'}">
                                            <td rowspan="${goodsList.noaddDlvrCnt}">착불</td>
                                        </c:when>
                                        <c:when test="${goodsList.dlvrcPaymentCd eq '04'}">
                                            <td rowspan="${goodsList.noaddDlvrCnt}">매장픽업</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td rowspan="${goodsList.noaddDlvrCnt}">무료</td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                <td rowspan="${goodsList.noaddDlvrCnt}"><fmt:formatNumber value="${goodsList.realDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <c:set var="preGrpId" value="${grpId}"/>
                        <%--<td>
                            <fmt:formatNumber value="${goodsList.realDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            <fmt:parseNumber var="areaAddDlvrc" type="number" value="${goodsList.areaAddDlvrc}"/>
                            <c:if test="${areaAddDlvrc != 0}">
                            <br>지역추가배송비<br>
                            <fmt:formatNumber value="${areaAddDlvrc}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            </c:if>
                        </td>--%>
                    </tr>
                    </c:if>
                </c:forEach>
                </tbody>
            </table>

            <h3 class="product_stit">배송지 정보</h3>
            <table class="tProduct_Insert">
                <caption>
                    <h1 class="blind">배송지 정보 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:140px">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">받는사람</th>
                        <td>${orderVO.orderInfoVO.adrsNm}</td>
                    </tr>
                    <tr>
                        <th class="order_tit">핸드폰 번호/연락처</th>
                        <td>${orderVO.orderInfoVO.adrsMobile} / ${orderVO.orderInfoVO.adrsTel}</td>
                    </tr>
                    <%-- <tr>
                        <th class="order_tit">상품명</th>
                        <td>BL7827/시스루패턴 하이넥블라우스</td>
                    </tr> --%>
                    <tr>
                        <th class="order_tit">배송메모</th>
                        <td>${orderVO.orderInfoVO.dlvrMsg}</td>
                    </tr>
                    <tr>
                        <th class="order_tit">주소</th>
                        <td>
                            <ul class="order_info_list">
                            <c:choose>
                                <c:when test="${orderVO.orderInfoVO.memberGbCd eq '10'}">
                                    <li>우편번호 : ${orderVO.orderInfoVO.postNo}</li>
                                    <li>지번주소 : ${orderVO.orderInfoVO.numAddr}</li>
                                    <li>도로명 주소 : ${orderVO.orderInfoVO.roadnmAddr}</li>
                                    <li>상세주소 : ${orderVO.orderInfoVO.dtlAddr}</li>
                                </c:when>
                                <c:otherwise>
                                    <li>COUNTRY : ${orderVO.orderInfoVO.frgAddrCountry}</li>
                                    <li>CITY : ${orderVO.orderInfoVO.frgAddrCity}</li>
                                    <li>STATE : ${orderVO.orderInfoVO.frgAddrState}</li>
                                    <li>ZIPCODE : ${orderVO.orderInfoVO.frgAddrZipCode}</li>
                                    <li>상세주소1 : ${orderVO.orderInfoVO.frgAddrDtl1}</li>
                                    <li>상세주소2 : ${orderVO.orderInfoVO.frgAddrDtl2}</li>
                                </c:otherwise>
                            </c:choose>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="btn_area">
                <button type="button" class="btn_go_main" onclick="location.href='/'">쇼핑몰 메인으로 가기</button>
            </div>
        </div>
        <!---// cart --->
    </t:putAttribute>
</t:insertDefinition>