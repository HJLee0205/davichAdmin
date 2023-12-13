<%--
  Created by IntelliJ IDEA.
  User: intervision
  Date: 2023/01/02
  Time: 11:14 AM
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
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(document).ready(() => {
                Dmall.validate.set('form_inspection_info');
                Dmall.DaumEditor.init();
                Dmall.DaumEditor.create('ta_id_content1');

                // 저장하기 버튼 클릭
                $('#btn_regist').on('click', () => {
                    if(Dmall.validate.isValid('form_inspection_info')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                        var url = '/admin/board/board-letter-update';

                        $('#form_inspection_info').ajaxSubmit({
                            url: url,
                            dataType: 'json',
                            success: (result) => {
                                if(result.success) {
                                    Dmall.LayerUtil.alert(result.message).done(() => {
                                        var param = { bbsId: $('#bbsId').val() };
                                        Dmall.FormUtil.submit('/admin/board/letter', param);
                                    });
                                } else {
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        })
                    }
                });

                // 이미지 삭제 버튼 클릭
                $(document).on('click', '.mg_upload_file .cancel', (e) => {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var obj = $(e.target).parents('.mg_upload_file');
                    if(obj.attr('data-file-no')) {
                        delRemoteFile(obj.attr('data-file-no'));
                    } else {
                        obj.remove();
                        $('input[name=file]').val('');
                    }
                });

                // 이미지 첨부 시 미리보기 이미지 표시
                $('input[type=file]').change(function() {
                    if(this.files && this.files[0]) {
                        var self = this;
                        var fileNm = this.files[0].name;
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            if($(self).parents('td').children().is('.mg_upload_file')) {
                                Dmall.LayerUtil.alert('이미 대표 이미지가 등록되어 있습니다.<br/>기존 이미지를 삭제 후 진행해주세요.');
                                $(self).val('');
                            } else {
                                var template =
                                    '<div class="mg_upload_file">' +
                                    '<img src="' + e.target.result + '" width="110" height="110" alt="미리보기 이미지" class="mr20">' +
                                    '<span class="txt">' + fileNm + '</span>' +
                                    '<button class="cancel">삭제</button>' +
                                    '</div>';
                                $(self).parents('td').append(template);
                            }
                        };
                        reader.readAsDataURL(this.files[0]);
                    }
                });

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
                });
            });

            // 게시물 상세 조회
            var param = { bbsId: "${so.bbsId}", lettNo: "${so.lettNo}" };
            var url = '/admin/board/board-letter-detail';
            Dmall.AjaxUtil.getJSON(url, param, (result) => {
                Dmall.FormUtil.jsonToForm(result.data, 'form_inspection_info');
                Dmall.DaumEditor.setContent('ta_id_content1', result.data.content);
                Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages);

                // 서버 첨부 파일 바인딩
                bindAtchFile(result.data.atchFileArr);
            });

            // 서버 이미지 파일 삭제
            function delRemoteFile(fileNo) {
                Dmall.LayerUtil.confirm('삭제된 이미지는 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', () => {
                    var url = '/admin/board/attach-file-delete';
                    var param = { fileNo: fileNo, bbsId: $('#bbsId').val() };

                    Dmall.AjaxUtil.getJSON(url, param, (result) => {
                        $('div[data-file-no=' + fileNo + ']').remove();
                    });
                });
            }

            // 서버 첨부 파일 바인딩
            function bindAtchFile(data) {
                jQuery.each(data, (idx, obj) => {
                    var imgSrc = '${_IMAGE_DOMAIN}/image/image-view?type=BBSDTL&path=' + obj.filePath + '&id1=' + obj.fileNm;
                    $('label[for=input_id_image]').parents('td').append(
                        '<div class="mg_upload_file" data-file-no="' + obj.fileNo + '">' +
                        '<img src="' + imgSrc + '" width="110" height="110" alt="미리보기 이미지" class="mr20">' +
                        '<span class="txt">' + obj.orgFileNm + '</span>' +
                        '<button class="cancel">삭제</button>' +
                        '</div>'
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
            <form id="form_inspection_info" method="post">
                <!-- line_box -->
                <div class="line_box fri pb">
                    <!-- tblw -->
                    <div class="tblw mt0">
                        <table summary="이표는 게시글 등록 표 입니다. 구성은 작성자, 말머리, 제목, 내용 입니다.">
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
                                <th>제목<span class="important">*</span></th>
                                <td colspan="5">
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}">
                                    <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}">
                                    <span class="intxt w100p">
                                        <input type="text" id="title" name="title" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[200]]" maxlength="200">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td colspan="5">
                                    <div class="edit">
                                        <textarea id="ta_id_content1" name="content" class="blind"></textarea>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>대표이미지
                                    <span class="help_wrap ml0">
                                        <button class="help_ico">도움말 정보버튼</button>
                                        <div class="help_popup main_img_popup">
                                            <div class="pop_wrap">
                                                <div class="pop_tlt">
                                                    <h2 class="tlth2">대표 이미지</h2>
                                                </div>
                                                <div class="pop_main">
                                                    <span class="txt">검사법 목록에서 표시되는 대표 이미지입니다.</span>
                                                    <div class="pop_img">
                                                        <div class="pop_app">
                                                            <span>[app]</span>
                                                            <img src="/admin/img/common/new/app_img02.png" alt="">
                                                        </div>
                                                        <div class="pop_web">
                                                            <span>[web]</span>
                                                            <img src="/admin/img/common/new/web_img02.png" alt="">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </span>
                                </th>
                                <td colspan="5">
                                    <span class="intxt imgup2"><input id="file_route1" class="upload-name" type="text" disabled></span>
                                    <label class="filebtn on" for="input_id_image">파일첨부
                                        <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                                    </label>
                                    <span class="br"></span>
                                    <span class="desc">
                                        * 파일 첨부 시 3MB 이하 업로드 ( jpg / png / bmp )<br>
                                        * 이미지 권장 사이즈 400*400px<br>
                                        * 이미지를 첨부하지 않을 경우 기본이미지 표시
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>SEO 검색용 태그</th>
                                <td colspan="5">
                                    <div class="txt_area">
                                        <textarea name="seoSearchWord" maxlength="300"></textarea>
                                    </div>
                                    <span class="fc_pr1 fs_pr1">
                                        ※ 쉼표(,)로 띄어쓰기 없이 구분하여 등록해주세요.<br/>
                                        ※ ex) 안경,안경테,안경렌즈
                                    </span>
                                </td>
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
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">저장하기</button>
                </div>
            </div>
            <!--//bottom_box  -->
        </div>
    </t:putAttribute>
</t:insertDefinition>