<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%-- 기획전 할인 --%>
<c:set var="salePrice" value="${goodsInfo.data.salePrice}"/>

<c:choose>
    <c:when test="${member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
        <c:choose>
        <c:when test="${promotionInfo.data.firstBuySpcPrice > 0}">
            <c:set var="dcPrice" value="${goodsInfo.data.salePrice-promotionInfo.data.firstBuySpcPrice}"/>
            <c:set var="salePrice" value="${promotionInfo.data.firstBuySpcPrice}"/>
            <c:set var="prmtDcValue" value="0"/>
        </c:when>
        <c:otherwise>
            <c:if test="${promotionInfo.data.prmtDcGbCd eq '01'}">
                <c:set var="dcPrice" value="${goodsInfo.data.salePrice*((promotionInfo.data.prmtDcValue/100)/10)}"/>
                <c:set var="dcPrice" value="${(dcPrice-(dcPrice%1))*10}"/>
            </c:if>
            <c:if test="${promotionInfo.data.prmtDcGbCd eq '02'}">
                <c:set var="dcPrice" value="${promotionInfo.data.prmtDcValue}"/>
            </c:if>

            <c:set var="salePrice" value="${salePrice-dcPrice}"/>
            <c:set var="prmtDcValue" value="${promotionInfo.data.prmtDcValue}"/>
        </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${promotionInfo.data eq null}">
                <c:set var="dcPrice" value="0"/>
                <c:set var="salePrice" value="${salePrice}"/>
            </c:when>
            <c:otherwise>
                <c:if test="${promotionInfo.data.prmtDcGbCd eq '01'}">
                    <c:set var="dcPrice" value="${goodsInfo.data.salePrice*((promotionInfo.data.prmtDcValue/100)/10)}"/>
                    <c:set var="dcPrice" value="${(dcPrice-(dcPrice%1))*10}"/>
                </c:if>
                <c:if test="${promotionInfo.data.prmtDcGbCd eq '02'}">
                    <c:set var="dcPrice" value="${promotionInfo.data.prmtDcValue}"/>
                </c:if>

                <c:set var="salePrice" value="${salePrice-dcPrice}"/>
                <c:set var="prmtDcValue" value="${promotionInfo.data.prmtDcValue}"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
<%-- //기획전 할인 --%>

<%-- 회원등급 할인 --%>
<%-- <c:if test="${user.session.memberNo ne null}">
    <c:choose>
        <c:when test="${member_info.data.dcValue ne null}">
            <c:choose>
                <c:when test="${member_info.data.dcUnitCd eq '1'}">
                    <c:set var="memberGradeDcPrice" value="${salePrice*(member_info.data.dcValue/100)/10}"/>
                    <c:set var="memberGradeDcPrice" value="${(memberGradeDcPrice-(memberGradeDcPrice%1))*10}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="memberGradeDcPrice" value="${member_info.data.dcValue}"/>
                </c:otherwise>
            </c:choose>
            <c:set var="salePrice" value="${salePrice-memberGradeDcPrice}"/>
        </c:when>
        <c:otherwise>
            <c:set var="salePrice" value="${salePrice}"/>
        </c:otherwise>
    </c:choose>
</c:if> --%>

<%-- 마켓포인트 계산 --%>
<c:set var="pvdSvmnAmt" value="0"/>
<c:choose>
    <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'Y'}">
    <c:if test="${site_info.svmnPvdYn eq 'Y'}">
        <c:set var="svmnTruncStndrdCd" value="1"/>
        <c:choose>
            <c:when test="${site_info.svmnTruncStndrdCd eq '2'}">
                <c:set var="svmnTruncStndrdCd" value="10"/>
            </c:when>
            <c:when test="${site_info.svmnTruncStndrdCd eq '3'}">
                <c:set var="svmnTruncStndrdCd" value="100"/>
            </c:when>
            <c:when test="${site_info.svmnTruncStndrdCd eq '4'}">
                <c:set var="svmnTruncStndrdCd" value="1000"/>
            </c:when>
        </c:choose>
        <c:set var="pvdSvmnAmt" value="${goodsInfo.data.salePrice*(site_info.svmnPvdRate/100)/svmnTruncStndrdCd}"/>
        <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
    </c:if>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'N'}">
        <fmt:parseNumber var="goodsSvmnAmt" type="number" value="${goodsInfo.data.goodsSvmnAmt}"/>
        <c:set var="pvdSvmnAmt" value="${goodsSvmnAmt}"/>
    </c:when>
</c:choose>
<%-- // 마켓포인트 계산 --%>

