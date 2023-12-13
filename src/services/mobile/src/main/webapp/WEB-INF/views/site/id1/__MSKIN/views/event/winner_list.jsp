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
	<t:putAttribute name="title">당첨자 발표</t:putAttribute>
	
	<t:putAttribute name="script">
	    <script type="text/javascript">
	    
	    	//페이징
		    jQuery('#div_id_wng_paging').grid(jQuery('#form_id_wng_search'));
	    	
	    	
		    $('.more_view').on('click', function() {
	        	var pageIndex = Number($('#page').val())+1;
	          	var param = "page="+pageIndex;
	     		var url = '${_MOBILE_PATH}/front/event/winner-list-ajax?'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
			    	if('${wngSo.totalPageCount}'==pageIndex){
			        	$('#div_id_wng_paging').hide();
			        }
			        $("#page").val(pageIndex);
			        $('.list_page_view em').text(pageIndex);
			        $('.winner_list').append(result);
		        })
	         });
	    	
	    	
		    var EventUtil = {
		    		wngPopup:function(eventNo, wngYn, obj) {
		    			jQuery('.wng_text').html('');
		    			
		    			var url = '${_MOBILE_PATH}/front/event/event-winning-info',dfd = jQuery.Deferred();
	                    var param = {eventNo:eventNo, wngYn:wngYn};

	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	      
	                    	var wngNmHtml = '';
                            var wngContentHtml = '';
                            if(result.data.wngNm != null) {
                            	wngNmHtml = '<div class="tit">'+result.data.wngNm+'</div>';
                            }
                            if(result.data.wngContentHtml != null) {
                                wngContentHtml = '<div>'+result.data.wngContentHtml+'</div>';
                            }
                            jQuery('.wng_text').html('');
                            $('.wng_text').append('<span id="wngWrapper" class="tit">'+wngNmHtml + wngContentHtml +'</span><br>');
                            $('#wngWrapper').find('div').each(function() {
                                $(this).find('img').css({'width':289+'px'});
                            });
	                        dfd.resolve(result.data);
	                    });
	                    
	                    var url = '${_MOBILE_PATH}/front/event/event-winning-list',dfd = jQuery.Deferred();
	                    var param = {eventNo:eventNo, wngYn:wngYn}

	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                        if(result.success){
	                        	
	                            if(wngYn != null && wngYn != '' && wngYn == 'Y'){
		                        	var template =
	                        			'{{memberNm}} / {{mobile}}<br>',
		                            	managerGroup = new Dmall.Template(template),
		                            	tr = '';
		                           
		                            jQuery.each(result.resultList, function(idx, obj) {
		                                var key;
		                                for(key in obj) {
		                                    //휴대폰번호 마스킹 처리
		                                    if(key === 'mobile') {
		                                        obj[key] = EventUtil.maskingMobile(obj[key]);
		                                    }
		
		                                    //휴대폰번호 마스킹 처리
		                                    if(key === 'memberNm') {
		                                        if(obj[key] !== null && obj[key] !== '' && obj[key] !== 'undefined') {
		                                            obj[key] = EventUtil.maskingName(obj[key]);
		                                        }
		                                    }
		                                }
		                                tr += managerGroup.render(obj);
		                            });
		                            
		                            jQuery('.wng_text').append(tr);
                            	}
	                            
	                            dfd.resolve(result.resultList);
	                            
	                            $(obj).next('.wng_text:hidden').slideDown("middle");
	                        }
	                    });
	                }
	               , maskingMobile:function(hp) {
	                    var pattern = /^(\d{3})-?(\d{2,3})\d{1}-?(\d{1,2})\d{2}$/;
	                    var result = "";
	                    if(!hp) return result;
	         
	                    var match = pattern.exec(hp);
	                    if(match) {
	                        result = match[1]+"-"+match[2]+"*-"+match[3]+"**";
	                    } else {
	                        result = "***";
	                    }
	                    return result;
	                }
	                , maskingName:function(name) {
	                    var pattern = /.$/;
	                    return name.replace(pattern, "*");
	                }
	                , wngPopupIng:function(){
	                	jQuery('.wng_text').html('당첨 진행중입니다.');
	                }
		        }
	    	
	    	//이벤트 당첨자 내용 보기
	    	$(function () {
				$( ".wng_text" ).hide();	
				$( ".wng_title" ).click(function() {
					$(".wng_text:visible").slideUp("middle");
					/* $(this).next('.wng_text:hidden').slideDown("middle"); */
					return false;
				
				});
	    	});
		    
        </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    
    <div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			이벤트
		</div>
		<!-- 이벤트 당첨자 -->
		<h2 class="event_stit">
			<span>이벤트 당첨자 발표</span>
			<!-- <button type="button" class="btn_event_more">MORE</button> -->
		</h2>
		<form:form id="form_id_wng_search" commandName="wngSo">
        <form:hidden path="page" />
        <input type="hidden" name="eventCd" value="wng"/>
		<ul class="winner_list margin0">
			<c:forEach var="eventWngList" items="${eventWngList.resultList}" varStatus="status">
	        <%-- <input type="hidden" id="eventNo" name="eventNo" value="${eventWngList.eventNo}"/> --%>
		        <c:choose>
					<c:when test="${eventWngList.wngContentHtml ne null || eventWngList.eventCmntUseYn eq 'N'}">
						<li class="wng_title" onclick="EventUtil.wngPopup(${eventWngList.eventNo},'${eventWngList.eventCmntUseYn}',this)"><a href="#" onclick="return false;">${eventWngList.eventNm}
							<span class="date">
							${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
		                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
							</span>
							<button type="button" class="btn_view_winner" style="cursor: pointer;">결과확인</button></a>
						</li>
						<li class="wng_text"></li>
					</c:when>
					<c:otherwise>
						<li class="wng_title" onclick="EventUtil.wngPopup(${eventWngList.eventNo},'${eventWngList.eventCmntUseYn}', this)"><a href="#" onclick="return false;">${eventWngList.eventNm}
							<span class="date">
							${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
		                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
							</span>
							<button type="button" class="btn_view_winner ing" style="cursor: pointer;">당첨진행중</button></a>
						</li>
						<li class="wng_text"></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
            <c:if test="${eventWngList.resultList eq null}">
	            <li>
	            	이벤트 담청내역이 없습니다.
	            </li>
            </c:if>
		</ul>
		<div class="tPages" id="div_id_wng_paging">
			<grid:paging resultListModel="${eventWngList}" />
	    </div>
		</form:form>
		<!-- /이벤트 당첨자 -->
	</div>	

    </t:putAttribute>
</t:insertDefinition>