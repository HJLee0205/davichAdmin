<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
        <script>
        $(document).ready(function() {
            //에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Dmall.DaumEditor.init();
            //emailContent 를 ID로 가지는 Textarea를 에디터로 설정
            Dmall.DaumEditor.create('emailContent');
            
            //이메일 최근 발송 내역 선택 이벤트
            $('#emailHst').on('change', function(e) {
                if(this.value == ""){
                    $("#mailTitle").val("");
                    Dmall.DaumEditor.clearContent('emailContent'); // 에디터 초기화
                }else{
                    var url = '/admin/operation/email-send-history',
                    param = {mailSendNo:this.value};

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_emailSend');
                        if(result.success){
                            $("#mailTitle").val(result.data.sendTitle);
                            Dmall.DaumEditor.setContent('emailContent', result.data.sendContent); // 에디터에 데이터 세팅
                            Dmall.DaumEditor.setAttachedImage('emailContent', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅
                        }
                    });
                }
            });
            
            // 이메일 발송
            $('#sendEmailBtn').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                //메일 제목 유효성 체크
                if($("#mailTitle").val() == ""){
                    Dmall.LayerUtil.alert("이메일 제목을 입력하여 주십시오.");
                    return;
                }
                
                //메일 내용 유효성 체크
                if(Dmall.DaumEditor.getContent('emailContent') == "" || Dmall.DaumEditor.getContent('emailContent') == null){
                    Dmall.LayerUtil.alert("이메일 내용을 입력하여 주십시오.");
                    return;
                }
                
                if(Dmall.validate.isValid('form_id_emailSend')) {
                    //에디터에서 폼으로 데이터 세팅
                    Dmall.DaumEditor.setValueToTextarea('emailContent');
                    
                    $("#curPage").val($(location).attr("protocol")+"//"+$(location).attr("host"));
                    
                    var url = '/admin/operation/email-send',
                        param = $('#form_id_emailSend').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        Dmall.validate.viewExceptionMessage(result, 'form_id_emailSend');
                        if(result.success){
                            Dmall.LayerPopupUtil.close("emailLayout");
                            Dmall.DaumEditor.clearContent('emailContent');
                            $("#emailHst").val("");
                            $('#emailHst').trigger('change');
                        }
                    });
                }
            });
            
        });
        
        //이메일 발송 레이어 팝업 실행
        function openEmailLayer(memberNo, memberNm, memberLoginId, memberEmail){
            Dmall.LayerPopupUtil.open($("#emailLayout"));
            $("#receiverNoSelect").val(memberNo);
            $("#receiverNmSelect").val(memberNm);
            $("#receiverIdSelect").val(memberLoginId);
            $("#recvEmailSelect").val(memberEmail);
            selectEmailHst();
        }
        
        //마켓포인트 내역 조회
        function selectEmailHst(){
            if(Dmall.validate.isValid('form_id_emailSend')) {
                var url = '/admin/operation/email-history',
                    param = '', 
                    callback = sendEmailHistAppend || function() {
                    };
                Dmall.AjaxUtil.getJSON(url, param, callback);
            }
        }
        
        //이메일 최근 발송 이력 셀렉트 박스에 추가
        function sendEmailHistAppend(result){
            var selectOption = ''; 
            var template = '<option value="{{mailSendNo}}">{{sendTitle}}</option>';
            sendEmailHist = new Dmall.Template(template);
            jQuery.each(result, function(idx, obj) {
                selectOption += sendEmailHist.render(obj);
            });
            $('#emailHst').append(selectOption);
            
        }
        
        </script>
    <!-- layer_popup1 -->
    <div id="emailLayout" class="layer_popup">
        <div class="pop_wrap size1">
            <!-- pop_tlt -->
            <div class="pop_tlt">
                <h2 class="tlth2">이메일 발송</h2>
                <button class="close ico_comm">닫기</button>
            </div>
            <!-- //pop_tlt -->
            <!-- pop_con -->
            <form id="form_id_emailSend" >
            <input type="hidden" id="receiverNoSelect" name="receiverNoSelect" />
            <input type="hidden" id="receiverNmSelect" name="receiverNmSelect" />
            <input type="hidden" id="receiverIdSelect" name="receiverIdSelect" />
            <input type="hidden" value="select" name="emailMember" />
            <input type="hidden" id="recvEmailSelect" name="recvEmailSelect" />
            <input type="hidden" value="${emailPossCnt}" name="emailPossCnt" id="emailPossCnt" />
            <input type="hidden" value="01" name="sendTargetCd" />
            <input type="hidden" name="curPage" id="curPage" />
            <div class="pop_con">
                <div>
                    <p class="sm_info"><strong>이메일 전송</strong></p>
                    <span class="select wid100p">
                        <label for="">최신 발송한 이메일 선택</label>
                        <select name="emailHst" id="emailHst">
                            <option value="">최신 발송한 이메일 선택</option>
                        </select>
                    </span>
                    <span class="br"></span>
                    <span class="intxt wid100p">
                        <input type="text" name="mailTitle" id="mailTitle" />
                    </span>
                    <span class="br"></span>
                    <!-- 에디트 영역 -->
                    <div class="edit">
                        <textarea id="emailContent" name="mailContent" class="blind"></textarea>
                    </div>
                    <!-- //에디트 영역 -->
                    <div class="btn_box txtc">
                        <button class="btn green" id="sendEmailBtn">발송</button>
                    </div>
                </div>
            </div>
            </form>
            <!-- //pop_con -->
        </div>
    </div>
    <!-- //layer_popup1 -->
