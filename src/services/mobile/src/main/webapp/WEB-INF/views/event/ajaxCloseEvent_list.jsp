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

                     <c:forEach var="eventCloseList" items="${eventCloseList.resultList}" varStatus="status">
                         <li>
                         	<div class="event_content">
                             <dl class="end_event_info">
                                 <dt>
                                 <img src="http://www.davichmarket.com/image/image-view?type=EVENT&path=${eventCloseList.eventMobileBannerImgPath}&id1=${eventCloseList.eventMobileBannerImg}" title="${eventCloseList.eventNm}" onerror="this.src='../img/event/event_ing01.jpg'">
                                 </dt>
                                 <dd>
                                     <h4 class="event_stit">${eventCloseList.eventNm}</h4>
                                     <span class="end_event_date">${eventCloseList.applyStartDttm.substring(0,10)} ~ ${eventCloseList.applyEndDttm.substring(0,10)}</span>
                                 </dd>
                             </dl>
                             </div>
                         </li>
                     </c:forEach>
