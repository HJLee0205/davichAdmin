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
    <t:putAttribute name="title">홈 &gt; 설정 &gt; 결제 관리 &gt; 통합전자결제설정</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                
                // 검색
                $('#btn_id_search').on('click', function() {
                    $('#form_id_search').submit();
                });

                // 등록 화면
                $('#btn_id_save').on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/setup/config/payment/payment-config-new');
                });

                // 페이지네이션 활성
                $('#grid_id_paymentList').grid($('#form_id_search'));

            });

            // 수정
            function fn_updatePaymentInfo(shopCd) {
                location.href= "/admin/setup/config/payment/payment-config?shopCd=" + shopCd;
            }

            // 삭제
            function fn_deletePaymentInfo(shopCd) {
                // 삭제 처리
                Dmall.LayerUtil.confirm('선택된 전자결제 정보를 삭제하시겠습니까?', function() {
                    var url = '/admin/setup/config/payment/payment-config-delete',
                        param = {'pgCd':'02', 'shopCd':shopCd};

                    console.log("param = ", param);
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        //getSearchGoodsData();
                        Dmall.validate.viewExceptionMessage(result, 'form_id_search');
                        $('#form_id_search').submit();
                        //bannerSet.getBannerList();
                    });
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">통합전자결제관리</h2>
            </div>
            <div class="line_box fri">
                <form:form action="/admin/setup/config/payment/payment-list" id="form_id_search" commandName="so">
                    <form:hidden path="page" id="search_id_page" />
                    <form:hidden path="rows" />
                    <input type="hidden" name="sort" value="${so.sort}" />
                    <input type="hidden" name="pgCd" value="02" />
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="intxt search_bar">
                                <input name="shopNm" id="input_search_word" type="text" value="${so.shopNm}" placeholder=" 가입자명으로 검색해 주세요." maxlength="16">
                            </span>
                            <button class="search_bar_btn" id="btn_id_search">검색</button>
                        </div>
                        <div class="select_btn_right">
                            <a href="#none" class="btn_gray2" id="btn_id_save">신규 등록</a>
                        </div>
                    </div>
                </form:form>
                <div class="tblh th_l">
                    <table id="table_id_paymentList" summary="이표는 팝업관리 리스트 표 입니다. 구성은 체크박스, 메뉴및위치, 팝업구분, 팝업창명, 전시여부, 전시시작일시, 전시종료일시, 등록자ID, 등록자명, 등록 일시 입니다.">
                        <caption>팝업관리 리스트</caption>
                        <colgroup>
                            <col>
                            <col width="70%">
                            <col >
                        </colgroup>
                        <thead>
                        <tr>
                            <th>NO</th>
                            <th>가입자명</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody id="tbody_id_paymentList">
                        <c:forEach var="paymentList" items="${resultListModel.resultList}" varStatus="status">
                            <tr data-payment-no="${paymentList.shopCd}">
                                <td>${paymentList.sortNum}</td>
                                <td>${paymentList.shopNm}</td>
                                <td>
                                    <button type="button" class="btn_gray" onclick="fn_updatePaymentInfo('${paymentList.shopCd}');">수정</button>
                                    <button type="button" class="btn_gray" onclick="fn_deletePaymentInfo('${paymentList.shopCd}');">삭제</button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="bottom_lay" style="margin-top: 40px;">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
