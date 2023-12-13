<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {

});
</script>
<!-- layer_popup1 -->
<div id="smsUseInfo" class="layer_popup">
    <div class="pop_wrap size2">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">SMS 내역</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <ul class="desc_txt top">
                    <li>- 발송결과를 받기까지 시간이 걸릴 수 있습니다.</li>
                    <li>- '접수중' 요청 후 SMS의 전송결과를 받기전까지의 상태입니다.</li>
                    <li>- 전송결과를 받기 전까지는 충전 건수에서 제외됩니다. (단, 실패 시에는 복구됩니다.)</li>
                </ul>
                <form action="" id="form_sms_info">
                    <!-- tblh -->
                    <div class="tblh mt0">
                        <table summary="이표는 SMS 사용내역 표 입니다. 구성은 순번, 수신자(ID), 수신자번호, 내용, 발송결과 입니다.">
                            <caption>SMS 사용내역</caption>
                            <colgroup>
                                <col width="20%">
                                <col width="80%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>순번</th>
                                    <td id="pop_rowNum">1</td>
                                </tr>
                                <tr>
                                    <th>수신자 ID</th>
                                    <td id="pop_receiverId"></td>
                                </tr>
                                <tr>
                                    <th>수신자번호</th>
                                    <td id="pop_recvTel"></td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td id="pop_sendMsg"></td>
                                </tr>
                                <tr>
                                    <th>발송결과</th>
                                    <td id="pop_sendRslt"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                </form>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->