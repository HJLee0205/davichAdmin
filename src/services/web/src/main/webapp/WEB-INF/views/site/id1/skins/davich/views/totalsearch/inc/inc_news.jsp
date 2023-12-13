<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>

		<ul class="search_news_list">
		<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
			<h3 class="search_area_tit">뉴스</h3>
				<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
					<li>
					<c:if test="${resultListModel.imgFileNm ne ''}">
						<a href="${resultListModel.detailLink }"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${resultListModel.imgFilePath}&amp;id1=${resultListModel.imgFileNm}" alt=""></a>
					</c:if>
						<div class="right_text">
							<p class="tit"><a href="${resultListModel.detailLink }">${resultListModel.title}</a></p>
							<p class="text">${resultListModel.content }</p>
							<span class="date">${resultListModel.regDate }</span>
							<!-- <p class="text">${resultListModel.imgFileNm}</p>  -->
						</div>
					
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