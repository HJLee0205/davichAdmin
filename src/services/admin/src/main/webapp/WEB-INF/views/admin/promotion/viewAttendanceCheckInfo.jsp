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
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 출석체크 이벤트 상세</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                // 수정 : 이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                jQuery('#updt_btn').on('click', function(e) {
                    var eventNo = $("#eventNo").val();
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var eventMethodCds = $("#eventMethodCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/attendancecheck-update-form',
                            {eventNo : eventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, eventMethodCds : eventMethodCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                });
                
                //목록 : 기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                jQuery('#event_list').on('click', function(e) {
                   var periodSelOption = $("#periodSelOption").val();
                   var searchStartDate = $("#searchStartDate").val();
                   var searchEndDate = $("#searchEndDate").val();
                   var eventMethodCds = $("#eventMethodCds").val();
                   var searchWords = $("#searchWords").val();
                   var rows = $("#rows").val();
                   var pageNoOri = $("#pageNoOri").val();
                   Dmall.FormUtil.submit('/admin/promotion/attendancecheck',
                           {periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, eventMethodCds : eventMethodCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                 });
            });
        </script>       
    </t:putAttribute>
    <t:putAttribute name="content">     
    <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <button class="btn gray" id="event_list">출석체크 이벤트리스트</button>
            </div>
            <h2 class="tlth2">출석체크 이벤트 상세</h2>
            <div class="btn_box right">
                <button class="btn blue shot" id="updt_btn">수정하기</button>
            </div>
        </div>
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">이벤트 정보</h3>
            
            <!-- tblw -->
            <form id="form_info">
            <c:set var="result" value="${resultModel.data}" />
            <input type="hidden" name="periodSelOption" id="periodSelOption" value="${so.periodSelOption}" />
            <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
            <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
            <input type="hidden" name="eventMethodCds" id="eventMethodCds" value="${fn:join(so.eventMethodCds, ',')}" />
            <input type="hidden" name="searchWords"     id="searchWords" value="${so.searchWords}" />
            <input type="hidden" name="rows"            id="rows" value="${so.rows}" />
            <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />
            <input type="hidden" name="eventNo" id="eventNo" value="${result.eventNo}"/>
            <input type="hidden" name="eventKindCd" id="eventKindCd" value="02"/>
            <div class="tblw tblmany">
                <table summary="이표는 이벤트등록표 입니다. 구성은 출석체크명, 종류, 체크기간, 예외설정, 출석체크 형태, 참여방법, 출석체크 참여혜택, 참여권한설정 입니다.">
                    <caption>이벤트 등록</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>출석체크명</th>
                            <td>
                                ${result.eventNm}
                            </td>
                        </tr>
                        <tr>
                            <th>참여방법</th>
                            <td>
                                <c:if test='${result.eventMethodCd eq "01"}'> ${result.eventMethodCdNm}<span class="fc_pr1 fs_pr1">(로그인 시 자동 반영)</span></c:if>
                                <c:if test='${result.eventMethodCd eq "02"}'> ${result.eventMethodCdNm}<span class="fc_pr1 fs_pr1">(출석체크 버튼 클릭 시 반영)</span></c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>출석체크 기간</th>
                            <td>
                                 ${fn:substring(result.applyStartDttm, 0, 4)}년 ${fn:substring(result.applyStartDttm, 4, 6)}월 ${fn:substring(result.applyStartDttm, 6, 8)}일 
                                 ${fn:substring(result.applyStartDttm, 8, 10)}시 ${fn:substring(result.applyStartDttm, 10, 12)}분
                                 ~
                                 ${fn:substring(result.applyEndDttm, 0, 4)}년 ${fn:substring(result.applyEndDttm, 4, 6)}월 ${fn:substring(result.applyEndDttm, 6, 8)}일 
                                 ${fn:substring(result.applyEndDttm, 8, 10)}시 ${fn:substring(result.applyEndDttm, 10, 12)}분
                            </td>
                        </tr>
                        <tr>
                            <th>기간 예외설정</th>
                            <td>
                                <c:if test='${result.eventPeriodExptCd eq "01"}'> ${result.eventPeriodExptCdNm}</c:if> 
                                <c:if test='${result.eventPeriodExptCd eq "02"}'> ${result.eventPeriodExptCdNm}</c:if> 
                                <c:if test='${result.eventPeriodExptCd eq "03"}'> ${result.eventPeriodExptCdNm}</c:if> 
                            </td>
                        </tr>
                        <tr>
                            <th>출석 포인트 지급</th>
                            <td>
                                ${result.eventPvdPoint} 점 <span class="fc_pr1 fs_pr1">(1일 최대 지급 포인트를 의미함)</span>
                            </td>
                        </tr>
                        <tr>
                            <th>출석 포인트<br>유효기간 설정</th>
                            <td>
                                <c:if test='${result.eventPointApplyCd eq "01"}'>
<%--                                     ${fn:substring(result.pointApplyStartDttm, 0, 4)}년 ${fn:substring(result.pointApplyStartDttm, 4, 6)}월 ${fn:substring(result.pointApplyStartDttm, 6, 8)}일  --%>
<%--                                     ${fn:substring(result.pointApplyStartDttm, 8, 10)}시 ${fn:substring(result.pointApplyStartDttm, 10, 12)}분 --%>
<!--                                     ~ -->
                                    ${fn:substring(result.pointApplyEndDttm, 0, 4)}년 ${fn:substring(result.pointApplyEndDttm, 4, 6)}월 ${fn:substring(result.pointApplyEndDttm, 6, 8)}일 
<%--                                     ${fn:substring(result.pointApplyEndDttm, 8, 10)}시 ${fn:substring(result.pointApplyEndDttm, 10, 12)}분 --%>
                                </c:if>
                                <c:if test='${result.eventPointApplyCd eq "02"}'>
                                    ${result.eventApplyIssueAfPeriod} 개월 유효(사용기한 초과 포인트 자동 소멸)
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>출석 이벤트 조건</th>
                            <td>
                                <c:if test='${result.eventCndtCd eq "01"}'>
                                조건완성형: 총 참여횟수가 ${result.eventTotPartdtCndt}회 이상일 경우 이벤트 조건을 만족합니다. 
                                </c:if>    
                                <c:if test='${result.eventCndtCd eq "02"}'>
                                추가지급형: 총 참여횟수 ${result.eventTotPartdtCndt}회 만족 시 추가포인트를 지급합니다.
                                <span class="br2"></span>포인트 ${result.eventAddPvdPoint}점 추가지급
                                </c:if>    
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            </form>
            <!-- //tblw -->
            
        </div>
        <!-- //line_box -->
    </div>
        
    </t:putAttribute>
</t:insertDefinition>
