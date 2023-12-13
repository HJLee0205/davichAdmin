<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/11/23
  Time: 11:23 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">스타일 픽 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 스타일 픽 게시물 데이터 조회
                bbsPickLettSet.getBbsPickLettList();

                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $('#srch_sc01').val().replace(/-/gi, "");
                    var toDttm = $('#srch_sc02').val().replace(/-/gi, "");
                    if(fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('등록일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $('#hd_page').val('1');
                    bbsPickLettSet.getBbsPickLettList();
                })

                // 게시글 상세 페이지 이동
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no')
                    }
                    Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
                })

                // 선택 삭제 버튼 클릭
                $('#delSelectBbsLett').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk == false) {
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', bbsPickLettSet.delSelectBbsLett);
                });

                // 등록 버튼 클릭
                $('#viewBbsLettInsert').on('click', function() {
                    var param = {bbsId:$('#bbsId').val()}
                    Dmall.FormUtil.submit('/admin/board/letter-insert-form', param);
                });
            });

            var bbsPickLettSet = {
                bbsPickLettList : []
                , getBbsPickLettList : function() {
                    var url = '/admin/board/board-letter-list', dfd = jQuery.Deferred();
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-lett-no="{{lettNo}}" data-bbs-id="{{bbsId}}">' +
                            '<td>' +
                            '<label for="delLettNo_{{lettNo}}" class="chack">' +
                            '<span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}" value="{{lettNo}}" class="blind"></span></label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td style="text-align:left"><a href="#none" class="tbl_link">{{content}}</a></td>' +
                            '<td>{{memberNn}}</td>' +
                            '<td>{{inqCnt}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '</tr>';
                        var templateMgr = new Dmall.Template(template);
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_bbsLettList').html(tr);
                        bbsPickLettSet.bbsPickLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsPickLett', bbsPickLettSet.getBbsPickLettList);

                        $('#a').text(result.filterdRows);
                    });
                }
                , delSelectBbsLett : function() {
                    var url = '/admin/board/board-checkedletter-delete';
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $('#hd_page').val('1');
                            bbsPickLettSet.getBbsPickLettList();
                        }
                    });
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">스타일 픽</h2>
            </div>
            <form id="form_id_search">
                <input type="hidden" name="page" id="hd_page" value="1"/>
                <input type="hidden" name="sord" id="hd_srod" value=""/>
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 스타일 픽 검색 표 입니다. 구성은 등록일, 검색어 입니다.">
                            <caption>스타일 픽 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>등록일</th>
                                <td>
                                    <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}"/>
                                    <span class="intxt w100p">
                                        <input type="text" name="searchVal" id="searchVal">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="btn_id_search">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- line_box -->
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                        <span class="search_txt">
                        총 <strong class="be" id="a"></strong>개의 게시물이 검색되었습니다.
                        </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="스타일 픽 리스트 표 입니다. 구성은 선택, 번호, 내용, 태그값, 인플루언서, 조회수, 작성일 입니다.">
                            <caption>스타일 추천 투표 리스트 표</caption>
                            <colgroup>
                                <col width="5%" />
                                <col width="10%" />
                                <col width="40%" />
                                <col width="20%" />
                                <col width="10%" />
                                <col width="15%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack03" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack03"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>내용</th>
                                <th>인플루언서</th>
                                <th>조회수</th>
                                <th>작성일</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_bbsLettList">
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div id="div_id_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="delSelectBbsLett">선택삭제</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="viewBbsLettInsert">등록</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>