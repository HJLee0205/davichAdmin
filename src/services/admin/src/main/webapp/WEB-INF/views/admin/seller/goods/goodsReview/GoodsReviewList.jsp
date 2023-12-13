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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">상품 후기 관리 > 상품</t:putAttribute>
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

                // 상세 화면
                $(document).on('click', '#tbody_id_bbsLettList a.tbl_link', function(e) {
                    var lettNo = $(this).parents('tr').data('lett-no');
                    var param = {bbsId : $("#bbsId").val(), lettNo : lettNo};
                    Dmall.FormUtil.submit('/admin/seller/goods/board-goodsreview-detail', param);
                });

                // 선택 삭제
                $('#btn_delete').on('click', function() {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('삭제할 데이터를 체크해 주세요');
                        return;
                    }

                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br />정말 삭제하시겠습니까?', bbsLettSet.delSelectBbsLett);
                });

                // 일괄 비노출
                $('#updateBbsLettExpsN').on('click', function() {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('데이터를 체크해 주세요');
                        return;
                    }
                    $("#expsYn").val("N");
                    Dmall.LayerUtil.confirm('선택한 게시글을 비노출 하시겠습니까?', updateBbsLettExpsYn);
                });

                // 일괄 노출
                $('#updateBbsLettExpsY').on('click', function() {
                    var delChk = $('input:checkbox[name=delLettNo]').is(':checked');
                    if(delChk==false){
                        Dmall.LayerUtil.alert('데이터를 체크해 주세요');
                        return;
                    }
                    $("#expsYn").val("Y");
                    Dmall.LayerUtil.confirm('선택한 게시글을 노출 하시겠습니까?', updateBbsLettExpsYn);
                });
                
                getCategoryOptionValue('1', $('#sel_ctg_1'));
                // 카테고리1 변경시 이벤트
                $('#sel_ctg_1').on('change', function(e) {
                    changeCategoryOptionValue('2', $(this));
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_2_def').focus();
                });
                // 카테고리2 변경시 이벤트
                $('#sel_ctg_2').on('change', function(e) {
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_3_def').focus();
                });
                // 카테고리3 변경시 이벤트
                $('#sel_ctg_3').on('change', function(e) {
                    changeCategoryOptionValue('4', $(this));
                    $('#opt_ctg_4_def').focus();
                });
            });
            
            var bbsLettSet = {
                bbsLettList : [],
                getBbsLettList : function() {
                    var url = '/admin/seller/setup/board-letter-list',dfd = jQuery.Deferred();
                    var param = $('#form_id_search').serialize();
    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = 
                            '<tr data-lett-no="{{lettNo}}">' +
                            '<td>' +
                            '   <label for="delLettNo_{{lettNo}}" class="chack">' +
                            '   <span class="ico_comm"><input type="checkbox" name="delLettNo" id="delLettNo_{{lettNo}}" value="{{lettNo}}" class="blind"></span></label>' +
                            '</td>'+
                            '<td>{{rowNum}}</td>' +
                            '<td class="txtl">{{goodsNm}}</td>'+
                            '<td class="txtl"><a href="#none" class="tbl_link acd_tlt">{{content}}</a></td>' +
                            '<td>{{memberNn}}</td>' +
                            '<td>{{score}}</td>' +
                            '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';
    
                        jQuery.each(result.resultList, function(idx, obj) {
                            tr += managerGroup.render(obj)
                        });
    
                        if(tr == '') {
                            tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
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
            
            function updateBbsLettExpsYn(){
                var param = $('#form_id_search').serialize();
                var url = '/admin/board/board-letterexpose-update';

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success){
                        bbsLettSet.getBbsLettList();
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">상품 후기 관리</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" name="page" id="hd_page" value="1">
                    <input type="hidden" name="sord" id="hd_srod" value="">
                    <input type="hidden" name="rows" id="hd_rows" value="">
                    <input type="hidden" name="bbsId" id="bbsId" value="review">
                    <input type="hidden" name="expsYn" id="expsYn" value="">
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
                                    <th>카테고리</th>
                                    <td id="td_goods_select_ctg">
                                    <span class="select">
                                        <label for="sel_ctg_1">1차 카테고리</label>
                                        <select name="searchCtg1" id="sel_ctg_1">
                                            <option id="opt_ctg_1_def" value="">1차 카테고리</option>
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
                                    <th>후기 등록일</th>
                                    <td>
                                        <tags:calendar from="fromRegDt" to="toRegDt" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>노출 여부</th>
                                    <td>
                                        <tags:checkboxs codeStr=":전체;Y:노출;N:비노출" name="expsYns" idPrefix="expsYn"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상품명</th>
                                    <td>
                                        <span class="intxt w100p">
                                            <input type="text" name="searchGoodsName">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="intxt w100p">
                                            <input type="text" value="" id="searchVal" name="searchVal">
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <button class="btn--black" id="btn_id_search">검색</button>
                        </div>
                    </div>
                    <!-- //line_box -->
                    <!-- line_box -->
                    <div class="line_box">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 상품 후기가 검색되었습니다.
                                </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh th_l">
                            <table summary="공통 코드 그룹 관리" id="table_id_cmnCdGrp" style="table-layout: fixed;">
                                <caption>상품 문의 관리 리스트</caption>
                                <colgroup>
                                    <col width="5%">
                                    <col width="7%">
                                    <col width="20%">
                                    <col width="43%">
                                    <col width="15%">
                                    <col width="10%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>
                                        <label for="chack05" class="chack">
                                            <span class="ico_comm"><input type="checkbox" name="table" id="chack05"></span>
                                        </label>
                                    </th>
                                    <th>번호</th>
                                    <th>상품명</th>
                                    <th>후기 내용</th>
                                    <th>닉네임</th>
                                    <th>점수</th>
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
                    </div>
                </form>
            </div>
            <!--bottom_box  -->
            <div class="bottom_box">
                <div class="left">
                    <div class="pop_btn">
                        <button class="btn--big btn--big-white" id="btn_delete">선택삭제</button>
                    </div>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="updateBbsLettExpsN">일괄 비노출</button>
                    <button class="btn--blue-round" id="updateBbsLettExpsY">일괄 노출</button>
                </div>
            </div>
            <!--//bottom_box  -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
