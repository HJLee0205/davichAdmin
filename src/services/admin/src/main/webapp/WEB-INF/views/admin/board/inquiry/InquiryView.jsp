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
    <t:putAttribute name="title">1:1 문의 > 게시물</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                // 게시글 정보 조회
                var param = {bbsId: "${so.bbsId}", lettNo: "${so.lettNo}"};
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.data.inquiryCd == '6' || result.data.inquiryCd == '7' || result.data.inquiryCd == '3') {
                        result.data.inquiryNm = '환불/취소';
                    }
                    if(result.data.inquiryCd == '8' || result.data.inquiryCd == '4') {
                        result.data.inquiryNm = '교환/AS';
                    }

                    Dmall.FormUtil.jsonToForm(result.data, 'form_inquiry_info');
                    // 답변내용 데이터 바인딩
                    $('#contentArea').html(result.data.replyContent);
                    // 첨부이미지 데이터 바인딩
                    $.each(result.data.atchFileArr, function (idx, obj) {
                        var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=' + obj.filePath + '&id1=' + obj.fileNm;
                        var template =
                            '<span class="img_Insert">' +
                            '<img src="'+ imgSrc +'" alt="">' +
                            '</span>';
                        $('#insertImg').append(template);
                    });
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

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
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
                <h2 class="tlth2">1:1 문의</h2>
            </div>
            <!-- search_box -->
            <form id="form_inquiry_info">
                <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}" />
                <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}" />
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table
                                summary="이표는 게시글 보기 표 입니다. 구성은 작성자,아이디, 등급, 작성일, 공지글 설정, 제목, 내용 입니다."
                        >
                            <caption>
                                게시글 보기
                            </caption>
                            <colgroup>
                                <col width="150px" />
                                <col width="" />
                                <col width="150px" />
                                <col width="25%" />
                                <col width="150px" />
                                <col width="" />
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
                                <th>분류</th>
                                <td colspan="5" id="bind_target_id_inquiryNm" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>게시글 제목</th>
                                <td colspan="5" id="bind_target_id_title" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>게시글 내용</th>
                                <td colspan="5" id="bind_target_id_content" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>게시글 첨부 이미지</th>
                                <td colspan="5" id="insertImg">
                                </td>
                            </tr>
                            <tr>
                                <th>답변 내용</th>
                                <td colspan="5" id="contentArea"></td>
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
