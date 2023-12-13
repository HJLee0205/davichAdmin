<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="main_visual">
    <!-- banner -->
    <div class="main_banner">
    	<c:choose>
	    	<c:when test="${visual_banner_side.resultList ne null && fn:length(visual_banner_side.resultList) gt 0}">
		       	<c:forEach var="resultModel" items="${visual_banner_side.resultList}" varStatus="status">
			       	<c:if test="${!empty resultModel.linkUrl}">
			       		<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
			       	</c:if>
			       		<img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
			       	<c:if test="${!empty resultModel.linkUrl}">
			       		</a>
			       	</c:if>
		   		</c:forEach>
	   		</c:when>
	   		<c:otherwise>
   			</c:otherwise>
   		</c:choose>
    </div>
    <!--// banner -->
    <!-- slider -->
    <ul class="main_visual_slider">
    <c:choose>
    	<c:when test="${visual_banner.resultList ne null && fn:length(visual_banner.resultList) gt 0}">
	        <c:forEach var="resultModel" items="${visual_banner.resultList}" varStatus="status">
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
    <!--// slider -->
</div>
