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

	<c:if test="${null ne newsList.resultList}">
		<c:forEach var="bbsList" items="${newsList.resultList}" varStatus="status">
			<c:if test="${bbsList.rowNum ne 'notice' }">
				<li>
					<div class="tit">
						<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}')">${bbsList.title}</a>
					</div>
					<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}')">
                              <c:choose>
                                  <c:when test="${bbsList.imgFilePath ne null}">
                                      <img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${bbsList.imgFilePath}&id1=${bbsList.imgFileNm}'  alt=''>
                                  </c:when>
                                  <c:otherwise>
                                      <img src='../img/community/gallery_img01.gif' alt=''>
                                  </c:otherwise>
                              </c:choose>
					</a>
					<div class="right_text">
						<p class="text">
							<c:out value='${(bbsList.content).replaceAll("\\\<.*?\\\>","").replaceAll("&nbsp;"," ")}' />
						</p>
						<span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${bbsList.regDttm}" /></span>
					</div>
				</li>
			</c:if>
		</c:forEach>
	</c:if>
					