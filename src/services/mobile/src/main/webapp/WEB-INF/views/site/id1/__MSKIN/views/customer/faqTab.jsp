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
	    	
	        $('.more_view').on('click', function() {
	        	var fgc = $("#faqGbCd").val();
	       		var pageIndex = Number($('#page').val())+1;
	         	var param = "page="+pageIndex;
	    		var url = '${_MOBILE_PATH}/front/customer/faq-list-ajax?faqGbCd='+fgc+'&'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
			    	if('${so.totalPageCount}'==pageIndex){
			        	$('#div_id_paging').hide();
			        }
			        $("#page").val(pageIndex);
			        $('.list_page_view em').text(pageIndex);
			        $('.faq_list').append(result);
		        })
	        });
	    	
	    	
	    	$( ".notice_view_text" ).hide();	
	    	$('.notice_view_title').off("click").on('click', function(e) {
	    		$(".notice_view_text:visible").slideUp("middle");
	    		$(this).next('.notice_view_text:hidden').slideDown("middle");
	    		return false;
	        });
	    });
    </script>
	
	<c:if test="${resultListModel.resultList eq null}">
		<li class="none_data">
			데이터가 없습니다.
		</li>
	</c:if>
	<c:if test="${resultListModel.resultList ne null}">
	<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
		<li>
			<ul class="notice_view">
				<li class="notice_view_title">
					<span class="bar_tit">${resultModel.faqGbNm}</span>
					${resultModel.title}
				</li>
				<li class="notice_view_text" style="display: none;">
				<p class="que_text_area">	
					<c:set value="${resultModel.content}" var="data"/>
					<c:set value="${fn:replace(data, cn, br)}" var="content"/>
					${content}
					<%-- ${resultModel.content} --%>
				</p>
				</li>
			</ul>
		</li>
	</c:forEach>
	</c:if>
	
	<div class="tPages" id="div_id_paging">
   		<grid:paging resultListModel="${resultListModel}" />
    </div>
           		