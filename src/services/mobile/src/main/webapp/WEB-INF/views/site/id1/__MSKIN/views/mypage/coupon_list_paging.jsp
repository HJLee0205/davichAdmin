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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>

<c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">	
	<tr <c:if test="${couponList.couponKindCd eq '99' and couponList.useDttm eq null or couponList.offlineOnlyYn ne 'N'}">onClick="fn_print_pop('${couponList.memberCpNo}');"</c:if>>
		<td class="textL">
			<div class="my_coupon
					<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}">
						<c:choose>
							<c:when test="${couponList.goodsTypeCd eq '01' }"> off01</c:when>
							<c:when test="${couponList.goodsTypeCd eq '02' }"> off04</c:when>
							<c:when test="${couponList.goodsTypeCd eq '03' }"> off03</c:when>
							<c:when test="${couponList.goodsTypeCd eq '04' }"> off02</c:when>
							<c:otherwise> off00</c:otherwise>
						</c:choose>
					</c:if>">
				<c:choose>
					<c:when test="${couponList.couponBnfCd eq '01' }">
						<fmt:formatNumber value="${couponList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>		
					</c:when>
					<c:when test="${couponList.couponBnfCd eq '02' }">
						<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
					</c:when>
					<c:otherwise>
							${couponList.couponBnfTxt}
					</c:otherwise>
					<%--<c:otherwise>
						<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
					</c:otherwise>--%>
				</c:choose>
				${couponList.bnfUnit}
			</div>	
		</td>
		<td class="textL">
			${couponList.couponNm}
			<c:if test="${couponList.couponKindCd eq '99' and couponList.useDttm eq null or couponList.offlineOnlyYn ne 'N'}">▶</c:if>
			<span class="coupon_detail">
				<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시 
				<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
                   				/ 최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                   			</c:if>
			</span>
		</td>
		<td class="f11">
			<c:choose>
				<c:when test="${couponList.couponApplyPeriodCd eq '01' }">
					${couponList.cpApplyStartDttm}<br>~ ${couponList.cpApplyEndDttm}
				</c:when>
				<c:otherwise>
					<c:if test="${couponList.couponApplyPeriodDttm ne null}">
						${couponList.couponApplyPeriodDttm} 
						<br>
						<span class="coupon_dday">D-${couponList.couponApplyPeriod}일</span>
					</c:if>
				</c:otherwise>
			</c:choose>
		</td>
		<td>
			<c:choose>
                         <c:when test="${couponList.useDttm eq null}">
                         	미사용
                         </c:when>
                         <c:otherwise>
                         	${couponList.useDttm}
                         </c:otherwise>
                     </c:choose>
		</td>
	</tr>
</c:forEach>