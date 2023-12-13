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
    <t:putAttribute name="title">테스트</t:putAttribute>
    <t:putAttribute name="style">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {

                // 파일업로드 - 선택한 파일의 경로가 보이고 업로드 버튼을 투르면 업로드
                jQuery('#a_id_upload').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    jQuery('#form_id_imageUploadForm').attr('action', '/admin/common/file-upload');
                    if (Dmall.FileUpload.checkFileSize('form_id_uploadForm')) {
                        jQuery.when(Dmall.FileUpload.upload('form_id_uploadForm')).then(function (result) {
//                            var file = result.files[0] || null;
//                            if (file) {
//                                jQuery('#div_id_download').html('<a class="btn_red" href="/admin/common/common-download?' + jQuery.param(file) + '">다운로드</a>');
//                            }
                        });
                    }
                });
                // 이미지업로드 - 선택한 파일의 경로가 보이고 업로드 버튼을 투르면 업로드
                jQuery('#a_id_image').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    jQuery('#form_id_imageUploadForm').attr('action', '/admin/common/image-upload-temp');
                    jQuery.when(Dmall.FileUpload.upload('form_id_imageUploadForm')).then(
                            function (result) {
                                var file = result.files[0] || null;
                                if (file) {
                                    jQuery('#div_id_image').html('<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>')
                                }
                            });
                });
                // 다중파일업로드 - 선택한 파일의 경로가 보이고 업로드 버튼을 투르면 업로드
                jQuery('#a_id_uploads').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if (Dmall.FileUpload.checkFileSize('form_id_uploadForms')) {
                        Dmall.FileUpload.upload('form_id_uploadForms')
                    }
                });
                // 엑셀업로드 - 선택한 파일의 경로가 보이고 업로드 버튼을 투르면 업로드
                jQuery('#a_id_excel').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    if (Dmall.FileUpload.checkFileSize('form_id_excelUpload')) {
                        Dmall.FileUpload.upload('form_id_excelUpload');
                    }
                });
                // 파일업로드 - 파일을 선택하면 바로 업로드
                jQuery('#a_id_simpleFileUpload').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.FileUpload.file()
                            .done(function (result) {

                                Dmall.FileDownload.download(result.files[0].filePath, result.files[0].fileName)
                            })
                            .fail(function (result) {
                            });
                });
                // 엑셀업로드 - 파일을 선택하면 바로 업로드
                jQuery('#a_id_simpleExcelUpload').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.FileUpload.excel()
                            .done(function (result) {

                            })
                            .fail(function (result) {

                            });
                });
                // 이미지업로드 - 파일을 선택하면 바로 업로드
                jQuery('#a_id_simpleImageUpload').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.FileUpload.image()
                            .done(function (result) {

                                var file = result.files[0] || null;
                                if (file) {
                                    jQuery('#div_id_image2').html('<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>')
                                }
                            })
                            .fail(function (result) {

                            });
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">

        <strong>
            ** 일단은 임시 경로에 올리는 거니, 실제 데이터 저장시 업로드 후 반환하는 임시 파일 경로 데이터를 서버로 넘겨서 <br>
            파일을 실제 저장할 경로로 옮기고 그 경로를 디비에 저장해야 합니다.<br/>
            처음부터 실제 경로에 올리는 경우는 샘플을 따라서 실제 경로로 파일을 떨구도록 개발해주세요
        </strong>
        <br/>
        <form>

        </form>

        <p>
            단일 파일 업로드<br/>
            <form action="/admin/common/file-upload" name="fileUploadForm" id="form_id_uploadForm" method="post" enctype="multipart/form-data">
                <span class="intxt"><input class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                <label class="filebtn" for="input_id_file">파일찾기</label>
                <input class="filebox" name="file" type="file" id="input_id_file">
                <a href="#none" class="btn_blue" id="a_id_upload">업로드</a><br/>
            </form>
            <div id="div_id_download"></div>
        </p>
        <p>
            단일 이미지 업로드<br/>
            <form action="/admin/common/file-upload" name="imageUploadForm" id="form_id_imageUploadForm" method="post" enctype="multipart/form-data" >
                <span class="intxt"><input class="upload-name" type="text" value="이미지선택" disabled="disabled"></span>
                <label class="filebtn" for="input_id_image">이미지찾기</label>
                <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                <a href="#none" class="btn_blue" id="a_id_image">업로드</a><br/>
            </form>
            <div id="div_id_image"></div>
        </p>
        <p>
            다중 파일 업로드<br/>
            <form action="/admin/common/file-upload" name="fileUploadForms" id="form_id_uploadForms" method="post" enctype="multipart/form-data">
                <span class="intxt"><input class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                <label class="filebtn" for="input_id_files">다중파일선택</label>
                <input class="filebox" name="files" type="file" id="input_id_files" multiple="multiple">
                <a href="#none" class="btn_blue" id="a_id_uploads">업로드</a><br/>
            </form>
        </p>
        <p>
            엑셀 파일 업로드<br/>
            <form action="/admin/example/upload-excel" name="fileUploadForm" id="form_id_excelUpload" method="post" enctype="multipart/form-data">
                <span class="intxt"><input class="upload-name" type="text" value="파일선택" disabled="disabled"></span>
                <label class="filebtn" for="input_id_excel">파일찾기</label>
                <input class="filebox" name="excel" type="file" id="input_id_excel" accept="application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
                <a href="#none" class="btn_blue" id="a_id_excel">업로드</a><br/>
            </form>
        </p>
        <p>
            간단 파일 업로드<br/>
            <a href="#none" class="btn_blue" id="a_id_simpleFileUpload">파일 업로드</a>
            <a href="#none" class="btn_blue" id="a_id_simpleExcelUpload">엑셀 파일만 업로드</a>
            <a href="#none" class="btn_blue" id="a_id_simpleImageUpload">이미지 파일만 업로드</a><br/>
            <div id="div_id_image2"></div>
        </p>
        <br/>
        <p>
            다운로드 예제<br/>
            아래 소스와 같이 스크립트를 통해 다운로드 타입과 키값(ID등)으로 호출해주세요<br/>
            <code><pre>
                Dmall.FileDownload.download('BBS', '1')
                </pre>
            </code>
            <a class="btn_red" href="#" onclick="Dmall.FileDownload.download('BBS', '1')">다운로드</a>
        </p>
    </t:putAttribute>
</t:insertDefinition>