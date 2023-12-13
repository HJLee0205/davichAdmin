<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {

    
});

//sms 충전내역 레이어 팝업 실행
function openSmsChargeHisLayer(){
    selectChargeHis();
}

//충전 내역 조회
function selectChargeHis(){
//     if(Dmall.validate.isValid('form_sms_charge')) {
        
//         var url = '/admin/operation/sms-charge-info',
//             param = $('#form_sms_charge').serialize(), 
//             callback = chargeHistAppend || function() {
//             };
//         Dmall.AjaxUtil.getJSON(url, param, callback);
//     }
}

//충전 내역 테이블에 입력
function chargeHistAppend(result){
    var tbody = '', 
    template = new Dmall.Template('<tr><td>{{rownum}}</td><td>{{regDttm}}</td><td><span class="{{classNm}}">{{pointType}}</span>{{prcPoint}}</td><td>{{reasonNm}}</td><td>{{validPeriod}}</td><td>{{typeNm}}</td></tr>');
    jQuery.each(result.resultList, function(idx, obj) {
        tbody += template.render(obj);

    });
    $('#smsChargeTbody').html(tbody);
    
    Dmall.GridUtil.appendPaging('form_sms_charge', 'charge_paging', result, 'paging_id_manager', selectChargeHis);
}



</script>
<!-- layer_popup1 -->
<div id="smsCharge" class="layer_popup">
    <div class="pop_wrap size3">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">SMS 충전내역 확인하기</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <form action="" id="form_sms_charge">
                <input type="hidden" name="memberNo" id="smsChargeMemNo" value="${memberManageSO.memberNo}" />
                <input type="hidden" name="page" id="charge_page" value="1" />
                <!-- tblh -->
                <div class="tblh mt0">
                    <table summary="이표는 SMS 충전내역 확인하기 표 입니다. 구성은 순번, 결제내용, 결제방법, 결제가격, 결제일 입니다.">
                        <caption>SMS 충전내역 확인하기</caption>
                        <colgroup>
                            <col width="8%">
                            <col width="23%">
                            <col width="23%">
                            <col width="23%">
                            <col width="23%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>순번</th>
                                <th>결제내용</th>
                                <th>결제방법</th>
                                <th>결제가격</th>
                                <th>결제일</th>
                            </tr>
                        </thead>
                        <tbody id="smsChargeTbody">
                            <tr>
                                <td>1</td>
                                <td>벨몰 SMS 100 충전</td>
                                <td>카드결제</td>
                                <td>2,200원</td>
                                <td>2016-03-22 11:39</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay" id="charge_paging"></div>
                <!-- //bottom_lay -->
                </form>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->