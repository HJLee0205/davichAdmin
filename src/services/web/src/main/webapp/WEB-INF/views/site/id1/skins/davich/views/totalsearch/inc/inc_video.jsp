<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>

	<h3 class="search_area_tit">동영상</h3>
	
	<ul class="search_movie_list">
		<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
				<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
					<li>
					<a href="${resultListModel.linkUrl }">
						<div class="movie_area">
							<img src="https://img.youtube.com/vi/${fn:substring(resultListModel.linkUrl, 17, 99)}/0.jpg" style='width:221px; height:auto' ">
							<i class="icon_play"></i>
						</div>
						<p class="tit">${resultListModel.title}</p>
						<span>${resultListModel.regDate }</span>
					</a>
					</li>
				</c:forEach>
			</c:when>
		<c:otherwise>
             	  <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p>
           </c:otherwise>
		</c:choose>	
	</ul>
	
	<!---- 페이징 ---->
	<div class="tPages" id="div_id_paging">
	    <grid:paging resultListModel="${resultListModel}" />
	</div>