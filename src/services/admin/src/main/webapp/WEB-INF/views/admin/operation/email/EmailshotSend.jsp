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
    <t:putAttribute name="title">대량메일 발송 설정 > 대량메일 > 운영</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
<%--            var siteNo = "${siteNo}";--%>
            $(document).ready(function() {
                //에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.init();
                //emailContent 를 ID로 가지는 Textarea를 에디터로 설정
                Dmall.DaumEditor.create('emailContent');

<%--                //이메일 보유 건수 조회--%>
<%--                var url = Constant.smsemailServer + '/email/point/'+siteNo,--%>
<%--                    param = "";--%>

<%--                Dmall.AjaxUtil.getJSONP(url, param, function(result) {--%>
<%--                    $("#emailPossCntTh").text("이메일 발송[보유 이메일 건수 : " + result + "건]");--%>
<%--                    $("#paidPossCnt").text("현재 " + result + " 건");--%>
<%--                });--%>


<%--                //이메일 발송--%>
<%--                $('#sendEmailInsert').on('click', function(e) {--%>
<%--                    e.preventDefault();--%>
<%--                    e.stopPropagation();--%>

<%--                    if($("#mailTitle").val()==""){--%>
<%--                        Dmall.LayerUtil.alert('메일 제목을 입력하여 주십시오.');--%>
<%--                        return;--%>
<%--                    }--%>
<%--                    if($("#sendTimeSel").val()==""){--%>
<%--                        Dmall.LayerUtil.alert('발송시간을 선택하여 주십시오.');--%>
<%--                        return;--%>
<%--                    }--%>

<%--                    if($("#emailshotGb").val()==""){--%>
<%--                        Dmall.LayerUtil.alert('메일 구분을 선택하여 주십시오.');--%>
<%--                        return;--%>
<%--                    }--%>

<%--//         if($("input[name = 'EmailMember']:checked").val()=="select"){--%>
<%--//             $("#totalMemberList").remove();--%>
<%--//             $("#searchMemberList").remove();--%>
<%--//         }--%>

<%--                    //예약발송 일 경우 예약 시간이 현재 시간보다 앞에 있는지 CHECK--%>
<%--                    if($("#sendTimeSel").val() == "reservation"){--%>
<%--                        var nowTime = new Date();--%>
<%--                        var year = nowTime.getFullYear();--%>
<%--                        var month = nowTime.getMonth() +1;--%>
<%--                        var day = nowTime.getDate();--%>
<%--                        var hour = nowTime.getHours();--%>

<%--                        if(month < 10){--%>
<%--                            month = "0"+month;--%>
<%--                        }--%>
<%--                        if(day < 10){--%>
<%--                            day = "0"+day;--%>
<%--                        }--%>
<%--                        if(hour < 10){--%>
<%--                            hour = "0"+hour;--%>
<%--                        }--%>
<%--                        var nowTm = year+""+month +""+day+""+hour;--%>
<%--                        var rsvTime = $("#reservationYear").val()+$("#reservationMonth").val()+$("#reservationDay").val()+$("#reservationTime").val();--%>

<%--                        if(nowTm > rsvTime || nowTm == rsvTime){--%>
<%--                            Dmall.LayerUtil.alert('예약 발송 시간은 현재 시간보다 빠를 수 없습니다.');--%>
<%--                            return;--%>
<%--                        }--%>
<%--                    }--%>

<%--                    if(Dmall.validate.isValid('form_id_emailSendInsert')) {--%>

<%--                        //받는 대상 set--%>
<%--                        var target = "";--%>
<%--                        if($("input[name = 'sendTargetType']:checked").val()=="memGrade"){--%>
<%--                            target = $("#memberGrade option:selected").text();--%>
<%--                            if($("#memberGrade").val() != ''){--%>
<%--                                target += " 회원";--%>
<%--                            }--%>
<%--                        }else{--%>
<%--                            target = $("#bornMonth").val() + "월 " + $("#anniversarySel option:selected").text() + " 회원";--%>
<%--                        }--%>

<%--                        $("#sendStndrd").val(target);--%>

<%--                        //예약발송일 경우 예약발송시간 set--%>
<%--                        if($("#sendTimeSel").val() == "reservation"){--%>
<%--                            $("#reservationDttm").val($("#reservationYear").val()+$("#reservationMonth").val()+$("#reservationDay").val()+$("#reservationTime").val());--%>
<%--                        }--%>


<%--                        //에디터에서 폼으로 데이터 세팅--%>
<%--                        Dmall.DaumEditor.setValueToTextarea('emailContent');--%>

<%--                        $("#curPage").val($(location).attr("protocol")+"//"+$(location).attr("host"));--%>

<%--                        var url = '/admin/operation/email-send',--%>
<%--                            param = $('#form_id_emailSendInsert').serialize();--%>

<%--                        Dmall.AjaxUtil.getJSON(url, param, function(result) {--%>
<%--                            Dmall.validate.viewExceptionMessage(result, 'form_id_emailSendInsert');--%>
<%--                            if(result.success){--%>
<%--                                var param = {pageGb:"3"};--%>
<%--                                Dmall.FormUtil.submit('/admin/operation/bulk-mailing', param);--%>
<%--                            }--%>
<%--                        });--%>
<%--                    }--%>
                });

<%--                //이메일 미리보기--%>
<%--                $('#previewBtn').on('click', function(e) {--%>
<%--                    e.preventDefault();--%>
<%--                    e.stopPropagation();--%>
<%--                    viewEmailPreview();--%>
<%--                });--%>

<%--                //발송시간 selectbox 선택 이벤트--%>
<%--                $('#sendTimeSel').on('change', function(e) {--%>
<%--                    //일반발송--%>
<%--                    if($(this).val() == "general"){--%>
<%--                        $("#yearSel").hide();--%>
<%--                        $("#yearText").hide();--%>
<%--                        $("#monthSel").hide();--%>
<%--                        $("#monthText").hide();--%>
<%--                        $("#daySel").hide();--%>
<%--                        $("#dayText").hide();--%>
<%--                        $("#timeSel").hide();--%>
<%--                        $("#timeText").hide();--%>
<%--                    }--%>
<%--                    //예약발송--%>
<%--                    else{--%>
<%--                        $("#yearSel").show();--%>
<%--                        $("#yearText").show();--%>
<%--                        $("#monthSel").show();--%>
<%--                        $("#monthText").show();--%>
<%--                        $("#daySel").show();--%>
<%--                        $("#dayText").show();--%>
<%--                        $("#timeSel").show();--%>
<%--                        $("#timeText").show();--%>
<%--                    }--%>
<%--                });--%>

<%--                //메일 구분 선택 이벤트(광고, 공지)--%>
<%--                $('#emailshotGb').on('change', function(e) {--%>
<%--                    if($(this).val() == "urgency"){--%>
<%--                        var $input = $("input[name='excludeRecvN']");--%>
<%--                        $input.prop("readonly",false);--%>

<%--                        $input = $('input[name="footerUseYn"]');--%>
<%--                        $input.prop("readonly",false);--%>

<%--                    }else{--%>
<%--                        var $input = $("input[name='excludeRecvN']");--%>
<%--                        $input.parents().parents('label').addClass('on');--%>
<%--                        $("#excludeRecvN").prop("checked",true);--%>
<%--                        $("#excludeRecvN").prop("readonly",true);--%>

<%--                        $input = $("input:radio[name='footerUseYn']:radio[value='Y']");--%>
<%--                        $inputs = $('input[name="footerUseYn"]');--%>
<%--                        $inputs.parents('label').removeClass('on');--%>
<%--                        $input.parents().parents('label').addClass('on');--%>
<%--                        $input.prop("checked",true);--%>
<%--                        $inputs.prop("readonly",true);--%>
<%--                    }--%>
<%--                });--%>
<%--            });--%>

