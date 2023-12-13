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
$('.event_comment_view').each(function() {
    var dataMemberNo = parseInt($(this).find('button').attr('data-member-no'), 10);
    if(EventUtil.memberNo != dataMemberNo) {
        $(this).find('button').hide();
    }
});
</script>
        		<!-- 이벤트 댓글 페이징 -->
				<c:forEach var="eventLettList" items="${eventLettList.resultList}" varStatus="status">
					<div class="comment_view">
						<span class="comment_writer">
	                      		${eventLettList.loginId}
						</span>
						<div class="comment_content">
							${eventLettList.content}
							<div class="event_comment_view">
								<fmt:formatDate pattern="yyyy-MM-dd" value="${eventLettList.regDttm}" />
								<button type="button" id="" data-member-no="${eventLettList.memberNo}" onclick="EventUtil.deleteEventLett(${eventLettList.lettNo}, ${eventLettList.eventNo})">
									<img src="../img/web/product/btn_reply_del.gif" alt="댓글삭제">
								</button>
							</div>
						</div>
					</div>	
				</c:forEach>	
				