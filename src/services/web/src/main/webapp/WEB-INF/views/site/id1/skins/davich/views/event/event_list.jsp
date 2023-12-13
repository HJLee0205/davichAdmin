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
	<t:putAttribute name="title">다비치마켓 :: 이벤트</t:putAttribute>
	<t:putAttribute name="script">
	    <script type="text/javascript">
	        $(document).ready(function(){
	            $('#eventCommentWrite').hide();
	            EventUtil.memberNo = "${sessionMemberNo}";


	            //이벤트 슬라이드
	            //리스트가 3개이상이면 자동롤링 사용
	            var eventIngListSize = "${fn:length(eventIngList.resultList)}";
	            var autoFlag = false;
	            if(parseInt(eventIngListSize, 10) > 3) {
	                autoFlag = true;
	            }
	            var bxObj = $('.event_slider').bxSlider({
	                slideWidth: 255,
	                maxSlides: 3,
	                slideMargin: 16,
	                pager: false,
	                auto:autoFlag,
	                autoDelay:3000
                });

	            $('#ingTab').click(function(e){
                    e.preventDefault();
                    $('#form_id_ing_search').find('#page').val('1');
                    $('#form_id_ing_search').submit();
                    //bxObj.reloadSlider();
                    //$(".event_banner").css({'margin':'50px 0'});
                    //$("#eventCommentWrite").show();
                    //$("#eventBoard").show();
                });

	            $('#closeTab').click(function(e){
                    e.preventDefault();
                    $('#form_id_close_search').find('#page').val('1');
                    $('#form_id_close_search').submit();
                });

	            $('#wngTab').click(function(e){
                    e.preventDefault();
                    $('#form_id_wng_search').find('#page').val('1');
                    $('#form_id_wng_search').submit();
                });
   
	            //자동 탭선택
	            EventUtil.tabControl("${so.eventCd}");

	            //페이징
	            jQuery('#form_id_ing_search').grid(jQuery('#form_id_ing_search'));
	            jQuery('#div_id_close_paging').grid(jQuery('#form_id_close_search'));
	            jQuery('#div_id_wng_paging').grid(jQuery('#form_id_wng_search'));
            });

	       
	        //이벤트 상세내용
	        var EventUtil = {
	            eventNo:0
	            , memberNo:0
	            , deleteFlag:false
                , view:function(eventNo) {
                    EventUtil.getEvent(eventNo);
                }              
                , tabControl:function(eventCd) {
                	if(eventCd === 'ing') {
                        $("#tab1").addClass('active');
                        $("#tab2").removeClass('active');
                        $("#tab3").removeClass('active');
                        $("#tab01").fadeIn();
                        $("#tab02").hide();
                        $("#tab03").hide();
                    } else if(eventCd === 'close') {
                        $("#tab1").removeClass('active');
                        $("#tab2").removeClass('active');
                        $("#tab3").addClass('active');
                        $("#tab01").hide();
                        $("#tab02").hide();
                        $("#tab03").fadeIn();
                    } else if(eventCd === 'wng') {
                        $("#tab1").removeClass('active');
                        $("#tab2").addClass('active');
                        $("#tab3").removeClass('active');
                        $("#tab01").hide();
                        $("#tab02").fadeIn();
                        $("#tab03").hide();
                    }
                }
                , wngPopup:function(eventNo, wngYn, wngCnt) {
                	
                	jQuery('#popupListView').html('');
                	
                	var url = '/front/event/event-winning-info',dfd = jQuery.Deferred();
                    var param = {eventNo:eventNo, wngYn:wngYn};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
      
                    	jQuery('#popupListView').html('');
                    	
                    	$('#popupEventTitle').text(result.data.eventNm);
                        $('#popupEventDttm').text('이벤트 기간:'+result.data.applyStartDttm.substring(0,10)
                                +' ~ '+result.data.applyEndDttm.substring(0,10));
                        
                    	var wngNmHtml = '';
                        var wngContentHtml = '';
                        if(result.data.wngNm != null) {
                            wngNmHtml = '<div>'+result.data.wngNm+'</div>';
                        }
                        if(result.data.wngContentHtml != null) {
                            wngContentHtml = '<div>'+result.data.wngContentHtml+'</div>';
                        }
                        $('#popupListView').append(''+wngNmHtml + wngContentHtml +'</li>');
                        $('#wngWrapper').find('div').each(function() {
                            $(this).find('img').css({'width':289+'px'});
                        });
                        dfd.resolve(result.data);
                    });
                    
                    
                    var url = '/front/event/event-winning-list',dfd = jQuery.Deferred();
                    var param = {eventNo:eventNo, wngYn:wngYn};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){

                           if(wngYn != null && wngYn != '' && wngYn == 'Y'){
	                           var template =
	                           //'<li>{{mobile}} / {{memberNm}}</li>',
	                           '<li>{{memberNm}}({{mobile}})</li>',
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
	                            jQuery('#popupListView').append(tr);
                           	}
                            //Dmall.LayerPopupUtil.open(($('#popupWinner')));
                        }
                    });
                }
                , pagingCallBack:function() {
                    EventUtil.getLettList(EventUtil.eventNo);
                }
                , maskingMobile:function(hp) {
                    var pattern = /^(\d{3})-?(\d{2,3})\d{1}-?(\d{1,2})\d{2}$/;
                    var result = "";
                    if(!hp) {
                        result = "*";
                        return result;
                    }

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
	        }
            function detailEvent(eventNo, eventStatus){
                var eventNo = eventNo;
                var eventCd = eventStatus;
                Dmall.FormUtil.submit('/front/event/event-detail?eventNo='+eventNo,  {eventNo : eventNo, eventCd : eventCd});      
            }
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">
        <!--- category header 카테고리 location과 동일 --->
        <!--div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>이벤트
            </div>
        </div-->
        <!---// category header --->
		<div class="event_head">
			<h2 class="event_tit">이벤트</h2>
		</div>

		<ul class="event_tabs">
			<li class="active" style="width:235px" rel="tab01" id="tab1">진행중인 이벤트</li>
			<li rel="tab02" style="width:235px" id="tab2">당첨자 발표</li>
			<li rel="tab03" style="width:235px" id="tab3">지난 이벤트</li>
		</ul>
		
		<!-- tab01:진행중인 이벤트 -->
		<div class="event_tab_content" id="tab01">
        <form:form id="form_id_ing_search" commandName="ingSo">
        <form:hidden path="page" />
        <input type="hidden" name="eventCd" value="ing"/>
		<ul class="event_list">
			<c:choose>
                <c:when test="${fn:length(eventIngList.resultList) eq 0}">
                   <li class="textC" colspan="5"><p class="no_blank">진행중인 이벤트가 없습니다.</p></li>
                </c:when>
                <c:otherwise>
                <c:forEach var="eventIngList" items="${eventIngList.resultList}" varStatus="status">
                	<li>
                	<form:form id="form_id_search" commandName="ingSo">
                	<form:hidden path="eventNo" id="eventNo"/>
					<a href="javascript:detailEvent(${eventIngList.eventNo},'ing');">
						<img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventIngList.eventWebBannerImgPath}&id1=${eventIngList.eventWebBannerImg}" alt="${eventIngList.eventNm}">
						<p class="tit">${eventIngList.eventNm}</p>
						<span class="date">
							${fn:substring(eventIngList.applyStartDttm, 0, 10)}
                            ~ ${fn:substring(eventIngList.applyEndDttm, 0, 10)}
						</span>
					</a>
					</form:form>
					</li>                   
                    </c:forEach>
                </c:otherwise>
            </c:choose>           
        </ul>
		<!-- pageing -->
        <div class="tPages" id="div_id_ing_paging">
            <grid:paging resultListModel="${eventIngList}" />
        </div>
		<!--// pageing -->
		</form:form>
		</div>
		<!--// tab01:진행중인 이벤트 -->

		<!-- tab02:당첨자 발표 -->
		<div class="event_tab_content" id="tab02">
		<form:form id="form_id_wng_search" commandName="wngSo">
        <form:hidden path="page" />
        <input type="hidden" name="eventCd" value="wng"/>
			<table class="tProduct_Board event">
				<caption>
					<h1 class="blind">당첨자 발표 게시판 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="">
					<col style="width:218px">
					<col style="width:144px">
					<col style="width:144px">
				</colgroup>
				<thead>
					<tr>
						<th>이벤트명</th>
						<th>이벤트 기간</th>
						<th>당첨자발표일</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
	                <c:choose>
	                    <c:when test="${fn:length(eventWngList.resultList) eq 0}">
	                        <tr><td class="textC" colspan="5"><p class="no_blank">당첨자 발표 내역이 없습니다.</p></td></tr>
	                    </c:when>
	                    <c:otherwise>
	                        <c:forEach var="eventWngList" items="${eventWngList.resultList}" varStatus="status">
	                         <tr>
	                             <td>
	                                 ${eventWngList.eventNm}
	                             </td>
	                             <td class="textC">
	                                ${fn:substring(eventWngList.applyStartDttm, 0, 10)}
	                                ~ ${fn:substring(eventWngList.applyEndDttm, 0, 10)}
	                              </td>
	                             <td class="textC">${fn:substring(eventWngList.eventWngDttm, 0, 10)}</td>
	                             <td class="textC">
	                                <c:choose>
	                                    <c:when test="${eventWngList.wngContentHtml ne null || eventWngList.eventCmntUseYn eq 'N'}">
	                                        <button type="button" class="btn_view_winner" onclick="EventUtil.wngPopup(${eventWngList.eventNo},'${eventWngList.eventCmntUseYn}','${eventWngList.wngCnt}')">결과확인</button>
	                                    </c:when>
	                                    <c:otherwise>당첨 진행중</c:otherwise>
	                                </c:choose>
	                             </td>
	                         </tr>
	                        </c:forEach>
	                    </c:otherwise>
	                </c:choose>
	            </tbody>
			</table>
			<!-- pageing -->
            <c:if test="${fn:length(eventWngList.resultList) > 0}">
                <div class="tPages" id="div_id_wng_paging">
                     <grid:paging resultListModel="${eventWngList}" />
                 </div>
            </c:if>
			<!--// pageing -->
			</form:form>
		</div>
		<!--// tab02:당첨자 발표 -->

		<!-- tab03:지난 이벤트 -->
		<div class="event_tab_content" id="tab03">
			<form:form id="form_id_close_search" commandName="closeSo">
                <form:hidden path="page" id="page" />
                <input type="hidden" name="eventCd" value="close"/>
