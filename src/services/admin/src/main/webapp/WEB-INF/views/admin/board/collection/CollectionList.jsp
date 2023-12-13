<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2022/11/23
  Time: 2:01 PM
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
    <t:putAttribute name="title">컬렉션 관리 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 컬렉션 게시물 데이터 조회
                bbsCollectionLettSet.getBbsLettList();

                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#hd_page').val('1');
                    bbsCollectionLettSet.getBbsLettList();
                });

                // 게시글 상세 페이지 이동
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no')
                    }
                    Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
                });

                // 게시글 미리보기 버튼 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.btn_gray', function() {
                    console.log('preview button');
                });

                // 선택 삭제 버튼 클릭
                $('#btn_delete').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk == false) {
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해주세요.');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', bbsCollectionLettSet.delBbsLettList);
                });

                // 등록 버튼 클릭
                $('#btn_regist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var param = { bbsId: $('#bbsId').val() };
                    Dmall.FormUtil.submit('/admin/board/letter-insert-form', param);
                });
            });

            var bbsCollectionLettSet = {
                bbsLettList: []
                , getBbsLettList: function() {
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
                            '<td style="text-align:left"><a href="#none" class="tbl_link">{{title}}</a></td>' +
                            '<td><a class="btn_gray">보기</a></td>' +
                            '<td>{{dispGbCdNm}}</td>' +
                            '<td>{{inqCnt}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '</tr>';
                        var templateMgr = new Dmall.Template(template);
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="7">데이터가 없습니다.</td></tr>'
                        }

                        $('#tbody_id_bbsLettList').html(tr);
                        bbsCollectionLettSet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsCollectionLett', bbsCollectionLettSet.getBbsLettList);

                        $('#a').text(result.filterdRows);
                    });
                    return dfd.promise();
                }
                , delBbsLettList: function() {
                    var url = '/admin/board/board-checkedletter-delete';
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $('#hd_page').val('1');
                            bbsCollectionLettSet.getBbsLettList();
                        }
                    })
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
                <h2 class="tlth2">컬렉션 관리</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" name="page" id="hd_page" value="1"/>
                    <input type="hidden" name="sord" id="hd_srod" value=""/>
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이 표는 컬렉션 관리 검색 표 입니다. 구성은 상품군, 검색어 입니다.">
                                <caption>컬렉션 관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>상품군</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <tags:checkboxs codeStr="01:안경테;02:선글라스;04:콘택트렌즈" name="goodsTypeCds" idPrefix="goodsTypeCd"/>
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
                            <table summary="컬렉션 관리 리스트 표 입니다. 구성은 선택, 번호, 컬렉션 명, 조회수, 작성일 입니다.">
                                <caption>스타일 추천 투표 리스트 표</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="8%">
                                    <col width="">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="15%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="chack03" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack03"></span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>컬렉션 명</th>
                                    <th>미리보기</th>
                                    <th>노출</th>
                                    <th>조회수</th>
                                    <th>작성일</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_bbsLettList">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_paging"></div>
                        </div>
                        <!-- //bottom_lay -->
                    </div>
                </form>
            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_delete">선택삭제</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_regist">등록</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>