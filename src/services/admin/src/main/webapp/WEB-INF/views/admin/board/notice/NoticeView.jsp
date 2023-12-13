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
    <t:putAttribute name="title">공지사항 > 게시물</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function() {
                // 게시글 리스트 화면
                jQuery('#btn_list').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var param = {bbsId : $('#bbsId').val()};
                    Dmall.FormUtil.submit('/admin/board/letter', param);
                });

                // 게시글 수정 화면 이동
                jQuery('#btn_change').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    var param = { bbsId: $('#bbsId').val(), lettNo: $('#lettNo').val() };
                    Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
                });

                // 게시글 정보 가져오기
                var param = { bbsId: "${so.bbsId}", lettNo: "${so.lettNo}" };
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_notice_info');
                    $('#contentArea').html(result.data.content);
                    jQuery.each(result.data.atchFileArr, function(idx, obj) {
                        var template =
                            '<div class="mt10 mb10">' +
                            '<a href="#none" class="tbl_link" onclick="return fileDownload(' + obj.fileNo + ');">' + obj.orgFileNm + ' (' + convertSize(obj.fileSize, 1) + 'KB)</a>' +
                            '</div>';
                        $('#FileInsert').append(template);
                    });
                });

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
                });
            });

            function convertSize(size, unit) {
                for(let i = 0; i < unit; i++) {
                    size = size / 1024;
                }
                return size.toFixed(1).toLocaleString('ko-KR');
            }

            function fileDownload(fileNo){
                var url = '/admin/board/download';
                var param = {fileNo : fileNo};

                Dmall.FormUtil.submit(url, param, '_blank');

                return false;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">공지사항</h2>
            </div>
            <form id="form_notice_info">
                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}">
                <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}">
                <!-- line_box -->
                <div class="line_box fri">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 보기 표 입니다. 구성은 작성자, 작성일, 말머리, 공지글 설정, 제목, 내용 입니다.">
                            <caption>게시글 보기</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                                <col width="150px">
                                <col width="25%">
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>작성자</th>
                                <td id="bind_target_id_memberNm" class="bind_target"></td>
                                <th>아이디</th>
                                <td>
                                    <input type="hidden" id="memberNo" name="memberNo" value="">
                                    <a href="#none" id="bind_target_id_loginId" class="bind_target tbl_link"></a>
                                </td>
                                <th>등급</th>
                                <td id="bind_target_id_memberGradeNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td colspan="5" id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td colspan="5" id="contentArea"></td>
                            </tr>
                            <tr>
                                <th>파일첨부</th>
                                <td colspan="5" >
                                    <span id="FileInsert"></span>
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