<!-- 	            <ul class="event_list last"> --><!--class에 last추가 시 페이징이 우측에 붙음  -->
	            <ul class="event_list last">
                <c:choose>
                    <c:when test="${fn:length(eventCloseList.resultList) eq 0}">
                        <div class="textC" style="margin-top:45px"><p class="no_blank">지난 이벤트가 없습니다.</p></div>
                    </c:when>
                    <c:otherwise>
                            <c:forEach var="eventCloseList" items="${eventCloseList.resultList}" varStatus="status">
                                <li>
                                	<span class="label_end">종료된 이벤트입니다</span>
									<a href="javascript:detailEvent(${eventCloseList.eventNo},'close');">
										<img src="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventCloseList.eventWebBannerImgPath}&id1=${eventCloseList.eventWebBannerImg}" alt="${eventCloseList.eventNm}">
										<p class="tit">${eventCloseList.eventNm}</p>
										<span class="date">종료된 이벤트입니다</span>
									</a>									
                                </li>
                            </c:forEach>                            
                    </c:otherwise>
                </c:choose>
                </ul>
               <!---- pageing ---->
                <div class="tPages" id="div_id_close_paging">
                    <grid:paging resultListModel="${eventCloseList}" />
                </div>
               <!----// pageing ---->
                </form:form>
		</div>
		<!--// tab03:지난 이벤트 -->
	</div>
    <!---// 02.LAYOUT: 카테고리 메인 --->
    <!-- popup -->
	<div class="popup" id="popupWinner" style="display:none;">
		<div class="inner event">
			<div class="popup_head">
				<h1 class="tit">이벤트 결과 확인</h1>
				<button type="button" class="btn_close_popup">창닫기</button>
			</div>
			<div class="popup_body"> 
				<div class="event_result_head">
					<p id="popupEventTitle" class="tit"></p>
					<p id="popupEventDttm" class="tit_ymd"></p>
				</div>
				<div class="popup_event_outline">				
					<div class="winner_tit">"당첨을 축하드립니다."</div>	
					<div id="popupWinnerList" class="winner_list_area">
						<ul id="popupListView" class="list_view">							
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--// popup -->
    </t:putAttribute>
</t:insertDefinition>