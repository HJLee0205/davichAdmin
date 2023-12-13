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
    <t:putAttribute name="title">나의 쿠폰</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));

            //달력
            $(function() {
                $( ".datepicker" ).datepicker();
            });

            //검색
            $('.btn_date').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_list').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('/front/coupon/coupon-list', param);
            });

            //적용대상
            $('.btn_coupon_ok').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                $('#apply_content').html('');
                var d = $(this).data();

                var htmlApplyTarget = '';
                //alert(d.couponNo + ' : 쿠폰 적용 대상 / '+ d.couponApplyLimitCd);
                if(d.couponApplyLimitCd == '01') {
                    htmlApplyTarget += '<table class="tProduct_Insert" style="margin-top:5px">';
                    htmlApplyTarget += '    <caption><h1 class="blind">쿠폰적용 선택 표 입니다.</h1></caption>';
                    htmlApplyTarget += '    <colgroup>';
                    htmlApplyTarget += '        <col style="width:24%">';
                    htmlApplyTarget += '        <col style="width:">';
                    htmlApplyTarget += '    </colgroup>';
                    htmlApplyTarget += '    <tbody>';
                    htmlApplyTarget += '        <tr>';
                    htmlApplyTarget += '            <th class="order_tit">적용 상품 선택</th>';
                    htmlApplyTarget += '            <td>전체상품</td>';
                    htmlApplyTarget += '        </tr>';
                    htmlApplyTarget += '    </tbody>';
                    htmlApplyTarget += '</table>';

                    $('#apply_content').html(htmlApplyTarget);
                    Dmall.LayerPopupUtil.open($('#coupon_apply_target'));
                } else {
                    var url = "/front/coupon/coupon-applytarget-list";
                    var param = {couponNo:d.couponNo, couponApplyLimitCd:d.couponApplyLimitCd, couponApplyTargetCd:d.couponApplyTargetCd};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            htmlApplyTarget += '<table class="tProduct_Insert" style="margin-top:5px">';
                            htmlApplyTarget += '    <caption><h1 class="blind">쿠폰적용 선택 표 입니다.</h1></caption>';
                            htmlApplyTarget += '    <colgroup>';
                            htmlApplyTarget += '        <col style="width:24%">';
                            htmlApplyTarget += '        <col style="width:">';
                            htmlApplyTarget += '    </colgroup>';
                            htmlApplyTarget += '    <tbody>';
                            if(d.couponApplyTargetCd == '02' || d.couponApplyTargetCd == '03') {
                                if(result.data.couponTargetCtgList != null && result.data.couponTargetCtgList.length > 0){
                                    htmlApplyTarget += '        <tr>';
                                    if(d.couponApplyLimitCd == "02") {
                                        htmlApplyTarget += '        <th class="order_tit">적용 카테고리</th>';
                                    } else if(d.couponApplyLimitCd == "03"){
                                        htmlApplyTarget += '        <th class="order_tit">적용 예외 카테고리</th>';
                                    }
                                    htmlApplyTarget += '            <td>';
                                    htmlApplyTarget += '                <ul class="coupon_ok_category">';
                                    $.each(result.data.couponTargetCtgList, function (i){
                                        htmlApplyTarget += '                    <li>- '+result.data.couponTargetCtgList[i].ctgNm+'</li>';
                                    })
                                    htmlApplyTarget += '                <ul>';
                                    htmlApplyTarget += '            </td>';
                                    htmlApplyTarget += '        </tr>';
                                }
                            }
                            if(d.couponApplyTargetCd == '01' || d.couponApplyTargetCd == '03') {
                                if(result.data.couponTargetGoodsList != null && result.data.couponTargetGoodsList.length > 0){
                                    htmlApplyTarget += '        <tr>';
                                    if(d.couponApplyLimitCd == "02") {
                                        htmlApplyTarget += '        <th class="order_tit">적용 상품</th>';
                                    } else if(d.couponApplyLimitCd == "03"){
                                        htmlApplyTarget += '        <th class="order_tit">적용 예외 상품</th>';
                                    }
                                    htmlApplyTarget += '            <td style="padding:0">';
                                    htmlApplyTarget += '                <div class="coupon_ok_product_scroll">';
                                    htmlApplyTarget += '                    <ul class="coupon_select_list">';
                                    $.each(result.data.couponTargetGoodsList, function (j){

                                        htmlApplyTarget += '                        <li class="pix_img">';
                                        htmlApplyTarget += '                            <img src="../img/mypage/coupon_product_img01.gif" alt="상품 이미지">';
                                        htmlApplyTarget += '                            <div class="goods_title">';
                                        htmlApplyTarget += '                                '+result.data.couponTargetGoodsList[j].goodsNm;
                                        htmlApplyTarget += '                            </div>';
                                        htmlApplyTarget += '                        </li>';
                                    });
                                    htmlApplyTarget += '                    </ul>';
                                    htmlApplyTarget += '                </div>';
                                    htmlApplyTarget += '            </td>';
                                    htmlApplyTarget += '        </tr>';
                                }
                            }
                            htmlApplyTarget += '    </tbody>';
                            htmlApplyTarget += '</table>';

                            $('#apply_content').html(htmlApplyTarget);
                            Dmall.LayerPopupUtil.open($('#coupon_apply_target'));
                        }
                    });
                }
            });

            // 적용대상 팝업 닫기
            $('.btn_mypage_ok').on('click', function() {
                Dmall.LayerPopupUtil.close('coupon_apply_target');
            });
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- 마이페이지 메인  --->
        <div class="contents fixwid">
            <!--- category header 카테고리 location과 동일 --->
            <div id="category_header">
                <div id="category_location">
                    <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 혜택 <span>&gt;</span>나의 쿠폰
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
                    <form:form id="form_id_list" commandName="so">
                    <form:hidden path="page" id="page" />
                    <h3 class="mypage_con_tit">
                        나의 쿠폰
                    </h3>
                    <div class="date_select_area">
                        <p class="date_select_title">- 기간검색</p>
                        <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                        <input type="text" name="fromRegDt" id="event_start" class="datepicker date" style="margin-left:8px" value="${so.fromRegDt}" readonly="readonly" onkeydown="return false"> ~ <input type="text" name="toRegDt" id="event_end" class="datepicker date" value="${so.toRegDt}" readonly="readonly" onkeydown="return false">
                        <button type="button" class="btn_date" style="margin-left:8px">조회하기</button>
                    </div>

                    <table class="tCart_Board">
                        <caption>
                            <h1 class="blind">나의 쿠폰 내용입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:11%">
                            <col style="width:12%">
                            <col style="width:10%">
                            <col style="width:12%">
                            <col style="width:12%">
                            <col style="width:14%">
                            <col style="width:10%">
                            <col style="width:7%">
                            <col style="width:12%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>종류</th>
                                <th>발급일자</th>
                                <th>쿠폰명</th>
                                <th>제한금액</th>
                                <th>기간제한</th>
                                <th>혜택</th>
                                <th>적용대상</th>
                                <th>사용여부</th>
                                <th>사용일</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${fn:length(resultListModel.resultList) > 0}">
                            <c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">
                            <tr>
                                <td class="f12">
                                    ${couponList.couponKindCdNm}
                                    <!-- 온라인-기념일<br>
                                    (다운로드) -->
                                </td>
                                <td class="f12">${couponList.issueDttm}</td>
                                <td class="f12">${couponList.couponNm}</td>
                                <td class="f12">
                                    <fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상<br>
                                    구매시
                                </td>
                                <td class="f12">
                                    <c:choose>
                                        <c:when test="${couponList.couponApplyPeriodCd eq '01' }">
                                        ${couponList.cpApplyStartDttm}<br>
                                        ~ ${couponList.cpApplyEndDttm}
                                        </c:when>
                                        <c:otherwise>
                                        발급일로부터 <br>${couponList.couponApplyIssueAfPeriod}일
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="f12">
                                    ${couponList.couponBnfValue}${couponList.bnfUnit}할인
                                    <c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
                                    <br>(최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                                    </c:if>
                                </td>
                                <td class="f12">
                                    <button type="button" class="btn_coupon_ok" data-coupon-no="${couponList.couponNo}" data-coupon-apply-limit-cd="${couponList.couponApplyLimitCd}" data-coupon-apply-target-cd="${couponList.couponApplyTargetCd}">적용</button>
                                </td>
                                <td class="f12">${couponList.useYn}</td>
                                <td class="f12">
                                <c:choose>
                                    <c:when test="${couponList.useDttm eq null}">
                                    -
                                    </c:when>
                                    <c:otherwise>
                                    ${couponList.useDttm}
                                    </c:otherwise>
                                </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            </c:when>
                            <c:otherwise>
                            <tr>
                                <td colspan="9">조회된 데이터가 없습니다.</td>
                            </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>

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

        <!--- popup 쿠폰적용 대상 --->
        <div class="popup_coupon_select" id="coupon_apply_target" style="display:none">
            <div class="popup_header">
                <h1 class="popup_tit">쿠폰적용 대상</h1>
                <button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div id="apply_content"></div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_mypage_ok">닫기</button>
                </div>
            </div>
        </div>
        <!---// popup 쿠폰적용 대상 --->
    </t:putAttribute>
</t:insertDefinition>