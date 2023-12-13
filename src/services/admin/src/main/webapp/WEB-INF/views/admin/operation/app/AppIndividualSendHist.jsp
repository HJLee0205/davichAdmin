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
    <t:putAttribute name="title">발송내역 > 푸시알림 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            function viewPushDtl(pushNo) {
                Dmall.FormUtil.submit('/admin/operation/app/sendHistDtl', {pushNo: pushNo});
            }

            $(document).ready(function() {
                appSendHistSet.getList();

                //검색
                $('#btn_id_appSendHist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_recv_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_recv_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('조회기간 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#auto_page').val('1');
                    appSendHistSet.getList();
                });
            });

            var appSendHistSet = {
                appSendHist: [],
                getList: function() {
                    var url = '/admin/operation/app-history-list', dfd = $.Deferred();
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr>' +
                            '<td>{{rowNum}}</td>' +
                            '<td>{{senderNm}}</td>' +
                            '<td class="txtl"><a href="#none" class="push_key" onclick="javascript:viewPushDtl(\'{{pushNo}}\');">{{sendMsg}}</a></td>' +
                            '<td>{{sendCnt}}</td>' +
                            '<td>{{ordCnt}}</td>' +
                            '<td>{{visitCnt}}</td>' +
                            '<td>{{sendDttm}}</td>' +
                            '<td>{{resultCd}}</td>' +
                            '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            if(obj.pushStatusNm == '발송완료') {
                                obj.resultCd = '<a href="#none" class="btn_colnor b1">'+obj.pushStatusNm+'</a>';
                            } else if (obj.pushStatusNm == '발송취소') {
                                obj.resultCd = '<a href="#none" class="btn_colnor r1">'+obj.pushStatusNm+'</a>';
                            } else {
                                obj.resultCd = obj.pushStatusNm;
                            }

                            tr += managerGroup.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="8">데이터가 없습니다.</td></tr>'
                        }

                        $('#tbody_id_appIndividualSendHist').html(tr);
                        appSendHistSet.appSendHist = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search','div_hist_paging',result,'paging_appSendHist',appSendHistSet.getList);

                        $('#cnt_total').text(result.filterdRows);
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
                    운영 설정<span class="step_bar"></span> 푸시알림<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">발송내역</h2>
            </div>
            <div class="search_box_wrap">
                <form action="" id="form_id_search">
                    <input type="hidden" name="page" id="auto_page" value="1" />
                    <input type="hidden" name="rows" id="auto_rows" value="" />
                    <!-- search_box -->
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는  PUSH 발송 내역 검색 표 입니다. 구성은 조회기간, 상태, 검색어 입니다.">
                                <caption>PUSH 발송 내역 검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>조회기간</th>
                                    <td>
                                        <tags:calendar from="searchDateFrom" to="searchDateTo" fromValue="" toValue="" idPrefix="srch_recv" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>유형</th>
                                    <td>
                                        <span class="select">
                                            <label for="pushStatus"></label>
                                            <select name="pushStatus" id="pushStatus">
                                                <code:option codeGrp="PUSH_STATUS" includeTotal ="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>메세지 내용</th>
                                    <td>
                                        <span class="intxt w100p">
                                            <input type="text" id="sendMsg" name="sendMsg">
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                        <div class="btn_box txtc">
                            <button class="btn green" id="btn_id_appSendHist">검색</button>
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
                            <table summary="이표는 app 발송내역 표 입니다.">
                                <caption>app 발송내역</caption>
                                <colgroup>
                                    <col width="5%" />
                                    <col width="10%" />
                                    <col width="30%" />
                                    <col width="10%" />
                                    <col width="10%" />
                                    <col width="10%" />
                                    <col width="10%" />
                                    <col width="10%" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>발송인</th>
                                    <th>내용</th>
                                    <th>발송건수</th>
                                    <th>구매건수</th>
                                    <th>예약건수</th>
                                    <th>발송(예약)일시</th>
                                    <th>상태</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_appIndividualSendHist">
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
                    <!-- //line_box -->
                </form>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>