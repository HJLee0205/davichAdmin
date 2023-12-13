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
    <t:putAttribute name="title">대량메일 발송 내역</t:putAttribute>
    <t:putAttribute name="script">
<%--        <script>--%>
<%--            var groupCount = 0;--%>
<%--            function viewEmailInfo(emailSendNo,senderNm,senderEmail,sendStndrd,groupCnt,successCnt) {--%>
<%--                groupCount = groupCnt;--%>
<%--                Dmall.LayerPopupUtil.open($("#emailUseInfo"));--%>
<%--                openEmailUseInfoLayer(emailSendNo);--%>

<%--                //발송건수 set--%>
<%--                $("#emailSendCnt").text(groupCnt+"건");--%>

<%--                //실패건수 set--%>
<%--                //아직 발송 결과가 없는 경우--%>
<%--                if(successCnt == "-"){--%>
<%--                    $("#emailSendFailCnt").text(successCnt+"건");--%>
<%--                }else{--%>
<%--                    $("#emailSendFailCnt").text((groupCnt-successCnt)+"건");--%>
<%--                }--%>

<%--                //보내는사람 set--%>
<%--//     $("#senderTd").text(senderNm+"<br/>("+senderEmail+")");--%>


<%--            }--%>

<%--            jQuery(document).ready(function() {--%>
<%--                emailSendHistSet.getList();--%>

<%--                jQuery('#emailSendHistBtn').on('click', function(e){--%>
<%--                    var fromDttm = "";--%>
<%--                    var toDttm = "";--%>
<%--                    if($("#srch_recv_sc01").val() != null && $("#srch_recv_sc01").val() != ''){--%>
<%--                        fromDttm = $("#srch_recv_sc01").val().replace(/-/gi, "");--%>
<%--                    }--%>
<%--                    if($("#srch_recv_sc02").val() != null && $("#srch_recv_sc02").val() != ''){--%>
<%--                        toDttm = $("#srch_recv_sc02").val().replace(/-/gi, "");--%>
<%--                    }--%>

<%--                    if(fromDttm != "" && toDttm != ""){--%>
<%--                        if(fromDttm > toDttm){--%>
<%--                            Dmall.LayerUtil.alert('발송일 검색 시작 날짜가 종료 날짜보다 큽니다.');--%>
<%--                            return;--%>
<%--                        }--%>
<%--                    }--%>

<%--                    jQuery("#hd_page2").val("1");--%>
<%--                    emailSendHistSet.getList();--%>
<%--                });--%>

<%--                jQuery('#sel_rows2').on('change', function(e) {--%>
<%--                    jQuery('#hd_page2').val('1');--%>

<%--                    jQuery('#hd_rows2').val($(this).val());--%>
<%--                    emailSendHistSet.getList();--%>
<%--                });--%>

<%--                //메일 발송 이력 삭제--%>
<%--                $("#delSelectEmailSendHst").on('click', function(e) {--%>
<%--                    var delChk = $('input:checkbox[name=delEmailShotHst]').is(':checked');--%>
<%--                    if(delChk==false){--%>
<%--                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');--%>
<%--                        return;--%>
<%--                    }--%>
<%--                    Dmall.LayerUtil.confirm('Warning <br/> 삭제 시 복구가 어렵습니다 <br/> 정말로 삭제하시겠습니까?', delSendEmailHst);--%>
<%--                });--%>
<%--            });--%>

