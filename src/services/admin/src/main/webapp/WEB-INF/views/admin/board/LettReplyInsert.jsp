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
    <t:putAttribute name="title">게시판 관리</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
           jQuery(document).ready(function() {
                Dmall.validate.set('formBbsLettReply');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                // 게시글 리스트 화면
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", noticeLettSetYn : "${so.noticeLettSetYn}",
                            bbsKindCd : "${so.bbsKindCd}", titleUseYn:"${so.titleUseYn}"};
                    Dmall.FormUtil.submit('/admin/operation/letter', param);
                });
                // 저장
                jQuery('#bbsLettListInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    if(Dmall.validate.isValid('formBbsLettReply')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/operation/board-reply-insert';
                        var param = jQuery('#formBbsLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                            if(result.success){
                                var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}"}
                                Dmall.FormUtil.submit('/admin/operation/letter', param);
                            }
                        });
                    }
                });
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var titleUseYn="${so.titleUseYn}";
                var url = '/admin/operation/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettReply');
                    jQuery("#contentArea").html(result.data.content);
                    if(titleUseYn!="Y"){jQuery("#titleSelectBox").hide(); return;}    
                });
                
                var param = {memberNo:"${so.regrNo}", siteNo:"${siteNo}"};
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                    jQuery("#memeberInfo").html(data);
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
                <h2 class="tlth2">[${so.bbsNm}] 게시글 답변 등록 </h2>
                <!-- <div class="btn_box right">
                    <a href="#none" id ="bbsLettListInsert"  class="btn blue shot">저장하기</a>
                </div> -->
            </div>
            <form action="" id="formBbsLettReply">
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 게시글 등록 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
                        <caption>게시글 등록</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>작성자</th>
                                <td id ="memeberInfo">
                                    
                                </td>
                            </tr>
                            <tr id = "titleSelectBox">
                                <th>말머리</th>
                                <td id="bind_target_id_titleNm" class="bind_target"></td> 
                            </tr>
                            <tr>
                                <th>게시글 제목</th>
                                <td id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>게시글 내용</th>
                                <td colspan="3" id="contentArea" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>답변 제목</th>
                                <td>
                                    <input type="hidden" id="grpNo" name="grpNo" />
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                    <input type="hidden" id="titleNo" name="titleNo"  />
                                    <input type="hidden" id="lvl" name="lvl"  />
                                    <input type="hidden" id="lettLvl" name="lettLvl"  />
                                    <input type="hidden" name="replyLettNo" id="replyLettNo"  >
                                    <span class="intxt" style="width:85%;">
                                        <input type="text" name="replyTitle" id="replyTitle" data-validation-engine="validate[required], maxSize[200]]" maxlength="200" />
                                    </span>
                                 </td>
                            </tr>
                            <tr>
                                <th>답변 내용</th>
                                <td>
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="replyContent" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </div>
            <!-- //line_box -->
            </form>

			<div class="btn_box txtc">
				<a href="#none" id ="bbsLettListInsert"  class="btn blue shot">저장하기</a>
			</div>
       </div>  
    </t:putAttribute>
</t:insertDefinition>
