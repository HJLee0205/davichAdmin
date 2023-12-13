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
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            //Dmall.validate.set('formBbsLettReply');
            // 게시글 리스트 화면
            jQuery('#viewBbsLettList').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", regrNo : "${so.regrNo}"}
                Dmall.FormUtil.submit('/admin/seller/goods/goods-reviews', param);
            });
            // 저장
            jQuery('#bbsLettListInsert').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                if(Dmall.validate.isValid('formBbsLettReply')) {
    
                    var url = '/admin/seller/board-reply-insert';
                    var param = jQuery('#formBbsLettReply').serialize();
    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                        if(result.success){
                            var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}"}
                            Dmall.FormUtil.submit('/admin/seller/goods/goods-reviews', param);
                        }
                    });
                }
            });
            
         	// 답변삭제
            jQuery('#bbsReplyDelete').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                if(Dmall.validate.isValid('formBbsLettReply')) {
    
                    var url = '/admin/seller/board-reply-delete';
                    var param = jQuery('#formBbsLettReply').serialize();
    
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                        if(result.success){
                            var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}"}
                            Dmall.FormUtil.submit('/admin/seller/goods/goods-reviews', param);
                        }
                    });
                }
            });
         
            var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
            var url = '/admin/seller/setup/board-letter-detail';
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var atchFileArr = "";
                Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettReply');
                jQuery.each(result.data.atchFileArr, function(i, obj) {
                    atchFileArr += '<a href="#none" class="tbl_link" onclick= "return fileDownload('+obj.fileNo+
                    ');">'+obj.orgFileNm+'</a><span class="br2"></span>';
                });
                jQuery("#viewFileInsert").html(atchFileArr);
                
                if(result.data.replyLettNo == null || result.data.replyLettNo == ''){
                	$('#bbsReplyDelete').hide();
                }
            });
            
            var param = {memberNo:"${so.regrNo}", siteNo:"${siteNo}"};
            var url = '/admin/goods/member-info';
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                jQuery("#memeberInfo").html(data);
            });
            function fileDownload(fileNo){
                Dmall.FileDownload.download("BBS", fileNo)
                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
        <div class="tlt_box">
            <div class="btn_box left">
                <a href="#none" id="viewBbsLettList" class="btn gray">상품 후기 리스트</a>
            </div>
            <h2 class="tlth2">상품 후기 관리</h2>
            <div class="btn_box right">
                <a href="#none" id ="bbsLettListInsert"  class="btn blue shot">저장하기</a>
            </div>
        </div>
        <form action="" id="formBbsLettReply">
        <!-- line_box -->
        <div class="line_box fri">
            <h3 class="tlth3">상품후기 정보 </h3>
            <!-- tblw -->
            <div class="tblw tblmany">
                <table summary="이표는 상품후기 정보 표 입니다. 구성은  입니다.">
                    <caption>상품후기 정보</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="35%">
                        <col width="15%">
                        <col width="35%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>이름</th>
                            <td  colspan="3" id ="memeberInfo">
                                
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td colspan="3" id="bind_target_id_title"></td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td colspan="3" id="bind_target_id_content" ></td>
                        </tr>
                        <tr>
                            <th>파일 첨부</th>
                            <td colspan="3">
                                <span id = "viewFileInsert"></span>
                            </td>
                        </tr>
                   </tbody>
                </table>
            </div>
            <!-- //tblw -->
            <h3 class="tlth3">답변 작성</h3>
            <!-- tblw -->
            <div class="tblw">
                <table summary="이표는 답변 작성 표 입니다. 구성은  입니다.">
                    <caption>답변 작성</caption>
                    <colgroup>
                        <col width="15%">
                        <col width="35%">
                        <col width="15%">
                        <col width="35%">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>상품</th>
                            <td colspan="3" id="bind_target_id_goodsNm" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>답변 제목</th>
                            <td colspan="3">
                                <input type="hidden" id="goodsNo" name = "goodsNo" >
                                <input type="hidden" id="grpNo" name="grpNo" />
                                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                <input type="hidden" id="titleNo" name="titleNo"  />
                                <input type="hidden" id="lvl" name="lvl"  />
                                <input type="hidden" id="lettLvl" name="lettLvl"  />
                                <input type="hidden" name="replyLettNo" id="replyLettNo"  >
                                <input type="hidden" name="memberNo" id = "memberNo" value = "${so.regrNo}">
                                <span class="intxt wid100p">
                                    <input type="text" name="replyTitle" id="replyTitle" data-validation-engine="validate[required], maxSize[200]]" maxlength="200" >
                                </span>
                             </td>
                        </tr>
                        <tr>
                            <th>답변 내용</th>
                            <td colspan="3">
                                <div class="txt_area">
                                    <textarea name="replyContent" id="replyContent"></textarea>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="tlt_box">
	            <div class="btn_box right" style="margin-top:30px;">
	                <a href="#none" id ="bbsReplyDelete"  class="btn blue shot">답변삭제</a>
	            </div>
	        </div>
        </div>
        <!-- //line_box -->
        </form>
    </div>
    </t:putAttribute>
</t:insertDefinition>