<%--            function delSendEmailHst(){--%>

<%--                var delChk = $('input:checkbox[name=delEmailShotHst]').is(':checked');--%>
<%--                if(delChk==false){--%>
<%--                    Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');--%>
<%--                    return;--%>
<%--                }--%>

<%--                var param = $('#form_email_hist').serialize();--%>

<%--                var url = Constant.smsemailServer + '/email/updateDelYn/'--%>
<%--                    ,dfd = jQuery.Deferred();--%>
<%--//    var url = 'http://localhost:8082/email/updateDelYn/';--%>
<%--//     var url = '/admin/operation/deleteMailSendHst.do';--%>

<%--                Dmall.AjaxUtil.getJSONP(url, param, function(result) {--%>
<%--                    if(result.success){--%>
<%--                        Dmall.LayerUtil.alert('삭제되었습니다.');--%>
<%--                        var param = {pageGb:"4"};--%>
<%--                        Dmall.FormUtil.submit('/admin/operation/bulk-mailing', param);--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>

<%--            var emailSendHistSet = {--%>
<%--                emailSendHist : [],--%>
<%--                getList : function(){--%>
<%--//         var url = '/admin/operation/email-autosend-list',dfd = jQuery.Deferred();--%>
<%--                    var url = Constant.smsemailServer + '/email/history/',dfd = jQuery.Deferred();--%>
<%--//        var url = 'http://localhost:8082/email/history/',dfd = jQuery.Deferred();--%>
<%--                    var param = jQuery('#form_email_hist').serialize();--%>

<%--                    Dmall.AjaxUtil.getJSONP(url, param, function(result) {--%>
<%--                        var template =--%>
<%--                                '<tr data-mail-send-no = "{{mailSendNo}}" data-send-dttm = "{{sendDttm}}" data-send-stnrd = "{{sendStndrd}}">'+--%>
<%--                                '<td><label for="chack" class="chack" >' +--%>
<%--                                '<span class="ico_comm"><input type="checkbox" name="delEmailShotHst" id="chack" class="blind" value="{{mailSendNo}}" /></span>' +--%>
<%--                                '</label></td>' +--%>
<%--                                '<td>{{rowNum}}</td>' +--%>
<%--                                '<td class="txtl">{{sendTitle}}</td>' +--%>
<%--                                '<td>{{SendStndrd}}<br/>({{groupCnt}}명)</td>'+--%>
<%--                                '<td>{{sendDttm}}</td>'+--%>
<%--                                //                 '<td>{{resultCd}}</td><td>{{successCnt}}건</td>',--%>
<%--                                '<td>{{resultCd}}</td><td>{{groupCnt}}건</td>',--%>
<%--                            managerGroup = new Dmall.Template(template),--%>
<%--                            tr = '';--%>

<%--                        jQuery.each(result.resultList, function(idx, obj) {--%>
<%--                            obj.sendTitle = '<a href="#none" class="tbl_link" onclick="viewEmailInfo(\''+obj.mailSendNo+'\',\''+obj.senderNm+'\',\''+obj.sendEmail+'\',\''+obj.sendStndrd+'\',\''+obj.groupCnt+'\',\''+obj.sucsCnt+'\');">'+obj.sendTitle+'</a>';--%>
<%--                            if(obj.resultCd=='06'){--%>
<%--                                obj.resultCd ='발송완료';--%>
<%--                            }else if(obj.resultCd=='03'){--%>
<%--                                obj.resultCd ='발송중';--%>
<%--                            }else if(obj.resultCd=='04'){--%>
<%--                                obj.resultCd ='예약';--%>
<%--                            }else{--%>
<%--                                obj.resultCd ='발송중';--%>
<%--//                     obj.resultCd ='실패';--%>
<%--                            }--%>

<%--                            tr += managerGroup.render(obj)--%>
<%--                        });--%>

<%--                        if(tr == '') {--%>
<%--                            tr = '<tr><td colspan="12">데이터가 없습니다.</td></tr>';--%>
<%--                        }--%>
<%--                        jQuery('#tbody_id_emailSendHist').html(tr);--%>
<%--                        emailSendHistSet.emailSendHist = result.resultList;--%>
<%--                        dfd.resolve(result.resultList);--%>

<%--                        Dmall.GridUtil.appendPaging('form_email_hist', 'div_mailSendhist_paging', result, 'paging_emailSentHist',--%>
<%--                            emailSendHistSet.getList);--%>

<%--                        $("#emailSendSelectCnt").text(result.filterdRows);--%>
<%--                        $("#emailSendTotalCnt").text(result.totalRows);--%>

<%--                        return;--%>
<%--                    });--%>
<%--                }--%>
<%--            }--%>
<%--        </script>--%>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 대량메일<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">대량메일 발송 내역</h2>
            </div>
            <form id="form_email_hist">
                <input type="hidden" name="page" id="hd_page2" value="1" />
                <input type="hidden" name="sord" id="hd_srod2" value="" />
                <input type="hidden" name="rows" id="hd_rows2" value="" />
                <input type="hidden" name="siteNo" value="" />
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 이메일 발송 내역 검색 표 입니다. 구성은 발송일, 검색어 입니다.">
                            <caption>이메일 발송 내역 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>발송일</th>
                                <td>
                                    <input type="hidden" value="2" id="pageGb" name = "pageGb">
                                    <tags:calendar from="startDt" to="endDt" fromValue="" toValue="" idPrefix="srch_hist" />
                                </td>
                            </tr>
                            <tr>
                                <th>상태</th>
                                <td>
                                    <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                    <tags:checkboxs name="resultCd" codeStr="03:발송중;04:예약;06:발송 완료" idPrefix="srch_id_resultCd" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" value="" id="searchWords" name="searchWords">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="emailSendHistBtn" type="button">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- line_box -->
                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 발송이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="이표는 이메일 발송 내역 검색 표 입니다. 구성은 발송일, 검색어 입니다.">
                            <caption>이메일 개별발송 내역</caption>
                            <colgroup>
                                <col width="6%">
                                <col width="6%">
                                <col width="48%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="emailShotHst" class="chack" >
                                        <span class="ico_comm"><input type="checkbox" name="table" id="emailShotHst" class="blind" /></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>대량메일 제목</th>
                                <th>받는사람</th>
                                <th>발송일시</th>
                                <th>상태</th>
                                <th>성공건수</th>
                            </tr>
                            </thead>
                            <tbody id = "tbody_id_emailSendHist">
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <!-- pageing -->
                        <div class="bottom_lay" id="div_mailSendhist_paging"></div>
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="delSelectEmailSendHst">선택 삭제</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>