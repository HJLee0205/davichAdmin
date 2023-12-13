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
    <!-- 다음 에디터 스타일  -->
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>    
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 이벤트 &gt; 이벤트 상세</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                // 수정: 이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                jQuery('#updt_btn').on('click', function(e) {
                    var eventNo = $("#eventNo").val();
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var eventStatusCds = $("#eventStatusCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/event-update-form',
                            {eventNo : eventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, eventStatusCds : eventStatusCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                 });
                
                //목록 : 기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                jQuery('#event_list').on('click', function(e) {
                    var periodSelOption = $("#periodSelOption").val();
                    var searchStartDate = $("#searchStartDate").val();
                    var searchEndDate = $("#searchEndDate").val();
                    var eventStatusCds = $("#eventStatusCds").val();
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#pageNoOri").val();
                    Dmall.FormUtil.submit('/admin/promotion/event',
                            {periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, eventStatusCds : eventStatusCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                 });
                
                // 이벤트내용 
                $("#eventContentHtml").html($('#eventContentJstl').val());
                
            });
        </script>    
    </t:putAttribute>
    <t:putAttribute name="content">     
    <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <button class="btn gray" id="event_list">이벤트 리스트</button>
            </div>
            <h2 class="tlth2">이벤트 상세</h2>
            <div class="btn_box right">
                <button class="btn blue shot" id="updt_btn">수정하기</button>
            </div>
        </div>
        
        <!-- line_box -->
        <form id="formEventDtl" >
        <c:set var="eventDtl" value="${resultModel.data}" />
        <input type="hidden" name="periodSelOption" id="periodSelOption" value="${so.periodSelOption}" />
        <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
        <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
        <input type="hidden" name="eventStatusCds" id="eventStatusCds" value="${fn:join(so.eventStatusCds, ',')}" />
        <input type="hidden" name="searchWords"     id="searchWords" value="${so.searchWords}" />
        <input type="hidden" name="rows"            id="rows" value="${so.rows}" />
        <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />
        <input type="hidden" name="eventNo" id="eventNo" value="${eventDtl.eventNo}" />
        <div class="line_box fri">
            <h3 class="tlth3">이벤트 정보</h3>
            
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 이벤트등록표 입니다. 구성은 이벤트명, 설명, 기간, 내용, 웹전용 이벤트 배너, 모바일전용 이벤트 배너, 이벤트 상품,댓글 사용여부 등록 입니다.">
                    <caption>이벤트 상세</caption>
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>이벤트명</th>
                            <td>
                                ${eventDtl.eventNm}
                            </td>
                        </tr>
                        <tr>
                            <th>이벤트 설명</th>
                            <td>
                                ${eventDtl.eventDscrt}
                            </td>
                        </tr>
                        <tr>
                            <th>이벤트 기간</th>
                            <td>
                                ${fn:substring(eventDtl.applyStartDttm, 0, 4)}년 ${fn:substring(eventDtl.applyStartDttm, 4, 6)}월 ${fn:substring(eventDtl.applyStartDttm, 6, 8)}일 
                                ${fn:substring(eventDtl.applyStartDttm, 8, 10)}시 ${fn:substring(eventDtl.applyStartDttm, 10, 12)}분
                                ~
                                ${fn:substring(eventDtl.applyEndDttm, 0, 4)}년 ${fn:substring(eventDtl.applyEndDttm, 4, 6)}월 ${fn:substring(eventDtl.applyEndDttm, 6, 8)}일 
                                ${fn:substring(eventDtl.applyEndDttm, 8, 10)}시 ${fn:substring(eventDtl.applyEndDttm, 10, 12)}분
                             </td>
                        </tr>
                        <tr>
                            <th>당첨자 발표</th>
                            <td>
                                ${fn:substring(eventDtl.eventWngDttm, 0, 4)}년 ${fn:substring(eventDtl.eventWngDttm, 4, 6)}월 ${fn:substring(eventDtl.eventWngDttm, 6, 8)}일 
                                ${fn:substring(eventDtl.eventWngDttm, 8, 10)}시 ${fn:substring(eventDtl.eventWngDttm, 10, 12)}분
                            </td>
                        </tr>
                        <tr>
                            <th>이벤트 내용</th>
                                   <td>
                                         <div class="tblh" >
                                              <div class="disposal_log2" id="eventContentHtml"></div>
                                              <input type="hidden" id="eventContentJstl" value="${eventDtl.eventContentHtml}" />       
                                         </div> 
                                   </td>
                        </tr>
                        <tr>
                            <th>웹전용 이벤트배너</th>
                            <td>
                                <c:if test='${eventDtl.eventWebBannerImg ne ""}'><img src ="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventDtl.eventWebBannerImgPath}&id1=${eventDtl.eventWebBannerImg}" width="164" height="82"/></c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>모바일전용 이벤트배너</th>
                            <td>
                                <c:if test='${eventDtl.eventMobileBannerImg ne ""}'><img src ="${_IMAGE_DOMAIN}/image/image-view?type=EVENT&path=${eventDtl.eventMobileBannerImgPath}&id1=${eventDtl.eventMobileBannerImg}" width="164" height="82"/></c:if>
                            </td>
                        </tr>
                        <tr>
                            <th>댓글사용여부</th>
                            <td>
                               <c:if test='${eventDtl.eventCmntUseYn eq "Y"}'>
                                사용 
                               </c:if>
                               <c:if test='${eventDtl.eventCmntUseYn eq "N"}'>
                                미사용 
                               </c:if>
                            </td>
                        </tr>
                        <tr>
                        	<th>댓글권한</th>
                        	<td>
                        		<c:out value="${eventDtl.eventCmntAuthNm eq null ? '전체' : eventDtl.eventCmntAuthNm}" />
                        	</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            </div>
            <!-- //tblw -->
        </form>
        </div>
        <!-- //line_box -->
            
    </t:putAttribute>
</t:insertDefinition>
