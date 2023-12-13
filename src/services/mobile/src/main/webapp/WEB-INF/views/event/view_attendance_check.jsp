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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${bbsInfo.data.bbsNm}</t:putAttribute>
    
    
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <link rel="stylesheet" type="text/css" href="/front/css/fullcalendar.css" />
        <link rel="stylesheet" type="text/css" href="/front/css/fullcalendar.print.css" media='print'/>
        <script src="/front/js/moment.min.js" charset="utf-8"></script>
        <script src="/front/js/fullcalendar.js" charset="utf-8"></script>
        <script type="text/javascript">

            $(document).ready(function(){
                $('.event_slider').bxSlider({
                    slideWidth: 255,
                    maxSlides: 3,
                    slideMargin: 16,
                    pager: false,
                });
                
                //출석체크 이벤트 달력
                var checkData = "";
                var today = new Date().format('yyyy-MM-dd');
                $('#calendar').fullCalendar({
                    contentHeight: 563,
                    header: {
                        left:'prev',
                        center: 'title',
                        right:'next',
                    },
                    monthNames: ["01","02","03","04","05","06","07","08","09","10","11","12"],
                    editable: true,
                    events: function(start, end, timezone, callback) {
                        
                        //출석정보 조회
                        var url = '/front/event/attendance-info';
                        var stRegDttm = "${event.data.applyStartDttm}";
                        var endRegDttm = "${event.data.applyEndDttm}";
                        stRegDttm = stRegDttm.substr(0,8);
                        endRegDttm = endRegDttm.substr(0,8);
                        var param = {eventNo:"${vo.eventNo}", memberNo:"${details.session.memberNo}", stRegDttm:stRegDttm, endRegDttm:endRegDttm};
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                var attendanceList = result.extraData.list
                                $.each(attendanceList,function(idx,obj){ 
                                    checkData += attendanceList[idx].attendanceDay +",";
                                });
                                
                                //이벤트 기간 반복
                                var sDate = parseDate('${event.data.applyStartDttm}');
                                var eDate = parseDate('${event.data.applyEndDttm}');
                                
                                var btMs = eDate.getTime() - sDate.getTime();;
                                var btDay = btMs / (1000*60*60*24); //이벤트 기간 일수
                                var dayOfMonth = sDate.getDate();
                                var events = [];
                                for(var i=0; i<=btDay; i++) {
                                    sDate.setDate(dayOfMonth);
                                    
                                    //출석 정보 비교
                                    var day = sDate.format('yyyy-MM-dd');
                                    var classNm = "view_nocheck";
                                    var title = "결석";
                                    if (checkData.indexOf(day) > -1) {
                                        classNm = "view_checkin";
                                        title = "출석";
                                    }
                                    //달력 이벤트 추가
                                    events.push({
                                        id: 'checkin'+i,
                                        title:title,
                                        start: sDate.format('yyyy-MM-dd'),
                                        className:[classNm]
                                    });
                                    dayOfMonth = sDate.getDate() + 1;
                                }
                                callback(events);
                            }
                        });
                    }
                });
                
                //출석 체크
                $('.btn_checkin').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var loginYn = ${user.login};
                    if(!loginYn) {
                        Dmall.LayerUtil.alert("로그인이 필요한 서비스 입니다..","","").done(function(){
                           //location.href = "/front/login/member-login";
                        });
                        return;
                    }
                    if(checkData.indexOf(today) > -1) {
                        Dmall.LayerUtil.alert("금일은 출석체크를 완료하였습니다.</br>다음에 다시 참여해주세요","","");
                        return;
                    }
            
                    var url = '/front/event/attendance-check';
                    var param = {eventNo:"${vo.eventNo}",memberNo:"${user.session.memberNo}"};
        
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            location.reload();
                        } 
                    });
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
        <!--- contents --->
        <div class="contents">
            <!--- category header 카테고리 location과 동일 ---> 
            <div id="category_header">
                <div id="category_location">
                    <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>출석체크 이벤트
                </div>      
            </div>
            <!---// category header --->
            <h2 class="sub_title">출석체크 이벤트<span>믿을수 있는 쇼핑! 더 안전한 쇼핑!</span></h2>            
                    
            <!-- full calendar -->
            <div id='calendar'></div>
            <!--// full calendar -->

            <div class="btn_area">
                <button type="button" class="btn_checkin">출석체크</button>
            </div>

        </div>
        <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>