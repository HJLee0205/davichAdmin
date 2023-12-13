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
	    	$( ".faq_anwser_view" ).hide();	
	    	$('.faq_title').off("click").on('click', function(e) {
	    		$(".faq_anwser_view:visible").slideUp("middle");
	    		$(this).next('.faq_anwser_view:hidden').slideDown("middle");
	    		return false;
	        });
	    });
    </script>
	
	<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
		<li>
			<ul class="faq_list_view">
				<li class="faq_title">
					<span class="title_no">${resultModel.num}</span>
					<p>${resultModel.title}</p>
				</li>
				<li class="faq_anwser_view">
					<c:set value="${resultModel.content}" var="data"/>
					<c:set value="${fn:replace(data, cn, br)}" var="content"/>
					${content}
					<%-- ${resultModel.content} --%>
				</li>
			</ul>
		</li>
	</c:forEach>
           		