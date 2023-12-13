<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
		<c:choose>
			<c:when test="${resultListModel.resultList ne null}">
			<c:choose>
				<c:when test="${moreYn eq 'Y'}">
				</c:when>
				<c:otherwise>
					<div class="product_head search">
						<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
						<a href="#"><span>'${so.searchWord }'</span> D.매거진</a>
					</div>
			   </c:otherwise>
			</c:choose>
			<ul class="search_magazine_list">
			    <c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
			    	<li>
					<a href="${resultListModel.detailLink }"><img src="${_IMAGE_DOMAIN}${resultListModel.goodsDispImgM }" style = "width : 90px; height : auto;" alt=""></a>
						<div class="right_text">
							<p class="tit"><a href="${resultListModel.detailLink }">${resultListModel.goodsNm}</a></p>
							<p class="text">${resultListModel.prWords}<br></p>
							<span class="date">${resultListModel.regDate}</span>
						</div>
					</li>
			   </c:forEach>
			  </ul>
			</c:when>
			<c:otherwise>
				<p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p>
			</c:otherwise>
		</c:choose>		
	</ul>
	<!-- //매거진 -->
	<c:if test="${(so.page * 3) < so.totalCount }">	
		<div class="tPages" id="div_id_paging">
		  	<grid:paging resultListModel="${resultListModel}" />
		</div>
	</c:if>