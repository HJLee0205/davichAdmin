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
    <t:putAttribute name="title">판매자 문의 > 기본</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('formBbsLettListUpdate');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 게시글 목록 화면 이동
                $('#btn_list').on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/seller/setup/inquiry-list');
                });
                
                // 수정 버튼 클릭
                $('#btn_update').on('click', function(e) {
                    if(Dmall.validate.isValid('formBbsLettListUpdate')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/seller/setup/board-letter-update';
                        var param = $('#formBbsLettListUpdate').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            Dmall.validate.viewExceptionMessage(result, 'formBbsLettListUpdate');
                            if(result.success){
                                Dmall.FormUtil.submit('/admin/seller/setup/inquiry-list');
                            }
                        });
                    }
                });
                
                // 게시글 상세조회
                var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                var url = '/admin/seller/setup/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'formBbsLettListUpdate');
                    $('#replyContent').html(result.data.replyContent);
                    $('#inquiryCd').val(result.data.inquiryCd).prop('selected', true);
                    
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.content); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 문의</h2>
            </div>
            <form id="formBbsLettListUpdate">
                <input type="hidden" name="bbsId" id="bbsId" value="${so.bbsId}">
                <input type="hidden" name="lettNo" id="lettNo" value="${so.lettNo}">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 답변 등록 표 입니다. 구성은 질문유형, 게시글 제목, 게시글 내용입니다.">
                            <caption>게시글 보기</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>질문유형</th>
                                <td>
                                    <span class="select">
                                        <label for="inquiryCd">상품 정보 문의</label>
                                        <select id="inquiryCd" name="inquiryCd">
                                            <cd:optionUDV codeGrp="INQUIRY_CD"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td class="in_del">
                                    <span class="intxt wid100p">
                                        <input type="text" name="title" id="title" data-validation-engine="validate[required], maxSize[500]]" value="제목이 표시됩니다.">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="content" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>답변 제목</th>
                                <td id="bind_target_id_replyTitle" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>답변 내용</th>
                                <td id="replyContent"></td>
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
                <button class="btn--blue-round" id="btn_update">수정</button>
            </div>
        </div>
        <!--// bottom_box -->
    </t:putAttribute>
</t:insertDefinition>
