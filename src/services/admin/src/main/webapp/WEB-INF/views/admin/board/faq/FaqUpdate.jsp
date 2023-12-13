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
    <t:putAttribute name="title">자주 묻는 질문 > 게시물</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('form_faq_info');
                Dmall.DaumEditor.init();
                Dmall.DaumEditor.create('ta_id_content1');

                // 게시물 상세 조회
                var param = { bbsId: "${so.bbsId}", lettNo: "${so.lettNo}" };
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_faq_info');
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.content);
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages);
                });

                // 저장하기 버튼 클릭
                $('#btn_save').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if(Dmall.validate.isValid('form_faq_info')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                        var url = '/admin/board/board-letter-update';
                        var param = $('#form_faq_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                var param = { bbsId: $('#bbsId').val() };
                                Dmall.FormUtil.submit('/admin/board/letter', param);
                            }
                        });
                    }
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">자주 묻는 질문</h2>
            </div>
            <form id="form_faq_info">
                <!-- line_box -->
                <div class="line_box fri">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 등록 표 입니다. 구성은 질문, 질문 분류, 답변 입니다.">
                            <caption>게시글 등록</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>분류</th>
                                <td><code:radioUDV codeGrp="FAQ_GB_CD" name="faqGbCd" idPrefix="faqGbCd"/></td>
                            </tr>
                            <tr>
                                <th>질문<span class="important">*</span></th>
                                <td class="in_del">
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                    <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}" />
                                    <span class="intxt wid100p">
                                        <input type="text" name="title" id="title" placeholder="질문을 입력해주세요." data-validation-engine="validate[required]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>답변<span class="important">*</span></th>
                                <td>
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="content" class="blind"></textarea>
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
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btn_save">저장하기</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
