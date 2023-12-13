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
                GoodsRsvAnlsUtil.init();

                // 1차 카테고리 select
                $('#sel_pop_ctg_1').on('change', function () {
                    GoodsRsvAnlsUtil.changeOptionValue('2', $(this));
                    GoodsRsvAnlsUtil.changeOptionValue('3', $(this));
                    GoodsRsvAnlsUtil.changeOptionValue('4', $(this));
                });

                // 2차 카테고리 select
                $('#sel_pop_ctg_2').on('change', function () {
                    GoodsRsvAnlsUtil.changeOptionValue('3', $(this));
                    GoodsRsvAnlsUtil.changeOptionValue('4', $(this));
                });

                // 3차 카테고리 select
                $('#sel_pop_ctg_3').on('change', function () {
                    GoodsRsvAnlsUtil.changeOptionValue('4', $(this));
                });

                // 검색
                $('#btn_id_search').on('click', function () {
                    $('#hd_page').val('1');
                    GoodsRsvAnlsUtil.getGoodsRsvList();
                });
            });

            var GoodsRsvAnlsUtil = {
                init: function () {
                    GoodsRsvAnlsUtil.getOptionValue('1', $('#sel_pop_ctg_1'));

                    $('#hd_page').val('1');
                    GoodsRsvAnlsUtil.getGoodsRsvList();
                },
                changeOptionValue: function (level, $target) {
                    var $sel = $('#sel_pop_ctg_'+level),
                        $label = $('label[for=sel_pop_ctg_'+ level +']');

                    $sel.find('option').not(':first').remove();
                    $label.text($sel.find('option:first').text());

                    if(level && level == '2' && $target.attr('id') == 'sel_pop_ctg_1') {
                        GoodsRsvAnlsUtil.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '3' && $target.attr('id') == 'sel_pop_ctg_2') {
                        GoodsRsvAnlsUtil.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '4' && $target.attr('id') == 'sel_pop_ctg_3') {
                        GoodsRsvAnlsUtil.getOptionValue(level, $sel, $target.val());
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
                getGoodsRsvList: function () {
                    var url = '/admin/statistics/', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td class="comma"></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma"></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td><button class="btn_gray">보기</button></td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = "<tr><td colspan='12'>데이터가 없습니다.</td></tr>";
                        }

                        $('#tbody_id_goodsRsvAnlsAll').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging("form_id_search", "div_id_pagingAll", result, "paging_id_goodsRsvAnlsAll", GoodsRsvAnlsUtil.getGoodsRsvList);

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
                    통계<span class="step_bar"></span> 상품 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">예약순위</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form action="" id="form_id_search">
                        <input type="hidden" name="page" id="hd_page">
                        <div class="search_tbl">
                            <table>
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
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form>
                </div>
                <div class="line_box">
                    <div class="sub_tab tab_lay2">
                        <ul>
                            <li class="tab-2 mr20 on"><a href="#tab1"><span class="ico_comm"></span>전체</a></li>
                            <li class="tab-2 mr20"><a href="#tab2"><span class="ico_comm"></span>WEB</a></li>
                            <li class="tab-2"><a href="#tab3"><span class="ico_comm"></span>APP</a></li>
                        </ul>
                    </div>

                    <div class="tab-2con" id="tab1">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3" style="float: left;">예약 순위 현황</h3>
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
                            <table summary="이표는 일별 판매순위 상품분석 결과 표 입니다. 구성은 판매순위, 상품명, 판매수량, 판매금액, 재고, 가용,장바구니, 관심상품,리뷰 입니다.">
                                <caption>판매상품 인기순위 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="25%">
                                    <col width="">
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
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>상품명</th>
                                    <th>옵션</th>
                                    <th>상품금액</th>
                                    <th>예약건수</th>
                                    <th>판매수량</th>
                                    <th>실 매출</th>
                                    <th>재고</th>
                                    <th>장바구니</th>
                                    <th>찜하기</th>
                                    <th>후기</th>
                                    <th>내역</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_goodsRsvAnlsAll">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingAll"></div>
                        </div>
                    </div>

                    <div class="tab-2con" id="tab2" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3" style="float: left;">예약 순위 현황</h3>
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
                            <table summary="이표는 일별 판매순위 상품분석 결과 표 입니다. 구성은 판매순위, 상품명, 판매수량, 판매금액, 재고, 가용,장바구니, 관심상품,리뷰 입니다.">
                                <caption>카테고리 인기순위 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="25%">
                                    <col width="">
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
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>상품명</th>
                                    <th>옵션</th>
                                    <th>상품금액</th>
                                    <th>예약건수</th>
                                    <th>판매수량</th>
                                    <th>실 매출</th>
                                    <th>재고</th>
                                    <th>장바구니</th>
                                    <th>찜하기</th>
                                    <th>후기</th>
                                    <th>내역</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_goodsRsvAnlsWeb">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingWeb"></div>
                        </div>
                    </div>

                    <div class="tab-2con" id="tab3" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3" style="float: left;">예약 순위 현황</h3>
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
                            <table summary="이표는 일별 판매순위 상품분석 결과 표 입니다. 구성은 판매순위, 상품명, 판매수량, 판매금액, 재고, 가용,장바구니, 관심상품,리뷰 입니다.">
                                <caption>카테고리 인기순위 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="25%">
                                    <col width="">
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
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>상품명</th>
                                    <th>옵션</th>
                                    <th>상품금액</th>
                                    <th>예약건수</th>
                                    <th>판매수량</th>
                                    <th>실 매출</th>
                                    <th>재고</th>
                                    <th>장바구니</th>
                                    <th>찜하기</th>
                                    <th>후기</th>
                                    <th>내역</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_goodsRsvAnlsApp">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingApp"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>