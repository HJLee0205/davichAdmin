<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        $(document).ready(function() {

            //sms 보유 건수 조회
            var url = Constant.smsemailServer + '/sms/point/'+siteNo,
            param = "";
            
            /*Dmall.AjaxUtil.getJSONP(url, param, function(result) {
                $("#smsPossCnt").val(result);
                $("#smsPossCntTag").text(result);
            });*/

            $("#smsPossCnt").val(35);
            $("#smsPossCntTag").text(35);
            
            // sms 발송
            $('#sendSmsBtn').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                //SMS 보유 건수 확인
                if($("#byteVal").text() >= 80){
                    $("#sendFrmCd").val("02");
                    /*if($("#smsPossCnt").val() < 3){
                        Dmall.LayerUtil.alert("SMS 보유 건수가 부족합니다.");
                        return;
                    }*/
                }else{
                    $("#sendFrmCd").val("01");
                    /*if($("#smsPossCnt").val() <= 0){
                        Dmall.LayerUtil.alert("SMS 보유 건수가 부족합니다.");
                        return;
                    }*/
                }
                
                //수신번호 체크
                if($("#recvTelNo").val() == ""){
                    Dmall.LayerUtil.alert("번호를 입력하여 주십시오.");
                    return;
                }
                
                //sms 발송 내용 유효성 체크
                if($("#sendWords").val() == ""){
                    Dmall.LayerUtil.alert("내용을 입력하여 주십시오.");
                    return;
                }
                
                if(Dmall.validate.isValid('form_id_smsSend')) {
                    var url = '/admin/operation/sms-send';
                    var param = jQuery('#form_id_smsSend').serializeObject();

                    Dmall.waiting.start();
                    $.ajax({
                        url          : url
                        , method     : "post"
                        , dataType   : 'json'
                        , data       : JSON.stringify(param)
                        , processData: true
                        , contentType: "application/json; charset=UTF-8"
                    }).done(function (result) {
                        if (result) {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_smsSend');
                            if (result == null || result.success != true) {
                                Dmall.waiting.stop();
                                return;
                            } else {
                                Dmall.AjaxUtil.viewMessage(result, function(){
                                Dmall.LayerPopupUtil.close("smsLayout");
                                $("#sendWords").val("");
                                });
                            }

                        } else {
                            Dmall.validate.viewExceptionMessage(result, 'form_id_smsSend');
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
                }
            });
            
            //sms 내용 글자 byte 출력
            $(document).on('keyup', '#sendWords', function(e){
                var text = $(this).val();
                var $textLengthInfo = $(this).parent().parent().find('strong.byte');
                $textLengthInfo.html("<span class='point_c3' id='byteVal'> " + getTextLength(text) + "</span> byte");
            });
            
        });
        
        //sms 발송 레이어 팝업 실행
        function openSmsLayer(memberNo, memberNm, memberLoginId, memberMobile, recvRjtYn){
            Dmall.LayerPopupUtil.open($("#smsLayout"));
            $("#receiverNo").val(memberNo);
            $("#receiverNm").val(memberNm);
            if(memberLoginId==''){
                memberLoginId='nomember';
            }
            $("#receiverId").val(memberLoginId);
            $("#recvTelNo").val(memberMobile);
            $("#receiverRecvRjtYnSelect").val(recvRjtYn);
        }
        
        //byte 계산
        function getTextLength(str){
            var len = 0;
            for (var i = 0; i < str.length; i++) {
                if (escape(str.charAt(i)).length == 6) {
                    len++;
                }
                len++;
            }
            return len;
        }
        
        </script>
    <!-- layer_popup1 -->
    <div id="smsLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">SMS 발송</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form id="form_id_smsSend" >
            <input type="hidden" id="receiverNo" name="receiverNoSelect" />
            <input type="hidden" id="receiverNm" name="receiverNmSelect" />
            <input type="hidden" id="receiverId" name="receiverIdSelect" />
            <input type="hidden" value="select" name="smsMember" />
            <input type="hidden" name="smsPossCnt" id="smsPossCnt" />
            <input type="hidden" value="01" name="sendTargetCd" />
            <input type="hidden" name="sendFrmCd" id="sendFrmCd" />
            <div class="pop_con">
                <div>
                    <p class="sm_info left">
                        <strong>SMS를 전송하시겠습니까?</strong> [보유 SMS 건수 : <strong class="point_c3" id="smsPossCntTag"></strong>건, 80byte 이상시 MMS/LMS로 발송되며 3건이 차감됩니다.]
                    </p>
                    <div class="byte_box">
                        <span class="intxt shot" style="width:110px!important;">
                            <input type="text" id="recvTelNo" name="recvTelnoSelect" readonly="readonly"/>
                            <input type="hidden" id="receiverRecvRjtYnSelect" name="receiverRecvRjtYnSelect"/>
                        </span>
                        <span class="intxt long"><input type="text" id="sendWords" name="sendWords" /></span>
                        <strong class="byte"><span class="point_c3" id="byteVal">00</span> byte</strong>
                    </div>
                    <div class="btn_box txtc">
                        <button type="button" class="btn green" id="sendSmsBtn" >발송</button>
                    </div>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
