<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {
    
});

function openEmailUseInfoLayer(mailSendNo){
    var param = {mailSendNo:mailSendNo};
    
    var url = Constant.smsemailServer + '/email/viewHistory/',dfd = jQuery.Deferred();
//    var url = 'http://localhost:8082/email/viewHistory/';

//     Dmall.AjaxUtil.getJSONP(url, param, function(result) {
//         if(result.success){
//             Dmall.LayerUtil.alert('삭제되었습니다.');
//             var param = {pageGb:"4"};
//             Dmall.FormUtil.submit('/admin/operation/bulk-mailing', param);
//         }
//     });
    
    
    Dmall.AjaxUtil.getJSONP(url, param, function(result) {
        Dmall.FormUtil.jsonToForm(result, 'form_mailUse_info');
        $("#sendContent").html(result.sendContent);
        $("#sendNmAndEmail").html(result.senderNm + "<br />" + "(" + result.sendEmail + ")");
        $("#bind_target_id_sendStndrd").append(" ("+groupCount+"명)");
        
        if(result.resultCd=='06'){
            $("#resultCdTd").html("발송완료"); 
        }else if(result.resultCd=='03'){
            $("#resultCdTd").html("발송중"); 
        }else if(result.resultCd=='04'){
            $("#resultCdTd").html("예약"); 
        }else{
            $("#resultCdTd").html("발송중"); 
        }
        
    });
}
</script>
<!-- layer_popup1 -->
<div id="emailUseInfo" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">대량메일 발송내역</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <form action="" id="form_mailUse_info">
                <!-- tblh -->
                <div class="tblh mt0">
                    <table summary="이표는 대량메일 발송내역 표 입니다. 구성은  입니다.">
                        <caption>이메일 발송내역 리스트</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="30%">
                            <col width="20%">
                            <col width="">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>발송일시</th>
                                <td id="bind_target_id_sendDttm" class="bind_target"></td>
                                <th class="line">발송상태</th>
                                <td id="resultCdTd"></td>
                            </tr>
                            <tr>
                                <th>발송건수</th>
                                <td id="emailSendCnt"></td>
                                <th>실패건수</th>
                                <td id="emailSendFailCnt"></td>
                            </tr>
                            <tr>
                                <th>보내는사람</th>
                                <td id="sendNmAndEmail"></td>
                                <th>받는사람</th>
                                <td id="bind_target_id_sendStndrd" class="bind_target"></td>
                            </tr>
                            <tr>
                                <th>이메일 제목</th>
                                <td colspan="3" id="bind_target_id_sendTitle" class="bind_target" style="text-align:left;"></td>
                            </tr>
                            <tr>
                                <td colspan="4" id="sendContent" class="bind_target" style="text-align:left;"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </form>
                <!-- //tblh -->
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->