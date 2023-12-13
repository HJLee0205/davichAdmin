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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">재입고알림상품관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 카테고리1 변경
                $('#sel_ctg_1').on('change', function(e) {
                    changeCategoryOptionValue('2', $(this));
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_2_def').focus();
                });
                // 카테고리2 변경
                $('#sel_ctg_2').on('change', function(e) {
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_3_def').focus();
                });
                // 카테고리3 변경
                $('#sel_ctg_3').on('change', function(e) {
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_4_def').focus();
                });

                // 엔터키 입력시 검색
                Dmall.FormUtil.setEnterSearch('form_id_search', function() { $('#btn_search').trigger('click'); });

                // 검색
                $('#btn_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#hd_page").val("1");
                    RestockUtil.getList();
                });

                // 엑셀다운로드
                $('#btn_download').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    RestockUtil.downloadExcel();
                });

                // 상세화면
                $(document).on('click', 'a.tbl_link', function () {
                    var goodsNo = $(this).parent('td').siblings().eq(0).find('input[type=checkbox]').val();
                    RestockUtil.viewDetail(goodsNo);
                });

                // 선택삭제
                $('#btn_delete').on('click', function () {
                    RestockUtil.deleteSelected();
                });

                // 재입고알림
                $('#btn_notify').on('click', function () {
                    RestockUtil.sendNotify();
                });

                // 데이터 조회
                RestockUtil.getList();
            });

            var RestockUtil = {
                getList: function() {
                    var url = '/admin/goods/restocknotify/restock-notify-list',
                        param = $('#form_id_search').serialize(),
                        dfd = $.Deferred();

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var template =
                                '<tr>' +
                                '<td>' +
                                '<label for="chkRestockNo_{{rowNum}}" class="chack"><span class="ico_comm">' +
                                '<input type="checkbox" name="chkRestockNo" id="chkRestockNo_{{rowNum}}" value="{{goodsNo}}" class="blind">' +
                                '</span></label>' +
                                '</td>' +
                                '<td>{{rowNum}}</td>' +
                                '<td><img src="${_IMAGE_DOMAIN}{{goodsImg}}" alt=""></td>' +
                                '<td><a href="#none" class="tbl_link">{{goodsNm}}</a></td>' +
                                '<td>{{goodsNo}}</td>' +
                                '<td class="comma">{{salePrice}}</td>' +
                                '<td class="comma">{{stockQtt}}</td>' +
                                '<td>{{goodsSaleStatusNm}}</td>' +
                                '<td>{{dupleCnt}}</td>' +
                                '</tr>',
                            templateMgr = new Dmall.Template(template),
                            tr = '';

                        $.each(result.resultList, function (idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="9">데이터가 없습니다.</td></tr>'
                        }

                        $('#tbody_notify_data').html(tr);
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_restock', RestockUtil.getList);

                        $('#cnt_total').text(result.filterdRows);

                        Dmall.common.comma();
                    });
                    return dfd.promise();
                },
                downloadExcel: function() {
                    $('#form_id_search').attr('action', '/admin/goods/restocknotify/restock-notify-excel');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '');
                },
                deleteSelected: function() {
                    var selected = [];
                    $('#tbody_notify_data').find('input[type=checkbox]:checked').each(function () {
                        selected.push($(this).val());
                    });

                    if(selected.length < 1) {
                        Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 상품은 복구할 수 없습니다.<br>정말 삭제하시겠습니까?', function () {
                        var url = '/admin/goods/restocknotify/restock-notifiy-delete',
                            param = {};

                        $.each(selected, function (idx, obj) {
                            var key = 'list['+idx+'].goodsNo';
                            param[key] = obj;
                        });

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            RestockUtil.getList();
                        });
                    });
                },
                sendNotify: function() {
                    var selected = [];
                    $('#tbody_notify_data').find('input[type=checkbox]:checked').each(function () {
                        selected.push($(this).val());
                    });

                    if (selected.length < 1) {
                        Dmall.LayerUtil.alert('선택된 상품이 없습니다.');
                        return;
                    }

                    console.log(selected);

                    Dmall.LayerUtil.confirm('선택된 상품의 모든 회원에게 재입고 알림을 발송하시겠습니까?', function () {
                        var url = '/admin/goods/restocknotify/checked-restock-sms-send',
                            param = {};

                        $.each(selected, function (idx, obj) {
                            var key = 'list['+idx+'].goodsNo';
                            param[key] = obj;
                        });

                        console.log(param);

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            if(result.success) {
                                $('#btn_search').trigger('click');
                            }
                        });
                    });
                },
                viewDetail: function(goodsNo) {
                    Dmall.FormUtil.submit('/admin/goods/restocknotify/restock-notify-detail', {goodsNo: goodsNo});
                }
            }

            // 하위 카테고리 정보 취득
            function getCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl},
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    //
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });
                    dfd.resolve(result.resultList);
                });

                return dfd.promise();
            }
            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeCategoryOptionValue(level, $target) {
                var $sel = $('#sel_ctg_' + level),
                    $label = $('label[for=sel_ctg_' + level + ']', '#td_goods_select_ctg');

                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                if ( level && level == '2' && $target.attr('id') == 'sel_ctg_1') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '3' && $target.attr('id') == 'sel_ctg_2') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '4' && $target.attr('id') == 'sel_ctg_3') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else {
                    return;
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">재입고 알림 상품</h2>
            </div>
            <div class="search_box_wrap">
                <form action="" id="form_id_search">
                    <input type="hidden" name="page" id="hd_page" value="1" />
                    <input type="hidden" name="sord" id="hd_srod" value="" />
                    <input type="hidden" name="rows" id="hd_rows" value="" />
                    <div class="search_box">
                        <div class="search_tbl">
                            <table>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>카테고리</th>
                                    <td id="td_goods_select_ctg">
                                    <span class="select">
                                        <label for="sel_ctg_1">1차 카테고리</label>
                                        <select name="searchCtg1" id="sel_ctg_1">
                                            <option id="opt_ctg_1_def" value="">1차 카테고리</option>
                                            <c:forEach var="ctg" items="${ctgList}" varStatus="status">
                                                <option id="opt_ctg_${ctg.ctgLvl}_${status.index}" value="${ctg.ctgNo}">${ctg.ctgNm}</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                        <span class="select">
                                        <label for="sel_ctg_2">2차 카테고리</label>
                                        <select name="searchCtg2" id="sel_ctg_2">
                                            <option id="opt_ctg_2_def" value="">2차 카테고리</option>
                                        </select>
                                    </span>
                                        <span class="select">
                                        <label for="sel_ctg_3">3차 카테고리</label>
                                        <select name="searchCtg3" id="sel_ctg_3">
                                            <option id="opt_ctg_3_def" value="">3차 카테고리</option>
                                        </select>
                                    </span>
                                        <span class="select">
                                        <label for="sel_ctg_4">4차 카테고리</label>
                                        <select name="searchCtg4" id="sel_ctg_4">
                                            <option id="opt_ctg_4_def" value="">4차 카테고리</option>
                                        </select>
                                    </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>재입고알림 요청기간</th>
                                    <td>
                                        <tags:calendar from="searchDateFrom" to="searchDateTo" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품상태</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <tags:checkboxs codeStr="1:판매중;4:판매중지;2:품절" name="goodsStatus" idPrefix="goodsStatus"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품코드</th>
                                    <td>
                                        <span class="intxt long">
                                            <input type="text" name="searchCode" id="txt_searchCode">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt wid100p">
                                            <input type="text" name="searchWord" id="txt_searchWord">
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--black" id="btn_search">검색</button>
                        </div>
                    </div>
                </form>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total"></strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span><img src="/admin/img/icons/icon-excel_down.png" alt="">
                            </button>
                        </div>
                    </div>
                    <div class="tblh">
                        <table>
                            <colgroup>
                                <col width="5%">
                                <col width="7%">
                                <col width="110px">
                                <col width="26%">
                                <col width="15%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                                <col width="10%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="allcheck" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="allcheck" class="blind"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>상품코드</th>
                                <th>판매가</th>
                                <th>재고</th>
                                <th>상태</th>
                                <th>요청자</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_notify_data">
                            </tbody>
                        </table>
                    </div>
                    <div class="bottom_lay">
                        <div class="pageing" id="div_id_paging"></div>
                    </div>
                </div>
            </div>
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_delete">선택 삭제</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_notify">재입고알림</button>
                </div>
            </div>
        </div>

        <%@ include file="restockSmsLayerPop.jsp" %>
    </t:putAttribute>
</t:insertDefinition>
