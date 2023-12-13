<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/02
  Time: 12:21 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
    <t:putAttribute name="title">검사법 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(() => {
                // 목록 버튼 클릭
                $('#btn_list').on('click', () => {
                    var param = { bbsId: $('#bbsId').val() };
                    Dmall.FormUtil.submit('/admin/board/letter', param);
                });

                // 수정하기 버튼 클릭
                $('#btn_update').on('click', () => {
                    var param = { bbsId: $('#bbsId').val(), lettNo: $('#lettNo').val() };
                    Dmall.FormUtil.submit('/admin/board/letter-update-form', param);
                });

                // 게시글 정보 조회
                var param = { bbsId: "${so.bbsId}", lettNo: "${so.lettNo}" };
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, (result) => {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_inspection_info');
                    $('#contentArea').html(result.data.content);

                    // 서버 첨부 파일 바인딩
                    bindAtchFile(result.data.atchFileArr);
                });

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
                });
            });

            // 서버 첨부 파일 바인딩
            function bindAtchFile(data) {
                jQuery.each(data, (idx, obj) => {
                    var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=' + obj.filePath + '&id1=' + obj.fileNm;
                    $('#image_container').append(
                        '<span class="img_Insert">' +
                        '<img src="' + imgSrc + '" alt="대표 이미지">' +
                        '</span>'
                    );
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    게시물 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">검사법</h2>
            </div>
            <form id="form_inspection_info">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}">
                    <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table>
                            <caption>게시글 등록</caption>
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
                                <th>대표이미지</th>
                                <td colspan="5" id="image_container"></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
                <!-- //line_box -->
            </form>
            <!--bottom_box  -->
            <div class="bottom_box">
                <div class="left">
                    <button class="btn--big btn--big-white" id="btn_list">목록</button>
                </div>
                <div class="right">
                    <button class="btn--blue-round" id="btn_update">수정하기</button>
                </div>
            </div>
            <!--//bottom_box  -->
        </div>
    </t:putAttribute>
</t:insertDefinition>