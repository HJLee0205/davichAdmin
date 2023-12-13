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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 출석체크 이벤트 만들기</t:putAttribute>
    <t:putAttribute name="script">
        <script>
        // 출석체크이벤트 시작일시 종료일시
        var $srch_sc01 = $("#srch_sc01");
        var $srch_sc02 = $("#srch_sc02");
        var $srch_from_hour = $("#srch_from_hour");
        var $srch_to_hour = $("#srch_to_hour");
        var $srch_from_minute = $("#srch_from_minute");
        var $srch_to_minute = $("#srch_to_minute");

        // 포인트유효기간 시작일시 종료일시
        var $pointSrch_sc01 = $("#pointSrch_sc01");
        var $pointSrch_sc02 = $("#pointSrch_sc02");
        var $pointSrch_from_hour = $("#pointSrch_from_hour");
        var $pointSrch_to_hour = $("#pointSrch_to_hour");
        var $pointSrch_from_minute = $("#pointSrch_from_minute");
        var $pointSrch_to_minute = $("#pointSrch_to_minute");
        
            jQuery(document).ready(function() {
                //포인트설정에서 포인트사용여부점검 : 포인트사용 안함이 선택되어 있으면 경고창 보여줌.
                pointUseYn();
                  
                
                // 저장
                jQuery('#reg_btn').on('click', function(e) {
                    if ( $("#eventNm").val() == "" ) {
                        Dmall.LayerUtil.alert("이벤트명을 입력하세요");
                        return false;
                    }

                    if ( $("#eventPvdPoint").val() == "" ) {
                        Dmall.LayerUtil.alert("지급할 포인트를 입력하세요");
                        return false;
                    }
                    if ( $("#eventPvdPoint").val() == "0" ) {
                        Dmall.LayerUtil.alert("지급할 포인트가 0일수는 없습니다.");
                        return false;
                    }

                    // 출석체크이벤트 기간 유효성검사 : 다른 이벤트와 겹치지 않게도 체크
                    if(dttmCheck() == false){
                        return false;
                    }
                    
                    //포인트 유효기간 유효성검사
                    if(pointPeriodCheck() == false){
                        return false;
                    }

                    // 총 참여횟수 유효성검사
                    if( totPartdtCndtCheck() == false ){
                        return false;
                    }               
                    
                    Dmall.EventUtil.stopAnchorAction(e);
                    if(Dmall.validate.isValid('form_info')) {

                        var url = '/admin/promotion/attendancecheck-insert',
                            param = jQuery('#form_info').serialize();
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_info');
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/promotion/attendancecheck');
                            }
                        });
                    }
                });
                
                //숫자만 입력가능하게 : 출석포인트, 유효기간, 참여횟수 
                $('#eventPvdPoint, #eventApplyIssueAfPeriod, #eventTotPartdtCndt01, #eventTotPartdtCndt02, #eventAddPvdPoint').on('focus', function () {
                    onlyNumberInput($(this));
                });
                //천단위로 콤마 찍기
                $('#eventPvdPoint, #eventApplyIssueAfPeriod, #eventTotPartdtCndt01, #eventTotPartdtCndt02, #eventAddPvdPoint').mask("#,##0", {reverse:true, maxlength:false});
            });
            
            function onlyNumberInput(obj){
                obj.on('keydown', function (event) {
                    event = event || window.event;
                    var keyID = (event.which) ? event.which : event.keyCode;
                    // 48 ~ 57 일반숫자키 0~9,  96~105 키보드 우측 숫자키패드,  백스페이스 8, 탭 9, end 35, home 36, 왼쪽 방향키 37, 오른쪽 방향키 39, 인서트 45, 딜리트 46, 넘버락 144 
                    if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 ){
                        
                        return;
                        
                    } else {
                        return false;
                    };
                });
                 obj.on('keyup', function (event) {
                    event = event || window.event;
                    var keyID = (event.which) ? event.which : event.keyCode;
                    if ( keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 ){
                        return;
                    }
                });
            };
            
            function pointUseYn(){
                var url = '/admin/operation/point-config-info';
                var param = '';
//                 dfd = jQuery.Deferred();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if( result.data.pointPvdYn == 'N' ){
                        Dmall.LayerUtil.confirm("설정 > 포인트서비스 > 포인트 지급 여부에 사용안함이 체크되어 있습니다. 출석체크이벤트로 포인트를 제공하시려면 사용으로 바꾸셔야 합니다. 해당페이지로 이동하시겠습니까?", function(){
                                   location.href = "/admin/operation/point-config";
                        });
                    }
                });
            };
            
            // 출석첵크 기간 유효성 검사 : 다른 이벤트와 기간 겹치면 경고
            function dttmCheck(){
                // 출석체크 기간
                if($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null ) {
                    Dmall.LayerUtil.alert("출석체크 날짜를 선택해주세요");
                    return false
                } else if($srch_sc01.val() > $srch_sc02.val()){
                    Dmall.LayerUtil.alert("출석체크 시작날짜가 출석체크 종료날짜보다 큽니다.")
                    return false;
                } else if($srch_sc01.val() == $srch_sc02.val()){
                    if($srch_from_hour.val() > $srch_to_hour.val()){
                        Dmall.LayerUtil.alert("출석체크 시작(시간)이 출석체크 종료(시간)보다 큽니다.")
                        return false;
                    } else if($srch_from_hour.val() == $srch_to_hour.val()){
                        if($srch_from_minute.val() >= $srch_to_minute.val()){
                            Dmall.LayerUtil.alert("출석체크 시작(분)이 출석체크 종료(분)보다 크거나 같습니다.")
                            return false;
                        };
                    };
                };
                
                // 다른 이벤트( 시작일시/ 종료일시/ 이벤트이름 )
                var otherEventStartDttm = $('#otherEventDttm').children('input:nth-child(3n+1)');
                var otherEventEndDttm = $('#otherEventDttm').children('input:nth-child(3n+2)');
                var otherEventNm = $('#otherEventDttm').children('input:nth-child(3n)');
                
                // 만들려는 이벤트( 시작일시/ 종료일시)
                var currentEventStartDttm = ( $srch_sc01.val()+$srch_from_hour.val()+$srch_from_minute.val() ).replaceAll("-", "")
                var currentEventEndDttm = ( $srch_sc02.val()+$srch_to_hour.val()+$srch_to_minute.val() ).replaceAll("-", "")
                
                // 기간 겹치는 부분 있으면 경고창
                for( var j = 0; j < otherEventEndDttm.length; j++ ){
                    if( otherEventStartDttm.eq(j).prop('value') <=  currentEventEndDttm ) {
                        if( otherEventEndDttm.eq(j).prop('value') >=  currentEventStartDttm ) {
                          alert( otherEventNm.eq(j).prop('value') + " 출석체크이벤트와 기간이 겹칩니다.")
                          return false;
                        };  
                    };
                 };
            };    
            
            // 포인트 유효기간 유효성 검사
            function pointDttmCheck(){
                // 포인트유효기간
//                 if($pointSrch_sc01.val() == '' || $pointSrch_sc01.val() == null || $pointSrch_sc02.val() == '' || $pointSrch_sc02.val() == null ) {
                if($pointSrch_sc02.val() == '' || $pointSrch_sc02.val() == null ) {
                    Dmall.LayerUtil.alert("포인트유효 날짜를 선택해주세요");
                    return false
                } else if($pointSrch_sc01.val() > $pointSrch_sc02.val()){
                    Dmall.LayerUtil.alert("포인트유효 시작날짜가 포인트유효 종료날짜보다 큽니다.")
                    return false;
                } else if($pointSrch_sc01.val() == $pointSrch_sc02.val()){
                    if($pointSrch_from_hour.val() > $pointSrch_to_hour.val()){
                        Dmall.LayerUtil.alert("포인트유효 시작(시간)이 포인트유효 종료(시간)보다 큽니다.")
                        return false;
                    } else if($pointSrch_from_hour.val() == $pointSrch_to_hour.val()){
                        if($pointSrch_from_minute.val() >= $pointSrch_to_minute.val()){
                            Dmall.LayerUtil.alert("포인트유효 시작(분)이 포인트유효 종료(분)보다 크거나 같습니다.")
                            return false;
                        }
                    }
                }

                // 출석체크시작 < 출석체크종료 < 포인트유효시작 < 포인트유효종료.  첫째셋째 부등호는 이미 구현함
                // 출석체크종료 < 포인트유효시작  지켜줘야 함.  
                if($srch_sc02.val() > $pointSrch_sc02.val()){
                    Dmall.LayerUtil.alert("출석체크 종료날짜는 포인트유효 날짜보다 느릴 수 없습니다.")
                    return false;
                } else if($srch_sc02.val() == $pointSrch_sc01.val()){
                    if($srch_to_hour.val() > $pointSrch_from_hour.val()){
                        Dmall.LayerUtil.alert("출석체크종료(시간)은 포인트유효시작(시간)보다 느릴 수 없습니다.")
                        return false;
                    } else if($srch_to_hour.val() == $pointSrch_from_hour.val()){
                        if($srch_to_minute.val() >= $pointSrch_from_minute.val()){
                            Dmall.LayerUtil.alert("출석체크종료(분)은 포인트유효시작(분)과 같거나 느릴 수 없습니다.")
                            return false;
                        }
                    }
                }
             }
            
            function pointPeriodCheck(){
                // 포인트 유효기간이 날짜일 경우  : 몇개월 후 초기값 0으로 지정
                if( $("#fromToPeriod").parents('label').hasClass('on') ) {
                    if(pointDttmCheck() == false){
                        return false;
                    } else {
                       $("#eventApplyIssueAfPeriod").prop("value", 0)
                    }
                }
                
                // 포인트 유효기간이 몇개월 후 일 경우  
                if( $("#issueAfPeriod").parents('label').hasClass('on') ) {
                    if ( $("#eventApplyIssueAfPeriod").val() =="" ){
                        Dmall.LayerUtil.alert("포인트 유효기간이 적립일로부터 몇개월까지인지 입력하세요");
                        return false;
                    }
                    if ( $("#eventApplyIssueAfPeriod").val() =="0" ){
                        Dmall.LayerUtil.alert("0개월은 입력할 수 없습니다.");
                        return false;
                    }
                }
            }
            
            // 총 참여횟수 유효성 검사 
            function totPartdtCndtCheck(){
               // 시작일시와 종료일시를 밀리세컨으로 변환하여 차이 일수를 구한다.
               var fromDate = $("#srch_sc01").val().split("-");
               var from = new Date( fromDate[0], fromDate[1], fromDate[2], $("#srch_from_hour").val(),  $("#srch_from_minute").val() );
               
               var toDate = $("#srch_sc02").val().split("-");
               var to = new Date( toDate[0], toDate[1], toDate[2], $("#srch_to_hour").val(),  $("#srch_to_minute").val() );
               
               var diff = to - from         
               var date = 24 * 60 * 60 * 1000       // 시 * 분 * 초 * 밀리세컨
               var week = 7 * 24 * 60 * 60 * 1000  //  일 * 시 * 분 * 초 * 밀리세컨
               
               // 출석체크기간 일수
               var periodDay = Math.ceil(diff/date); 
               
               // 이벤트기간이 일주일보다 길거나 같고 이벤트 예외요일이 설정돼 있다면, 일주일을 6일로 계산
               if( periodDay >= week ){
                   if( $("#exceptSat").parents('label').hasClass('on') || $("#exceptSun").parents('label').hasClass('on') ){
                       periodDay = periodDay * 6 / 7   // 일주일에서 하루씩 예외
                   } 
               } 

               // 이벤트기간이 일주일보다 짧고 그안에 예외요일이 들어있으면, 기간에서 -1 
               if( periodDay < week ){
                   var day = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
                   var sDate = new Date($("#srch_sc01").val()).getDay();
                   var sDateNm = day[sDate];
                   // 토요일 예외일때 아래와 조건이 같으면 하루빼기
                      // 시작일이 토요일이면 무조건
                      // 시작일이 일요일이고, 기간이 6일보다 크면
                      // 시작일이 월요일이고, 기간이 5일보다 크면
                      // 시작일이 화요일이고, 기간이 4일보다 크면
                      // 시작일이 수요일이고, 기간이 3일보다 크면
                      // 시작일이 목요일이고, 기간이 2일보다 크면
                      // 시작일이 금요일이고, 기간이 1일보다 크면
                   if($("#exceptSat").parents('label').hasClass('on')){
                       if(sDateNm == "토요일"){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "일요일" && (periodDay > 6)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "월요일" && (periodDay > 5)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "화요일" && (periodDay > 4)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "수요일" && (periodDay > 3)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "목요일" && (periodDay > 2)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "금요일" && (periodDay > 1)){
                           periodDay = periodDay - 1;
                       }
                   }
                   // 일요일 예외일때 아래와 조건이 같으면 하루빼기
                      // 시작일이 일요일이면 무조건
                      // 시작일이 월요일이고, 기간이 6일보다 크면
                      // 시작일이 화요일이고, 기간이 5일보다 크면
                      // 시작일이 수요일이고, 기간이 4일보다 크면
                      // 시작일이 목요일이고, 기간이 3일보다 크면
                      // 시작일이 금요일이고, 기간이 2일보다 크면
                      // 시작일이 토요일이고, 기간이 1일보다 크면
                   if($("#exceptSun").parents('label').hasClass('on')){
                       if(sDateNm == "일요일"){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "월요일" && (periodDay > 6)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "화요일" && (periodDay > 5)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "수요일" && (periodDay > 4)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "목요일" && (periodDay > 3)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "금요일" && (periodDay > 2)){
                           periodDay = periodDay - 1;
                       }
                       if(sDateNm == "토요일" && (periodDay > 1)){
                           periodDay = periodDay - 1;
                       }
                   }
               }
               
               // 조건완성형 선택한 경우 : 추가지급형 초기값 0으로 지정
               if( $("#cndtMeet").parents('label').hasClass('on') ) {
                   if ( $("#eventTotPartdtCndt01").val() =="" ){
                       Dmall.LayerUtil.alert("조건완성형의 총 참여횟수를 입력하세요");
                       return false;
                   } else if ( $("#eventTotPartdtCndt01").val() =="0" ){
                       Dmall.LayerUtil.alert("조건완성형의 총 참여횟수가 0일 수는 없습니다.");
                       return false;
                   } else if ( periodDay < $("#eventTotPartdtCndt01").val() ){
                       Dmall.LayerUtil.alert("조건완성형의 총 참여횟수는 가능출석체크일수와 같거나 작아야합니다.");
                   } else {
                       $("#eventTotPartdtCndt02").prop("value", 0)
                       $("#eventAddPvdPoint").prop("value", 0)
                   }    
               }
   
               // 추가지급형 선택한 경우 :  조건완성형 초기값 0으로 지정
               if( $("#extraPvd").parents('label').hasClass('on') ) {
                   if ( $("#eventTotPartdtCndt02").val() =="" ){
                       Dmall.LayerUtil.alert("추가지급형의 총 참여횟수를 입력하세요");
                       return false;
                   } else if ( $("#eventAddPvdPoint").val() =="" ){
                       Dmall.LayerUtil.alert("추가지급형의 추가포인트를 입력하세요");
                       return false;
                   } else if ( $("#eventTotPartdtCndt02").val() =="0" ){
                       Dmall.LayerUtil.alert("추가지급형의 총 참여횟수가 0일 수는 없습니다.");
                       return false;
                   } else if ( $("#eventAddPvdPoint").val() =="0"){
                       Dmall.LayerUtil.alert("추가지급형의 추가포인트가 0일 수는 없습니다.");
                       return false;
                   } else if ( periodDay < $("#eventTotPartdtCndt02").val() ){
                       Dmall.LayerUtil.alert("추가지급형의 총 참여횟수는 가능출석체크일수와 같거나 작아야합니다.");
                   } else {
                      $("#eventTotPartdtCndt01").prop("value", 0)
                   }
               }
            }
        </script>       
    </t:putAttribute>
    <t:putAttribute name="content">     
    <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <a href="/admin/promotion/attendancecheck" class="btn gray">출석체크 이벤트리스트</a>
            </div>
            <h2 class="tlth2">출석체크 이벤트 만들기</h2>
            <div class="btn_box right">
                <a href="#none" class="btn blue shot" id="reg_btn">저장하기</a>
            </div>
        </div>
        <!-- line_box -->
        
        <div class="line_box fri">
            <h3 class="tlth3">이벤트 정보</h3>
            <!-- tblw -->
            <form action="/admin/promotion/attendancecheck-insert" id="form_info">
            <input type="hidden" name="eventKindCd" id="eventKindCd" value="02"/>
            <div class="tblw tblmany">
                <table summary="이표는 이벤트등록표 입니다. 구성은 출석체크명, 종류, 체크기간, 예외설정, 출석체크 형태, 참여방법, 출석체크 참여혜택, 참여권한설정 입니다.">
                    <caption>이벤트 등록</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>출석체크명</th>
                            <td>
                                <span class="intxt wid100p"><input type="text" id="eventNm" name="eventNm" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>참여방법</th>
                            <td>
                                <label for="loginType" class="radio on mr20"><span class="ico_comm"><input type="radio" name="eventMethodCd" id="loginType" checked="checked" value="01"/></span> 로그인형 <span class="fc_pr1 fs_pr1">(로그인 시 자동 반영)</span></label>
                                <label for="stampType" class="radio"><span class="ico_comm"><input type="radio" name="eventMethodCd" id="stampType" value="02"/></span> 스템프형<span class="fc_pr1 fs_pr1">(출석체크 버튼 클릭 시 반영)</span></label>
                            </td>
                        </tr>
                        <tr>
                            <th>출석체크 기간</th>
                            <td>
                                <tags:calendarTime from="from" to="to" idPrefix="srch" />
                            </td>
                        </tr>
                        <tr>
                            <th>기간 예외설정</th>
                            <td>
                                <label for="exceptSat" class="radio on mr20"><span class="ico_comm"><input type="radio" name="eventPeriodExptCd" id="exceptSat" checked="checked" value="01"/></span> 토요일제외</label>
                                <label for="exceptSun" class="radio mr20"><span class="ico_comm"><input type="radio" name="eventPeriodExptCd" id="exceptSun"  value="02" /></span> 일요일제외</label>
                                <label for="exceptNone" class="radio mr20"><span class="ico_comm"><input type="radio" name="eventPeriodExptCd" id="exceptNone" value="03" /></span> 설정안함</label>
                            </td>
                        </tr>
                        <tr>
                            <th>출석 포인트 지급</th>
                            <td>
                                <span class="intxt"><input type="text" name="eventPvdPoint" id="eventPvdPoint" /></span> 점 <span class="fc_pr1 fs_pr1">(1일 최대 지급 포인트를 의미함)</span>
                            </td>
                        </tr>
                        <tr>
                            <th>출석 포인트<br>유효기간 설정</th>
                            <td>
                                <label for="fromToPeriod" class="radio on"><span class="ico_comm"><input type="radio" name="eventPointApplyCd" id="fromToPeriod" value="01" checked="checked" /></span> </label>
