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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<t:insertDefinition name="sellerDefaultLayout">
    <t:putAttribute name="title">판매자 관리 > 기본</t:putAttribute>
    <t:putAttribute name="style">
        <style>
            span.fileName {
                cursor: pointer;
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
        <%-- 주소 스크립트 --%>
        <script>
            $(document).ready(function() {
                // 주소 우편번호 버튼 클릭
                $('#a_id_post').on('click', function() {
                    Dmall.LayerPopupUtil.zipcode(setZipcode);
                });

                // 반품지 우편번호 버튼 클릭
                $('#b_id_post').on('click', function() {
                    Dmall.LayerPopupUtil.zipcode(ret_setZipcode);
                });
            });

            // 주소 우편번호 팝업 콜백
            function setZipcode(data) {
                $('#postNo').val(data.zonecode);
                if(data.jibunAddress || data.roadAddress) {
                    $('#addr').val(data.jibunAddress || data.roadAddress);
                }
                $('#addrDtl').val('').focus();
            }

            // 반품 우편번호 팝업 콜백
            function ret_setZipcode(data) {
                $('#retadrssPostNo').val(data.zonecode);
                if(data.jibunAddress || data.roadAddress) {
                    $('#retadrssAddr').val(data.jibunAddress || data.roadAddress);
                }
                $('#retadrssDtlAddr').val('').focus();
            }
        </script>
        <%-- 각종 이메일 select 스크립트 --%>
        <script>
            $(document).ready(function() {
                // 이메일 select 변경 이벤트
                $('#email03').change(function() {
                    var hostName = $(this).val();
                    if(hostName == 'etc') {
                        $('#email02').attr('readonly', false);
                        $('#email02').val('');
                        $('#email02').focus();
                    } else {
                        $('#email02').attr('readonly', true);
                        $('#email02').val(hostName);
                    }
                })

                // 세금계산서 수신메일 select 변경 이벤트
                $('#taxbillRecvMail03').change(function() {
                    var hostName = $(this).val();
                    if(hostName == 'etc') {
                        $('#taxbillRecvMail02').attr('readonly', false);
                        $('#taxbillRecvMail02').val('');
                        $('#taxbillRecvMail02').focus();
                    } else {
                        $('#taxbillRecvMail02').attr('readonly', true);
                        $('#taxbillRecvMail02').val(hostName);
                    }
                });

                // 담당자 이메일 select 변경 이벤트
                $('#managerEmail03').change(function() {
                    var hostName = $(this).val();
                    if(hostName == 'etc') {
                        $('#managerEmail02').attr('readonly', false);
                        $('#managerEmail02').val('');
                        $('#managerEmail02').focus();
                    } else {
                        $('#managerEmail02').attr('readonly', true);
                        $('#managerEmail02').val(hostName);
                    }
                });

                // 이메일 input 바인딩
                var email = '${resultModel.data.email}';
                var emailSplit = email.split('@');
                $('#email01').val(emailSplit[0]);
                $('#email02').val(emailSplit[1]);
                if($('#email03').children().is('option[value="' + emailSplit[1] + '"]')) {
                    $('#email03').val(emailSplit[1]);
                    $('#email02').val(emailSplit[1]);
                    $('#email02').attr('readonly', true);
                } else {
                    $('#email03').val('etc');
                    $('#email02').val(emailSplit[1]);
                }

                // 세금계산서 수신메일 input 바인딩
                var taxMail = '${resultModel.data.taxbillRecvMail}';
                var taxMailSplit = taxMail.split('@');
                $('#taxbillRecvMail01').val(taxMailSplit[0]);
                if($('#taxbillRecvMail03').children().is('option[value="' + taxMailSplit[1] + '"]')) {
                    $('#taxbillRecvMail03').val(taxMailSplit[1]);
                    $('#taxbillRecvMail02').val(taxMailSplit[1]);
                    $('#taxbillRecvMail02').attr('readonly', true);
                } else {
                    $('#taxbillRecvMail03').val('etc');
                    $('#taxbillRecvMail02').val(taxMailSplit[1]);
                }

                // 담당자 이메일 input 바인딩
                var mgrMail = '${resultModel.data.managerEmail}';
                var mgrMailSplit = mgrMail.split('@');
                $('#managerEmail01').val(mgrMailSplit[0]);
                $('#managerEmail02').val(mgrMailSplit[1]);
                if($('#managerEmail03').children().is('option[value="' + mgrMailSplit[1] + '"]')) {
                    $('#managerEmail03').val(mgrMailSplit[1]);
                    $('#managerEmail02').val(mgrMailSplit[1]);
                    $('#managerEmail02').attr('readonly', true);
                } else {
                    $('#managerEmail03').val('etc');
                    $('#managerEmail02').val(mgrMailSplit[1]);
                }
            });
        </script>
        <%-- 중복확인 스크립트 --%>
        <script>
            var orgSellerId = '';
            $(document).ready(function() {
                orgSellerId = $('#sellerId').val();

                // id input event
                $('#sellerId').on('input', function () {
                    if(orgSellerId && orgSellerId == $(this).val()) {
                        $('#chkSellerId').val(true);

                        var $spanSellerId = $('#span_sellerId');
                        $spanSellerId.removeClass('point_c6').removeClass('point_c3');
                        $spanSellerId.text('');
                    } else {
                        $('#chkSellerId').val(false);

                        var $spanSellerId = $('#span_sellerId');
                        $spanSellerId.removeClass('point_c6').removeClass('point_c3');
                        $spanSellerId.addClass('point_c6');
                        $spanSellerId.text('중복확인이 필요합니다.');
                    }
                });

                // 중복확인 버튼 클릭
                $('#btn_id_check').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var loginId = $('#sellerId').val();
                    if(idValidation(loginId)) {
                        var url = '/admin/seller/duplication-id-check';
                        var param = { sellerId : loginId };
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {
                            var $spanSellerId = $('#span_sellerId');
                            if(result.success) {
                                $('#chkSellerId').val(true);
                                $spanSellerId.removeClass('point_c6').removeClass('point_c3');
                                $spanSellerId.addClass('point_c3');
                                $spanSellerId.text('사용 가능한 아이디입니다.');
                            } else {
                                $('#chkSellerId').val(false);
                                $spanSellerId.removeClass('point_c6').removeClass('point_c3');
                                $spanSellerId.addClass('point_c6');
                                $spanSellerId.text('사용할 수 없는 아이디입니다.');
                            }
                        });
                    }
                });
            });

            function idValidation(val) {
                if(Dmall.validation.isEmpty(val)) {
                    Dmall.LayerUtil.alert('아이디를 입력해주세요.');
                    return false;
                }
                var spc = "!#$%&*+-./=?@^` {|}";
                for(var i=0; i < val.length; i++) {
                    if (spc.indexOf(val.substring(i, i+1)) >= 0) {
                        Dmall.LayerUtil.alert("특수문자나 공백을 입력할 수 없습니다.", "확인");
                        return false;
                    }
                }
                if (val.length < 5 || val.length > 20){
                    Dmall.LayerUtil.alert("아이디는 5~20자입니다.", "확인");
                    return false;
                }
                var hanExp = val.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
                if( hanExp > -1 ){
                    Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
                    return false;
                }
                return true;
            }
        </script>
        <%-- 파일첨부 스크립트 --%>
        <script>
            $(document).ready(function() {
                $('input[type=file]').change(function(e) {
                    var inputId = $(this).attr('id');
                    var ext = $(this).val().split('.').pop().toLowerCase();
                    switch (inputId) {
                        case 'input_id_files1':
                            if($.inArray(ext, ['jpg','gif','pdf']) == -1) {
                                Dmall.LayerUtil.alert('jpg,gif,pdf 파일만 업로드 할 수 있습니다.', '알림');
                                $(this).val('');
                                $('#fileBoxsNm1').val('');
                            } else {
                                if($('#bizFileInert').children().is('button')) {
                                    $('#' + inputId).val('');
                                    $('#fileBoxsNm1').val('');
                                    Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                                } else {
                                    $('#fileBoxsNm1').val(e.target.files[0].name);
                                }
                            }
                            break;
                        case 'input_id_files2':
                            if($.inArray(ext, ['jpg','gif','pdf']) == -1) {
                                Dmall.LayerUtil.alert('jpg,gif,pdf 파일만 업로드 할 수 있습니다.', '알림');
                                $(this).val('');
                                $('#fileBoxsNm2').val('');
                            } else {
                                if($('#bkFileInert').children().is('button')) {
                                    $('#' + inputId).val('');
                                    $('#fileBoxsNm2').val('');
                                    Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                                } else {
                                    $('#fileBoxsNm2').val(e.target.files[0].name);
                                }
                            }
                            break;
                        case 'input_id_files3':
                            if($.inArray(ext, ['jpg','gif','pdf']) == -1) {
                                Dmall.LayerUtil.alert('jpg,gif,pdf 파일만 업로드 할 수 있습니다.', '알림');
                                $(this).val('');
                                $('#fileBoxsNm3').val('');
                            } else {
                                if($('#etcFileInert').children().is('button')) {
                                    $('#' + inputId).val('');
                                    $('#fileBoxsNm3').val('');
                                    Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                                } else {
                                    $('#fileBoxsNm3').val(e.target.files[0].name);
                                }
                            }
                            break;
                        case 'input_id_files5':
                            if($.inArray(ext, ['zip']) > 0) {
                                Dmall.LayerUtil.alert('zip 파일은 업로드 할 수 없습니다.', '알림');
                                $(this).val('');
                                $('#fileBoxsNm5').val('');
                            } else {
                                if($('#refFileInert').children().is('button')) {
                                    $('#' + inputId).val('');
                                    $('#fileBoxsNm5').val('');
                                    Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                                } else {
                                    $('#fileBoxsNm5').val(e.target.files[0].name);
                                }
                            }
                            break;
                    }
                });

                fn_file_set();

                $('span.fileName').on('click', function () {
                    var url = '/admin/seller/download';
                    var param = { sellerNo: $('#sellerNo').val(), fileGbn: $(this).data('file-gbn') };

                    Dmall.FormUtil.submit(url, param, '_blank');
                });
            });

            function fn_file_set() {
                var bizOrgFileNm = "${resultModel.data.bizOrgFileNm}";

                if (bizOrgFileNm != null && bizOrgFileNm != "") {
                    var bizFile =
                        '<span class="fileName" data-file-gbn="biz">'+bizOrgFileNm+'</span>'+
                        '<button class="btn_del btn_comm" onclick= "return delFileNm(1)" ></button>';
                    $("#bizFileInert").html(bizFile);
                }

                var bkCopyOrgFileNm = "${resultModel.data.bkCopyOrgFileNm}";

                if (bkCopyOrgFileNm != null && bkCopyOrgFileNm != "") {
                    var bkCopyFile =
                        '<span class="fileName" data-file-gbn="bk">'+bkCopyOrgFileNm+'</span>'+
                        '<button class="btn_del btn_comm" onclick= "return delFileNm(2)" ></button>';
                    $("#bkFileInert").html(bkCopyFile);
                }

                var etcOrgFileNm = "${resultModel.data.etcOrgFileNm}";

                if (etcOrgFileNm != null && etcOrgFileNm != "") {
                    var etcFile =
                        '<span class="fileName" data-file-gbn="etc">'+etcOrgFileNm+'</span>'+
                        '<button class="btn_del btn_comm" onclick= "return delFileNm(3)" ></button>';
                    $("#etcFileInert").html(etcFile);
                }

                var refOrgFileNm = "${resultModel.data.refOrgFileNm}";

                if (refOrgFileNm != null && refOrgFileNm != "") {
                    var refFile =
                        '<span class="fileName" data-file-gbn="ref">'+refOrgFileNm+'</span>'+
                        '<button class="btn_del btn_comm" onclick= "return delFileNm(5)" ></button>';
                    $("#refFileInert").html(refFile);
                }
            }

            function delFileNm(fileGbn){
                var url = '/admin/seller/setup/attach-file-delete';

                var param = {};
                param.sellerNo = $('#sellerNo').val();

                if (fileGbn == "1") fileGbn = "biz";
                if (fileGbn == "2") fileGbn = "bk";
                if (fileGbn == "3") fileGbn = "etc";
                if (fileGbn == "5") fileGbn = "ref";

                param.fileGbn = fileGbn;

                Dmall.LayerUtil.confirm('삭제된 이미지는 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $("#" + fileGbn + "FileInert").html("");
                    });
                });
                return false;
            }
        </script>
        <%-- 기능 스크립트 --%>
        <script>
            $(document).ready(function() {
                // 포인트 지급 radio 변경 이벤트
                // $('input[name=sellerSvmnGbCd]').change(function() {
                //     var selVal = $(this).val();
                //
                //     if(selVal == '1'){
                //         $('#dcValueSpan').text('%');
                //     }else{
                //         $('#dcValueSpan').text('원');
                //     }
                // });

                $('input[name=sellerSvmnGbCd]').closest('label').on('click', function (e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                });

                // 수정/승인요청 버튼 클릭
                $('#btn_update, #btn_approve').on('click', function() {
                    if(!checkValidation()) {
                        return false;
                    }

                    // svmn 관련 input value 검증
                    checkInputValue('sellerCmsRate');
                    checkInputValue('sellerSvmnAmt');
                    checkInputValue('sellerSvmnMaxUseRate');
                    checkInputValue('svmnLoadrate');

                    // 이메일 세팅
                    if($('#email01').val().length > 0 && $('#email02').val().length > 0) {
                        $('#email').val($('#email01').val() + '@' + $('#email02').val());
                    }
                    if($('#taxbillRecvMail01').val().length > 0 && $('#taxbillRecvMail02').val().length > 0) {
                        $('#taxbillRecvMail').val($('#taxbillRecvMail01').val() + '@' + $('#taxbillRecvMail02').val());
                    }
                    if($('#managerEmail01').val().length > 0 && $('#managerEmail02').val().length > 0) {
                        $('#managerEmail').val($('#managerEmail01').val() + '@' + $('#managerEmail02').val());
                    }

                    if(Dmall.FileUpload.checkFileSize('form_id_sellerDtl')) {
                        var msg = '';
                        if($('#aprvYn').val() == 'Y') {
                            msg = '수정하시겠습니까?';
                        } else {
                            msg = '승인요청하시겠습니까?';
                        }
                        Dmall.LayerUtil.confirm(msg, function() {
                            var url = '/admin/seller/setup/seller-info-save';

                            $('#form_id_sellerDtl').ajaxSubmit({
                                url: url,
                                dataType: 'json',
                                success: function(result) {
                                    Dmall.validate.viewExceptionMessage(result, 'form_id_sellerDtl');
                                    if(result.success) {
                                        if(result.message.includes('로그아웃')) {
                                            Dmall.LayerUtil.alert(result.message).done(function() {
                                                Dmall.FormUtil.submit('/admin/login/logout');
                                            });
                                        } else {
                                            Dmall.LayerUtil.alert(result.message).done(function() {
                                                Dmall.FormUtil.submit('/admin/seller/setup/seller-detail');
                                            });
                                        }
                                    } else {
                                        Dmall.LayerUtil.alert(result.message);
                                    }
                                }
                            })
                        });
                    }
                });

                // 판매자 소개 textarea 바인딩
                $('textarea[name=farmIntro]').text('${resultModel.data.farmIntro}');

                // 비밀번호 change event
                $('#pw').on('change', function () {
                    var $spanPw = $('#span_pw');
                    var pwVal = $(this).val();

                    if (pwVal.length < 8 || pwVal.length > 16){
                        $spanPw.removeClass('point_c6').addClass('point_c6').text('비밀번호가 너무 짧거나 깁니다.');
                        return;
                    }
                    if (/ㄱ-ㅎ가-힣/.test(pwVal)) {
                        $spanPw.removeClass('point_c6').addClass('point_c6').text('비밀번호에 한글을 사용할 수 없습니다.');
                        return;
                    }
                    if(/(\w)\1\1/.test(pwVal)){
                        $spanPw.removeClass('point_c6').addClass('point_c6').text('비밀번호에 동일한 문자를 3번 연속하여 사용하실 수 없습니다.');
                        return;
                    }
                    if (pwVal.indexOf($('#sellerId').val()) > -1) {
                        $spanPw.removeClass('point_c6').addClass('point_c6').text('ID가 포함된 비밀번호는 사용하실 수 없습니다.');
                        return;
                    }
                    var num = pwVal.search(/[0-9]/g);
                    var eng = pwVal.search(/[a-z]/ig);
                    var spc = pwVal.search(/[!@#$%^&*]/ig);
                    if ((num < 0 && eng < 0) || (eng < 0 && spc < 0) || (spc < 0 && num < 0)) {
                        $spanPw.removeClass('point_c6').addClass('point_c6').text('비밀번호 형식이 잘못되었습니다. 영문/숫자/특수문자 2가지 이상 조합하여 주세요.');
                        return;
                    }

                    $spanPw.removeClass('point_c6').removeClass('point_c3').addClass('point_c3').text('사용할 수 있는 비밀번호입니다.');
                });

                $('#pwChk').on('change', function () {
                    var $spanPwChk = $('#span_pwChk');
                    var pwVal = $('#pw').val();
                    var pwChkVal = $('#pwChk').val();

                    if(pwVal != pwChkVal) {
                        $spanPwChk.removeClass('point_c6').addClass('point_c6').text('비밀번호가 일치하지 않습니다.');
                    } else {
                        $spanPwChk.removeClass('point_c6').addClass('point_c3').text('비밀번호가 일치합니다.');
                    }
                });
            });

            //전화번호 형식 체크 및 자동 하이픈 넣기
            function chk_tel(str, field){
                var value = str.replace(/[^0-9]/g, '').replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, '$1-$2-$3');
                field.value = value;
            }

            // svmn 관련 input default value 설정
            function checkInputValue(id) {
                var obj = $('#'+ id);
                if(obj.val() == null || obj.val() == undefined || obj.val().trim() == '') {
                    obj.val('0');
                    if(id == 'sellerSvmnAmt') {
                        $('input:radio[name=sellerSvmnGbCd][value="1"]').trigger('click');
                    }
                } else {
                    obj.val(obj.val().replaceAll(',', ''));
                }
            }

            // 모든 input의 유효성 검증
            function checkValidation() {
                // ID 입력 검증
                if(Dmall.validation.isEmpty($("#sellerId").val())) {
                    Dmall.LayerUtil.alert("판매자ID를 입력해주세요.", "알림");
                    return false;
                }

                if ($('#chkSellerId').val() == 'false') {
                    Dmall.LayerUtil.alert("판매자ID의 중복체크를 확인해주세요.", "알림");
                    return false;
                }
                // 비밀번호 검증
                if(!Dmall.validation.isEmpty($("#pw").val())) {
                    chkPw();
                }
                // 업체명 검증
                if(Dmall.validation.isEmpty($("#sellerNm").val())) {
                    Dmall.LayerUtil.alert("업체명을 입력해주세요.", "알림");
                    return false;
                }
                // 사업자등록번호 검증
                if(Dmall.validation.isEmpty($("#bizRegNo").val())) {
                    Dmall.LayerUtil.alert("사업자등록번호를 입력해주세요.", "알림");
                    return false;
                }
                // 업태 검증
                if(Dmall.validation.isEmpty($("#bsnsCdts").val())) {
                    Dmall.LayerUtil.alert("업태를 입력해주세요.", "알림");
                    return false;
                }
                // 종목 검증
                if(Dmall.validation.isEmpty($("#st").val())) {
                    Dmall.LayerUtil.alert("종목을 입력해주세요.", "알림");
                    return false;
                }
                // 이메일 검증
                if(Dmall.validation.isEmpty($("#email01").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }
                if(Dmall.validation.isEmpty($("#email02").val())) {
                    Dmall.LayerUtil.alert("이메일을 입력해주세요.", "알림");
                    return false;
                }
                // 우편번호 검증
                if(Dmall.validation.isEmpty($("#postNo").val())) {
                    Dmall.LayerUtil.alert("우편번호를 입력해주세요.", "알림");
                    return false;
                }
                // 주소 검증
                if(Dmall.validation.isEmpty($("#addr").val())) {
                    Dmall.LayerUtil.alert("주소를 입력해주세요.", "알림");
                    return false;
                }
                // 상세주소 검증
                if(Dmall.validation.isEmpty($("#addrDtl").val())) {
                    Dmall.LayerUtil.alert("상세주소를 입력해주세요.", "알림");
                    return false;
                }
                // 숫자 검증
                var sellerCmsRate = $('#sellerCmsRate').val();
                if(sellerCmsRate < 0 || sellerCmsRate > 100) {
                    $('#sellerCmsRate').val('');
                    Dmall.LayerUtil.alert('허용할 수 없는 범위입니다.<br/>입력필드 : 판매자 수수료율', '알림');
                    return false;
                }
                var sellerSvmnAmt = $('#sellerSvmnAmt').val();
                if(sellerSvmnAmt < 0 || sellerSvmnAmt > 100) {
                    $('#sellerSvmnAmt').val('');
                    Dmall.LayerUtil.alert('허용할 수 없는 범위입니다.<br/>입력필드 : 포인트 지급 설정', '알림');
                    return false;
                }
                var sellerSvmnMaxUseRate = $('#sellerSvmnMaxUseRate').val();
                if(sellerSvmnMaxUseRate < 0 || sellerSvmnMaxUseRate > 100) {
                    $('#sellerSvmnMaxUseRate').val('');
                    Dmall.LayerUtil.alert('허용할 수 없는 범위입니다.<br/>입력필드 : 포인트 사용 제한 설정', '알림');
                    return false;
                }
                var svmnLoadrate = $('#svmnLoadrate').val();
                if(svmnLoadrate < 0 || svmnLoadrate > 100) {
                    $('#svmnLoadrate').val('');
                    Dmall.LayerUtil.alert('허용할 수 없는 범위입니다.<br/>입력필드 : 포인트 사용 본사 부담율', '알림');
                    return false;
                }

                return true;
            }

            // 비밀번호 검사
            function chkPw() {
                var $obj = $('#pw');
                if( $obj.val() != $('#pwChk').val()){
                    Dmall.LayerUtil.alert("비밀번호가 일치하지 않습니다.", "알림");
                    return false;
                }
                if ($obj.val().length < 8 || $obj.val().length > 16){
                    Dmall.LayerUtil.alert("비밀번호가 너무 짧거나 깁니다.", "알림");
                    return false;
                }
                if (/ㄱ-ㅎ가-힣/.test($obj.val())) {
                    Dmall.LayerUtil.alert("비밀번호에 한글을 사용할 수 없습니다.", "알림");
                    return false;
                }
                if(/(\w)\1\1/.test($obj.val())){
                    Dmall.LayerUtil.alert("비밀번호에 동일한 문자를 3번 연속하여 사용하실 수 없습니다.", "알림");
                    return false;
                }
                if ($obj.val().indexOf($('#sellerId').val()) > -1) {
                    Dmall.LayerUtil.alert("ID가 포함된 비밀번호는 사용하실 수 없습니다.", "알림");
                    return false;
                }
                var num = $obj.val().search(/[0-9]/g);
                var eng = $obj.val().search(/[a-z]/ig);
                var spc = $obj.val().search(/[!@#$%^&*]/ig);
                if ((num < 0 && eng < 0) || (eng < 0 && spc < 0) || (spc < 0 && num < 0)) {
                    Dmall.LayerUtil.alert('비밀번호 형식이 잘못되었습니다.<br/>영문/숫자/특수문자 2가지 이상 조합하여 주세요.', '알림');
                    return false;
                }
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <c:set var="sellerDtl" value="${resultModel.data}"/>
            <form id="form_id_sellerDtl" method="post">
                <input type="hidden" name="email" id="email" value="${sellerDtl.email}">
                <input type="hidden" name="taxbillRecvMail" id="taxbillRecvMail" value="${sellerDtl.taxbillRecvMail}">
                <input type="hidden" name="managerEmail" id="managerEmail" value="${sellerDtl.managerEmail}">
                <input type="hidden" name="sellerNo" id="sellerNo" value="${sellerDtl.sellerNo}">
                <input type="hidden" name="chkSellerId" id="chkSellerId" value="true">
                <input type="hidden" name="inputGbn" id="inputGbn" value="UPDATE">

                <div class="tlt_box">
                    <div class="tlt_head">
                        기본 설정<span class="step_bar"></span>
                    </div>
                    <h2 class="tlth2">판매자 관리</h2>
                </div>
                <!-- line_box 판매자 관리 -->
                <div class="line_box fri marginB40">
                    <h3 class="tlth3 btn1">판매자 관리</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 기본정보 표 입니다. 구성은 이름/아이디, 실명확인, 성별, 생년월일, 이메일/수신여부, 핸드폰/수신여부, 전화번호, 주소 입니다.">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col width="180px">
                                <col width="">
                                <col width="180px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>판매자ID <span class="important">*</span></th>
                                <td colspan="3">
                                    <span class="intxt">
                                        <input type="text" name="sellerId" id="sellerId" value="${sellerDtl.sellerId}" data-validation-engine="validate[required, maxSize[20]]">
                                    </span>
                                    <button type="button" class="btn_gray popup_open" id="btn_id_check">중복확인</button>
                                    <span class="ml5" id="span_sellerId"></span>
                                    <br><span class="desc_txt ml5">· 영문, 숫자 사용가능하며, 5~20자 가능</span>
                                </td>
                            </tr>
                            <tr id="pwTr">
                                <th>비밀번호<br>(비밀번호 변경 시에만 입력하세요.)</th>
                                <td colspan="3">
									<span class="intxt">
										<input type="password" id="pw" name="pw" placeholder="비밀번호 입력">
									</span>
                                    <span class="ml5" id="span_pw"></span>
                                    <span class="br"></span>
                                    <span class="intxt">
										<input type="password" id="pwChk" placeholder="비밀번호 확인">
									</span>
                                    <span class="ml5" id="span_pwChk"></span>
                                    <span class="br"></span>
                                    <span class="point_c6 member_password">
										* 영문/숫자/특수문자 2가지 이상 조합하여 8~16자로 입력하세요. 아이디가 포함되거나 3번 연속되는 문자와 숫자는 불가합니다.
									</span>
                                </td>
                            </tr>
                            <tr>
                                <th>업체명 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="sellerNm" id="sellerNm" value="${sellerDtl.sellerNm}" data-validation-engine="validate[required, maxSize[30]]" maxlength="30">
                                    </span>
                                </td>
                                <th>사업자등록번호 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="bizRegNo" id="bizRegNo" maxlength="10" value="${sellerDtl.bizRegNo}" data-validation-engine="validate[required, maxSize[10]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>판매자 소개</th>
                                <td colspan="3">
                                    <c:set var="farm" value="${fn:replace(sellerDtl.farmIntro, br, cn)}"/>
                                    <textarea name="farmIntro" style="width:100%;height:80px; padding:5px;">${farm}</textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>판매자 수수료율</th>
                                <td colspan="3">
                                    <span class="intxt">
                                        <input type="number" name="sellerCmsRate" id="sellerCmsRate" value="${sellerDtl.sellerCmsRate}" disabled>
                                    </span>%
                                </td>
                            </tr>
                            <tr>
                                <th>포인트 지급 설정</th>
                                <td colspan="3">
                                    주문 금액의 ( <tags:radio codeStr="1:비율;2:금액;" name="sellerSvmnGbCd" idPrefix="sellerSvmnGbCd" value="${sellerDtl.sellerSvmnGbCd}"/>
                                    <label for="" class="intxt shot"><input type="number" name="sellerSvmnAmt" id="sellerSvmnAmt" value="${sellerDtl.sellerSvmnAmt}" class="comma" maxlength="10" disabled></label>
                                    <span id="dcValueSpan" class="marginL05">%</span>) 을(를) 구매 확정 시 지급
                                </td>
                            </tr>
                            <tr>
                                <th>포인트 사용 제한 설정</th>
                                <td colspan="3">
                                    주문 금액의
                                    <label for="sellerSvmnMaxUseRate" class="intxt shot">
                                        <input type="number" id="sellerSvmnMaxUseRate" name="sellerSvmnMaxUseRate" maxlength="4" value="${sellerDtl.sellerSvmnMaxUseRate}" disabled>
                                    </label> % 을(를) 까지 사용 가능
                            <tr>
                                <th>포인트 사용 본사부담율</th>
                                <td colspan="3">
                                    <label for="svmnLoadrate" class="mr5">
                                        <input type="number" id="svmnLoadrate" name="svmnLoadrate" maxlength="4" value="${sellerDtl.svmnLoadrate}" disabled>
                                    </label> %
                                </td>
                            </tr>
                            <tr>
                                <th>결제은행</th>
                                <td>
                                    <span class="select w100p">
                                        <label for="paymentBank"></label>
                                        <select name="paymentBank" id="paymentBank">
                                            <cd:option codeGrp="BANK_CD" value="${sellerDtl.paymentBank}" includeChoice="true"/>
                                        </select>
                                    </span>
                                </td>
                                <th>결제계좌번호</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="paymentActNo" id="paymentActNo" value="${sellerDtl.paymentActNo}">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>예금주명</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="paymentActNm" id="paymentActNm" value="${sellerDtl.paymentActNm}">
                                    </span>
                                </td>
                                <th>업태 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="bsnsCdts" id="bsnsCdts" value="${sellerDtl.bsnsCdts}" data-validation-engine="validate[required, maxSize[15]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>종목 <span class="important">*</span></th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="st" id="st" value="${sellerDtl.st}" data-validation-engine="validate[required, maxSize[15]]">
                                    </span>
                                </td>
                                <th>대표자명</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="ceoNm" id="ceoNm" value="${sellerDtl.ceoNm}">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>대표 전화번호</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="dlgtTel" id="dlgtTel" value="${sellerDtl.dlgtTel}" onblur="chk_tel(this.value,this);" data-validation-engine="validate[maxSize[11]]">
                                    </span>
                                </td>
                                <th>대표 휴대폰번호</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" name="mobileNo" id="mobileNo" value="${sellerDtl.mobileNo}" onblur="chk_tel(this.value,this);" data-validation-engine="validate[maxSize[11]]">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>팩스</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="text" id="fax" name="fax" value="${sellerDtl.fax}" onblur="chk_tel(this.value,this);" datetimeonly="true" style="ime-mode:disabled;" data-validation-engine="validate[maxSize[11]]">
                                    </span>
                                </td>
                                <th>이메일 <span class="important">*</span></th>
                                <td class="seller_email_box">
                                    <span class="intxt mr5"><input type="text" id="email01" data-validation-engine="validate[required]"></span> @
                                    <span class="intxt mr5 ml5" ><input type="text" id="email02" data-validation-engine="validate[required]"></span>
                                    <span class="select">
										<label for="">직접입력</label>
										<select id="email03">
										  <option value="etc" selected="selected">직접입력</option>
										  <option value="naver.com">naver.com</option>
										  <option value="daum.net">daum.net</option>
										  <option value="hanmail.net">hanmail.net</option>
										  <option value="nate.com">nate.com</option>
										  <option value="hotmail.com">hotmail.com</option>
										  <option value="yahoo.com">yahoo.com</option>
										  <option value="empas.com">empas.com</option>
										  <option value="korea.com">korea.com</option>
										  <option value="dreamwiz.com">dreamwiz.com</option>
										  <option value="gmail.com">gmail.com</option>
										</select>
									</span>
                                </td>
                            </tr>
                            <tr class="radio_a">
                                <th>주소 <span class="important">*</span></th>
                                <td>
                                    <div class="addr_field">
                                        <span class="intxt "><input type="text" id="postNo"  name="postNo" value="${sellerDtl.postNo}" data-validation-engine="validate[required]" placeholder="우편번호"></span>
                                        <a href="#layer_id_post" class="btn_gray2 popup_open" id="a_id_post">우편번호</a>
                                        <span class="br"></span>
                                        <span class="intxt w100p"><input type="text" id="addr" name="addr" value="${sellerDtl.addr}" data-validation-engine="validate[required]" placeholder="주소"></span>
                                        <span class="br"></span>
                                        <span class="intxt w100p"><input type="text" id="addrDtl" name="addrDtl" value="${sellerDtl.addrDtl}" data-validation-engine="validate[required]" placeholder="상세 주소 입력"></span>
                                    </div>
                                </td>
                                <th>반품지 주소 </th>
                                <td>
                                    <div class="addr_field">
                                        <span class="intxt"><input type="text"  id="retadrssPostNo" name="retadrssPostNo" value="${sellerDtl.retadrssPostNo}" placeholder="우편번호"></span>
                                        <a href="#layer_id_post" class="btn_gray2 popup_open" id="b_id_post">우편번호</a>
                                        <span class="br"></span>
                                        <span class="intxt w100p"><input type="text" id="retadrssAddr" name="retadrssAddr" value="${sellerDtl.retadrssAddr}" placeholder="주소"></span>
                                        <span class="br"></span>
                                        <span class="intxt w100p"><input type="text" id="retadrssDtlAddr" name="retadrssDtlAddr" value="${sellerDtl.retadrssDtlAddr}" placeholder="상세 주소 입력"></span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>세금계산서 수신메일</th>
                                <td class="seller_email_box">
                                    <span class="intxt mr5"><input type="text" id="taxbillRecvMail01"></span> @
                                    <span class="intxt ml5"><input type="text" id="taxbillRecvMail02"></span>
                                    <span class="select shot">
										<label for="">직접입력</label>
										<select id="taxbillRecvMail03">
										  <option value="etc" selected="selected">직접입력</option>
										  <option value="naver.com">naver.com</option>
										  <option value="daum.net">daum.net</option>
										  <option value="hanmail.net">hanmail.net</option>
										  <option value="nate.com">nate.com</option>
										  <option value="hotmail.com">hotmail.com</option>
										  <option value="yahoo.com">yahoo.com</option>
										  <option value="empas.com">empas.com</option>
										  <option value="korea.com">korea.com</option>
										  <option value="dreamwiz.com">dreamwiz.com</option>
										  <option value="gmail.com">gmail.com</option>
										</select>
									</span>
                                </td>
                                <th>홈페이지</th>
                                <td>
                                    <span class="intxt w100p"><input type="text" name="homepageUrl" id="hompageUrl" value="${sellerDtl.homepageUrl}"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>담당자명 </th>
                                <td>
                                    <span class="intxt w100p"><input type="text" name="managerNm" id="managerNm" value="${sellerDtl.managerNm}" data-validation-engine="validate[required, maxSize[15]]"></span>
                                </td>
                                <th>담당자 직급</th>
                                <td>
                                    <span class="intxt w100p"><input type="text" id="managerPos" name="managerPos" value="${sellerDtl.managerPos}"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>담당자 전화번호 </th>
                                <td>
                                    <span class="intxt w100p"><input type="text" id="managerTelno" name="managerTelno" value="${sellerDtl.managerTelno}" onblur="chk_tel(this.value,this);" data-validation-engine="validate[maxSize[11]]"></span>
                                </td>
                                <th>담당자 휴대폰번호</th>
                                <td>
                                    <span class="intxt w100p"><input type="text" id="managerMobileNo" name="managerMobileNo" value="${sellerDtl.managerMobileNo}" onblur="chk_tel(this.value,this);" data-validation-engine="validate[maxSize[11]]"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>담당자 이메일</th>
                                <td class="seller_email_box">
                                    <span class="intxt mr5"><input type="text" id="managerEmail01"></span> @
                                    <span class="intxt ml5"><input type="text" id="managerEmail02"></span>
                                    <span class="select shot">
										<label for="">직접입력</label>
										<select id="managerEmail03">
											<option value="etc" selected="selected">직접입력</option>
											<option value="naver.com">naver.com</option>
											<option value="daum.net">daum.net</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="nate.com">nate.com</option>
											<option value="hotmail.com">hotmail.com</option>
											<option value="yahoo.com">yahoo.com</option>
											<option value="empas.com">empas.com</option>
											<option value="korea.com">korea.com</option>
											<option value="dreamwiz.com">dreamwiz.com</option>
											<option value="gmail.com">gmail.com</option>
										</select>
									</span>
                                </td>
                                <th>사업자 등본</th>
                                <td>
                                    <span class="intxt "><input class="upload-name" id="fileBoxsNm1" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn" for="input_id_files1">파일첨부</label>
                                    <input class="filebox" type="file" id="input_id_files1" name="biz_file">
                                    <div class="desc_txt">( jpg, gif, pdf 파일 업로드 )</div>
                                    <span id="bizFileInert" style="margin-left:20px;"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>통장 사본</th>
                                <td>
                                    <span class="intxt wid240"><input class="upload-name" id="fileBoxsNm2" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn" for="input_id_files2">파일첨부</label>
                                    <input class="filebox" type="file" id="input_id_files2" name="copy_file">
                                    <div class="desc_txt">( jpg, gif, pdf 파일 업로드 )</div>
                                    <span id="bkFileInert" style="margin-left:20px;"></span>
                                </td>
                                <th>통신판매업신고증</th>
                                <td>
                                    <span class="intxt"><input class="upload-name" id="fileBoxsNm3" type="text" value="" disabled="disabled"></span>
                                    <label class="filebtn" for="input_id_files3">파일첨부</label>
                                    <input class="filebox" type="file" id="input_id_files3" name="etc_file">
                                    <div class="desc_txt">( jpg, gif, pdf 파일 업로드 )</div>
                                    <span id="etcFileInert" style="margin-left:20px;"></span>
                                </td>
                            </tr>
                            <tr>
                                <th>기타 파일</th>
                                <td colspan="3">
                                    <span class="intxt wid240"><input class="upload-name" id="fileBoxsNm5" type="text" value="" disabled=""></span>
                                    <label class="filebtn" for="input_id_files5">파일첨부</label>
                                    <input class="filebox" type="file" id="input_id_files5" name="ref_file">
                                    <div class="desc_txt">( zip 파일 외 업로드 )</div>
                                    <span id="refFileInert" style="margin-left:20px;"></span>
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
                <input type="hidden" name="aprvYn" id="aprvYn" value="${sellerDtl.aprvYn}">
                <c:if test="${sellerDtl.aprvYn == 'N'}">
                    <button class="btn--blue-round" id="btn_approve">승인 요청</button>
                </c:if>
                <c:if test="${sellerDtl.aprvYn == 'Y'}">
                    <button class="btn--blue-round" id="btn_update">수정</button>
                </c:if>
            </div>
        </div>
        <!-- //bottom_box -->
        <!--- popup 아이디 중복확인 --->
        <div id="popup_id_duplicate_check" class="layer_popup">
            <div class="pop_wrap size2">
                <div class="pop_tlt">
                    <h2 class="tlth2">아이디 중복확인 </h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <div class="pop_con">
                    <div class="pw_search_info">
                        아이디는 영문, 숫자 가능하며 5~20자 이내로 입력해주세요.
                    </div>
                    <ul class="id_duplicate_check">
                        <li>
                            <input type="text" id="id_check" maxlength="20">
                            <button type="button" class="btn_id_duplicate_check">중복확인</button>
                        </li>
                    </ul>
                    <div>
                        <div class="id_duplicate_check_info"></div>
                        <div class="textC" id="id_success_div" style="display: none;">
                            <button type="button" class="btn_popup_login" style="margin-top:22px">사용하기</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!---// popup 아이디 중복확인 --->
    </t:putAttribute>
</t:insertDefinition>