<%-- 배송비 설정 --%>
<c:set var="dlvrMehtodCnt" value="0"/> <%-- 배송방법 갯수 --%>
<c:set var="goodsDlvrAmt" value="0"/> <%-- 배송비 --%>
<c:set var="couriUseYn" value="N"/> <%-- 택배 사용여부 --%>
<c:set var="directVisitRecptYn" value="N"/> <%-- 매장픽업 사용여부 --%>
<c:set var="dlvrPaymentKindCdCnt" value="0"/> <%-- 배송 결제 방법 코드 갯수--%>
<c:set var="dlvrPaymentKindCd" value="0"/> <%-- 배송 결제 방법 코드 --%>
<c:choose>
    <c:when test="${goodsInfo.data.dlvrSetCd eq '1'}"> <%-- 기본설정 배송비 사용 --%>
        <%-- 배송방법 갯수 --%>
        <c:if test="${seller_info.couriUseYn eq 'Y'}">
            <c:set var="dlvrMehtodCnt" value="${dlvrMehtodCnt+1}"/>
        </c:if>
        <c:if test="${seller_info.directVisitRecptYn eq 'Y'}">
            <c:set var="dlvrMehtodCnt" value="${dlvrMehtodCnt+1}"/>
        </c:if>
        <%-- 배송비 --%>
        <c:choose>
            <c:when test="${seller_info.defaultDlvrcTypeCd eq '1'}">
                <c:set var="goodsDlvrAmt" value="0"/>
            </c:when>
            <c:when test="${seller_info.defaultDlvrcTypeCd eq '2'}">
                <c:set var="goodsDlvrAmt" value="${seller_info.defaultDlvrc}"/>
            </c:when>
            <c:when test="${seller_info.defaultDlvrcTypeCd eq '3'}">
                <c:set var="goodsDlvrAmt" value="${seller_info.defaultDlvrMinDlvrc}"/>
            </c:when>
        </c:choose>
        <%-- 택배 사용여부 --%>
        <c:if test="${seller_info.couriUseYn eq 'Y'}">
            <c:set var="couriUseYn" value="Y"/>
        </c:if>
        <%-- 매장픽업 사용여부 --%>
        <c:if test="${seller_info.directVisitRecptYn eq 'Y'}">
            <c:set var="directVisitRecptYn" value="Y"/>
        </c:if>
        <%-- 배송 결제 방법 코드 --%>
        <c:if test="${seller_info.dlvrPaymentKindCd eq '1'}">
            <c:set var="dlvrPaymentKindCdCnt" value="1"/>
            <c:set var="dlvrPaymentKindCd" value="1"/>
        </c:if>
        <c:if test="${seller_info.dlvrPaymentKindCd eq '2'}">
            <c:set var="dlvrPaymentKindCdCnt" value="1"/>
            <c:set var="dlvrPaymentKindCd" value="2"/>
        </c:if>
        <c:if test="${seller_info.dlvrPaymentKindCd eq '3'}">
            <c:set var="dlvrPaymentKindCdCnt" value="2"/>
            <c:set var="dlvrPaymentKindCd" value="3"/>
        </c:if>
    </c:when>
    <c:otherwise> <%-- 상품별 배송비 사용 --%>
        <%-- 배송방법 갯수 --%>
        <c:if test="${goodsInfo.data.couriDlvrApplyYn eq 'Y'}">
            <c:set var="dlvrMehtodCnt" value="${dlvrMehtodCnt+1}"/>
        </c:if>
        <c:if test="${goodsInfo.data.directRecptApplyYn eq 'Y'}">
            <c:set var="dlvrMehtodCnt" value="${dlvrMehtodCnt+1}"/>
        </c:if>
        <%-- 배송비 --%>
        <c:choose>
            <c:when test="${goodsInfo.data.dlvrSetCd eq '2'}">
                <c:set var="goodsDlvrAmt" value="0"/>
            </c:when>
            <c:when test="${goodsInfo.data.dlvrSetCd eq '3'}">
                <c:set var="goodsDlvrAmt" value="${goodsInfo.data.goodseachDlvrc}"/>
            </c:when>
            <c:when test="${goodsInfo.data.dlvrSetCd eq '4'}">
                <c:set var="goodsDlvrAmt" value="${goodsInfo.data.packUnitDlvrc}"/>
            </c:when>
            <c:when test="${goodsInfo.data.dlvrSetCd eq '6'}">
                <c:set var="goodsDlvrAmt" value="${goodsInfo.data.goodseachcndtaddDlvrc}"/>
            </c:when>
        </c:choose>
        <%-- 택배 사용여부 --%>
        <c:if test="${goodsInfo.data.couriDlvrApplyYn eq 'Y'}">
            <c:set var="couriUseYn" value="Y"/>
        </c:if>
        <%-- 매장픽업 사용여부 --%>
        <c:if test="${goodsInfo.data.directRecptApplyYn eq 'Y'}">
            <c:set var="directVisitRecptYn" value="Y"/>
        </c:if>
        <%-- 배송 결제 방법 코드 --%>
        <c:if test="${goodsInfo.data.dlvrPaymentKindCd eq '1'}">
            <c:set var="dlvrPaymentKindCdCnt" value="1"/>
            <c:set var="dlvrPaymentKindCd" value="1"/>
        </c:if>
        <c:if test="${goodsInfo.data.dlvrPaymentKindCd eq '2'}">
            <c:set var="dlvrPaymentKindCdCnt" value="1"/>
            <c:set var="dlvrPaymentKindCd" value="2"/>
        </c:if>
        <c:if test="${goodsInfo.data.dlvrPaymentKindCd eq '3'}">
            <c:set var="dlvrPaymentKindCdCnt" value="2"/>
            <c:set var="dlvrPaymentKindCd" value="3"/>
        </c:if>
    </c:otherwise>
