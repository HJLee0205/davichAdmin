<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>

<c:if test="${null ne resultListModel.resultList}">
	<c:forEach var="bbsList" items="${resultListModel.resultList}" varStatus="status">
		<%-- 비밀글 --%>
		<c:choose>
			<c:when test="${bbsList.sectYn eq 'Y'}">
				<c:set var="title" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${bbsList.title}"/>
			</c:when>
			<c:otherwise>
				<c:set var="title" value="${bbsList.title}"/>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${bbsList.imgFilePath ne null}">
				<c:set var="bbsImg" value="<img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${bbsList.imgFilePath}&id1=${bbsList.imgFileNm}'  width='150px' height='150px' alt=''>"/>
			</c:when>
			<c:otherwise>
				<c:set var="bbsImg" value="<img src='../img/community/gallery_img01.gif'  width='150px' height='150px' alt=''>"/>
			</c:otherwise>
		</c:choose>
		<li>
			<div class="gallery_check">
				<c:choose>
					<c:when test="${so.bbsId eq 'video' && bbsList.linkUrl ne null && bbsList.linkUrl ne ''}">
						<a href="${bbsList.linkUrl }" target="_blank">
							${bbsImg}
						</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}')">
							${bbsImg}
						</a>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="ellipsis">
			    <c:choose>
					<c:when test="${so.bbsId eq 'video' && bbsList.linkUrl ne null && bbsList.linkUrl ne ''}">
						<a href="${bbsList.linkUrl }" target="_blank">
							${title}
						</a>
					</c:when>
					<c:otherwise>
						<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}')">
							${title}
						</a>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="gallery_info">
		    	${bbsList.memberNm}<%-- (${bbsList.regrNo}) --%><br>
				<fmt:formatDate pattern="yyyy-MM-dd" value="${bbsList.regDttm}" />
		    </div>
		</li>
	</c:forEach>
</c:if>