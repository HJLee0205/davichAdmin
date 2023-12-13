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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">자주묻는 질문</t:putAttribute>
	
	<t:putAttribute name="script">
    <script type="text/javascript">
    jQuery(document).ready(function() {
        selectFaqTab("1");
    });

    //faq tab click
    function selectFaqTab(idx){
    	$("#page").val("1");
        $("#faqGbCd").val(idx);
        var param = $("#faqGbCd").val();
		var url = '${_MOBILE_PATH}/front/customer/faq-tab?faqGbCd='+param;
        Dmall.AjaxUtil.load(url, function(result) {
	        $('#faq_list').html(result);
	        $('.faq_content').show();
        })
    }

    </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents">
    
		<div class="event_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			고객센터
		</div>	
		<h2 class="customer_stit">
			<span>자주묻는 질문</span>
		</h2>
		
		<form id="form_id_search" action="${_MOBILE_PATH}/front/customer/faq-list-ajax">
        <input type="hidden" name="faqGbCd" id="faqGbCd" value="${so.faqGbCd}"/>
        <input type="hidden" name="page" id="page" value="1" />
	        <ul class="faq_menu">
	            <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
	                <li rel="faq_tabs_${codeModel.dtlCd}"
	                <c:if test="${status.count == so.faqGbCd}" >class="active"</c:if> onclick="selectFaqTab('${codeModel.dtlCd}');">${codeModel.dtlNm}
	                </li>
	            </c:forEach>
	        </ul>
	        
	        <div class="faq_content">
           		<ul class="faq_list" id="faq_list">
           		
           		</ul>
           	</div>
        
        </form>
        
	</div>	
    
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>