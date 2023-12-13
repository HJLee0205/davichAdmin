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
    <t:putAttribute name="title">SMS 발송 내역 > SMS > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                $('button.btn_day').eq(0).click();
                smsIndividualSendHistSet.getList();

                //숫자, 하이폰(-) 만 입력가능
                $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});

                // 검색
                $('#btn_id_smsSendHist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_recv_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_recv_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('조회기간 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#hd_page').val('1');
                    smsIndividualSendHistSet.getList();
                });

                // 상태
                $(document).on('click', 'a.btn_colnor', function(e){
                    var rowNum = $(this).parents('tr').data('row-num');
                    var recverId = $(this).parents('tr').data('receiver-id');
                    var recveTelNo = $(this).parents('tr').data('recv-telno');
                    var frsltstatnm = $(this).parents('tr').data('frsltstatnm');
                    var sendWords = $(this).parents('tr').find("textarea.sendWords").val();

                    $('#pop_rowNum').text(rowNum);
                    $("#pop_receiverId").text(recverId);
                    $("#pop_recvTel").text(recveTelNo);
                    $("#pop_sendMsg").html(sendWords.replaceAll('\n', '<br>'));
                    $('#pop_sendRslt').text(frsltstatnm);
                    Dmall.LayerPopupUtil.open($("#smsUseInfo"));
                });
            });

            var smsIndividualSendHistSet = {
                smsIndividualSendHist : [],
                getList : function() {
                    var url = '/admin/operation/sms/sendHistory', dfd = $.Deferred();
                    // var url = 'https://www.davichmarket.com/smsEmail/sms/history',dfd = $.Deferred();
                    // var url = 'http://localhost:8082/smsEmail/sms/history',dfd = $.Deferred();
                    var param = $('#form_sms_hist_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                                '<tr data-row-num="{{sortNum}}" ' +
                                'data-receiver-id = "{{receiverId}}" ' +
                                'data-recv-telno = "{{recvTelno}}" ' +
                                'data-frsltstatnm = "{{rslt}}" >'+
                                '<td>{{sortNum}}</td>' +
                                '<td>{{senderId}}</td>' +
                                '<td>{{receiverId}}</td>' +
                                '<td>{{receiverNm}}</td>'+
                                '<td>{{recvTelno}}</td>' +
                                '<td>{{sendDttm}}</td>' +
                                '<td>{{resultCd}}</td>' +
                                '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function (idx, obj) {
                            if (obj.frsltstatnm == '성공') {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="btn_colnor b1" >' + obj.rslt + '</a>';
                            } else if (obj.frsltstatnm == '실패') {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="btn_colnor r1" >' + obj.rslt + '</a>';
                            } else {
                                obj.resultCd = '<textarea class="sendWords" style="display: none;">'+obj.sendWords+'</textarea>' +
                                    '<a href="#none" class="btn_colnor" >' + obj.rslt + '</a>';
                            }

                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_smsIndividualSendHist').html(tr);
                        smsIndividualSendHistSet.smsIndividualSendHist = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_sms_hist_search', 'div_hist_paging', result, 'paging_smsIndividualSentHist',smsIndividualSendHistSet.getList);

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
                <h2 class="tlth2">SMS 발송 내역</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_sms_hist_search">
                    <input type="hidden" name="page" id="hd_page" value="1">
                    <input type="hidden" name="sord" id="hd_srod" value="">
                    <input type="hidden" name="autoSendYn" id="autoSendYn" value="N">
                    <input type="hidden" name="siteNo" id="siteNo" value="1">
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 SMS 자동발송 내역 검색 표 입니다. 구성은 조회기간, 상태, 검색어 입니다.">
                                <caption>SMS 자동발송 내역 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>조회기간</th>
                                    <td>
                                        <tags:calendar from="startDt" to="endDt" idPrefix="srch_recv"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <tags:radio codeStr=":전체;3:성공;4:실패" name="status" idPrefix="status" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>수신자 ID</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" id="receiverId" name="receiverId">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>수신자 전화번호</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" id="recvTelno" name="recvTelno" maxlength="13" datetimeOnly>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button type="button" class="btn green" id="btn_id_smsSendHist">검색</button>
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
                            <table summary="이표는 SMS 발송내역 표 입니다. 구성은 번호, 관리자ID, 수신자ID, 수신자 이름, 전화번호, 발송일, 발송 상태 입니다.">
                                <caption>SMS 발송내역</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="15%">
                                    <col width="15%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="20%">
                                    <col width="15%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>발송자ID</th>
                                    <th>수신자ID</th>
                                    <th>수신자이름</th>
                                    <th>전화번호</th>
                                    <th>발송일</th>
                                    <th>상태</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_smsIndividualSendHist">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                            <div class="pageing" id="div_hist_paging"></div>
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                    </div>
                </form>
            </div>
        </div>
        <%@ include file="SmsUseInfo.jsp" %>
    </t:putAttribute>
</t:insertDefinition>