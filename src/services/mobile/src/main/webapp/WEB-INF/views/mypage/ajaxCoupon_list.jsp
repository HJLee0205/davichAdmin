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
	<c:choose>
         <c:when test="${fn:length(resultListModel.resultList) > 0}">
         <c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">			
			<tr>
				<td class="textL">
					${couponList.couponNm}
					<span class="coupon_detail">
							<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상
		                         구매시
					</span>
				</td>
				<td>
					<span class="coupon_no">
						${couponList.couponBnfValue}${couponList.bnfUnit}할인
		                      <c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
		                      <br>(최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
		                      </c:if>
					</span>
				</td>
				<td>
				
				<fmt:parseDate value="${couponList.cpApplyEndDttm}" pattern="yyyy-MM-dd" var="endDay"/>
				<fmt:formatDate value="${endDay}" pattern="yyyy-MM-dd" var="dd"/>
				<fmt:parseNumber value="${endDay.time /(1000*60*60*24)}" integerOnly="true" var="oldDays" scope="request" />
					<c:choose>
					<c:when test="${oldDays-nowDays>0 }">
					${oldDays-nowDays} 일
					</c:when>
					<c:otherwise>
					 기간 만료
					</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		 
	</c:otherwise>
	</c:choose>
		 