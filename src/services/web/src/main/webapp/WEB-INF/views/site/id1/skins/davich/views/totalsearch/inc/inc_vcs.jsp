<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>

		<ul class="search_vision_list">
			<c:choose>
            <c:when test="${resultListModel.resultList ne null}">
				<c:forEach var="resultListModel" items="${resultListModel.resultList}" varStatus="status">
						<li>
							<a href="${resultListModel.detailLink }">
								<p class="tit">${resultListModel.title}</p>
								<img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${resultListModel.imgFilePath}&amp;id1=${resultListModel.imgFileNm}" alt="">
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