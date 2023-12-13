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
                VstrAnlsUtil.init();
                VstrAnlsUtil.getVstrAnlsList();

                // 기간 radio
                $('input:radio[name=periodGb]').on('change', function () {
                    VstrAnlsUtil.setPeriodSelect($(this).val());
                });

                // month select
                $('#selectMonth').on('change', function () {
                    VstrAnlsUtil.setSelectDay(false);
                });

                // year select
                $('#selectYear').on('change', function () {
                    VstrAnlsUtil.setSelectYear();
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    VstrAnlsUtil.getVstrAnlsList();
                });
            });

            var VstrAnlsUtil = {
                today: new Date(),
                chart: undefined,
                init: function () {
                    VstrAnlsUtil.setSelectYear();
                    VstrAnlsUtil.setSelectMonth();
                    VstrAnlsUtil.setSelectDay(true);
                },
                setPeriodSelect: function (value) {
                    switch(value) {
                        case 'T':
                            $('.mb30').text('시간별 현황');
                            $('.comHr').text('시간별');
                            $('#select1').show();
                            $('#select2').show();
                            $('#select3').show();
                            break;
                        case 'D':
                            $('.mb30').text('일별 현황');
                            $('.comHr').text('일별');
                            $('#select1').show();
                            $('#select2').show();
                            $('#select3').hide();
                            break;
                        case 'M':
                            $('.mb30').text('월별 현황');
                            $('.comHr').text('월별');
                            $('#select1').show();
                            $('#select2').hide();
                            $('#select3').hide();
                            break;
                    }
                },
                setSelectYear: function () {
                    var yearData = 0;

                    var yearVal = $('#selectYear option:selected').val();
                    if(!yearVal) {
                        yearData = VstrAnlsUtil.today.getFullYear();
                    } else {
                        yearData = Number(yearVal);
                    }

                    $('#selectYear').html('');
                    for(var i = yearData-4; i < yearData+5; i++) {
                        $('#selectYear').prepend('<option value="'+ i +'">'+ i +'년</option>');
                    }

                    $('#selectYear option[value='+ yearData +']').attr('selected', true);
                },
                setSelectMonth: function () {
                    var month = '';

                    var monthVal = $('#selectMonth option:selected').val();
                    if(!monthVal) {
                        month = String(VstrAnlsUtil.today.getMonth() + 1).padStart(2, '0');
                    } else {
                        month = monthVal;
                    }

                    for(var i = 1; i < 13; i++) {
                        var text = String(i).padStart(2, '0');
                        $('#selectMonth').append('<option value="'+ text +'">'+ text +'월</option>');
                    }

                    $('#selectMonth option[value='+ month +']').attr('selected', true);
                },
                setSelectDay: function (init) {
                    var maxDay = 0;

                    var yearVal = $('#selectYear option:selected').val();
                    var monthVal = $('#selectMonth option:selected').val();
                    if(monthVal == "02"){
                        // 윤달 계산
                        if((yearVal % 4 ==0 && yearVal % 100 != 0) || yearVal % 400 == 0 ){
                            maxDay = 29;
                        }else{
                            maxDay = 28;
                        }
                    }else if(monthVal == "04" || monthVal == "06" || monthVal == "09" || monthVal == "11"){
                        maxDay = 30;
                    }else{
                        maxDay = 31;
                    }

                    $('#selectDay').html('');
                    for(var i = 1; i <= maxDay; i++) {
                        var text = String(i).padStart(2, '0');
                        $('#selectDay').append('<option value="'+ text +'">'+ text +'일</option>');
                    }

                    if(init) {
                        var day = String(VstrAnlsUtil.today.getDay()).padStart(2, '0');
                        $('#selectDay option[value='+ day +']').attr('selected', true);
                    }
                },
                getVstrAnlsList: function () {
                    var eqpmGbCd = $('.tab-2.on').children('a').attr('href');
                    switch(eqpmGbCd) {
                        case '#tab1':
                            $('#eqpmGbCd').val('');
                            break;
                        case '#tab2':
                            $('#eqpmGbCd').val('11');
                            break;
                        case '#tab3':
                            $('#eqpmGbCd').val('12');
                            break;
                    }

                    var url = '/admin/statistics/contacts-status', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var labelArr = [];

                        var vstrCnt = [];
                        var vstrTotCnt = 0;

                        var pageVw = [];
                        var pageVwTotCnt = 0;
                        var periodGb = $('input:radio[name=periodGb]:checked').val();

                        var loop = 0;
                        var text = '';
                        switch(periodGb) {
                            case 'T':
                                loop = 24;
                                text = '시';
                                break;
                            case 'D':
                                loop = $('#selectDay').children().length;
                                text = '일';
                                break;
                            case 'M':
                                loop = 12;
                                text = '월';
                                break;
                        }

                        var cnt = 0;
                        var tr = '';
                        for(var i = 0; i < loop; i++) {
                            var item = result.resultList[cnt];

                            var label = '';
                            if(periodGb == 'T') {
                                label = String(i).padStart(2, '0');
                            } else {
                                label = String(i + 1).padStart(2, '0');
                            }

                            if(result.resultList.length == cnt) {
                                labelArr.push(label + text);

                                vstrCnt.push('0');

                                pageVw.push('0');

                                tr +=
                                    '<tr>' +
                                    '<td>'+ (label + text) +'</td>' +
                                    '<td class="comma">0</td>' +
                                    '<td class="comma">0</td>' +
                                    '</tr>';
                            } else {
                                if(item.label == label) {
                                    labelArr.push(item.label + text);

                                    vstrCnt.push(item.vstrCnt);
                                    vstrTotCnt += Number(item.vstrCnt);

                                    pageVw.push(item.pageVw);
                                    pageVwTotCnt += Number(item.pageVw);

                                    tr +=
                                        '<tr>' +
                                        '<td>'+ (item.label + text) +'</td>' +
                                        '<td class="comma">'+ item.vstrCnt +'</td>' +
                                        '<td class="comma">'+ item.pageVw +'</td>' +
                                        '</tr>';

                                    cnt++;
                                } else {
                                    labelArr.push(label + text);

                                    vstrCnt.push('0');

                                    pageVw.push('0');

                                    tr +=
                                        '<tr>' +
                                        '<td>'+ (label + text) +'</td>' +
                                        '<td class="comma">0</td>' +
                                        '<td class="comma">0</td>' +
                                        '</tr>';
                                }
                            }
                        }

                        if(tr == '') {
                            tr = '<tr><td colspan="3">데이터가 없습니다.</td></tr>';
                        } else {
                            tr +=
                                '<tr>' +
                                '<td class="bbray">합계</td>' +
                                '<td class="bbray comma">'+ vstrTotCnt +'</td>' +
                                '<td class="bbray comma">'+ pageVwTotCnt +'</td>' +
                                '</tr>';
                        }

                        $('#tbody_id_vstrAnlsListAll').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.common.comma();

                        VstrAnlsUtil.drawChart(labelArr, vstrCnt, pageVw);
                    });

                    return dfd.promise();
                },
                drawChart: function (labelData, vstrData, pageData) {
                    var data = {
                        labels: labelData,
                        datasets: [
                            {
                                type: "line",
                                label: "방문자수",
                                data: vstrData,
                                fill: false,
                                borderWidth: 2,
                                borderColor: "#0135c2",
                                pointBackgroundColor: "#0135c2",
                                pointBorderColor: "#0135c2",
                                pointRadius: 3,
                                pointHoverRadius: 3,
                                pointHoverBackgroundColor: '#fff',
                                pointHoverBorderColor: '#0135c2',
                                lineTension: 0.3,
                            },
                            {
                                type: "line",
                                label: "페이지뷰",
                                data: pageData,
                                fill: false,
                                borderWidth: 2,
                                borderColor: "#9e9e9e",
                                pointBackgroundColor: "#9e9e9e",
                                pointRadius: 3,
                                pointHoverRadius: 3,
                                pointHoverBackgroundColor: '#fff',
                                lineTension: 0.3,
                            }
                        ]
                    };
                    var options = {
                        plugins: {
                            legend: {
                                display: false,
                                position: "end",
                                align: "top",
                                labels: {
                                    font: {
                                        size: 12,
                                        family: "Lato",
                                    },
                                },
                            },
                            tooltip: {
                                backgroundColor: "#000",
                                titleColor: "#fff",
                                bodyColor: "#fff",
                                borderColor: "#e5e5e5",
                                borderWidth: 1,
                                cornerRadius:0,
                                displayColors: false,
                                colorBox: false,
                                padding: 10,
                                bodyFontSize: 14,
                                titleFontSize: 14,
                                cornerRadius: 0,
                                opacity: 0.8,
                                titleFont: { weight: "400", family: "Roboto" },
                                bodyFont: { weight: "400", family: "Roboto" },
                                yAlign: "bottom",
                                xAlign: "center",
                                callbacks: {
                                },
                            },
                        },
                        scales: {
                            // x축
                            x: {
                                grid: {
                                    display: false,
                                },
                                ticks: {
                                    color: "#222",
                                    font: {
                                        size: 12,
                                        family: "roboto",
                                    },
                                },
                            },
                            // y 축
                            y: {
                                min: 0,
                                ticks: {
                                    stepSize: 5000,
                                    color: "#222",
                                    font: {
                                        size: 12,
                                        family: "roboto",
                                    },
                                    beginAtZero: true,
                                    userCallback: function(value, index, values) {
                                        return value.toLocaleString();   // this is all we need
                                    }
                                },
                                grid: {
                                    color: "#e5e5e5",
                                },
                            },
                        },
                    };

                    if(!VstrAnlsUtil.chart) {
                        var config = {
                            type: 'line',
                            data: data,
                            options: options,
                        };

                        VstrAnlsUtil.chart = new Chart($('#canvasAll'), config);
                    } else {
                        VstrAnlsUtil.chart.data = data;
                        VstrAnlsUtil.chart.options = options;
                        VstrAnlsUtil.chart.update('none');
                    }
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
                <h2 class="tlth2">방문자 분석</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/contacts-status" id="form_id_search" commandName="vstrSO">
                        <input type="hidden" name="eqpmGbCd" id="eqpmGbCd" value="">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 방문자 분석표입니다. 구성은 시간별, 일별, 월별등의 기간검색 입니다.">
                                <caption>방문자 분석 기간검색</caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th rowspan="2">기간</th>
                                    <td>
                                        <tags:radio name="periodGb" idPrefix="srch_id_periodSelect" codeStr="T:시간별;D:일별;M:월별" value="T" />
                                    </td>
                                </tr>
                                <tr>
                                    <td id="selectId">
                                        <span class="select" id="select1">
                                            <select name="yr" id="selectYear"></select>
                                        </span>
                                        <span class="select" id="select2">
                                            <select name="mm" id="selectMonth"></select>
                                        </span>
                                        <span class="select" id="select3">
                                            <select name="dt" id="selectDay"></select>
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
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
                        <h3 class="mb30">시간별 현황</h3>
                        <div class="chart_ttl_wrap">
                            <p class="chart_ttl mr20"><span></span>방문자수</p>
                            <p class="chart_ttl"><span></span>페이지뷰</p>
                        </div>
                        <div class="box_graph mb60" id="box_graphAll">
                            <canvas id="canvasAll" height="80"></canvas>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <!--div class="scroll"-->
                            <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                                <caption>판매상품관리 리스트</caption>
                                <colgroup>
                                    <col width="33%">
                                    <col width="33%">
                                    <col width="33%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="comHr">시간별</th>
                                    <th>방문자수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_vstrAnlsListAll">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                    </div>

                    <!-- PC -->
                    <div id="tab2" class="tab-2con" style="display:none;">
                        <h3 class="mb30">시간별 현황</h3>
                        <div class="chart_ttl_wrap">
                            <p class="chart_ttl mr20"><span></span>방문자수</p>
                            <p class="chart_ttl"><span></span>페이지뷰</p>
                        </div>
                        <div class="box_graph mb60" id="box_graphPC">
                            <canvas id="canvasPC" height="80"></canvas>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <!--div class="scroll"-->
                            <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                                <caption>판매상품관리 리스트</caption>
                                <colgroup>
                                    <col width="33%">
                                    <col width="33%">
                                    <col width="33%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="comHr">시간별</th>
                                    <th>방문자수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_vstrAnlsListPC">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                    </div>

                    <!-- 모바일 -->
                    <div id="tab3" class="tab-2con" style="display:none;">
                        <h3 class="mb30">시간별 현황</h3>
                        <div class="chart_ttl_wrap">
                            <p class="chart_ttl mr20"><span></span>방문자수</p>
                            <p class="chart_ttl"><span></span>페이지뷰</p>
                        </div>
                        <div class="box_graph mb60" id="box_graphMobile">
                            <canvas id="canvasMobile" height="80"></canvas>
                        </div>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <!--div class="scroll"-->
                            <table summary="이표는 판매상품관리 리스트 표 입니다. 구성은 선택, 번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                                <caption>판매상품관리 리스트</caption>
                                <colgroup>
                                    <col width="33%">
                                    <col width="33%">
                                    <col width="33%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="comHr">시간별</th>
                                    <th>방문자수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_vstrAnlsListMobile">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>