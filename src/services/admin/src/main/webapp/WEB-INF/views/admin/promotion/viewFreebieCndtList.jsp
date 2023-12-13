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
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 사은품이벤트 &gt; 사은품이벤트 목록</t:putAttribute>
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
                    } else if( $("input[name='freebieStatusCds']:checked").length == 0 ){
                        Dmall.LayerUtil.alert("진행상태를 선택해주세요");
                        return false;
                    } else {
                        $("#search_id_page").val("1");
                        $("#form_id_search").submit();
                    }
                });
                
                // 삭제
                $("#del_freebie_btn").on("click", function(){
                    if(jQuery("#grid_id_freebieCndList tr td input[type='checkbox']:checked").length == 0){
                        Dmall.LayerUtil.alert("삭제할 목록을 선택해주세요")
                        return false;
                    }
                    Dmall.LayerUtil.confirm('정말로 삭제하시겠습니까?', delFreebie,'','사은품 삭제','체크박스에 체크한 사은품을 삭제합니다.');
                });

                //상세 : 사은품이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                $(document).on("click", "#freebieEventNm", function(e){
                    var freebieEventNo = jQuery(this).parent().parent().data("freebie-event-no");
                    var periodSelOption = $("#srch_id_periodSelOption").val();
                    var searchStartDate = $("#srch_sc01").val();
                    var searchEndDate = $("#srch_sc02").val();
                    var freebieStatusCds = [];
                        $("input[name='freebieStatusCds']:checked").each(function(i){
                            freebieStatusCds.push( $(this).val() );
                        });
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#search_id_page").val();
                    Dmall.FormUtil.submit('/admin/promotion/freebieevent-detail',
                            {freebieEventNo : freebieEventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, 
                             freebieStatusCds : freebieStatusCds, searchWords : searchWords, rows : rows, pageNoOri : pageNoOri});
                });    
                
                //수정 : 사은품이벤트번호,기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,노출개수,페이지번호
                $(document).on("click", "#update_btn", function(e){
                    var freebieEventNo = jQuery(this).parent().parent().parent().data("freebie-event-no");
                    var periodSelOption = $("#srch_id_periodSelOption").val();
                    var searchStartDate = $("#srch_sc01").val();
                    var searchEndDate = $("#srch_sc02").val();
                    var freebieStatusCds = [];
                        $("input[name='freebieStatusCds']:checked").each(function(i){
                            freebieStatusCds.push( $(this).val() );
                        });
                    var searchWords = $("#searchWords").val();
                    var rows = $("#rows").val();
                    var pageNoOri = $("#search_id_page").val();
                    Dmall.FormUtil.submit('/admin/promotion/freebieevent-update-form',
                            {freebieEventNo : freebieEventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, 
                            freebieStatusCds : freebieStatusCds, searchWords : searchWords, rows : rows, pageNoOri : pageNoOri});
                });
                
                $('#grid_id_freebieCndList').grid($('#form_id_search'));
                
                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search_btn').trigger('click') });
          });
          
            //삭제
            function delFreebie(){
                var url = 'freebieevent-delete';
                var param = {};
                var $selected = jQuery("#grid_id_freebieCndList tr td input[type='checkbox']:checked");
                var list = {};
                var freebieEventNo;
                var freebiePresentCndtCd;
                
                jQuery.each($selected, function(i, o) {
                    freebieEventNo = {'freebieEventNo' : $(o).parents('tr').data('freebieEventNo')};
                    param['list[' + i + '].freebieEventNo'] = $(o).parents('tr').data('freebieEventNo');
                    freebiePresentCndtCd = {'freebiePresentCndtCd' : $(o).parents('tr').children('td').eq(8).children().val()};
                    param['list[' + i + '].freebiePresentCndtCd'] = $(o).parents('tr').children('td').eq(8).children().val();

                });

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                      if(result.success) {
                           $('#btn_id_search_btn').trigger('click');
                    }
                });
            }

        </script>   
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">사은품이벤트 리스트</h2>


                <div class="btn_box right">
                    <a href="/admin/promotion/freebieevent-insert-form" id="viewFreebieCndtInsert" class="btn blue">사은품 이벤트 만들기</a>
                </div>
            </div>  
             <!-- search_box -->
             <div class="search_box">
                 <!-- search_tbl -->
                 <form:form id="form_id_search" commandName="so">
                      <form:hidden path="page" id="search_id_page" value="" /> 
                      <form:hidden path="rows" id="rows" value=""/>
                      <input type="hidden" name="sort" value="${so.sort}" />        
                      <div class="search_tbl">
                          <table summary="이표는 사은품 이벤트 검색 표 입니다. 구성은 기간, 상태, 검색어 입니다.">
                              <caption>판매상품관리 검색</caption>
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
                                  </tr>
                                  <tr>
                                       <th>상태</th>
                                       <td> 
                                           <c:set var="freebieStatusCds" value="${fn:join(so.freebieStatusCds, ' ')}"/>
                                           <label for="freebieStatusCds1" class="chack mr20<c:if test="${fn:contains(freebieStatusCds,'01')}"> on</c:if>">
                                               <span class="ico_comm">
                                                   <form:checkbox path="freebieStatusCds" id="freebieStatusCds1" value="01" label="" cssClass="blind" />
                                               </span>
                                                            진행 전
                                           </label>
                                           <label for="freebieStatusCds2" class="chack mr20<c:if test="${fn:contains(freebieStatusCds,'02')}"> on</c:if>">
                                               <span class="ico_comm">
                                                   <form:checkbox path="freebieStatusCds" id="freebieStatusCds2" value="02" label="" cssClass="blind"/>
                                               </span>
                                                            진행 중
                                           </label>
                                           <label for="freebieStatusCds3" class="chack mr20<c:if test="${fn:contains(freebieStatusCds,'03')}"> on</c:if>">
                                               <span class="ico_comm">
                                                   <form:checkbox path="freebieStatusCds" id="freebieStatusCds3" value="03" label="" cssClass="blind"/>
                                               </span>
                                                            종료
                                            </label>
                                            <a href="#none" class="all_choice"><span class="ico_comm"></span> 전체</a>                                            
                                       </td>
                                   </tr>
                                   <tr>
                                      <th>검색어</th>
                                      <td>
                                          <div class="select_inp">
                                              <span>
                                                  <label for="freebieNm">이벤트명</label>
                                                  <select name="" id="freebieNm">
                                                      <option value="">이벤트명</option>
                                                  </select>
                                              </span>
                                              <form:input path="searchWords" cssClass="text" cssErrorClass="text medium error" size="20" maxlength="30" value=""/>
                                              <form:errors path="searchWords" cssClass="errors"  />
                                          </div>
                                      </td>
                                   </tr>
                              </tbody>
                            </table>
                        </div>
                        <!-- //search_tbl -->

                     <div class="btn_box txtc">
                         <a href="#none" class="btn green" id="btn_id_search_btn">검색</a>
                     </div>
                 </form:form>
               </div>
                
               <grid:table id="grid_id_freebieCndList" so="${so}" resultListModel="${resultListModel}" sortOptionStr="">
                <div class="tblh">
                    <table summary="이표는 사은품이벤트 목록 표 입니다. 구성은 번호, 생성일, 사은품 이벤트명, 이벤트 시작일, 이벤트 종료일, 이벤트 진행상태, 관리 입니다.">
                        <caption>사은품 이벤트 리스트</caption>
                        <colgroup>
                            <col width="5%">
                            <col width="5%">
                            <col width="10%">
                            <col width="45%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="5%">
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
                                <th>사은품 이벤트명</th>
                                <th>이벤트 시작일</th>
                                <th>이벤트 종료일</th>
                                <th>이벤트 진행상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_id_freebieList">
                           <c:forEach var="freebieList" items="${resultListModel.resultList}" varStatus="status">
                              <tr data-freebie-event-no="${freebieList.freebieEventNo}">
                                  <td>
                                      <label for="chack05_${status.count}" class="chack">
                                          <span class="ico_comm">
                                              <input type="checkbox" name="freebieEventNo" id="chack05_${status.count}" value="${freebieList.freebieEventNo}" />
                                          </span>
                                      </label>
                                  </td>
                                  <td><a href="#none" >${freebieList.rownum}</a></td>
                                  <td><fmt:formatDate pattern="yyyy-MM-dd"  value="${freebieList.regDttm}" /></td>
                                  <td><a href="#none" id="freebieEventNm" class="tbl_link">${freebieList.freebieEventNm}</a></td>
                                  <td>${fn:substring(freebieList.applyStartDttm, 0, 10)}</td>
                                  <td>${fn:substring(freebieList.applyEndDttm, 0, 10)}</td>
                                  <td>${freebieList.freebieStatusNm}</td>
                                  <td>
                                      <div class="pop_btn">
                                          <button type="button"  class="btn_gray" id="update_btn" >수정</button>
                                      </div>
                                  </td>
                                  <td style="display:none">
                                    사은품 증정조건 
                                    <input type="hidden" value="${freebieList.freebiePresentCndtCd}">
                                  </td>
                              </tr>
                            </c:forEach>
                            <c:if test="${resultListModel.filterdRows == 0}">
                                 <tr>
                                      <td colspan="10">데이터가 없습니다.</td>
                                 </tr>
                            </c:if>     
                        </tbody>
                    </table>
            </div>    
            <!-- //tblh -->
            <!-- bottom_lay -->
            <div class="bottom_lay">
                <div class="left">
                    <div class="pop_btn">
                        <button id="del_freebie_btn" class="btn_gray2">삭제</button>
                    </div>
                </div>
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!-- //bottom_lay -->
          </grid:table>
        </div>    
    </t:putAttribute>
</t:insertDefinition>