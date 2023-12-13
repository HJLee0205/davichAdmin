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
<t:insertDefinition name="popupLayout">
    <t:putAttribute name="title">홈 &gt; 주문 &gt; 주문관리 &gt; 주문내역서</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        function printWindow(){
            bV = parseInt(navigator.appVersion);
            if (bV >= 4) window.print();
        }
/*         
        jQuery(document).ready(function() {
            setDefaultFday();
            jQuery('#btnPrint').on('click', function() {
                alert("print");
                    bV = parseInt(navigator.appVersion);
                    alert(bV);
                    if (bV >= 4) window.print();
            });
        });
        
 */        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
<!-- layer_popup1 -->
<div id="layout1" class="layer_popup wid_p100p" style="display:block;">
    <div class="pop_wrap">
        <!-- oder_tlt -->
        <div class="oder_tlt">
            <div class="left">
                <strong>${rsltInfoVo.ordrNm}</strong> 님의 주문상품 정보입니다.
            </div>
            <h2 class="tlth2">주문내역서</h2>
            <div class="right">
                <strong>주문일</strong> : <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${rsltInfoVo.ordAcceptDttm}" /><br>
                <strong>주문번호</strong> : ${rsltInfoVo.ordNo}
            </div>
        </div>
        <!-- //oder_tlt -->
        <!-- tblh -->
        <div class="tblh tblmany line_no">
            <table summary="이표는 주문내역서 리스트 표 입니다. 구성은 주문상품, 수량, 판매가, 할인금액, 사용 마켓포인트, 배송, 결제금액, 주문상태 입니다.">
                <caption>주문내역서 리스트</caption>
                    <colgroup>
                        <col width="40%">
                        <col width="8%">
                        <col width="8%">
                        <col width="8%">
                        <col width="12%">
                        <col width="8%">
                        <col width="8%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문상품</th>
                            <th>수량</th>
                            <th>판매가</th>
                            <th>할인금액</th>
                            <th>배송</th>
                            <th>결제금액</th>
                            <th>주문상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="sumQty" value="0"/>
                        <c:set var="sumSaleAmt" value="0"/>
                        <c:set var="sumDcAmt" value="0"/>
                        <c:set var="sumDlvrAmt" value="0"/>
                        <c:set var="sumPayAmt" value="0"/>
                        <c:set var="totalRow" value="${orderGoodsVO.size()}"/>
                        <c:forEach var="orderGoodsVo" items="${orderGoodsVO}" varStatus="status">
                        <tr>
                            <td class="txtl">
                                <div class="item_box">
                                <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
                                    <span class="addition" >
                                        <img src="/admin/img/order/icon_addition.png" alt="추가상품" />
                                    </span>
                                </c:if>
                                    <a href="#none" class="goods_img"><img src="${orderGoodsVo.imgPath}"  alt="" /></a>
                                <c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
                                    <a href="#none" class="goods_txt">
                                        <span class="tlt">${orderGoodsVo.goodsNm}</span>
                                    </a>
                                </c:if>
                                <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                                    <a href="#none" class="goods_txt">
                                        <span class="tlt">${orderGoodsVo.goodsNm}</span>
                                        <c:if test="${orderGoodsVo.itemNm ne null and orderGoodsVo.itemNm ne ''}">
                                        <span class="option">
                                            <span class="ico01">옵션</span>
                                            <c:out value="${orderGoodsVo.itemNm}"/>
                                        </span>
                                        </c:if>
                                        <span class="code">[상품코드 : ${orderGoodsVo.goodsNo}]</span>
                                        <c:if test="${orderGoodsVo.freebieNm ne null and orderGoodsVo.freebieNm ne ''}">
                                        <span class="option">
                                           <span class="ico01">사은품</span>
                                           <c:out value="${orderGoodsVo.freebieNm}"/>
                                        </span>
                                        </c:if>
                                    </a>
                                </c:if>
                                </div>
                            </td>
                            <td>${orderGoodsVo.ordQtt}</td>
                            <td class="txtr"><fmt:formatNumber value='${orderGoodsVo.saleAmt}' type='number'/></td>
                            <td class="txtr"><fmt:formatNumber value='${orderGoodsVo.dcAmt}' type='number'/></td>
                            <c:if test="${orderGoodsVo.addOptYn eq 'N' and orderGoodsVo.dlvrcCnt ne 0}">
                            <td rowspan="${orderGoodsVo.dlvrcCnt}" id='${orderGoodsVo.areaAddDlvrc}'>
                                <c:choose>
                                <c:when test="${orderGoodsVo.areaAddDlvrc ne '0.00' }">
                                    선불<br>
                                </c:when>
                                <c:otherwise>
                                    ${orderGoodsVo.dlvrcPaymentNm}<br>
                                </c:otherwise>
                                </c:choose>
                            <c:if test="${(orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc) > 0 }">
                            <fmt:formatNumber value='${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}' type='number'/>
                            </c:if>
                            </td>
                            </c:if>
                            <td class="txtr"><fmt:formatNumber value='${orderGoodsVo.payAmt}' type='number'/></td>
                            <c:if test="${orderGoodsVo.addOptYn eq 'N'}">
                            <td rowspan="${orderGoodsVo.cnt}">${orderGoodsVo.ordDtlStatusNm}</td>
                            </c:if>
                        </tr>
                    <c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
                    <c:set var="sumSaleAmt" value="${sumSaleAmt + orderGoodsVo.saleAmt}"/>
                    <c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt}"/>
                    <c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc}"/>
                    <c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                            <td class="txtr fwb">소계</td>
                            <td><c:out value="${sumQty}"/></td>
                            <td class="txtr"><fmt:formatNumber value='${sumSaleAmt}' type='number'/></td>
                            <td class="txtr"><fmt:formatNumber value='${sumDcAmt}' type='number'/></td>
                            <td><fmt:formatNumber value='${sumDlvrAmt}' type='number'/></td>
                            <td class="txtr total"><fmt:formatNumber value='${sumPayAmt}' type='number'/></td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
        </div>
        <!-- //tblh -->
        <!-- double_lay -->
        <div class="double_lay">
            <div class="left">
                <div>
                    <h3 class="tlth3">결제정보</h3>
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 결제정보 표 입니다. 구성은  입니다.">
                            <caption>결제정보</caption>
                            <colgroup>
                                <col width="25%">
                                <col width="75%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>주문자</th>
                                    <td>${rsltInfoVo.ordrNm}</td>
                                </tr>
                                <tr>
                                    <th>연락처</th>
                                    <td>
                                        핸드폰 : ${rsltInfoVo.ordrMobile}<br>
                                        일반전화: ${rsltInfoVo.ordrTel}
                                    </td>
                                </tr>
                                <tr>
                                    <th>결제일자</th>
                                    <td>${rsltInfoVo.paymentCmpltDttm}</td>
                                </tr>
                                <tr>
                                    <th>결제방법</th>
                                    <td>${rsltInfoVo.paymentWayNm}</td>
                                </tr>
                                <tr>
                                    <th>결제금액</th>
                                    <td><fmt:formatNumber value='${rsltInfoVo.paymentAmt}' type='number'/>원</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </div>
            <div class="right">
                <div>
                    <h3 class="tlth3">배송지정보</h3>
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 배송지정보 표 입니다. 구성은  입니다.">
                            <caption>배송지정보</caption>
                            <colgroup>
                                <col width="25%">
                                <col width="75%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>수령인</th>
                                    <td>${rsltInfoVo.adrsNm}</td>
                                </tr>
                                <tr>
                                    <th>수령지주소</th>
                                    <td>
                                        ${rsltInfoVo.postNo}<br>
                                        ${rsltInfoVo.roadnmAddr} ${rsltInfoVo.dtlAddr}
                                    </td>
                                </tr>
                                <tr>
                                    <th>연락처</th>
                                    <td>
                                        핸드폰 : ${rsltInfoVo.adrsMobile}<br>
                                        일반전화: ${rsltInfoVo.adrsTel}
                                    </td>
                                </tr>
                                <tr>
                                    <th>${rsltInfoVo.dlvrMsg}</th>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </div>
        </div>
        <!-- double_lay -->
        <div class="btn_box txtc">
            <a href="javascript:printWindow()" id="btnPrint" class="btn green">출력</a>
        </div>
    </div>
</div>
<!-- //content -->
    </t:putAttribute>
</t:insertDefinition>