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
    <t:putAttribute name="title">매출 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                SalesSttcsUtil.init();
                
                // 1차 카테고리 select
                $('#sel_pop_ctg_1').on('change', function () {
                    SalesSttcsUtil.changeOptionValue('2', $(this));
                    SalesSttcsUtil.changeOptionValue('3', $(this));
                    SalesSttcsUtil.changeOptionValue('4', $(this));
                });

                // 2차 카테고리 select
                $('#sel_pop_ctg_2').on('change', function () {
                    SalesSttcsUtil.changeOptionValue('3', $(this));
                    SalesSttcsUtil.changeOptionValue('4', $(this));
                });

                // 3차 카테고리 select
                $('#sel_pop_ctg_3').on('change', function () {
                    SalesSttcsUtil.changeOptionValue('4', $(this));
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    SalesSttcsUtil.getSalesSttcsAnlsList();
                });
            });
            
            var SalesSttcsUtil = {
                init: function () {
                    SalesSttcsUtil.getOptionValue('1', $('#sel_pop_ctg_1'));

                    SalesSttcsUtil.getSalesSttcsAnlsList();
                },
                changeOptionValue: function (level, $target) {
                    var $sel = $('#sel_pop_ctg_'+level),
                        $label = $('label[for=sel_pop_ctg_'+ level +']');

                    $sel.find('option').not(':first').remove();
                    $label.text($sel.find('option:first').text());

                    if(level && level == '2' && $target.attr('id') == 'sel_pop_ctg_1') {
                        CtgGoodsAnls.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '3' && $target.attr('id') == 'sel_pop_ctg_2') {
                        CtgGoodsAnls.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '4' && $target.attr('id') == 'sel_pop_ctg_3') {
                        CtgGoodsAnls.getOptionValue(level, $sel, $target.val());
                    } else {
                        return;
                    }
                },
                getOptionValue: function (ctgLvl, $sel, upCtgNo) {
                    if(ctgLvl != '1' && upCtgNo == '') {
                        return;
                    }

                    var url = '/admin/goods/goods-category-list', dfd = $.Deferred(),
                        param = {'upCtgNo':upCtgNo, 'ctgLvl':ctgLvl};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        if(result == null || result.success != true) {
                            return;
                        }
                        $sel.find('option').not(':first').remove();
                        $.each(result.resultList, function (idx, obj) {
                            $sel.append('<option id="opt_ctg_'+ ctgLvl +'_'+ idx +'" value="'+ obj.ctgNo +'">'+ obj.ctgNm +'</option>')
                        });
                        dfd.resolve(result.resultList);
                    });
                    return dfd.promise();
                },
                getSalesSttcsAnlsList: function () {
                    var url = '/admin/statistics/sales-statistics-stauts', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var totalTr =
                            '<tr>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totBuyrCnt +'</td>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totSalesAmt +'</td>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totSaleAmt +'</td>' +
                            '</tr>';

                        $('#tbody_id_ordSttcsAnlsTotalSum').html(totalTr);

                        var template =
                                '<tr>' +
                                '<td>{{rank}}</td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td>{{paymentCnt}}</td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma">{{paymentAmt}}</td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma">{{realPaymentAmt}}</td>' +
                                '<td class="comma">{{returnRefundAmt}}</td>' +
                                '<td class="comma">{{cancelRefundAmt}}</td>' +
                                '<td class="comma">{{refundAmt}}</td>' +
                                '<td class="comma">{{salesAmt}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr += '<tr><td colspan="14">데이터가 없습니다.</td></tr>';
                        }

                        $("#tbody_id_saleSttcsAnlsListAll").html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.common.comma();
                    });
                    return dfd.promise();
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box statistics">
            <div class="tlt_box">
                <div class="tlt_head">
                    통계<span class="step_bar"></span> 매출 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">매출통계</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/sales-statistics-stauts" id="form_id_search" commandName="salesSttcsSO">
                        <input type="hidden" name="periodGb" id="periodGb"/>
                        <input type="hidden" name="yr" id="yr"/>
                        <input type="hidden" name="mm" id="mm"/>
                        <input type="hidden" name="dd" id="dd"/>
                        <input type="hidden" name="eqpmGbCd" id="eqpmGbCd"/>

                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 매출통계 분석표 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                <caption>매출통계 기간검색입니다.</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="searchFrom" to="searchTo" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>카테고리</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_pop_ctg_1">1차 카테고리</label>
                                            <select name="searchCtg1" id="sel_pop_ctg_1">
                                                <option id="opt_ctg_1_def" value="">1차 카테고리</option>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="sel_pop_ctg_2">2차 카테고리</label>
                                            <select name="searchCtg2" id="sel_pop_ctg_2">
                                                <option id="opt_ctg_2_def" value="">2차 카테고리</option>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="sel_pop_ctg_3">3차 카테고리</label>
                                            <select name="searchCtg3" id="sel_pop_ctg_3">
                                                <option id="opt_ctg_3_def" value="">3차 카테고리</option>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="sel_pop_ctg_4">4차 카테고리</label>
                                            <select name="searchCtg4" id="sel_pop_ctg_4">
                                                <option id="opt_ctg_4_def" value="">4차 카테고리</option>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>주문 방식</th>
                                    <td>
                                        <tags:radio codeStr=":전체;01:택배;02:픽업;03:오프라인 구매" name="ordWay" idPrefix="ordWay" value=""/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td>
                                        <label for="" class="intxt w100p">
                                            <input type="text">
                                        </label>
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
                    <div class="tblh th_l tblmany">
                        <table summary="이표는 ...입니다.">
                            <caption>매출통계 리스트</caption>
                            <colgroup>
                                <col width="33%">
                                <col width="34%">
                                <col width="33%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>총 구매자수</th>
                                <th>총 구매건수</th>
                                <th>총 판매금액</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_ordSttcsAnlsTotalSum">
                            </tbody>
                        </table>
                    </div>

                    <div class="tab_lay2_wrap">
                        <div class="sub_tab tab_lay2">
                            <ul>
                                <li class="tab-2 mr20 on"><a href="#tab1"><span class="ico_comm"></span>전체</a></li>
                                <li class="tab-2 mr20"><a href="#tab2"><span class="ico_comm"></span>WEB</a></li>
                                <li class="tab-2 mr20"><a href="#tab3"><span class="ico_comm"></span>APP</a></li>
                                <li class="tab-2"><a href="#tab4"><span class="ico_comm"></span>오프라인</a></li>
                            </ul>
                        </div>
                        <div class="tab-2con" id="tab1">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <h3 class="tlth3">매출 현황</h3>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_exl">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh th_l tblmany">
                                <table summary="이표는 매출통계 입니다. 구성은 결제금액, 환불금액에 따른 결제금액, 쿠폰할인, 기타할인,실결제금액,반품, 취소, 환불액 내역 입니다.">
                                    <caption>매출통계 리스트</caption>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="20%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead class="thin">
                                    <tr>
                                        <th rowspan="2" class="comHr">순위</th>
                                        <th rowspan="2" class="comHr">카테고리</th>
                                        <th rowspan="2" class="comHr">상품명</th>
                                        <th rowspan="2" class="comHr">주문방식</th>
                                        <th class="line_b" colspan="6">결제금액</th>
                                        <th class="line_b" colspan="3">환불금액</th>
                                        <th rowspan="2">매출액</th>
                                    </tr>
                                    <tr>
                                        <th>결제자 수</th>
                                        <th>결제당 금액</th>
                                        <th>결제 금액</th>
                                        <th>포인트 할인</th>
                                        <th>배송비</th>
                                        <th>실결제금액(합계)</th>
                                        <th>반품</th>
                                        <th>취소</th>
                                        <th>합계</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_id_saleSttcsAnlsListAll">
                                    </tbody>
                                </table>
                            </div>
                            <!-- //tblh -->
                        </div>

                        <div class="tab-2con" id="tab2" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <h3 class="tlth3">매출 현황</h3>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_exl">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh th_l tblmany">
                                <table summary="이표는 매출통계 입니다. 구성은 결제금액, 환불금액에 따른 결제금액, 쿠폰할인, 기타할인,실결제금액,반품, 취소, 환불액 내역 입니다.">
                                    <caption>매출통계 리스트</caption>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="20%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead class="thin">
                                    <tr>
                                        <th rowspan="2" class="comHr">순위</th>
                                        <th rowspan="2" class="comHr">카테고리</th>
                                        <th rowspan="2" class="comHr">상품명</th>
                                        <th rowspan="2" class="comHr">주문방식</th>
                                        <th class="line_b" colspan="6">결제금액</th>
                                        <th class="line_b" colspan="3">환불금액</th>
                                        <th rowspan="2">매출액</th>
                                    </tr>
                                    <tr>
                                        <th>결제자 수</th>
                                        <th>결제당 금액</th>
                                        <th>결제 금액</th>
                                        <th>포인트 할인</th>
                                        <th>배송비</th>
                                        <th>실결제금액(합계)</th>
                                        <th>반품</th>
                                        <th>취소</th>
                                        <th>합계</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_id_saleSttcsAnlsListPC">
                                    </tbody>
                                </table>
                            </div>
                            <!-- //tblh -->
                        </div>

                        <div class="tab-2con" id="tab3" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <h3 class="tlth3">매출 현황</h3>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_exl">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh th_l tblmany">
                                <table summary="이표는 매출통계 입니다. 구성은 결제금액, 환불금액에 따른 결제금액, 쿠폰할인, 기타할인,실결제금액,반품, 취소, 환불액 내역 입니다.">
                                    <caption>매출통계 리스트</caption>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="20%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead class="thin">
                                    <tr>
                                        <th rowspan="2" class="comHr">순위</th>
                                        <th rowspan="2" class="comHr">카테고리</th>
                                        <th rowspan="2" class="comHr">상품명</th>
                                        <th rowspan="2" class="comHr">주문방식</th>
                                        <th class="line_b" colspan="6">결제금액</th>
                                        <th class="line_b" colspan="3">환불금액</th>
                                        <th rowspan="2">매출액</th>
                                    </tr>
                                    <tr>
                                        <th>결제자 수</th>
                                        <th>결제당 금액</th>
                                        <th>결제 금액</th>
                                        <th>포인트 할인</th>
                                        <th>배송비</th>
                                        <th>실결제금액(합계)</th>
                                        <th>반품</th>
                                        <th>취소</th>
                                        <th>합계</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_id_saleSttcsAnlsListMobile">
                                    </tbody>
                                </table>
                            </div>
                            <!-- //tblh -->
                        </div>

                        <div class="tab-2con" id="tab4" style="display: none;">
                            <div class="top_lay">
                                <div class="select_btn_left">
                                    <h3 class="tlth3">매출 현황</h3>
                                </div>
                                <div class="select_btn_right">
                                    <button class="btn_exl">
                                        <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                    </button>
                                </div>
                            </div>
                            <div style="clear: both;"></div>
                            <!-- tblh -->
                            <div class="tblh th_l tblmany">
                                <table summary="이표는 매출통계 입니다. 구성은 결제금액, 환불금액에 따른 결제금액, 쿠폰할인, 기타할인,실결제금액,반품, 취소, 환불액 내역 입니다.">
                                    <caption>매출통계 리스트</caption>
                                    <colgroup>
                                        <col width="5%">
                                        <col width="20%">
                                        <col width="10%">
                                    </colgroup>
                                    <thead class="thin">
                                    <tr>
                                        <th rowspan="2" class="comHr">순위</th>
                                        <th rowspan="2" class="comHr">카테고리</th>
                                        <th rowspan="2" class="comHr">상품명</th>
                                        <th rowspan="2" class="comHr">주문방식</th>
                                        <th class="line_b" colspan="6">결제금액</th>
                                        <th class="line_b" colspan="3">환불금액</th>
                                        <th rowspan="2">매출액</th>
                                    </tr>
                                    <tr>
                                        <th>결제자 수</th>
                                        <th>결제당 금액</th>
                                        <th>결제 금액</th>
                                        <th>포인트 할인</th>
                                        <th>배송비</th>
                                        <th>실결제금액(합계)</th>
                                        <th>반품</th>
                                        <th>취소</th>
                                        <th>합계</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tbody_id_saleSttcsAnlsListOff">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>