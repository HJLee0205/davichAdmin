<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">쿠폰존 관리 > 프로모션 설정</t:putAttribute>ㅂ
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                // 검색
                $('#btn_coupon_search').on('click', function () {
                    var sDate = $("#srch_sc01").val().replace(/-/g, "")
                    var eDate = $("#srch_sc02").val().replace(/-/g, "")

                    if (sDate > eDate) {
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return false;
                    }

                    $("#search_id_page").val("1");
                    $('#form_coupon_search').attr('action', '/admin/promotion/coupon');
                    $('#form_coupon_search').submit();
                });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_coupon_search'));

                // 엑셀 다운로드
                $("#btn_download").on("click", function () {
                    $('#form_coupon_search').attr('action', '/admin/promotion/coupon-excel-download');
                    $('#form_coupon_search').submit();
                    $('#form_coupon_search').attr('action', '/admin/promotion/coupon');
                });

                // 수정
                $(document).on("click", "#updt_btn", function () {
                    var couponNo = $(this).parents('tr').data("coupon-no");
                    var searchStartDate = $("#srch_sc01").val();
                    var searchEndDate = $("#srch_sc02").val();
                    var couponKindCds = [];
                    $("input[name='couponKindCds']:checked").each(function (i) {
                        couponKindCds.push($(this).val());
                    });
                    var searchWordsNoChiper = $("#searchWordsNoChiper").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#search_id_page").val();
                    Dmall.FormUtil.submit('/admin/promotion/coupon-update-form',
                        {
                            couponNo: couponNo,
                            searchStartDate: searchStartDate,
                            searchEndDate: searchEndDate,
                            couponKindCds: couponKindCds,
                            searchWordsNoChiper: searchWordsNoChiper,
                            rows: rows,
                            pageNoOri: pageNoOri
                        });
                });

                // 복사
                $(document).on("click", "#copy_btn", function () {
                    var couponNo = $(this).parents('tr').data("coupon-no");

                    Dmall.LayerUtil.confirm('쿠폰 정보를 복사하시겠습니까?', function () {
                        var url = '/admin/promotion/coupon-copy',
                            param = {'couponNo': couponNo};

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {

                            Dmall.validate.viewExceptionMessage(result, 'popupForm');

                            if (result == null || result.success != true) {
                                return;
                            } else {
                                Dmall.LayerUtil.alert("쿠폰 정보가 복사 되었습니다.");
                                $('#btn_coupon_search').click();
                            }
                        });
                    });
                });

                // 선택 삭제
                $("#del_coupon_btn").on("click", function () {
                    if ($("#cpList input[type=checkbox]:checked").length == 0) {
                        Dmall.LayerUtil.alert("삭제할 쿠폰을 선택해주세요");
                        return false;
                    }

                    Dmall.LayerUtil.confirm('삭제한 쿠폰은 되돌릴 수 없습니다.<br>삭제하시겠습니까?', delCoupon);
                });

                // 쿠폰등록
                $('#regist_coupon_btn').on('click', function () {
                    Dmall.FormUtil.submit('/admin/promotion/coupon-insert-form');
                });
            });

            // 선택 삭제
            function delCoupon() {
                var url = '/admin/promotion/coupon-info-delete';
                var param = {};
                var $selected = $("#cpList input[type=checkbox]:checked");

                jQuery.each($selected, function (i, o) {
                    param['list['+ i +'].couponNo'] = $(o).parents('tr').data('coupon-no');
                    param['list['+ i +'].couponApplyLimitCd'] = $(o).parents('tr').data('coupon-limit-cd');
                    param['list['+ i +'].couponApplyTargetCd'] = $(o).parents('tr').data('coupon-target-cd');
                });

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        $('#btn_coupon_search').trigger('click');
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    프로모션 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">쿠폰존 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <form:form id="form_coupon_search" commandName="so">
                        <form:hidden path="page" id="search_id_page" value=""/>
                        <form:hidden path="rows" id="rows" value=""/>
                        <input type="hidden" name="sort" value="${so.sort}"/>
                        <div class="search_tbl">
                            <table summary="이표는 쿠폰 검색 표 입니다. 구성은 기간, 종류, 검색어 입니다.">
                                <caption>판매상품관리 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>생성일</th>
                                    <td>
                                        <tags:calendar from="searchStartDate" to="searchEndDate"
                                                       fromValue="${so.searchStartDate}" toValue="${so.searchEndDate}"
                                                       idPrefix="srch" hasTotal="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>종류</th>
                                    <td class="coupon_cate">
                                        <code:checkbox name="couponKindCds" codeGrp="COUPON_KIND_CD"
                                                       idPrefix="couponKindCd" value="${so.couponKindCd}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <form:input path="searchWordsNoChiper" cssClass="text"
                                                        cssErrorClass="text medium error" size="20" maxlength="30"/>
                                            <form:errors path="searchWordsNoChiper" cssClass="errors"/>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->
                    </form:form>
                    <div class="btn_box txtc">
                        <button id="btn_coupon_search" class="btn green">검색</button>
                    </div>
                </div>
                <div class="line_box pb">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>개의 상품이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table>
                            <colgroup>
                                <col width="50px">
                                <col width="90px">
                                <col width="12%">
                                <col width="26%">
                                <col width="12%">
                                <col width="12%">
                                <col width="8%">
                                <col width="12%">
                                <col width="8%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"/></span>
                                    </label>
                                </th>
                                <th>쿠폰번호</th>
                                <th>종류</th>
                                <th>쿠폰명</th>
                                <th>사용제한금액</th>
                                <th>유효기간</th>
                                <th>혜택</th>
                                <th>발급/사용</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="cpList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="9">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="couponList" items="${resultListModel.resultList}"
                                               varStatus="status">
                                        <tr data-coupon-no="${couponList.couponNo}"
                                            data-coupon-limit-cd="${couponList.couponApplyLimitCd}"
                                            data-coupon-target-cd="${couponList.couponApplyTargetCd}">
                                            <td>
                                                <label for="chack05_${status.count}" class="chack"><span class="ico_comm">
                                                    <input type="checkbox" name="couponNo" id="chack05_${status.count}"
                                                           value="${couponList.couponNo}"/>
                                                </span></label>
                                            </td>
                                            <td>${couponList.couponNo}</td>
                                            <td>${couponList.couponKindCdNm}<br/>
                                                <c:choose>
                                                    <c:when test="${couponList.offlineOnlyYn eq 'Y'}">
                                                        (오프라인)
                                                    </c:when>
                                                    <c:when test="${couponList.offlineOnlyYn eq 'N'}">
                                                        (온라인)
                                                    </c:when>
                                                    <c:otherwise>
                                                        (온/오프라인)
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="txtl">${couponList.couponNm}</td>
                                            <td id="couponUseLimitAmt"><fmt:formatNumber
                                                    value="${couponList.couponUseLimitAmt}" pattern="#,###"/> 원 이상구매시
                                            </td>
                                            <td id="couponApplyPeriod">
                                                <c:if test="${couponList.couponApplyPeriodCd eq '01'}">
                                                    ${couponList.applyStartDttm} ~ <br/>${couponList.applyEndDttm}
                                                </c:if>
                                                <c:if test="${couponList.couponApplyPeriodCd eq '02'}">
                                                    발급일로부터 ${couponList.couponApplyIssueAfPeriod}일
                                                </c:if>
                                                <c:if test="${couponList.couponApplyPeriodCd eq '03'}">
                                                    구매확정일로부터 ${couponList.couponApplyConfirmAfPeriod}일
                                                </c:if>
                                            </td>
                                            <td id="couponBnf">
                                                <c:if test="${couponList.couponBnfCd eq '01'}">
                                                    ${couponList.couponBnfValue}%할인 <br/>
                                                    최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}"
                                                                         pattern="#,###"/>원 할인
                                                </c:if>
                                                <c:if test="${couponList.couponBnfCd eq '02'}">
                                                    <fmt:formatNumber value="${couponList.couponBnfDcAmt}"
                                                                      pattern="#,###"/>원 할인
                                                </c:if>
                                            </td>
                                            <td>
                                                발급 [<span class="issue"
                                                          id="issueCnt_${couponList.rownum}">${couponList.issueCnt}</span>]건
                                                / 사용 [<span class="use">${couponList.useCnt}</span>]건
                                            </td>
                                            <td>
                                                <div class="btn_gray4_wrap">
                                                    <button class="btn_gray4" id="updt_btn">수정</button>
                                                    <button class="btn_gray4 btn_gray4_right" id="copy_btn">복사</button>
                                                </div>
                                            </td>
                                            <td style="display:none;">${couponList.rownum}</td>
                                            <td style="display:none;"><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
                                                                                      value="${couponList.regDttm}"/></td>
                                            <td style="display:none;">
                                                <div class="pop_btn">
                                                    <jsp:useBean id="now" class="java.util.Date"/>
                                                    <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="today"/>
                                                    <fmt:parseDate value="${couponList.applyEndDttm}"
                                                                   pattern="yyyy-MM-dd" var="applyEnd"/>
                                                    <fmt:formatDate value="${applyEnd}" pattern="yyyyMMdd"
                                                                    var="applyEndDttm"/>
                                                    <!-- 유효기간 지난 쿠폰은 발급하기btn 보이지 않음 -->
                                                    <c:if test="${(couponList.couponKindCd eq '05') and ( (applyEndDttm - today > 0) or (couponList.couponApplyPeriodCd eq '02') )}">
                                                        <button class="btn_gray" name="coupon_issue_popup_btn">발급하기
                                                        </button>
                                                        <br/>
                                                    </c:if>
                                                    <button class="motion_coupon" name="issue_use_hist_btn">
                                                        발급 [<span class="issue"
                                                                  id="issueCnt_${couponList.rownum}">${couponList.issueCnt}</span>]건
                                                        / 사용 [<span class="use">${couponList.useCnt}</span>]건
                                                    </button>
                                                </div>
                                            </td>
                                            <td style="display:none">
                                                쿠폰 전체 개수
                                                <input type="hidden" id="couponQttLimitCnt_${couponList.rownum}"
                                                       value="${couponList.couponQttLimitCnt}">
                                            </td>
                                            <td style="display:none">
                                                쿠폰수량 제한코드 : 01 수량무제한 02 수량 제한
                                                <input type="hidden" id="couponQttLimitCd_${couponList.rownum}"
                                                       value="${couponList.couponQttLimitCd}">
                                            </td>
                                            <td style="display:none">
                                                쿠폰적용대상코드(상품/카테고리) - 쿠폰삭제 시 필요
                                                <input type="hidden" value="${couponList.couponApplyTargetCd}">
                                            </td>
                                            <td style="display:none">
                                                중복다운로드 가능여부
                                                <input type="hidden" value="${couponList.couponDupltDwldPsbYn}">
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}"/>
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="del_coupon_btn">선택 삭제</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="regist_coupon_btn">쿠폰등록</button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>