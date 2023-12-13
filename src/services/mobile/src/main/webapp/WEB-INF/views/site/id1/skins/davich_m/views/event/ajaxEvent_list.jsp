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
<script>
$(".event_ing_list img").error(function() {
    $(".event_ing_list img").attr("src", "../img/event/event_ing01.jpg");
});
</script>
    
	            <c:forEach var="eventIngList" items="${eventIngList.resultList}" varStatus="status">
	            <li>
	            	<a href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo=${eventIngList.eventNo}">
	            	<img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventIngList.eventMobileBannerImgPath}&id1=${eventIngList.eventMobileBannerImg}" alt="${eventIngList.eventNm}" onerror="this.src='../img/event/event_ing01.jpg'">
	            	<%-- <img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&id1=${eventIngList.eventMobileBannerImgPath}_${eventIngList.eventMobileBannerImg}" alt="${eventIngList.eventNm}" onerror="this.src='../img/event/event_ing01.jpg'"> --%>
	            	</a>
	             	<dd>
                        <h4 class="event_stit">${eventIngList.eventNm}</h4>
                        <span class="end_event_date">${eventIngList.applyStartDttm.substring(0,10)} ~ ${eventIngList.applyEndDttm.substring(0,10)}</span>
                    </dd>
	            </li>
	            </c:forEach>
			