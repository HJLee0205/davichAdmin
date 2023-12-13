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
    <t:putAttribute name="title">SMS 자동 발송 내역 > SMS > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                $('button.btn_day').eq(0).click();
                smsAutoSendHistSet.getList();

                //숫자, 하이폰(-) 만 입력가능
                $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});

                // 검색
                $('#searchBtn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('조회기간 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#auto_page').val('1');
                    smsAutoSendHistSet.getList();
                });

                // 상태
                $(document).on('click', 'a.tbl_link', function(e){
                    var rowNum = $(this).parents('tr').data('row-num');
                    var recverId = $(this).parents('tr').data('receiver-id');
                    var recveTelNo = $(this).parents('tr').data('recv-telno');
                    var sendWords = $(this).parents('tr').find("textarea.sendWords").val();
                    var frsltstatnm = $(this).parents('tr').data('frsltstatnm');

                    $('#pop_rowNum').text(rowNum);
                    $("#pop_receiverId").text(recverId);
                    $("#pop_recvTel").text(recveTelNo);
                    $("#pop_sendMsg").html(sendWords.replaceAll('\n', '<br>'));
                    $('#pop_sendRslt').text(frsltstatnm);

                    Dmall.LayerPopupUtil.open($("#smsUseInfo"));
                });
            });

            var smsAutoSendHistSet = {
                smsAutoSendHist: [],
                getList: function() {
                    var url = '/admin/operation/sms/sendHistory', dfd = $.Deferred();
                    // var url = 'https://www.davichmarket.com/smsEmail/sms/autoSendHistory', dfd = $.Deferred();
                    // var url = 'http://localhost:8082/smsEmail/sms/autoSendHistory', dfd = $.Deferred();
                    var param = $('#form_sms_auto_hist_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-row-num="{{sortNum}}" ' +
                                'data-receiver-id="{{receiverId}}" ' +
                                'data-recv-telno="{{recvTelno}}" ' +
                                'data-frsltstatnm="{{rslt}}">' +
                                '<td>{{sortNum}}</td>' +
                                '<td>{{sendFrmNm}}</td>' +
                                '<td>{{sendDttm}}</td>' +
                                '<td>{{frsltdate}}</td>' +
                                '<td>{{recvTelno}}</td>' +
                                '<td>{{sendTelno}}</td>' +
                                '<td>{{resultCd}}</td>' +
                            '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            if (obj.frsltstatnm == '성공') {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="tbl_link" >' + obj.rslt + '</a>';
                            } else if (obj.frsltstatnm == '실패') {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="tbl_link" >' + obj.rslt + '</a>';
                            } else {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="tbl_link" >' + obj.rslt + '</a>';
                            }

                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_smsAutoSendHist').html(tr);
                        smsAutoSendHistSet.smsAutoSendHist = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_sms_auto_hist_search','div_auto_hist_paging',result,'paging_smsAutoSentHist',smsAutoSendHistSet.getList);

                        $("#cnt_total").text(result.filterdRows);
                    });
                    return dfd.promise();
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> SMS<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">SMS 자동 발송 내역</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_sms_auto_hist_search">
                    <input type="hidden" name="page" id="auto_page" value="1" />
                    <input type="hidden" name="rows" id="auto_rows" value="" />
                    <input type="hidden" name="autoSendYn" id="autoSendYn" value="Y" />
                    <input type="hidden" name="siteNo" id="siteNo" value="${smsSendSo.siteNo}" />
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 SMS 자동발송 내역 검색 표 입니다. 구성은 조회기간, 상태, 검색어 입니다.">
                                <caption>SMS 자동발송 내역 검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>조회기간</th>
                                    <td>
                                        <tags:calendar from="startDt" to="endDt" fromValue="" toValue="" idPrefix="srch" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>발송유형</th>
                                    <td>
                                        <tags:radio codeStr=":전체;02:LMS;01:SMS" name="sendFrmCd" idPrefix="sendFrmCd" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>발송상태</th>
                                    <td>
                                        <tags:radio codeStr=":전체;3:성공;4:실패" name="status" idPrefix="resultCd" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>수신자 전화번호</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" name="recvTelno" maxlength="13" datetimeOnly>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>발신자 전화번호</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" name="sendTelno" maxlength="13" datetimeOnly>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button class="btn green" type="button" id="searchBtn">검색</button>
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
                            <table summary="이표는 SMS 자동발송 내역 표 입니다. 구성은  입니다.">
                                <caption>SMS 자동발송 내역</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="15%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>유형</th>
                                    <th>발송시간</th>
                                    <th>실제 발송 시간</th>
                                    <th>수신 번호</th>
                                    <th>회신 번호</th>
                                    <th>상태</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_smsAutoSendHist">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                            <div class="pageing" id="div_auto_hist_paging"></div>
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                    </div>
                    <!-- //line_box -->
                </form>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/admin/operation/sms/SmsUseInfo.jsp"/>
    </t:putAttribute>
</t:insertDefinition>