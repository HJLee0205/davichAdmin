<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
$(document).ready(function() {

    //숫자만 입력가능
    $(document).on("keyup", "input:text[numberOnly]", function() {$(this).val( $(this).val().replace(/[^0-9]/gi,"") );});

    //사유 선택 이벤트
    $('#reasonCd').on('change', function(e) {
        if(this.value == "05"){
            $("#etcReasonSpan").show();
        }else{
            $("#etcReasonSpan").hide();
        }
    });

    //유효기간 선택 이벤트
    $('#validPeriod').on('change', function(e) {
        if(this.value == "03"){
            $("#etcValidImg").show();
            $("#etcValidSpan").show();
        }else{
            $("#etcValidImg").hide();
            $("#etcValidSpan").hide();
        }
    });

    // 마켓포인트 지급
    $('#insertBtn').on('click', function(e) {
        return;

        e.preventDefault();
        e.stopPropagation();

        //마켓포인트 처리금액 유효성 체크
        if($("#prcAmt").val() == ""){
            Dmall.LayerUtil.alert("마켓포인트를 입력하여 주십시오");
            return;
        }

        //사유 유효성 체크
        if($("#reasonCd").val() == ""){
            Dmall.LayerUtil.alert("사유를 선택하여 주십시오");
            return;
        }

        //직접입력 사유 유효성 체크
        if($("#reasonCd").val() == "05"){
            if($("#etcReason").val() == ''){
                Dmall.LayerUtil.alert("사유를 입력하여 주십시오");
                return;
            }
        }

        if($("#prcAmt").val() > 1000000000){
            Dmall.LayerUtil.alert("1회 지급/차감 마켓포인트 한도는 1,000,000,000 원 입니다. ");
            return;
        }

        //마켓포인트 유효기간 유효성 체크
        if($("#validPeriod").val() == "03"){
            if($("#etcValidPeriod").val() == ''){
                Dmall.LayerUtil.alert("유효기간을 입력하여 주십시오");
                return;
            }

            var date = new Date();
            var year  = date.getFullYear();
            var month = date.getMonth() + 1;
            var day   = date.getDate();

            if (("" + month).length == 1) {
                month = "0" + month;
            }
            if (("" + day).length   == 1) {
                day   = "0" + day;
            }

            var toDayVal = year + month + day;
            var validPeriod = $("#etcValidPeriod").val().replace(/-/gi,"");

            if(validPeriod < toDayVal){
                Dmall.LayerUtil.alert("마켓포인트 유효기간이 마켓포인트 지급/차감일보다 빠를 수 없습니다.");
                return;
            }
        }

        if($('#gbCd').val() == "10"){
            if($("#reasonCd").val() == "03" || $("#reasonCd").val() == "04"){
                Dmall.LayerUtil.alert("마켓포인트 지급 사유를 선택하여 주십시오.");
                return;
            }
        }else if($('#gbCd').val() == "20"){
            if($("#reasonCd").val() == "01" || $("#reasonCd").val() == "02"){
                Dmall.LayerUtil.alert("마켓포인트 차감 사유를 선택하여 주십시오.");
                return;
            }

            if(Number($("#savedMnVal").val()) < Number($("#prcAmt").val())){
                Dmall.LayerUtil.alert("마켓포인트 차감 금액은 보유하고 있는 금액을 초과할 수 없습니다.");
                return;
            }
        }

        if(Dmall.validate.isValid('form_id_saveMn_insert')) {

            var url = '/admin/operation/savedMnPoint/savedmoney-insert',
                param = $('#form_id_saveMn_insert').serialize();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                Dmall.LayerUtil.alert("마켓포인트가 적용되었습니다.", "알림");
                if(result.success){
                var savedMnVal =Number($("#savedMnVal").val());
                    var prcAmt =Number($("#prcAmt").val());
                    if($('#gbCd').val() == "20"){
                        $("#totPrcAmt").text(savedMnVal-prcAmt);
                        $("#savedMnVal").val(savedMnVal-prcAmt);
                    }else{
                        $("#totPrcAmt").text(savedMnVal+prcAmt);
                        $("#savedMnVal").val(savedMnVal+prcAmt);
                    }


                    selectSaveMnHis();
                }
            });
        }
    });

    // 마켓포인트 내역 조회
    $('#btnSearchPoint').on('click', function(e) {
        $("#pointPage").val("1");
        selectSaveMnHis()
    });
});

