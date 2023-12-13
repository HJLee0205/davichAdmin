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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<script>
    $(function () {
    	$( ".review_view_text" ).hide();	
    	$('.review_view_title').off("click").on('click', function(e) {
    		$(".review_view_text:visible").slideUp("middle");
    		$(this).next('.review_view_text:hidden').slideDown("middle");
    		return false;
        });
    });
    
</script>

<c:if test="${resultListModel.resultList ne null}">
	<data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="N"/>
</c:if>