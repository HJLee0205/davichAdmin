<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
	<div class="search_qna_list">
	<ul class="search_qna_list">
		<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
            <c:choose>
				<c:when test="${moreYn eq 'Y'}">
				</c:when>
				<c:otherwise>
					<div class="product_head search">
						<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
						<a href="#"><span>'${so.searchWord }'</span> Q&A</a>
					</div>
			   </c:otherwise>
			</c:choose>
			<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
				<li>
					<p class="tit">
						<a href="${resultListModel.detailLink}"><em>Q.</em>${resultListModel.title}</a>
					</p>
					<p class="a_text"><em>A.</em>${resultListModel.content }</p>
					<span class="date">${resultListModel.regDate }</span>
				</li>
			</c:forEach>
			</c:when>
			<c:otherwise>
                <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p>
            </c:otherwise>
		</c:choose>
	</ul>
	</div>
		
	<!---- 페이징 ---->
	<c:if test="${(so.page * 3) < so.totalCount }">	
	    <div class="tPages" id="div_id_paging">
	        <grid:paging resultListModel="${resultListModel}" />
	    </div>
	</c:if>