<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div class="dzine_banner_area">
	<ul>
		<c:choose>
	    	<c:when test="${main_banner_magazine.resultList ne null && fn:length(main_banner_magazine.resultList) gt 0}">
		        <c:forEach var="resultModel" items="${main_banner_magazine.resultList}" varStatus="status">
			        <li>
			            <%--<div class="slider_text">
			            	<button type="button" class="btn_visual">MORE<i></i></button>
			            </div>--%>
			            <c:if test="${!empty resultModel.linkUrl}">
							<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
						</c:if>
			            <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
			            <c:if test="${!empty resultModel.linkUrl}">
							</a>
						</c:if>
			        </li>
		        </c:forEach>
			</c:when>
			<c:otherwise>
	
			</c:otherwise>
		</c:choose>
	</ul>
</div>