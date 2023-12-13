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
<%@ taglib prefix="fomr" uri="http://www.springframework.org/tags/form" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">회원 분석</t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            $(document).ready(function() {
                LoginCurStatusUtil.init();

                // 검색
                $('#btn_id_search').on('click', function () {
                    $('#hd_page').val('1');
                    LoginCurStatusUtil.getLoginCurStatusList();
                });
            });

            var LoginCurStatusUtil = {
                init: function () {
                    $('#btn_srch_cal_1').trigger('click');

                    $('#hd_page').val('1');
                    LoginCurStatusUtil.getLoginCurStatusList();
                },
                getLoginCurStatusList: function () {
                    var url = '/admin/statistics/login-currentstatus', dfd = $.Deferred(),
                        param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td>{{rank}}</td>' +
                                '<td>{{loginId}}</td>' +
                                '<td>{{memberNm}}</td>' +
                                '<td>{{lastLoginDttm}}</td>' +
                                '<td class="comma">{{totLoginCnt}}</td>' +
                                '<td class="comma">{{pageVw}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_loginCurStatusListAll').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_pagingAll', result, 'paging_id_all', LoginCurStatusUtil.getLoginCurStatusList);

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
                    통계<span class="step_bar"></span> 회원 분석<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">로그인 현황</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form action="/admin/statistics/login-currentstatus" id="form_id_search" commandName="loginCurrentStatusSO">
                        <fomr:hidden path="page" id="hd_page"/>
                        <form:hidden path="eqpmGbCd"/>
                        <!-- search_tbl -->
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
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">로그인 현황 분석</h3>
                            </div>
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
                                    <col width="10%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                    <col width="30%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>ID</th>
                                    <th>회원명</th>
                                    <th>최근 접속 시간</th>
                                    <th>총 로그인 횟수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_loginCurStatusListAll">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingAll"></div>
                        </div>
                    </div>

                    <!-- Web -->
                    <div id="tab2" class="tab-2con" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">로그인 현황 분석</h3>
                            </div>
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
                                    <col width="10%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                    <col width="30%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>ID</th>
                                    <th>회원명</th>
                                    <th>최근 접속 시간</th>
                                    <th>총 로그인 횟수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_loginCurStatusListWeb">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingWeb"></div>
                        </div>
                    </div>

                    <!-- App -->
                    <div id="tab3" class="tab-2con" style="display: none;">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <h3 class="tlth3">로그인 현황 분석</h3>
                            </div>
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
                                    <col width="10%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                    <col width="30%" />
                                    <col width="15%" />
                                    <col width="15%" />
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>순위</th>
                                    <th>ID</th>
                                    <th>회원명</th>
                                    <th>최근 접속 시간</th>
                                    <th>총 로그인 횟수</th>
                                    <th>페이지뷰</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_loginCurStatusListApp">
                                </tbody>
                            </table>
                            <!--/div-->
                        </div>
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_pagingApp"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>