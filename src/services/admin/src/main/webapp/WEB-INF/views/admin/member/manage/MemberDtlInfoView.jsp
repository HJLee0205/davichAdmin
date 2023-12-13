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
    <t:putAttribute name="title">회원 관리 > 회원</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var siteNo = "${siteNo}";
            var memberNm = "${resultModel.data.memberNm}";
            var memberLoginId = "${resultModel.data.loginId}";
            var memberPoint = "<fmt:formatNumber value='${resultModel.data.prcPoint}' type='number' />";
            var memberAmt = "${resultModel.data.prcAmt}";
            var memberCpCnt = "<fmt:formatNumber value='${resultModel.data.cpCnt}' type='number' />";
            var memberStamp = "${resultModel.data.prcStamp}";
            var memberMobile = "${resultModel.data.mobile}";
            var authGbCd = "${authCd}";
            var adminNo = "${adminNo}";

            $(document).ready(function() {
                fn_file_set();

                //숫자, 하이폰(-) 만 입력가능
                $(document).on("keyup", "input:text[datetimeOnly]", function() {$(this).val( $(this).val().replace(/[^0-9\-]/gi,"") );});
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});
                //영문만 입력가능
                $(document).on("keyup", "input:text[engOnly]", function() {$(this).val( $(this).val().replace(/[^a-zA-Z0-9\_]/g,"") );});

                // 관리자가 아닌 운영자라면 비밀번호 수정 불가
                if(authGbCd == "M" && adminNo == "${resultModel.data.memberNo}"){
                    $("#pwTr").remove();
                }

                // 회원유형 변경 이벤트
                $('select[name=memberTypeCd]').on('change', function() {
                    var url = '/admin/member/manage/member-info-update';
                    var param = {memberNo: "${resultModel.data.memberNo}", memberTypeCd: $(this).val()}
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        location.reload();
                    });
                });

                // 닉네임 중복확인
                $('#btn_check').on('click', function() {
                    // reset
                    $('.id_duplicate_check_info').html('');
                    $('#id_success_div').attr('style', 'display:none;');
                    Dmall.LayerPopupUtilNew.open($('#popup_id_duplicate_check'));
                });

                // 닉네임 중복확인 팝업의 중복확인 버튼
                var createNn = '';
                $('.btn_id_duplicate_check').on('click', function() {
                    if(Dmall.validation.isEmpty($('#id_check').val())) {
                        $('#id_success_div').attr('style', 'display:none;');
                        Dmall.LayerUtil.alert('닉네임을 입력해주세요.', '알림');
                        return false;
                    } else {
                        var url = '/admin/member/manage/duplication-nickname-check';
                        var param = {memberNn: $('#id_check').val(), siteNo: siteNo};
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                createNn = $('#id_check').val();
                                $('#id_success_div').attr('style', 'display:block;');
                                $('.id_duplicate_check_info').html('사용 가능한 닉네임입니다.');
                            } else {
                                $('#id_success_div').attr('style', 'display:none;');
                                $('.id_duplicate_check_info').html('사용할 수 없는 닉네임입니다.');
                            }
                        });
                    }
                });

                // 닉네임 중복확인 팝업 사용하기 버튼 클릭
                $('.btn_popup_login').on('click', function() {
                    Dmall.LayerPopupUtil.close('popup_id_duplicate_check');
                    $('#memberNn').val(createNn);
                    $('#chkNickname').val(true);
                });

                //우편번호 팝업
                $('#a_id_post').on('click', function(e) {
                    Dmall.LayerPopupUtil.zipcode(setZipcode);
                });

                // 파일첨부
                $('input[type=file]').on('change', function(e) {
                    var inputId = $(this).attr('id');
                    var ext = $(this).val().split('.').pop().toLowerCase();

                    if(inputId == 'input_id_file') {
                        if($.inArray(ext, ['pptx','ppt','xls','xlsx','doc','docx','hwp','pdf','png','jpg','jpeg']) == -1) {
                            Dmall.LayerUtil.alert('pptx','ppt','xls','xlsx','doc','docx','hwp','pdf','png','jpg','jpeg 파일만 업로드할 수 있습니다.', '알림');
                            $(this).val('');
                            $('#upload-name').val('');
                            return;
                        } else {
                            if($('#upload_file').children().is('button')) {
                                $('#' + inputId).val('');
                                $('#upload-name').val('');
                                Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                            } else {
                                var template =
                                    '<span class="txt">' + e.target.files[0].name + '</span>' +
                                    '<button class="cancel">삭제</button>';
                                $('#upload_file').html(template);
                                $('#upload-name').val(e.target.files[0].name);
                            }
                        }
                    } else if(inputId == 'input_id_image') {
                        if($.inArray(ext, ['jpg','jpeg','png','pdf']) == -1) {
                            Dmall.LayerUtil.alert('jpg,jpeg,png,pdf 파일만 업로드 할 수 있습니다.', '알림');
                            $(this).val('');
                            $('#upload-name').val('');
                            return;
                        } else {
                            if($('#upload_file').children().is('button')) {
                                $('#' + inputId).val('');
                                $('#upload-name').val('');
                                Dmall.LayerUtil.alert('이미 등록된 파일이 있습니다.', '알림');
                            } else {
                                var fileNm = e.target.files[0].name;
                                var reader = new FileReader();
                                reader.onload = function(e) {
                                    var template =
                                        '<img src="' + e.target.result + '" width="110" height="110" alt="미리보기 이미지" class="mr20">' +
                                        '<span class="txt">' + fileNm + '</span>' +
                                        '<button class="cancel">삭제</button>';
                                    $('#upload_file').html(template);
                                    $('#upload-name').val(fileNm);
                                }
                                reader.readAsDataURL(e.target.files[0]);
                            }
                        }
                    }
                });

                // 업로드한 파일 삭제
                $('#upload_file').on('click', '.cancel', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($(this).attr('id') == 'remote') {
                        var url = '/admin/member/manage/attach-file-delete';
                        var param = {};
                        param.memberNo = $('#memberNo').val();
                        param.memberTypeCd = $('#memberTypeCd').val();

                        Dmall.LayerUtil.confirm('삭제된 이미지는 복구할 수 없습니다.<br/>정말 삭제하시겠습니까?', function() {
                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                $("#upload_file").html('');
                            });
                        });
                    } else {
                        if($('#memberTypeCd').val() == '04') {
                            $('#input_id_image').val('');
                        } else if($('#memberTypeCd').val() == '05'){
                            $('#input_id_file').val('');
                        }
                        $('#upload-name').val('');
                        $('#upload_file').html('');
                    }
                })

                //포인트 레이어 팝업 실행
                $("#savedMnHisBtn, #savedMnHis").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    openSaveMnLayer($("#memberNo").val(), memberAmt);
                });

                // 스탬프 레이어 팝업 실행
                $('#stampHisBtn').on('click', function () {
                    // reset
                    $('#form_id_stamp_select')[0].reset();
                    $('#stampHistBody').html('');
                    $('#div_id_stamp_paging').html('');

                    Dmall.LayerPopupUtil.open($('#stampLayout'));
                    $('.mpAmt', '#stampLayout').html(memberStamp);
                    openStampLayer();
                });

                // 스탬프 팝업 검색 버튼
                $('#btnSearchStamp').on('click', function (e) {
                    $('#stampPage').val('1');
                    openStampLayer();
                });

                //주문 목록 화면
                $("#viewOrdBtn").on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/order/manage/order-status', {searchCd : '07', searchWord: memberMobile}, "_blank");
                });

                //쿠폰 내역 팝업 실행
                $("#cpHisBtn").on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);
                    Dmall.LayerPopupUtil.open($("#couponLayout"));
                    openCouponLayer($("#memberNo").val(), memberNm, memberLoginId, memberCpCnt);
                });

                //상품 문의 게시판으로 이동
                $("#viewQuestionBtn").on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/goods/goods-questions', { memberNo: $('#memberNo').val() }, '_blank');
                });

                //1:1 문의 게시판으로 이동
                $("#viewInquiryBtn").on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/board/letter', {bbsId : 'inquiry', memberNo: $('#memberNo').val() }, '_blank');
                });

                //상품 후기 게시판으로 이동
                $("#viewReviewBtn").on('click', function(e) {
                    Dmall.FormUtil.submit('/admin/goods/goods-reviews', { memberNo: $('#memberNo').val() }, '_blank');
                });

                //회원리스트 화면으로 이동
                $("#viewMemListBtn").on('click', function(e) {
                    location.replace("/admin/member/manage/member");
                });

                //사업자 승인
                $('#confirmBtn').click(function(e){
                    var url = '/admin/member/manage/member-info-confirm';
                    var param = {memberNo: ${resultModel.data.memberNo}};

                    Dmall.LayerUtil.confirm('승인처리 하시겠습니까?', function() {
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                location.reload();
                            } else {
                                Dmall.LayerUtil.alert("오류가 발생하였습니다.");
                            }
                        });
                    });
                });

                //회원 탈퇴
                $("#withdrawalBtn").on('click', function(e) {
                    Dmall.LayerUtil.confirm('정말 탈퇴 시키시겠습니까?', function() {
                        if(Dmall.validate.isValid('form_id_memDtl')) {
                            var url = '/admin/member/manage/member-delete',
                                param = $('#form_id_memDtl').serialize();

                            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                                Dmall.validate.viewExceptionMessage(result, 'form_id_memDtl');
                                if(result.success){
                                    location.replace("/admin/member/manage/member");
                                }
                            });
                        }
                    });
                });

                //회원정보 수정
                $("#updateMemBtn").on('click', function(e) {
                    if(Dmall.validate.isValid('form_id_memDtl')) {
                        // 비밀번호 입력했을 때 비밀번호 검증
                        if($("#memPw").val() != "" ){
                            if(!chkPw()) {
                                return;
                            }
                        }
                        // 닉네임 중복확인 검증
                        if($('#memberTypeCd').val() != '05' && !$('#chkNickname').val()) {
                            Dmall.LayerUtil.alert("닉네임 중복 확인이 필요합니다.", "알림");
                            return;
                        }
                        // 이메일 값 대입
                        var emailVal = $("#email1").val().replaceAll(' ','') + "@" + $("#email2").val().replaceAll(' ','');
                        if(emailVal == '@') {
                            $("#email").val('');
                        } else {
                            $("#email").val(emailVal);
                        }
                        // 사업자등록번호 하이픈 제거
                        if($('#bizRegNo').val()) {
                            $('#bizRegNo').val($('#bizRegNo').val().replace(/\-/g, ''));
                        }

                        var url = '/admin/member/manage/member-info-update';

                        Dmall.waiting.start();
                        $('#form_id_memDtl').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Dmall.waiting.stop();
                                Dmall.validate.viewExceptionMessage(result, 'form_id_memDtl');
                                if(result.success){
                                    Dmall.LayerUtil.alert(result.message).done(function () {
                                        location.reload();
                                    });
                                } else {
                                    Dmall.LayerUtil.alert(result.message);
                                }
                            }
                        });
                    }
                });
            });

            //우편번호, 주소 값 입력
            function setZipcode(data) {
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#newPostNo').val(data.zonecode); //5자리 새우편번호 사용
                $('#strtnbAddr').val(data.jibunAddress);
                $('#roadAddr').val(data.roadAddress);
                $('#addrDtl').val('').focus();
            }

            // 서버 첨부파일 바인딩
            function fn_file_set() {
                var memType = "${resultModel.data.memberTypeCd}";
                var template = '';

                if(memType != null && memType != '' && memType == '04') {
                    var imgOrgNm = "${resultModel.data.imgOrgNm}";
                    if(imgOrgNm != null && imgOrgNm != '') {
                        template =
                            '<img src="" width="110" height="110" alt="미리보기 이미지" class="mr20">' +
                            '<span class="txt">${resultModel.data.imgOrgNm}</span>' +
                            '<button class="cancel" id="remote">삭제</button>';
                    }
                } else if(memType == '05') {
                    var bizOrgFileNm = "${resultModel.data.bizOrgFileNm}";
                    if(bizOrgFileNm != null && bizOrgFileNm != '') {
                        template =
                            '<span class="txt">${resultModel.data.bizOrgFileNm}</span>' +
                            '<button class="cancel" id="remote">삭제</button>';
                    }
                }
                $('#upload_file').html(template);
            }

            // 비밀번호 검사
            function chkPw() {
                var $obj = $('#memPw');
                if( $obj.val() != $('#memPwChk').val()){
                    Dmall.LayerUtil.alert("비밀번호가 일치하지 않습니다.", "알림");
                    return false;
                }
                if ($obj.val().length < 8 || $obj.val().length > 16){
                    Dmall.LayerUtil.alert("비밀번호 길이가 맞지 않습니다.", "알림");
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
                if ($obj.val().indexOf($('#loginId').val()) > -1) {
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
                return true;
            }

            // 전화번호 자동 하이픈
            function chkTel(target) {
                target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{2,3})(\d{3,4})(\d{4})$/g, '$1-$2-$3');
            }

            // 휴대폰 자동 하이픈
            function chkMobile(target) {
                target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, '$1-$2-$3').replace(/(\-{1,2})$/g, '');
            }

            // 사업자등록번호 자동 하이픈
            function chkBizNo(target) {
                target.value = target.value.replace(/[^0-9]/g, '').replace(/^(\d{0,3})(\d{0,2})(\d{0,5})$/g, '$1-$2-$3').replace(/(\-{1,2})$/g, '');
            }

            // 스탬프 레이어 팝업 실행
            function openStampLayer() {
                var url = '/admin/member/manage/stamp-list',
                    param = $('#form_id_stamp_select').serialize(),
                    dfd = $.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var template =
                            '<tr>' +
                            '<td>{{sortNum}}</td>' +
                            '<td>{{inDate}}</td>' +
                            '<td>{{inType}}{{inStore}}<br>{{slaStamp}}</td>' +
                            '<td>자동</td>' +
                            '</tr>',
                        templateMgr = new Dmall.Template(template),
                        tr = '';

                    $.each(result.resultList, function (idx, obj) {
                        if(obj.inType == '+') {
                            obj.inType = '<span class="point_c6">(+)</span>';
                        } else {
                            obj.inType = '<span class="point_c3">(-)</span>';
                        }

                        if(obj.inStore == 'on') {
                            obj.inStore = '온라인'
                        } else {
                            obj.inStore = '오프라인';
                        }

                        tr += templateMgr.render(obj);
                    });

                    if(tr == '') {
                        tr = '<tr><td colspan="4">데이터가 없습니다.</td></tr>'
                    }

                    $('#stampHistBody').html(tr);
                    dfd.resolve(result.resultList);

                    Dmall.GridUtil.appendPaging('form_id_stamp_select', 'div_id_stamp_paging', result, 'paging_id_stamp', openStampLayer);

                    $('.all', '#stampLayout').text(result.filterdRows);
                });

                return dfd.promise();
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <c:set var="memDtl" value="${resultModel.data}" />
            <form id="form_id_memDtl" method="post">
                <input type="hidden" name="memberNo" id="memberNo" value = "${memDtl.memberNo}" />
                <input type="hidden" name="loginId" id="loginId" value = "${memDtl.loginId}"/>
                <input type="hidden" name="memberNm" id="memberNm" value = "${memDtl.memberNm}"/>
                <input type="hidden" name="email" id="email" value = "${memDtl.email}"/>
                <c:choose>
                    <c:when test="${memDtl.memberNn eq null}">
                        <input type="hidden" id="chkNickname" value="false">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" id="chkNickname" value="true">
                    </c:otherwise>
                </c:choose>
                <div class="tlt_box">
                    <div class="tlt_head">
                        회원 설정<span class="step_bar"></span>
                    </div>
                    <h2 class="tlth2">회원 관리</h2>
                </div>
                <!-- line_box -->
                <div class="line_box fri pb">
                    <h3 class="tlth3">기본 정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 가입일 표 입니다.">
                            <caption>가입일</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>가입일</th>
                                <td>${memDtl.joinDttm}</td>
                                <th>상태</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${memDtl.integrationMemberGbCd eq '03'}">
                                            ${memDtl.integrationMemberGbNm} / 통합일시 : ${memDtl.memberIntegrationDttm}
                                        </c:when>
                                        <c:otherwise>
                                            ${memDtl.integrationMemberGbNm}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>앱 최초 로그인</th>
                                <td>${memDtl.appFirstLoginDttm}</td>
                                <th>회원유형</th>
                                <td style="display: flex;">
                                    <span class="select">
                                        <label for="memberTypeCd"></label>
                                        <select name="memberTypeCd" id="memberTypeCd">
                                            <tags:option codeStr="01:일반회원;05:가맹점;06:임직원" value="${memDtl.memberTypeCd}"/>
                                        </select>
                                    </span>
                                    <c:if test="${memDtl.memberTypeCd eq '05'}">
                                        <span class="intxt w100p">
                                            <input type="text" name="customStoreNo" id="customStoreNo" value="${memDtl.customStoreNo}">
                                        </span>
                                    </c:if>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3 btn1">개인 정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 기본정보 표 입니다. 구성은 이름/아이디, 실명확인, 성별, 생년월일, 이메일/수신여부, 핸드폰/수신여부, 전화번호, 주소 입니다.">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                            <c:choose>
                                <%-- 일반회원 / 임직원 --%>
                                <c:when test="${memDtl.memberTypeCd eq '01' || memDtl.memberTypeCd eq '06'}">
                                    <tr>
                                        <th>이름 / 아이디</th>
                                        <td>${memDtl.memberNm} / ${memDtl.loginId}</td>
                                        <th class="line">닉네임</th>
                                        <td>
                                            <span class="intxt long2">
                                                <input type="text" name="memberNn" id="memberNn" value="${memDtl.memberNn}">
                                            </span>
                                            <a href="#none" class="btn--black_small" id="btn_check">중복확인</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="line">본인인증</th>
                                        <td>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'Y'}">인증완료</c:if>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'N'}">인증미완료</c:if>
                                        </td>
                                        <th class="line">생년월일 / 성별</th>
                                        <td>
                                            <c:catch var="ex">
                                            <c:set var="birthLength" value="${fn:length(memDtl.birth)}"/>
                                            <c:choose>
                                                <c:when test="${birthLength eq 6}">
                                                    <fmt:parseDate var="birthDate" value="${memDtl.birth}" pattern="yyMMdd"/>
                                                    <fmt:formatDate value="${birthDate}" pattern="yy-MM-dd" /> /
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:parseDate var="birthDate" value="${memDtl.birth}" pattern="yyyyMMdd"/>
                                                    <fmt:formatDate value="${birthDate}" pattern="yyyy-MM-dd" /> /
                                                </c:otherwise>
                                            </c:choose>
                                            </c:catch>
                                            <c:if test="${memDtl.genderGbCd eq 'M'}">남성</c:if>
                                            <c:if test="${memDtl.genderGbCd eq 'F'}">여성</c:if>
                                        </td>
                                    </tr>
                                    <tr id="pwTr">
                                        <th>비밀번호 변경</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPw" name="pw" placeholder="비밀번호 입력" />
                                            </span>
                                            <span class="point_c6 member_password">
                                                * 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.<br/>&nbsp;&nbsp;아이디와 동일하거나, 3자리 이상 반복되는 문구와 숫자는 불가합니다.
                                            </span>
                                        </td>
                                        <th>변경 비밀번호 확인</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPwChk" placeholder="비밀번호 확인" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이메일</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${memDtl.email eq null}">
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value=""/></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="memEmail" value="${fn:split(memDtl.email, '@')}" />
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="${memEmail[0]}" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value="${memEmail[1]}" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <th>이메일 수신여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="emailRecvYn" idPrefix="emailRecvYn" value="${memDtl.emailRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>휴대폰</th>
                                        <td>
                                            <input type="hidden" name="mobile" id="mobile" value="${memDtl.mobile}">
                                            ${memDtl.mobile}
                                        </td>
                                        <th>SMS 수신 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="smsRecvYn" idPrefix="smsRecvYn" value="${memDtl.smsRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>PUSH 동의</th>
                                        <td colspan="3">
                                            <tags:checkbox id="notiGb" name="notiGb" compareValue="${memDtl.notiGb}" text="댓글" value="1"/>
                                            <tags:checkbox id="eventGb" name="eventGb" compareValue="${memDtl.eventGb}" text="마케팅" value="1"/>
                                            <tags:checkbox id="newsGb" name="newsGb" compareValue="${memDtl.newsGb}" text="야간 푸시" value="1"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            주소<br/><br/>
                                            상세 주소
                                        </th>
                                        <td colspan="3">
                                            <div class="addr_field">
                                                <div class="flex">
                                                    <span class="intxt shot2"><input type="text" name="newPostNo" id="newPostNo" value="${memDtl.newPostNo}"></span>
                                                    <span class="intxt flex1"><input type="text" name="roadAddr" id="roadAddr" value="${memDtl.roadAddr}"></span>
                                                    <a href="#none" class="btn--black_small" id="a_id_post">주소선택</a>
                                                </div>
                                                <span class="br"></span>
                                                <span class="intxt w100p"><input type="text" name="dtlAddr" id="dtlAddr" value="${memDtl.dtlAddr}"></span>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <%-- 인플루언서 --%>
                                <c:when test="${memDtl.memberTypeCd eq '04'}">
                                    <tr>
                                        <th>이름 / 아이디</th>
                                        <td>${memDtl.memberNm} / ${memDtl.loginId}</td>
                                        <th>닉네임</th>
                                        <td>
                                            <span class="intxt long2">
                                                <input type="text" name="memberNn" id="memberNn" value="${memDtl.memberNn}" readonly>
                                            </span>
                                            <a href="#none" class="btn--black_small" id="btn_check">중복확인</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th rowspan="2">프로필 이미지</th>
                                        <td rowspan="2">
                                            <span class="intxt imgup2"><input type="text" id="upload-name" class="upload-name" readonly></span>
                                            <label class="filebtn on" for="input_id_image">파일첨부
                                                <input class="filebox" name="file" type="file" id="input_id_image" accept="image/*">
                                            </label>
                                            <span class="br"></span>
                                            <span class="desc">
                                                * 파일 첨부 시 3MB 이하 업로드 ( jpg / png / bmp )<br>
                                                * 이미지 권장 사이즈 500*500px
                                            </span>
                                            <div class="upload_file" id="upload_file"></div>
                                        </td>
                                        <th>인플루언서 소개</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="text" name="infDesc" id="infDesc" value="${memDtl.infDesc}">
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>내 코드 정보</th>
                                        <td>
                                            <strong>얼굴형</strong>
                                            <tags:checkboxs codeStr="S:S(Square);R:R(Round);P:P(Polygon);O:O(Oval)" name="" idPrefix=""/>
                                            <span class="br"></span>
                                            <string>스타일</string>
                                            <tags:checkboxs codeStr="D:D(Daily);N:N(Natural);F:F(Fancy)" name="" idPrefix=""/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>본인인증</th>
                                        <td>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'Y'}">인증완료</c:if>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'N'}">인증미완료</c:if>
                                        </td>
                                        <th>생년월일 / 성별</th>
                                        <td>
                                            <c:catch var="ex">
                                            <c:set var="birthLength" value="${fn:length(memDtl.birth)}"/>
                                            <c:choose>
                                                <c:when test="${birthLength eq 6}">
                                                    <fmt:parseDate var="birthDate" value="${memDtl.birth}" pattern="yyMMdd"/>
                                                    <fmt:formatDate value="${birthDate}" pattern="yy-MM-dd" /> /
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:parseDate var="birthDate" value="${memDtl.birth}" pattern="yyyyMMdd"/>
                                                    <fmt:formatDate value="${birthDate}" pattern="yyyy-MM-dd" /> /
                                                </c:otherwise>
                                            </c:choose>
                                            </c:catch>
                                            <c:if test="${memDtl.genderGbCd eq 'M'}">남성</c:if>
                                            <c:if test="${memDtl.genderGbCd eq 'F'}">여성</c:if>
                                        </td>
                                    </tr>
                                    <tr id="pwTr">
                                        <th>비밀번호 변경</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPw" name="pw" placeholder="비밀번호 입력" />
                                            </span>
                                            <span class="point_c6 member_password">
                                                * 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.<br/>&nbsp;&nbsp;아이디와 동일하거나, 3자리 이상 반복되는 문구와 숫자는 불가합니다.
                                            </span>
                                        </td>
                                        <th>변경 비밀번호 확인</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPwChk" placeholder="비밀번호 확인" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이메일</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${memDtl.email eq null}">
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value=""/></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="memEmail" value="${fn:split(memDtl.email, '@')}" />
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="${memEmail[0]}" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value="${memEmail[1]}" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <th>이메일 수신여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="emailRecvYn" idPrefix="emailRecvYn" value="${memDtl.emailRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>휴대폰</th>
                                        <td>
                                            <input type="hidden" name="mobile" id="mobile" value="${memDtl.mobile}">
                                            ${memDtl.mobile}
                                        </td>
                                        <th>SMS 수신 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="smsRecvYn" idPrefix="smsRecvYn" value="${memDtl.smsRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>PUSH 동의</th>
                                        <td colspan="3">
                                            <tags:checkbox id="notiGb" name="notiGb" compareValue="1" text="댓글" value="${memDtl.notiGb}"/>
                                            <tags:checkbox id="eventGb" name="eventGb" compareValue="1" text="마케팅" value="${memDtl.eventGb}"/>
                                            <tags:checkbox id="newsGb" name="newsGb" compareValue="1" text="야간 푸시" value="${memDtl.newsGb}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            주소<br/><br/>
                                            상세 주소
                                        </th>
                                        <td colspan="3">
                                            <div class="addr_field">
                                                <div class="flex">
                                                    <span class="intxt shot2"><input type="text" name="newPostNo" id="newPostNo" value="${memDtl.newPostNo}"></span>
                                                    <span class="intxt flex1"><input type="text" name="roadAddr" id="roadAddr" value="${memDtl.roadAddr}"></span>
                                                    <a href="#none" class="btn--black_small" id="a_id_post">주소선택</a>
                                                </div>
                                                <span class="br"></span>
                                                <span class="intxt w100p"><input type="text" name="dtlAddr" id="dtlAddr" value="${memDtl.dtlAddr}"></span>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <%-- 가맹점 --%>
                                <c:when test="${memDtl.memberTypeCd eq '03' || memDtl.memberTypeCd eq '05'}">
                                    <tr>
                                        <th>업체명 / 아이디</th>
                                        <td>${memDtl.memberNm} / ${memDtl.loginId}</td>
                                        <th>본인인증</th>
                                        <td>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'Y'}">인증완료</c:if>
                                            <c:if test="${memDtl.realnmCertifyYn eq 'N'}">인증미완료</c:if>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>사업자등록번호</th>
                                        <td>
                                            <span class="intxt w100p"><input type="text" name="bizRegNo" id="bizRegNo" value="${memDtl.bizRegNo.replaceAll("^(\\d{0,3})(\\d{0,2})(\\d{0,5})$", "$1-$2-$3")}" maxlength="12" oninput="chkBizNo(this)"></span>
                                        </td>
                                        <th>사업자등록증 사본</th>
                                        <td>
                                            <span class="intxt imgup2"><input type="text" id="upload-name" class="upload-name" readonly></span>
                                            <label class="filebtn on" for="input_id_file">파일첨부
                                                <input class="filebox" name="file" type="file" id="input_id_file">
                                            </label>
                                            <span class="br"></span>
                                            <span class="desc">
                                                * 파일 첨부 시 3MB 이하 업로드
                                            </span>
                                            <div class="upload_file" id="upload_file"></div>
                                        </td>
                                    </tr>
                                    <tr id="pwTr">
                                        <th>비밀번호 변경</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPw" name="pw" placeholder="비밀번호 입력" />
                                            </span>
                                            <span class="point_c6 member_password">
                                                * 영문/숫자/특수문자 2가지 이상 조합 8~16자로 입력하세요.<br/>&nbsp;&nbsp;아이디와 동일하거나, 3자리 이상 반복되는 문구와 숫자는 불가합니다.
                                            </span>
                                        </td>
                                        <th>변경 비밀번호 확인</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="password" id="memPwChk" placeholder="비밀번호 확인" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>이메일</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${memDtl.email eq null}">
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value=""/></span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="memEmail" value="${fn:split(memDtl.email, '@')}" />
                                                    <span class="intxt shot5"><input name="email1" id="email1" type="text" value="${memEmail[0]}" engOnly/></span>
                                                    @
                                                    <span class="intxt shot5 ml10"><input name="email2" id="email2" type="text" value="${memEmail[1]}" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <th>이메일 수신여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="emailRecvYn" idPrefix="emailRecvYn" value="${memDtl.emailRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>전화번호</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="text" name="tel" id="tel" value="${memDtl.tel}" maxlength="13" oninput="chkTel(this)">
                                            </span>
                                        </td>
                                        <th style="border-right: none; background-color: white;"></th>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <th>담당자 이름</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="text" name="managerNm" id="managerNm" value="${memDtl.managerNm}">
                                            </span>
                                        </td>
                                        <th>PUSH 동의</th>
                                        <td colspan="3">
                                            <tags:checkbox id="notiGb" name="notiGb" compareValue="1" text="댓글" value="${memDtl.notiGb}"/>
                                            <tags:checkbox id="eventGb" name="eventGb" compareValue="1" text="마케팅" value="${memDtl.eventGb}"/>
                                            <tags:checkbox id="newsGb" name="newsGb" compareValue="1" text="야간 푸시" value="${memDtl.newsGb}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>담당자 휴대폰</th>
                                        <td>
                                            <span class="intxt w100p">
                                                <input type="text" name="mobile" id="mobile" value="${memDtl.mobile}" maxlength="13" oninput="chkMobile(this)">
                                            </span>
                                        </td>
                                        <th>SMS 수신 여부</th>
                                        <td>
                                            <tags:radio codeStr="Y:동의;N:거부" name="smsRecvYn" idPrefix="smsRecvYn" value="${memDtl.smsRecvYn}"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            주소<br/><br/>
                                            상세 주소
                                        </th>
                                        <td colspan="3">
                                            <div class="addr_field">
                                                <div class="flex">
                                                    <span class="intxt shot2"><input type="text" name="newPostNo" id="newPostNo" value="${memDtl.newPostNo}"></span>
                                                    <span class="intxt flex1"><input type="text" name="roadAddr" id="roadAddr" value="${memDtl.roadAddr}"></span>
                                                    <a href="#none" class="btn--black_small" id="a_id_post">주소선택</a>
                                                </div>
                                                <span class="br"></span>
                                                <span class="intxt w100p"><input type="text" name="dtlAddr" id="dtlAddr" value="${memDtl.dtlAddr}"></span>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <h3 class="tlth3">활동 정보<span class="desc">해당 회원이 쇼핑몰에서 활동한 정보입니다.</span></h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 활동정보 표 입니다. 구성은 최근로그인, 최근수정일, 회원등급, 포인트, 마켓포인트, 보유쿠폰, 구매금액, 주문횟수, 방문횟수, 상품후기, 상품문의, 1:1문의 입니다.">
                            <caption>활동정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="510px">
                                <col width="150px">
                                <col width="510px">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>최근 로그인 (IP)</th>
                                    <td colspan="3">${memDtl.lastLoginDttm} (IP : ${memDtl.loginIp})</td>
                                </tr>
                                <tr>
                                    <th>방문횟수</th>
                                    <td colspan="3"><fmt:formatNumber value='${memDtl.loginCnt}' type='number'/>회</td>
