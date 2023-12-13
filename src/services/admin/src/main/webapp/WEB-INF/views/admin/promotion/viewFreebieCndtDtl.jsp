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
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 사은품이벤트 &gt; 사은품이벤트 상세</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //수정 버튼 클릭
            jQuery("#freebieCndt_updt").on("click", function(){
                var freebieEventNo = $("#freebieEventNo").val();
                var periodSelOption = $("#periodSelOption").val();
                var searchStartDate = $("#searchStartDate").val();
                var searchEndDate = $("#searchEndDate").val();
                var freebieStatusCds = $("#freebieStatusCds").val();
                var searchWords = $("#searchWords").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#pageNoOri").val();
                Dmall.FormUtil.submit('/admin/promotion/freebieevent-update-form',
                        {freebieEventNo : freebieEventNo, periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, freebieStatusCds : freebieStatusCds, searchWords : searchWords, rows:rows, pageNoOri : pageNoOri});
            });
            
            //사은품이벤트리스트 페이지로 돌아가기 : 기간검색옵션,검색시작일,검색종료일,이벤트진행상태,검색어,페이지번호
            jQuery("#freebieCndt_list").on("click", function(){
                var periodSelOption = $("#periodSelOption").val();
                var searchStartDate = $("#searchStartDate").val();
                var searchEndDate = $("#searchEndDate").val();
                var freebieStatusCds = $("#freebieStatusCds").val();
                var searchWords = $("#searchWords").val();
                var rows = $("#rows").val();
                var pageNoOri = $("#pageNoOri").val();
                Dmall.FormUtil.submit('/admin/promotion/freebie-event',
                        {periodSelOption : periodSelOption, searchStartDate : searchStartDate, searchEndDate : searchEndDate, freebieStatusCds : freebieStatusCds, searchWords : searchWords, rows : rows, pageNoOri : pageNoOri});
            });
        });    
        
        </script>
    </t:putAttribute>

    <t:putAttribute name="content">
        <!--- contents --->
        <c:set var="freebieDtl" value="${resultModel.data}" />
          <div class="sec01_box">
              <div class="tlt_box">
                  <div class="btn_box left">
                      <button id="freebieCndt_list" class="btn gray">사은품리스트</button>
                  </div>
                  <h2 class="tlth2">사은품 이벤트 상세</h2>
                  <div class="btn_box right">
                      <button type="button" class="btn blue shot" id="freebieCndt_updt">수정하기</button>
                  </div> 
              </div>
                 <!-- line_box -->
                 <input type="hidden" name="periodSelOption" id="periodSelOption" value="${so.periodSelOption}" />
                 <input type="hidden" name="searchStartDate" id="searchStartDate" value="${so.searchStartDate}" />
                 <input type="hidden" name="searchEndDate"   id="searchEndDate" value="${so.searchEndDate}" />
                 <input type="hidden" name="freebieStatusCds" id="freebieStatusCds" value="${fn:join(so.freebieStatusCds, ',')}" />
                 <input type="hidden" name="searchWords"     id="searchWords" value="${so.searchWords}" />
                 <input type="hidden" name="rows"            id="rows" value="${so.rows}" />
                 <input type="hidden" name="pageNoOri"       id="pageNoOri" value="${so.pageNoOri}" />
                 <input type="hidden" name="freebieEventNo"  id="freebieEventNo" value="${freebieDtl.freebieEventNo}" />
                 <div class="line_box fri">
                     <h3 class="tlth3">사은품 이벤트 정보</h3>
                     <!-- tblw -->
                     <div class="tblw tblmany">
                         <table summary="이표는 사은품등록표 입니다. 구성은 사은품 이벤트명, 설명, 기간, 사은품명, 사은품설정 입니다.">
                             <caption>상품 기본정보</caption>
                             <colgroup>
                                 <col width="20%">
                                 <col width="80%">
                             </colgroup>
                             <tbody>
                                 <tr>
                                     <th>사은품 이벤트명</th>
                                     <td>
                                         ${freebieDtl.freebieEventNm}
                                     </td>
                                 </tr>
                                 <tr>
                                     <th>사은품 이벤트 설명</th>
                                     <td>
                                         ${freebieDtl.freebieEventDscrt}
                                     </td>
                                 </tr>
                                 <%-- <tr>
                                     <th>접속 권한</th>
                                     <td>
                                       <c:if test="${freebieDtl.useYn eq 'Y'}">
                                           사용자의 이벤트 페이지 접근을 차단합니다.  단, 관리자는 볼 수 있습니다.
                                       </c:if>
                                       <c:if test="${freebieDtl.useYn eq 'N'}"> 
                                           사용자의 이벤트 페이지 접근이 가능합니다.
                                       </c:if>
                                     </td> 
                                 </tr>     --%>
                                 <tr>
                                     <th>사은품 이벤트 기간</th>
                                     <td>
                                             ${fn:substring(freebieDtl.applyStartDttm, 0, 4)}년 ${fn:substring(freebieDtl.applyStartDttm, 4, 6)}월 ${fn:substring(freebieDtl.applyStartDttm, 6, 8)}일 
                                             ${fn:substring(freebieDtl.applyStartDttm, 8, 10)}시 ${fn:substring(freebieDtl.applyStartDttm, 10, 12)}분
                                             ~
                                             ${fn:substring(freebieDtl.applyEndDttm, 0, 4)}년 ${fn:substring(freebieDtl.applyEndDttm, 4, 6)}월 ${fn:substring(freebieDtl.applyEndDttm, 6, 8)}일 
                                             ${fn:substring(freebieDtl.applyEndDttm, 8, 10)}시 ${fn:substring(freebieDtl.applyEndDttm, 10, 12)}분    <br/>
                                     </td>
                                 </tr>
                                 <tr>
                                     <th>사은품 증정 조건</th>
                                     <td>
                                         <c:if test='${freebieDtl.freebiePresentCndtCd eq "01"}'>
                                            총 결제금액이 <fmt:formatNumber value="${freebieDtl.freebieEventAmt}" pattern="#,###" />원 이상이면 해당 사은품 증정
                                         </c:if>
                                         <c:if test='${freebieDtl.freebiePresentCndtCd eq "02"}'>
                                            개별상품으로 선정
                                             <ul class="tbl_ul pr_ul1 display_block"> 
                                                  <c:forEach var = "targetResult" items="${resultModel.extraData.targetResult}">
                                                          <li class='pr_thum'>
                                                             <img src="${targetResult.imgPath}" width='82' height='82' alt='상품이미지' /><br/> 
                                                             <input type="text" value="${targetResult.goodsNm}" readonly/> 
                                                          </li>
                                                  </c:forEach>
                                             </ul>
                                         </c:if>
                                     </td>    
                                 </tr>              
                                 <tr>
                                     <th>사은품이벤트 상품설정</th>
                                     <td>
                                            <ul class="tbl_ul pr_ul1 display_block"> 
                                                  <c:forEach var = "goodsResult" items="${resultModel.extraData.goodsResult}">
                                                          <li class='pr_thum'>
                                                             <img src="${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1=${goodsResult.imgPath}_${goodsResult.imgNm}" width='82' height='82' alt='사은품 이미지' /><br/>
                                                             <input type="text" value="${goodsResult.freebieNm}" readonly/> 
                                                          </li>
                                                  </c:forEach>
                                            </ul>
                                     </td>
                                 </tr>
                             </tbody>
                         </table>
                     </div>
                     <!-- //tblw -->
                 </div>
                 <!-- //line_box -->
          </div>
        <!---// contents--->
    </t:putAttribute>
</t:insertDefinition>