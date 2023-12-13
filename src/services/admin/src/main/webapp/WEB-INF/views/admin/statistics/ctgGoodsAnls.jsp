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
    <t:putAttribute name="title">상품 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                CtgGoodsAnls.init();

                // 1차 카테고리 select
                $('#sel_pop_ctg_1').on('change', function () {
                    CtgGoodsAnls.changeOptionValue('2', $(this));
                    CtgGoodsAnls.changeOptionValue('3', $(this));
                    CtgGoodsAnls.changeOptionValue('4', $(this));
                });

                // 2차 카테고리 select
                $('#sel_pop_ctg_2').on('change', function () {
                    CtgGoodsAnls.changeOptionValue('3', $(this));
                    CtgGoodsAnls.changeOptionValue('4', $(this));
                });

                // 3차 카테고리 select
                $('#sel_pop_ctg_3').on('change', function () {
                    CtgGoodsAnls.changeOptionValue('4', $(this));
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    $('#hd_page').val('1');
                    CtgGoodsAnls.getCtgGoodsList();
                });
            });

            var CtgGoodsAnls = {
                init: function () {
                    CtgGoodsAnls.getOptionValue('1', $('#sel_pop_ctg_1'));

                    $('#hd_page').val('1');
                    CtgGoodsAnls.getCtgGoodsList();
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
                getCtgGoodsList: function () {
                    var url = '/admin/statistics/category-rank-status', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td>{{rank}}</td>' +
                                '<td></td>' +
                                '<td>{{largeClsfNm}} > {{mediumClsfNm}}</td>' +
                                '<td>{{allSaleQtt}}</td>' +
                                '<td class="comma">{{allSaleAmt}}</td>' +
                                '<td>{{reviewCnt}}</td>' +
                                '<td>{{pcSaleQtt}}</td>' +
                                '<td class="comma">{{pcSaleAmt}}</td>' +
                                '<td>{{mobileSaleQtt}}</td>' +
                                '<td class="comma">{{mobileSaleAmt}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = "<tr><td colspan='10'>데이터가 없습니다.</td></tr>";
                        }

                        $('#tbody_id_ctgGoodsAnlsList').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging("form_id_search", "div_id_paging", result, "paging_id_ctgGoodsAnls", CtgGoodsAnls.getCtgGoodsList);

                        Dmall.common.comma();
                    });
                    return dfd.promise();
                },
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    통계<span class="step_bar"></span> 상품 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">카테고리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/category-rank-status" id="form_id_search" commandName="ctgGoodsSO">
                        <form:hidden path="page" id="hd_page"/>
                        <input type="hidden" name="periodGb" value="M">
                        <input type="hidden" name="yr" value="2022">
                        <div class="search_box">
                            <div class="search_tbl">
                                <table summary="이표는 회원 마켓포인트 분석표 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                    <caption>카테고리 상품 분석 기간검색입니다.</caption>
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
                                    </tbody>
                                </table>
                            </div>
                            <div class="btn_box txtc">
                                <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                            </div>
                        </div>
                    </form:form>
                </div>
                <div class="line_box">
                    <div class="tab-2con">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3" style="float: left;">카테고리 인기순위 현황</h3>
                            </div>
                            <div class="select_btn_right">
                                <button class="btn_exl" id="btn_download">
                                    <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                                </button>
                            </div>
                        </div>
                        <div style="clear: both;"></div>
                        <div class="tblh th_l tblmany">
                            <table summary="이표는 일별 카테고리 인기순위 결과 표 입니다. 구성은 순위,구분, 전체,pc,모바일 입니다.">
                                <caption>카테고리 인기순위 리스트</caption>
                                <colgroup>
                                    <col width="8%" />
                                    <col width="10%" />
                                    <col width="20%" />
                                    <col width="8%" />
                                    <col width="10%" />
                                    <col width="8%" />
                                    <col width="8%" />
                                    <col width="10%" />
                                    <col width="8%" />
                                    <col width="10%" />
                                </colgroup>
                                <thead class="thin">
                                <tr>
                                    <th rowspan="2">순위</th>
                                    <th rowspan="2">상품군</th>
                                    <th rowspan="2">카테고리</th>
                                    <th class="line_b" colspan="3">전체</th>
                                    <th class="line_b" colspan="2">WEB</th>
                                    <th class="line_b" colspan="2">APP</th>
                                </tr>
                                <tr>
                                    <th class="line_l">판매수량</th>
                                    <th>판매금액</th>
                                    <th>후기</th>
                                    <th>판매수량</th>
                                    <th>판매금액</th>
                                    <th>판매수량</th>
                                    <th>판매금액</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_ctgGoodsAnlsList">
                                </tbody>
                            </table>
                        </div>
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_paging"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>