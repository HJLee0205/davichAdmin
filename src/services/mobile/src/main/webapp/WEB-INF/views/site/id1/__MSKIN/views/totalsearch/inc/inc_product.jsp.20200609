<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
	<div class="" id="categoryList1">
		<c:choose>
			<c:when test="${resultListModel.resultList ne null}">
			<c:choose>
				<c:when test="${moreYn eq 'Y'}">
				</c:when>
				<c:otherwise>
					<div class="product_head search">
						<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
						<a href="#"><span>'${so.searchWord }'</span> 상품</a>
					</div>
			   </c:otherwise>
			</c:choose>
			    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
			</c:when>
			<c:otherwise>
			    <p class="no_blank">검색결과가 없습니다.</p>
			</c:otherwise>
		</c:choose>
	</div>
	
	<!---- 페이징 ---->
	<c:if test="${(so.page * 20) < so.totalCount }">
		<div class="tPages" id="div_id_paging">
		    <grid:paging resultListModel="${resultListModel}" />
		</div>
	</c:if>