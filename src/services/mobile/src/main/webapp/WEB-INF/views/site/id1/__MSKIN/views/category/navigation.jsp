<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="product_head">
	<c:choose>
		<c:when test="${so.ctgNo eq '426' || so.ctgNo eq '434' }">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			${so.ctgNm }
		</c:when>
		<c:otherwise>
			<c:forEach var="navigationList" items="${navigation}" varStatus="status">
				<c:choose>
					<c:when test="${status.index < 1}">
						<c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
							<c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">
								<input type="hidden" id="navigation_combo_${status.index}" value="${ctgList1.ctgNo}"/>
								<c:if test="${status.index < 1}">
									<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>

									${ctgList1.ctgNm}
										<%-- BEST 제외 --%>
	                					<c:if test="${ctgList1.ctgNo ne '434'}">
										<a href="javascript:move_category('${ctgList1.ctgNo }', 'all');" class="all_product_link">
										<span class="all_product">전체상품</span>
										</a>
									</c:if>
									<%-- <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>${ctgList1.ctgNm} --%>
								</c:if>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<%--<select id="navigation_combo_${status.index}">
							<c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
								<option value="${ctgList1.ctgNo}" <c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">selected</c:if>>${ctgList1.ctgNm}</option>
			                </c:forEach>
						</select>--%>
					</c:otherwise>
				</c:choose>
		    </c:forEach>
		</c:otherwise>
	</c:choose>
</div>	
