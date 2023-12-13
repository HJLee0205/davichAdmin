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
<sec:authentication var="user" property='details'/>

	<c:forEach var="couponTypeList" items="${couponTypeList}" varStatus="status">
	<h3 class="zone_stit">${couponTypeList.goodsTypeCdNm}</h3>
	<c:set var="couponList" value="couponList${status.index}" />
	<c:set var="resultList" value="${requestScope.get(couponList)}" />
	<ul class="conpon_zone_list">
	<c:forEach var="couponList" items="${resultList }" varStatus="status">
		<c:set var="couponType" value=""/>
		<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'Y'}">
			<c:choose>
				<c:when test="${couponList.goodsTypeCd eq '01' }"><c:set var="couponType" value="off01"/></c:when>
				<c:when test="${couponList.goodsTypeCd eq '02' }"><c:set var="couponType" value="off04"/></c:when>
				<c:when test="${couponList.goodsTypeCd eq '03' }"><c:set var="couponType" value="off03"/></c:when>
				<c:when test="${couponList.goodsTypeCd eq '04' }"><c:set var="couponType" value="off02"/></c:when>
				<c:otherwise><c:set var="couponType" value="off00"/></c:otherwise>
			</c:choose>
		</c:if>
		<c:if test="${couponList.issueYn eq 'Y'}">
			<c:set var="couponType" value="${couponType } end"/>
		</c:if>
		<li id="li_${couponList.couponNo }">
			<p class="couponzone_name <c:if test="${couponList.issueYn eq 'Y'}">end</c:if>">${couponList.couponNm }</p>
			<div class="coupon ${couponType}">
				<p class="price">
				<em <c:if test="${couponList.couponBnfCd eq '03' }">style="font-size: 20px;"</c:if>>
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
						</c:choose>
				</em>
				<c:choose>
					<c:when test="${couponList.couponBnfCd eq '01'}">%</c:when>
					<c:when test="${couponList.couponBnfCd eq '02'}">원</c:when>
				</c:choose>
				<c:if test="${couponList.couponBnfCd ne '03' }">
				할인
				</c:if>

				</p>
				<p class="text">
					<c:if test="${couponList.couponUseLimitAmt > 0 }">
						<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시
					</c:if>
					<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
						<c:if test="${couponList.couponUseLimitAmt > 0 }"> / </c:if>
						최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
					</c:if>
				</p>
			</div>
			<c:choose>
				<c:when test="${couponList.issueYn eq 'Y'}">
					<button type="button" class="btn_zone_down" disabled>쿠폰받기 완료</button>
				</c:when>
				<c:otherwise>
					<button type="button" class="btn_zone_down" data-couponNo="${couponList.couponNo }" onClick="issueCoupon('${couponList.couponNo}','${couponList.offlineOnlyYn}')">쿠폰받기<i></i></button>
				</c:otherwise>
			</c:choose>
		</li>
		</c:forEach>
	</ul>
	</c:forEach>