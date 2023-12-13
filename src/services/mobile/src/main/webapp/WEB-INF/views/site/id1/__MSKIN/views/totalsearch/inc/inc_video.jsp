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
		<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
            <c:choose>
				<c:when test="${moreYn eq 'Y'}">
				</c:when>
				<c:otherwise>
					<div class="product_head search">
						<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
						<a href="#"><span>'${so.searchWord }'</span> 동영상</a>
					</div>	
			   </c:otherwise>
			</c:choose>			
			<ul class="search_movie_list">
				<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
					<li>
						<a href="${resultListModel.linkUrl }">
							<div class="left_movie">
								<img src="https://img.youtube.com/vi/${fn:substring(resultListModel.linkUrl, 17, 99)}/0.jpg" style='width:221px; height:auto' ">
								<i class="icon_play"></i>
							</div>
							<div class="right_text">
								<p class="tit">${resultListModel.title}</p>
								<span>${resultListModel.regDate }</span>
							</div>
						</a>
					</li>
				</c:forEach>
			</ul>
			</c:when>
		<c:otherwise>
             	  <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p>
           </c:otherwise>
		</c:choose>	
	</ul>
	
	<!---- 페이징 ---->
	<c:if test="${(so.page * 3) < so.totalCount }">	
		<div class="tPages" id="div_id_paging">
		    <grid:paging resultListModel="${resultListModel}" />
		</div>
	</c:if>