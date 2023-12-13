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
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 할인이벤트 &gt; 출석체크이벤트 목록</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            jQuery(document).ready(function() {
                
                // 검색
                $('#btn_id_search_btn').on('click', function() {
                    var sDate = $("#srch_sc01").val().replace(/-/g, "")
                    var eDate = $("#srch_sc02").val().replace(/-/g, "")
                    if( ((sDate == "") ? 19000101 : sDate) > ((eDate == "") ? 99991231 : eDate) ){
                        Dmall.LayerUtil.alert('시작일이 종료일보다 늦은 경우 조회가 불가합니다.');
                        return false;
                    } else if( $("input[name='eventMethodCds']:checked").length == 0 ){
                        Dmall.LayerUtil.alert("참여방법을 선택해주세요");
                        return false;
                    } else {
                        $("#search_id_page").val("1");
                        $("#form_id_search").submit();
                    }
                });
                
                // 삭제btn 클릭
                $("#del_attendanceCheck_btn").on('click', function(){
                    if(jQuery("#grid_id_attendanceCheckList tr td input[type='checkbox']:checked").length == ''){
                        Dmall.LayerUtil.alert("삭제할 목록을 선택해주세요")
                        return false;
                    }
                    Dmall.LayerUtil.confirm('정말로 삭제하시겠습니까?', delAttendanceCheck,'','출석체크이벤트 삭제','체크박스에 체크한 목록을 삭제합니다.');
                })
                
                //상세 : 이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                $(document).on("click", "#attendanceCheckNm", function(e){
                var eventNo = jQuery(this).parent().parent().data("event-no");
                var periodSelOption = $("#srch_id_periodSelOption").val();
                var searchStartDate = $("#srch_sc01").val();
                var searchEndDate = $("#srch_sc02").val();
                var eventMethodCds = [];
                    $("input[name='eventMethodCds']:checked").each(function(i){
                        eventMethodCds.push( $(this).val() );
                    });
                var searchWords = $("#searchWords").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#search_id_page").val();
                Dmall.FormUtil.submit('/admin/promotion/attendance-check-info',
                        {eventNo : eventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, 
                         eventMethodCds : eventMethodCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});    
                });   
                
                //수정 : 이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                $(document).on("click", "#updt_btn", function(e){
                var eventNo = jQuery(this).parent().parent().data("event-no");
                var periodSelOption = $("#srch_id_periodSelOption").val();
                var searchStartDate = $("#srch_sc01").val();
                var searchEndDate = $("#srch_sc02").val();
                var eventMethodCds = [];
                    $("input[name='eventMethodCds']:checked").each(function(i){
                        eventMethodCds.push( $(this).val() );
                    });
                var searchWords = $("#searchWords").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#search_id_page").val();
                Dmall.FormUtil.submit('/admin/promotion/attendancecheck-update-form',
                        {eventNo : eventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, 
                         eventMethodCds : eventMethodCds, searchWords : searchWords, rows: rows, pageNoOri : pageNoOri});
                });   
            
                // 그리드 적용
                $('#grid_id_attendanceCheckList').grid($('#form_id_search'));
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search_btn').trigger('click') });

            });
            
            //삭제
            function delAttendanceCheck(){
                var url = 'event-delete';
                var param = {};
                var $selected = jQuery("#grid_id_attendanceCheckList tr td input[type='checkbox']:checked");
                var list = {};
                var eventNo;
                
                jQuery.each($selected, function(i, o) {
                    eventNo = {'eventNo' : $(o).parents('tr').data('eventNo')};
                    param['list[' + i + '].eventNo'] = $(o).parents('tr').data('eventNo');
                });

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                      if(result.success) {
                           $('#btn_id_search_btn').trigger('click');
                    }
                });
            }
        </script>        
    </t:putAttribute>
    
    <!-- 이벤트 목록 -->
    <t:putAttribute name="content">
          <div class="sec01_box">
              <div class="tlt_box">
                  <h2 class="tlth2">출석체크이벤트 리스트</h2>

                  <div class="btn_box right">
                      <a href="/admin/promotion/attendancecheck-insert-form" class="btn blue">이벤트 만들기</a>
                  </div>
              </div>
              
              <!-- search_box -->
              <div class="search_box">
                  <!-- search_tbl -->
                  <form:form id="form_id_search" commandName="so">
                      <form:hidden path="page" id="search_id_page" value="" />
                      <form:hidden path="rows" id="rows" value="" />
                      <input type="hidden" name="sort" value="${so.sort}" />    
                      <div class="search_tbl">
                      <table summary="이표는 이벤트 검색 표 입니다. 구성은 기간, 종류, 검색어 입니다.">
                          <caption>이벤트관리 검색</caption>
                          <colgroup>
                              <col width="15%">
                              <col width="85%">
                          </colgroup>
                          <tbody>
                              <tr>
                                  <th>기간</th>
                                  <td>
                                     <span class="select"> 
                                         <label for="srch_id_periodSelOption"></label>
                                            <select name="periodSelOption" id="srch_id_periodSelOption"> 
                                                <tags:option codeStr="applyStartDttm:이벤트 시작일;applyEndDttm:이벤트 종료일" value="${so.periodSelOption}" /> 
                                            </select> 
                                     </span>
                                  <tags:calendar from="searchStartDate" to="searchEndDate" fromValue="${so.searchStartDate}" toValue="${so.searchEndDate}" idPrefix="srch" hasTotal="true" />
                                  </td>
                              <tr>
                                  <th>참여방법</th>
                                  <td>
                                      <c:set var="eventMethodCds" value="${fn:join(so.eventMethodCds, ' ')}"/>
                                      <label for="eventMethodCd1" class="chack mr20<c:if test="${fn:contains(eventMethodCds,'01')}"> on</c:if>">
                                          <span class="ico_comm">
                                             <form:checkbox path="eventMethodCds" id="eventMethodCd1" value="01" label="" cssClass="blind"/>
                                          </span>
                                          로그인형
                                      </label>
                                      <label for="eventMethodCd2" class="chack mr20<c:if test="${fn:contains(eventMethodCds,'02')}"> on</c:if>">
                                          <span class="ico_comm">
                                             <form:checkbox path="eventMethodCds" id="eventMethodCd2" value="02" label="" cssClass="blind"/>
                                          </span>
                                          스템프형
                                      </label>
                                      <a href="#none" class="all_choice"><span class="ico_comm"></span> 전체</a>
                                  </td>
                              </tr>
                              
                              <tr>
                                  <th>검색어</th>
                                  <td>
                                      <div class="select_inp">
                                          <span>
                                              <label for="eventNmSel">이벤트명</label>
                                              <select name="" id="eventNmSel">
                                                  <option value="">이벤트명</option>
                                              </select>
                                          </span>
                                          <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="20" maxlength="30" />
                                          <form:errors path="searchWords" cssClass="errors"  />
                                      </div>
                                  </td>
                              </tr>
                          </tbody>
                      </table>
                  </div>
                  <!-- //search_tbl -->

                  </form:form>
                  <div class="btn_box txtc">
                      <button id="btn_id_search_btn" class="btn green" >검색</button>
                  </div>
              </div>
              <!-- //search_box -->
              <grid:table id="grid_id_attendanceCheckList" so="${so}" resultListModel="${resultListModel}" sortOptionStr="">
                  <!-- tblh -->
                  <div class="tblh">
