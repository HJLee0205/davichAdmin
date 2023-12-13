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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">판매자 공지 > 기본</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 게시글 목록 조회
                bbsLettSet.getBbsLettList();

                // 엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', bbsLettSet.getBbsLettList);

                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e){
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#hd_page").val("1");
                    bbsLettSet.getBbsLettList();
                });

                 // 제목 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function(e) {
                    var lettNo = $(this).parents('tr').data('lett-no');
                    var param = {bbsId: $("#bbsId").val(), lettNo: lettNo};
                    Dmall.FormUtil.submit('/admin/seller/setup/seller-bbs-detail', param);
                });
            });

            var bbsLettSet = {
                bbsLettList : [],
                getBbsLettList : function() {
                    var url = '/admin/seller/setup/board-letter-list',dfd = jQuery.Deferred();
                    var param = $('#form_id_search').serialize();
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-lett-no="{{lettNo}}">'+
                            '<td>{{rowNum}}</td>' +
                            '<td><a href="#none" class="tbl_link">{{title}}</a></td>' +
                            '<td>{{memberNm}}</td>' +
                            '<td>{{regDttm}}</td>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="4">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_bbsLettList').html(tr);
                        bbsLettSet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', bbsLettSet.getBbsLettList);

                        $("#cnt_total").text(result.filterdRows);
                    });

                    return dfd.promise();
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 공지</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" name="bbsId" id="bbsId" value="sellNotice">
                    <input type="hidden" name="page" id="hd_page" value="1">
                    <input type="hidden" name="sord" id="hd_srod" value="">
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 게시판 리스트 검색 표 입니다. 구성은 검색어 입니다.">
                                <caption>게시글 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>작성일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="intxt w100p">
                                            <input type="text" value="" id="searchVal" name="searchVal">
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn--black" id="btn_id_search">검색</a>
                        </div>
                    </div>
                    <!-- //line_box -->
                    <!-- line_box -->
                    <div class="line_box">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 게시물이 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <table summary="게시글 리스트" id="table_id_bbsLettList">
                                <caption>게시글 리스트</caption>
                                <colgroup id="colgroupList">
                                    <col width="6%">
                                    <col width="60%">
                                    <col width="14%">
                                    <col width="20%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                </thead>
                                <tbody id="tbody_id_bbsLettList">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <!-- pageing -->
                            <div class="pageing" id="div_id_paging"></div>
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                        <!-- //line_box -->
                    </div>
                </form>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
