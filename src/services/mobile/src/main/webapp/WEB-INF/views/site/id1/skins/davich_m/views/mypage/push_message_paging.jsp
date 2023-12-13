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


<c:if test="${fn:length(resultListModel.resultList) > 0}">
	<c:forEach var="li" items="${resultListModel.resultList }">
		<tr class="title <c:if test="${li.readYn eq 'N' }">no_read</c:if>" data-readyn="${li.readYn }" data-pushno="${li.pushNo }" onClick="javascript:fn_push_confirm(this);">
			<td>${li.appDate }</td>
			<td style="text-align:left;padding-left:10px;">${fn:substring(li.memo,0,30)}</td>
			<td class="textC">${li.appTime }</td>
			<td class="textC">${li.strName }</td>
		</tr>
		<tr class="hide">
			<td colspan="4">
				${li.memo}
				<c:if test="${li.imgUrl ne null}">
					<br><img src="${li.imgUrl}">
				</c:if>
			</td>
		</tr>
	</c:forEach>
</c:if>
							