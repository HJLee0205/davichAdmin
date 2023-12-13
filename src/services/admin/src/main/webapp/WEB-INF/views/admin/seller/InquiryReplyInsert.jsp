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
    <t:putAttribute name="title">판매자 문의 > 업체</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('formBbsInquiryLettReply');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 목록 버튼 클릭
                jQuery('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/seller/inquiry-list');
                });
                
                // 저장 버튼 클릭
                $('#btn_save').on('click', function(e) {
                    if(Dmall.validate.isValid('formBbsInquiryLettReply')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/seller/board-reply-insert';
                        var param = $('#formBbsInquiryLettReply').serialize();
                        
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettListInsert');
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/seller/inquiry-list');
                            }
                        });
                    }
                });

                // 게시글 상세조회
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsInquiryLettReply');
                    $('#smsSendYn').val('Y');
                    $('#emailSendYn').val('Y');
                    $("#contentArea").html(result.data.content);

                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.replyContent); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 문의</h2>
            </div>
            <form id="formBbsInquiryLettReply">
                <input type="hidden" name="lettNo" id="lettNo">
                <input type="hidden" name="bbsId" id="bbsId">
                <input type="hidden" name="replyLettNo" id="replyLettNo">
                <input type="hidden" name="sellerNo">
                <input type="hidden" name="smsSendYn" id="smsSendYn">
                <input type="hidden" name="emailSendYn" id="emailSendYn">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 답변 등록 표 입니다. 구성은 작성자, 질분유형, 게시글 제목, 게시글 내용, 답변 제목, 답변 내용, SMS발송, 이메일발송 입니다.">
                            <caption>게시글 보기</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>판매자</th>
                                <td id="bind_target_id_sellerNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>질문유형</th>
                                <td id="bind_target_id_inquiryNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td colspan="3" id="contentArea"></td>
                            </tr>
                            <tr>
                                <th>답변 제목</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="replyTitle" id="replyTitle" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[200]]" maxlength="200">
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
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_save">
                    <c:choose>
                        <c:when test="${so.replyStatusYn == 'Y'}">
                            수정
                        </c:when>
                        <c:otherwise>
                            저장
                        </c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
