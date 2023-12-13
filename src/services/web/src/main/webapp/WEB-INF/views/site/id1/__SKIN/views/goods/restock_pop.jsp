<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
//재입고신청
$('#btn_restock_ok').on('click',function (){
    if($('#restock_rule_check').is(':checked') == false) {
        Dmall.LayerUtil.alert("개인정보 수집에 동의하셔야 합니다.", "알림");
        return;
    }
    if(Dmall.validation.isEmpty($("#mobile01").val())||Dmall.validation.isEmpty($("#mobile02").val())||Dmall.validation.isEmpty($("#mobile03").val())) {
        Dmall.LayerUtil.alert("연락받으실 휴대전화번호를 입력해주세요.","알림");
        return false;
    }
    var url = '/front/goods/restock-notify-insert';
    var param = {goodsNo:'${vo.goodsNo}',mobile:$('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val()};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        Dmall.LayerPopupUtil.close('restock_pop');
        if(!result.success) {
            Dmall.LayerUtil.alert('재입고 알림등록에 실패하였습니다.');
        }
    });
});
</script>
<div class="popup_present_event pop_front" id="restock_pop" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">재입고 알림</h1>
        <button type="button" class="btn_close_popup" id="btn_restock_close">
        <img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기">
        </button>
    </div>
    <div class="popup_content">
        <span>* 상품 재입고 시 등록하신 휴대폰 SMS를 통해 안내드립니다.</span>
        <table class="tProduct_Insert" style="margin-top:20px">
            <caption>
                <h1 class="blind">재입고 알림팝업 입니다.</h1>
            </caption>
            <colgroup>
                <col style="width:24%">
                <col style="width:">
            </colgroup>
            <tbody>
                <tr>
                    <th class="order_tit">상품명</th>
                    <td>${vo.goodsNm}</td>
                </tr>

                <tr>
                    <th class="order_tit">휴대폰번호</th>
                    <td>
                        <div class="select_box28" style="width:69px;display:inline-block">
                            <label for="mobile01">010</label>
                            <select id="mobile01" class="select_option" title="select option">
                                <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                            </select>
                        </div>
                        -
                        <input type="text" id="mobile02" style="width:67px" maxlength="4">
                        -
                        <input type="text" id="mobile03" style="width:67px" maxlength="4">
                    </td>
                </tr>

                <tr>
                    <th class="order_tit">개인정보 수집동의</th>
                    <td>
                        <div class="qna_check">
                            <label>
                                <input type="checkbox" name="rule01_agree" id="restock_rule_check">
                                <span></span>
                            </label>
                            <label for="rule02_agree">동의합니다.</label>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="popup_btn_area">
            <button type="button" class="btn_popup_ok" id="btn_restock_ok">확인</button>
            <button type="button" class="btn_popup_cancel" id="btn_restock_cancel">닫기</button>
        </div>
    </div>
</div>