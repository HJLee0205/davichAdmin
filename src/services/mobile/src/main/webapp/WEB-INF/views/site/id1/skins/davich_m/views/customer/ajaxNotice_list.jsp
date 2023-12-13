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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<script>

$(function () {
	$( ".notice_view_text" ).hide();	
	$('.notice_view_title').off("click").on('click', function(e) {
		$(".notice_view_text:visible").slideUp("middle");
		$(this).next('.notice_view_text:hidden').slideDown("middle");
		return false;
    });
	
    $(".notice_view_text img").error(function() {
        $(".notice_view_text img").attr("src", "../img/product/product_200_200.gif");
    });
});

</script>

<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
<li>
	<ul class="notice_view">
		<li class="notice_view_title">
			${resultModel.title}
			<div class="notice_date">
				<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
			</div>
		</li>
		<li class="notice_view_text">
					<c:set value="${resultModel.content}" var="data"/>
					<c:set value="${fn:replace(data, cn, br)}" var="content"/>
					${content}
			<%-- ${resultModel.content} --%>
		</li>
	</ul>
</li>
</c:forEach>
				