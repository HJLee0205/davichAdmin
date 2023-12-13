<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">상품 문의 관리 > 상품</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('formBbsLettReply');
                Dmall.DaumEditor.init();
                Dmall.DaumEditor.create('ta_id_content1');

                // 노출여부 변경 이벤트
                $('#expsYn').off('change').on('change', function(e) {
                    var url = '/admin/board/board-letterexpose-update';
                    var param = {
                        delLettNo: $('#lettNo').val(),
                        bbsId: $('#bbsId').val(),
                        expsYn: $('#expsYn').val()
                    };

                    Dmall.AjaxUtil.getJSON(url, param);
                });

                // 목록
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/goods/goods-questions');
                });

                // 삭제
                $('#btn_delete').on('click', function() {
                    Dmall.LayerUtil.confirm('삭제된 게시글은 복구할 수 없습니다.<br />정말 삭제하시겠습니까?', function() {
                        var url = '/admin/board/board-letter-delete';
                        var param = $('#formBbsLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/goods/goods-questions');
                            }
                        });
                    });
                });

                // 저장
                $('#btn_save').on('click', function() {
                    if (Dmall.validate.isValid('formBbsLettReply')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                        var url = '/admin/board/board-reply-insert';
                        var param = $('#formBbsLettReply').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettReply');
                            if (result.success) {
                                Dmall.FormUtil.submit('/admin/goods/goods-questions');
                            }
                        });
                    }
                });

                // 게시글 상세조회
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettReply');
                    $('#emailSendYn').val('Y');
                    $('#smsSendYn').val('Y');
                    $('input:hidden[name=memberNo]').after('<input type="hidden" name="goodsNm" value="'+ result.data.goodsNm +'">');

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
                    상품 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">상품 문의 관리</h2>
            </div>
            <form id="formBbsLettReply">
                <input type="hidden" name="lettNo" id="lettNo">
                <input type="hidden" name="bbsId" id="bbsId">
                <input type="hidden" name="replyLettNo" id="replyLettNo">
                <input type="hidden" name="emailSendYn" id="emailSendYn">
                <input type="hidden" name="smsSendYn" id="smsSendYn">
                <input type="hidden" name="memberNo">
                <!-- line_box -->
                <div class="line_box fri paddingB140">
                    <h3 class="tlth3">문의 정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 문의자 정보 표 입니다. 구성은  입니다.">
                            <caption>문의자 정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>노출 여부</th>
                                <td>
                                    <span class="select">
                                        <label for="expsYn">노출</label>
                                        <select name="expsYn" id="expsYn">
                                            <option value="Y">노출</option>
                                            <option value="N">비노출</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <td id="bind_target_id_goodsNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>문의 제목</th>
                                <td id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>닉네임</th>
                                <td id="bind_target_id_memberNn" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>문의 내용</th>
                                <td id="bind_target_id_content" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>작성일</th>
                                <td id="bind_target_id_regDttm" class="bind_target"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">답변 정보</h3>
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 답변 작성 표 입니다. 구성은  입니다.">
                            <caption>답변 작성</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>답변 제목</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="replyTitle" id="replyTitle" data-validation-engine="validate[required], maxSize[200]]" maxlength="200">
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
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="btn_delete">삭제</button>
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
