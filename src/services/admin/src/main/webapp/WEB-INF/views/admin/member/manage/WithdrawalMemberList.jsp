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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">탈퇴 회원 관리 > 회원</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function () {
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function () {$('#btn_id_search').trigger('click')});

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 검색
                $('#btn_id_search').on('click', function () {
                    var fromDttm = $("#srch_recv_sc01").val().replace(/-/gi, "");
                    var toDttm = $("#srch_recv_sc02").val().replace(/-/gi, "");
                    if (fromDttm && toDttm && fromDttm > toDttm) {
                        Dmall.LayerUtil.alert('검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#search_id_page").val("1");
                    $('#form_id_search').submit();
                });

                // select 변경 시 input 초기화
                $('select[name]').change(function (e) {
                    var name = $(this).attr('name');
                    if(name == 'withdrawalReasonCd') {
                        $('#etcWithdrawalReason').val('');
                    } else {
                        $('#searchWords').val('');
                    }
                });
            });

            //회원 상세 정보
            function viewMemInfoDtl(memberNo) {
                Dmall.FormUtil.submit('/admin/member/manage/withdrawal-member-info', {memberNo: memberNo});
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    회원 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">탈퇴 회원 관리</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/member/manage/leaving-member" id="form_id_search" commandName="memberManageSO">
                        <form:hidden path="page" id="search_id_page"/>
                        <form:hidden path="rows"/>
                        <div class="search_tbl">
                            <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입방법, 검색어 입니다.">
                                <caption>탈퇴회원관리</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>탈퇴일</th>
                                    <td>
                                        <tags:calendar from="withdrawalStDttm" to="withdrawalEndDttm" fromValue="${memberManageSO.withdrawalStDttm}" toValue="${memberManageSO.withdrawalEndDttm}" idPrefix="srch_recv"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>탈퇴유형</th>
                                    <td>
                                        <tags:radio codeStr=":전체;03:일반;02:강제탈퇴" name="withdrawalTypeCd" idPrefix="widhdrawalTypeCd" value="${memberManageSO.withdrawalTypeCd}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>탈퇴사유</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <label for="withdrawalReasonCd"></label>
                                                <select name="withdrawalReasonCd" id="withdrawalReasonCd">
                                                    <cd:option codeGrp="WITHDRAWAL_REASON_CD" includeTotal="true" value="${memberManageSO.withdrawalReasonCd}"/>
                                                </select>
                                            </span>
                                            <input type="text" name="etcWithdrawalReason" id="etcWithdrawalReason" value="${memberManageSO.etcWithdrawalReason}"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <label for="searchType"></label>
                                                <select name="searchType" id="searchType">
                                                    <tags:option codeStr="id:아이디;name:이름;" value="${memberManageSO.searchType}"/>
                                                </select>
                                            </span>
                                            <input type="text" id="searchWords" name="searchWords" value="${memberManageSO.searchWords}"/>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                              총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>명의 회원이 검색되었습니다.
                            </span>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh">
                        <table summary="회원 리스트" id="table_id_memberList">
                            <caption>회원 리스트</caption>
                            <colgroup>
                                <col width="7%">
                                <col width="15%">
                                <col width="46%">
                                <col width="20%">
                                <col width="12%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>No</th>
                                <th>아이디</th>
                                <th>사유</th>
                                <th>탈퇴일시</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_memberList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="5">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="memList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr>
                                            <td>${memList.rowNum}</td>
                                            <c:set var="result" value="${fn:substring(memList.loginId, 0, 5)}"/>
                                            <c:forEach begin="5" end="${fn:length(memList.loginId)}">
                                                <c:set var="result" value="${result.concat('*')}"/>
                                            </c:forEach>
                                            <td>${result}</td>
                                            <td class="txtl">
                                                <c:choose>
                                                    <c:when test="${memList.withdrawalTypeCd eq '02'}">
                                                        강제탈퇴
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${memList.withdrawalReasonNm}
                                                        <c:if test="${not empty memList.withdrawalReasonNm}">
                                                            &nbsp;:&nbsp;
                                                        </c:if>
                                                        ${memList.etcWithdrawalReason}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${memList.withdrawalDttm}</td>
                                            <td>
                                                <div class="pop_btn">
                                                    <a href="#none" class="btn_gray" onclick="viewMemInfoDtl('${memList.memberNo}');">상세</a>
                                                </div>
                                            </td>
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
                        <grid:paging resultListModel="${resultListModel}"/>
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>