<%--            //이메일 미리보기 레이어팝업--%>
<%--            function viewEmailPreview() {--%>
<%--                //메일 구분 메일 타이틀에 set--%>
<%--                var mailGb = $("#emailshotGb").val();--%>
<%--                var mailGbTxt = "";--%>
<%--                if(mailGb == "ad"){--%>
<%--                    mailGbTxt = "(광고)";--%>
<%--                }else if(mailGb == "urgency"){--%>
<%--                    mailGbTxt = "(공지)";--%>
<%--                }--%>

<%--                //받는 대상 set--%>
<%--                var target = "";--%>
<%--                if($("input[name = 'sendTargetType']:checked").val()=="memGrade"){--%>
<%--                    target = $("#memberGrade option:selected").text();--%>
<%--                    if($("#memberGrade").val() != ''){--%>
<%--                        target += " 회원";--%>
<%--                    }--%>
<%--                }else{--%>
<%--                    target = $("#bornMonth").val() + "월 " + $("#anniversarySel option:selected").text() + " 회원";--%>
<%--                }--%>

<%--                $("#emailContentTd").html(Dmall.DaumEditor.getContent('emailContent'));--%>
<%--                $("#emailTitleTd").html(mailGbTxt+$("#mailTitle").val());--%>
<%--                $("#senderTd").html($("#senderNm").val() + "<br/> (" + $("#sendEmail").val() + ")");--%>
<%--                $("#receiverTd").html(target);--%>

<%--                //footer 사용 여부 체크 및 set--%>
<%--                if($("input[name = 'footerUseYn']:checked").val() == "Y"){--%>
<%--                    $("#footerTd").html($("#footerVal").text());--%>
<%--                }--%>


<%--                Dmall.LayerPopupUtil.open($("#emailPreview"));--%>
<%--            }--%>
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 대량메일<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">대량메일 발송 설정</h2>
            </div>
            <form id="form_id_emailSendInsert">
                <input type="hidden" name="sendStndrd" id="sendStndrd" />
                <input type="hidden" name=reservationDttm id="reservationDttm" />
                <input type="hidden" name="curPage" id="curPage" />
                <!-- line_box -->
                <div class="line_box fri">
                    <!-- tblh -->
                    <div class="tblh th_l tblmany">
                        <table summary="이표는 대량메일 발송 설정 표 입니다. 구성은  입니다.">
                            <caption>대량메일 발송 설정</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th colspan="2" id="emailPossCntTh"></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <th>보내는사람</th>
                                <td class="txtl">
                                    <label for="in_01">이름 :</label> <span class="intxt"><input type="text" id="senderNm" name="senderNm" value="${siteInfo.siteNm}" readonly="readonly"/></span>
                                    <label for="in_02">이메일 :</label> <span class="intxt long2"><input type="text" id="sendEmail" name="sendEmail" value="${siteInfo.custCtEmail}" readonly="readonly" /></span>
                                    <tags:checkbox name="excludeRecvN" id="excludeRecvN" value="Y" compareValue="" text="수신거부회원 제외" />
                                </td>
                            </tr>
                            <tr>
                                <th>받는사람</th>
                                <td class="txtl">
                                    발급기준
                                    <span class="br2"></span>
                                    <div class="tblw tblmany2 mt0">
                                        <table summary="이표는 발급기준 표 입니다.">
                                            <caption>발급기준</caption>
                                            <colgroup>
                                                <col width="20%">
                                                <col width="80%">
                                            </colgroup>
                                            <tbody>
                                            <tr>
                                                <th class="back_c1">
                                                    <label for="radio55_1" class="radio on left ">
                                                    <span class="ico_comm">
                                                        <input type="radio" name="sendTargetType" checked="checked" value="memGrade" />
                                                    </span>
                                                        회원그룹별</label>
                                                </th>
                                                <td>
                                                <span class="select">
                                                    <label for="">회원등급</label>
                                                    <select name="memberGrade" id="memberGrade">
                                                        <option value="">전체회원</option>
                                                        <c:forEach var = "gradeList" items="${memberGradeListModel.resultList}">
                                                            <option value="${gradeList.memberGradeNo}" >${gradeList.memberGradeNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th class="back_c1">
                                                    <label for="radio55_2" class="radio left ">
                                                    <span class="ico_comm">
                                                        <input type="radio" name="sendTargetType" value="anniversary">
                                                    </span>
                                                        기념일별</label>
                                                </th>
                                                <td>
                                                <span class="select">
                                                    <label for=""></label>
                                                    <select name="anniversarySel" id="anniversarySel">
                                                        <option value="birth">생일</option>
                                                    </select>
                                                </span>
                                                    <span class="select one">
                                                    <label for=""></label>
                                                    <select name="bornMonth" id="bornMonth">
                                                        <option value="01">01</option>
                                                        <option value="02">02</option>
                                                        <option value="03">03</option>
                                                        <option value="04">04</option>
                                                        <option value="05">05</option>
                                                        <option value="06">06</option>
                                                        <option value="07">07</option>
                                                        <option value="08">08</option>
                                                        <option value="09">09</option>
                                                        <option value="10">10</option>
                                                        <option value="11">11</option>
                                                        <option value="12">12</option>
                                                    </select>
                                                </span>
                                                    <span class="vtam">월</span>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>메일구분</th>
                                <td class="txtl">
                            <span class="select">
                                <label for=""></label>
                                <select name="emailshotGb" id="emailshotGb">
                                    <option value="" selected>메일구분</option>
                                    <option value="ad">광고성정보</option>
                                    <option value="urgency">긴급공지</option>
                                </select>
                            </span>
                                </td>
                            </tr>
                            <tr>
                                <th>발송시간</th>
                                <td class="txtl">
                            <span class="select">
                                <label for=""></label>
                                <select name="sendTimeSel" id="sendTimeSel">
                                    <option value="" selected>선택하기</option>
                                    <option value="general">일반발송</option>
                                    <option value="reservation">예약발송</option>
                                </select>
                            </span>
                                    <span class="select" id="yearSel" style="display:none;">
                                <label for=""></label>
                                <select name="reservationYear" id="reservationYear">
                                    <option value="2016" <c:if test='${nowYear eq "2016" }' >selected</c:if>>2016</option>
                                    <option value="2017" <c:if test='${nowYear eq "2017" }' >selected</c:if>>2017</option>
                                </select>
                            </span>
                                    <span class="vtam" id="yearText" style="display:none;">년</span>
                                    <span class="select one" id="monthSel" style="display:none;">
                                <label for=""></label>
                                <select name="reservationMonth" id="reservationMonth">
                                    <option value="01" <c:if test='${nowMonth eq "01" }' >selected</c:if>>01</option>
                                    <option value="02" <c:if test='${nowMonth eq "02" }' >selected</c:if>>02</option>
                                    <option value="03" <c:if test='${nowMonth eq "03" }' >selected</c:if>>03</option>
                                    <option value="04" <c:if test='${nowMonth eq "04" }' >selected</c:if>>04</option>
                                    <option value="05" <c:if test='${nowMonth eq "05" }' >selected</c:if>>05</option>
                                    <option value="06" <c:if test='${nowMonth eq "06" }' >selected</c:if>>06</option>
                                    <option value="07" <c:if test='${nowMonth eq "07" }' >selected</c:if>>07</option>
                                    <option value="08" <c:if test='${nowMonth eq "08" }' >selected</c:if>>08</option>
                                    <option value="09" <c:if test='${nowMonth eq "09" }' >selected</c:if>>09</option>
                                    <option value="10" <c:if test='${nowMonth eq "10" }' >selected</c:if>>10</option>
                                    <option value="11" <c:if test='${nowMonth eq "11" }' >selected</c:if>>11</option>
                                    <option value="12" <c:if test='${nowMonth eq "12" }' >selected</c:if>>12</option>
                                </select>
                            </span>
                                    <span class="vtam" id="monthText" style="display:none;">월</span>
                                    <span class="select one" id="daySel" style="display:none;">
                                <label for=""></label>
                                <select name="reservationDay" id="reservationDay">
                                    <option value="01" <c:if test='${nowDay eq "01" }' >selected</c:if>>01</option>
                                    <option value="02" <c:if test='${nowDay eq "02" }' >selected</c:if>>02</option>
                                    <option value="03" <c:if test='${nowDay eq "03" }' >selected</c:if>>03</option>
                                    <option value="04" <c:if test='${nowDay eq "04" }' >selected</c:if>>04</option>
                                    <option value="05" <c:if test='${nowDay eq "05" }' >selected</c:if>>05</option>
                                    <option value="06" <c:if test='${nowDay eq "06" }' >selected</c:if>>06</option>
                                    <option value="07" <c:if test='${nowDay eq "07" }' >selected</c:if>>07</option>
                                    <option value="08" <c:if test='${nowDay eq "08" }' >selected</c:if>>08</option>
                                    <option value="09" <c:if test='${nowDay eq "09" }' >selected</c:if>>09</option>
                                    <option value="10" <c:if test='${nowDay eq "10" }' >selected</c:if>>10</option>
                                    <option value="11" <c:if test='${nowDay eq "11" }' >selected</c:if>>11</option>
                                    <option value="12" <c:if test='${nowDay eq "12" }' >selected</c:if>>12</option>
                                    <option value="13" <c:if test='${nowDay eq "13" }' >selected</c:if>>13</option>
                                    <option value="14" <c:if test='${nowDay eq "14" }' >selected</c:if>>14</option>
                                    <option value="15" <c:if test='${nowDay eq "15" }' >selected</c:if>>15</option>
                                    <option value="16" <c:if test='${nowDay eq "16" }' >selected</c:if>>16</option>
                                    <option value="17" <c:if test='${nowDay eq "17" }' >selected</c:if>>17</option>
                                    <option value="18" <c:if test='${nowDay eq "18" }' >selected</c:if>>18</option>
                                    <option value="19" <c:if test='${nowDay eq "19" }' >selected</c:if>>19</option>
                                    <option value="20" <c:if test='${nowDay eq "20" }' >selected</c:if>>20</option>
                                    <option value="21" <c:if test='${nowDay eq "21" }' >selected</c:if>>21</option>
                                    <option value="22" <c:if test='${nowDay eq "22" }' >selected</c:if>>22</option>
                                    <option value="23" <c:if test='${nowDay eq "23" }' >selected</c:if>>23</option>
                                    <option value="24" <c:if test='${nowDay eq "24" }' >selected</c:if>>24</option>
                                    <option value="25" <c:if test='${nowDay eq "25" }' >selected</c:if>>25</option>
                                    <option value="26" <c:if test='${nowDay eq "26" }' >selected</c:if>>26</option>
                                    <option value="27" <c:if test='${nowDay eq "27" }' >selected</c:if>>27</option>
                                    <option value="28" <c:if test='${nowDay eq "28" }' >selected</c:if>>28</option>
                                    <option value="29" <c:if test='${nowDay eq "29" }' >selected</c:if>>29</option>
                                    <option value="30" <c:if test='${nowDay eq "30" }' >selected</c:if>>30</option>
                                    <option value="31" <c:if test='${nowDay eq "31" }' >selected</c:if>>31</option>
                                </select>
                            </span>
                                    <span class="vtam" id="dayText" style="display:none;">일</span>
                                    <span class="select one" id="timeSel" style="display:none;">
                                <label for=""></label>
                                <select name="reservationTime" id="reservationTime">
                                    <option value="00" <c:if test='${nowTime eq "00" }' >selected</c:if>>00</option>
                                    <option value="01" <c:if test='${nowTime eq "01" }' >selected</c:if>>01</option>
                                    <option value="02" <c:if test='${nowTime eq "02" }' >selected</c:if>>02</option>
                                    <option value="03" <c:if test='${nowTime eq "03" }' >selected</c:if>>03</option>
                                    <option value="04" <c:if test='${nowTime eq "04" }' >selected</c:if>>04</option>
                                    <option value="05" <c:if test='${nowTime eq "05" }' >selected</c:if>>05</option>
                                    <option value="06" <c:if test='${nowTime eq "06" }' >selected</c:if>>06</option>
                                    <option value="07" <c:if test='${nowTime eq "07" }' >selected</c:if>>07</option>
                                    <option value="08" <c:if test='${nowTime eq "08" }' >selected</c:if>>08</option>
                                    <option value="09" <c:if test='${nowTime eq "09" }' >selected</c:if>>09</option>
                                    <option value="10" <c:if test='${nowTime eq "10" }' >selected</c:if>>10</option>
                                    <option value="11" <c:if test='${nowTime eq "11" }' >selected</c:if>>11</option>
                                    <option value="12" <c:if test='${nowTime eq "12" }' >selected</c:if>>12</option>
                                    <option value="13" <c:if test='${nowTime eq "13" }' >selected</c:if>>13</option>
                                    <option value="14" <c:if test='${nowTime eq "14" }' >selected</c:if>>14</option>
                                    <option value="15" <c:if test='${nowTime eq "15" }' >selected</c:if>>15</option>
                                    <option value="16" <c:if test='${nowTime eq "16" }' >selected</c:if>>16</option>
                                    <option value="17" <c:if test='${nowTime eq "17" }' >selected</c:if>>17</option>
                                    <option value="18" <c:if test='${nowTime eq "18" }' >selected</c:if>>18</option>
                                    <option value="19" <c:if test='${nowTime eq "19" }' >selected</c:if>>19</option>
                                    <option value="20" <c:if test='${nowTime eq "20" }' >selected</c:if>>20</option>
                                    <option value="21" <c:if test='${nowTime eq "21" }' >selected</c:if>>21</option>
                                    <option value="22" <c:if test='${nowTime eq "22" }' >selected</c:if>>22</option>
                                    <option value="23" <c:if test='${nowTime eq "23" }' >selected</c:if>>23</option>
                                </select>
                            </span>
                                    <span class="vtam" id="timeText" style="display:none;">시</span>
                                </td>
                            </tr>
                            <tr>
                                <th>메일제목</th>
                                <td class="txtl">
                            <span class="intxt long">
                                <input type="text" id="mailTitle" name="mailTitle" />
                            </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <div class="edit tblmany">
                        <textarea id="emailContent" name="mailContent" class="blind"></textarea>
                    </div>

                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="">
                            <caption></caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>수신거부 (필수)</th>
                                <td id="footerVal">
                                    본 메일은 ${nowYear}년 ${nowMonth}월 ${nowDay}일 기준으로 회원님의 이메일 수신동의 여부를 확인한 결과, 수신에 동의하였기에 발송되었습니다. 메일 수신을 원하지 않으시면 <a href="#none" class="tbl_link">[수신거부]</a> 를 클릭해 주십시오.
                                    <br><br>
                                    If you don't want to receive this email anymore, click <a href="#none" class="tbl_link">[HERE]</a><br>
                                    본 메일은 발신전용으로 회신되지 않으므로 문의사항은 [고객센터]를 이용하여 주시기 바랍니다.
                                </td>
                            </tr>
                            <tr>
                                <th>푸터 사용여부</th>
                                <td>
                                    <label for="radio04_1" class="radio on mr20"><span class="ico_comm"><input type="radio" name="footerUseYn" checked="checked" value="Y"></span> 사용</label>
                                    <label for="radio04_2" class="radio mr20"><span class="ico_comm"><input type="radio" name="footerUseYn" value="N"></span> 미사용</label>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->

                    <div class="mail_info">
                        <strong>불법스팸방지 안내</strong>
                        <span class="br2"></span>
                        - 영리목적의 광고성 정보를 전송하려면 사전에 수신동의를 받아야 합니다.<br>
                        - 광고성 정보 전송 시 "전송자의 명칭 및 연락처, 수신거부 방법"은 반드시 명시가 되어야 합니다.<br>
                        - 메일을 받은 회원이 수신거부 시 처리결과 통지 메일이 자동으로 발송됩니다.<br>
                        - 광고성 정보 전송 시 제목이 시작되는 부분이 "(광고)"를 표시하여야 합니다.<br>
                        - (광고)를 표시하는 경우에는 수신거부를 회피하기 위한 목적으로 (광/고), (광.고), ("광고"), (대출광고)와 같이 변칙 표기를 하시면 안됩니다.
                        <span class="br"></span>
                        [출처] 한국인터넷진흥원<a href="http://www.kisa.or.kr" class="tbl_link" target="_blank">(www.kisa.or.kr)</a><br>
                        [참조] <a href="#none" class="tbl_link" target="_blank">불법 스팸 방지를 위한 정보통신망법 안내서</a><br>
                        <span class="br"></span>
                        <strong>스팸규제 관련 안내</strong>
                        <span class="br2"></span>
                        - 스팸메일 발송에 관한 규정을 준수하시기 바라며, 스팸메일 발송 시 약관에 의거 쇼핑몰을 폐쇄 조치할 수 있으니 주의하여 주시기 바랍니다.<br>
                        - 해당 쇼핑몰의 회원에게만 전송해야 하며, 그 외 목적으로 사용시 법적 제재를 받을 수 있습니다.
                        <span class="br"></span>
                        [관련정책 및 법규 확인] 불법스팸대응센터<a href="http://www.spamcop.or.kr" class="tbl_link" target="_blank">(www.spamcop.or.kr)</a>
                        <span class="br"></span>
                        <strong>메일발송시 주의사항</strong>
                        <span class="br2"></span>
                        - 대량메일의 한국인터넷진흥원(KISA) 권장량은 최대 10만건입니다. 10만건 이상 발송될 경우 KISA에서 관리되는 대량메일 발송 IP 신뢰도지수가 떨어져 화이트도메인내에서 제외될 수 있으니, 1회 발송 당 최대 10만건을 권장합니다.<br>
                        - 메일 내용 작성시 꺽쇠표시(<<>>)가 앞 또는 뒤에 중복 입력될 경우 HTML 코드가 제대로 인식되지 않을 수 있으며, 발송후 클릭분석이 되지 않을 수 있습니다.<br>
                        - 네이트(nate.com), 엠팔(empal.com), 라이코스(lycos.co.kr)의 경우 자사의 메일계정이 아닌 경우 자체 필터링되어 메일 발송이 정상적이지 않을 수 있습니다.
                        <span class="br"></span>
                        <strong>발송시간 관련 안내</strong>
                        <span class="br2"></span>
                        - 대량메일은 각 쇼핑몰의 발송 요청 순서(캠페인)에 따라 순차 발송되어, 예약 발송시간보다 늦게 발송될 수 있으니 운영에 참고 하시기 바랍니다.<br>
                        - 대량메일은 발송 요청 순서 및 발송량에 따라 발송완료까지 최소 2시간~ 최대 1일 정도 소요될 수 있습니다.<br>
                          예) 1만통 기준 : (준비시간 10분 + 발송시간 10분 + 네트워크 상황 변수 + 10분) x 대기중인 캠페인 수 = 예상 소요 시간
                        <span class="br"></span>
                        <strong>외부노출가능 이미지 제한</strong>
                        <span class="br2"></span>
                        - [이미지 호스팅] 서비스를 이용해야 이미지 첨부 사용이 가능합니다.
                        <span class="br"></span>
                        <strong>발송전 트래픽 용량 확인</strong>
                        <span class="br2"></span>
                        - [이미지 호스팅 플러스]와 [웹FTP 오픈 호스팅] 서비스는 트래픽이 발생되오니, 잔여 트래픽을 꼭 확인하고 발송하시기 바랍니다.<br>
                          (트래픽 초과 시 이미지가 차단됩니다.)
                    </div>
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="sendEmailInsert">발송하기</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>