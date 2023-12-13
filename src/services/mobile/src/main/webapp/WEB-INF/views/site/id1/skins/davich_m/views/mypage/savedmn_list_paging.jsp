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

<c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" >
	<tr>
		<input type="hidden" name="prcAmt" value="${savedmnList.prcAmt}">
		<td>
			<fmt:formatDate pattern="yyyy-MM-dd" value="${savedmnList.regDttm}"/><br>
			<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
				<span class="cash_plus">+${savedmnList.svmnTypeNm}</span>
			</c:if>
			<c:if test="${savedmnList.svmnTypeNm eq '차감'}">
				<span class="cash_minus">-${savedmnList.svmnTypeNm}</span>
			</c:if>
		</td>
		<td>
				${savedmnList.content}
		</td>
		<td>
			<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
				<span class="emoney_detail">
			</c:if>
			${savedmnList.svmnType} <fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
			<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
				</span>
			</c:if>
		</td>
	</tr>
</c:forEach>