<%--                                    <th>회원등급</th>--%>
<%--                                    <td>--%>
<%--                                        <span class="select">--%>
<%--                                            <label for="memberGradeNo"></label>--%>
<%--                                            <select name="memberGradeNo" id="memberGradeNo">--%>
<%--                                                <tags:option codeStr="1:일반;3:실버;4:골드;2:플래티넘" value="${memDtl.memberGradeNo}"/>--%>
<%--                                            </select>--%>
<%--                                        </span>--%>
<%--                                    </td>--%>
                                </tr>
                                <tr>
                                    <th>포인트</th>
                                    <td><fmt:formatNumber value='${memDtl.prcAmt}' type='number'/>p <a href="#savedMnLayout" class="btn_gray nudge popup_open" id = "savedMnHisBtn">내역 확인<span class="ico_comm"></span></a></td>
                                    <th class="line">스탬프</th>
                                    <td><fmt:formatNumber value='${memDtl.prcStamp}' type='number'/>개 <a href="#stampLayout" class="btn_gray nudge popup_open" id="stampHisBtn">내역 확인<span class="ico_comm"></span></a></td>
                                </tr>
                                <tr>
                                    <th>구매금액</th>
                                    <td><fmt:formatNumber value='${memDtl.saleAmt}' type='number'/>원 <a href="#" class="btn_gray nudge" title="새 창" id="viewOrdBtn">내역 확인<span class="ico_comm"></span></a></td>
                                    <th class="line">보유쿠폰</th>
                                    <td><fmt:formatNumber value='${memDtl.cpCnt}' type='number'/>장 <a href="#couponLayout" class="btn_gray nudge popup_open" id = "cpHisBtn">내역 확인<span class="ico_comm"></span></a></td>
                                </tr>
                                <tr>
                                    <th class="line">주문건수</th>
                                    <td><fmt:formatNumber value='${memDtl.ordCnt}' type='number'/>건
                                        <span class="nudge">
                                            <fmt:parseNumber var="saleAmt" value='${memDtl.saleAmt}' integerOnly="true"/>
                                            <c:choose>
                                                <c:when test="${saleAmt > 0 and memDtl.ordCnt > 0}">
                                                    <fmt:parseNumber var="avgSaleAmt" value="${saleAmt / memDtl.ordCnt}" integerOnly="true" />
                                                    (평균 <fmt:formatNumber value='${avgSaleAmt}' type='number'/> 원)
                                                </c:when>
                                                <c:otherwise>
                                                    (평균 0 원)
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <th>상품문의</th>
                                    <td><fmt:formatNumber value='${memDtl.questionCnt}' type='number'/>개 <a href="#none" class="btn_gray nudge" id="viewQuestionBtn" >내역 확인</a></td>
                                </tr>
                                <tr>
                                    <th class="line">1:1문의</th>
                                    <td><fmt:formatNumber value='${memDtl.inquiryCnt}' type='number'/>개 <a href="#none" class="btn_gray nudge" title="새 창" id="viewInquiryBtn" >내역 확인</a></td>
                                    <th class="line">상품후기</th>
                                    <td><fmt:formatNumber value='${memDtl.reviewCnt}' type='number'/>개 <a href="#none" class="btn_gray nudge" title="새 창" id="viewReviewBtn">내역 확인</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                    <!-- double_lay -->
                    <div class="double_lay disposal">
                        <div class="left">
                            <h3 class="tlth3">관리자 메모</h3>
                            <div class="txt_area" style="height: 150px;">
                                <textarea name="managerMemo" id="managerMemo">${memDtl.managerMemo}</textarea>
                            </div>
                        </div>
                        <div class="right">
                            <div>
                                <h3 class="tlth3">처리로그</h3>
                                <div class="disposal_log">
                                    <ul>
                                        <c:forEach var = "prcLogList" items="${prcLog}">
                                            <c:set var="len" value="${fn:length(prcLogList.prcLogNm)}"/>
                                            <li>[${prcLogList.chgDttm}] ${prcLogList.prcNm} <c:out value="${fn:substring(prcLogList.prcLogNm,1,len) }" /> 변경 </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //double_lay -->
                </div>
                <!-- //line_box -->
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="left">
                <div class="pop_btn">
                    <button class="btn--big btn--big-white" id="viewMemListBtn">목록</button>
                </div>
            </div>
            <div class="right">
                <c:if test="${memDtl.memberTypeCd eq '05' && (memDtl.bizAprvYn eq 'N' || memDtl.bizAprvYn eq null)}">
                    <button class="btn--blue-round" id="confirmBtn">승인</button>
                </c:if>
                <button class="btn--blue-round" id="withdrawalBtn">강제탈퇴</button>
                <button class="btn--blue-round" id="updateMemBtn">저장하기</button>
            </div>
        </div>
        <!-- //bottom_box -->
        <%@ include file="SaveMnLayerPop.jsp" %>
        <%@ include file="CouponLayerPop.jsp" %>
        <!--- popup 아이디 중복확인 --->
        <div id="popup_id_duplicate_check" style="display: none;" class="pop_wrap size2">
            <div class="pop_tlt">
                <h2 class="tlth2">닉네임 중복확인</h2>
                <button type="button" class="btn_close_popup"><img src="/admin/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="pop_con">
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
        <!---// popup 아이디 중복확인 --->
        <!-- popup 스탬프 관리 -->
        <div id="stampLayout" class="layer_popup">
            <div class="pop_wrap size1">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">스탬프 관리</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con">
                    <h3 class="tlth3">보유 스탬프 : <span class="mpAmt"></span>개</h3>
                    <!-- search_form -->
                    <form action="" id="form_id_stamp_select">
                        <input type="hidden" name="page" id="stampPage" value="1">
                        <input type="hidden" name="memberNo" value="${memDtl.memberNo}">
                        <div class="tblw mt0">
                            <table>
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>지급/차감일</th>
                                    <td>
                                        <tags:calendar from="fromDt" to="toDt" idPrefix="stampSrch"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>지급/차감</th>
                                    <td>
                                        <tags:radio codeStr=":전체;P:지급;D:차감" name="statusCd" idPrefix="statusCd" value=""/>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </form>
                    <!-- //search_form -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="btnSearchStamp">검색</button>
                    </div>
                    <div class="mt20">
                        <div class="top_lay">
                            <div class="select_btn_left">
                                    <span class="search_txt">
                                        총 <strong class="all" id="cnt_total"></strong>건의 내역이 검색되었습니다.
                                    </span>
                            </div>
                        </div>
                        <!-- tblh -->
                        <div class="tblh">
                            <table>
                                <colgroup>
                                    <col width="10%">
                                    <col width="18%">
                                    <col width="18%">
                                    <col width="18%">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>NO</th>
                                    <th>일시</th>
                                    <th>지급/차감</th>
                                    <th>자동/수동</th>
                                </tr>
                                </thead>
                                <tbody id="stampHistBody">
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblh -->
                        <!-- bottom_lay -->
                        <div class="bottom_lay">
                            <div class="pageing" id="div_id_stamp_paging"></div>
                        </div>
                        <!-- //bottom_lay -->
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
        <!-- //popup 스탬프 관리 -->
    </t:putAttribute>
</t:insertDefinition>
