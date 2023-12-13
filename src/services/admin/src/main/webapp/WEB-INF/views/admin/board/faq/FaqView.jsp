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
    <t:putAttribute name="title">자주 묻는 질문 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                // 게시물 상세 조회
                var param = {bbsId: "${so.bbsId}", lettNo: "${so.lettNo}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_faq_info');
                    $('#contentArea').html(result.data.content);
                });

                // 게시글 리스트 화면
                jQuery('#btn_list').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var param = {bbsId : $('#bbsId').val()};
                    Dmall.FormUtil.submit('/admin/board/letter', param);
                });

                // 수정하기 버튼 클릭
                $('#btn_change').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var param = {bbsId: $('#bbsId').val(), lettNo: $('#lettNo').val()};
                    Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
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
                        <table summary="이표는 게시글 보기 표 입니다. 구성은 작성자, 작성일, 공지글 설정, 제목, 내용 입니다.">
                            <caption>게시글 보기</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>분류</th>
                                <td id="bind_target_id_faqGbNm" class="bind_target">기타</td>
                            </tr>
                            <tr>
                                <th>질문
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                                    <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}" />
                                </th>
                                <td  id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>답변</th>
                                <td  id="contentArea"></td>
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
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_change">수정하기</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
