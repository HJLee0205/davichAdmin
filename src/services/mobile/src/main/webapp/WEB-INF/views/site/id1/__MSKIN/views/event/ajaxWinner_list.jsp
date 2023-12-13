<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>

	    <script type="text/javascript">
	    
	    $(function () {
			$( ".wng_text" ).hide();	
			$( ".wng_title" ).off("click").on('click', function() {
				$(".wng_text:visible").slideUp("middle");
				$(this).next('.wng_text:hidden').slideDown("middle");
				return false;
			
			});
    	});
		    
        </script>
	
			<c:forEach var="eventWngList" items="${eventWngList.resultList}" varStatus="status">
	        <%-- <input type="hidden" id="eventNo" name="eventNo" value="${eventWngList.eventNo}"/> --%>
			<c:if test="${eventWngList.wngCnt > 0}">
				<li class="wng_title" onclick="EventUtil.wngPopup(${eventWngList.eventNo})" style="cursor: pointer;">
					<div class="winner_ellipsis" style="width:auto;max-width:90%">
						${eventWngList.eventNm}
					</div>					 
					<!-- <span class="winner_new">NEW</span> -->
					<span class="winner_date">
						${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
	                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
	                </span>
				</li>
				<li class="wng_text" style="background:#f3f4f4 url(../img/product/dotline_01.png) repeat-x left top">
				</li>
			</c:if>
			<c:if test="${eventWngList.wngCnt eq 0}">
				<li class="wng_title" onclick="EventUtil.wngPopupIng()" style="cursor: pointer;">
					<div class="winner_ellipsis" style="width:auto;max-width:90%">
						${eventWngList.eventNm}
					</div>					 
					<!-- <span class="winner_new">NEW</span> -->
					<span class="winner_date">
						${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
	                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
	                </span>
				</li>
				<li class="wng_text" style="background:#f3f4f4 url(../img/product/dotline_01.png) repeat-x left top">
					당첨자 발표 진행중입니다.					
				</li>
			</c:if>
			</c:forEach>
		