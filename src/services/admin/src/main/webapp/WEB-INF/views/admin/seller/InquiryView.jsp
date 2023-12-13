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
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>

            jQuery(document).ready(function() {
                // 게시글 리스트 화면
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo : "${so.regrNo}"}
                    Dmall.FormUtil.submit('/admin/seller/inquiry-list', param);
                });
                
                // 게시글 답변 등록 화면 이동
                jQuery('#viewBbsLettUpdate').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    var regrNo = jQuery("#regrNo").val();
                    var titleNo = jQuery("#titleNo").val();
                    var param = {lettNo: "${so.lettNo}", bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo:regrNo, titleNo:titleNo};
                    Dmall.FormUtil.submit('/admin/seller/letter-reply-form', param);
                });
                
                // 게시글 정보 가져오기
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_id_bbsLett');
                    jQuery("#bind_target_id_memberNm").html(result.data.sellerNm+'(<span class="point_c3">'+result.data.loginId+'</span>)');
                    jQuery("#contentArea").html(result.data.content);
                    jQuery("#reply_content").html(result.data.replyContent);
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
             <div class="tlt_box">
                 <div class="btn_box left">
                     <a href="#none" id="viewBbsLettList" class="btn gray">게시글 리스트</a>
                 </div>
                 <h2 class="tlth2">[판매자문의] 게시글 보기 </h2>
                 <div class="btn_box right">
                     <a href="#none" id="viewBbsLettUpdate" class="btn blue shot">답변등록</a>
                 </div>
             </div>
             <form action="" id="form_id_bbsLett">
             <!-- line_box -->
             <div class="line_box fri">
                 <!-- tblw -->
                 <div class="tblw mt0">
                     <table summary="이표는 게시글 보기 표 입니다. 구성은 작성자, 작성일, 공지글 설정, 제목, 내용 입니다.">
                         <caption>게시글 보기</caption>
                         <colgroup>
                             <col width="15%">
                             <col width="35%">
                             <col width="15%">
                             <col width="35%">
                         </colgroup>
                         <tbody>
                             <tr>
                                 <th>작성자</th>
                                 <td id="bind_target_id_memberNm" class="bind_target"></td>
                                 <th class="line">작성일</th>
                                 <td id="bind_target_id_regDttm" class="bind_target"></td>
                             </tr>
                            <tr>
                                <th>판매자</th>
                                <td id="bind_target_id_sellerNm" class="bind_target"></td>
                             </tr>
                             <tr>
                                 <th>질문유형</th>
                                 <td colspan="3" id="bind_target_id_inquiryNm" class="bind_target"></td> 
                             </tr>
                             <tr>
                                  <th>제목
                                        <input type="hidden" id="lettNo" name = "lettNo" >
                                        <input type="hidden" name="memberNm" id="memberNm">
                                        <input type="hidden" name="titleNo" id="titleNo">
                                        <input type="hidden" name="regrNo" id="regrNo">
                                  </th>
                                  <td colspan="3" id="bind_target_id_title" class="bind_target"></td>
                              </tr>
                              <tr>
                                  <th>내용</th>
                                  <td colspan="3" id="contentArea" class="bind_target">
                                        
                                  </td>
                              </tr>
                         </tbody>
                     </table>
                 </div>
                 <!-- //tblw -->
             </div>
             <!-- //line_box -->
             <div class="line_box fri">
                 <!-- tblw -->
                 <div class="tblw mt0">
                     <table summary="이표는 게시글 보기 표 입니다. 구성은 작성자, 작성일, 공지글 설정, 제목, 내용 입니다.">
                         <caption>게시글 보기</caption>
                         <colgroup>
                             <col width="15%">
                             <col width="35%">
                             <col width="15%">
                             <col width="35%">
                         </colgroup>
                         <tbody>
                             <tr>
                                  <th>답변 제목
                                  </th>
                                  <td colspan="3" id="bind_target_id_replyTitle" class="bind_target"></td>
                              </tr>
                              <tr>
                                  <th>답변 내용</th>
                                  <td colspan="3" id="reply_content" class="bind_target">
                                  </td>
                              </tr>
                         </tbody>                     
                     </table>
                 </div>
                 <!-- //tblw -->
             </div>             
             
             </form>
        </div>
    </t:putAttribute>
</t:insertDefinition>
