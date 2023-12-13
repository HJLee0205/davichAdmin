<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${fn:length(mo_main_banner_magazine.resultList) > 0}">
<div class="dzine_banner_area">
	<ul>
	<c:forEach var="resultModel" items="${mo_main_banner_magazine.resultList}" varStatus="status">
		<li><a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img class="lazy" src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}"></a></li>
	</c:forEach>
	</ul>
	<div class="btm_banner_controls">
		<a href="#none" class="btn_magazine_prev"><i></i></a>
		<a href="#none" class="btn_magazine_next"><i></i></a>
	</div>
</div>
</c:if>