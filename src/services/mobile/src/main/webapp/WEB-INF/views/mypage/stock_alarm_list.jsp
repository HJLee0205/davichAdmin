<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">변경해주세요</t:putAttribute>
    
    
    
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        stockAlarmSet.getStockAlarmList();
    });

    var stockAlarmSet = {
            stockAlarmList : [],
            getStockAlarmList : function() {
                var url = '/front/mypage/stock-alarm',dfd = jQuery.Deferred();
                var param = jQuery('#form_id_search').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var template =
                    '<tr>'+
                        '<td>'+
                            '<div class="mypage_check">'+
                            '<label>'+
                                '<input type="checkbox" name="freeboard_checkbox" value="{{num}}">'+
                                '<span></span>'+
                            '</label>'+
                        '</div>'+
                        '</td>'+
                        '<td class="textL">'+
                            'BL7827/시스루패턴 하이넥블라우스'+
                        '</td>'+
                        '<td>2016-06-01</td>'+
                        '<td>2016-06-10</td>'+
                        '<td>'+
                            '<button type="button" class="btn_mypage_s03">삭제</button>'+
                        '</td>'+
                    '</tr>',
                        managerGroup = new Dmall.Template(template),
                            tr = '';
                    jQuery.each(result.resultList, function(idx, obj) {
                        tr += managerGroup.render(obj)
                    });

                    if(tr == '') {
                        tr = '<tr><td colspan="5"></td></tr>';
                    }
                    jQuery('#id_alarm_List').html(tr);
                    stockAlarmSet.stockAlarmList = result.resultList;
                    dfd.resolve(result.resultList);
                    Dmall.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_stock_alarm', selectFaq);
                    $("#a").text(result.filterdRows);
                    $("#b").text(result.totalRows);
                });
                return dfd.promise();
            }
        }

    //선택된 알림목록 삭제
    function delete_stock_arlrm(){
        stockAlarmSet.getStockAlarmList();
    }
    //선택한 재입고 알림삭제
    function seletct_delete(idx){
        //목록에서 해당 아이템 selected 처리

        //선택한 아이템 삭제 로직 실행
        delete_stock_arlrm();
    }

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 관심상품 <span>&gt;</span>관심상품
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    재입고 알림
                    <span class="row_info_text">재입고 알림 요청한 상품을 확인 하실 수 있습니다.</span>
                </h3>
                <form id="form_id_search" action="/front/mypage/stock-alarm"></form>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">재입고 알림 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:44px">
                        <col style="width:">
                        <col style="width:160px">
                        <col style="width:160px">
                        <col style="width:65px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>
                                <div class="mypage_check">
                                    <label>
                                        <input type="checkbox" name="freeboard_checkbox">
                                        <span></span>
                                    </label>
                                </div>
                            </th>
                            <th>상품명</th>
                            <th>재입고알림 신청일시</th>
                            <th>재입고알림 통보일시</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody id="id_alarm_List">
                    </tbody>
                </table>
                <div class="floatC" style="margin:8px 0">
                    <button type="button" class="btn_mypage_ok">선택상품 삭제</button>
                </div>
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging"></div>
                <!----// 페이징 ---->
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>