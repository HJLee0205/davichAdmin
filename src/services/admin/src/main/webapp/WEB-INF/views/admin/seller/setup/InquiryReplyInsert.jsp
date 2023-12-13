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
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                Dmall.validate.set('formBbsInquiryLettReply');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정
                // 검색
                $('#btn_id_search').on('click', function() {
                    jQuery('#form_id_search').submit();
                });
                
                jQuery('#viewBbsLettList').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    
                    var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", loginId : "${so.loginId}"}
                    Dmall.FormUtil.submit('/admin/seller/inquiry-list', param);
                });
                
                // 저장
                jQuery('#bbsLettListInsert').on('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();

                    if(Dmall.validate.isValid('formBbsInquiryLettReply')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/board/board-reply-insert';
                        var param = jQuery('#formBbsInquiryLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettListInsert');
                            if(result.success){
                                var param = {bbsId : "${so.bbsId}", bbsNm : "${so.bbsNm}", loginId : "${so.loginId}"}
                                Dmall.FormUtil.submit('/admin/seller/InquiryList', param);
                            }
                        });
                    }
                });

                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsInquiryLettReply');
                    jQuery("#contentArea").html(result.data.content);
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.replyContent); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                });
                
                var param = {memberNo:"${so.regrNo}", siteNo:"${siteNo}"};
                var url = '/admin/goods/member-info';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var data = result.data.memberNm+'(<span class="point_c3">'+result.data.loginId+"/"+result.data.memberGradeNm+'</span>)';
                    jQuery("#memeberInfo").html(data);
                    
                    jQuery("#regrMemberNo").val(result.data.memberNo);
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
            <h2 class="tlth2">[판매자문의] 게시글 답변 등록</h2>
            <div class="btn_box right">
                <a href="#none" id ="bbsLettListInsert" class="btn blue shot">저장하기</a>
            </div>
        </div>
        <form action="" id="formBbsInquiryLettReply">
        <!-- line_box -->
        <div class="line_box fri">
            <!-- tblw -->
            <div class="tblw mt0">
                <table summary="이표는 게시글 답변 등록 표 입니다. 구성은 작성자, 질분유형, 게시글 제목, 게시글 내용, 답변 제목, 답변 내용, SMS발송, 이메일발송 입니다.">
                    <caption>게시글 보기</caption>
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
                        <tr>
                            <th>판매자</th>
                            <td id="bind_target_id_sellerNm" class="bind_target"></td> 
                        </tr>
                        <tr>
                            <th>질문유형</th>
                            <td id="bind_target_id_inquiryNm" class="bind_target"></td> 
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
                                <input type="hidden" id="inquiryCd" name="inquiryCd"  />
                                <input type="hidden" name="lvl" id="lvl"  >
                                <input type="hidden" name="lettLvl" id="lettLvl"  >
                                <input type="hidden" name="replyLettNo" id="replyLettNo"  >
                                <input type="hidden" name="regrMemberNo" id="regrMemberNo" value = ""  >
                                <input type="hidden" name="memberNo" id = "memberNo" value = "${so.regrNo}">
                                
                                <span class="intxt" style="width:85%;">
                                    <input type="text" name="replyTitle" id="replyTitle" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[200]]" maxlength="200" >
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
<%--                         <tr> --%>
<%--                             <th>SMS발송</th> --%>
<%--                             <td> --%>
<%--                                 <tags:checkbox name="smsSendYn" id="srch_id_smsSendYn" value="Y" compareValue="" text="해당 회원에게 답변완료 SMS를 발송합니다." /> --%>
<%--                             </td> --%>
<%--                         </tr> --%>
<%--                         <tr> --%>
<%--                             <th>이메일발송</th> --%>
<%--                             <td> --%>
<%--                                 <tags:checkbox name="emailSendYn" id="srch_id_emailSendYn" value="Y" compareValue="" text="해당 회원에게 답변완료 이메일을 발송합니다." /> --%>
<%--                             </td> --%>
<%--                         </tr> --%>
                    </tbody>
                </table>
            </div>
            <!-- //tblw -->
        </div>
        <!-- //line_box -->
        </form>
    </div>
    </t:putAttribute>
</t:insertDefinition>
