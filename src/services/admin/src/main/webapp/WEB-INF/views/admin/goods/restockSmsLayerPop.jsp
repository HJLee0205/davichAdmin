<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        var siteNo = ${siteNo};
        
        $(document).ready(function() {
            
            // sms 발송
            $('#sendSmsBtn').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                //수신번호 체크
                if($("#recvTelNo").text() == ""){
                    Dmall.LayerUtil.alert("번호를 입력하여 주십시오.");
                    return;
                }
                
                //sms 발송 내용 유효성 체크
                if($("#sendWords").val() == ""){
                    Dmall.LayerUtil.alert("내용을 입력하여 주십시오.");
                    return;
                }
                
                if(Dmall.validate.isValid('form_id_smsSend')) {
                    var url = '/admin/goods/restocknotify/restock-sms-send',
                        param = {},
                        recvData = $('#recvTelNo').data('recvTelNo');
                    
                    jQuery.each(recvData, function(i, o) {
                        key = 'list[' + i + '].reinwareAlarmNo';
                        param[key] = o['reinwareAlarmNo'];
                        key = 'list[' + i + '].goodsNo';
                        param[key] = o['goodsNo'];
                        key = 'list[' + i + '].memberNo';
                        param[key] = o['memberNo'];
                        key = 'list[' + i + '].goodsNm';
                        param[key] = o['goodsNm'];
                        key = 'list[' + i + '].recvTelNo';
                        param[key] = o['mobile'];
                        key = 'list[' + i + '].receiverNo';
                        param[key] = o['memberNo'];
                        key = 'list[' + i + '].receiverNm';
                        param[key] = o['memberNm'];
                        key = 'list[' + i + '].alarmStatusCd';
                        param[key] = '2';
                        key = 'list[' + i + '].sendWords';
                        param[key] = $('#sendWords').val();
                    });

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_smsSend');
                        if(result.success){
                            Dmall.LayerPopupUtil.close('layer_notify_pop');
                            getRestockNotifyList();
                        }
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
        function openSmsLayer(){
            var restockNotifyList = fn_selectedList();
            if (restockNotifyList) {
                // SMS 보유 문자 건수 확인
                var url = Constant.smsemailServer + '/sms/point/' + siteNo,
                param = "";
                /*Dmall.AjaxUtil.getJSONP(url, param, function(result) {
                    // SMS 보유 건수 확인
                    if(result <= 0){
                        Dmall.LayerUtil.alert("SMS 보유 건수가 부족합니다.");
                        return;
                    } else {
                        $("#smsPossCnt").val(result);
                        $("#smsCnt").text(result);
                    }
                });*/
                
                Dmall.LayerPopupUtil.open($("#layer_notify_pop"));
                
                var recvNm = ''
                  , recvNo = ''
                  , recvData = [];                
                jQuery.each(restockNotifyList, function(i, o) {                    
                    var data = $('#tr_notify_' + restockNotifyList[i]).data('prev_data');
                    if (i === 0) {
                        recvNm = (restockNotifyList.length > 1) ? data['memberNm'] + '외' + restockNotifyList.length +'명' : data['memberNm'];
                        recvNo = '(' + Dmall.formatter.tel(data['mobile']) + ')';
                    }
                    recvData.push(data);
                });
                $('#recvTelNo').data('recvTelNo', recvData).text(recvNm + recvNo);
            }
            var text = $('#sendWords').val();
            $('#byteVal').text(getTextLength(text));
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
    <div id="layer_notify_pop" class="layer_popup">
        <div class="pop_wrap size2">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                    <h2 class="tlth2">재입고 알림 통보하기</h2>
                    <button class="close ico_comm">닫기</button>
                </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form id="form_id_smsSend" >
            <input type="hidden" id="receiverNo" name="receiverNoSelect" />
            <input type="hidden" id="receiverNm" name="receiverNmSelect" />
            <input type="hidden" id="receiverId" name="receiverIdSelect" />
            <input type="hidden" value="select" name="smsMember" />
            <input type="hidden" value="0" name="smsPossCnt" id="smsPossCnt" />
            <input type="hidden" value="01" name="sendTargetCd" />
            <input type="hidden" name="sendFrmCd" id="sendFrmCd" />
            
            <div class="pop_con sms_pcon">
                <div>
                    <p class="sm_info"><strong>SMS 전송</strong> [보유 SMS 건수 : <strong class="point_c3" id="smsCnt"></strong>건] <a href="#none" class="btn_blue">충전</a></p>
                    <span class="br"></span>
                    <div class="in">
                        <strong>받는 사람</strong> : <span id="recvTelNo" name="recvTelnoSelect" ></span>
                        <span class="br2"></span>
                        <strong>보내는 사람</strong> : 
                            <span class="intxt"><input type="text" id="sendTelNo" name="sendTelnoSelect" value="${adminSmsNo}" readonly/></span>
                        <span class="br2"></span>
                        <p class="desc_txt">90byte 이상 시 LMS로 발송되며 3건이 차감됩니다.</p>
                        <span class="br"></span>
                        <div class="txt_area">
                            <textarea id="sendWords" name="sendWords">${restockSmsWord}</textarea>
                        </div>
                        <!-- <strong class="byte"><span class="point_c3" id="byteVal">00</span> byte</strong> -->
                    </div>
                    <div class="btn_box txtc">
                        <button class="btn green" id="sendSmsBtn">SMS 전송</button>
                    </div>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
