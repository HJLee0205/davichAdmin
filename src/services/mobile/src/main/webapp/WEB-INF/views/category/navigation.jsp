<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="category_head">
	<c:forEach var="navigationList" items="${navigation}" varStatus="status">
		<c:choose>
			<c:when test="${status.index < 1}">
				<c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
					<c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">
						<input type="hidden" id="navigation_combo_${status.index}" value="${ctgList1.ctgNo}"/>
						<c:if test="${status.index < 1}">
							<h2 class="category_tit">${ctgList1.ctgNm}</h2>
						</c:if>
					</c:if>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<select id="navigation_combo_${status.index}">
					<c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
						<option value="${ctgList1.ctgNo}" <c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">selected</c:if>>${ctgList1.ctgNm}</option>
	                </c:forEach>
				</select>
			</c:otherwise>
		</c:choose>
    </c:forEach>
</div>	