</c:choose>
<%-- //배송비 설정 --%>

<%-- 판매여부 goodsStatud - 01:판매중, 02:품절,03:판매대기,04:판매중지 --%>
<c:set var="goodsStockQtt" value="0"/>
<c:choose>
    <c:when test="${goodsInfo.data.multiOptYn eq 'Y'}">
        <c:forEach var="itemList" items="${goodsInfo.data.goodsItemList}" varStatus="status">
            <c:set var="goodsStockQtt" value="${goodsStockQtt+itemList.stockQtt}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <c:set var="goodsStockQtt" value="${goodsInfo.data.stockQtt}"/>
    </c:otherwise>
</c:choose>
<c:set var="goodsStatus" value=""/>
<c:choose>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '1'}">
        <c:choose>
            <c:when test="${goodsInfo.data.stockSetYn eq 'Y' && goodsInfo.data.availStockSaleYn eq 'Y'}">
                <c:choose>
                    <c:when test="${goodsStockQtt + goodsInfo.data.availStockQtt gt 0}">
                        <c:set var="goodsStatus" value="01"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="goodsStatus" value="02"/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${goodsStockQtt gt 0}">
                        <c:set var="goodsStatus" value="01"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="goodsStatus" value="02"/>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '2'}">
        <c:set var="goodsStatus" value="02"/>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '3'}">
        <c:set var="goodsStatus" value="03"/>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '4'}">
        <c:set var="goodsStatus" value="04"/>
    </c:when>
    <c:otherwise>
        <c:set var="goodsStatus" value="04"/><%--그외 판매중지로 처리--%>
    </c:otherwise>
</c:choose>
<%-- // 판매여부 --%>
<%--총 할인율--%>
<c:choose>
    <c:when test="${goodsInfo.data.customerPrice gt 0 }">
        <c:set var="totalSaleRate" value="${100-(salePrice/goodsInfo.data.customerPrice*100)}"/>
    </c:when>
    <c:otherwise>
        <c:set var="totalSaleRate" value="${100-(salePrice/goodsInfo.data.salePrice*100)}"/>
    </c:otherwise>
</c:choose>
<%--
<c:set var="totalSaleRate" value="${totalSaleRate < 0 ? -totalSaleRate:totalSaleRate}"/>--%>
<%-- logCorpAScript --%>
<c:set var="http_PC" value="${fn:replace(fn:replace(goodsInfo.data.goodsNm, '_', '-'),';',':')}" scope="request"/> <%--상품명 (상품명에 언더바[_]가 포함되어서는안됩니다.)--%>
<c:set var="log_ctg" value="${navigation[0].ctgNm}"/>
<c:if test="${navigation[1].ctgNm ne null}">
    <c:set var="log_ctg" value="${log_ctg};${navigation[1].ctgNm}"/>
</c:if>
<c:if test="${navigation[2].ctgNm ne null}">
    <c:set var="log_ctg" value="${log_ctg};${navigation[2].ctgNm}"/>
</c:if>
<c:if test="${navigation[3].ctgNm ne null}">
    <c:set var="log_ctg" value="${log_ctg};${navigation[3].ctgNm}"/>
</c:if>
<c:set var="http_PT" value="${log_ctg}" scope="request"/> <%--카테고리명(카테고리가 여러단계일 경우 ';'으로 구분 [예] AA;BB;CC)--%>
<c:set var="http_PS" value="${salePrice}" scope="request"/> <%--상품가격(예:29000)--%>
<%--// logCorpAScript --%>