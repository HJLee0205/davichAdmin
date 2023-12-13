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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">자주묻는 질문</t:putAttribute>
	
	<t:putAttribute name="script">
    <script type="text/javascript">
    jQuery(document).ready(function() {
        selectFaqTab('${so.faqGbCd}');
    });

    //faq tab click
    function selectFaqTab(idx){
    	activeTab(idx);
    	$("#page").val("1");
        $("#faqGbCd").val(idx);
        var faqGbCd = $("#faqGbCd").val();
        var searchVal = $("#qna_search").val();
        var param = {searchVal : searchVal, faqGbCd:faqGbCd};
		var url = '${_MOBILE_PATH}/front/customer/faq-tab?faqGbCd='+faqGbCd+'&searchVal='+searchVal+'&searchKind='+'all';
		$("#qna_search").val('');
		Dmall.AjaxUtil.load(url, function(result) {
	        $('#faq_list').html(result);
	        $('.faq_content').show();
        })

	    //FAQ 검색
	    $('#btn_qna_search').on('click', function() {
	        var searchVal = $("#qna_search").val();
	        var param = {searchVal : searchVal, faqGbCd:'', searchKind:'customerMain'};
	        var url = "${_MOBILE_PATH}/front/customer/faq-list";
	        Dmall.FormUtil.submit(url, param)
	    });
        
        function activeTab(faqGbCd){		    
            if($(".active").hasClass("active") === true) {
           	 $(".active").removeClass();
           	}	    
       		var id="faq_tabs_"+faqGbCd;
       		$('#'+id).addClass('active');     		
       	}
    }
    </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
   
   <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			자주묻는 질문
		</div>
		<div id="customer_content">
			<div class="customer_top">		
				<div class="text_area">
					<em>자주묻는질문 검색</em>으로 더 빠르게 궁금증을 해결해 보세요.
				</div>
				<div class="search_area">
					<input type="text" id="qna_search" value="${so.searchVal}"><button type="button" class="btn_q_search" id="btn_qna_search">검색</button>
				</div>
			</div>
			<form id="form_id_search" action="${_MOBILE_PATH}/front/customer/faq-list-ajax">
	        <input type="hidden" name="faqGbCd" id="faqGbCd" value="${so.faqGbCd}"/>
	        <input type="hidden" name="page" id="page" value="1" />
	        <ul class="faq_menu">
        		<li id="faq_tabs_" onclick="selectFaqTab('');">전체</li>
	            <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
                <li id="faq_tabs_${codeModel.dtlCd}" onclick="selectFaqTab('${codeModel.dtlCd}');">${codeModel.dtlNm}</li>
	            </c:forEach>
	        </ul>
			<div class="customer_content_area">
				<h2 class="customer_stit">
					<span>전체</span>
					<!-- <button type="button" class="btn_event_more" id="notice_more">전체보기</button> -->
				</h2>
				<div class="faq_content">
	           		<ul class="notice_list" id="faq_list">
	           		
	           		</ul>
	           	</div>				
			</div>
		</div><!-- //customer_content -->
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>