<!--                       <div class="scroll"> -->
                          <table summary="이표는 이벤트 검색 표 입니다. 구성은 이벤트명,  이벤트기간, 참여방법, 참여형태, 이벤트 진행상태, 관리 입니다.">
                              <caption>이벤트 리스트</caption>
                              <colgroup>
                                  <col width="5%">
                                  <col width="5%">
                                  <col width="10%">
                                  <col width="30%">
                                  <col width="30%">
                                  <col width="10%">
                                  <col width="10%">
                              </colgroup>
                              <thead>
                                  <tr>
                                      <th>
                                         <label for="chack05" class="chack">
                                             <span class="ico_comm"><input type="checkbox" name="table" id="chack05" /></span>
                                         </label> 
                                      </th>
                                      <th>번호</th>
                                      <th>생성일</th>
                                      <th>이벤트명</th>
                                      <th>이벤트 기간</th>
                                      <th>참여방법</th>
                                      <th>관리</th>
                                  </tr>
                              </thead>
                              <tbody id="cpList">
                                  <c:forEach var="attendanceCheckList" items="${resultListModel.resultList}" varStatus="status">  
                                     <tr data-event-no="${attendanceCheckList.eventNo}">
                                         <td>
                                             <label for="chack05_${status.count}" class="chack">
                                                 <span class="ico_comm">
                                                     <input type="checkbox" name="eventNo" id="chack05_${status.count}" value="${attendanceCheckList.eventNo}" />
                                                 </span>
                                             </label>
                                         </td>
                                         <td>${attendanceCheckList.rowNum}</td>
                                         <td><fmt:formatDate pattern="yyyy-MM-dd"  value="${attendanceCheckList.regDttm}" /></td>
                                         <td class="txtl"><a href="#none" id="attendanceCheckNm" class="tbl_link">${attendanceCheckList.eventNm}</a></td>
                                         <td>${fn:substring(attendanceCheckList.applyStartDttm, 0, 16)} ~ ${fn:substring(attendanceCheckList.applyEndDttm, 0, 16)}</td>
                                         <td>${attendanceCheckList.eventMethodCdNm}</td>
                                         <td><button class="btn_gray" id="updt_btn">수정</button></td>
                                     </tr>
                                  </c:forEach>
                                  <c:if test="${resultListModel.filterdRows == 0}">
                                       <tr>
                                            <td colspan="10">데이터가 없습니다.</td>
                                       </tr>
                                  </c:if>    
                              </tbody>
                          </table>
<!--                       </div> -->
                  </div>
                  <!-- //tblh -->
                  <!-- bottom_lay -->
                  <div class="bottom_lay">
                      <div class="left">
                          <div class="pop_btn">
                              <button type="button" id="del_attendanceCheck_btn" class="btn_gray2">삭제</button>
                          </div>
                      </div>
                      <grid:paging resultListModel="${resultListModel}" />
                  </div>
                  <!-- //bottom_lay -->
              </grid:table>
              <!-- //line_box -->
          </div>
    </t:putAttribute>
</t:insertDefinition>