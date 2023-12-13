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
    <t:putAttribute name="title">상품 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                SaleRankGoodsUtil.init();

                // 1차 카테고리 select
                $('#sel_pop_ctg_1').on('change', function () {
                    SaleRankGoodsUtil.changeOptionValue('2', $(this));
                    SaleRankGoodsUtil.changeOptionValue('3', $(this));
                });

                // 2차 카테고리 select
                $('#sel_pop_ctg_2').on('change', function () {
                    SaleRankGoodsUtil.changeOptionValue('3', $(this));
                });

                // 검색
                $('#btn_id_search').on('click', function(e){
                    $('#hd_page').val('1');
                    SaleRankGoodsUtil.getSaleRankGoodsList();
                });
            });

            var SaleRankGoodsUtil = {
                init: function () {
                    SaleRankGoodsUtil.getOptionValue('1', $('#sel_pop_ctg_1'));

                    $('#hd_page').val('1');
                    SaleRankGoodsUtil.getSaleRankGoodsList();
                },
                changeOptionValue: function (level, $target) {
                    var $sel = $('#sel_pop_ctg_'+level),
                        $label = $('label[for=sel_pop_ctg_'+ level +']');

                    $sel.find('option').not(':first').remove();
                    $label.text($sel.find('option:first').text());

                    if(level && level == '2' && $target.attr('id') == 'sel_pop_ctg_1') {
                        SaleRankGoodsUtil.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '3' && $target.attr('id') == 'sel_pop_ctg_2') {
                        SaleRankGoodsUtil.getOptionValue(level, $sel, $target.val());
                    } else if(level && level == '4' && $target.attr('id') == 'sel_pop_ctg_3') {
                        SaleRankGoodsUtil.getOptionValue(level, $sel, $target.val());
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
                getSaleRankGoodsList: function () {
                    var url = '/admin/statistics/sales-rank-status', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td>{{rank}}</td>' +
                                '<td>{{goodsNm}}</td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td>{{favGoodsQtt}}</td>' +
                                '<td>{{basketQtt}}</td>' +
                                '<td class="comma">{{saleQtt}}</td>' +
                                '<td class="comma">{{saleAmt}}</td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td class="comma">{{stockQtt}}</td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td></td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = "<tr><td colspan='17'>데이터가 없습니다.</td></tr>";
                        }

                        $("#tbody_id_saleRankGoodsAnlsListAll").html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging("form_id_search", "div_id_pagingAll", result, "paging_id_saleRankGoodsAll", SaleRankGoodsUtil.getSaleRankGoodsList);

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
                    통계<span class="step_bar"></span> 상품 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매순위</h2>
            </div>
            <div class="search_box_wrap">
                <form:form action="/admin/statistics/sales-rank-status" id="form_id_search" commandName="saleRankGoodsSO">
                    <input type="hidden" name="periodGb" id="periodGb"/>
                    <input type="hidden" name="yr" id="yr"/>
                    <input type="hidden" name="mm" id="mm"/>
                    <input type="hidden" name="dd" id="dd"/>
                    <input type="hidden" name="page" id="hd_page" />
                    <input type="hidden" name="eqpmGbCd" id="eqpmGbCd"/>
                    <input type="hidden" name="anlsGbCd" id="anlsGbCd" value="1"/>
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 판매순위 상품 분석표 입니다. 구성은 일별, 월별등의 기간검색 입니다.">
                                <caption>판매순위 기간검색입니다.</caption>
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
                                    </td>
                                </tr>
                                <tr>
                                    <th>내 얼굴 정보</th>
                                    <td>
                                        <span class="select">
                                            <label for="searchFaceSize">안경추천사이즈</label>
                                            <select name="searchFaceSize" id="searchFaceSize">
                                                <option value="" selected="selected">안경추천사이즈</option>
                                                <code:optionUDV codeGrp="FACE_SIZE_CD" value=""/>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="searchFaceShape">얼굴형</label>
                                            <select name="searchFaceShape" id="searchFaceShape">
                                                <option value="" selected="selected">얼굴형</option>
                                                <code:optionUDV codeGrp="FACE_SHAPE_CD" value=""/>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="searchSkinTone">피부톤</label>
                                            <select name="searchSkinTone" id="searchSkinTone">
                                                <option value="" selected="selected">피부톤</option>
                                                <code:optionUDV codeGrp="FACE_SKIN_TONE_CD" value=""/>
                                            </select>
                                        </span>
                                        <span class="select">
                                            <label for="searchFaceStyle">스타일</label>
                                            <select name="searchFaceStyle" id="searchFaceStyle">
                                                <option value="" selected="selected">스타일</option>
                                                <code:optionUDV codeGrp="FACE_STYLE_CD" value=""/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>우선순위</th>
                                    <td>
                                        <tags:radio codeStr="01:조회수;02:판매수량;03:판매금액;04:실판매금액" name="priority" idPrefix="priority" value="01"/>
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
                                <h3 class="tlth3" style="float: left;">판매 순위 현황</h3>
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
                                    <col width="50px">
                                    <col width="220px">
                                    <col width="80px">
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
                                    <th>조회수</th>
                                    <th>찜하기</th>
                                    <th>장바구니</th>
                                    <th>판매수량</th>
                                    <th>판매금액</th>
                                    <th>실판매금액</th>
                                    <th>할인금액</th>
                                    <th>재고</th>
                                    <th>성별</th>
                                    <th>연령대</th>
                                    <th>안경추천사이즈</th>
                                    <th>얼굴형</th>
                                    <th>피부톤</th>
                                    <th>스타일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_saleRankGoodsAnlsListAll">
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
                                <h3 class="tlth3" style="float: left;">판매 순위 현황</h3>
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
                                    <col width="50px">
                                    <col width="220px">
                                    <col width="80px">
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
                                    <th>조회수</th>
                                    <th>찜하기</th>
                                    <th>장바구니</th>
                                    <th>판매수량</th>
                                    <th>판매금액</th>
                                    <th>실판매금액</th>
                                    <th>할인금액</th>
                                    <th>재고</th>
                                    <th>성별</th>
                                    <th>연령대</th>
                                    <th>안경추천사이즈</th>
                                    <th>얼굴형</th>
                                    <th>피부톤</th>
                                    <th>스타일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_saleRankGoodsAnlsListPC">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingPC"></div>
                        </div>
                    </div>

                    <div class="tab-2con" id="tab3" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3" style="float: left;">판매 순위 현황</h3>
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
                                    <col width="50px">
                                    <col width="220px">
                                    <col width="80px">
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
                                    <th>조회수</th>
                                    <th>찜하기</th>
                                    <th>장바구니</th>
                                    <th>판매수량</th>
                                    <th>판매금액</th>
                                    <th>실판매금액</th>
                                    <th>할인금액</th>
                                    <th>재고</th>
                                    <th>성별</th>
                                    <th>연령대</th>
                                    <th>안경추천사이즈</th>
                                    <th>얼굴형</th>
                                    <th>피부톤</th>
                                    <th>스타일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_saleRankGoodsAnlsListMobile">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingMobile"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>