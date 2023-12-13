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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">방문 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            $(document).ready(function() {
                VisitPathUtil.getVisitpathAnlsList();

                // 검색
                $('#btn_id_search').on('click', function () {
                    VisitPathUtil.getVisitpathAnlsList();
                });
            });

            var VisitPathUtil = {
                getVisitpathAnlsList: function () {
                    var url = '/admin/statistics/visitpath-analysis', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        $('#box_graphAll > .tooltip_div').html('');
                        $('#box_graphAll > .stick_div').html('');
                        $('#box_graphAll > .name_div').html('');
                        $('#tbody_id_visitPathAnlsListAll').html('');

                        $.each(result.resultList, function (idx, obj) {
                            // tooltip
                            var template1 =
                                '<div class="chart_item--total chart_'+ idx +'" style="width: '+ obj.rto +'%">' +
                                '<div class="tooltip">'+ obj.visitPathNm +' <span class="status_data--total">'+ obj.rto +'%</span></div>' +
                                '</div>';
                            $('#box_graphAll > .tooltip_div').append(template1);
                            // stick
                            var template2 =
                                '<div class="chart_item2--total chart_'+ obj.cla +'" style="width: '+ obj.rto +'%"></div>';
                            $('#box_graphAll > .stick_div').append(template2);
                            // name
                            var template3 =
                                '<div class="name_'+ obj.cla +'"><span></span>'+ obj.visitPathNm +'</div>';
                            $('#box_graphAll > .name_div').append(template3);
                            // table
                            var template4 =
                                '<tr>' +
                                '<td>'+ (idx + 1) +'</td>' +
                                '<td>'+ obj.visitPathNm +'</td>' +
                                '<td class="comma">'+ obj.vstrCnt +'</td>' +
                                '<td>'+ obj.rto +'%</td>' +
                                '</tr>';
                            $('#tbody_id_visitPathAnlsListAll').append(template4);
                        });

                        Dmall.common.comma();
                    });
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box statistics">
            <div class="tlt_box">
                <div class="tlt_head">
                    통계<span class="step_bar"></span> 방문 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">방문 경로</h2>
            </div>
            <div class="search_box_wrap">
                <form action="" id="form_id_search">
                    <div class="search_box">
                        <div class="search_tbl">
                            <table>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchFrom" to="searchTo" idPrefix="srch"/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </div>
                </form>
                <div class="line_box">
                    <div class="sub_tab tab_lay2">
                        <ul>
                            <li class="tab-2 mr20 on"><a href="#tab1"><span class="ico_comm"></span>전체</a></li>
                            <li class="tab-2 mr20"><a href="#tab2"><span class="ico_comm"></span>WEB</a></li>
                            <li class="tab-2"><a href="#tab3"><span class="ico_comm"></span>APP</a></li>
                        </ul>
                    </div>
                    <!-- 전체 -->
                    <div id="tab1" class="tab-2con">
                        <h3>접속자 현황</h3>
                        <div class="box_graph" id="box_graphAll">
                            <div class="chart_item_wrap tooltip_div">
                            </div>
                            <div class="chart_item_wrap chart_item_color stick_div">
                            </div>
                            <div class="chart_name_wrap name_div">
                            </div>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div class="tblh">
                            <table>
                                <colgroup>
                                    <col width="60px" />
                                    <col width="" />
                                    <col width="" />
                                    <col width="" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>검색엔진</th>
                                    <th>방문자수</th>
                                    <th>비율</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitPathAnlsListAll">
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- WEB -->
                    <div id="tab2" class="tab-2con" style="display: none;">
                        <h3>접속자 현황</h3>
                        <div class="box_graph" id="box_graphWeb">
                            <div class="chart_item_wrap tooltip_div">
                            </div>
                            <div class="chart_item_wrap chart_item_color stick_div">
                            </div>
                            <div class="chart_name_wrap name_div">
                            </div>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div class="tblh">
                            <table>
                                <colgroup>
                                    <col width="60px" />
                                    <col width="" />
                                    <col width="" />
                                    <col width="" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>검색엔진</th>
                                    <th>방문자수</th>
                                    <th>비율</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitPathAnlsListWeb">
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- APP -->
                    <div id="tab3" class="tab-2con" style="display: none;">
                        <h3>접속자 현황</h3>
                        <div class="box_graph" id="box_graphApp">
                            <div class="chart_item_wrap tooltip_div">
                            </div>
                            <div class="chart_item_wrap chart_item_color stick_div">
                            </div>
                            <div class="chart_name_wrap name_div">
                            </div>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div class="tblh">
                            <table>
                                <colgroup>
                                    <col width="60px" />
                                    <col width="" />
                                    <col width="" />
                                    <col width="" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>검색엔진</th>
                                    <th>방문자수</th>
                                    <th>비율</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitPathAnlsListApp">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>