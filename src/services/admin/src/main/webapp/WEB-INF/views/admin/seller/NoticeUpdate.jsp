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
    <t:putAttribute name="title">판매자 공지 > 업체</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(function() {
                Dmall.validate.set('form_sellnotice_info');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 목록 버튼 클릭
                $('#btn_list').on('click', function() {
                    Dmall.FormUtil.submit('/admin/seller/notice-list');
                });

                // 저장 버튼 클릭
                $('#btn_save').on('click', function() {
                    Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                    if(Dmall.validate.isValid('form_sellnotice_info')) {
                        var url = '/admin/board/board-letter-insert';
                        var param = $('#form_sellnotice_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/seller/notice-list');
                            }
                        });
                    }
                });

                // 수정 버튼 클릭
                $('#btn_update').on('click', function() {
                    Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                    if(Dmall.validate.isValid('form_sellnotice_info')) {
                        var url = '/admin/board/board-letter-update';
                        var param = $('#form_sellnotice_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/seller/notice-list');
                            }
                        });
                    }
                });

                // 게시글 상세조회
                if(${so.lettNo != null}) {
                    var param = {lettNo:"${so.lettNo}", bbsId:"${so.bbsId}"};
                    var url = '/admin/board/board-letter-detail';
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.FormUtil.jsonToForm(result.data, 'form_sellnotice_info');

                        Dmall.DaumEditor.setContent('ta_id_content1', result.data.content); // 에디터에 데이터 세팅
                        Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                    });
                }
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    업체 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">판매자 공지</h2>
            </div>
            <form id="form_sellnotice_info">
                <input type="hidden" id="bbsId" name="bbsId" value="sellNotice">
                <input type="hidden" id="lettNo" name="lettNo" value="">
                <!-- line_box -->
                <div class="line_box fri">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 등록 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
                            <caption>게시글 등록</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>판매자</th>
                                <td>
                                    <span class="select">
                                        <label for="sel_seller">전체</label>
                                        <select name="sellerNo" id="sel_seller">
                                            <cd:sellerOption siteno="${siteNo}" includeNotiTotal="true"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>제목 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" id="title" name="title" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[500]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>내용 <span class="important">*</span></th>
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
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <c:choose>
                    <c:when test="${so.lettNo == null}">
                        <button class="btn--blue-round" id="btn_save">저장</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn--blue-round" id="btn_update">수정</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
