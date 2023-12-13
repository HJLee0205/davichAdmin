<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="cd" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">홈 &gt; 프로모션 &gt; 할인쿠폰 &gt; 할인쿠폰 등록</t:putAttribute>
    <t:putAttribute name="style">
        <style>
            .minus {
                width: 18px !important;
                height: 18px !important;
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            // 쿠폰 시작일시 종료일시
            var $srch_sc01 = $("#srch_sc01");
            var $srch_sc02 = $("#srch_sc02");
            var $srch_from_hour = $("#srch_from_hour");
            var $srch_to_hour = $("#srch_to_hour");
            var $srch_from_minute = $("#srch_from_minute");
            var $srch_to_minute = $("#srch_to_minute");

            jQuery(document).ready(function() {

                // 저장
                jQuery('#reg_btn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if( $("#couponNm").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰명을 입력하세요");
                        $("#couponNm").focus();
                        return;
                    }
                    /*if( $("#couponDscrt").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰설명을 입력하세요");
                        $("#couponDscrt").focus();
                        return;
                    }*/
                    if( $("#couponUseLimitAmt").val() == ""){
                        Dmall.LayerUtil.alert("최소결제금액을 입력하세요");
                        $("#couponUseLimitAmt").focus();
                        return;
                    }

                    //쿠폰종류가 '생일자쿠폰' '신규회원가입쿠폰'인 경우 유효기간 조건 점검
                    if( $("#couponKindCd").val() == '03'  ){ /*|| $("#couponKindCd").val() == '04'*/
                        if( $("input[name='couponApplyPeriodCd']:checked").val() == '01' ){
                            Dmall.LayerUtil.alert("유효기간조건을 발급일 기준으로만 등록가능한 쿠폰입니다.");
                            return;
                        }
                    }

                    //유효기간 체크 : 시작일시 종료일시 크기 비교, 체크해놓고 발급일로부터 몇일 공백 시 경고.
                    if(periodCheck() == false){
                        return;
                    }

                    //쿠폰혜택 체크 : 선택안된 라디오버튼 하위 text값 삭제
                    if( $('#couponKindCd').val() != '97') {
                        if(bnfCdCheck() == false){
                            return;
                        };
                    }

                    //적용조건 체크 : 전체 적용 예외, 체크박스 체크에 따른 선택한 상품과 카테고리 점검
                    if(applyConditionCheck()  == false){
                        return false;
                    };

                    //숫자에 콤마 없애고 넘기기
                    if(delComma() == false){
                        return;
                    }

                    if( $("#cpLoadrate").val()*1 > 100){
                        Dmall.LayerUtil.alert("본사 부담율은 최대 100% 입니다")
                        return;
                    }

                    if(Dmall.validate.isValid('form_coupon_insert')) {
                        var url = '/admin/promotion/coupon-info-insert';
                        var param = jQuery('#form_coupon_insert').serialize();
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Dmall.FormUtil.submit('/admin/promotion/coupon');
                            } else {
                                Dmall.validate.viewExceptionMessage(result, 'form_coupon_insert');
                            }
                        });
                    }
                });


                // 쿠폰종류 변경 시, 그에 맞는 쿠폰상세정보로 바꾸기
                $("#couponKindCd").change(function(){
                    var checked = $(this).val();
                    $("#option_content_total td").hide();
                    $("#option_content_" + checked).show();

                    // 쿠폰종류가 '생일자쿠폰' 또는 '신규회원가입쿠폰'이면 유효기간조건을 발급일 기준으로 선택
                    if(checked == '03' ){ /*|| checked == '04'*/
                        $("#fromToPeriod").parents("label").removeClass('on');
                        $("#issueAfPeriod").parents("label").addClass('on');
                        $("input[name='couponApplyPeriodCd']:checked").prop('value', '02');
                    }else{
                        if(checked == '07'){
                            $('#periodLayer_01').hide();
                            $('#periodLayer_02').show();
                            $("#fromToPeriod").parents("label").removeClass('on');
                            $("#issueAfPeriod").parents("label").removeClass('on');
                            $("#confirmAfPeriod").parents("label").addClass('on');
                            $("input[name='couponApplyPeriodCd']:checked").prop('value', '03');
                        }else{
                            $('#periodLayer_01').show();
                            $('#couponApplyConfirmAfPeriod').val(0);
                            $('#periodLayer_02').hide();

                            $("#fromToPeriod").parents("label").addClass('on');
                            $("#issueAfPeriod").parents("label").removeClass('on');
                            $("input[name='couponApplyPeriodCd']:checked").prop('value', '01');
                        }


                    }

                    /* 유효기간 조건 라디오버튼을 숨기려했으나 기간표시하는 물결표시(~)가 태그에 쌓여있지 않아 포기.
                      if(checked == '03' || checked == '04'){
                      $("#fromToPeriod").parents('label').hide()
                      $("#fromToPeriod").parents('label').siblings().hide()
                      $("#fromToPeriod").parents('label').siblings().eq(9).show()
                      $("#fromToPeriod").parents('label').siblings().eq(10).show()
                    } else {
                      $("#fromToPeriod").parents('label').show()
                      $("#fromToPeriod").parents('label').siblings().show()
                    } */

                    $('.trPresentCoupon').show();
                    $('label[for="applyGoods"]').show();
                    $('label[for="totalGoods"]').show();
                    $('label[for="couponTargetExpt"]').show();
                    $('label[for="applyCtg"]').show();
                    $('#apply_select_ctg').show();

                    // 쿠폰종류가 '오프라인쿠폰'이면 예약전용쿠폰 여부 항목 노출
                    if(checked == '99'){
                        $('#trRsvOnly').show();
                        $('.trPresentCoupon').show();
                    }else if(checked == '97'){
                        $('#trRsvOnly').hide();
                        $('.trPresentCoupon').hide();

                        $("#couponSoloUseN").parents("label").removeClass('on');
                        $("#couponSoloUseY").parents("label").addClass('on');
                        $("input[name='couponSoloUseYn']:checked").prop('value', 'Y');
                        $("#couponUseLimitAmt").prop('value', 0);
                        $("#couponBnfValue").prop('value', 0);
                        $("#bnfDcAmt01").prop('value', 0);
                        $("#bnfDcAmt02").prop('value', 0);
                        $("#bnfDcAmt03").prop('value', '');

                        $('label[for="couponTargetApply"]').click();

                        $('label[for="applyGoods"]').hide();
                        if(!$('label[for="applyGoods"]').hasClass('on')){
                            $('label[for="applyGoods"]').click();
                        }
                        if(!$('label[for="rsvOnlyYn"]').hasClass('on')){
                            $('label[for="rsvOnlyYn"]').click();
                        }
                        if(!$('label[for="offlineOnlyYn"]').hasClass('on')){
                            $('label[for="offlineOnlyYn"]').click();
                        }

                        $('label[for="totalGoods"]').hide();
                        $('label[for="couponTargetExpt"]').hide();
                        $('label[for="applyCtg"]').hide();
                        $('#apply_select_ctg').hide();

                    }else{
                        $('#trRsvOnly').hide();
                        $('.trPresentCoupon').show();
                    }

                });

                // 쿠폰수량 옵션 변경 시, 제한수량 텍스트박스 보여주기/감추기
                $("#couponQttLimitCd").change(function(){
                    if( $(this).val() == '02' ){
                        $(".couponQttLimitCntDisplay").show();
                    } else {
                        $(".couponQttLimitCntDisplay").hide();
                        $("#couponQttLimitCnt").attr("value", "0")
                    }
                });

                // % 할인혜택 텍스트상자에 포커싱
                jQuery("#couponBnfValue, #bnfDcAmt01").on('focus', function(){
                    //해당 라디오버튼 미선택 시, 경고
                    if( $("#priceDc").parents("label").hasClass('on') ) {
                        Dmall.LayerUtil.alert("라디오버튼을 체크하지 않았습니다");
                        return;
                    }
                });

                // 금액 할인혜택 텍스트상자에 포커싱
                jQuery("#bnfDcAmt02").on('focus', function(){
                    //해당 라디오버튼 미선택 시, 경고
                    if( $("#percentDc").parents("label").hasClass('on') ) {
                        Dmall.LayerUtil.alert("라디오버튼을 체크하지 않았습니다");
                        return;
                    }
                });

                // 유효기간 '일월일' 텍스트상자 또는 셀렉트박스에 포커싱
                jQuery("#srch_sc01, #srch_from_hour, #srch_from_minute, #srch_sc02, #srch_to_hour, #srch_to_minute").on('focus', function(){
                    // '생일자 쿠폰' '회원가입쿠폰' 선택 시 경고창 띄우기
                    if( $("#couponKindCd").val() == '03' ){ /*|| $("#couponKindCd").val() == '04'*/
                        Dmall.LayerUtil.alert("해당 쿠폰은 유효기간조건을 발급일 기준으로만 등록가능한 쿠폰입니다.");
                        return;
                    }

                    //해당 라디오버튼 미선택 시, 경고
                    if( $("#issueAfPeriod").parents("label").hasClass('on') ) {
                        Dmall.LayerUtil.alert("라디오버튼을 체크하지 않았습니다");
                        return;
                    }
                });

                // 유효기간 '발급일 기준' 텍스트상자에 포커싱
                jQuery("#couponApplyIssueAfPeriod").on('focus', function(){
                    //해당 라디오버튼 미선택 시, 경고
                    if( $("#fromToPeriod").parents("label").hasClass('on') ) {
                        Dmall.LayerUtil.alert("라디오버튼을 체크하지 않았습니다");
                        return;
                    }
                });

                // 숫자만 입력하게 만들기 : 쿠폰수량, 쿠폰혜택 %할인, 쿠폰혜택 최대금액, 쿠폰혜택 금액할인, 일동안 사용가능, 최소결제금액
                $('#couponQttLimitCnt, #couponBnfValue, #bnfDcAmt01, #bnfDcAmt02, #couponApplyIssueAfPeriod,#couponApplyConfirmAfPeriod, #couponUseLimitAmt, #cpLoadrate').on('focus', function () {
                    onlyNumberInput($(this));
                });
                // 숫자에 천단위로 콤마 찍기
                $('#couponQttLimitCnt, #couponBnfValue, #bnfDcAmt01, #bnfDcAmt02, #couponApplyIssueAfPeriod,#couponApplyConfirmAfPeriod, #couponUseLimitAmt').mask("#,##0", {reverse : true, maxlength : false});

                // 적용
                // 초기화
                getCategoryOptionValue('1', jQuery('#sel_ctg_1'));

                // 예외
                // 초기화
                getExptCategoryOptionValue('1', jQuery('#expt_sel_ctg_1'));

                // 적용
                // 카테고리1 변경시 이벤트
                jQuery('#sel_ctg_1').on('change', function(e) {
                    changeCategoryOptionValue('2', $(this));
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_2_def').focus();
                });
                // 적용
                // 카테고리2 변경시 이벤트
                jQuery('#sel_ctg_2').on('change', function(e) {
                    changeCategoryOptionValue('3', $(this));
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_3_def').focus();
                });
                // 적용
                // 카테고리3 변경시 이벤트
                jQuery('#sel_ctg_3').on('change', function(e) {
                    changeCategoryOptionValue('4', $(this));
                    jQuery('#opt_ctg_4_def').focus();
                });


                // 예외
                // 카테고리1 변경시 이벤트
                jQuery('#expt_sel_ctg_1').on('change', function(e) {
                    changeExptCategoryOptionValue('2', $(this));
                    changeExptCategoryOptionValue('3', $(this));
                    changeExptCategoryOptionValue('4', $(this));
                    jQuery('#expt_opt_ctg_2_def').focus();
                });
                // 예외
                // 카테고리2 변경시 이벤트
                jQuery('#expt_sel_ctg_2').on('change', function(e) {
                    changeExptCategoryOptionValue('3', $(this));
                    changeExptCategoryOptionValue('4', $(this));
                    jQuery('#expt_opt_ctg_3_def').focus();
                });
                // 예외
                // 카테고리3 변경시 이벤트
                jQuery('#expt_sel_ctg_3').on('change', function(e) {
                    changeExptCategoryOptionValue('4', $(this));
                    jQuery('#expt_opt_ctg_4_def').focus();
                });



                // 적용
                // 카테고리선택btn 클릭시 이벤트
                $('#ctg_sel_btn').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    if( !$("#applyCtg").parent().hasClass('on') ){
                        Dmall.LayerUtil.alert("[카테고리 검색]을 체크하지 않았습니다");
                        return false;
                    };
                    writeCategoryOptionValue();
                });

                // 예외
                // 카테고리선택btn 클릭시 이벤트
                $('#expt_ctg_sel_btn').on('click', function(e){
                    Dmall.EventUtil.stopAnchorAction(e);

                    if( !$("#exptCtg").parent().hasClass('on') ){
                        Dmall.LayerUtil.alert("[카테고리 선택]을 체크하지 않았습니다");
                        return false;
                    };
                    writeExptCategoryOptionValue();
                });

                // 적용
                // 상품 검색
                jQuery('#apply_goods_srch_btn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if( $(".radio_b input[name='couponApplyTargetCd']:checked").val() != '01' ){
                        Dmall.LayerUtil.alert("[상품검색]을 체크하지 않았습니다");
                        return false;
                    };
                    Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                    GoodsSelectPopup._init( fn_callback_pop_apply_goods );
                    $("#btn_popup_goods_search").trigger("click");
                });

                // 예외
                // 상품 검색
                jQuery('#expt_goods_srch_btn').on('click', function(e) {
                    Dmall.EventUtil.stopAnchorAction(e);

                    if( $(".radio_c input[name='couponApplyTargetCd']:checked").val() != '01' ){
                        Dmall.LayerUtil.alert("[상품검색]을 체크하지 않았습니다");
                        return false;
                    };
                    Dmall.LayerPopupUtil.open(jQuery('#layer_popup_goods_select'));
                    GoodsSelectPopup._init( fn_callback_pop_expt_goods );
                    $("#btn_popup_goods_search").trigger("click");
                });

                // 공통
                // 선택한 상품 또는 카테고리 삭제btn 클릭시 이벤트
                jQuery(document).on("click", "button[name='minus_btn']", function(e){
                    var $minus_btn = $("button[name='minus_btn']")
                    var i = $minus_btn.index(this);
                    $minus_btn.eq(i).parent().remove()
                    if($("#sel_apply_goods_list").children().length == 0){
                        $("#sel_apply_goods_list").removeClass("display_block")
                    }
                    if($("#sel_apply_ctg_list").children().length == 0){
                        $("#sel_apply_ctg_list").removeClass("display_block")
                    }
                    if($("#sel_expt_goods_list").children().length == 0){
                        $("#sel_expt_goods_list").removeClass("display_block")
                    }
                    if($("#sel_expt_ctg_list").children().length == 0){
                        $("#sel_expt_ctg_list").removeClass("display_block")
                    }
                });

                // 목록
                $('#btn_list').on('click', function () {
                    Dmall.FormUtil.submit('/admin/promotion/coupon');
                });
            });

            // 적용
            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeCategoryOptionValue(level, $target) {
                var $sel = $('#sel_ctg_' + level);
                var $label = $('label[for=sel_ctg_' + level + ']', '#apply_select_ctg');

                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                if ( level && level == '2' && $target.attr('id') == 'sel_ctg_1') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '3' && $target.attr('id') == 'sel_ctg_2') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '4' && $target.attr('id') == 'sel_ctg_3') {
                    getCategoryOptionValue(level, $sel, $target.val());
                } else {
                    return;
                }
            }

            // 예외
            // 상위 카테고리 설정에 따른 하위 카테고리 옵션값 변경
            function changeExptCategoryOptionValue(level, $target) {
                var $sel = $('#expt_sel_ctg_' + level);
                var $label = $('label[for=expt_sel_ctg_' + level + ']', '#expt_select_ctg');

                $sel.find('option').not(':first').remove();
                $label.text( $sel.find("option:first").text() );

                if ( level && level == '2' && $target.attr('id') == 'expt_sel_ctg_1') {
                    getExptCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '3' && $target.attr('id') == 'expt_sel_ctg_2') {
                    getExptCategoryOptionValue(level, $sel, $target.val());
                } else if ( level && level == '4' && $target.attr('id') == 'expt_sel_ctg_3') {
                    getExptCategoryOptionValue(level, $sel, $target.val());
                } else {
                    return;
                }
            }


            // 적용
            // 하위 카테고리 정보 취득
            function getCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl},
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });
                    dfd.resolve(result.resultList);
                });
                return dfd.promise();
            }

            // 예외
            // 하위 카테고리 정보 취득
            function getExptCategoryOptionValue(ctgLvl, $sel, upCtgNo) {
                if (ctgLvl != '1' && upCtgNo == '') {
                    return;
                }
                var url = '/admin/goods/goods-category-list',
                    param = {'upCtgNo' : upCtgNo, 'ctgLvl' : ctgLvl},
                    dfd = jQuery.Deferred();

                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if (result == null || result.success != true) {
                        return;
                    }
                    // 취득결과 셋팅
                    jQuery.each(result.resultList, function(idx, obj) {
                        $sel.append('<option id="expt_opt_ctg_'+ ctgLvl + '_' + idx +'" value="'+ obj.ctgNo + '">' + obj.ctgNm + '</option>');
                    });
                    dfd.resolve(result.resultList);
                });
                return dfd.promise();
            }

            // 적용
            // 선택한 카테고리 값, 화면에 표시하기
            function writeCategoryOptionValue(){
                var $ctg_lev_1_text = $("#sel_ctg_1 option:selected").text();
                var $ctg_lev_2_text = $("#sel_ctg_2 option:selected").text();
                var $ctg_lev_3_text = $("#sel_ctg_3 option:selected").text();
                var $ctg_lev_4_text = $("#sel_ctg_4 option:selected").text();

                var $ctg_lev_1_val = $("#sel_ctg_1 option:selected").val();
                var $ctg_lev_2_val = $("#sel_ctg_2 option:selected").val();
                var $ctg_lev_3_val = $("#sel_ctg_3 option:selected").val();
                var $ctg_lev_4_val = $("#sel_ctg_4 option:selected").val();

                var $sel_apply_ctg_list = $("#sel_apply_ctg_list");

                if($ctg_lev_1_text == "1차 카테고리"){
                    Dmall.LayerUtil.alert("카테고리를 선택하세요!")
                } else if($ctg_lev_1_text != "1차 카테고리" && $ctg_lev_2_text == "2차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_apply_ctg_list.children('li').children('input').length; i++){
                        if( $sel_apply_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_1_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_apply_ctg_list.addClass("display_block");
                    $sel_apply_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "<input type='hidden' name='applyCtgNoArr' value='" + $ctg_lev_1_val + "'/></li>");
                } else if($ctg_lev_2_text != "2차 카테고리" && $ctg_lev_3_text == "3차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_apply_ctg_list.children('li').children('input').length; i++){
                        if( $sel_apply_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_2_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_apply_ctg_list.addClass("display_block");
                    $sel_apply_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "<input type='hidden' name='applyCtgNoArr' value='" + $ctg_lev_2_val + "'/></li>");
                } else if($ctg_lev_3_text != "3차 카테고리" && $ctg_lev_4_text == "4차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_apply_ctg_list.children('li').children('input').length; i++){
                        if( $sel_apply_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_3_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_apply_ctg_list.addClass("display_block");
                    $sel_apply_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_3_text +"<input type='hidden' name='applyCtgNoArr' value='" + $ctg_lev_3_val + "'/></li>");
                } else{
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_apply_ctg_list.children('li').children('input').length; i++){
                        if( $("#sel_apply_ctg_list").children('li').children('input').eq(i).prop('value') == $ctg_lev_4_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_apply_ctg_list.addClass("display_block");
                    $sel_apply_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_3_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_4_text + "<input type='hidden' name='applyCtgNoArr' value='" + $ctg_lev_4_val + "'/></li>");
                }
            }

            // 예외
            // 선택한 카테고리 값, 화면에 표시하기
            function writeExptCategoryOptionValue(){
                var $ctg_lev_1_text = $("#expt_sel_ctg_1 option:selected").text();
                var $ctg_lev_2_text = $("#expt_sel_ctg_2 option:selected").text();
                var $ctg_lev_3_text = $("#expt_sel_ctg_3 option:selected").text();
                var $ctg_lev_4_text = $("#expt_sel_ctg_4 option:selected").text();

                var $ctg_lev_1_val = $("#expt_sel_ctg_1 option:selected").val();
                var $ctg_lev_2_val = $("#expt_sel_ctg_2 option:selected").val();
                var $ctg_lev_3_val = $("#expt_sel_ctg_3 option:selected").val();
                var $ctg_lev_4_val = $("#expt_sel_ctg_4 option:selected").val();

                var $sel_expt_ctg_list = $("#sel_expt_ctg_list");

                if($ctg_lev_1_text == "1차 카테고리"){
                    Dmall.LayerUtil.alert("카테고리를 선택하세요!")
                } else if($ctg_lev_1_text != "1차 카테고리" && $ctg_lev_2_text == "2차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_expt_ctg_list.children('li').children('input').length; i++){
                        if( $sel_expt_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_1_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_expt_ctg_list.addClass("display_block");
                    $sel_expt_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "<input type='hidden' name='exceptCtgNoArr' value='" + $ctg_lev_1_val + "'/></li>");
                } else if($ctg_lev_2_text != "2차 카테고리" && $ctg_lev_3_text == "3차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_expt_ctg_list.children('li').children('input').length; i++){
                        if( $sel_expt_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_2_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_expt_ctg_list.addClass("display_block");
                    $sel_expt_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "<input type='hidden' name='exceptCtgNoArr' value='" + $ctg_lev_2_val + "'/></li>");
                } else if($ctg_lev_3_text != "3차 카테고리" && $ctg_lev_4_text == "4차 카테고리"){
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_expt_ctg_list.children('li').children('input').length; i++){
                        if( $sel_expt_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_3_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_expt_ctg_list.addClass("display_block");
                    $sel_expt_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_3_text +"<input type='hidden' name='exceptCtgNoArr' value='" + $ctg_lev_3_val + "'/></li>");
                } else{
                    // 선택 중복 체크
                    for(var i = 0; i <= $sel_expt_ctg_list.children('li').children('input').length; i++){
                        if( $sel_expt_ctg_list.children('li').children('input').eq(i).prop('value') == $ctg_lev_4_val ){
                            Dmall.LayerUtil.alert("이미 선택하셨습니다");
                            return false;
                        }
                    }
                    $sel_expt_ctg_list.addClass("display_block");
                    $sel_expt_ctg_list.append("<li class='fc_pr1 fs_pr1'><button name='minus_btn' type='button' class='minus btn_comm pr_minus'></button>"
                        + $ctg_lev_1_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_2_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_3_text + "&nbsp;&gt;&nbsp;" + $ctg_lev_4_text + "<input type='hidden' name='exceptCtgNoArr' value='" + $ctg_lev_4_val + "'/></li>");
                }
            }

            // 적용
            // 상품 팝업 리턴 콜백함수
            function fn_callback_pop_apply_goods(data) {
                var $sel_apply_goods_list = $("#sel_apply_goods_list");
                // 선택 중복 체크
                for(var i = 0; i <= $sel_apply_goods_list.children('li').children('input').length; i++){
                    if( $sel_apply_goods_list.children('li').children('input').eq(i).prop('value') == data['goodsNo']){
                        Dmall.LayerUtil.alert("이미 선택하셨습니다");
                        return false;
                    }
                }

                var template  = "";
                template += "<li class='pr_thum'>";
                template +=       "<button name='minus_btn' type='button' class='minus btn_comm mr20'></button>";
                template +=       "<img src='${_IMAGE_DOMAIN}" + data["goodsImg02"] + "' width='82' height='82' alt='상품이미지'/><br/>";
                template +=       "<input type='text' value='" + data["goodsNm"] + "' readonly/>";
                template +=       "<input type='hidden' value='" + data["goodsNo"] + "' name='applyGoodsNoArr' readonly/>";
                template += "</li>";

                $sel_apply_goods_list.addClass("display_block");
                $sel_apply_goods_list.append(template);
            }

            // 예외
            // 상품 팝업 리턴 콜백함수
            function fn_callback_pop_expt_goods(data) {
                //alert('상품 선택 팝업 리턴 결과 :' + data["goodsNo"] + ', data :' + JSON.stringify(data));
                var $sel_expt_goods_list = $("#sel_expt_goods_list");
                // 선택 중복 체크
                for(var i = 0; i <= $sel_expt_goods_list.children('li').children('input').length; i++){
                    if( $sel_expt_goods_list.children('li').children('input').eq(i).prop('value') == data['goodsNo']){
                        Dmall.LayerUtil.alert("이미 선택하셨습니다");
                        return false;
                    }
                }

                var template  = "";
                template += "<li class='pr_thum'>";
                template +=       "<button name='minus_btn' type='button' class='minus btn_comm'></button>";
                template +=       "<img src='${_IMAGE_DOMAIN}" + data["goodsImg02"] + "' width='82' height='82' alt='상품이미지'/><br/>";
                template +=       "<input type='text' value='" + data["goodsNm"] + "' readonly/>";
                template +=       "<input type='hidden' value='" + data["goodsNo"] + "' name='exceptGoodsNoArr' readonly/>";
                template += "</li>";

                $sel_expt_goods_list.addClass("display_block");
                $sel_expt_goods_list.append(template);
            }

            // 쿠폰혜택값 체크
            function bnfCdCheck() {
                // %할인이 혜택
                if( $("input[name='couponBnfCd']:checked").val() == '01' ){
                    if( $("#couponBnfValue").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰 혜택 %를 입력 해주세요");
                        return false;
                    } else if( $("#couponBnfValue").val() == 0 ){
                        Dmall.LayerUtil.alert("할인률은 0이 될 수 없습니다.");
                        return false;
                    } else if( $("#couponBnfValue").val() > 100 ){
                        Dmall.LayerUtil.alert("할인률은 100%를 넘을 수 없습니다.");
                        return false;
                    } else if( $("#bnfDcAmt01").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰 최대혜택 금액을 입력 해주세요");
                        return false;
                    } else if( $("#bnfDcAmt01").val() == 0){
                        Dmall.LayerUtil.alert("쿠폰 최대혜택 금액은 0이 될 수 없습니다.");
                        return false;
                    } else {
                        $("#bnfDcAmt02").prop('value', 0);
                        $("#bnfDcAmt03").prop('value', '');
                    }
                }
                // 금액할인이 혜택
                if( $("input[name='couponBnfCd']:checked").val() == '02' ){
                    if( $("#bnfDcAmt02").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰 혜택 금액을 입력 해주세요");
                        return false;
                    } else if( $("#bnfDcAmt02").val() == 0){
                        Dmall.LayerUtil.alert("쿠폰 혜택 금액은 0이 될 수 없습니다.");
                        return false;
                    } else{
                        $("#couponBnfValue").prop('value', 0);
                        $("#bnfDcAmt01").prop('value', 0);
                        $("#bnfDcAmt03").prop('value', '');
                    }
                }

                if( $("input[name='couponBnfCd']:checked").val() == '03' ){
                    if( $("#bnfDcAmt03").val() == ""){
                        Dmall.LayerUtil.alert("쿠폰 혜택 내용을 입력 해주세요");
                        return false;
                    } else{
                        $("#bnfDcAmt01").prop('value', 0);
                        $("#bnfDcAmt02").prop('value', 0);
                        $("#couponBnfValue").prop('value', 0);
                    }
                }
            }

            // 유효기간 체크
            function periodCheck() {
                if( $("input[name='couponApplyPeriodCd']:checked").val() == '01' ){
                    if($srch_sc01.val() == '' || $srch_sc01.val() == null || $srch_sc02.val() == '' || $srch_sc02.val() == null) {
                        Dmall.LayerUtil.alert("기간을 선택해주세요");
                        return false;
                    } else if($srch_sc01.val() > $srch_sc02.val()){
                        Dmall.LayerUtil.alert("시작날짜가 종료날짜보다 큽니다.");
                        return false;
                    } else if($srch_sc01.val() == $srch_sc02.val()){
                        if($srch_from_hour.val() > $srch_to_hour.val()){
                            Dmall.LayerUtil.alert("시작시간이 종료시간보다 큽니다.");
                            return false;
                        } else if($srch_from_hour.val() == $srch_to_hour.val()){
                            if($srch_from_minute.val() >= $srch_to_minute.val()){
                                Dmall.LayerUtil.alert("시작시간이 종료시간보다 크거나 같습니다.");
                                return false;
                            }
                        } else {
                            $("#couponApplyIssueAfPeriod").prop('value', 0);
                            $("#couponApplyConfirmAfPeriod").prop('value', 0);

                        }
                    } else {
                        $("#couponApplyIssueAfPeriod").prop('value', 0);
                        $("#couponApplyConfirmAfPeriod").prop('value', 0);

                    }
                }
                if( $("input[name='couponApplyPeriodCd']:checked").val() == '02' ){

                    $("#couponApplyConfirmAfPeriod").prop('value', 0);

                    if( $("#couponApplyIssueAfPeriod").val() == ""){
                        Dmall.LayerUtil.alert("발급일로부터 사용가능한 일 수를 입력 해주세요");
                        return false;
                    }
                    if( $("#couponApplyIssueAfPeriod").val() == 0){
                        Dmall.LayerUtil.alert("0은 입력할 수 없습니다.");
                        return false;
                    }
                }

                if( $("input[name='couponApplyPeriodCd']:checked").val() == '03' ){

                    $("#couponApplyIssueAfPeriod").prop('value', 0);

                    if( $("#couponApplyConfirmAfPeriod").val() == ""){
                        Dmall.LayerUtil.alert("구매확정일 로부터 사용가능한 일 수를 입력 해주세요");
                        return false;
                    }
                    if( $("#couponApplyConfirmAfPeriod").val() == 0){
                        Dmall.LayerUtil.alert("0은 입력할 수 없습니다.");
                        return false;
                    }
                }
            }

            // 적용조건 체크
            function applyConditionCheck(){
                //전체 start
                if( $("#totalGoods").parents('label').hasClass('on') ){
                    // 사용가능 체크박스 해제 : 상품, 카테고리
                    // 사용불가 체크박스 해제 : 상품, 카테고리
                    $("input[name='couponApplyTargetCd']").parent().removeClass('on')
                    $(".radio_b input[name='couponApplyTargetCd']").attr("checked", false)
                    $(".radio_c input[name='couponApplyTargetCd']").attr("checked", false)
                }
                //전체 end

                //특정 상품/카테고리 사용 가능 start
                if( $("#couponTargetApply").parents('label').hasClass('on') ){

                    var applyGoodsOn = $("#applyGoods").parent().hasClass('on')
                    var applyCtgOn = $("#applyCtg").parent().hasClass('on')

                    if( !applyGoodsOn && !applyCtgOn){
                        Dmall.LayerUtil.alert("상품 또는 카테고리를 체크해주세요.");
                        return false;
                    }

                    if( applyGoodsOn && !applyCtgOn ){
                        if( $("#sel_apply_goods_list").children().length == "0"){
                            Dmall.LayerUtil.alert("상품을 선택하지 않았습니다.");
                            return false;
                        };
                    } else if( !applyGoodsOn && applyCtgOn ){
                        if( $("#sel_apply_ctg_list").children().length == "0"){
                            Dmall.LayerUtil.alert("카테고리를 선택하지 않았습니다.");
                            return false;
                        };
                    }

                    if( applyGoodsOn && applyCtgOn){
                        if( $("#sel_apply_goods_list").children().length == "0"){
                            Dmall.LayerUtil.alert("상품을 선택하지 않았습니다.");
                            return false;
                        };
                        if( $("#sel_apply_ctg_list").children().length == "0"){
                            Dmall.LayerUtil.alert("카테고리를 선택하지 않았습니다.");
                            return false;
                        };
                    }
                    // 사용불가 체크박스 해제 : 상품, 카테고리
                    $(".radio_c input[name='couponApplyTargetCd']").parent().removeClass('on')
                    $(".radio_c input[name='couponApplyTargetCd']").attr("checked", false)
                }
                //특정 상품/카테고리 사용 가능 end

                //특정 상품/카테고리 사용 불가 start
                if( $("#couponTargetExpt").parents('label').hasClass('on') ){

                    var exptGoodsOn = $("#exptGoods").parent().hasClass('on')
                    var exptCtgOn = $("#exptCtg").parent().hasClass('on')

                    if( !exptGoodsOn && !exptCtgOn){
                        Dmall.LayerUtil.alert("상품 또는 카테고리를 체크해주세요.");
                        return false;
                    }

                    if( exptGoodsOn && !exptCtgOn ){
                        if( $("#sel_expt_goods_list").children().length == "0"){
                            Dmall.LayerUtil.alert("상품을 선택하지 않았습니다.");
                            return false;
                        };
                    } else if( !exptGoodsOn && exptCtgOn ){
                        if( $("#sel_expt_ctg_list").children().length == "0"){
                            Dmall.LayerUtil.alert("카테고리를 선택하지 않았습니다.");
                            return false;
                        };
                    }

                    if( exptGoodsOn && exptCtgOn){
                        if( $("#sel_expt_goods_list").children().length == "0"){
                            Dmall.LayerUtil.alert("상품을 선택하지 않았습니다.");
                            return false;
                        };
                        if( $("#sel_expt_ctg_list").children().length == "0"){
                            Dmall.LayerUtil.alert("카테고리를 선택하지 않았습니다.");
                            return false;
                        };
                    }
                    // 사용가능 체크박스 해제 : 상품, 카테고리
                    $(".radio_b input[name='couponApplyTargetCd']").parent().removeClass('on')
                    $(".radio_b input[name='couponApplyTargetCd']").attr("checked", false)
                }
                //특정 상품/카테고리 사용 불가 end
            }

            // 숫자만 입력 가능하게 하기
            function onlyNumberInput(obj){
                obj.on('keydown', function (event) {
                    event = event || window.event;
                    var keyID = (event.which) ? event.which : event.keyCode;
                    // 48 ~ 57 일반숫자키 0~9,  96~105 키보드 우측 숫자키패드,  백스페이스 8, 탭 9, end 35, home 36, 왼쪽 방향키 37, 오른쪽 방향키 39, 인서트 45, 딜리트 46, 넘버락 144
                    if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 ){
                        return;
                    } else {
                        return false;
                    }
                });
                obj.on('keyup', function (event) {
                    event = event || window.event;
                    var keyID = (event.which) ? event.which : event.keyCode;
                    if ( keyID == 8 || keyID == 9 || keyID == 35 || keyID == 36 || keyID == 37 || keyID == 39 || keyID == 45 || keyID == 46 || keyID == 144 || keyID == 144 ){
                        return;
                    }
                });
            }

            // 숫자에 콤마 없애기( 자바단에 넘기기 직전 )
            function delComma(){
                $('#couponQttLimitCnt').val( $('#couponQttLimitCnt').val().trim().replaceAll(',', '') )
                $('#couponBnfValue').val( $('#couponBnfValue').val().trim().replaceAll(',', '') )
                $('#bnfDcAmt01').val( $('#bnfDcAmt01').val().trim().replaceAll(',', '') )
                $('#bnfDcAmt02').val( $('#bnfDcAmt02').val().trim().replaceAll(',', '') )
                $('#couponApplyIssueAfPeriod').val( $('#couponApplyIssueAfPeriod').val().trim().replaceAll(',', '') )
                $('#couponApplyConfirmAfPeriod').val( $('#couponApplyConfirmAfPeriod').val().trim().replaceAll(',', '') )
                $('#couponUseLimitAmt').val( $('#couponUseLimitAmt').val().trim().replaceAll(',', '') )
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <div class="tlt_head">
                    프로모션 설정<span class="step_bar"></span>
                </div>
                <h2 class="tlth2">쿠폰존 관리</h2>
            </div>
            <!-- line_box -->
            <form id="form_coupon_insert" method="post">
                <div class="line_box fri">
                    <h3 class="tlth3">쿠폰 종류 선택</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 쿠폰 종류 선택 표 입니다. 구성은 쿠폰종류, 쿠폰수량 입니다.">
                            <caption>쿠폰 종류 선택</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>쿠폰종류</th>
                                <td>
                                <span class="select">
                                    <label for="couponKindCd">쿠폰선택</label>
                                    <select name="couponKindCd" id="couponKindCd">
                                        <cd:option codeGrp="COUPON_KIND_CD" value="01" />
<%--                                         <tags:option codeStr="01:상품쿠폰;02:상품쿠폰(모바일전용);03:생일자쿠폰;04:신규회원가입쿠폰;05:직접발급쿠폰;" /> --%>
                                    </select>
                                </span>
                                </td>
                            </tr>
                            <tr id="option_content_total">
                                <th>상세정보</th>
                                <td id="option_content_01">상품쿠폰: 발급된 상품 쿠폰을 회원이 상품 상세페이지에서 다운로드합니다.</td>
                                <td id="option_content_02" style="display:none;">상품쿠폰(모바일전용): 발급된 상품 쿠폰을 회원이 상품 상세페이지에서 다운로드합니다.(단, 모바일만 사용가능)</td>
                                <td id="option_content_03" style="display:none;">생일자 쿠폰: 생일 맞이 회원이 마이페이지에서 다운로드합니다.<br/> &emsp;&emsp;&emsp;&emsp;&emsp;&nbsp; 유효기한 조건을 발급일 기준으로만 지정 가능합니다.</td>
                                <td id="option_content_04" style="display:none;">신규회원가입 쿠폰: 신규회원에게 자동으로 발급됩니다.<br/> &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;유효기한 조건을 발급일 기준으로만 지정 가능합니다.</td>
                                <td id="option_content_05" style="display:none;">직접발급 쿠폰: 특정한 회원에게 관리자 직접 발급합니다.</td>
                                <td id="option_content_06" style="display:none;">주문서쿠폰</td>
                                <td id="option_content_07" style="display:none;">상품구매 쿠폰 : 특정 상품 구매 후 발급 쿠폰 <br/>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;발급 시점은 구매 완료, 사용 가능 시점은 구매 확정</td>
                            </tr>
                            <tr>
                                <th>쿠폰수량</th>
                                <td>
                                <span class="select">
                                    <label for="couponQttLimitCd">수량선택</label>
                                    <select name="couponQttLimitCd" id="couponQttLimitCd">
                                        <tags:option codeStr="01:전체 수량 제한 없음;02:수량 제한" />
                                    </select>
                                </span>
                                    <span class="intxt shot couponQttLimitCntDisplay" style="display:none">
                                    <input type="text" name="couponQttLimitCnt" id="couponQttLimitCnt" data-validation-engine="validate[required]" value="0"/>
                                </span>
                                    <span class="couponQttLimitCntDisplay" style="display:none" >개</span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->

                    <h3 class="tlth3">쿠폰 상세정보</h3>
                    <!-- tblw -->
                    <div class="tblw tblmany">
                        <table summary="이표는 쿠폰 상세정보 표 입니다. 구성은 쿠폰명, 쿠폰설명, 단독사용설정, 쿠폰혜택, 유효기간, 사용제한, 쿠폰사용유무 입니다.">
                            <caption>쿠폰 상세정보</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th>쿠폰명</th>
                                <td><span class="intxt wid100p"><input type="text" name="couponNm" id="couponNm" data-validation-engine="validate[required, maxSize[100]]"/></span></td>
                            </tr>
                            <tr>
                                <th>쿠폰설명</th>
                                <td><span class="intxt wid100p"><input type="text" name="couponDscrt" id="couponDscrt" data-validation-engine="validate[required, maxSize[500]]"/></span></td>
                            </tr>
                            <tr class="trPresentCoupon">
                                <th>단독 사용설정</th>
                                <td>
                                    <label for="couponSoloUseY" class="radio"><span class="ico_comm"><input type="radio" name="couponSoloUseYn" id="couponSoloUseY" value="Y"/></span> 이 쿠폰은 동일한 주문 건에 다른 쿠폰과 <span class="point_c5">함께 사용할 수 있습니다.</span></label>
                                    <br>
                                    <label for="couponSoloUseN" class="radio on"><span class="ico_comm"><input type="radio" name="couponSoloUseYn" id="couponSoloUseN" checked="checked" value="N"/></span> 이 쿠폰은 동일한 주문 건에 다른 쿠폰과 <span class="point_c5">함께 사용할 수 없습니다. </span></label>
                                </td>
                            </tr>
                            <tr class="trPresentCoupon">
                                <th>쿠폰 혜택</th>
                                <td>
                                    <label for="percentDc" class="radio on"><span class="ico_comm">
                                <input type="radio" name="couponBnfCd" id="percentDc" value="01" checked="checked" /></span> </label>
                                    <span class="intxt"><input type="text" name="couponBnfValue" id="couponBnfValue" value="" maxlength="2"/></span> %
                                    할인, 최대
                                    <span class="intxt"><input type="text" id="bnfDcAmt01" name="bnfDcAmt01" value="" maxlength="10"/></span> 원  &nbsp;&nbsp;&nbsp;&nbsp;
                                    <tags:checkbox name="couponDupltDwldPsbYn" id="couponDupltDwldPsbYn" value="Y" compareValue="" text="중복 다운로드 가능" />
                                    <span class="br2"></span>

                                    <label for="priceDc" class="radio"><span class="ico_comm">
                                <input type="radio" name="couponBnfCd" id="priceDc" value="02"/></span> </label>
                                    <span class="intxt"><input type="text" id="bnfDcAmt02" name="bnfDcAmt02" value="" maxlength="10"/></span> 원 할인
                                    <span class="br2"></span>

                                    <label for="priceDc" class="radio"><span class="ico_comm">
                                <input type="radio" name="couponBnfCd" id="productDc" value="03"/></span> </label>
                                    <span class="intxt"><input type="text" id="bnfDcAmt03" name="bnfDcAmt03" value="" maxlength="10"/></span>
                                    <span class="br2"></span>
                                    *콘택트만 적용가능(안경테,안경렌즈X)
                                </td>
                            </tr>
                            <tr id="periodLayer_01">
                                <th>유효기간</th>
                                <td>
                                    <label for="fromToPeriod" class="radio on"><span class="ico_comm">
                                        <input type="radio" name="couponApplyPeriodCd" id="fromToPeriod" checked="checked" value="01" /></span></label>
                                    <tags:calendarTime from="from" to="to" idPrefix="srch"/><span class="br"></span>
                                    <label for="issueAfPeriod" class="radio"><span class="ico_comm">
                                        <input type="radio" name="couponApplyPeriodCd" id="issueAfPeriod" value="02"/></span></label>
                                    발급일로부터 <span class="intxt shot"><input type="text" name="couponApplyIssueAfPeriod" id ="couponApplyIssueAfPeriod" value="" maxlength="5" /></span> 일동안 사용가능
                                </td>
                            </tr>
                            <tr id="periodLayer_02" style="display: none;">
                                <th>유효기간</th>
                                <td>
                                    <label for="confirmAfPeriod" class="radio"><span class="ico_comm">
                                        <input type="radio" name="couponApplyPeriodCd" id="confirmAfPeriod" value="03"/></span></label>
                                    구매확정일로부터 <span class="intxt shot"><input type="text" name="couponApplyConfirmAfPeriod" id ="couponApplyConfirmAfPeriod" value="" maxlength="5" /></span> 일동안 사용가능
                                </td>
                            </tr>
                            <tr class="trPresentCoupon">
                                <th>사용제한 금액</th>
                                <td>
                                    최소결제 금액이 <span class="intxt shot"><input type="text" name="couponUseLimitAmt" id="couponUseLimitAmt" data-validation-engine="validate[required, maxSize[10]]" /></span> 원 이상이면 사용가능
                                </td>
                            </tr>
                            <tr>
                                <th>사용제한<br>상품/카테고리</th>
                                <td>
                                    <label for="totalGoods" class="radio mr20 ra on"><span class="ico_comm"><input type="radio" name="couponApplyLimitCd" id="totalGoods" value="01" checked="checked" /></span> 전체상품 쿠폰 사용 가능</label>
                                    <label for="couponTargetApply" class="radio mr20 rb"><span class="ico_comm"><input type="radio" name="couponApplyLimitCd" id="couponTargetApply"  value="02" /></span> 특정상품 쿠폰 사용가능</label>
                                    <label for="couponTargetExpt" class="radio rc"><span class="ico_comm"><input type="radio" name="couponApplyLimitCd" id="couponTargetExpt"  value="03" /></span> 특정상품 쿠폰 사용 불가</label>
                                    <span class="br2"></span>
                                    <!-- tblw -->
                                    <div class="tblw tblmany2 mt0">
                                        <table summary="이표는 상품/ 카테고리 표 입니다.">
                                            <caption>상품/ 카테고리</caption>
                                            <colgroup>
                                                <col width="100%">
                                                <col width="">
                                            </colgroup>
                                            <tbody>
                                            <tr class="radio_a">
                                                <td>전체상품</td>
                                            </tr>

                                            <tr class="radio_b" style="display:none;">
                                                <td>
                                                    <label for="applyGoods" class="chack on" ><span class="ico_comm"></span>상품 검색
                                                        <input type="checkbox" name="couponApplyTargetCd" id="applyGoods" class="blind" value="01" checked="checked"/>
                                                    </label>
                                                    <button type="button" id="apply_goods_srch_btn" class="btn_blue">상품 검색</button>
                                                    <ul class="tbl_ul pr_ul1" id="sel_apply_goods_list"> <!--선택되기 전엔 class="display_block" 항목이 빠집니다.--></ul>
<%--                                                    <span class="br"></span>--%>

<%--                                                    <label for="applyCtg" class="radio" ><span class="ico_comm"></span>카테고리 검색--%>
<%--                                                        <input type="radio" name="couponApplyTargetCd" id="applyCtg" class="blind" value="02" />--%>
<%--                                                    </label>--%>
<%--                                                    <span class="br2"></span>--%>
<%--                                                    <div id="apply_select_ctg">--%>
<%--                                                             <span class="select">--%>
<%--                                                                 <label for="sel_ctg_1"></label>--%>
<%--                                                                 <select name="searchCtg1" id="sel_ctg_1">--%>
<%--                                                                     <option id="opt_ctg_1_def" value="">1차 카테고리</option>--%>
<%--                                                                 </select>--%>
<%--                                                             </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                                 <label for="sel_ctg_2"></label>--%>
<%--                                                                 <select name="searchCtg2" id="sel_ctg_2">--%>
<%--                                                                     <option id="opt_ctg_2_def" value="">2차 카테고리</option>--%>
<%--                                                                 </select>--%>
<%--                                                             </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                                 <label for="sel_ctg_3"></label>--%>
<%--                                                                 <select name="searchCtg3" id="sel_ctg_3">--%>
<%--                                                                     <option id="opt_ctg_3_def" value="">3차 카테고리</option>--%>
<%--                                                                 </select>--%>
<%--                                                             </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                                 <label for="sel_ctg_4"></label>--%>
<%--                                                                 <select name="searchCtg4" id="sel_ctg_4">--%>
<%--                                                                     <option id="opt_ctg_4_def" value="">4차 카테고리</option>--%>
<%--                                                                 </select>--%>
<%--                                                             </span>--%>
<%--                                                        <button type="button" id="ctg_sel_btn" class="btn_blue">카테고리 선택</button>--%>
<%--                                                        <ul class="pr_cate_s display_block" id="sel_apply_ctg_list">--%>
<%--                                                        </ul>--%>
<%--                                                    </div> <span class="br2"></span>--%>
                                                </td>
                                            </tr>

                                            <tr class="radio_c" style="display:none;">
                                                <td>
                                                    <label for="exptGoods" class="chack on" ><span class="ico_comm"></span>상품 검색
                                                        <input type="checkbox" name="couponApplyTargetCd" id="exptGoods" class="blind" value="01" checked="checked">
                                                    </label>
                                                    <button type="button" id="expt_goods_srch_btn" class="btn_blue">상품 검색</button>
                                                    <ul class="tbl_ul pr_ul1" id="sel_expt_goods_list"></ul>
<%--                                                    <span class="br"></span>--%>

<%--                                                    <label for="exptCtg" class="radio" ><span class="ico_comm"></span>카테고리 검색--%>
<%--                                                        <input type="radio" name="couponApplyTargetCd" id="exptCtg" class="blind" value="02">--%>
<%--                                                    </label>--%>
<%--                                                    <span class="br2"></span>--%>
<%--                                                    <div id="expt_select_ctg">--%>
<%--                                                         <span class="select">--%>
<%--                                                             <label for="expt_sel_ctg_1"></label>--%>
<%--                                                             <select name="searchCtg1" id="expt_sel_ctg_1">--%>
<%--                                                                 <option id="expt_opt_ctg_1_def" value="">1차 카테고리</option>--%>
<%--                                                             </select>--%>
<%--                                                         </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                             <label for="expt_sel_ctg_2"></label>--%>
<%--                                                             <select name="searchCtg2" id="expt_sel_ctg_2">--%>
<%--                                                                 <option id="expt_opt_ctg_2_def" value="">2차 카테고리</option>--%>
<%--                                                             </select>--%>
<%--                                                         </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                             <label for="expt_sel_ctg_3"></label>--%>
<%--                                                             <select name="searchCtg3" id="expt_sel_ctg_3">--%>
<%--                                                                 <option id="expt_opt_ctg_3_def" value="">3차 카테고리</option>--%>
<%--                                                             </select>--%>
<%--                                                         </span>--%>
<%--                                                        <span class="select">--%>
<%--                                                             <label for="expt_sel_ctg_4"></label>--%>
<%--                                                             <select name="searchCtg4" id="expt_sel_ctg_4">--%>
<%--                                                                 <option id="expt_opt_ctg_4_def" value="">4차 카테고리</option>--%>
<%--                                                             </select>--%>
<%--                                                         </span>--%>
<%--                                                        <button type="button" id="expt_ctg_sel_btn" class="btn_blue">카테고리 선택</button>--%>
<%--                                                        <ul class="pr_cate_s display_block" id="sel_expt_ctg_list"> <!--선택되기 전엔 class="display_block" 항목이 빠집니다.-->--%>
<%--                                                        </ul>--%>
<%--                                                    </div> <span class="br2"></span>--%>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- //tblw -->
                                </td>
                            </tr>
                            <tr>
                                <th>쿠폰 제품유형</th>
                                <td>
                                <span class="select">
                                    <label for="goodsTypeCd">선택</label>
                                    <select name="goodsTypeCd" id="goodsTypeCd">
                                        <%-- <cd:option codeGrp="GOODS_TYPE_CD" value="" includeChoice="true"/> --%>
                                        <tags:option codeStr=":선택;01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" />
                                    </select>
                                </span>
                                </td>
                            </tr>
                            <tr>
                                <th>쿠폰 연령대</th>
                                <td>
                                    <a href="#none" class="all_choice mr20"><span class="ico_comm"></span> 전체</a>
                                    <tags:checkboxs codeStr="10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;70:70대;80:80대;90:90대;" name="ageCd" idPrefix="ageCd"/>
                                </td>
                            </tr>
                            <tr>
                                <th>쿠폰사용유무</th>
                                <td>
                                    <tags:radio codeStr="Y:사용;N:미사용" name="couponUseYn" idPrefix="conponUseYn" value="Y"/>
                                </td>
                            </tr>
                            <tr class="trPresentCoupon" style="display:none;">
                                <th>본사 부담율</th>
                                <td>
                                    <input type="text" name="cpLoadrate" id="cpLoadrate" data-validation-engine="validate[required, maxSize[3]]" value="100" style="width:80px;">
                                    <span id="dcValueSpan" class="marginL05">%</span>
                                </td>
                            </tr>
                            <tr id="trRsvOnly" style="display:none;">
                                <th>예약전용쿠폰 여부</th>
                                <td>
                                    <label for="rsvOnlyYn" class="chack"><span class="ico_comm"><input type="checkbox" name="rsvOnlyYn" id="rsvOnlyYn" value="Y"></span>사용</label>
                                </td>
                            </tr>
                                <%--<tr class="trPresentCoupon">
                                    <th>오프라인 전용여부</th>
                                    <td>
                                        <label for="offlineOnlyYn" class="chack"><span class="ico_comm"><input type="checkbox" name="offlineOnlyYn" id="offlineOnlyYn" value="Y"></span>사용</label>
                                    </td>
                                </tr>--%>
                            <tr class="trPresentCoupon">
                                <th>쿠폰종류</th>
                                <td>
                                        <%--<label for="offlineOnlyYn" class="chack"><span class="ico_comm"><input type="checkbox" name="offlineOnlyYn" id="offlineOnlyYn" value="Y"></span>사용</label>--%>
                                    <label for="offlineOnlyYn01" class="radio"><span class="ico_comm"><input type="radio" name="offlineOnlyYn" id="offlineOnlyYn01" value="N"/></span>온라인 전용</label>
                                    <label for="offlineOnlyYn02" class="radio"><span class="ico_comm"><input type="radio" name="offlineOnlyYn" id="offlineOnlyYn02" value="Y"/></span>오프라인 전용 </label>
                                    <label for="offlineOnlyYn03" class="radio on"><span class="ico_comm"><input type="radio" name="offlineOnlyYn" id="offlineOnlyYn03" value="F" checked="checked"/></span>온/오프라인 </label>

                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //tblw -->
                </div>
            </form>
            <!-- //line_box -->
        </div>
        <div class="bottom_box">
            <div class="left">
                <button class="btn--big btn--big-white" id="btn_list">목록</button>
            </div>
            <div class="right">
                <button class="btn--blue-round" id="reg_btn">저장</button>
            </div>
        </div>


        <jsp:include page="/WEB-INF/include/popup/goodsSelectPopup.jsp" />
    </t:putAttribute>
</t:insertDefinition>
