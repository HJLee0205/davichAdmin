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

		<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
			<h3 class="search_area_tit">Q&A - 자주하는 질문</h3>
			<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
			<div class="search_qna_list">
				<p class="tit">
					<a href="${resultListModel.detailLink}">${resultListModel.title}</a>
					<span class="date">${resultListModel.regDate }</span>
				</p>
				<%-- <p class="q_text">${resultListModel.content }</p> --%>
				<p class="a_text"><em>A.</em>${resultListModel.content }</p>
			</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
                <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p>
            </c:otherwise>
		</c:choose>
		
	<!---- 페이징 ---->
    <div class="tPages" id="div_id_paging">
        <grid:paging resultListModel="${resultListModel}" />
    </div>