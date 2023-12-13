<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {
    
});

function openEmailUseInfoLayer(mailSendNo){
    var param = {mailSendNo:mailSendNo};
    var url = '/admin/operation/email-send-info';
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        Dmall.FormUtil.jsonToForm(result.data, 'form_mailUse_info');
        $("#sendContent").html(result.data.sendContent);
    });
}
</script>
<!-- layer_popup1 -->
<div id="emailUseInfo" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">이메일 발송내역</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <form action="" id="form_mailUse_info">
                <!-- tblw -->
                <div class="tblw">
                    <table>
                        <colgroup>
                            <col width="150px">
                            <col width="">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>발송일시</th>
                            <td id="bind_target_id_sendDttm" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>발송상태</th>
                            <td id="bind_target_id_resultCd" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>수신자 ID</th>
                            <td id="bind_target_id_receiverId" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>수신자 이름</th>
                            <td id="bind_target_id_receiverNm" class="bind_target"></td>
                        </tr>
                        <tr>
                            <th>이메일 제목</th>
                            <td id="bind_target_id_sendTitle" class="bind_target"></td>
                        </tr>
                        <tr>
                            <td colspan="2" id="sendContent" class="bind_target" style="text-align: left;"></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
            </form>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->