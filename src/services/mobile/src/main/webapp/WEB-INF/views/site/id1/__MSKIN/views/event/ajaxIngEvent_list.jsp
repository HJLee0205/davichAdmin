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
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<script type="text/javascript">
$('.event_comment_view').each(function() {
    var dataMemberNo = parseInt($(this).find('button').attr('data-member-no'), 10);
    if(EventUtil.memberNo != dataMemberNo) {
        $(this).find('button').hide();
    }
});
</script>
        		<!-- 이벤트 댓글 페이징 -->
        		<c:if test="${eventLettList ne null}">
				<c:forEach var="eventLettList" items="${eventLettList.resultList}" varStatus="status">
					<li>
						<div>
						<span class="name">${StringUtil.maskingName(eventLettList.memberNm)}</span>
						<span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${eventLettList.regDttm}" /></span>
						</div>
						<c:set value="${eventLettList.content}" var="data"/>
						<c:set value="${fn:replace(data, cn, br)}" var="content"/>
						<p>${content}</p>
						<div class="event_comment_view">
						<button type="button" class="btn_review_del" id="" data-member-no="${eventLettList.memberNo}" onclick="EventUtil.deleteEventLett(${eventLettList.lettNo}, ${eventLettList.eventNo})">
							삭제
						</button>
						</div>
					</li>
				</c:forEach>
				</c:if>
				