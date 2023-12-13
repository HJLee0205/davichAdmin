<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
	<c:choose>
		<c:when test="${resultListModel.resultList ne null}">
		<h3 class="search_area_tit">상품</h3>
		    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
		</c:when>
		<c:otherwise>
		    <p class="no_blank">검색결과가 없습니다.</p>
		</c:otherwise>
	</c:choose>
	
	<!---- 페이징 ---->
	<div class="tPages" id="div_id_paging">
	    <grid:paging resultListModel="${resultListModel}" />
	</div>