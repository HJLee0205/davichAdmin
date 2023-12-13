<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>

//쿠폰 레이어 팝업 실행
function openCouponLayer(memberNo, memberNm, memberLoginId, couponCnt){
    $(".coupon_num").html(couponCnt);
    $("#memberNoCpSelect").val(memberNo);
    selectCouponList();
}

//쿠폰 리스트 조회
function selectCouponList(){
    if(Dmall.validate.isValid('form_id_coupon_select')) {

        var url = '/admin/member/manage/coupon-list',
            param = $('#form_id_coupon_select').serialize(),
            dfd = $.Deferred();
        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            var tbody = '',
                template = new Dmall.Template(
                    '<tr>' +
                    '<td>{{sortNum}}</td>' +
                    '<td>{{issueDttm}}</td>' +
                    '<td>{{couponNm}}</td>' +
                    '<td>{{couponBnfValue}} {{bnfUnit}}</td>' +
                    '<td>{{couponUseLimitAmt}}원<br/>이상 구매시</td>' +
                    '<td>{{cpApplyEndDttm}}</td>' +
                    '</tr>'
                );
            jQuery.each(result.resultList, function(idx, obj) {
                tbody += template.render(obj);
            });

            if(tbody == '') {
                tbody = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
            }

            $('#couponListTbody').html(tbody);

            dfd.resolve(result.resultList);

            Dmall.GridUtil.appendPaging('form_id_coupon_select', 'coupon_list_paging', result, 'paging_id_manager', selectCouponList);
        });

        return dfd.promise();
    }
}

</script>
<!-- layer_popup1 -->
<div id="couponLayout" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">보유 쿠폰 관리</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <form id="form_id_coupon_select" >
                    <input type="hidden" id="memberNoCpSelect" name="memberNo" />
                    <input type="hidden" name="page" value="1" />
                    <h3 class="tlth3" >보유 쿠폰 :<span class="coupon_num">15</span>장</h3>
                    <div class="tblh mt0">
                        <table summary="이표는 보유 쿠폰 리스트 표 입니다. 구성은 번호, 발급일, 쿠폰명, 할인액/율, 제한금액, 유효기간, 사용일, 사용여부 입니다.">
                            <caption>보유 쿠폰 리스트</caption>
                            <colgroup>
                                <col width="8%">
                                <col width="15%">
                                <col width="20%">
                                <col width="20%">
                                <col width="12%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>NO</th>
                                <th>발급일</th>
                                <th>쿠폰명</th>
                                <th>혜택</th>
                                <th>사용제한금액</th>
                                <th>유효기간</th>
                            </tr>
                            </thead>
                            <tbody id="couponListTbody">
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblh -->
                    <!-- bottom_lay -->
                    <div class="bottom_lay">
                        <div class="pageing" id="coupon_list_paging"></div>
                    </div>
                    <!-- //bottom_lay -->
                </form>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->
