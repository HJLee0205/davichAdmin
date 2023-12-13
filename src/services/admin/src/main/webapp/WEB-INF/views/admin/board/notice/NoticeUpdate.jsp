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
            var totalFileSize = 0;

            jQuery(document).ready(function() {
                Dmall.validate.set('form_notice_info');
                Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Dmall.DaumEditor.create('ta_id_content1'); // ta_id_content2 를 ID로 가지는 Textarea를 에디터로 설정

                // 저장하기 버튼 클릭
                $('#btn_regist').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if(Dmall.validate.isValid('form_notice_info')) {
                        Dmall.DaumEditor.setValueToTextarea('ta_id_content1');
                        var url = '/admin/board/board-letter-update';

                        $('#form_notice_info').ajaxSubmit({
                            url: url,
                            dataType: 'json',
                            success: function(result) {
                                if(result.success) {
                                    Dmall.LayerUtil.alert(result.message).done(function() {
                                        var param = { bbsId : $('#bbsId').val() };
                                        Dmall.FormUtil.submit('/admin/board/letter', param);
                                    });
                                } else {
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        })
                    }
                });

                // 파일 등록 콜백
                var num = 1;
                $(document).on('change', 'input[type=file]', function(e) {
                    // 파일 확장자 검사
                    var ext = $(this).val().split('.').pop().toLowerCase();
                    if($.inArray(ext, ['pptx','ppt','xls','xlsx','doc','docx','hwp','pdf','gif','png','jpg','jpeg']) == -1) {
                        Dmall.LayerUtil.alert('pptx,ppt,xls,xlsx,doc,docx,hwp,pdf,gif,png,jpg 파일만 업로드 할수 있습니다.');
                        $('input[name=' + $(e.target).attr('name') + ']').val('');
                        return;
                    }

                    // 파일 용량 검사
                    if (totalFileSize + e.target.files[0].size > 10485760) {
                        Dmall.LayerUtil.alert('최대 용량을 초과하여 파일을 첨부할 수 없습니다.');
                        return;
                    }

                    // 업로드된 파일명 표시
                    var fileNm = e.target.value.substring(e.target.value.lastIndexOf('\\') + 1);
                    $('#fileList').append(
                        '<div class="upload_file" id="' + num + '" data-file-size="' + e.target.files[0].size + '">' +
                        '<span class="txt">' + fileNm + ' (' + convertSize(e.target.files[0].size, 1) + 'KB)' + '</span>' +
                        '<button class="cancel">삭제</button>' +
                        '</div>');

                    // 새로운 파일첨부 버튼 추가
                    $('label[for=input_' + $(e.target).attr('name') + ']').css('display', 'none');
                    num = num + 1;
                    var template =
                        '<label for="input_file' + num + '" class="filebtn on">파일첨부' +
                        '<input type="file" name="file' + num + '" id="input_file' + num + '" class="filebox">' +
                        '</label>';
                    $('#input_file').append(template);

                    // 총 업로드 파일 용량 표시
                    totalFileSize += e.target.files[0].size;
                    setTotalSize();
                });

                // 등록한 파일 삭제
                $(document).on('click', '#fileList button.cancel', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var obj = $(e.target).parents('.upload_file');
                    if(obj.attr('id')) {
                        var num = obj.attr('id');
                        var size = obj.data('file-size');
                        obj.remove();
                        $('label[for=input_file' + num + ']').remove();
                        totalFileSize -= size;
                        setTotalSize();
                    } else {
                        delRemoteFile(e.target);
                    }
                });

                // 전체삭제 버튼 클릭
                $('#fileList button.btn_gray').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($('#fileList').children().is('div.upload_file') && $('#fileList').children().is('div[data-file-no]')) {
                        delAtchFileTemplate('remote');
                    } else {
                        delAtchFileTemplate('local');
                    }
                });

                // 게시물 상세 조회
                var param = { bbsId: "${so.bbsId}", lettNo: "${so.lettNo}" };
                var url = '/admin/board/board-letter-detail';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    Dmall.FormUtil.jsonToForm(result.data, 'form_notice_info');
                    Dmall.DaumEditor.setContent('ta_id_content1', result.data.content); // 에디터에 데이터 세팅
                    Dmall.DaumEditor.setAttachedImage('ta_id_content1', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅

                    // 서버 첨부 파일 바인딩
                    bindAtchFile(result.data.atchFileArr);
                });

                // 회원 상세 페이지 이동
                $('#bind_target_id_loginId').on('click', function() {
                    var param = { memberNo: $('#memberNo').val() };
                    Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', param, '_blank');
                });
            });

            // 첨부 파일 템플릿 삭제
            function delAtchFileTemplate(delType) {
                if(delType == 'local') {
                    $('#fileList div.upload_file').each(function(idx, obj) {
                        var id = $(obj).attr('id');
                        $('#' + id).remove();
                        $('label[for=input_file' + id + ']').remove();
                        totalFileSize = 0;
                        setTotalSize();
                    });
                } else {
                    $('#fileList div.upload_file').each(function(idx, obj) {
                        if($(obj).attr('id')) {
                            return true;
                        } else {
                            var fileNo = $(obj).data('file-no');
                            var url = '/admin/board/attach-file-delete';
                            var param = { fileNo: fileNo, bbsId: $('#bbsId').val() };

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                $('#fileList div.upload_file').each(function(idx, obj) {
                                    $(obj).remove();
                                    if($(obj).attr('id')) {
                                        var id = $(obj).attr('id');
                                        $('label[for=input_file' + id + ']').remove();
                                    }
                                });
                                totalFileSize = 0;
                                setTotalSize();
                            });
                        }
                    });
                }
            }

            // 서버 첨부 파일 바인딩
            function bindAtchFile(data) {
                jQuery.each(data, function(idx, obj) {
                    $('#fileList').append(
                        '<div class="upload_file" data-file-no="' + obj.fileNo + '" data-file-size="' + obj.fileSize + '">' +
                        '<span class="txt">' + obj.orgFileNm + ' (' + convertSize(obj.fileSize, 1) + 'KB)' + '</span>' +
                        '<button class="cancel">삭제</button>' +
                        '</div>');
                    totalFileSize += obj.fileSize;
                });
                setTotalSize();
            }

            // 서버 첨부 파일 삭제
            function delRemoteFile(el) {
                Dmall.LayerUtil.confirm('삭제된 파일은 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                    var obj = $(el).parents('div.upload_file');
                    var fileNo = obj.data('file-no');
                    var url = '/admin/board/attach-file-delete';
                    var param = { fileNo: fileNo, bbsId: $('#bbsId').val() };

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var fileSize = obj.data('file-size');
                        totalFileSize -= fileSize;
                        obj.remove();
                        setTotalSize();
                    });
                });
            }

            function setTotalSize() {
                $('#fileSize').text(convertSize(totalFileSize, 2) + 'MB');
            }

            function convertSize(size, unit) {
                for(let i = 0; i < unit; i++) {
                    size = size / 1024;
                }
                return size.toFixed(1).toLocaleString('ko-KR');
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
            <form id="form_notice_info" method="post">
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
                                <th>공지글</th>
                                <td colspan="5">
                                    <span id="noticeSet">
                                        <label for="bind_target_id_noticeYn" class="chack mr20">
                                          <span class="ico_comm">
                                              <input type="checkbox" name="noticeYn" value="Y" id="bind_target_id_noticeYn" class="bind_target">
                                          </span>
                                        공지글로 설정하기</label>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>제목<span class="important">*</span></th>
                                <td colspan="5">
                                    <input type="hidden" id="bbsId" name="bbsId" value="${so.bbsId}">
                                    <input type="hidden" id="lettNo" name="lettNo" value="${so.lettNo}">
                                    <span class="intxt w100p">
                                        <input type="text" id="title" name="title" placeholder="제목을 입력해주세요." data-validation-engine="validate[required], maxSize[500]]">
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
                                <th>파일첨부</th>
                                <td colspan="5" id="fileList">
                                    <div class="file_btn_box mb20">
                                        <div class="left" id="input_file">
                                            <label for="input_file1" class="filebtn on">파일첨부
                                                <input type="file" name="file1" id="input_file1" class="filebox">
                                            </label>
                                        </div>
                                        <div class="file_size">
                                            <span class="point_c6" id="fileSize">0MB</span> / 10MB
                                        </div>
                                        <div class="right">
                                            <button class="btn_gray2">전체삭제</button>
                                        </div>
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
            <!-- //line_box -->
            <!-- bottom_box -->
            <div class="bottom_box">
                <div class="right">
                    <button class="btn--blue-round" id="btn_regist">저장하기</button>
                </div>
            </div>
            <!-- //bottom_box -->
        </div>
    </t:putAttribute>
</t:insertDefinition>
