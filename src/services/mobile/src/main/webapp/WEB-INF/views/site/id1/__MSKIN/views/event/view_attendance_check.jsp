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
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">${bbsInfo.data.bbsNm}</t:putAttribute>
    
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <link rel="stylesheet" type="text/css" href="${_MOBILE_PATH}/front/css/fullcalendar.print.css" media='print'/>
        <script src="${_MOBILE_PATH}/front/js/moment.min.js" charset="utf-8"></script>
        <script src="${_MOBILE_PATH}/front/js/fullcalendar.js" charset="utf-8"></script>
        <script type="text/javascript">

            $(document).ready(function(){                
                //출석체크 이벤트 달력
                var checkData = "";
                var ingYn = true; //진행여부
                var today = new Date().format('yyyy-MM-dd');
                $('#calendar').fullCalendar({
                    contentHeight: 563,
                    header: {
                        left:'prev',
                        center: 'title',
                        right:'next',
                    },
					firstDay: 1,
                    monthNames: [" 1"," 2"," 3"," 4"," 5"," 6"," 7"," 8"," 9"," 10"," 11"," 12"],
                    editable: true,
                    events: function(start, end, timezone, callback) {
                        
                        //출석정보 조회
                        var url = '${_MOBILE_PATH}/front/event/attendance-info';
                        var stRegDttm = "${event.data.applyStartDttm}";
                        var endRegDttm = "${event.data.applyEndDttm}";
                        stRegDttm = stRegDttm.substr(0,8);
                        endRegDttm = endRegDttm.substr(0,8);
                        var param = {eventNo:"${so.eventNo}", memberNo:"${details.session.memberNo}", stRegDttm:stRegDttm, endRegDttm:endRegDttm};
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                var attendanceList = result.extraData.list
                                $.each(attendanceList,function(idx,obj){ 
                                    checkData += attendanceList[idx].attendanceDay +",";
                                });
                                
                                //이벤트 기간 반복
                                var sDate = parseDate('${event.data.applyStartDttm}');
                                var eDate = parseDate('${event.data.applyEndDttm}');
                                if(sDate.format('yyyy-MM-dd') <= today && eDate.format('yyyy-MM-dd') >= today) {
                                    ingYn = true;
                                } else {
                                    ingYn = false;
                                }
                                
                                var btMs = eDate.getTime() - sDate.getTime();;
                                var btDay = btMs / (1000*60*60*24); //이벤트 기간 일수
                                var dayOfMonth = sDate.getDate();
                                var events = [];
                                events.push({
                                    start: sDate.format('yyyy-MM-dd'),
                                    end : eDate.format('yyyy-MM-dd'),
                                    backgroundColor:'none',
                                    rendering:'background'
                                })
                                for(var i=0; i<=btDay; i++) {
                                    sDate.setDate(dayOfMonth);
                                    
                                    //출석 정보 비교
                                    var day = sDate.format('yyyy-MM-dd');
                                    var dayOfWeek = new Date(day).getDay()
                                    if(sDate <= new Date()) {
                                    	var classNm = "view_nocheck";
                                    	var title = "";
	                                    if (checkData.indexOf(day) > -1) {
	                                        classNm = "view_checkin";
	                                        title = "50";
	                                        switch(dayOfWeek) {
	                                        	case 1 : title = "50"; break;
	                                        	case 2 : title = "100"; break;
	                                        	case 3 : title = "150"; break;
	                                        	case 4 : title = "200"; break;
	                                        	case 5 : title = "500"; break;
	                                        	default : title = "50"; break;
	                                        }
	                                    }
	                                    
	                                    //달력 이벤트 추가
	                                    events.push({
	                                        id: 'checkin'+i,
	                                        title:title,
	                                        start: sDate.format('yyyy-MM-dd'),
	                                        className:[classNm]
	                                    });
                                    }
                                    dayOfMonth = sDate.getDate() + 1;
                                }
                                callback(events);
                                
                              	//출석체크 완료일때 
                                if(checkData.indexOf(today) > -1) {
                                	$('.fc-body').find('.fc-today').removeClass('fc-today');	
                                }
                            }
                        });
                    },
                    
                    dayClick : function(date, jsEvent, view){/* 날짜 클릭이벤트 */

                    	/* 로그인 여부 체크 */
                    	var loginYn = ${user.login};
                        if(!loginYn) {
                            Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                                //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                                function() {
                                    var returnUrl = window.location.pathname+window.location.search;
                                    location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                                }
                            );
                            return;
                        }
                    	
                        /* 진행중 이벤트인지 체크 */
                        if(!ingYn){
                            Dmall.LayerUtil.alert("진행중인 이벤트가 아닙니다.","","");
                            return;
                        }
                        
                        /* 날짜 체크 */
                    	/* var clickDate = date.format();
                    	if(clickDate != today){
                    		Dmall.LayerUtil.alert("금일 날짜를 선택해주세요.","","");
                    		return;
                    	} */
                    	
                        if(checkData.indexOf(today) > -1) {
                            Dmall.LayerUtil.alert("금일은 출석체크를 완료하였습니다.</br>다음에 다시 참여해주세요","","");
                            return;
                        }
                        
                        var url = '${_MOBILE_PATH}/front/event/attendance-check';
                        var param = {eventNo:"${so.eventNo}",memberNo:"${user.session.memberNo}"};

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                location.reload();
                            }
                        });
                        
                    }
                });

            });
            
            //ie11 Date객체 변환 문제 수정 스크립트
            /* function parseDate(strDate) {
                var _strDate = strDate;
                var _dateObj = new Date(strDate);
                if(_dateObj.toString() == 'Invalid Date') {
                    _strDate = _strDate.split('.').join('-');
                    _dateObj = new Date(_strDate);
                }
                if(_dateObj.toString() == 'Invalid Date') {
                    var _parts = _strDate.split(' ');
                    
                    var _dateParts = _parts[0];
                    _dateObj = new Date(_dateParts);
                    
                    if(_parts.length > 1) {
                        var _timeParts = _parts[1].split(':');
                        _dateObj.setHours(_timeParts[0]);
                        _dateObj.setMinutes(_timeParts[1]);
                        if(_timeParts.length > 2) {
                            _dateObj.setSeconds(_timeParts[2]);
                        }
                    }
                }
                return _dateObj;
            } */
            
         	// 페이스북 공유하기
            function jsShareFacebook() {
                var url = encodeURIComponent(document.location.href);
                url = url.replaceAll('%2Fm', "")
                var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
                var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=10");
            }
            
            function parseDate(strDate) {
                var _strDate = strDate;
                var _year = _strDate.substring(0,4);
                var _month = _strDate.substring(4,6)-1;
                var _day = _strDate.substring(6,8);
                var _dateObj = new Date(_year,_month,_day);
                return _dateObj;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- middle_area --->
        <div id="middle_area">
			<div class="attend_top_box">
				<img src="${_SKIN_IMG_PATH}/event/attend_img01.png" alt="하루 1분! 매주 월요일 시작되는 출근도장 이벤트! 평일 연속 출석한 날만큼 50원씩 증정! 월~금 만근하시면 250원 추가증정! 매주 500원 증정!!">
			</div>
			<div class="attend_calendar_area">
				<!-- full calendar -->
				<div id='calendar'></div>
				<!--// full calendar -->
				<p class="attend_text"><img src="${_SKIN_IMG_PATH}/event/attend_btm_text.png" alt="해당일자를 '클릭'하면 자동으로 출근 처리가 됩니다.">
			</div>
			<div class="attend_facebook">
				<a href="javascript:jsShareFacebook();"><img src="${_SKIN_IMG_PATH}/event/attend_facebook.png" alt="페이스북으로 이벤트 공유하기"></a>
			</div>
			<div class="attend_btm_text">
				<p class="text_tit"><img src="${_SKIN_IMG_PATH}/event/attend_tit_event.png" alt="이벤트 내용"></p>
				<div class="inner_text">
					<img src="${_SKIN_IMG_PATH}/event/attend_event.png" alt="다비치마켓 로그인 후 출근도장만 찍어도 현금처럼 사용 가능한 마켓포인트 50원 매일 증정! 매주 월요일부터 금요일까지 5회 연속 출근시 금요일에 마켓포인트 2배 (250원) 추가 증정! 주말 방문시에도 하루 50원 증정~! 한주 동안 연속출석 한 일자만큼 마켓포인트가 지급됩니다.(주말별도)">
					<p><img src="${_SKIN_IMG_PATH}/event/attend_btm_img.png" alt="5일연속 250원 만근시 2배 500원, 3일 연속 150원 2일 연속 100원, 연속참여만 출근인정 "></p>
				</div>
			</div>
			<div class="attend_warning">
				<p class="warning_tit"><img src="${_SKIN_IMG_PATH}/event/icon_warning.png" alt="유의사항"></p>
				<div class="inner_text">
					<img src="${_SKIN_IMG_PATH}/event/attend_warning.png" alt="01.다비치마켓 홈페이지 혹은 다비치마켓 어플에서 1일 1회 참여 가능합니다. 02.월-금 5회 연속 출근에 실패하여 더블혜택을 못 받으셨을 경우 다음주에 재참여 가능합니다. 03.마켓포인트는 다비치마켓에서 현금처럼 사용 가능합니다. 04.이벤트로 지급된 마켓포인트 유효기간은 3개월입니다. 미사용 시 소멸되오니 참고 바랍니다. 05.출근도장 이벤트로 지급된 적립금은 미사용시 현금으로 환불되지 않습니다.">
				</div>
			</div>
        </div>
        <!---// middle_area --->
    </t:putAttribute>
</t:insertDefinition>