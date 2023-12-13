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
    <t:putAttribute name="title">회원 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            $(document).ready(function() {
                NewMemberUtil.init();
                NewMemberUtil.getNewMemberAnlsList();

                // 기간 radio
                $('input:radio[name=periodGb]').on('change', function () {
                    NewMemberUtil.setPeriodSelect($(this).val());
                });

                // month select
                $('#selectMonth').on('change', function () {
                    NewMemberUtil.setSelectDay(false);
                });

                // year select
                $('#selectYear').on('change', function () {
                    NewMemberUtil.setSelectYear();
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    NewMemberUtil.getNewMemberAnlsList();
                });
            });

            var NewMemberUtil = {
                today: new Date(),
                chart: undefined,
                init: function () {
                    NewMemberUtil.setSelectYear();
                    NewMemberUtil.setSelectMonth();
                    NewMemberUtil.setSelectDay(true);
                },
                setPeriodSelect: function (value) {
                    switch(value) {
                        case 'T':
                            $('.mb30').text('시간별 신규회원 현황');
                            $('.comHr').text('시간별');
                            $('#select1').show();
                            $('#select2').show();
                            $('#select3').show();
                            break;
                        case 'D':
                            $('.mb30').text('일별 신규회원 현황');
                            $('.comHr').text('일별');
                            $('#select1').show();
                            $('#select2').show();
                            $('#select3').hide();
                            break;
                        case 'M':
                            $('.mb30').text('월별 신규회원 현황');
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
                        yearData = NewMemberUtil.today.getFullYear();
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
                        month = String(NewMemberUtil.today.getMonth() + 1).padStart(2, '0');
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
                        var day = String(NewMemberUtil.today.getDay()).padStart(2, '0');
                        $('#selectDay option[value='+ day +']').attr('selected', true);
                    }
                },
                getNewMemberAnlsList: function () {
                    var url = '/admin/statistics/newmember-status', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var labelArr = [];

                        var nwCnt = [];
                        var nwTotCnt = 0;

                        var webCnt = [];
                        var webTotCnt = 0;

                        var appCnt = [];
                        var appTotCnt = 0;
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

                                nwCnt.push('0');
                                webCnt.push('0');
                                appCnt.push('0');

                                tr +=
                                    '<tr>' +
                                    '<td>'+ (label + text) +'</td>' +
                                    '<td class="comma">0</td>' +
                                    '<td class="comma">0</td>' +
                                    '<td class="comma">0</td>' +
                                    '</tr>';
                            } else {
                                if(item.label == label) {
                                    labelArr.push(item.label + text);

                                    nwCnt.push(item.nwJonrCnt);
                                    webCnt.push(item.pcJonrCnt);
                                    appCnt.push(item.mobileJonrCnt);

                                    nwTotCnt += Number(item.nwJonrCnt);
                                    webTotCnt += Number(item.pcJonrCnt);
                                    appTotCnt += Number(item.mobileJonrCnt);

                                    tr +=
                                        '<tr>' +
                                        '<td>'+ (item.label + text) +'</td>' +
                                        '<td class="comma">'+ item.nwJonrCnt +'</td>' +
                                        '<td class="comma">'+ item.pcJonrCnt +'</td>' +
                                        '<td class="comma">'+ item.mobileJonrCnt +'</td>' +
                                        '</tr>';

                                    cnt++;
                                } else {
                                    labelArr.push(label + text);

                                    nwCnt.push('0');
                                    webCnt.push('0');
                                    appCnt.push('0');

                                    tr +=
                                        '<tr>' +
                                        '<td>'+ (label + text) +'</td>' +
                                        '<td class="comma">0</td>' +
                                        '<td class="comma">0</td>' +
                                        '<td class="comma">0</td>' +
                                        '</tr>';
                                }
                            }
                        }

                        if(tr == '') {
                            tr = '<tr><td colspan="4">데이터가 없습니다.</td></tr>';
                        } else {
                            tr +=
                                '<tr>' +
                                '<td class="bbray">합계</td>' +
                                '<td class="bbray comma">'+ nwTotCnt +'</td>' +
                                '<td class="bbray comma">'+ webTotCnt +'</td>' +
                                '<td class="bbray comma">'+ appTotCnt +'</td>' +
                                '</tr>';
                        }

                        $('#tbody_id_nwMemberAnlsList').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.common.comma();

                        NewMemberUtil.drawChart(labelArr, nwCnt, webCnt, appCnt);
                    });
                    return dfd.promise();
                },
                drawChart: function (labelData, newData, webData, appData) {
                    var data = {
                        labels: labelData,
                        datasets: [
                            {
                                type: 'line',
                                label: '신규',
                                data: newData,
                                fill: false,
                                borderWidth: 2,
                                borderColor: "#bdbdbd",
                                pointBackgroundColor: "#bdbdbd",
                                pointBorderColor: "#bdbdbd",
                                pointRadius: 3,
                                pointHoverRadius: 2,
                                pointHoverBackgroundColor: '#fff',
                            },
                            {
                                type: 'bar',
                                label: 'WEB',
                                data: webData,
                                borderColor: "#0135c2",
                                backgroundColor: "#0135c2",
                                maxBarThickness: 15,
                            },
                            {
                                type: 'bar',
                                label: 'APP',
                                data: appData,
                                borderColor: "#0f2154",
                                backgroundColor: "#0f2154",
                                maxBarThickness: 15,
                            }
                        ]
                    };
                    var options = {
                        plugins: {
                            legend: {
                                display: false,
                                position: "top",
                                align: "end",
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
                                titleFont: { family: "noto" },
                                bodyFont: { weight: "400", family: "noto" },
                                yAlign: "bottom",
                                xAlign: "center",
                                callbacks: {
                                },
                            },
                        },
                        scales: {
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
                        }
                    };

                    if(!NewMemberUtil.chart) {
                        var config = {
                            type: 'bar',
                            data: data,
                            options: options
                        };

                        NewMemberUtil.chart = new Chart($('#canvas'), config);
                    } else {
                        NewMemberUtil.chart.data = data;
                        NewMemberUtil.chart.options = options;
                        NewMemberUtil.chart.update('none');
                    }
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box statistics">
            <div class="tlt_box">
                <div class="tlt_head">
                    통계<span class="step_bar"></span> 회원 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">신규 회원</h2>
            </div>
            <div class="search_box_wrap">
                <form:form action="/admin/statistics/newmember-status" id="form_id_search" commandName="nwMemberSO">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 방문자 분석표입니다. 구성은 시간별, 일별, 월별등의 기간검색 입니다.">
                            <caption>신규 회원 분석 기간검색</caption>
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
                <div class="line_box">
                    <div id="tab-2con" class="tab-2con">
                        <h3 class="mb30">시간별 신규회원 현황</h3>
                        <div class="chart_ttl_wrap">
                            <p class="chart_ttl mr20"><em></em>신규가입자수</p>
                            <p class="chart_ttl mr20"><span class="bg_c3"></span>WEB</p>
                            <p class="chart_ttl"><span class="bg_c7"></span>APP</p>
                        </div>
                        <canvas id="canvas" height="80"></canvas>
                        <div class="top_lay">
                            <div class="select_btn_right">
                                <button class="btn_exl">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <table summary="이표는 신규 회원분석 리스트 표 입니다. 구성은 시간별, 신규가입자수,PC, 모바일 입니다.">
                                <caption>판매상품관리 리스트</caption>
                                <colgroup>
                                    <col width="25%">
                                    <col width="25%">
                                    <col width="25%">
                                    <col width="25%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="comHr">시간별</th>
                                    <th>신규가입자 수</th>
                                    <th>PC</th>
                                    <th>모바일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_nwMemberAnlsList">
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