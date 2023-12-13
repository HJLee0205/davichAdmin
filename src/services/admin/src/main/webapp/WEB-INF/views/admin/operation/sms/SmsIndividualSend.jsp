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
    <t:putAttribute name="title">SMS 개별 발송 > SMS > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            var totalMemberCnt = ${resultListModel.totalRows};
            var searchMemberCnt = ${resultListModel.filterdRows};
            var srchMemList;

            $(document).ready(function() {
                // 검색
                $('#btn_id_search').on('click', function(e){
                    if($("#join_sc01").val().replace(/-/gi, "") > $("#join_sc02").val().replace(/-/gi, "")){
                        Dmall.LayerUtil.alert('가입일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    if($("#login_sc01").val().replace(/-/gi, "") > $("#login_sc02").val().replace(/-/gi, "")){
                        Dmall.LayerUtil.alert('최종방문일 검색 시작 날짜가 종료 날짜보다 큽니다.');
                        return;
                    }

                    $("#search_id_page").val("1");
                    $('#form_id_search').attr('action', '/admin/operation/sms/individualSend');
                    console.log("parma = ", $('#form_id_search').serialize());
                    $('#form_id_search').submit();
                });

                //엔터키 입력시 검색 기능
                Dmall.FormUtil.setEnterSearch('form_id_search', function(){ $('#btn_id_search').trigger('click') });

                // 페이징 기능 활성
                $('div.bottom_lay').grid($('#form_id_search'));

                // 엑셀 다운로드 버튼 클릭
                $('#btn_download').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    $('#form_id_search').attr('action', '/admin/member/manage/memberinfo-excel');
                    $('#form_id_search').submit();
                    $('#form_id_search').attr('action', '/admin/operation/sms/individualSend');
                });

                // sms 발송
                $('#btn_sms').on('click', function() {
                    var url = '/admin/operation/member-list-by-send';
                    var rsvNo = $('#rsvNo').val();
                    var param = $('#form_id_search').serialize();
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result) {
                            console.log("result = ", result);
                            srchMemList = result;
                        }
                        var memChk = $('input:checkbox[name=chkMemberNo]').is(':checked');
                        if(memChk == false){
                            $('input[name=smsMember][value=select]').attr('disabled', true);
                        } else {
                            $('input[name=smsMember][value=select]').attr('disabled', false);
                        }

                        $('#receiver_list').html('');

                        $('input[name=smsMember][value=search]').trigger('click');

                        Dmall.LayerPopupUtil.open($('#smsLayout'));
                    });

                });

                // 팝업 받는사람 radio
                $('input[name=smsMember]').change(function() {
                    var value = $('input[name=smsMember]:checked').val();
                    switch(value) {
                        case 'all':
                            $('#receiver_list').html('');
                            $('#pop_recv_cnt').text(totalMemberCnt.toLocaleString('ko-KR') + '명');
                            break;
                        case 'search':
                            $('#receiver_list').html('');
                            $('#pop_recv_cnt').text(searchMemberCnt.toLocaleString('ko-KR') + '명');

                            var tr = '';
                            $.each(srchMemList, function (idx, obj) {
                                var template =
                                    '<li>' +
                                    '<input type="hidden" name="recvTelnoSearch" value="'+ obj.mobile +'">' +
                                    '<input type="hidden" name="receiverNoSearch" value="'+ obj.memberNo +'">' +
                                    '<input type="hidden" name="receiverIdSearch" value="'+ obj.loginId +'">' +
                                    '<input type="hidden" name="receiverNmSearch" value="'+ obj.memberNm +'">' +
                                    '<input type="hidden" name="receiverRecvRjtYnSearch" value="'+ obj.recvRjtYn +'">' +
                                    obj.memberGradeNm +' | '+ obj.memberNm +' | '+ obj.loginId +' | '+ obj.email +' | '+ obj.mobile +
                                    '</li>';
                                tr += template;
                            });
                            $('#receiver_list').html(tr);
                            break;
                        case 'select':
                            var tr = '';
                            var count = 0;
                            $('input:checkbox[name=chkMemberNo]:checked').each(function() {
                                var memberGradeNm = $(this).parents('tr').data('member-grade-nm');
                                var memberNm = $(this).parents('tr').data('member-nm');
                                var loginId = $(this).parents('tr').data('login-id');
                                var email = $(this).parents('tr').data('email');
                                var mobile = $(this).parents('tr').data('mobile');
                                var memberNo = $(this).parents('tr').data('member-no');
                                var recvRjtYn = $(this).parents('tr').data('recv-rjt-yn');
                                var smsRecvYn = $(this).parents('tr').data('sms-recv-yn');

                                var template =
                                    '<li>' +
                                    '<input type="hidden" name="recvTelnoSelect" value="'+mobile+'">' +
                                    '<input type="hidden" name="receiverNoSelect" value="'+memberNo+'">' +
                                    '<input type="hidden" name="receiverIdSelect" value="'+loginId+'">' +
                                    '<input type="hidden" name="receiverNmSelect" value="'+memberNm+'">' +
                                    '<input type="hidden" name="receiverRecvRjtYnSelect" value="'+recvRjtYn+'">' +
                                    '<input type="hidden" name="receiverSmsRecvYnSelect" value="'+smsRecvYn+'">' +
                                    memberGradeNm+' | '+memberNm+' | '+loginId+' | '+email+' | '+mobile +
                                    '</li>';

                                tr += template;

                                count++;
                            });
                            $('#receiver_list').html(tr);
                            $('#pop_recv_cnt').text(count + '명');
                            break;
                    }
                });

                // 팝업 sms 내용 byte 표시
                $('#sendWords').on('keyup', function() {
                    var $textarea = $(this);
                    var $text = $('#byteVal');
                    var str = $textarea.val();

                    var totalByte = 0;
                    for(var i = 0; i < str.length; i++) {
                        var each_char = str.charAt(i);
                        var uni_char = _escape(each_char);
                        if(uni_char.length > 4) {
                            totalByte += 2;
                        } else {
                            totalByte += 1;
                        }
                    }

                    $text.text(totalByte);
                });

                // 팝업 발송
                $('#sendSmsBtn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    var url = '/admin/operation/sms-send';
                    var popParam = $('#form_id_smsSend').serializeObject();
                    var searchParam = { 'memberManageSO' : $('#form_id_search').serializeObject() };
                    var paramMerge = $.extend(popParam, searchParam);
                    Dmall.waiting.start();
                    $.ajax({
                        url : url,
                        method: 'post',
                        dataType: 'json',
                        data: JSON.stringify(paramMerge),
                        processData: true,
                        contentType: 'application/json; charset=UTF-8'
                    }).done(function(result) {
                        if (result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_smsSendInsert');
                            if (!(result == null || result.success != true)) {
                                Dmall.LayerUtil.alert(result.message).done(function() {
                                    Dmall.LayerPopupUtil.close('smsLayout');
                                });
                            }
                        } else {
                            Dmall.validate.viewExceptionMessage(xhr, 'form_id_smsSendInsert');
                        }
                        Dmall.waiting.stop();
                    }).fail(function (result) {
                        if (result.status == 403) {
                            Dmall.LayerUtil.confirm('로그인 정보가 없거나 유효시간이 지났습니다.<br/>로그인페이지로 이동하시겠습니까?',
                                function () {
                                    document.location.href = '/admin/login/member-login';
                                });
                        }
                        Dmall.waiting.stop();
                        Dmall.AjaxUtil.viewMessage(result.responseJSON);
                    });
                });
            });

            // 회원 상세 정보
            function viewMemInfoDtl(memberNo){
                Dmall.FormUtil.submit('/admin/member/manage/memberinfo-detail', {memberNo : memberNo}, '_blank');
            }

            function _escape(text) {
                var res = '', i;
                for(i = 0; i < text.length; i ++) {
                    var c = text.charCodeAt(i);
                    if(c < 256) res += encodeURIComponent(text[i]);
                    else res += '%u' + c.toString(16).toUpperCase();
                }
                return res;
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> SMS<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">SMS 개별발송</h2>
            </div>
            <div class="search_box_wrap">
                <div class="search_box">
                    <!-- search_tbl -->
                    <form:form action="/admin/operation/sms/individualSend" id="form_id_search" commandName="memberManageSO">
                        <form:hidden path="page" id="search_id_page" />
                        <form:hidden path="rows" />
                        <div class="search_tbl">
                            <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입방법, 검색어 입니다.">
                                <caption>
                                    회원 관리
                                </caption>
                                <colgroup>
                                    <col width="150px" />
                                    <col width="" />
                                    <col width="150px" />
                                    <col width="" />
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
                                    <th>생월</th>
                                    <td>
                                        <span class="select">
                                            <label for=""></label>
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
                                    <th>회원유형</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_memberTypeCd"></label>
                                            <select name="memberTypeCd" id="srch_id_memberTypeCd">
                                                <cd:optionUDV codeGrp="MEMBER_TYPE_CD" value="${memberManageSO.memberTypeCd}" includeTotal="true"/>
                                            </select>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>SMS수신</th>
                                    <td>
                                        <tags:radio name="smsRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_smsRecvYn" value="${memberManageSO.smsRecvYn}" />
                                    </td>
                                    <th>이메일수신</th>
                                    <td>
                                        <tags:radio name="emailRecvYn" codeStr=":전체;Y:동의;N:거부" idPrefix="srch_id_emailRecvYn" value="${memberManageSO.emailRecvYn}" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>회원등급</th>
                                    <td>
                                        <span class="select">
                                            <label for="srch_id_memberGrade">전체</label>
                                            <select name="memberGradeNo" id="srch_id_memberGrade">
                                                <tags:option codeStr=":전체;1:일반;3:실버;4:골드;2:플레티넘" value="${memberManageSO.memberGradeNo}"/>
                                            </select>
                                        </span>
                                    </td>
                                    <th>구매금액</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="stSaleAmt" value="${memberManageSO.stSaleAmt}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endSaleAmt" value="${memberManageSO.endSaleAmt}" numberOnly>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>포인트</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="stPrcPoint" value="${memberManageSO.stPrcPoint}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endPrcPoint" value="${memberManageSO.endPrcPoint}" numberOnly>
                                        </span>
                                    </td>
                                    <th>주문횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="stOrdCnt" value="${memberManageSO.stOrdCnt}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endOrdCnt" value="${memberManageSO.endOrdCnt}" numberOnly>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>댓글횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="stCommentCnt" value="${memberManageSO.stCommentCnt}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endCommentCnt" value="${memberManageSO.endCommentCnt}" numberOnly>
                                        </span>
                                    </td>
                                    <th>방문횟수</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="stLoginCnt" value="${memberManageSO.stLoginCnt}" numberOnly>
                                        </span>
                                        ~
                                        <span class="intxt ml10">
                                            <input type="text" name="endLoginCnt" value="${memberManageSO.endLoginCnt}" numberOnly>
                                        </span>
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
                                                    <tags:option codeStr="all:전체;name:이름;id:아이디;email:이메일;mobile:휴대폰" value="${memberManageSO.searchType}"/>
                                                </select>
                                            </span>
                                            <input type="text" name="searchWords" value="${memberManageSO.searchWords}">
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="btn_box txtc">
                            <a href="#none" class="btn green" id="btn_id_search">검색</a>
                        </div>
                    </form:form>
                </div>
                <div class="line_box pb" id="grid_id_memList">
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
                    <div class="tblh">
                        <table summary="회원 리스트" id="table_id_memberList">
                            <caption>
                                회원 리스트
                            </caption>
                            <colgroup>
                                <col width="6%" />
                                <col width="6%" />
                                <col width="8%" />
                                <col width="6%" />
                                <col width="8%" />
                                <col width="8%" />
                                <col width="" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="6%" />
                                <col width="7%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>
                                    <label for="chack05" class="chack">
                                        <span class="ico_comm"><input type="checkbox" name="table" id="chack05"></span>
                                    </label>
                                </th>
                                <th>번호</th>
                                <th>등급</th>
                                <th>가입정보</th>
                                <th>이름</th>
                                <th>아이디</th>
                                <th>이메일</th>
                                <th>휴대폰</th>
                                <th>가입일</th>
                                <th>포인트</th>
                                <th>방문횟수</th>
                                <th>상세</th>
                            </tr>
                            </thead>
                            <tbody id="tbody_id_memberList">
                            <c:choose>
                                <c:when test="${fn:length(resultListModel.resultList) == 0}">
                                    <tr>
                                        <td colspan="12">데이터가 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="memList" items="${resultListModel.resultList}" varStatus="status">
                                        <tr data-member-grade-nm="${memList.memberGradeNm}"
                                            data-member-nm="${memList.memberNm}"
                                            data-login-id="${memList.loginId}"
                                            data-email="${memList.email}"
                                            data-mobile="${memList.mobile}"
                                            data-member-no="${memList.memberNo}"
                                            data-recv-rjt-yn="${memList.recvRjtYn}"
                                            data-sms-recv-yn="${memList.smsRecvYn}" >
                                            <td>
                                                <label for="chkMemberNo_${memList.sortNum}" class="chack">
                                                    <span class="ico_comm"><input type="checkbox" name="chkMemberNo" id="chkMemberNo_${memList.sortNum}" value="${memList.memberNo}" class="bline"></span>
                                                </label>
                                            </td>
                                            <td>${memList.sortNum}</td>
                                            <td>${memList.memberGradeNm}</td>
                                            <td>${memList.joinPathNm}</td>
                                            <td>${memList.memberNm}</td>
                                            <td>${memList.loginId}</td>
                                            <td>${memList.email}</td>
                                            <td>${memList.mobile}</td>
                                            <td>${memList.joinDttm}<br/>${memList.lastLoginDttm}</td>
                                            <td>${memList.prcAmt}</td>
                                            <td>${memList.loginCnt}</td>
                                            <td>
                                                <div class="pop_btn">
                                                    <a href="#none" class="btn_gray" onclick="viewMemInfoDtl('${memList.memberNo}');">보기</a>
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
                    <div class="bottom_lay">
                        <!-- pageing -->
                        <grid:paging resultListModel="${resultListModel}"/>
                        <!-- //pageing -->
                    </div>
                    <!-- //bottom_lay -->
                </div>

            </div>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_sms">SMS 발송</button>
            </div>
        </div>
        <!-- //bottom_box -->
        <!-- sms 발송 layer_popup -->
        <div id="smsLayout" class="layer_popup">
            <div class="pop_wrap size1">
                <!-- pop_tlt -->
                <div class="pop_tlt">
                    <h2 class="tlth2">SMS 발송</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
                <!-- //pop_tlt -->
                <form id="form_id_smsSend">
                    <input type="hidden" name="sendTargetCd" value="01">
                    <!-- pop_con -->
                    <div class="pop_con">
                        <div class="tblw">
                            <table id="tb_goods_basic_info">
                                <colgroup>
                                    <col width="15%">
                                    <col width="85%">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th rowspan="2">받는사람</th>
                                    <td>
                                        <tags:radio codeStr="all:전체 회원;search:검색된 회원;select:선택된 회원" name="smsMember" idPrefix="smsMember"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="disposal_log">
                                            <ul id="receiver_list"></ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>받는 사람 전체 수</th>
                                    <td id="pop_recv_cnt"></td>
                                </tr>
                                <tr>
                                    <th>보내는 사람</th>
                                    <td>
                                        <span class="intxt">
                                            <input type="text" name="" id="" value="${adminSmsNo}" readonly>
                                            <span id="hpComment" class="desc_txt ml10">' - ' 를 빼고 입력해 주세요. </span>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td>
                                        <div class="byte_box">
                                            <p class="sm_info left mb10">90 byte 이상시 LMS로 발송이 되며 2건이 차감됩니다.</p>
                                            <p class="sm_info right byte"><span id="byteVal">00</span> bytes</p>
                                            <div class="txt_area">
                                                <textarea name="sendWords" id="sendWords" style="resize: none;"></textarea>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <div class="btn_box txtc">
                                <button type="button" class="btn green" id="sendSmsBtn">발송</button>
                            </div>
                        </div>
                    </div>
                    <!-- //pop_con -->
                </form>
            </div>
        </div>
        <!-- //sms 발송 layer_popup -->
    </t:putAttribute>
</t:insertDefinition>