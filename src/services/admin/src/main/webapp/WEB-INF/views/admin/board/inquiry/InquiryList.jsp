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
    <t:putAttribute name="title">1:1 문의 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var fromMember = ${not empty so.memberNo};
            $(document).ready(function() {
                // 게시글 목록 조회
                bbsInquirySet.getBbsLettList();

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', bbsInquirySet.getBbsLettList);

                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm > toDttm){
                        Dmall.LayerUtil.alert('등록일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#hd_page").val("1");
                    bbsInquirySet.getBbsLettList();
                });

                // 선택삭제 버튼 클릭
                $('#delSelectBbsLett').on('click', function(e) {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', bbsInquirySet.delSelectBbsLett);
                });

                // 게시글 보기 페이지 이동
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no')
                    };
                    Dmall.FormUtil.submit('/admin/board/letter-detail', param);
                });

                // 게시글 수정/삭제 버튼 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.btn_gray', function() {
                    var param = {
                        bbsId: $(this).parents('tr').data('bbs-id'),
                        lettNo: $(this).parents('tr').data('lett-no')
                    };

                    if($(this).text() == '수정' || $(this).text() == '등록') {
                        Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
                    } else {
                        var url = '/admin/board/board-letter-delete';
                        Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    $('#hd_page').val('1');
                                    bbsInquirySet.getBbsLettList();
                                }
                            });
                        });
                    }
                });
            });

            var bbsInquirySet = {
                bbsLettList: [],
                getBbsLettList: function() {
                    var url = '/admin/board/board-letter-list', dfd = jQuery.Deferred();
                    var param = $('#form_id_search').serialize();
                    param = param.replace(/inquiryCds=67/g, 'inquiryCds=6&inquiryCds=7&inquiryCds=3')
                        .replace(/inquiryCds=84/g, 'inquiryCds=8&inquiryCds=4');

                    if(fromMember) {
                        param += '&memberNo=${so.memberNo}';
                        fromMember = false;
                    }

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template =
                            '<tr data-lett-no="{{lettNo}}" data-bbs-id="{{bbsId}}">' +
                            '<td>' +
                            '<label for="delLettNo_{{lettNo}}" class="chack">' +
                            '<span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}" value="{{lettNo}}" class="blind"></span></label>' +
                            '</td>' +
                            '<td>{{rowNum}}</td>' +
                            '<td>{{inquiryNm}}</td>' +
                            '<td class="txtl"><a href="#none" class="tbl_link">{{title}}</a></td>' +
                            '<td>{{memberNm}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '<td>{{replyStatusYnNm}}</td>' +
                            '<td>';
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            if(obj.inquiryCd == '6' || obj.inquiryCd == '7' || obj.inquiryCd == '3') {
                                obj.inquiryNm = '환불/취소';
                            }
                            if(obj.inquiryCd == '8' || obj.inquiryCd == '4') {
                                obj.inquiryNm = '교환/AS';
                            }

                            var temp = '';
                            if(obj.replyStatusYn == 'Y') {
                                temp = template + '<a href="#none" class="btn_gray">수정</a>';
                            } else {
                                temp = template + '<a href="#none" class="btn_gray">등록</a>';
                            }
                            temp +=
                                '<a href="#none" class="btn_gray">삭제</a>' +
                                '</td></tr>';

                            var templateMgr = new Dmall.Template(temp);

                            tr += templateMgr.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="8">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_bbsLettList').html(tr);
                        bbsInquirySet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);

                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', bbsInquirySet.getBbsLettList);

                        $('#a').text(result.filterdRows);
                    });
                    return dfd.promise();
                },
                delSelectBbsLett: function() {
                    var url = '/admin/board/board-checkedletter-delete';
                    var param = $('#form_id_search').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            $('#hd_page').val('1');
                            bbsInquirySet.getBbsLettList();
                        }
                    });
                }
            }
        </script>
        <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">1:1 문의</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}"/>
                    <input type="hidden" name="page" id="hd_page" value="1"/>
                    <input type="hidden" name="sord" id="hd_srod" value=""/>
                    <!-- search_box -->
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="1:1 문의 리스트 검색 표">
                                <caption>1:1 문의 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>등록일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>분류</th>
                                    <td>
                                        <tags:checkboxs codeStr="1:상품;2:배송;5:주문;67:환불/취소;84:교환/AS;9:기타" name="inquiryCds" idPrefix="inquiryCd"/>
                                        <a href="#none" class="all_choice"><span class="ico_comm"></span> 전체</a>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
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
                            <table summary="1:1 문의 리스트 표">
                                <caption>1:1 문의 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="7%">
                                    <col width="10%">
                                    <col width="30%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="15%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05"/></span>
                                        </label>
                                    </th>
                                    <th>No</th>
                                    <th>분류</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>등록일시</th>
                                    <th>답변상태</th>
                                    <th>관리</th>
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
                    <!-- //line_box -->
                </form>
            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="delSelectBbsLett">선택삭제</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