<%--                                 <tags:calendarTime from="pointFrom" to="pointTo" idPrefix="pointSrch" /> --%>
								<span class="intxt"><input type="text" name="pointTo" value="${eventVO.pointApplyEndDttm}" id="pointSrch_sc02" class="bell_date_sc"></span>
								<a href="javascript:void(0)" class="date_sc ico_comm" id="pointSrch_date01">달력이미지</a>
								<input type="hidden" name="pointToHoure" value="00" />
								<input type="hidden" name="pointToMinute" value="00" />
                                <span class="fc_pr1 fs_pr1">(해당일까지만 포인트가 유효함)</span>
                                <span class="br2"></span>
                                <label for="issueAfPeriod" class="radio"><span class="ico_comm"><input type="radio" name="eventPointApplyCd" id="issueAfPeriod" value="02"/></span> </label>
                                적립일로부터 <span class="intxt"><input type="text" name="eventApplyIssueAfPeriod" id="eventApplyIssueAfPeriod" /></span> 일 유효(사용기한 초과 포인트 자동 소멸)
                            </td>
                        </tr>
                        <tr>
                            <th>출석 이벤트 조건</th>
                            <td>
                                <div class="txtind_box">
                                    <label for="cndtMeet" class="radio left on"><span class="ico_comm"><input type="radio" name="eventCndtCd" id="cndtMeet" value="01" checked="checked"/></span> 조건완성형:</label>
                                    <div class="right">
                                        총 참여횟수가 <span class="intxt shot"><input type="text" id="eventTotPartdtCndt01" name="eventTotPartdtCndt01" /></span> 회 이상일 경우 이벤트 조건을 만족합니다.
                                    </div>
                                    <span class="br"></span>
                                    <label for="extraPvd" class="radio left"><span class="ico_comm"><input type="radio" name="eventCndtCd" id="extraPvd" value="02"/></span> 추가지급형:</label>
                                    <div class="right">
                                        총 참여횟수 <span class="intxt shot"><input type="text" id="eventTotPartdtCndt02" name="eventTotPartdtCndt02" /></span> 회 만족 시 추가포인트를 지급합니다. 
                                        <span class="br2"></span>
                                        포인트 <span class="intxt shot"><input type="text" id="eventAddPvdPoint" name="eventAddPvdPoint" /></span> 점 추가지급
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            </form>
            
            <!-- 출석체크이벤트기간 중복 방지 -->            
            <span id="otherEventDttm">
                <c:forEach var = "result" items = "${resultModel.resultList}">
                        <input type="hidden" value="${result.otherApplyStartDttm}" />
                        <input type="hidden" value="${result.otherApplyEndDttm}" />
                        <input type="hidden" value="${result.otherEventNm}" />
                </c:forEach>
            </span>
            <!-- //tblw -->
            
        </div>
        <!-- //line_box -->
    </div>
        
    </t:putAttribute>
</t:insertDefinition>
