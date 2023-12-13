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
    <t:putAttribute name="title">재입고 알림</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){

        /* 페이징 */
        $('#div_id_paging').grid(jQuery('#form_id_search'));

        /* 전체선택 */
        $("#allCheck").click(function(){
            //만약 전체 선택 체크박스가 체크된상태일경우
            StockAlarmUtil.allCheckBox();
        })
        /* 개별 삭제 */
        $('.direct-delete-btn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             StockAlarmUtil.reinwareAlarmNo = $(this).parents('tr').attr('data-alarm-no');
             Dmall.LayerUtil.confirm('삭제하시겠습니까?', StockAlarmDeleteUtil.directDeleteProc);
        });
        /* 선택 삭제 */
        $('#del_btn_select_stockAlarm').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            StockAlarmDeleteUtil.checkDelete();
        });
    });


    StockAlarmUtil = {
        reinwareAlarmNo : '',
        allCheck : function() {
            $('#allCheck').trigger('click');
        },
        allCheckBox : function() {
            if ($("#allCheck").prop("checked")) {
                //해당화면에 전체 checkbox들을 체크해준다a
                $("input[name=reinwareAlarmNo]").prop("checked", true);
                // 전체선택 체크박스가 해제된 경우
            } else {
                //해당화면에 모든 checkbox들의 체크를해제시킨다.
                $("input[name=reinwareAlarmNo]").prop("checked", false);
            }
        }
    }

    StockAlarmDeleteUtil = {
        deleteUrl : '/front/member/restock-notify-delete',
        completeDeleteMsg : function() { // 삭제 완료후 페이지 새로고침
            Dmall.LayerUtil.alert('재입고알림이 삭제 되었습니다.').done(function() {
                location.reload();
            });
        },
        checkDelete : function() { //선택상품 삭제
            var chkItem = $('input:checkbox[name=reinwareAlarmNo]:checked').length;
            if (chkItem == 0) {
                Dmall.LayerUtil.alert('삭제할 재입고알림을 선택해 주십시요');
                return;
            }
            Dmall.LayerUtil.confirm('삭제하시겠습니까?', StockAlarmDeleteUtil.deleteProc);
        },
        deleteProc : function() { //삭제 진행
            var param = {},key;
            var restockNotifyList = fn_selectedList();
            jQuery.each(restockNotifyList, function(i, o) {
                key = 'list[' + i + '].reinwareAlarmNo';
                param[key] = o;
            });
            Dmall.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    StockAlarmDeleteUtil.completeDeleteMsg();
                }
            });
        },
        directDeleteProc : function() { //개별 삭제 진행
            var url = '/front/member/restock-notify-delete';
            var param = {
                'list[0].reinwareAlarmNo' : StockAlarmUtil.reinwareAlarmNo
            };
            Dmall.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    StockAlarmDeleteUtil.completeDeleteMsg();
                }
            });
        }
    }

    // 그리드에서 선택된 재입고 알림번호 취득
    function fn_selectedList() {
        var selected = [];
        $('#id_alarm_List input:checked').each(function() {
            selected.push($(this).val());
        });
        return selected;
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 관심상품 <span>&gt;</span>재입고 알림
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
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
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
                                        <input type="checkbox" name="freeboard_checkbox" id="allCheck">
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
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                            <tr data-alarm-no="${resultModel.reinwareAlarmNo}">
                                <td>
                                    <div class="mypage_check">
                                    <label for="reinwareAlarmNo_${status.index}">
                                        <input type="checkbox" name="reinwareAlarmNo" id="reinwareAlarmNo_${status.index}" value="${resultModel.reinwareAlarmNo}">
                                        <span></span>
                                    </label>
                                </div>
                                </td>
                                <td class="textL">${resultModel.goodsNm}</td>
                                <td>${resultModel.strRegDttm}</td>
                                <td>${resultModel.alarmDttm}</td>
                                <td>
                                    <button type="button" class="direct-delete-btn btn_mypage_s03">삭제</button>
                                </td>
                            </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5">등록된 재입고 알림이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <div class="floatC" style="margin:8px 0">
                    <button type="button" id="del_btn_select_stockAlarm" class="btn_mypage_ok">선택상품 삭제</button>
                </div>
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>