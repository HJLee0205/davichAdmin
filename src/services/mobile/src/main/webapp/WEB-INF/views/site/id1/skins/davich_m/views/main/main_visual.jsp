<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="main_visual">
    <ul class="main_visual_slider">
    <c:choose>
	    <c:when test="${mo_visual_banner.resultList ne null && fn:length(mo_visual_banner.resultList) gt 0}">
	   		<c:forEach var="resultModel" items="${mo_visual_banner.resultList}" varStatus="status">
	       	<li>
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
	</c:choose>
    </ul>
</div>