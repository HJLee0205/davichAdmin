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
<t:insertDefinition name="defaultLayout">
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
		    		wngPopup:function(eventNo) {
		    			jQuery('.wng_text').html('');
		    			
	                    var url = '${_MOBILE_PATH}/front/event/event-winning-list',dfd = jQuery.Deferred();
	                    var param = {eventNo:eventNo, wngYn:'Y'}

	                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
	                        if(result.success){
	                        	var template =
		                        	'{{mobile}} / {{memberNm}}<br>',
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
		                                        obj[key] = EventUtil.maskingName(obj[key]);
		                                    }
		                                }
		                                tr += managerGroup.render(obj);
		                            });
		                            
		                            jQuery('.wng_text').html(tr);
		                            var wngNmHtml = '';
		                            var wngContentHtml = '';
		                            if(result.resultList[0].wngNm != null) {
		                                wngNmHtml = '<div>'+result.resultList[0].wngNm+'</div>';
		                            }
		                            if(result.resultList[0].wngContentHtml != null) {
		                                wngContentHtml = '<div>'+result.resultList[0].wngContentHtml+'</div>';
		                            }
		                            $('.wng_text').prepend('<span id="wngWrapper" class="tit">'+wngNmHtml + wngContentHtml +'</span><br>');
		                            $('#wngWrapper').find('div').each(function() {
		                                $(this).find('img').css({'width':289+'px'});
		                            });
		                            dfd.resolve(result.resultList);
	                        } else {
	                        	tr = '데이터가 없습니다.';
	                        	jQuery('.wng_text').html(tr);
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
					$(this).next('.wng_text:hidden').slideDown("middle");
					return false;
				
				});
	    	});
		    
        </script>
	</t:putAttribute>
	
    <t:putAttribute name="content">
    
    <div id="middle_area">
		<div class="event_head">
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
		<ul class="winner_list">
			<c:forEach var="eventWngList" items="${eventWngList.resultList}" varStatus="status">
	        <%-- <input type="hidden" id="eventNo" name="eventNo" value="${eventWngList.eventNo}"/> --%>
			<c:if test="${eventWngList.wngCnt > 0}">
				<li class="wng_title" onclick="EventUtil.wngPopup(${eventWngList.eventNo})" style="cursor: pointer;">
					<div class="winner_ellipsis" style="width:auto;max-width:90%">
						${eventWngList.eventNm}
					</div>					 
					<!-- <span class="winner_new">NEW</span> -->
					<span class="winner_date">
						${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
	                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
	                </span>
				</li>
				<li class="wng_text" style="background:#f3f4f4 url(../img/product/dotline_01.png) repeat-x left top">
				</li>
			</c:if>
			<c:if test="${eventWngList.wngCnt eq 0}">
				<li class="wng_title" onclick="EventUtil.wngPopupIng()" style="cursor: pointer;">
					<div class="winner_ellipsis" style="width:auto;max-width:90%">
						${eventWngList.eventNm}
					</div>					 
					<!-- <span class="winner_new">NEW</span> -->
					<span class="winner_date">
						${fn:substring(eventWngList.applyStartDttm, 0, 10)} 
	                     ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
	                </span>
				</li>
				<li class="wng_text" style="background:#f3f4f4 url(../img/product/dotline_01.png) repeat-x left top">
					당첨자 발표 진행중입니다.					
				</li>
			</c:if>
			</c:forEach>
		</ul>
		<div class="tPages" id="div_id_wng_paging">
			<grid:paging resultListModel="${eventWngList}" />
	    </div>
		</form:form>
		<!-- /이벤트 당첨자 -->
	</div>	

    </t:putAttribute>
</t:insertDefinition>