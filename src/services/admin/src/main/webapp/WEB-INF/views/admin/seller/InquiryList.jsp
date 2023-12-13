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
    <t:putAttribute name="title">판매자 문의 > 업체</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                bbsLettSet.getBbsLettList();
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', bbsLettSet.getBbsLettList);
              
                // 검색 버튼 클릭
                $('#btn_id_search').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }
                    
                    $("#hd_page").val("1");
                    bbsLettSet.getBbsLettList();
                });
                
                // 답변 등록/수정 버튼 클릭
                $(document).on('click', '#tbody_id_bbsLettList a.btn_gray', function(e) {
                    var lettNo = $(this).parents('tr').data('lett-no');
                    var replyStatusYn = $(this).parents('tr').data('reply-status-yn');
                    var param = {bbsId : $("#bbsId").val(), lettNo : lettNo, replyStatusYn: replyStatusYn};

                    Dmall.FormUtil.submit('/admin/seller/letter-reply-form', param);
                });

                // 선택삭제 버튼 클릭
                $('#delSelectBbsLett').on('click', function() {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');
                        return;
                    }
                    
                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br />정말 삭제하시겠습니까?', bbsLettSet.delSelectBbsLett);
                });
            });
            
            var bbsLettSet = {
                bbsLettList : [],
                getBbsLettList : function() {
                    var url = '/admin/board/board-letter-list',dfd = jQuery.Deferred();
                    var param = jQuery('#form_id_search').serialize();
                    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = 
                            '<tr data-lett-no="{{lettNo}}" data-reply-status-yn="{{replyStatusYn}}">'+
                            '<td>'+
                            '    <label for="delLettNo_{{lettNo}}" class="chack"> '+
                            '    <span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}"  value="{{lettNo}}" class="blind" /></span></label>'+
                            '</td>'+
                            '<td>{{rowNum}}</td>' +
                            '<td>{{sellerNm}}</td>' +
                            '<td>{{inquiryNm}}</td>' +
                            '<td>{{title}}</td>' +
                            '<td>{{regDttm}}</td>' +
                            '<td>{{replyStatusYnNm}}</td>'+
                            '<td>';
                        var tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            var temp = '';
                            if(obj.replyStatusYn == 'Y') {
                                temp = template + '<a href="#none" class="btn_gray">답변 수정</a>';
                            } else {
                                temp = template + '<a href="#none" class="btn_gray">답변 등록</a>';
                            }
                            temp = temp + '</td></tr>';

                            var managerGroup = new Dmall.Template(temp);

                            tr += managerGroup.render(obj);
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="8">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_bbsLettList').html(tr);
                        bbsLettSet.bbsLettList = result.resultList;
                        dfd.resolve(result.resultList);
                        
                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', bbsLettSet.getBbsLettList);
                        
                        $("#cnt_total").text(result.filterdRows);
                    });

                    return dfd.promise();
                },
                delSelectBbsLett: function() {
                    var param = $('#form_id_search').serialize();
                    var url = '/admin/board/board-checkedletter-delete';

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            $("#hd_page").val("1");
                            bbsLettSet.getBbsLettList();
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
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 문의</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" name="bbsId" id="bbsId" value="sellQuestion">
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
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller">전체</label>
                                            <select name="selSellerNo" id="sel_seller">
                                                <code:sellerOption siteno="${so.siteNo}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>질문유형</th>
                                    <td>
                                        <a href="#none" class="all_choice mr20"><span class="ico_comm"></span>전체</a>
                                        <code:checkboxUDV codeGrp="INQUIRY_CD" name="inquiryCds" idPrefix="inquiryCd"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="intxt w100p">
                                            <input type="text" id="searchVal" name="searchVal">
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
                    <!-- //search_tbl -->
                    <!-- line_box -->
                    <div class="line_box pb">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 문의가 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh th_l">
                            <table summary="게시글 리스트">
                                <caption>게시글 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="5%">
                                    <col width="12%">
                                    <col width="13%">
                                    <col width="33%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="12%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05"></span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>판매자</th>
                                    <th>질문유형</th>
                                    <th>문의 제목</th>
                                    <th>작성일</th>
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
                            <!-- pageing -->
                            <div class="pageing" id="div_id_paging"></div>
                            <!-- //pageing -->
                        </div>
                        <!-- //bottom_lay -->
                        <!-- //line_box -->
                    </div>
                    <!-- //line_box -->
                </form>
            </div>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="delSelectBbsLett">선택삭제</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
