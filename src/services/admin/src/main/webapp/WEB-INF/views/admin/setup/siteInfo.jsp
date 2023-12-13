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
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">사이트 기본정보</t:putAttribute>
    <t:putAttribute name="style">
        <link href="/admin/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/admin/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                // 기본관리 데이터 조회
                fn_getSiteInfo();

                // 사업장주소 주소선택
                $('#btn_post').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.zipcode(setZipcode);
                });

                // 반품지주소 주소선택
                $('#btn_return_post').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.zipcode(setRetZipcode);
                });

                // 저장하기
                $('#btn_regist').off("click").on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    fn_setFormInputParam();

                    if (Dmall.validate.isValid('form_site_info')) {
                        var url = '/admin/setup/siteinfo/site-info-update',
                            param = $('#form_site_info').serialize();

                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_site_info');

                            if (result == null || result.success != true) {
                                return;
                            } else {
                                fn_getSiteInfo();

                                // 다음에디터 로딩
                                // getCompanyInfo();
                            }
                        });
                    }
                });

                // 관리자이메일 변경 이벤트
                $('#sel_company_domain').on('change', function() {
                    if($(this).val()) {
                        $('#txt_mail_domain').prop('readonly', true);
                        $('#txt_mail_domain').val($(this).val());
                    } else {
                        $('#txt_mail_domain').prop('readonly', false);
                        $('#txt_mail_domain').val('').focus();
                    }
                });

                // 고객센터 이메일 변경 이벤트
                $('#sel_cs_domain').on('change', function() {
                    if($(this).val()) {
                        $('#txt_cust_oper_domain').prop('readonly', true);
                        $('#txt_cust_oper_domain').val($(this).val());
                    } else {
                        $('#txt_cust_oper_domain').prop('readonly', false);
                        $('#txt_cust_oper_domain').val('').focus();
                    }
                });

                // 읽기전용 input은 포커싱될 때 바로 포커스 제거
                $('input[readonly]').focus(function () {
                    this.blur();
                });

                // Valicator 셋팅
                Dmall.validate.set('form_site_info');

                Dmall.common.phoneNumber();









                <%--jQuery('#btn_link_home_certify').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    Dmall.LayerUtil.confirm('쇼핑몰 실명인증 페이지로 이동 하시겠습니까?', fn_linkHomeCertify);--%>
                <%--});--%>

                <%--jQuery('#btn_link_home_mypage').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    Dmall.LayerUtil.confirm('쇼핑몰 마이페이지로 이동 하시겠습니까?', fn_linkHomeMypage);--%>
                <%--});--%>

                <%--/*--%>
                <%--jQuery('#btn_chg_domain').off("click").on('click', function(e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    alert("도메인 변경 인터페이스 호출");--%>
                <%--});--%>

                <%--jQuery('#btn_add_domain').off("click").on('click', function(e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    alert("도메인 추가 인터페이스 호출");--%>
                <%--});--%>
                <%--*/--%>

                <%--$('#sel_company_domain').change(function () {--%>
                <%--    var domain = $(this).val()--%>
                <%--        ,--%>
                <%--        value = $('#txt_mail_domain').data('prev_value') ? $('#txt_mail_domain').data('prev_value') : '';--%>
                <%--    if (domain === '') {--%>
                <%--        $('#txt_mail_domain').removeAttr("readonly").val(value).focus();--%>
                <%--    } else {--%>
                <%--        $('#txt_mail_domain').attr("readonly", "readonly").val(domain);--%>
                <%--    }--%>
                <%--})--%>

                <%--jQuery('#a_upload_fvc').off("click").on('click', function (e) {--%>
                <%--    Dmall.LayerPopupUtil.open(jQuery('#layer_id_fvc'));--%>
                <%--});--%>

                <%--jQuery('#a_id_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>

                <%--    if (Dmall.FileUpload.checkFileSize('fileUploadForm')) {--%>

                <%--        var $input = $('#file_favicon')--%>
                <%--            , ext = $input.val().split('.').pop().toLowerCase();--%>

                <%--        if ($.inArray(ext, ['ico']) == -1) {--%>
                <%--            Dmall.LayerUtil.alert('FAVICO 파일이 아닙니다. (확장자 .ico 만 업로드 가능)');--%>
                <%--            return;--%>
                <%--        } else {--%>
                <%--            /*--%>
                <%--                var reader = new FileReader();--%>
                <%--                reader.onload = function(e) {--%>
                <%--                    $('#tempImg').attr('src', e.target.result);--%>
                <%--                }--%>
                <%--                reader.readAsDataURL($input[0].files[0]);--%>

                <%--                //이미지 사이즈를 검증한다.--%>
                <%--                reader.onloadend = function() {--%>
                <%--                    uploadTempImg();--%>
                <%--                }--%>
                <%--            */--%>
                <%--            jQuery.when(Dmall.FileUpload.upload('fileUploadForm')).then(function (result) {--%>
                <%--                var file = result.files[0] || null;--%>
                <%--                if (file) {--%>
                <%--                    // jQuery('#div_id_download').html('<a class="btn_red" href="/admin/common/common-download?' + jQuery.param(file) + '">파비콘 이미지가 업로드 되었습니다.</a>');--%>
                <%--                    var imgSrc = '<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>';--%>
                <%--                    jQuery('#div_id_download, #sp_img_fvc').html(imgSrc);--%>
                <%--                    $('#hid_filepath').val(file.filePath);--%>
                <%--                    $('#hid_filename').val(file.fileName);--%>
                <%--                    // alert('파비콘 이미지가 업로드 되었습니다.');--%>
                <%--                } else {--%>
                <%--                    Dmall.LayerUtil.alert('FAVICO 파일 처리 중 오류가 발생했습니다. 파일 형식이 올바른 FAVICO 파일인지 확인해 주십시요.');--%>
                <%--                }--%>
                <%--            });--%>
                <%--        }--%>
                <%--    }--%>
                <%--});--%>

                <%--jQuery('#a_upload_logo').off("click").on('click', function (e) {--%>
                <%--    Dmall.LayerPopupUtil.open(jQuery('#layer_id_logo'));--%>
                <%--});--%>

                <%--jQuery('#a_logo_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    if (Dmall.FileUpload.checkFileSize('logoUploadForm')) {--%>
                <%--        var $input = $('#file_logo')--%>
                <%--            , ext = $input.val().split('.').pop().toLowerCase();--%>

                <%--        if ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {--%>
                <%--            Dmall.LayerUtil.alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');--%>
                <%--            return;--%>
                <%--        } else {--%>
                <%--            jQuery.when(Dmall.FileUpload.upload('logoUploadForm')).then(function (result) {--%>
                <%--                var file = result.files[0] || null;--%>
                <%--                if (file) {--%>
                <%--                    if (file) {--%>
                <%--                        var imgSrc = '<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>';--%>
                <%--                        jQuery('#div_logo_download').html(imgSrc);--%>
                <%--                        jQuery('#sp_img_logo').html(imgSrc);--%>

                <%--                        $('#hid_logo_filepath').val(file.filePath);--%>
                <%--                        $('#hid_logo_filename').val(file.fileName);--%>
                <%--                    }--%>
                <%--                }--%>
                <%--            });--%>
                <%--        }--%>
                <%--    }--%>
                <%--});--%>

                <%--jQuery('#a_upload_bottom_logo').off("click").on('click', function (e) {--%>
                <%--    Dmall.LayerPopupUtil.open(jQuery('#layer_id_bottom_logo'));--%>
                <%--});--%>

                <%--jQuery('#a_bottom_logo_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    if (Dmall.FileUpload.checkFileSize('bottomLogoUploadForm')) {--%>
                <%--        var $input = $('#file_bottom_logo')--%>
                <%--            , ext = $input.val().split('.').pop().toLowerCase();--%>

                <%--        if ($.inArray(ext, ['gif', 'png', 'jpg', 'jpeg']) == -1) {--%>
                <%--            Dmall.LayerUtil.alert('이미지 파일이 아닙니다. (gif, png, jpg, jpeg 만 업로드 가능)');--%>
                <%--            return;--%>
                <%--        } else {--%>
                <%--            jQuery.when(Dmall.FileUpload.upload('bottomLogoUploadForm')).then(function (result) {--%>
                <%--                var file = result.files[0] || null;--%>
                <%--                if (file) {--%>
                <%--                    if (file) {--%>
                <%--                        var imgSrc = '<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>';--%>
                <%--                        jQuery('#div_bottom_logo_download').html(imgSrc);--%>
                <%--                        jQuery('#sp_img_bottom_logo').html(imgSrc);--%>

                <%--                        $('#hid_bottom_logo_filepath').val(file.filePath);--%>
                <%--                        $('#hid_bottom_logo_filename').val(file.fileName);--%>
                <%--                    }--%>
                <%--                }--%>
                <%--            });--%>
                <%--        }--%>
                <%--    }--%>
                <%--});--%>


                <%--// 조회 버튼 이벤트 처리--%>
                <%--jQuery('#a_id_search').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>

                <%--    Dmall.AjaxUtil.getJSON('/admin/example/load-editor', {}, function (result) {--%>
                <%--        //--%>
                <%--        jQuery('input[name="name"]').val(result.data.name);--%>

                <%--        Dmall.DaumEditor.setContent('ta_company_info', result.data.content); // 에디터에 데이터 세팅--%>
                <%--        Dmall.DaumEditor.setAttachedImage('ta_company_info', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅--%>
                <%--    })--%>
                <%--});--%>
                <%--// 초기화 버튼 이벤트 처리--%>
                <%--jQuery('#a_id_clear').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    Dmall.DaumEditor.clearContent('ta_company_info');  // 에디터 데이터 클리어--%>
                <%--});--%>

                <%--// 파일업로드 확인 이벤트 처리--%>
                <%--jQuery('#btn_confirm_file_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    $('#btn_close_file_upload').trigger('click');--%>
                <%--});--%>

                <%--// 로고업로드 확인 이벤트 처리--%>
                <%--jQuery('#btn_confirm_logo_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    $('#btn_close_logo_upload').trigger('click');--%>
                <%--});--%>

                <%--// 하단 로고업로드 확인 이벤트 처리--%>
                <%--jQuery('#btn_confirm_bottom_logo_upload').off("click").on('click', function (e) {--%>
                <%--    Dmall.EventUtil.stopAnchorAction(e);--%>
                <%--    $('#btn_close_bottom_logo_upload').trigger('click');--%>
                <%--});--%>

                <%--// 다음에디터 로딩--%>
                <%--fn_loadEditor();--%>
            });

            // 기본관리 데이터 조회
            function fn_getSiteInfo() {
                var url = '/admin/setup/siteinfo/site-info-detail',
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, {}, function (result) {
                    if (result == null || result.success != true) {
                        return;
                    } else {
                        var siteInfo = result.data;

                        // jQuery('#div_id_download').html('</BR>');
                        // $('#file_favicon, #hid_filepath, #hid_filename').val('');

                        setResult(siteInfo);
                    }

                    dfd.resolve(result.data);
                });
                return dfd.promise();
            }

            // 데이터 결과 세팅
            function setResult(siteInfo) {
                $('[data-find="site_info"]').DataBinder(siteInfo);

                // 추가 도메인 처리
                // var addDomainHtml = ''
                //     , idx = 0;
                // if ('addDomain1' in siteInfo && siteInfo['addDomain1']) {
                //     addDomainHtml += '<tr><th>쇼핑몰 추가도메인' + (++idx) + '</th><td>http://<span class="intxt long"><input type="text" name="addDomain1" id="txt_adddomain1" value=' + siteInfo['addDomain1'] + ' readonly data-validation-engine="validate[maxSize[50]]"></span></td></tr>';
                // }
                // if ('addDomain2' in siteInfo && siteInfo['addDomain2']) {
                //     addDomainHtml += '<tr><th>쇼핑몰 추가도메인' + (++idx) + '</th><td>http://<span class="intxt long"><input type="text" name="addDomain2" id="txt_adddomain2" value=' + siteInfo['addDomain2'] + ' readonly data-validation-engine="validate[maxSize[50]]"></span></td></tr>';
                // }
                // if ('addDomain3' in siteInfo && siteInfo['addDomain3']) {
                //     addDomainHtml += '<tr><th>쇼핑몰 추가도메인' + (++idx) + '</th><td>http://<span class="intxt long"><input type="text" name="addDomain3" id="txt_adddomain3" value=' + siteInfo['addDomain3'] + ' readonly data-validation-engine="validate[maxSize[50]]"></span></td></tr>';
                // }
                // if ('addDomain4' in siteInfo && siteInfo['addDomain4']) {
                //     addDomainHtml += '<tr><th>쇼핑몰 추가도메인' + (++idx) + '</th><td>http://<span class="intxt long"><input type="text" name="addDomain4" id="txt_adddomain4" value=' + siteInfo['addDomain4'] + ' readonly data-validation-engine="validate[maxSize[50]]"></span></td></tr>';
                // }
                // if ('' !== addDomainHtml) {
                //     $('#tbody_site_domain').append(addDomainHtml);
                // }
                // // 사이트 상세 설명 코드값은 고정
                // $('#hid_siteInfoCd').val('01');
            }

            // 관리자 이메일 DataBinder 함수
            function setMailDomain(data, obj, bindName, target, area, row) {
                var mailDomain = data["mailDomain"];
                if (mailDomain) {
                    var label = $("option[value='" + mailDomain + "']", obj).attr("selected", true).text();
                    obj.siblings('label').text(label);

                    if (!label || label.trim().length < 1) {
                        var label = $('option:first', obj).attr('selected', true).text();
                        obj.siblings('label').text(label);
                    }
                } else {
                    var label = $('option:first', obj).attr('selected', true).text();
                    obj.siblings('label').text(label);
                }
            }

            // 고객센터 이메일 DataBinder 함수
            function setCsMailDomain(data, obj, bindName, target, area, row) {
                var mailDomain = data["custCtDomain"];
                if(mailDomain) {
                    var label = $("option[value='" + mailDomain + "']", obj).attr("selected", true).text();
                    obj.siblings('label').text(label);

                    if (!label || label.trim().length < 1) {
                        var label = $('option:first', obj).attr('selected', true).text();
                        obj.siblings('label').text(label);
                    }
                } else {
                    var label = $('option:first', obj).attr('selected', true).text();
                    obj.siblings('label').text(label);
                }
            }

            // 사업장주소 주소선택 콜백
            function setZipcode(data) {
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#txt_company_postno').val(data.zonecode); //5자리 새우편번호 사용
                if(data.jibunAddress || data.autoJibunAddress) {
                    $('#txt_company_addr1').val(data.jibunAddress || data.autoJibunAddress);
                }
                $('#txt_company_addr2').val(data.roadAddress);
                $('#txt_company_addrdtl').val('').focus();
            }

            // 반품지주소 주소선택 콜백
            function setRetZipcode(data) {
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#txt_return_postno').val(data.zonecode); //5자리 새우편번호 사용
                if(data.jibunAddress || data.autoJibunAddress) {
                    $('#txt_return_addr1').val(data.jibunAddress || data.autoJibunAddress);
                }
                $('#txt_return_addr2').val(data.roadAddress);
                $('#txt_return_addrdtl').val('').focus();
            }

            // input 파라미터 설정
            function fn_setFormInputParam() {
                $('#hid_email').val($('#txt_mail_account').val() + '@' + $('#txt_mail_domain').val());
                // $('#hid_telno').val( $('#txt_telno').val().replaceAll("-", ""));
                // $('#hid_faxno').val( $('#txt_faxno').val().replaceAll("-", ""));
                // $('#hid_cust_oper_tel').val( $('#txt_cust_oper_tel').val().replaceAll("-", ""));
                // $('#hid_cust_oper_fax').val( $('#txt_cust_oper_fax').val().replaceAll("-", ""));
                // $('#hid_telno').val( $('#txt_telno').val().trim());
                $('#hid_faxno').val($('#txt_faxno').val().trim());
                $('#hid_cust_oper_tel').val($('#txt_cust_oper_tel').val().trim());
                $('#hid_cust_oper_fax').val($('#txt_cust_oper_fax').val().trim());
                $('#hid_cust_oper_email').val($('#txt_cust_oper_account').val() + '@' + $('#txt_cust_oper_domain').val());
                $('#hid_commno').val($('#txt_commno').val().replaceAll("-", ""));
                $('#hid_bizno').val($('#txt_biz_no').val().trim());

                // 에디터에서 폼으로 데이터 세팅
                // Dmall.DaumEditor.setValueToTextarea('ta_company_info');

            }





            <%--function uploadTempImg() {--%>
            <%--    $('#tempImg').load(function () {--%>
            <%--        if (this.naturalWidth > 32 || this.naturalHeight > 32) {--%>
            <%--            Dmall.LayerUtil.alert('파비콘 이미지 사이즈는 16 * 16 입니다. 이미지 사이즈를 확인해 주세요');--%>
            <%--            return;--%>
            <%--        } else {--%>
            <%--            jQuery.when(Dmall.FileUpload.upload('fileUploadForm')).then(function (result) {--%>
            <%--                var file = result.files[0] || null;--%>
            <%--                if (file) {--%>
            <%--                    // jQuery('#div_id_download').html('<a class="btn_red" href="/admin/common/common-download?' + jQuery.param(file) + '">파비콘 이미지가 업로드 되었습니다.</a>');--%>
            <%--                    var imgSrc = '<img src="${_IMAGE_DOMAIN}/image/image-view?type=TEMP&path=' + file.filePath + '&id1=' + file.fileName + '"/>';--%>
            <%--                    jQuery('#div_id_download, #sp_img_fvc').html(imgSrc);--%>
            <%--                    $('#hid_filepath').val(file.filePath);--%>
            <%--                    $('#hid_filename').val(file.fileName);--%>
            <%--                    // alert('파비콘 이미지가 업로드 되었습니다.');--%>
            <%--                }--%>
            <%--            });--%>
            <%--        }--%>
            <%--    });--%>
            <%--}--%>

            <%--function fn_loadEditor() {--%>
            <%--    Dmall.DaumEditor.init(); // 에디터 초기화 함수,--%>
            <%--    Dmall.DaumEditor.create('ta_company_info'); // ta_company_info 를 ID로 가지는 Textarea를 에디터로 설정--%>

            <%--    getCompanyInfo();--%>
            <%--}--%>

            <%--function fn_linkHomeCertify() {--%>
            <%--    Dmall.LayerUtil.alert('[미개발 기능] - 홈페이지 발신번호 인증 링크 URL 필요.');--%>
            <%--    return false;--%>
            <%--}--%>

            <%--function fn_linkHomeMypage() {--%>
            <%--    Dmall.LayerUtil.alert('[미개발 기능] - 홈페이지 마이페이지 링크 URL 필요.');--%>
            <%--    return false;--%>
            <%--}--%>

            <%--function getCompanyInfo() {--%>
            <%--    Dmall.AjaxUtil.getJSON('/admin/setup/siteinfo/site-info-html', {siteInfoCd: '01'}, function (result) {--%>
            <%--        //--%>
            <%--        // jQuery('input[name="name"]').val(result.data.name);--%>

            <%--        Dmall.DaumEditor.setContent('ta_company_info', result.data.content); // 에디터에 데이터 세팅--%>
            <%--        Dmall.DaumEditor.setAttachedImage('ta_company_info', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅--%>
            <%--    })--%>
            <%--}--%>

            <%--function setImage(data, obj, bindName, target, area, row) {--%>
            <%--    var key = obj.data('bind-value');--%>
            <%--    if (key in data && data[key]) {--%>
            <%--        obj.attr('src', data[key]);--%>
            <%--    }--%>
            <%--}--%>

            <%--function setLabelCheckbox(data, obj, bindName, target, area, row) {--%>
            <%--    var value = obj.data("bind-value")--%>
            <%--        , useYn = data[value]--%>
            <%--        , $label = jQuery(obj)--%>
            <%--        , $input = jQuery("#" + $label.attr("for"));--%>


            <%--    useYn = (useYn && ('Y' == useYn || '1' == useYn));--%>
            <%--    // 체크박스 값 설정--%>
            <%--    if (useYn) {--%>
            <%--        $label.addClass('on');--%>
            <%--        $input.data('value', 'Y').prop('checked', true);--%>
            <%--    } else {--%>
            <%--        $label.removeClass('on');--%>
            <%--        $input.data('value', 'N').prop('checked', false);--%>
            <%--    }--%>
            <%--}--%>
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    기본 설정<span class="step_bar"></span> 기본 관리<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">기본 정보</h2>
            </div>
            <form action="" id="form_site_info">
                <div class="line_box fri">
                    <!-- 사이트기본설정 -->
                    <h3 class="tlth3">사이트 기본 설정</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>사이트명 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt wid50p">
                                        <input type="text" name="siteNm" id="txt_site_nm"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="siteNm"
                                               maxlength="50"
                                               data-validation-engine="validate[required, maxSize[50]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>관리자 이메일 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt"><input type="text" name="mailAccount" id="txt_mail_account"
                                                               data-find="site_info"
                                                               data-bind-type="text"
                                                               data-bind-value="mailAccount"
                                                               maxlength="30"
                                                               data-validation-engine="validate[required, maxSize[30]]"></span>
                                    @
                                    <span class="intxt"><input type="text" name="mailDomain" id="txt_mail_domain"
                                                               data-find="site_info"
                                                               data-bind-type="text"
                                                               data-bind-value="mailDomain"
                                                               maxlength="30"
                                                               data-validation-engine="validate[required, maxSize[30]]"></span>
                                    <span class="select">
                                        <label for="sel_company_domain"></label>
                                        <select id="sel_company_domain"
                                                data-find="site_info"
                                                data-bind-value="mailDomain"
                                                data-bind-type="function"
                                                data-bind-function="setMailDomain">
                                            <option value="">직접입력</option>
                                            <tags:option codeStr="naver.com:naver.com;nate.com:nate.com;daum.net:daum.net;gmail.com:gmail.com;hotmail.com:hotmail.com"/>
                                        </select>
                                    </span>
                                    <input type="hidden" id="hid_email" name="email" value=""
                                           data-validation-engine="validate[required, custom[email]]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>기본검색어</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <input type="text" name="defaultSrchWord" id="txt_default_srch_word"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="defaultSrchWord"
                                               maxlength="50"
                                               data-validation-engine="validate[maxSize[50]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>자동로그아웃</th>
                                <td>
                                    <span class="select shot">
                                        <label for="sel_auto_logout"></label>
                                        <select name="autoLogoutTime" id="sel_auto_logout"
                                                data-find="site_info"
                                                data-bind-type="labelselect"
                                                data-bind-value="autoLogoutTime">
                                            <tags:option codeStr="0:설정안함;10:10;30:30;60:60;120:120;360:360"/>
                                        </select>
                                    </span>
                                    분 동안 마우스 클릭이 없으면 로그아웃합니다. (“설정안함”일 경우 자동 로그아웃 되지 않음)
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 사업자정보 -->
                    <h3 class="tlth3">사업자 정보</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>회사(상호)명 <span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt wid50p">
                                        <input type="text" name="companyNm" id="txt_company_nm"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="companyNm"
                                               maxlength="50"
                                               data-validation-engine="validate[required, maxSize[50]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>업태</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="bsnsCdts" id="txt_bsnscdts"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="bsnsCdts"
                                               maxlength="50"
                                               data-validation-engine="validate[maxSize[50]]">
                                    </span>
                                </td>
                                <th>종목</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="item" id="txt_item"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="item"
                                               maxlength="50"
                                               data-validation-engine="validate[maxSize[50]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>사업장 주소 <span class="important">*</span><br><br>상세주소</th>
                                <td colspan="3">
                                    <div class="addr_field">
                                        <span class="intxt shot2">
                                            <input type="text" name="postNo" id="txt_company_postno" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="postNo"
                                                   data-validation-engine="validate[required, maxSize[8]]">
                                        </span>
                                        <span class="intxt widaddrp">
                                            <input name="addrNum" id="txt_company_addr1" type="hidden" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="addrNum"
                                                   data-validation-engine="validate[maxSize[50]]">
                                            <input name="addrRoadnm" id="txt_company_addr2" type="text" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="addrRoadnm"
                                                   data-validation-engine="validate[maxSize[50]]">
                                        </span>
                                        <a href="#none" class="btn--black_small" id="btn_post">주소선택</a>
                                        <span class="br"></span>
                                        <span class="intxt wid50p">
                                            <input name="addrCmnDtl" id="txt_company_addrdtl" type="text" maxlength="50"
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="addrCmnDtl"
                                                   data-validation-engine="validate[required, maxSize[50]]">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>사업자 번호</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="tempBizNo" id="txt_biz_no" maxlength="12"
                                               data-find="site_info"
                                               data-bind-type="bizno"
                                               data-bind-value="bizNo"
                                               data-validation-engine="validate[maxSize[12]]">
                                    </span>
                                    <input type="hidden" id="hid_bizno" name="bizNo" value="" maxlength="12"
                                           data-validation-engine="validate[maxSize[12]]"/>
                                </td>
                                <th>통신판매신고번호</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="tempCommSaleRegistNo" id="txt_commno" maxlength="50"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="commSaleRegistNo"
                                               data-validation-engine="validate[maxSize[20]]">
                                    </span>
                                    <input type="hidden" id="hid_commno" name="commSaleRegistNo" value="" maxlength="20"
                                           data-validation-engine="validate[maxSize[20]]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>대표자명 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="ceoNm" id="txt_ceonm" maxlength="50"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="ceoNm"
                                               data-validation-engine="validate[required, maxSize[50]]">
                                    </span>
                                </td>
                                <th>개인정보책임관리자 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" name="privacymanager" id="txt_privmanager" maxlength="50"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="privacymanager"
                                               data-validation-engine="validate[required, maxSize[50]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>전화번호 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" class="phoneNumber" name="certifySendNo"
                                               id="txt_certifySendNo" maxlength="14"
                                               data-find="site_info"
                                               data-bind-type="tel"
                                               data-bind-value="certifySendNo">
                                    </span>
                                </td>
                                <th>팩스번호</th>
                                <td>
                                    <span class="intxt wid100p">
                                        <input type="text" class="phoneNumber" name="tempFaxNo" id="txt_faxno"
                                               maxlength="14"
                                               data-find="site_info"
                                               data-bind-type="fax"
                                               data-bind-value="faxNo">
                                    </span>
                                    <input type="hidden" id="hid_faxno" name="faxNo" value=""
                                           data-validation-engine="validate[maxSize[14]]"/>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 고객센터정보 -->
                    <h3 class="tlth3">고객센터 정보</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>전화번호</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <textarea name="tempCustCtTelNo"
                                               id="txt_cust_oper_tel"
                                               maxlength="100"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtTelNo" style="width:590px;height:58px;padding: 10px 10px"></textarea>
                                    </span>
                                    <input type="hidden" id="hid_cust_oper_tel" name="custCtTelNo" value=""
                                           data-validation-engine="validate[maxSize[30]]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>팩스번호</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <input type="text" class="phoneNumber" name="tempCustCtFaxNo"
                                               id="txt_cust_oper_fax"
                                               maxlength="14"
                                               data-find="site_info"
                                               data-bind-type="fax"
                                               data-bind-value="custCtFaxNo">
                                    </span>
                                    <input type="hidden" id="hid_cust_oper_fax" name="custCtFaxNo" value=""
                                           data-validation-engine="validate[maxSize[14]]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>이메일주소<span class="important">*</span></th>
                                <td>
                                    <span class="intxt">
                                        <input type="text" name="custCtAccount" id="txt_cust_oper_account"
                                               maxlength="30"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtAccount"
                                               data-validation-engine="validate[required, maxSize[30]]">
                                    </span>
                                    @
                                    <span class="intxt">
                                        <input type="text" name="custCtDomain" id="txt_cust_oper_domain"
                                               maxlength="30"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtDomain"
                                               data-validation-engine="validate[required, maxSize[30]]">
                                    </span>
                                    <span class="select">
                                        <label for="sel_cs_domain"></label>
                                        <select id="sel_cs_domain"
                                                data-find="site_info"
                                                data-bind-value="custCtDomain"
                                                data-bind-type="function"
                                                data-bind-function="setCsMailDomain">
                                            <option value="">직접입력</option>
                                            <tags:option codeStr="naver.com:naver.com;nate.com:nate.com;daum.net:daum.net;gmail.com:gmail.com;hotmail.com:hotmail.com"/>
                                        </select>
                                    </span>
                                    <input type="hidden" id="hid_cust_oper_email" name="custCtEmail" value=""
                                           data-validation-engine="validate[required, custom[email]]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>운영시간</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <input type="text" name="custCtOperTime" id="txt_cust_oper_time"
                                               maxlength="100"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtOperTime">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>점심시간</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <textarea name="custCtLunchTime" id="txt_cust_lunch_time"
                                               maxlength="100"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtLunchTime" style="width:590px;height:58px;padding: 10px 10px"></textarea>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>휴무일</th>
                                <td>
                                    <span class="intxt wid50p">
                                        <input type="text" name="custCtClosedInfo" id="txt_cust_closed_info"
                                               maxlength="100"
                                               data-find="site_info"
                                               data-bind-type="text"
                                               data-bind-value="custCtClosedInfo">
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 반품주소지설정 -->
                    <h3 class="tlth3">반품 주소지 설정</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>주소<br><br>상세주소</th>
                                <td>
                                    <div class="addr_field">
                                        <span class="intxt shot2">
                                            <input type="text" name="retadrssPost" id="txt_return_postno" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="retadrssPost"
                                                   data-validation-engine="validate[maxSize[8]]">
                                        </span>
                                        <span class="intxt widaddrp">
                                            <input name="retadrssAddrNum" id="txt_return_addr1" type="hidden" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="retadrssAddrNum"
                                                   data-validation-engine="validate[maxSize[50]]">
                                            <input name="retadrssAddrRoadnm" id="txt_return_addr2" type="text" readonly
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="retadrssAddrRoadnm"
                                                   data-validation-engine="validate[maxSize[50]]">
                                        </span>
                                        <a href="#none" class="btn--black_small" id="btn_return_post">주소선택</a>
                                        <span class="br"></span>
                                        <span class="intxt wid50p">
                                            <input name="retadrssAddrDtl" id="txt_return_addrdtl" type="text"
                                                   maxlength="50"
                                                   data-find="site_info"
                                                   data-bind-type="text"
                                                   data-bind-value="retadrssAddrDtl"
                                                   data-validation-engine="validate[maxSize[50]]">
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 장바구니기본설정 -->
                    <h3 class="tlth3">장바구니 기본 설정</h3>
                    <div class="tblw tblmany">
                        <table>
                            <colgroup>
                                <col width="160px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>상품 보관 기간</th>
                                <td>
                                    <span class="basket_info_txt">고객이 삭제 시 까지 보관</span>
                                </td>
                            </tr>
                            <tr>
                                <th>품절 상품 보관</th>
                                <td>
                                    <span class="bbasket_info_txt">품절 시 보관</span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 보관 개수</th>
                                <td>
                                    <span class="basket_info_txt">최대 50개 보관 가능 </span>
                                    <span class="desc_txt">&nbsp;&nbsp;*50개가 초과할 경우 담은 순서가 오래된 상품순으로 삭제</span>
                                </td>
                            </tr>
                            <tr>
                                <th rowspan="2">장바구니 담기 후<br>페이지 이동</th>
                                <td rowspan="2">
                                    <span class="basket_info_txt">장바구니 페이지 이동 여부 선택창</span>
                                    <span class="desc_txt">&nbsp;&nbsp;*바로이동하지 않음</span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_regist">저장하기</button>
            </div>
        </div>
        <!-- //bottom_box -->
    </t:putAttribute>
</t:insertDefinition>