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
                VisitRsvUtil.init();

                // 검색
                $('#btn_id_search').on('click', function(e){
                    $('#hd_page').val('1');
                    VisitRsvUtil.getVisitRsvLis();
                });
            });

            var VisitRsvUtil = {
                init: function () {
                    $('#hd_page').val('1');
                    VisitRsvUtil.getVisitRsvLis();
                },
                getVisitRsvLis: function () {
                    var url = '/admin/statistics/', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td></td>' +
                                '<td></td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma"></td>' +
                                '<td class="comma"></td>' +
                                '<td></td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = "<tr><td colspan='6'>데이터가 없습니다.</td></tr>";
                        }

                        $("#tbody_id_visitRsvListAll").html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging("form_id_search", "div_id_pagingAll", result, "paging_id_visitRsvAll", VisitRsvUtil.getVisitRsvLis);

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
                <h2 class="tlth2">방문예약순위</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form action="" id="form_id_search">
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
                                    <th>매장명</th>
                                    <td>
                                        <label for="" class="intxt w100p">
                                            <input type="text">
                                        </label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>우선순위</th>
                                    <td>
                                        <tags:radio codeStr="01:예약건수;02:실 방문건수;03:MY스토어 수" name="priority" idPrefix="priority" value="01"/>
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
                                <h3 class="tlth3" style="float: left;">방문 예약 순위 현황</h3>
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
                                    <th>매장명</th>
                                    <th>예약건수</th>
                                    <th>실 방문건수</th>
                                    <th>MY스토어 수</th>
                                    <th>최근 방문일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitRsvListAll">
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
                                <h3 class="tlth3" style="float: left;">방문 예약 순위 현황</h3>
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
                                    <th>매장명</th>
                                    <th>예약건수</th>
                                    <th>실 방문건수</th>
                                    <th>MY스토어 수</th>
                                    <th>최근 방문일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitRsvListWeb">
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
                                <h3 class="tlth3" style="float: left;">방문 예약 순위 현황</h3>
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
                                    <th>매장명</th>
                                    <th>예약건수</th>
                                    <th>실 방문건수</th>
                                    <th>MY스토어 수</th>
                                    <th>최근 방문일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_visitRsvListApp">
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