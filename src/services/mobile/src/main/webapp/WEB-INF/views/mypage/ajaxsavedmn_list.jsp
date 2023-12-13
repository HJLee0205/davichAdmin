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
	<c:when test="${resultListModel.resultList ne null }">
		<c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" >                        
			<tr>
				<td>
				<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${savedmnList.regDttm}"/><br>
					${savedmnList.reasonNm}
				</td>
				<td>
					${savedmnList.content}
					<span class="emoney_detail">${savedmnList.svmnType} <fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
				</td>
				<td>
					<fmt:formatNumber value="${savedmnList.restAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
	
	</c:otherwise>
</c:choose>
            
			 