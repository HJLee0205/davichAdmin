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
    <t:putAttribute name="title">정산집계 > 업체</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                // 정산집계 버튼 클릭
                $('#btn_regist').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if (Dmall.validation.isEmpty($("input[name=calculateStartdt]").val())) {
                        Dmall.LayerUtil.alert("정산 시작일자를 입력하세요.", "알림");
                        return false;
                    }

                    if (Dmall.validation.isEmpty($("input[name=calculateEnddt]").val())) {
                        Dmall.LayerUtil.alert("정산 종료일자를 입력하세요.", "알림");
                        return false;
                    }

                    if (Dmall.validation.isEmpty($("input[name=calculateDttm]").val())) {
                        Dmall.LayerUtil.alert("정산일자를 입력하세요.", "알림");
                        return false;
                    }

                    var param = {};
                    param.sellerNo = $("#sellerNo option:selected").val();
                    param.calculateDttm = $("input[name=calculateDttm]").val();
                    param.calculateStartdt = $("input[name=calculateStartdt]").val();
                    param.calculateEnddt = $("input[name=calculateEnddt]").val();

                    Dmall.LayerUtil.confirm('정산집계를 하시겠습니까?', function () {

                        Dmall.AjaxUtil.getJSON('/admin/seller/seller-calculation', param, function (result) {
                            if (result.success) {
                                Dmall.FormUtil.submit('/admin/seller/calc-total-list', param);
                            }
                        });
                    });
                });

                // input에 날짜 세팅
                if (${so.calculateStartdt != null && so.calculateEnddt != null && so.calculateDttm != null}) {
                    $('input[name=calculateStartdt]').val('${so.calculateStartdt}');
                    $('input[name=calculateEnddt]').val('${so.calculateEnddt}');
                    $('input[name=calculateDttm]').val('${so.calculateDttm}');
                }

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">정산집계</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form id="form_id_search">
                        <input type="hidden" name="_action_type" value="INSERT" />
                        <input type="hidden" name="page" id="search_id_page">
                        <input type="hidden" name="rows">
                        <div class="search_tbl">
                            <table summary="">
                                <caption>판매자 관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>기간</th>
                                    <td>
                                        <tags:calendar from="calculateStartdt" to="calculateEnddt" idPrefix="srch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>판매자</th>
                                    <td>
                                        <span class="select">
                                            <label for="sel_seller">전체</label>
                                            <select name="sellerNo" id="sel_seller">
                                                <cd:sellerOption siteno="${so.siteNo}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>정산일자</th>
                                    <td>
                                        <span class="intxt"><input type="text" name="calculateDttm" value="" id="srch_sc01" class="bell_date_sc" maxlength="10" placeholder="YYYY-MM-DD"></span>
                                        <a href="javascript:void(0)" class="date_sc ico_comm" id="srch_date01">달력이미지</a>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn--black" id="btn_regist">정산집계</a>
                        </div>
                    </form>
                </div>
                <div class="line_box " id="grid_id_sellerList">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>개의 정산집계건이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="판매자 리스트" id="table_id_sellerList">
                            <caption>판매자 리스트</caption>
                            <colgroup>
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="12%">
                                <col width="13%">
                                <col width="13%">
                                <col width="14%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>정산일자</th>
                                <th>업체명</th>
                                <th>정산기준 시작일</th>
                                <th>정산기준 종료일</th>
                                <th>결제금액</th>
                                <th>수수료</th>
                                <th>정산금액</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_memberList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="8">정산집계 데이터가 존재하지 않습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="sellerList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr data-grp-cd="${sellerList.calculateNo}">
                                            <td>${sellerList.rowNum}</td>
                                            <td>${sellerList.calculateDttm}</td>
                                            <td>${sellerList.sellerNm}</td>
                                            <td>${sellerList.calculateStartdt}</td>
                                            <td>${sellerList.calculateEnddt}</td>
                                            <td><fmt:formatNumber value="${sellerList.paymentAmt}" pattern="#,###" /></td>
                                            <td><fmt:formatNumber value="${sellerList.cmsTotal}" pattern="#,###" /></td>
                                            <td><fmt:formatNumber value="${sellerList.calculateAmt}" pattern="#,###" /></td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}" />
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
