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
    <t:putAttribute name="title">개별발송 > 푸시알림 > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <link rel="stylesheet" type="text/css" href="/admin/css/jquery.timepicker.min.css">
        <script src="/admin/js/lib/jquery/jquery.timepicker.min.js" charset="utf-8"></script>
        <script>
            var totalMemberCnt = ${resultListModel.totalRows};
            var searchMemberCnt = ${resultListModel.filterdRows};
            var selectMemberCnt = 0;
            var srchMemList;

            $(document).ready(function() {
                // timepicker 설정
                $('input[name=sendTime]').timepicker({ 'scrollDefault': 'now' ,  'timeFormat': 'H:i'});

                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                // 검색
                $('#btn_id_search').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($("#join_sc01").val().replace(/-/gi, "") > $("#join_sc02").val().replace(/-/gi, "")){
                        Dmall.LayerUtil.alert('가입일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    if($("#login_sc01").val().replace(/-/gi, "") > $("#login_sc02").val().replace(/-/gi, "")){
                        Dmall.LayerUtil.alert('최종방문일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    if($("#ord_sc01").val().replace(/-/gi, "") > $("#ord_sc02").val().replace(/-/gi, "")){
                        Dmall.LayerUtil.alert('구매일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    var expdate = new Date();
                    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
                    setCookie('SEARCH_APPPUSH_LIST', JSON.stringify($('#form_id_search').serializeObject()), expdate);


                    $("#search_id_page").val("1");
                    $('#form_id_search').attr('action', '/admin/operation/app/individualSend');
                    $('#form_id_search').submit();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 엑셀 다운로드
                $('#btn_download').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_search').attr('action', '/admin/member/manage/memberinfo-excel');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/operation/app/individualSend');
                });

                // 푸시알림 발송
                $('#btn_push').on('click', function() {
                    var url = '/admin/operation/app/member-list-by-send';
                    var param = $('#form_id_search').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result) {
                            console.log("result = ", result);
                            srchMemList = result;
                        }
                        // 받는 사람 초기화
                        var memChk = $('input:checkbox[name=selectMember]').is(':checked');
                        if(memChk == false) {
                            $('input[name=appMember][value=select]').attr('disabled', true);
                        } else {
                            $('input[name=appMember][value=select]').attr('disabled', false);
                        }
                        $('#receiver_list').html('');
                        $('input[name=appMember][value=search]').trigger('click');
                        // 파일,링크,내용 초기화
                        $('input.upload-name').val('');
                        $('input[type=file]').val('');
                        $('div.upload_file').html('');
                        $('input:text[name=link]').val('');
                        $('#sendMsg').val('(광고) ');
                        // 발송시간 초기화
                        $('input:text[name=sendDate]').val('');
                        $('input:text[name=sendTime]').val('');
                        $('input:radio[name=pushSendType][value="1"]').trigger('click');

                        Dmall.LayerPopupUtil.open($('#appLayout'));
                    });


                });

                // timepicker
                $('input:radio[name=pushSendType]').change(function(e){
                    var chk = $('input:radio[name="pushSendType"]:checked').val();
                    if (chk == "1") {
                        $('#s_date').hide();
                    } else {
                        $('#s_date').show();
                    }
                });

                //팝업 받는사람 radio
                $('input[name=appMember]').change(function() {
                    var value = $('input[name=appMember]:checked').val();
                    switch(value) {
                        case 'all':
                            $('#receiver_list').html('');
                            $('#receiverCnt').text(totalMemberCnt.toLocaleString('ko-KR') + '명');
                            break;
                        case 'search':
                            $('#receiver_list').html('');
                            $('#receiverCnt').text(searchMemberCnt.toLocaleString('ko-KR') + '명');

                            var tr = '';
                            $.each(srchMemList, function (idx, obj) {
                                var template =
                                    '<li>' +
                                    obj.memberGradeNm +' | '+ obj.memberNm +' | '+ obj.loginId +' | '+ obj.email +' | '+ obj.mobile +
                                    '</li>';
                                tr += template;
                            });
                            $('#receiver_list').html(tr);
                            break;
                        case 'select':
                            var tr = '';
                            var count = 0;
                            $('input:checkbox[name=selectMember]:checked').each(function() {
                                var memberNo = $(this).parents('tr').data('member-no');
                                var memberNm = $(this).parents('tr').data('member-nm');
                                var mobile = $(this).parents('tr').data('mobile');
                                var loginId = $(this).parents('tr').data('login-id');
                                var appToken = $(this).parents('tr').data('app-token');
                                var osType = $(this).parents('tr').data('os-type');
                                var memberGradeNm = $(this).parents('tr').data('member-grade-nm');
                                var email = $(this).parents('tr').data('email');

                                var template =
                                    '<li>' +
                                    '<input type="hidden" name="list['+ count +'].receiverNo" value="'+ memberNo +'">' +
                                    '<input type="hidden" name="list['+ count +'].receiverId" value="'+ loginId +'">' +
                                    '<input type="hidden" name="list['+ count +'].receiverNm" value="'+ memberNm +'">' +
                                    '<input type="hidden" name="list['+ count +'].appToken" value="'+ appToken +'">' +
                                    '<input type="hidden" name="list['+ count +'].osType" value="'+ osType +'">' +
                                    memberGradeNm+' | '+memberNm+' | '+loginId+' | '+email+' | '+mobile +
                                    '</li>';

                                tr += template;
                                count++;
                            });
                            $('#receiver_list').html(tr);
                            $('#receiverCnt').text(count + '명');

                            selectMemberCnt = count;
                            break;
                    }
                });

                // 팝업 파일첨부
                $('input[type=file]').on('change', function(e) {
                    if($(this)[0].files.length < 1) {
                        $('input.upload-name').val('');
                        $('div.upload_file').html('');
                        return;
                    }

                    if(this.files && this.files[0]) {
                        var ext = $(this).val().split('.').pop().toLowerCase();
                        if($.inArray(ext, ['jpg','jpeg','png','bmp']) == -1) {
                            Dmall.LayerUtil.alert('jpg,jpeg,png,bmp 파일만 업로드 할 수 있습니다.','알림');
                            $(this).val('');
                            $('input.upload-name').val('');
                            return;
                        }

                        var fileNm = this.files[0].name;
                        var reader = new FileReader();
                        reader.onload = function (e) {
                            $('div.upload_file').html(
                                '<span class="txt">'+ fileNm +'</span>' +
                                '<button class="cancel" onclick="delFileNm(this);"></button><br>' +
                                '<img src="'+ e.target.result +'" alt="미리보기 이미지">'
                            );
                        };
                        reader.readAsDataURL(this.files[0]);
                        $('input.upload-name').val(fileNm);
                    }
                });

                // 팝업 발송
                $('#sendAppBtn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var typeChk = $('input:radio[name="pushSendType"]:checked').val();

                    if (typeChk == "1") {
                        $('input[name=sendDate]').val('');
                        $('input[name=sendTime]').val('');
                        $('input[name=pushStatus]').val('02');  //발송중
                    } else {
                        var sendDate = $('input[name=sendDate]').val();
                        var sendTime = $('input[name=sendTime]').val();
                        $('input[name=pushStatus]').val('03');  //예약대기

                        if (sendDate == '' || sendDate == undefined) {
                            Dmall.LayerUtil.alert('발송예정일자를 입력하세요.');
                            return;
                        }

                        if (sendTime == '' || sendTime == undefined) {
                            Dmall.LayerUtil.alert('발송예정시간을 입력하세요.');
                            return;
                        }

                        var now = new Date();
                        var year = now.getFullYear();
                        var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
                        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
                        var time = now.getHours() + '' + now.getMinutes();

                        var chan_val = year + '-' + mon + '-' + day;

                        if (sendDate < chan_val) {
                            $('input[name=sendDate]').val('');
                            Dmall.LayerUtil.alert('발송예정일자는 오늘이후로 선택하세요.');
                            return;
                        }

                        var selTime = sendTime.replace(":", "");
                        if (sendDate == chan_val) {
                            if (parseInt(selTime) < parseInt(time)) {
                                $('input[name=sendTime]').val('');
                                Dmall.LayerUtil.alert('발송예정시간을 현재시간이후로 선택하세요.');
                                return;
                            }
                            if (parseInt(selTime) > parseInt('1800')) {
                                Dmall.LayerUtil.alert('발송예정시간을 18:00 이전으로 선택하세요.');
                                return;

                            }
                        }
                    }

                    var link = $('input[name="link"]').val();
                    var pattern = /^(http|https)?:\/\/[a-zA-Z0-9-\.]+\.[a-z]{2,4}/;

                    if (link.length > 0 && !pattern.test(link)) {
                        Dmall.LayerUtil.alert('링크 입력형식이 올바르지 않습니다.');
                        return;
                    }

                    // 필수 파라미터 설정
                    $('input:hidden[name=sendType]').val(typeChk);
                    var recvCndtGb = $('input:radio[name=appMember]:checked').val();
                    $('input:hidden[name=recvCndtGb]').val(recvCndtGb);
                    if(recvCndtGb == 'all') {
                        $('input:hidden[name=sendCnt]').val(totalMemberCnt);
                    } else if(recvCndtGb == 'search') {
                        $('input:hidden[name=sendCnt]').val(searchMemberCnt);
                    } else if(recvCndtGb == 'select') {
                        $('input:hidden[name=sendCnt]').val(selectMemberCnt);
                    }

                    var url = '/admin/operation/app-push';

                    Dmall.waiting.start();
                    $('#form_id_appSendInsert').ajaxSubmit({
                        url: url,
                        dataType: 'json',
                        success: function (result) {
                            Dmall.waiting.stop();
                            var msg = '';
                            if(result.success) {
                                if(typeChk == '1') {
                                    msg = '푸시 알림이 발송되었습니다. ';
                                } else {
                                    msg = '푸시 알림 발송이 예약되었습니다.';
                                }
                                Dmall.LayerUtil.alert(msg).done(function () {
                                    Dmall.LayerPopupUtil.close('appLayout');
                                });
                            } else {
                                Dmall.LayerUtil.alert('푸시 알림 발송이 실패했습니다.');
                            }
                        },
                    })
                });
            });

            // input 파일 삭제
            function delFileNm(obj) {
                $(obj).parent('div.upload_file').html('');
                $('input[type=file]').val('');
                $('input.upload-name').val('');
            }

            //회원 상세 정보
            function viewMemInfoDtl(memberNo){
                Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', {memberNo : memberNo});
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> 푸시알림<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">개별발송</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/operation/app/individualSend" id="form_id_search" commandName="memberManageSO">
                        <form:hidden path="page" id="search_id_page" />
                        <form:hidden path="rows" />
                        <div class="search_tbl">
                            <table summary="이표는 [app발송] 설정 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, app수신, 이메이수신, 회원등급, 구매금액, 적립금, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입 방법, 검색어 입니다.">
                                <caption>[app발송] 설정 검색</caption>
                                <colgroup>
                                    <col width="150px">
                                    <col width="">
                                    <col width="150px">
                                    <col width="">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>가입일</th>
                                    <td colspan="3">
                                        <tags:calendar from="joinStDttm" to="joinEndDttm"  fromValue="${memberManageSO.joinStDttm}" toValue="${memberManageSO.joinEndDttm}" idPrefix="join" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>최종방문일</th>
                                    <td colspan="3">
                                        <tags:calendar from="loginStDttm" to="loginEndDttm"  fromValue="${memberManageSO.loginStDttm}" toValue="${memberManageSO.loginEndDttm}" idPrefix="login" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>구매일</th>
                                    <td colspan="3">
                                        <tags:calendar from="ordStDttm" to="ordEndDttm"  fromValue="${memberManageSO.ordStDttm}" toValue="${memberManageSO.ordEndDttm}" idPrefix="ord" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>나이</th>
                                    <td colspan="3">
                                        <span class="intxt">
                                            <form:input path="stAge" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="4"  />
                                        </span>년생
                                        <form:errors path="stAge" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endAge" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="4" />
                                        </span>년생
                                        <form:errors path="endAge" cssClass="errors"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th>생월</th>
                                    <td colspan="3">
                                        <span class="select">
                                            <label for="bornMonth"></label>
                                            <select name="bornMonth" id="bornMonth">
                                                <option value="">전체</option>
                                                <option value="01" <c:if test='${memberManageSO.bornMonth eq "01" }' >selected</c:if>>01월</option>
                                                <option value="02" <c:if test='${memberManageSO.bornMonth eq "02" }' >selected</c:if>>02월</option>
                                                <option value="03" <c:if test='${memberManageSO.bornMonth eq "03" }' >selected</c:if>>03월</option>
                                                <option value="04" <c:if test='${memberManageSO.bornMonth eq "04" }' >selected</c:if>>04월</option>
                                                <option value="05" <c:if test='${memberManageSO.bornMonth eq "05" }' >selected</c:if>>05월</option>
                                                <option value="06" <c:if test='${memberManageSO.bornMonth eq "06" }' >selected</c:if>>06월</option>
                                                <option value="07" <c:if test='${memberManageSO.bornMonth eq "07" }' >selected</c:if>>07월</option>
                                                <option value="08" <c:if test='${memberManageSO.bornMonth eq "08" }' >selected</c:if>>08월</option>
                                                <option value="09" <c:if test='${memberManageSO.bornMonth eq "09" }' >selected</c:if>>09월</option>
                                                <option value="10" <c:if test='${memberManageSO.bornMonth eq "10" }' >selected</c:if>>10월</option>
                                                <option value="11" <c:if test='${memberManageSO.bornMonth eq "11" }' >selected</c:if>>11월</option>
                                                <option value="12" <c:if test='${memberManageSO.bornMonth eq "12" }' >selected</c:if>>12월</option>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>회원등급</th>
                                    <td colspan="3">
                                        <span class="select">
                                            <label for="srch_id_memberGrade"></label>
                                            <select name="memberGradeNo" id="srch_id_memberGrade">
                                                <option value="">전체</option>
                                                <c:forEach var="gradeList" items="${memberGradeListModel.resultList}">
                                                    <option value="${gradeList.memberGradeNo}" <c:if test="${gradeList.memberGradeNo eq memberManageSO.memberGradeNo}">selected="selected"</c:if>>${gradeList.memberGradeNm}</option>
                                                </c:forEach>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>구매제품</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_ordTypeCd"></label>
                                            <select name="ordTypeCd" id="srch_id_ordTypeCd">
                                                <code:optionUDV codeGrp="GOODS_TYPE_CD" value="${memberManageSO.ordTypeCd}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                    <th>구매금액</th>
                                    <td>
                                        <span class="intxt">
                                            <form:input path="stSaleAmt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50"  />
                                        </span>
                                        <form:errors path="stSaleAmt" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endSaleAmt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50" />
                                        </span>
                                        <form:errors path="endSaleAmt" cssClass="errors"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th>포인트</th>
                                    <td>
                                        <span class="intxt">
                                            <form:input path="stPrcAmt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50"  />
                                        </span>
                                        <form:errors path="stPrcAmt" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endPrcAmt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50" />
                                        </span>
                                        <form:errors path="endPrcAmt" cssClass="errors"  />
                                    </td>
                                    <th>주문횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <form:input path="stOrdCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50"  />
                                        </span>
                                        <form:errors path="stOrdCnt" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endOrdCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50" />
                                        </span>
                                        <form:errors path="endOrdCnt" cssClass="errors"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th>댓글횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <form:input path="stCommentCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50"  />
                                        </span>
                                        <form:errors path="stCommentCnt" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endCommentCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50" />
                                        </span>
                                        <form:errors path="endCommentCnt" cssClass="errors"  />
                                    </td>
                                    <th>방문횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <form:input path="stLoginCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50"  />
                                        </span>
                                        <form:errors path="stLoginCnt" cssClass="errors"  />
                                        ~
                                        <span class="intxt ml10">
                                            <form:input path="endLoginCnt" cssClass="text" cssErrorClass="text medium error" numberOnly="true" size="40" maxlength="50" />
                                        </span>
                                        <form:errors path="endLoginCnt" cssClass="errors"  />
                                    </td>
                                </tr>
                                <tr>
                                    <th>성별</th>
                                    <td colspan="3">
                                        <tags:radio name="genderGbCd" codeStr=":전체;M:남;F:여" idPrefix="srch_id_genderGbCd" value="${memberManageSO.genderGbCd}" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>가입정보</th>
                                    <td colspan="3">
                                        <tags:checkboxs codeStr="SHOP:일반가입;KT:카카오;NV:네이버;AP:애플;" name="joinPathCd" idPrefix="joinPathCd" value="${memberManageSO.joinPathCd}"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>검색어</th>
                                    <td colspan="3">
                                        <div class="select_inp">
                                            <span>
                                                <label for="srch_id_searchType"></label>
                                                <select name="searchType" id="srch_id_searchType">
                                                    <tags:option codeStr="all:전체;name:이름;id:아이디;email:이메일;mobile:휴대폰;"/>
                                                </select>
                                            </span>
                                            <input type="text" name="searchWords">
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" type="button" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
                <div class="line_box">
                    <div class="top_lay">
                        <div class="select_btn_left">
                            <span class="search_txt">
                                총 <strong class="all" id="cnt_total">${resultListModel.filterdRows}</strong>명의 회원이 검색되었습니다.
                            </span>
                        </div>
                        <div class="select_btn_right">
                            <button class="btn_exl" id="btn_download">
                                <span>Excel download</span> <img src="/admin/img/icons/icon-excel_down.png" alt="excel icon">
                            </button>
                        </div>
                    </div>
                    <!-- tblh -->
                    <div class="tblh th_l">
                        <table summary="회원 리스트"  id="table_id_bbsList">
                            <caption>회원 리스트</caption>
                            <colgroup>
                                <col width="5%">
                                <col width="6%">
                                <col width="8%">
                                <col width="8%">
                                <col width="8%">
                                <col width="8%">
                                <col width="14%">
                                <col width="11%">
                                <col width="9%">
                                <col width="8%">
                                <col width="8%">
                                <col width="7%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack" >
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"  /></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>등급</th>
                                <th>가입경로</th>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>휴대폰번호<br>전화번호</th>
                                <th>가입일<br>최종방문</th>
                                <th>포인트</th>
                                <th>방문횟수</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_memberList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="12">검색된 데이터가 존재하지 않습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="memList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr data-member-no="${memList.memberNo}"
                                            data-member-nm="${memList.memberNm}"
                                            data-mobile="${memList.mobile}"
                                            data-login-id="${memList.loginId}"
                                            data-app-token="${memList.appToken}"
                                            data-os-type="${memList.osType}"
                                            data-member-grade-nm="${memList.memberGradeNm}"
                                            data-email="${memList.email}" >
                                            <td>
                                                <label for="chack05_${memList.sortNum}" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="selectMember" id="chack05_${memList.sortNum}"/></span>
                                                </label>
                                            </td>
                                            <td>${memList.sortNum}</td>
                                            <td>${memList.memberGradeNm}</td>
                                            <td>${memList.joinPathNm}</td>
                                            <td>${memList.memberNm}</td>
                                            <td>${memList.loginId}</td>
                                            <td>${memList.email}</td>
                                            <td>${memList.mobile}</td>
                                            <td>${memList.joinDttm}<br>${memList.lastLoginDttm}</td>
                                            <td><fmt:formatNumber value='${memList.prcPoint}' type='number'/></td>
                                            <td>${memList.loginCnt}</td>
                                            <td>
                                                <div class="pop_btn">
                                                    <a href="#none" class="btn_blue" onclick="viewMemInfoDtl('${memList.memberNo}');">보기</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay" >
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}" />
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>
            </div>
        </div>
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_push">푸시알림 발송</button>
            </div>
        </div>

        <!-- layer_popup -->
        <div id="appLayout" class="layer_popup">
            <div class="pop_wrap size5">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">푸시알림 발송</h2>
                    <button class="close ico_comm" id="btn_close_layer_goods_option">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <!-- pop_con -->
                <div class="pop_con">
                    <form action="" id="form_id_appSendInsert" method="post">
                        <input type="hidden" name="sendType" />
                        <input type="hidden" name="pushStatus" />
                        <input type="hidden" name="recvCndtGb">
                        <input type="hidden" name="sendCnt">
                        <input type="hidden" name="srchCndt" value="${memberManageSO}">
                        <input type="hidden" name="alarmGbNm" value="전체">
                        <!-- tblw -->
                        <div class="tblw">
                            <table>
                                <colgroup>
                                    <col width="15%">
                                    <col width="35%">
                                    <col width="15%">
                                    <col width="35%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>발송시간</th>
                                    <td colspan="3">
                                        <tags:radio codeStr="1:즉시 발송;2:예약 발송" name="pushSendType" idPrefix="pushSendType" value="1"/>
                                        <span id="s_date" style="display:none">
                                            <span class="intxt"><input type="text" name="sendDate" class="bell_date_sc" placeholder="YYYY-MM-DD"></span>
                                            <a href="javascript:void(0);" class="date_sc ico_comm" >달력이미지</a>
                                            <input name="sendTime" type="text" class="time ui-timepicker-input custom_timepicker" autocomplete="off" style="width:80px;" placeholder="HH:MM">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th rowspan="2">받는사람</th>
                                    <td colspan="3">
                                        <tags:radio codeStr="all:전체 회원;search:검색된 회원;select:선택된 회원" name="appMember" idPrefix="appMember"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <div class="disposal_log">
                                            <ul id="receiver_list"></ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>받는사람 수</th>
                                    <td colspan="3" id="receiverCnt"></td>
                                </tr>
                                <tr>
                                    <th>이미지</th>
                                    <td colspan="3">
                                        <span class="intxt wid240"><input type="text" class="upload-name" readonly></span>
                                        <label for="input_id_files4" class="filebtn">파일선택</label>
                                        <input type="file" id="input_id_files4" class="filebox" name="push_img" accept="image/*">
                                        <span class="desc">· 파일 첨부 시 10MB 이하 업로드 ( jpg / png / bmp )</span>
                                        <div class="upload_file"></div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>링크</th>
                                    <td colspan="3">
                                        <span class="intxt w100p">
                                            <input type="text" id="link" name="link" style="width:80%;">
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td colspan="3">
                                        <div class="area_byte">
                                            <div class="txt_area w100p">
                                                <textarea name="sendMsg" id="sendMsg"></textarea>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- //tblw -->
                    </form>
                    <div class="btn_box txtc">
                        <button class="btn green" id="sendAppBtn">메시지 전송</button>
                    </div>
                </div>
                <!-- //pop_con -->
            </div>
        </div>
        <!-- //layer_popup -->
    </t:putAttribute>
</t:insertDefinition>
