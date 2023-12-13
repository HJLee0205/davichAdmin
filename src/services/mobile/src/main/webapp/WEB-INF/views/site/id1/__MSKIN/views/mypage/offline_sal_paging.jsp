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


<c:if test="${fn:length(salList) > 0}">
	<c:forEach var="s_li" items="${salList }">
		<c:forEach var="p_li" items="${s_li.prdList }" varStatus="s_status">
			<tr>
				<th class="textL" colspan="4">
					<fmt:parseDate var="salDate" value="${s_li.salDate }" pattern="yyyyMMdd" />
					<fmt:formatDate var="formatSalDate" value="${salDate }" pattern="yyyy-MM-dd" />
					<span class="offline_date">구매일 : ${formatSalDate }</span>
					<p class="offline_good_name">${p_li.itmName }</p>
				</th>
			</tr>
			<tr>
				<td class="stit">수량</td>
				<td>${p_li.qty }</td>
				<td class="stit">매장</td>
				<td>${s_li.strName }</td>
			</tr>
			<tr>
				<td class="stit">구매금액</td>
				<td colspan="3"><b>${p_li.salAmt }</b>원</td>
			</tr>
		</c:forEach>
	</c:forEach>
</c:if>
							