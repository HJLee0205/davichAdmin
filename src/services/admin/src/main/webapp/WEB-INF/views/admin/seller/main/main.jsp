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
<t:insertDefinition name="sellerMainLayout">
	<t:putAttribute name="title">다비치마켓 판매자 메인</t:putAttribute>
	<t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
		<script type="text/javascript">
            $(document).ready(function() {
                // 주간 현황 탭 클릭
                $('ul.tabs li').click(function () {
                    $("ul.tabs li").removeClass("active").css("color", "#383838");
                    $(this).addClass("active").css("color", "#383838");
                    var activeTab = $(this).attr("rel");
                    $('#'+activeTab).show().siblings('div.tab_content').hide();
                });

                $(".tab_content").hide();
                $(".tab_content:first").show();

                drawChart();

                todayDataListener();

                $('button.btn_day').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $(this).addClass('on').siblings().removeClass('on');

                    var $this = $(this),
                        $from = $this.closest('div.main_select_btn').find('input.bell_date_sc:eq(0)'),
                        $to = $this.closest('div.main_select_btn').find('input.bell_date_sc:eq(1)'),
                        index = $this.index(),
                        from,
                        to = $to.val(),
                        date;

                    if($.trim(to) == '') {
                        date = new Date();
                        to = date.format('yyyy-MM-dd');
                    } else {
                        date = new Date($to.val().replace(/-/g, '/'));
                    }

                    switch(index) {
                        case 0 :
                            date = new Date();
                            from = date.format('yyyy-MM-dd');
                            to = date.format('yyyy-MM-dd');
                            break;
                        case 1 :
                            date.setDate(date.getDate() - 3);
                            break;
                        case 2 :
                            date.setDate(date.getDate() - 7);
                            break;
                        case 3 :
                            date.setMonth(date.getMonth() - 1);
                            break;
                        case 4 :
                            date.setMonth(date.getMonth() - 3);
                            break;
                        default :
                            from = '';
                            to = '';
                            break;
                    }

                    if(from != '') {
                        from = date.format('yyyy-MM-dd');
                    }

                    $from.val(from);
                    $to.val(to);

                    mallStatus();
                });

                $('input.bell_date_sc').on('hidden', function () {
                    mallStatus();
                });

                Dmall.common.comma();
            });

            function drawChart() {
                var thisWeek = $('#thisWeek').val();
                var param = { firstDayOfWeek: thisWeek };

                Dmall.AjaxUtil.getJSON('/admin/seller/main/week-status', param, function (result) {
                    // 주간 매출 현황
                    var chart1 = $('#chart1');
                    chart1.css('background-color', 'white');
                    var data1 = {
                        datasets: [{
                            type: 'line',
                            data: result.map(row => row.salesAmt),
                            fill: false,
                            borderWidth: 1,
                            borderColor: "#0135c2",
                            pointBackgroundColor: "#0135c2",
                            pointBorderColor: "#fff",
                            pointRadius: 3,
                            pointHoverRadius: 2,
                        },{
                            type: 'bar',
                            data: result.map(row => row.salesAmt),
                            borderColor: "#e5e5e5",
                            backgroundColor: "#e5e5e5",
                            maxBarThickness: 15,
                            hoverBackgroundColor: "#0135c2",
                            hoverBorderColor: "#0135c2",
                        }],
                        labels: result.map(row => row.dayOfWeek)
                    }
                    new Chart(chart1, {
                        data: data1,
                        options: {
                            responsive: true,
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
                                    mode: "index",
                                    intersect: false,
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
                                        label: function(tooltipItem, index) {
                                            // console.log(data.datasets[tooltipItem.datasetIndex]);
                                            var datasetLabel = data1.datasets[tooltipItem.datasetIndex].type;
                                            var value = data1.datasets[tooltipItem.datasetIndex].data[tooltipItem.dataIndex];
                                            console.log(tooltipItem.index)
                                            if (datasetLabel === 'line') {
                                                return value + '원'; // Dataset 1만 해당 데이터를 표시
                                            } else {
                                                return ''; // Dataset 2는 빈 문자열 반환
                                            }
                                        },
                                        title: function(tooltipItems, data) {
                                            return ''; // 타이틀을 빈 문자열로 반환하여 숨김
                                        },
                                        labelTextColor: function (tooltipItem) {
                                            var color;
                                            if (tooltipItem.datasetIndex === 0) {
                                                // color = "#ff81ad";
                                            } else {
                                                // color = "#3091ff";
                                            }
                                            return color;
                                        },
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
                                    ticks: {
                                        color: "#222",
                                        font: {
                                            size: 12,
                                            family: "roboto",
                                        },
                                        callback: function (value, index, ticks) {
                                            return value.toLocaleString('ko-KR') + "원";
                                        },
                                    },
                                    grid: {
                                        color: "#e5e5e5",
                                    },
                                },
                            },
                        }
                    });

                    // 주간 주문 현황
                    var chart2 = $('#chart2');
                    chart2.css('background-color', 'white');
                    var data2 = {
                        datasets: [{
                            type: 'line',
                            data: result.map(row => row.ordCnt),
                            fill: false,
                            borderWidth: 1,
                            borderColor: "#0135c2",
                            pointBackgroundColor: "#0135c2",
                            pointBorderColor: "#fff",
                            pointRadius: 3,
                            pointHoverRadius: 2,
                        }, {
                            type: 'bar',
                            data: result.map(row => row.ordCnt),
                            borderColor: "#e5e5e5",
                            backgroundColor: "#e5e5e5",
                            maxBarThickness: 15,
                            hoverBackgroundColor: "#0135c2",
                            hoverBorderColor: "#0135c2",
                        }],
                        labels: result.map(row => row.dayOfWeek)
                    }
                    new Chart(chart2, {
                        data: data2,
                        options: {
                            responsive: true,
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
                                    mode: "index",
                                    intersect: false,
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
                                        label: function(tooltipItem, index) {
                                            // console.log(data.datasets[tooltipItem.datasetIndex]);
                                            var datasetLabel = data2.datasets[tooltipItem.datasetIndex].type;
                                            var value = data2.datasets[tooltipItem.datasetIndex].data[tooltipItem.dataIndex];
                                            console.log(tooltipItem.index)
                                            if (datasetLabel === 'line') {
                                                return value + '건'; // Dataset 1만 해당 데이터를 표시
                                            } else {
                                                return ''; // Dataset 2는 빈 문자열 반환
                                            }
                                        },
                                        title: function(tooltipItems, data) {
                                            return ''; // 타이틀을 빈 문자열로 반환하여 숨김
                                        },
                                        labelTextColor: function (tooltipItem) {
                                            var color;
                                            if (tooltipItem.datasetIndex === 0) {
                                                // color = "#ff81ad";
                                            } else {
                                                // color = "#3091ff";
                                            }
                                            return color;
                                        },
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
                                    ticks: {
                                        color: "#222",
                                        font: {
                                            size: 12,
                                            family: "roboto",
                                        },
                                        callback: function (value, index, ticks) {
                                            return value.toLocaleString('ko-KR') + "건";
                                        },
                                    },
                                    grid: {
                                        color: "#e5e5e5",
                                    },
                                },
                            },
                        }
                    });
                });

                Dmall.AjaxUtil.getJSON('/admin/main/visit-path', {}, function(result) {
                    var chart5 = $('#chart5');
                    new Chart(chart5, {
                        type: 'doughnut',
                        data: {
                            datasets: [{
                                data: result.map(row => row.rto),
                                backgroundColor: ["#0135c2", "#0f2154", "#9e9e9e", "#e5e5e5"],
                                borderColor: ["#fff"],
                                borderWidth: 3,
                                scaleBeginAtZero: true,
                                cutout: "60%",
                                hoverBorderColor: ["#0135c2", "#0f2154", "#9e9e9e", "#e5e5e5"],
                                hoverBackgroundColor: ["#0135c2", "#0f2154", "#9e9e9e", "#e5e5e5"],
                                hoverOffset: 20,
                            }],
                            labels: result.map(row => row.visitPathNm)
                        },
                        options: {
                            cutoutPercentage: 0,
                            responsive: false,
                            radius: '90%',
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    mode: "index",
                                    intersect: false,
                                    backgroundColor: "#000",
                                    titleColor: "#fff",
                                    bodyColor: "#fff",
                                    borderColor: "#000",
                                    borderWidth: 1,
                                    cornerRadius:0,
                                    displayColors: false,
                                    colorBox: false,
                                    padding: 10,
                                    bodyFontSize: 0,
                                    titleFontSize: 14,
                                    titleFont: { family: "noto" },
                                    bodyFont: { weight: "400", family: "noto" },
                                    callbacks: {

                                    },
                                },
                            }
                        }
                    });
                });
            }

            function todayDataListener() {
                $('a.today_link').on('click', function () {
                    var id = $(this).attr('id');

                    switch (id) {
                        // 주문 / 배송
                        case 'todayPaymentCmpltCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '20' }, '_blank');
                            break;
                        case 'todayOrdCmpltCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '30' }, '_blank');
                            break;
                        case 'todayDlvrStartCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '30' }, '_blank');
                            break;
                        case 'todayStorePicCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { searchDlvrcPaymentCd: '04' }, '_blank');
                            break;
                        case 'todayRsvCnt':
                            var param = {
                                rsvDayS: '${todayDttm}',
                                rsvDayE: '${todayDttm}',
                                rsvType: 'G',
                                searchCd: '02'
                            }
                            Dmall.FormUtil.submit('/admin/order/reservation/reservation-info', param, '_blank');
                            break;
                        case 'todayDlvrReadyCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '30' }, '_blank');
                            break;
                        case 'todayDlvrPrcCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '40' }, '_blank');
                            break;
                        case 'todayDlvrCmpltCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '50' }, '_blank');
                            break;
                        // 클레임 / 정산
                        case 'todayPaymentCancelClaimCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/pay-cancel', { claimCd: '31' }, '_blank');
                            break;
                        case 'todayReturnClaimCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/refund', { claimCd: '11' }, '_blank');
                            break;
                        case 'todayExchangeClaimCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/exchange', { claimCd: '21' }, '_blank');
                            break;
                        case 'todayBuyCmpltCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '90' }, '_blank');
                            break;
                        case 'todayPartReturnCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '72' }, '_blank');
                            break;
                        case 'todayPartExchangeCnt':
                            Dmall.FormUtil.submit('/admin/seller/order/order-status', { ordDtlStatusCd: '62' }, '_blank');
                            break;
                    }
                });

            }

            function mallStatus() {
                var url = '/admin/main/mall-status',
                    param = {
                        stDate: $('#srch_sc01').val().replace(/-/gi,''),
                        endDate: $('#srch_sc02').val().replace(/-/gi,''),
                        sellerNo: '${so.sellerNo}'
                    };

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var template =
                            '<tr>' +
                            '<td>{{goodsTypeNm}}</td>' +
                            '<td class="comma">{{salesAmt}}</td>' +
                            '<td class="comma">{{paymentCmplt}}</td>' +
                            '<td class="comma">{{dlvrReady}}</td>' +
                            '<td class="comma">{{dlvrStart}}</td>' +
                            '<td class="comma">{{dlvrCmplt}}</td>' +
                            '<td class="comma">{{buyCmplt}}</td>' +
                            '<td><span class="comma" style="color: #ef2b2a;">{{ordCancel}}</span></td>' +
                            '<td><span class="comma" style="color: #ef2b2a;">{{ordExchange}}</span></td>' +
                            '<td><span class="comma" style="color: #ef2b2a;">{{ordRefund}}</span></td>' +
                            '<td class="comma">{{goodsReview}}</td>' +
                            '</tr>',
                        templateTot =
                            '<tr>' +
                            '<td class="bbray">{{goodsTypeNm}}</td>' +
                            '<td class="bbray comma">{{salesAmt}}</td>' +
                            '<td class="bbray comma">{{paymentCmplt}}</td>' +
                            '<td class="bbray comma">{{dlvrReady}}</td>' +
                            '<td class="bbray comma">{{dlvrStart}}</td>' +
                            '<td class="bbray comma">{{dlvrCmplt}}</td>' +
                            '<td class="bbray comma">{{buyCmplt}}</td>' +
                            '<td class="bbray comma">{{ordCancel}}</td>' +
                            '<td class="bbray comma">{{ordExchange}}</td>' +
                            '<td class="bbray comma">{{ordRefund}}</td>' +
                            '<td class="bbray comma">{{goodsReview}}</td>' +
                            '</tr>',
                        templateMgr = new Dmall.Template(template),
                        templateTotMgr = new Dmall.Template(templateTot),
                        tr = '';

                    $.each(result, function (idx, obj) {
                        if(result.length - 1 == idx) {
                            tr += templateTotMgr.render(obj);
                        } else {
                            tr += templateMgr.render(obj);
                        }
                    });

                    $('#tbody_mall_status').html(tr);

                    Dmall.common.comma();
                });
            }
		</script>
	</t:putAttribute>
	<t:putAttribute name="content">
        <div class="main_container">
            <div>
                <h3 class="tlth3">오늘 주문 / 배송</h3>
                <div class="main_top_box_group">
                    <div class="main_top_box main_box">
                        <div class="ico_main"><i class="icon_main01"></i></div>
                        <div class="sbox"><span>결제 완료</span><a id="todayPaymentCmpltCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayPaymentCmpltCnt}" /></em></a>건</div>
                        <div class="sbox"><span>주문 확정</span><a id="todayOrdCmpltCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayOrdCmpltCnt}" /></em></a>건</div>
                        <ul class="sbox_list" >
                            <li><span>오늘 출발</span><span><a id="todayDlvrStartCnt" class="today_link"><em class="fBlue"><fmt:formatNumber type="number" value="${TODAY.todayDlvrStartCnt}" /></em></a>건</span></li>
                        </ul>
                    </div>
                    <div class="main_top_box main_box">
                        <div class="ico_main"><i class="icon_main02"></i></div>
                        <div class="sbox"><span>배송 준비</span><a id="todayDlvrReadyCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayDlvrReadyCnt}" /></em></a>건</div>
                        <div class="sbox"><span>배송 중</span><a id="todayDlvrPrcCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayDlvrProgCnt}" /></em></a>건</div>
                        <div class="sbox"><span>배송 완료</span><a id="todayDlvrCmpltCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayDlvrCmpltCnt}" /></em></a>건</div>
                    </div>
                </div>
            </div>
            <div>
                <h3 class="tlth3">오늘 클레임 / 정산</h3>
                <div class="main_top_box_group">
                    <div class="main_top_box main_box">
                        <div class="ico_main"><i class="icon_main03"></i></div>
                        <div class="sbox"><span>취소 요청</span><a id="todayPaymentCancelClaimCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayPaymentCancelClaimCnt}" /></em></a>건</div>
                        <div class="sbox"><span>반품 요청</span><a id="todayReturnClaimCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayReturnClaimCnt}" /></em></a>건</div>
                        <div class="sbox"><span>교환 요청</span><a id="todayExchangeClaimCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayExchangeClaimCnt}" /></em></a>건</div>
                    </div>
                    <div class="main_top_box main_box">
                        <div class="ico_main"><i class="icon_main04"></i></div>
                        <div class="sbox"><span>구매 확정</span><a id="todayBuyCmpltCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayBuyCmpltCnt}" /></em></a>건</div>
                        <div class="sbox"><span>부분 환불 요청</span><a id="todayPartReturnCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayPartReturnCnt}" /></em></a>건</div>
                        <div class="sbox"><span>부분 교환 요청</span><a id="todayPartExchangeCnt" class="today_link"><em class="fBlue f25"><fmt:formatNumber type="number" value="${TODAY.todayPartExchangeCnt}" /></em></a>건</div>
                    </div>
                </div>
            </div>
            <div class="main_chart">
                <h3 class="tlth3">현황</h3>
                <div class="main_mid_box main_box">
                    <div class="main_date">
                        <input type="hidden" id="thisWeek" value="<fmt:formatDate value="${WEEK_LIST[0]}" pattern="yyyyMMdd" />">
                        <c:forEach var="week" items="${WEEK_LIST}" varStatus="status">
                            <c:if test="${status.index eq 0}">
                                <fmt:formatDate value="${week}" pattern="yyyy.MM.dd" /> ~
                                <spring:eval expression="T(org.apache.commons.lang.time.DateUtils).addDays(week, 6)" var="week" />
                                <fmt:formatDate value="${week}" pattern="yyyy.MM.dd"  />
                            </c:if>
                        </c:forEach>
                    </div>
                    <ul class="tabs">
                        <li rel="main_tab01_01" class="active">주간 매출현황</li>
                        <li rel="main_tab01_02" >주간 주문 현황</li>
                    </ul>
                    <div class="tab_content" id="main_tab01_01" style="display: block;">
                        <canvas id="chart1" height="80"></canvas>
                    </div>
                    <div class="tab_content" id="main_tab01_02" style="display: block;">
                        <canvas id="chart2" height="80"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="main_container">
            <div class="main_visit">
                <h3 class="tlth3">방문 경로 <span class="desc_txt f16"> (오전 9시 업데이트)</span></h3>
                <div class="main_top_box_group main_box">
                    <div class="main_top_box bornon pa0">
                        <div class="box_graph box_center">
                            <canvas id="chart5" width="220" height="220"></canvas>
                        </div>
                    </div>
                    <div class="main_top_box bornon pa0">
                        <div class="tblh">
                            <table summary="이표는 방문경로분석 표 입니다. 구성은 순위,검색엔진, 방문자수, 비율 입니다.">
                                <caption>검색엔진순위 리스트</caption>
                                <colgroup>
                                    <col width="20%">
                                    <col width="50%">
                                    <col width="30%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>검색엔진</th>
                                    <th>비율</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="visitPath" items="${VISIT_PATH}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>${visitPath.visitPathNm}</td>
                                        <td>${visitPath.rto}</td>
                                    </tr>
                                    <c:if test="${status.last}">
                                        <tr>
                                            <td colspan="2" class="bbray">합계</td>
                                            <td class="bbray">100</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="main_notice">
                <h3 class="tlth3">문의 / 공지사항</h3>
                <div class="main_box main_notice_box">
                    <div class="main_mid_box_2way_left">
                        <div class="tabs">
                            <span>판매자 문의</span>
                        </div>
                        <div class="mid_box_conts">
                            <ul class="notice_list">
                                <c:forEach var="one2oneInquiry" items="${ONE2ONE_INQUIRY}">
                                    <li>
                                        <a href="/admin/seller/setup/letter-update-form?lettNo=${one2oneInquiry.lettNo}&bbsId=sellQuestion">
                                            [<c:out value="${one2oneInquiry.replyStatusYnNm}"/>][<c:out value="${one2oneInquiry.inquiryNm}"/>]&nbsp;<c:out value="${one2oneInquiry.title}" escapeXml="true"/>
                                        </a>
                                        <span class="date"><fmt:formatDate value="${one2oneInquiry.regDttm}" pattern="yyyy.MM.dd"/></span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                        <a href="/admin/seller/setup/inquiry-list"><button type="button" class="btn_more">+ more</button></a>
                    </div>
                    <div class="main_mid_box_2way_right">
                        <div class="tabs">
                            <span>판매자 공지</span>
                        </div>
                        <div class="mid_box_conts">
                            <ul class="notice_list">
                                <c:forEach var="notice" items="${NOTICE_LIST}">
                                    <li>
                                        <a href="/admin/seller/setup/seller-bbs-detail?lettNo=${notice.lettNo}&bbsId=sellNotice">
                                            <c:out value="${notice.title}" escapeXml="true" />
                                        </a>
                                        <span class="date"><fmt:formatDate value="${notice.regDttm}" pattern="yyyy.MM.dd"/></span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                        <a href="/admin/seller/setup/notice-list"> <button type="button" class="btn_more">+ more</button></a>
                    </div>
                </div>
            </div>
        </div>
        <div class="main_container">
            <div class="main_review">
                <h3 class="tlth3">후기 <span class="desc_txt f16">(최근 7일 기준)</span> </h3>
                <div class="tblh h50 main_box">
                    <!--div class="scroll"-->
                    <table summary="이표는 최근 7일간의 후기 게시물노출표 입니다. 구성은 분류, 신규후기,낮은 점수 후기 높은 점수 후기, 합계입니다.">
                        <caption>후기 게시물노출표</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="25%">
                            <col width="25%">
                            <col width="25%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>분류</th>
                            <th>신규 후기</th>
                            <th>낮은 점수 후기</th>
                            <th>높은 점수 후기</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="review" items="${GOODS_REVIEW}" varStatus="status">
                            <tr>
                                <c:choose>
                                    <c:when test="${status.last}">
                                        <td class="bbray">${review.goodsTypeCd}</td>
                                        <td class="bbray">${review.recent}</td>
                                        <td class="bbray">${review.low}</td>
                                        <td class="bbray">${review.high}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <th>${review.goodsTypeCd}</th>
                                        <td>${review.recent}</td>
                                        <td>${review.low}</td>
                                        <td>${review.high}</td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <!--/div-->
                </div>
            </div>
            <div class="main_status">
                <h3 class="tlth3">쇼핑몰 운영 현황</h3>
                <div class="main_select_btn">
                    <tags:calendar from="stDate" to="endDate" fromValue="${so.stDate}" toValue="${so.endDate}" idPrefix="srch"/>
                </div>
                <div class="tblh main_box">
                    <table>
                        <colgroup>
                            <col width="9%">
                            <col width="11%">
                            <col width="11%">
                            <col width="9%">
                            <col width="9%">
                            <col width="9%">
                            <col width="9%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="9%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>분류</th>
                            <th>매출액(단위:원)</th>
                            <th>결제완료(단위:건)</th>
                            <th>배송준비</th>
                            <th>배송중</th>
                            <th>배송완료</th>
                            <th>구매확정</th>
                            <th>취소</th>
                            <th>교환</th>
                            <th>환불</th>
                            <th>상품 후기</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_mall_status">
                        <c:forEach var="mallStatus" items="${MALL_STATUS}" varStatus="status">
                            <tr>
                                <c:choose>
                                    <c:when test="${status.last}">
                                        <td class="bbray">${mallStatus.goodsTypeNm}</td>
                                        <td class="bbray comma">${mallStatus.salesAmt}</td>
                                        <td class="bbray comma">${mallStatus.paymentCmplt}</td>
                                        <td class="bbray comma">${mallStatus.dlvrReady}</td>
                                        <td class="bbray comma">${mallStatus.dlvrStart}</td>
                                        <td class="bbray comma">${mallStatus.dlvrCmplt}</td>
                                        <td class="bbray comma">${mallStatus.buyCmplt}</td>
                                        <td class="bbray comma">${mallStatus.ordCancel}</td>
                                        <td class="bbray comma">${mallStatus.ordExchange}</td>
                                        <td class="bbray comma">${mallStatus.ordRefund}</td>
                                        <td class="bbray comma">${mallStatus.goodsReview}</td>
                                    </c:when>
                                    <c:otherwise>
                                        <td>${mallStatus.goodsTypeNm}</td>
                                        <td class="comma">${mallStatus.salesAmt}</td>
                                        <td class="comma">${mallStatus.paymentCmplt}</td>
                                        <td class="comma">${mallStatus.dlvrReady}</td>
                                        <td class="comma">${mallStatus.dlvrStart}</td>
                                        <td class="comma">${mallStatus.dlvrCmplt}</td>
                                        <td class="comma">${mallStatus.buyCmplt}</td>
                                        <td><span style="color: #ef2b2a;" class="comma">${mallStatus.ordCancel}</span></td>
                                        <td><span style="color: #ef2b2a;" class="comma">${mallStatus.ordExchange}</span></td>
                                        <td><span style="color: #ef2b2a;" class="comma">${mallStatus.ordRefund}</span></td>
                                        <td class="comma">${mallStatus.goodsReview}</td>
                                    </c:otherwise>
                                </c:choose>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