//마켓포인트 레이어 팝업 실행
function openSaveMnLayer(memberNo, prcAmt){
    Dmall.LayerPopupUtil.open($("#savedMnLayout"));
    $(".mpAmt", '#savedMnLayout').text(prcAmt);
    $('input[name=memberNo]', '#form_id_point_select').val(memberNo);
    Dmall.common.comma();
    $('#pointPage').val('1');
    selectSaveMnHis();
}

//마켓포인트 내역 조회
function selectSaveMnHis(){
    if(Dmall.validate.isValid('form_id_saveMn_select')) {
        var url = '/admin/operation/savedMnPoint/savedmoney',
            param = $('#form_id_point_select').serialize(),
            dfd = $.Deferred();

        Dmall.AjaxUtil.getJSON(url, param, function (result) {
            var tr = '';
            var template =
                    '<tr>' +
                    '<td>{{rowNum}}</td>' +
                    '<td>{{regDttm}}</td>' +
                    '<td>' +
                    '<span class="{{className}}">({{gubun}})</span>{{prcPoint}}' +
                    '</td>' +
                    '<td>{{reasonNm}}</td>' +
                    '<td>{{validPeriod}}</td>' +
                    '<td>{{typeNm}}</td>' +
                    '</tr>',
                savedMnHist = new Dmall.Template(template);

            jQuery.each(result.resultList, function(idx, obj) {
                tr += savedMnHist.render(obj);
            });

            if(tr == '') {
                tr = '<tr><td colspan="6">데이터가 없습니다.</td></tr>';
            }

            $('#pointHistBody').html(tr);
            dfd.resolve(result.resultList);

            Dmall.GridUtil.appendPaging('form_id_point_select', 'div_id_point_paging', result, 'paging_id_manager', selectSaveMnHis);

            $('.all', '#savedMnLayout').text(result.filterdRows);
        });
    }
}
</script>
<!-- layer_popup1 -->
<div id="savedMnLayout" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">포인트 관리</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <h3 class="tlth3">보유 포인트 : <span class="mpAmt comma"></span>p</h3>
            <!-- search_form -->
            <form action="" id="form_id_point_select">
                <input type="hidden" name="page" id="pointPage" value="1">
                <input type="hidden" name="memberNo">
                <div class="tblw mt0">
                    <table>
                        <colgroup>
                            <col width="15%">
                            <col width="85%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>지급/차감일</th>
                            <td>
                                <tags:calendar from="stRegDttm" to="endRegDttm" idPrefix="pointSrch"/>
                            </td>
                        </tr>
                        <tr>
                            <th>지급/차감</th>
                            <td>
                                <tags:radio codeStr=":전체;10:지급;20:차감" name="pointGbCd" idPrefix="pointGbCd1" value=""/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </form>
            <!-- //search_form -->
            <div class="btn_box txtc">
                <button class="btn green" id="btnSearchPoint">검색</button>
            </div>
            <div class="mt20">
                <div class="top_lay">
                    <div class="select_btn_left">
                        <span class="search_txt">
                            총 <strong class="all" id="cnt_total"></strong>건의 내역이 검색되었습니다.
                        </span>
                    </div>
                </div>
                <!-- tblh -->
                <div class="tblh">
                    <table>
                        <colgroup>
                            <col width="10%">
                            <col width="18%">
                            <col width="18%">
                            <col width="18%">
                            <col width="18%">
                            <col width="18%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>NO</th>
                            <th>일시</th>
                            <th>지급/차감액</th>
                            <th>사유</th>
                            <th>유효기간</th>
                            <th>자동/수동</th>
                        </tr>
                        </thead>
                        <tbody id="pointHistBody">
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <div class="pageing" id="div_id_point_paging"></div>
                </div>
                <!-- //bottom_lay -->
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->