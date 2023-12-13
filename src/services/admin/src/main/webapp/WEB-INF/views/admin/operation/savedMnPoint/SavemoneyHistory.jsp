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
    <t:putAttribute name="title">포인트 관리 > 포인트 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                // 포인트 내역 조회
                saveMnSet.getSaveMnList();

                // var url = '/admin/operation/savedMnPoint/total-savedmoney',dfd = jQuery.Deferred();
                // var param = $('#form_id_search').serialize();
                //
                // Dmall.AjaxUtil.getJSON(url, param, function(result) {
                //     $('#totalSvmnPvd').text(Dmall.common.numberWithCommas(result.data.totalSvmnPvd));
                //     $('#totalSvmnUse').text(Dmall.common.numberWithCommas(result.data.totalSvmnUse));
                // });

                // 검색
                $('#btn_id_search').on('click', function(e){
                    var fromDttm = $("#srch_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_sc02").val().replace(/-/gi, "");
                    if(fromDttm && toDttm && fromDttm > toDttm){
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }
                    
                    $("#hd_page").val("1");
                    saveMnSet.getSaveMnList();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function() { $('#btn_id_search').trigger('click'); });
            });
            
            
            var saveMnSet = {
                saveMnList : [],
                getSaveMnList : function() {
                    var url = '/admin/operation/savedMnPoint/savedmoney', dfd = jQuery.Deferred();
                    var param = $('#form_id_search').serialize();

                    console.log("param = ", param);
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var template = 
                            '<tr>'+
                            '<td>{{rowNum}}</td>' +
                            '<td>{{memberNm}}</td>' +
                            '<td>{{loginId}}</td>' +
                            '<td>{{reasonNm}}</td>' +
                            '<td><span class="{{className}}">({{gubun}})</span><span>{{prcPoint}}</span></td>' +
                            '<td>{{regDt}}</td>' +
                            '<td>{{svmnTypeNm}}</td>' +
                            '<td>{{curPoint}}</td>' +
                            '</tr>',
                            managerGroup = new Dmall.Template(template),
                            tr = '';

                        jQuery.each(result.resultList, function(idx, obj) {
                            obj.svmnTypeNm = (obj.pointGbCd == '10') ? '지급' : '차감';

                            tr += managerGroup.render(obj)
                        });

                        if(tr == '') {
                            tr = '<tr><td colspan="9">데이터가 없습니다.</td></tr>';
                        }

                        $('#tbody_id_saveMnList').html(tr);
                        saveMnSet.saveMnList = result.resultList;
                        dfd.resolve(result.resultList);
                        
                        Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_saveMn', saveMnSet.getSaveMnList);
                        
                        $("#cnt_total").text(result.filterdRows);

                        $('#totalSvmnPvd').text(Dmall.common.numberWithCommas(result.extraData.totalPointList[0]));
                        $('#totalSvmnUse').text(Dmall.common.numberWithCommas(result.extraData.totalPointList[1]));

                        Dmall.common.comma();
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
                    운영 설정<span class="step_bar"></span> 포인트<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">포인트 관리</h2>
            </div>
            <div class="search_box_wrap">
                <form id="form_id_search">
                    <input type="hidden" name="page" id="hd_page" value="1">
                    <input type="hidden" name="sord" id="hd_srod" value="">
                    <div class="search_box">
                        <!-- search_tbl -->
                        <div class="search_tbl">
                            <table summary="이표는 마켓포인트 관리 검색 표 입니다. 구성은 발생일, 검색어 입니다.">
                                <caption>마켓포인트 관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>발생일</th>
                                    <td>
                                        <tags:calendar from="stRegDttm" to="endRegDttm" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <cd:checkboxUDV codeGrp="POINT_GB_CD" name="pointGbCd" idPrefix="pointGbCd" includeTotal="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <span class="select">
                                            <label for="searchKind"></label>
                                            <select name="searchKind" id="searchKind">
                                                <tags:option codeStr=":전체;searchMemberNm:회원명;searchLoginId:아이디;"/>
                                            </select>
                                        </span>
                                        <span class="intxt long">
                                            <input type="text" name="searchVal" id="searchVal">
                                        </span>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </div>
                    <!-- line_box -->
                    <div class="line_box">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                <span class="search_txt">
                                    총 <strong class="all" id="cnt_total"></strong>개의 포인트 내역이 검색되었습니다.
                                </span>
                            </div>
                            <div class="select_btn_right">
                                <div>총 지급 포인트 : <span id="totalSvmnPvd" class="comma"></span>원</div>
                                <div>총 사용 포인트 : <span id="totalSvmnUse" class="comma"></span>원</div>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh th_l">
                            <table summary="마켓포인트 리스트" id="table_id_saveMnList">
                                <caption>마켓포인트 리스트</caption>
                                <colgroup>
                                    <col width="6%">
                                    <col width="8%">
                                    <col width="10%">
                                    <col width="26%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="10%">
                                    <col width="10%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>이름</th>
                                    <th>아이디</th>
                                    <th>내용</th>
                                    <th>포인트</th>
                                    <th>발생일</th>
                                    <th>상태</th>
                                    <th>현재 포인트</th>
                                </tr>
                                </thead>
                                <tbody id="tbody_id_saveMnList">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- pageing -->
                        <div class="bottom_lay" id="div_id_paging">
                            <div class="pageing" id="paging_id_saveMn"></div>
                        </div>
                        <!-- //pageing -->
                        <!-- //bottom_lay -->
                        <!-- //line_box -->
                    </div>
                </form>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
