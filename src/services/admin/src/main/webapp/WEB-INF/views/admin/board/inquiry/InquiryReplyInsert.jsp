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
    <t:putAttribute name="title">1:1 문의 > 게시물</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            jQuery(document).ready(function () {
                Dmall.validate.set('form_inquiry_info');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 저장 버튼 클릭
                jQuery('#btn_save').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if (Dmall.validate.isValid('form_inquiry_info')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');  // 에디터에서 폼으로 데이터 세팅
                        var url = '/admin/board/board-reply-insert';
                        var param = jQuery('#form_inquiry_info').serialize();

                        console.log("param = ", param);
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_inquiry_info');
                            if (result.success) {
                                var param = {bbsId: "${so.bbsId}"}
                                Dmall.FormUtil.submit('/admin/board/letter', param);
                            }
                        });
                    }
                });

                // 게시글 정보 조회
                var url = '/admin/board/board-letter-detail';
                var param = {lettNo: "${so.lettNo}", bbsId: "${so.bbsId}"};
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if(result.data.inquiryCd == '6' || result.data.inquiryCd == '7' || result.data.inquiryCd == '3') {
                        result.data.inquiryNm = '환불/취소';
                    }
                    if(result.data.inquiryCd == '8' || result.data.inquiryCd == '4') {
                        result.data.inquiryNm = '교환/AS';
                    }

                    Dmall.FormUtil.jsonToForm(result.data, 'form_inquiry_info');
                    // 첨부이미지 데이터 바인딩
                    $.each(result.data.atchFileArr, function (idx, obj) {
                        var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path='+ obj.filePath +'&id1='+ obj.fileNm;
                        var template =
                            '<span class="img_Insert" style="cursor: pointer;">' +
                            '<img src="'+ imgSrc +'" alt="">' +
                            '</span>';
                        $('#insertImg').append(template);
                    });
                    // 답변내용 데이터 바인딩
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.replyContent); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                });

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
                });

                // 이미지 확대보기
                $(document).on('click', 'span.img_Insert > img', function () {
                    $('#img_preview_goods_image').attr('src', $(this).attr('src'));
                    Dmall.LayerPopupUtil.open($('#layer_preview_upload_image'));
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
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 답변 등록 표 입니다. 구성은 작성자, 질분유형, 게시글 제목, 게시글 내용, 답변 제목, 답변 내용, SMS발송, 이메일발송 입니다.">
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
                                <td colspan="5">
                                    <input type="hidden" name="bbsId" value="${so.bbsId}">
                                    <input type="hidden" name="lettNo" value="${so.lettNo}">
                                    <input type="hidden" name="replyLettNo">
                                    <input type="hidden" name="grpNo">
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="replyContent" class="blind"></textarea><!-- 에디터 컨테이너 시작 -->
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>SMS발송</th>
                                <td colspan="5">
                                    <label for="bind_target_id_smsSendYn" class="chack mr20">
                                        <span class="ico_comm">
                                          <input
                                                  type="checkbox"
                                                  name="smsSendYn"
                                                  id="bind_target_id_smsSendYn"
                                                  class="bind_target"
                                                  value="Y"
                                          />
                                        </span>
                                        해당 회원에게 답변완료 SMS를 발송합니다.
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th>이메일발송</th>
                                <td colspan="5">
                                    <label for="bind_target_id_emailSendYn" class="chack mr20">
                                        <span class="ico_comm">
                                          <input
                                                  type="checkbox"
                                                  name="emailSendYn"
                                                  id="bind_target_id_emailSendYn"
                                                  class="bind_target"
                                                  value="Y"
                                          />
                                        </span>
                                        해당 회원에게 답변완료 이메일을 발송합니다.
                                    </label>
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

        <!-- 이미지 확대 팝업 -->
        <div id="layer_preview_upload_image" class="layer_popup">
            <div class="pop_wrap size2">
                <div class="pop_tlt">
                    <h2 class="tlth2">이미지 미리보기</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <div class="pop_con">
                    <div>
                        <img src="" alt="" id="img_preview_goods_image">
                    </div>
                </div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>
