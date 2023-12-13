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
    <t:putAttribute name="title">SMS 자동 발송 설정 > SMS > 운영</t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function() {
                //숫자만 입력가능
                $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

                //치환코드 레이어팝업
                $('#smsReplace').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    Dmall.LayerPopupUtil.open($("#replaceLayer"));
                });

                // 관리자 수신번호 +
                $(document).on('click', 'button.plus', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($('div[name=adminNoDiv]').length >= 3) {
                        Dmall.LayerUtil.alert('관리자 번호는 3개까지 추가 할 수 있습니다.');
                        return;
                    }

                    var cnt = $('div[name=adminNoDiv]').length;
                    cnt++;

                    var template =
                        '<div name="adminNoDiv" style="margin: 10px 0;">' +
                        '<span class="intxt long">' +
                        '<input type="text" id="adminRcvNo_1_'+cnt+'" name="adminRcvNo1" maxlength="11" numberOnly ></span>' +
                        '<button type="button" class="plus btn_comm">더하기 버튼</button>' +
                        '<button type="button" class="minus btn_comm">빼기 버튼</button>' +
                        "<span class='ml20'>'-'를 빼고 입력해 주세요.</span>" +
                        '</div>';

                    $('#adminRcvNoTd').append(template);
                });

                // 관리자 수신번호 -
                $(document).on('click', 'button.minus', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if($('div[name=adminNoDiv]').length <= 1) {
                        return;
                    }

                    $(this).parent('div').remove();
                });

                // textarea byte 표시
                $(document).on('keyup', 'textarea', function() {
                    var $textarea = $(this);
                    var str = $textarea.val();

                    var totalByte = 0;
                    for(var i = 0; i < str.length; i++) {
                        var each_char = str.charAt(i);
                        if(encodeURI(each_char).length > 4)
                            totalByte += 2;
                        else
                            totalByte += 1;
                    }

                    var $textLengthInfo = $(this).parent().parent().find('span.byte');
                    $textLengthInfo.html("<span class='ico_comm post'></span> ("+totalByte+" / 90 bytes)");
                });

                // 저장
                $('#btn_save').on('click', function() {
                    // 자동 발송 상태 및 사용여부 설정
                    var useYnCode = [];
                    var useYnArray = [];
                    $('input[type=radio]:checked').each(function(idx){
                        useYnCode[idx] = $(this).attr('name');
                        useYnArray[idx] = $(this).val();
                    });
                    // 고객 발송 여부 목록 설정
                    var memberSendYn = [];
                    $('input:checkbox[name=memberSendYn]').each(function(idx) {
                        memberSendYn[idx] = $(this).is(':checked') ? 'Y' : 'N';
                    });
                    // 관리자 발송 여부 목록 설정
                    var adminSendYn = [];
                    $('input:checkbox[name=adminSendYn]').each(function(idx) {
                        adminSendYn[idx] = $(this).is(':checked') ? 'Y' : 'N';
                    });
                    // 판매자 발송 여부 목록 설정
                    var sellerSendYn = [];
                    $('input:checkbox[name=sellerSendYn]').each(function(idx) {
                        sellerSendYn[idx] = $(this).is(':checked') ? 'Y' : 'N';
                    });
                    // 가맹점 발송 여부 목록 설정
                    var storeSendYn = [];
                    $('input:checkbox[name=storeSendYn]').each(function(idx) {
                        storeSendYn[idx] = $(this).is(':checked') ? 'Y' : 'N';
                    });
                    // 임직원 발송 여부 목록 설정
                    var staffSendYn = [];
                    $('input:checkbox[name=staffSendYn]').each(function(idx) {
                        staffSendYn[idx] = $(this).is(':checked') ? 'Y' : 'N';
                    });

                    var url = '/admin/operation/sms-autosend-update';
                    var param = $('#smsAutoSetForm').serialize()+
                        "&useYnCode="+useYnCode+
                        "&useYnArray="+useYnArray+
                        "&memberSendYnArr="+memberSendYn+
                        "&adminSendYnArr="+adminSendYn+
                        "&sellerSendYnArr="+sellerSendYn+
                        "&storeSendYnArr="+storeSendYn+
                        "&staffSendYnArr="+staffSendYn;

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            location.reload();
                        }
                    });
                });

                $('textarea').trigger('keyup');
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    운영 설정<span class="step_bar"></span> SMS<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">SMS 자동 발송 설정</h2>
            </div>
            <form id="smsAutoSetForm">
                <div class="line_box fri">
                    <!-- tblw -->
                    <div class="tblw">
                        <table summary="이표는 SMS 자동발송 설정 표 입니다. 구성은 발신번호, 관리자 수신번호 입니다.">
                            <caption>
                                SMS 자동발송 설정
                            </caption>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>관리자 수신번호</th>
                                <td id="adminRcvNoTd">
                                    <c:choose>
                                        <c:when test="${adminRecvNo != null and adminRecvNo.size() > 0}">
                                            <c:forEach var="recvNo" items="${adminRecvNo}" varStatus="status">
                                                <div name="adminNoDiv">
                                                    <span class="intxt long">
                                                        <input type="text" id="adminRcvNo_1_1" name="adminRcvNo1" maxlength="11" value="${fn:replace(recvNo.recvMobile, '-', '')}" numberOnly/>
                                                    </span>
                                                    <button type="button" class="plus btn_comm">더하기 버튼</button>
                                                    <button type="button" class="minus btn_comm">빼기 버튼</button>
                                                    <span class="ml20">'-'를 빼고 입력해 주세요.</span>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div name="adminNoDiv">
                                                <span class="intxt long">
                                                    <input type="text" id="adminRcvNo_1_1" name="adminRcvNo1" maxlength="11" numberOnly/>
                                                </span>
                                                <button type="button" class="plus btn_comm">더하기 버튼</button>
                                                <button type="button" class="minus btn_comm">빼기 버튼</button>
                                                <span class="ml20">'-'를 빼고 입력해 주세요.</span>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <h3 class="tlth3 mt30">
                        <p class="desc">* 90 bytes 이상 시 LMS로 발송이 되며 2건이 차감됩니다.</p>
                        <div class="right">
                            <button type="button" class="btn_gray2" id="smsReplace">치환코드</button>
                        </div>
                    </h3>
                    <!-- tblw -->
                    <div class="tblw tbl_vagtop">
                        <table summary="이표는 SMS 전송 표 입니다. 구성은 입니다.">
                            <caption>
                                SMS 전송
                            </caption>
                            <colgroup>
                                <col width="190px" />
                                <col width="" />
                                <col width="190px" />
                                <col width="" />
                            </colgroup>
                            <tbody>
                            <tags:trUDV compare="${autoSendList}"/>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </form>
        </div>
        <!-- bottom_box -->
        <div class="bottom_box">
            <div class="right">
                <button class="btn--blue-round" id="btn_save">저장</button>
            </div>
        </div>
        <!-- //bottom_box -->
        <!-- 치환코드 팝업 -->
        <jsp:include page="/WEB-INF/views/admin/operation/sms/replaceCd.jsp"/>
    </t:putAttribute>
</t:insertDefinition>