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
                OrdSttcsUtil.init();

                // 1차 카테고리 select
                $('#sel_pop_ctg_1').on('change', function () {
                    OrdSttcsUtil.changeOptionValue('2', $(this));
                    OrdSttcsUtil.changeOptionValue('3', $(this));
                    OrdSttcsUtil.changeOptionValue('4', $(this));
                });

                // 2차 카테고리 select
                $('#sel_pop_ctg_2').on('change', function () {
                    OrdSttcsUtil.changeOptionValue('3', $(this));
                    OrdSttcsUtil.changeOptionValue('4', $(this));
                });

                // 3차 카테고리 select
                $('#sel_pop_ctg_3').on('change', function () {
                    OrdSttcsUtil.changeOptionValue('4', $(this));
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    OrdSttcsUtil.getOrdSttcsAnlsList();
                });
            });

            var OrdSttcsUtil = {
                init: function () {
                    OrdSttcsUtil.getOptionValue('1', $('#sel_pop_ctg_1'));

                    OrdSttcsUtil.getOrdSttcsAnlsList();
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
                getOrdSttcsAnlsList: function () {
                    var url = '/admin/statistics/order-status-statistics', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var totalTr =
                            '<tr>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totBuyrCnt +'</td>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totBuyCnt +'</td>' +
                            '<td class="comma">'+ result.extraData.resultListTotalSum[0].totSaleAmt +'</td>' +
                            '</tr>';

                        $("#tbody_id_ordSttcsAnlsTotalSum").html(totalTr);

                        var template =
                                '<tr>' +
                                '<td>{{rank}}</td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td>{{allBuyrCnt}}</td>' +
                                '<td>{{allBuyCnt}}</td>' +
                                '<td class="comma">{{allSaleAmt}}</td>' +
                                '<td>{{pcBuyrCnt}}</td>' +
                                '<td>{{pcBuyCnt}}</td>' +
                                '<td class="comma">{{pcSaleAmt}}</td>' +
                                '<td>{{mobileBuyrCnt}}</td>' +
                                '<td>{{mobileBuyCnt}}</td>' +
                                '<td class="comma">{{mobileSaleAmt}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr += '<tr><td colspan="12">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_ordSttcsAnlsList').html(tr);
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
                <h2 class="tlth2">주문통계</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/order-status-statistics" id="form_id_search" commandName="ordSttcsSO">
                        <input type="hidden" name="periodGb" id="periodGb"/>
                        <input type="hidden" name="yr" id="yr"/>
                        <input type="hidden" name="mm" id="mm"/>
                        <input type="hidden" name="dd" id="dd"/>
                        <input type="hidden" name="eqpmGbCd" id="eqpmGbCd"/>

                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 주문통계 분석표 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                <caption>주문통계 기간검색입니다.</caption>
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
                    <div>
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 ...입니다.">
                                <caption>주문통계 리스트</caption>
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
                        <div class="top_lay">
                            <h3 class="tlth3">주문 현황</h3>
                            <div class="select_btn_right">
                                <button class="btn_exl" id="btn_download">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <!-- tblh -->
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 주문통계표 입니다. 구성은 pc주문, 모바일주문, 수기주문에 대한 구매자수, 구매건수, 판매금액 입니다.">
                                <caption>주문통계 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="17%">
                                    <col width="15%">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                    <col width="">
                                </colgroup>
                                <thead class="thin">
                                <tr>
                                    <th rowspan="2" class="comHr">순위</th>
                                    <th rowspan="2" class="comHr">카테고리</th>
                                    <th rowspan="2" class="comHr">상품명</th>
                                    <th class="line_b" colspan="3">전체</th>
                                    <th class="line_b" colspan="3">WEB 주문</th>
                                    <th class="line_b" colspan="3">APP 주문</th>
                                </tr>
                                <tr>
                                    <th>구매자수</th>
                                    <th>구매건수</th>
                                    <th>판매금액</th>
                                    <th>구매자수</th>
                                    <th>구매건수</th>
                                    <th>판매금액</th>
                                    <th>구매자수</th>
                                    <th>구매건수</th>
                                    <th>판매금액</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_ordSttcsAnlsList">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>