<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="main_visual">
    <ul class="main_visual_slider">
        <c:choose>
            <c:when test="${visual_banner.resultList ne null && fn:length(visual_banner.resultList) gt 0}">
            <c:forEach var="resultModel" items="${visual_banner.resultList}" varStatus="status">
            <li>
            <c:if test="${empty resultModel.linkUrl}">
            <img src="/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="" width="940px;" height="440px;">
            </c:if>
            <c:if test="${!empty resultModel.linkUrl}">
            <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="" width="940px;" height="440px;"></a>
            </c:if>
            </li>
            </c:forEach>
            </c:when>
            <c:otherwise>
            <li><img src="${_SKIN_IMG_PATH}/main/main_visual_banner_01.jpg" alt=""></li>
            </c:otherwise>
        </c:choose>
    </ul>
</div>
