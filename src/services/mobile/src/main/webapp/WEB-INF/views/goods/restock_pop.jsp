<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    var url = '${_MOBILE_PATH}/front/goods/restock-notify-insert';
    var param = {goodsNo:'${vo.goodsNo}',mobile:$('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val()};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        Dmall.LayerPopupUtil.close('restock_pop');
        if(!result.success) {
            Dmall.LayerUtil.alert('재입고 알림등록에 실패하였습니다.');
        }
    });
});
</script>
<div class="popup_present_event" id="restock_pop" style="display: none;">
    <div class="popup_header">
        <h1 class="popup_tit">재입고 알림</h1>
        <button type="button" class="btn_close_popup" id="btn_restock_close">
        <img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기">
        </button>
    </div>
    <div class="popup_content">
        <ul class="popup_comment">
			<li>상품 재입고 시 등록하신 휴대폰 SMS를 통해 안내드립니다.</li>
		</ul>
        <table class="tProduct_Insert">
            <caption>
                <h1 class="blind">재입고 알림팝업 입니다.</h1>
            </caption>
            <tbody>
                <tr>
                    <th class="order_tit">상품명</th>
				</tr>
				<tr>
                    <td>${vo.goodsNm}</td>
                </tr>

                <tr>
                    <th class="order_tit">알림 받으실 연락처</th>
				</tr>
				<tr>
                    <td>
                        <div style="display:inline-block">
                            <select id="mobile01" title="select option" style="width:60px">
                                <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                            </select>
                        </div> - <input type="text" id="mobile02" style="width:60px" maxlength="4"> - <input type="text" id="mobile03" style="width:60px" maxlength="4">
                    </td>
                </tr>

                <tr>
                    <td style="border-bottom:none; padding-top:20px; text-align:center;">
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="rule01_agree" id="restock_rule_check">
                                <span></span>
								개인정보 수집에 동의합니다.
                            </label>
                            <!-- <label for="rule02_agree">개인정보 수집에 동의합니다.</label> -->
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