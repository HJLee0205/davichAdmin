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
	<t:putAttribute name="title">${bbsInfo.data.bbsNm}</t:putAttribute>


	<t:putAttribute name="script">
	    <script type="text/javascript">
	        $(document).ready(function(){
	            $('#eventCommentWrite').hide();
	            EventUtil.memberNo = "${sessionMemberNo}";

	            //첫번째 이벤트 상세내용 호출
	            EventUtil.view();

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
                    bxObj.reloadSlider();
                    $(".event_banner").css({'margin':'50px 0'});
                    $("#eventCommentWrite").show();
                    $("#eventBoard").show();
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

	            //이벤트 댓글 등록
	            $('#btnInsertEventLett').on('click', function(e) {
	                EventUtil.insertEventLett(e);
	            });

	            //비회원 댓글쓰기 방지
	            $('textarea').keydown(function(){
	                var text =$('textarea').val();
                    var byteTxt = "";
                    var byte = function(str){
                        var byteNum=0;
                        for(i=0;i<str.length;i++){
                            byteNum+=(str.charCodeAt(i)>127)?2:1;
                            if(byteNum<600){
                                byteTxt+=str.charAt(i);
                            };
                        };
                        return byteNum;
                    };

	                if(byte(text) > 0 && (EventUtil.memberNo === '' || EventUtil.memberNo === 0)) {
	                    //textarea에 계속입력하면 레이어를 무한정 오픈되기때문에 막아놓는다.
	                    $('textarea').prop('disabled', true);
	                    Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
	                        //확인버튼 클릭
                            function() {
                                location.href = '/front/login/member-login';
                            }
	                        //취소버튼 클릭
	                        , function() {
	                            $('textarea').prop('disabled', false);
                            })
                    }
	            });

	            //자동 탭선택
	            EventUtil.tabControl("${so.eventCd}");

	            //페이징
	            jQuery('#div_id_close_paging').grid(jQuery('#form_id_close_search'));
	            jQuery('#div_id_wng_paging').grid(jQuery('#form_id_wng_search'));
            });

	        //글자수(byte) 체크
            $(function(){
                function updateInputCount() {
                    var text =$('textarea').val();
                    var byteTxt = "";
                    var byte = function(str){
                        var byteNum=0;
                        for(i=0;i<str.length;i++){
                            byteNum+=(str.charCodeAt(i)>127)?2:1;
                            if(byteNum<600){
                                byteTxt+=str.charAt(i);
                            };
                        };
                        return byteNum;
                    };
                    $('#inputCnt').text(byte(text));
                }

                $('textarea')
                    .focus(updateInputCount)
                    .blur(updateInputCount)
                    .keypress(updateInputCount);
                    window.setInterval(updateInputCount,100);
                    //updateInputCount();
            });

	        //이벤트 상세내용
	        var EventUtil = {
	            eventNo:0
	            , memberNo:0
	            , deleteFlag:false
                , view:function(eventNo) {
                    EventUtil.getEvent(eventNo);
                }
                , getEvent:function(eventNo) {
                    var url = '/front/event/event-detail',dfd = jQuery.Deferred();;

                    //최초 이벤트 페이지 접속시 첫번째 이벤트 상세 내용을 불러온다.
                    if(typeof eventNo === 'undefined') {
                        eventNo = "${eventIngList.resultList[0].eventNo}";
                    }

                    //전의 이벤트 번호의 현재의 이벤트 번호가 다르다면 새이벤트 조회이므로 page를 1로 초기화한다.
                    if(EventUtil.eventNo !== eventNo) {
                        $('#ingPage').val(1);
                    }

                    //현재진행중인 이벤트 페이징이벤트 발생시 현재 이벤트페이지를 유지하기위한 변수
                    EventUtil.eventNo = eventNo;

                    var param = {eventNo: eventNo}
                    var eventIngListLength = $('#eventIngListLength').val();
                    if(eventIngListLength > 0) {
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            result.data.applyStartDttm =
                                result.data.applyStartDttm.substring(0,4)
                                +'-'+result.data.applyStartDttm.substring(4,6)
                                +'-'+result.data.applyStartDttm.substring(6,8);

                            result.data.applyEndDttm =
                                result.data.applyEndDttm.substring(0,4)
                                +'-'+result.data.applyEndDttm.substring(4,6)
                                +'-'+result.data.applyEndDttm.substring(6,8);

                            var template =
                            '<tr>'+
                                '<th>이벤트명</th>'+
                                '<td colspan="3">{{eventNm}}</td>'+
                            '</tr>'+
                            '<tr>'+
                                '<th>이벤트기간</th>'+
                                '<td>{{applyStartDttm}} ~ {{applyEndDttm}}</td>'+
                                '<th>게시일</th>'+
                                '<td>{{regDttm}}</td>'+
                            '</tr>'+
                            '<tr>'+
                                '<td colspan="4" class="event_con">'+
                                    '{{eventContentHtml}}'+
                                '</td>'+
                            '</tr>',
                            viewEvent = new Dmall.Template(template);
                            $('#id_view_event').html(viewEvent.render(result.data));
                            //이벤트 댓글 등록시 필요한 이벤트번호
                            $('#formEventNo').val(result.data.eventNo);
                            dfd.resolve(result.data);

                            //이벤트 댓글 호출
                            result.data.eventCmntUseYn === 'Y' ? EventUtil.getLettList(eventNo) : $('#eventCommentWrite').hide();
                        });
                    }

                    return dfd.promise();
                }
                , getLettList:function(eventNo) {
                    $('#eventCommentWrite').show();
                    var url = '/front/event/event-comment-list',dfd = jQuery.Deferred();

                    //최초 페이지 접속시 1로 설정
                    var pageNum = 1;

                    //1번이상 페이지로 이동시 페이지번호 설정
                    if($('#ingPage').val() !== '') {
                        pageNum = $('#ingPage').val();
                    }

                    //댓글 삭제를 했다면 무조건 1페이지로 이동하고 페이지번호 초기화
                    if(EventUtil.deleteFlag === true) {
                        pageNum = 1;
                        $('#ingPage').val(1);
                        EventUtil.deleteFlag = false;
                    }

                    var param = {eventNo: eventNo, page:pageNum};

                    Dmall.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        var template =
                        '<div class="event_comment_view">'+
                            '<div class="event_comment_id">'+
                                '{{loginId}}'+
                            '</div>'+
                            '<div class="event_comment_text">'+
                                '{{content}}'+
                            '</div>'+
                            '<div class="event_comment_info">'+
                                '<div class="comment_info_date">'+
                                    '{{regLettDttm}}'+
                                '</div>'+
                                '<button type="button" data-member-no="{{memberNo}}" onclick="EventUtil.deleteEventLett({{lettNo}}, {{eventNo}})"><img src="../img/product/btn_reply_del.gif" alt="댓글삭제"></button>'+
                            '</div>'+
                        '</div>',
                            managerGroup = new Dmall.Template(template),
                                tr = '';
                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<div class="accordion-section"><a class="accordion-section-title">댓글이 없습니다.</a></div>';
                        }
                        jQuery('#eventCommentList').html(tr);
                        dfd.resolve(result.resultList);

                        //현재진행중 이벤트 페이징처리
                        Dmall.GridUtil.appendPaging('form_id_ing_search', 'div_id_ing_paging', result, 'paging_id_ing_eventLett', EventUtil.pagingCallBack);
                        $("#a").text(result.filterdRows);
                        $("#b").text(result.totalRows);

                        //이벤트 상세내용이 호출된후 본인의 댓글 삭제버튼만 보이도록 호출
                        EventUtil.btnHide();
                    });


                    return dfd.promise();
                }
                , insertEventLett:function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    if(parseInt($('#inputCnt').text(), 10) === 0) {
                        Dmall.LayerUtil.alert('내용을 입력해 주십시요.','','');
                        $('textarea').focus();
                        return;
                    }

                    var url = '/front/event/event-comment-insert';
                    var param = $('#form_id_insert').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            $('textarea').text('');
                            EventUtil.getLettList(result.data.eventNo);
                        }
                    });
                }
                , deleteEventLett:function(lettNo, eventNo) {
                    Dmall.LayerUtil.confirm("삭제하시겠습니까?",
                        function() {
                            var url = '/front/event/event-comment-delete';
                            var param = {lettNo:lettNo};

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                //validate.viewExceptionMessage(result, 'form_id_cmntinsert');
                                if(result.success){
                                    EventUtil.getLettList(eventNo);
                                }
                        });
                    })
                    EventUtil.deleteFlag = true;
                }
                , btnHide:function() {
                    $('#eventCommentList .event_comment_view').each(function() {
                        var dataMemberNo = parseInt($(this).find('button').attr('data-member-no'), 10);
                        var sessionMemberNo = parseInt(EventUtil.memberNo, 10) || 0;
                        if(sessionMemberNo !== dataMemberNo) {
                            $(this).find('button').hide();
                        }
                    });
                }
                , tabControl:function(eventCd) {
                    if(eventCd === 'close') {
                        /* $(".event_banner").css({'margin':0});
                        $(".event_slider").hide();
                        $("#eventCommentWrite").hide();
                        $("#eventBoard").hide(); */
                        $("#tab1").hide();
                        $("#tab2").fadeIn();
                        $("#tab3").hide();
                    } else if(eventCd === 'wng') {
                        /* $(".event_banner").css({'margin':0});
                        $(".event_slider").hide();
                        $("#eventCommentWrite").hide();
                        $("#eventBoard").hide(); */
                        $("#tab1").hide();
                        $("#tab2").hide();
                        $("#tab3").fadeIn();
                    }
                }
                , wngPopup:function(eventNo) {
                    var url = '/front/event/event-winning-list',dfd = jQuery.Deferred();
                    var param = {eventNo:eventNo, wngYn:'Y'}

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                           $('#popupEventTitle').text(result.resultList[0].eventNm);
                           $('#popupEventDttm').text('이벤트 기간:'+result.resultList[0].applyStartDttm.substring(0,10)
                                   +' ~ '+result.resultList[0].applyEndDttm.substring(0,10));

                           var template =
                           '<li>{{mobile}} / {{memberNm}}</li>',
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

                            jQuery('#popupListView').html(tr);

                            var wngNmHtml = '';
                            var wngContentHtml = '';
                            if(result.resultList[0].wngNm != null) {
                                wngNmHtml = '<div>'+result.resultList[0].wngNm+'</div>';
                            }
                            if(result.resultList[0].wngContentHtml != null) {
                                wngContentHtml = '<div>'+result.resultList[0].wngContentHtml+'</div>';
                            }
                            $('#popupListView').prepend('<li id="wngWrapper" class="tit">'+wngNmHtml + wngContentHtml +'</li>');
                            $('#wngWrapper').find('div').each(function() {
                                $(this).find('img').css({'width':289+'px'});
                            });
                            dfd.resolve(result.resultList);
                            Dmall.LayerPopupUtil.open(($('#popupWinner')));
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
        </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents fixwid">
            <!--- category header 카테고리 location과 동일 --->
            <div id="category_header">
                <div id="category_location">
                    <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>이벤트
                </div>
            </div>
            <!---// category header --->
            <h2 class="sub_title">이벤트<span>믿을수 있는 쇼핑! 더 안전한 쇼핑!</span></h2>
            <ul class="tabs">
                <li rel="tab1" <c:if test="${so.eventCd eq 'ing'}">class="active"</c:if> id="ingTab" style="width:33%">진행중인 이벤트</li>
                <li rel="tab2" <c:if test="${so.eventCd eq 'close'}">class="active"</c:if> id="closeTab" style="width:33.4%">지난 이벤트</li>
                <li rel="tab3" <c:if test="${so.eventCd eq 'wng'}">class="active"</c:if> id="wngTab" style="width:33%">당첨자 발표</li>
            </ul>

            <!--- tab01: 진행중인 이벤트 영역 --->
            <div class="tab_content" id="tab1">
                <input type="hidden" id="eventIngListLength" value="${fn:length(eventIngList.resultList)}"/>
                <form id="form_id_ing_search" action="/front/event/event-comment-list">
                    <input type="hidden" name="page" id="ingPage" />
                </form>
                <div class="event_banner">
                    <c:choose>
                        <c:when test="${fn:length(eventIngList.resultList) eq 0}">
                            <div class="textC"><p class="no_blank">진행중인 이벤트가 없습니다.</p></div>
                        </c:when>
                        <c:otherwise>
                            <ul class="event_slider">
                                <c:forEach var="eventIngList" items="${eventIngList.resultList}" varStatus="status">
                                    <li onclick="EventUtil.view('${eventIngList.eventNo}');">
                                        <img src="/image/image-view?type=EVENT&path=${eventIngList.eventWebBannerImgPath}&id1=${eventIngList.eventWebBannerImg}" alt="${eventIngList.eventNm}">
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>

                <table id="eventBoard" class="tEvent_Board">
                    <caption>
                        <h1 class="blind">진행중 이벤트 게시판 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:130px">
                        <col style="width:">
                        <col style="width:130px">
                        <col style="width:130px">
                    </colgroup>
                    <tbody id="id_view_event"></tbody>
                </table>

                <!--- event comment 쓰기 --->
                <div class="event_comment_write" id="eventCommentWrite">
                    <div class="event_comment_warning">* 주제와 무관한 댓글, 악플은 삭제될 수 있습니다.</div>
                    <div class="event_comment_form">
                        <label for="event_comment_write"><span id="inputCnt">0</span>/300</label>
                        <form:form id="form_id_insert">
                            <input type="hidden" name="eventNo" id="formEventNo" />
                            <textarea id="event_comment_write" name="content"></textarea>
                        </form:form>
                        <button type="button" class="btn_event_comment" id="btnInsertEventLett">등록</button>
                    </div>
                    <div class="event_comment_list">
                        <div id="eventCommentList"></div>
                        <!---- 페이징 ---->
                        <div class="tPages" id="div_id_ing_paging"></div>
                        <!----// 페이징 ---->
                    </div>
                </div>
                <!---// comment 쓰기 --->
            </div>
            <!---// tab01: 진행중인 이벤트 영역 --->
            <!--- tab02: 지난 이벤트 영역 --->
            <div class="tab_content" id="tab2">
                <form:form id="form_id_close_search" commandName="closeSo">
                <form:hidden path="page" id="page" />
                <input type="hidden" name="eventCd" value="close"/>

                <c:choose>
                    <c:when test="${fn:length(eventCloseList.resultList) eq 0}">
                        <div class="textC" style="margin-top:45px"><p class="no_blank">지난 이벤트가 없습니다.</p></div>
                    </c:when>
                    <c:otherwise>
                        <ul class="end_event_list">
                            <c:forEach var="eventCloseList" items="${eventCloseList.resultList}" varStatus="status">
                                <li>
                                    <dl class="end_event_info">
                                        <dt>
                                           <img src="/image/image-view?type=EVENT&path=${eventCloseList.eventWebBannerImgPath}&id1=${eventCloseList.eventWebBannerImg}" alt="${eventCloseList.eventNm}">
                                        </dt>
                                        <dd>
                                            <h4 class="event_stit">${eventCloseList.eventNm}</h4>
                                            <span class="end_event_date">이벤트 기간 : ${eventCloseList.applyStartDttm} ~ ${eventCloseList.applyEndDttm}</span>
                                            <c:if test="${eventCloseList.wngCnt > 0}">
                                                <button type="button" class="btn_event_winner" onclick="EventUtil.wngPopup(${eventCloseList.eventNo})">당첨자발표</button>
                                            </c:if>
                                        </dd>
                                    </dl>
                                </li>
                            </c:forEach>
                            <c:if test="${fn:length(eventCloseList.resultList)%2 == 1}">
                                <li>
                                    <dl class="end_event_info">
                                        <dt>
                                        </dt>
                                        <dd>
                                        </dd>
                                    </dl>
                                </li>
                            </c:if>
                        </ul>

                        <!---- 페이징 ---->
                        <div class="tPages" id="div_id_close_paging">
                            <grid:paging resultListModel="${eventCloseList}" />
                        </div>
                       <!----// 페이징 ---->
                    </c:otherwise>
                </c:choose>
                </form:form>
            </div>
            <!---// tab02: 지난 이벤트 영역 --->

            <!--- tab03: 당첨자 발표 --->
           <div class="tab_content" id="tab3">
                <form:form id="form_id_wng_search" commandName="wngSo">
                    <form:hidden path="page" />
                    <input type="hidden" name="eventCd" value="wng"/>
                    <!-- 스토리보드에서 당첨자발표 검색은 제외한다고 하였으나 혹시 몰라서 주석처리 -->
                    <!-- <div class="table_top">
                        <div class="select_box28" style="width:100px;display:inline-block">
                            <label for="select_option">전체</label>
                            <select id="select_option" title="select option">
                                <option selected="selected">1</option>
                                <option>2</option>
                            </select>
                        </div>
                        <input type="text" id="event_search"><button type="button" id="event_search"></button>
                    </div> -->
                    <table class="tEventWinner_Board">
                        <caption>
                            <h1 class="blind">당첨자 발표 게시판 목록입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:76px">
                            <col style="width:">
                            <col style="width:220px">
                            <col style="width:130px">
                            <col style="width:130px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>이벤트명</th>
                                <th>이벤트 기간</th>
                                <th>당첨자발표일</th>
                                <th>당첨 결과확인</th>
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
                                         <td class="textC">${eventWngList.rowNum}</td>
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
                                                <c:when test="${eventWngList.wngCnt > 0}">
                                                    <button type="button" class="btn_event_winner_check" onclick="EventUtil.wngPopup(${eventWngList.eventNo})">확인</button>
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
                    <c:if test="${fn:length(eventWngList.resultList) > 0}">
                        <!---- 페이징 ---->
                        <div class="tPages" id="div_id_wng_paging">
                             <grid:paging resultListModel="${eventWngList}" />
                         </div>
                        <!----// 페이징 ---->
                    </c:if>
                </form:form>
            </div>
            <!---// tab03: 당첨자 발표 --->
        </div>
        <!---// 진행중인 이벤트 --->
        <!--- popup 당첨자발표(eventList.jsp페이지에서만 사용하기때문에 따로 파일로 빼지 않았습니다.) --->
        <div id="popupWinner" class="popup_winner blind">
            <div class="popup_header">
                <h1 class="popup_tit">당첨자발표</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_winner_list_tit">
                    <h4 id="popupEventTitle" class="popup_winner_list_stit"></h4>
                    <span id="popupEventDttm"></span>
                </div>
                <div id="popupWinnerList" class="popup_winner_list">
                    <ul id="popupListView" class="list_view">

                    </ul>
                </div>
            </div>
        </div>
        <!---// popup 당첨자발표 --->
    </t:putAttribute>
</t:insertDefinition>