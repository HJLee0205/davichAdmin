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
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">지난 이벤트</t:putAttribute>
	
	<t:putAttribute name="script">
	    <script type="text/javascript">
	    	//페이징
		    //jQuery('#div_id_paging').grid(jQuery('#form_id_close_search'));
	    	
		    $('.more_view').on('click', function() {
	        	var pageIndex = Number($('#page').val())+1;
	          	var param = "page="+pageIndex;
	     		var url = '${_MOBILE_PATH}/front/event/event-close-ajax?'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
			    	if('${closeSo.totalPageCount}'==pageIndex){
			        	$('#div_id_paging').hide();
			        }
			        $("#page").val(pageIndex);
			        $('.list_page_view em').text(pageIndex);
			        $('.end_event_list').append(result);
		        })
	         });
		    
		    $('#ingEventList').on('click', function(e) {
	            location.href="${_MOBILE_PATH}/front/event/event-list";
	        });
		    
		    function detailEvent(eventNo, eventStatus){
                var eventNo = eventNo;
                var eventCd = eventStatus;
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/event/event-ing-list?eventNo='+eventNo,  {eventNo : eventNo, eventCd : eventCd});      
            }
		    
        </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    
    <div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			이벤트
		</div>
		<div class="cont_body">
		<h3 class="sub_stit02">지난 이벤트
			<button type="button" class="btn_event_view" id="ingEventList">진행중인 이벤트 보기</button>
		</h3>
		<form:form id="form_id_close_search" commandName="closeSo">
                <form:hidden path="page" id="page" />
                <input type="hidden" name="eventCd" value="close"/>
                 <ul class="event_list last">
                     <c:forEach var="eventCloseList" items="${eventCloseList.resultList}" varStatus="status">
	       				<li>
						<span class="label_end">종료된 이벤트입니다</span>
						<a href="javascript:detailEvent(${eventCloseList.eventNo},'close');">
						<%-- <a href="${_MOBILE_PATH}/front/event/event-ing-list?eventNo=${eventCloseList.eventNo}&eventCd=close"> --%>
							<img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventCloseList.eventMobileBannerImgPath}&id1=${eventCloseList.eventMobileBannerImg}" alt="${eventCloseList.eventNm}" onerror="this.src='../img/event/event_ing01.jpg'">
							<%-- <img src="http://www.davichmarket.com/image/image-view?type=EVENT&path=${eventCloseList.eventMobileBannerImgPath}&id1=${eventCloseList.eventMobileBannerImg}" title="${eventCloseList.eventNm}" onerror="this.src='../img/event/event_ing01.jpg'"> --%>
							<p class="tit">${eventCloseList.eventNm}</p>
							<span class="date">${eventCloseList.applyStartDttm.substring(0,10)} ~ ${eventCloseList.applyEndDttm.substring(0,10)}</span>
						</a>
						</li>
                     </c:forEach>
                 </ul>
                 <!---- 페이징 ---->
                 <div class="tPages" id="div_id_paging">
                     <grid:paging resultListModel="${eventCloseList}" />
                 </div>
    	 </form:form>
    	 </div>
	</div>	

    </t:putAttribute>
</t:insertDefinition>