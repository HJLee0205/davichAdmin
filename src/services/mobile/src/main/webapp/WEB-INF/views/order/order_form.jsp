<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">주문하기</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
<!--             <script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script> -->
        </c:if>
        <c:if test="${pgPaymentConfig.data.pgCd eq '04'}">
            <!-- 올더게이트 웹표준 방식에 따른 결제 호출 및 관련 자바스크립트 추가 (위치변경금지)  -->
            <!-- jquery 버전 충돌로 Dmall에서 사용하는 상위버전 jquery-1.12.2.min.js 를 그대로 사용하도록 올더게이트에서 제공하는 것 막음 -->
            <!-- script type="text/javascript" src="https://www.allthegate.com/plugin/jquery-1.11.1.js"></script  -->
<!--             <script type="text/javascript" src="https://www.allthegate.com/payment/webPay/js/ATGClient_new.js" charset="UTF-8"></script> -->
        </c:if>
        <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
        <script src="${_MOBILE_PATH}/front/js/coupon.js" type="text/javascript" charset="utf-8"></script>

        <script type="text/javascript">
        $(document).ready(function(){
            //회원정보 셋팅
            var memberNo = '${user.session.memberNo}';
            if(memberNo != '') {
                //이메일
                var _email = '${member_info.data.email}';
                var temp_email = _email.split('@');
                $('#email01').val(temp_email[0]);
                if($('#email03').find('option[value="'+temp_email[1]+'"]').length > 0) {
                    $('#email03').val(temp_email[1]);
                } else {
                    $('#email03').val('etc');
                }
                $('#email03').trigger('change');
                $('#email02').val(temp_email[1]);

                //일반전화
                var _tel = '${member_info.data.tel}';
                if(_tel != '') {
                    var temp_tel = Dmall.formatter.tel(_tel).split('-');
                    if(temp_tel.length == 3) {
                        $('#ordrTel01').val(temp_tel[0]);
                        $('#ordrTel02').val(temp_tel[1]);
                        $('#ordrTel03').val(temp_tel[2]);
                        $('#ordrTel01').trigger('change');
                    }
                }

                //모바일
                var _mobile = '${member_info.data.mobile}';
                if(_mobile != '') {
                    var temp_mobile = Dmall.formatter.mobile(_mobile).split('-');
                    if(temp_mobile.length == 3) {
                        $('#ordrMobile01').val(temp_mobile[0]);
                        $('#ordrMobile02').val(temp_mobile[1]);
                        $('#ordrMobile03').val(temp_mobile[2]);
                        $('#ordrMobile01').trigger('change');
                    }
                }
            }

            //readonly 백스페이스 막기
            $(document).on('keydown' ,function(event) {
                var backspace = 8;
                var d = event.srcElement || event.target;
                if (event.keyCode == backspace) {
                    if (d.tagName.toUpperCase() === "SELECT") {
                        return false;
                    }
                    if (d.tagName.toUpperCase() === "INPUT" && d.readOnly){
                        return false;
                    }
                }
            });

            // 우편번호
            jQuery('.btn_post').on('click', function(e) {
                Dmall.LayerPopupUtil.zipcode(setZipcode);
            });

            function getGoodsList() {
                var i=0;
                var params=[];
                $(".couponInfo").each(function(){
                    var d=$(this).data();
                    params[i++]=d;
                });
                return params;
            }

            /* 이메일 선택 */
            var emailSelect = $('#email03');
            var emailTarget = $('#email02');
            emailSelect.bind('change', function() {
                var host = this.value;
                if (host != 'etc' && host != '') {
                    emailTarget.attr('readonly', true);
                    emailTarget.val(host).change();
                } else if (host == 'etc') {
                    emailTarget.attr('readonly'
                            , false);
                    emailTarget.val('').change();
                    emailTarget.focus();
                } else {
                    emailTarget.attr('readonly', true);
                    emailTarget.val('').change();
                }
            });

            /* 기본 배송지 선택 */
            $('#shipping_address').click(function(){
                resetAddr();
                if($('#basicMemberGbCd').val() == '10') {
                    $('#shipping_internal').prop("checked",true);
                    $('.radio_chack_a').trigger('click');
                    $('#postNo').val($('#basicPostNo').val());
                    $('#numAddr').val($('#basicNumAddr').val());
                    $('#roadnmAddr').val($('#basicRoadnmAddr').val());
                    $('#dtlAddr').val($('#basicDtlAddr').val());
                } else if($('#basicMemberGbCd').val() == '20'){
                    $('#shipping_oversea').prop("checked",true);
                    $('.radio_chack_b').trigger('click');
                    $('#frgAddrCountry').val($('#basicFrgAddrCountry').val());
                    $('#frgAddrCity').val($('#basicFrgAddrCity').val());
                    $('#frgAddrState').val($('#basicFrgAddrState').val());
                    $('#frgAddrZipCode').val($('#basicFrgAddrZipCode').val());
                    $('#frgAddrDtl1').val($('#basicFrgAddrDtl1').val());
                    $('#frgAddrDtl2').val($('#basicFrgAddrDtl2').val());
                }
                jsSetAreaAddDlvr();
            });

            /* 최근 배송지 선택 */
            $('#recently_shipping_address').click(function(){
                resetAddr();
                if($('#recentMemberGbCd') == '') {
                    Dmall.LayerUtil.alert('최근 배송지가 없습니다.');
                    $(this).prop('checked',false);
                }  else {
                    if($('#recentMemberGbCd').val() == '10') {
                        $('#shipping_internal').prop("checked",true);
                        $('.radio_chack_a').trigger('click');
                        $('#postNo').val($('#recentPostNo').val());
                        $('#numAddr').val($('#recentNumAddr').val());
                        $('#roadnmAddr').val($('#recentRoadnmAddr').val());
                        $('#dtlAddr').val($('#recentDtlAddr').val());
                    } else if($('#recentMemberGbCd').val() == '20'){
                        $('#shipping_oversea').prop("checked",true);
                        $('.radio_chack_b').trigger('click');
                        $('#frgAddrCountry').val($('#recentFrgAddrCountry').val());
                        $('#frgAddrCity').val($('#recentFrgAddrCity').val());
                        $('#frgAddrState').val($('#recentFrgAddrState').val());
                        $('#frgAddrZipCode').val($('#recentFrgAddrZipCode').val());
                        $('#frgAddrDtl1').val($('#recentFrgAddrDtl1').val());
                        $('#frgAddrDtl2').val($('#recentFrgAddrDtl2').val());
                    }
                    jsSetAreaAddDlvr();
                }
            });

            /* 신규 배송지 선택 */
            $('#new_shipping_address01').click(function(){
                resetAddr();
                jsSetAreaAddDlvr();
            });

            /* 쿠폰 조회 */
            var memberNo = '${user.session.memberNo}';
            if(memberNo != '') {

                couponPopupDiv = $("#btn_checkout_info").coupon({
                    url : "/coupon/available-ordercoupon-list"
                    ,params : getGoodsList()
                    ,orderTotalAmt : 0 //주문서 쿠폰 관련
                    ,onLoad : function(obj){
                        var totalCouponCnt = '${member_info.data.cpCnt}';
                        if(totalCouponCnt == '') {
                            totalCouponCnt = '0'
                        }
                        $("#total_coupon_cnt").html(totalCouponCnt);  //보유쿠폰 수량
                        $("#use_coupon_cnt").html(obj.useCouponCnt);      //사용가능쿠폰 수량
                    }
                    ,onApply : function(obj){
                        $('#cpUseAmt').val(commaNumber(obj.dcTotalAmt));
                        $('#couponTotalDcAmt').val(obj.dcTotalAmt);
                        var couponTotalDcAmt = $('#couponTotalDcAmt').val();
                        var promotionTotalDcAmt = $('#promotionTotalDcAmt').val();
                        var memberGradeTotalDcAmt = $('#memberGradeTotalDcAmt').val();
                        var dcTotalAmt = Number(couponTotalDcAmt)+Number(promotionTotalDcAmt)+Number(memberGradeTotalDcAmt);
                        $('#dcAmt').val(dcTotalAmt);
                        $('#totalDcAmt').html('(-) '+ commaNumber(dcTotalAmt) +' 원');
                        //쿠폰사용정보 생성
                        var couponUseInfo = '';
                        if(obj.selectData != null && obj.selectData.length > 0) {
                            for(var i=0; i<obj.selectData.length; i++) {
                                if(couponUseInfo != '') {
                                    couponUseInfo += '▦';
                                }
                                couponUseInfo += obj.selectData[i].itemNo+'^'+obj.selectData[i].memberCpNo+'^'+obj.selectData[i].couponNo+'^'+obj.selectData[i].dcAmt;
                                //쿠폰 선택 후 상품별 할인금액 셋팅
                                var itemLength = $('[name=itemNo]').length;
                                for(var k=0; k<itemLength; k++) {
                                    if($('[name=itemNo]').eq(k).val() == obj.selectData[i].itemNo) {
                                        var dcPrice = $('[name=basicDcPrice]').eq(k).val(); //기획전+등급할인 금액
                                        //총상품 할인금액 셋팅(기획전+등급+쿠폰)
                                        $('[name=goodsDcPriceInfo]').eq(k).val(Number(dcPrice)+Number(obj.selectData[i].dcAmt));
                                    } else {
                                        var dcPrice = $('[name=basicDcPrice]').eq(k).val(); //기획전+등급할인 금액
                                        //총상품 할인금액 셋팅(기획전)
                                        $('[name=goodsDcPriceInfo]').eq(k).val(Number(dcPrice));
                                    }
                                }
                            }
                            //쿠폰, 마켓포인트 중복 사용 불가
                            var svmnCpDupltApplyYn = '${site_info.svmnCpDupltApplyYn}';
                            if(svmnCpDupltApplyYn == 'N') {
                                if(couponUseInfo != '') {
                                    if(Number($('#mileageTotalAmt').val()) > 0 ) {
                                        Dmall.LayerUtil.alert("마켓포인트과 쿠폰은 중복 사용할 수 없습니다.").done(function(){
                                            $('#mileageTotalAmt').val(0);
                                            $('#mileageAmt').val(0);
                                            jsCalcMileageAmt();
                                        });
                                    }
                                    $('#mileageAmt').attr('disabled',true);
                                    $('#mileageAllUse').css('display','none');
                                }
                            }
                        } else {
                            $('#mileageAmt').attr('disabled',false);
                            $('#mileageAllUse').css('display','');
                        }
                        $('#couponUseInfo').val(couponUseInfo);
                        jsCalcTotalAmt();
                    }
                    ,onError : function(){

                    }
                });
            }

            /* 결제수단 선택 */
            $("input:radio[name=payment_select]").on('change', function(e) {
                $('#paymentPgCd').val($(this).val());
            });

            /* 결제하기 */
            $('.btn_go_payment').on("click", function(){
                var paymentAmt = $('#paymentAmt').val();
                var memeberNo = '${user.session.memberNo}';
                if(memberNo == '') {
                    //비회원 주문동의
                    if(!$('#nonmember_agree01').is(':checked')){
                        Dmall.LayerUtil.alert('쇼핑몰 이용약관에 동의해 주십시요.').done(function(){
                            $('#nonmember_agree01').focus();
                        });
                        return false;
                    }
                    if(!$('#nonmember_agree02').is(':checked')){
                        Dmall.LayerUtil.alert('비회원 구매 및 결제 개인정보 취급방침에 동의해 주십시요.').done(function(){
                            $('#nonmember_agree02').focus();
                        });
                        return false;
                    }
                    /* if(!$('#nonmember_agree03').is(':checked')){ //선택? 07
                        Dmall.LayerUtil.alert('개인정보 제3자 제공 동의를 체크해 주십시요.').done(function(){
                            $('#nonmember_agree03').focus();
                        });
                        return false;
                    }
                    if(!$('#nonmember_agree04').is(':checked')){ //선택? 08
                        Dmall.LayerUtil.alert('개인정보 취급 위탁 동의를 체크해 주십시요.').done(function(){
                            $('#nonmember_agree04').focus();
                        });
                        return false;
                    } */
                }
                //마켓포인트 사용 최소 금액
                var mileageTotalAmt = $('#mileageTotalAmt').val();
                if(Number(mileageTotalAmt) > 0) {
                    var svmnMinUseAmt = '${site_info.svmnMinUseAmt}';
                    if(Number(svmnMinUseAmt) > Number(mileageTotalAmt)) {
                        Dmall.LayerUtil.alert('마켓포인트은 최소'+commaNumber(svmnMinUseAmt)+'원 이상 사용 가능합니다.').done(function(){
                            $('#mileageAmt').focus();
                        });
                        return false;
                    }
                    //마켓포인트 사용 최대 금액
                    var svmnMaxUseAmt = '${site_info.svmnMaxUseAmt}';
                    if(Number(svmnMaxUseAmt) < Number(mileageTotalAmt)) {
                        Dmall.LayerUtil.alert('마켓포인트은 최대'+commaNumber(svmnMaxUseAmt)+'원 까지 사용 가능합니다.').done(function(){
                            $('#mileageAmt').focus();
                        });
                        return false;
                    }

                    //마켓포인트 사용단위
                    var mileageUnitCd = '${site_info.svmnUseUnitCd}';
                    var mileageUnit = '';
                    if(mileageUnitCd == '1') {
                        mileageUnit = '10';
                    } else if(mileageUnitCd == '2'){
                        mileageUnit = '100';
                    } else if(mileageUnitCd == '3'){
                        mileageUnit = '1000';
                    }
                    if(Number(mileageTotalAmt)%Number(mileageUnit) > 0) {
                        Dmall.LayerUtil.alert('마켓포인트은 '+commaNumber(mileageUnit)+'원 단위로 사용 가능합니다.').done(function(){
                            $('#mileageAmt').focus();
                        });
                        return false;
                    }
                }

                //구매수량 제한 확인
                var ordQttMinLimitOk = true;
                var ordQttMaxLimitOk = true;
                var limitItemNm = '';
                var minOrdQtt = 0;
                var maxOrdQtt = 0;
                $('[name=ordQttMinLimitYn]').each(function(){
                    if($(this).val() == 'Y') {
                        var seq = $(this).index();
                        limitItemNm = $('[name=limitItemNm]').eq(seq).val();
                        minOrdQtt = $('[name=minOrdQtt]').eq(seq).val();
                        ordQttMinLimitOk = false;
                    }
                });
                $('[name=ordQttMaxLimitYn]').each(function(){
                    if($(this).val() == 'Y') {
                        var seq = $(this).index();
                        limitItemNm = $('[name=limitItemNm]').eq(seq).val();
                        maxOrdQtt = $('[name=maxOrdQtt]').eq(seq).val();
                        ordQttMaxLimitOk = false;
                    }
                });
                if(!ordQttMinLimitOk) {
                    Dmall.LayerUtil.alert(limitItemNm +'상품은<br>최소 ' +minOrdQtt+'개 이상 구매해야 합니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    return false;
                }
                if(!ordQttMaxLimitOk) {
                    Dmall.LayerUtil.alert(limitItemNm +'상품은<br>' +maxOrdQtt+'개 까지만 구매 가능합니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    return false;
                }

                //주문자명
                if($.trim($('#ordrNm').val()) == '') {
                    Dmall.LayerUtil.alert('주문자명을 입력해 주십시요.').done(function(){
                        $('#ordrNm').focus();
                    });
                    return false;
                }

                //주문자이메일
                if($.trim($('#email01').val()) == '' || $.trim($('#email02').val()) == '') {
                    Dmall.LayerUtil.alert('이메일을 입력해 주십시요.').done(function(){
                        $('#email01').focus();
                    });
                    return false;
                } else {
                    $('#ordrEmail').val($.trim($('#email01').val())+'@'+$.trim($('#email02').val()));
                }

                //주문자 전화번호(필수X)
                if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                    $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
                }

                //주문자 핸드폰
                if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                    Dmall.LayerUtil.alert('휴대폰번호를 입력해 주십시요.').done(function(){
                        $('#ordrMobile01').focus();
                    });
                    return false;
                } else {
                    $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                    var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                    if(!regExp.test($('#ordrMobile').val())) {
                        Dmall.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br>휴대폰번호를 정확히 입력해 주십시요.').done(function(){
                            $('#ordrMobile01').focus();
                        })
                        return false;
                    }
                }
                //수령인
                if($.trim($('#adrsNm').val()) == '') {
                    Dmall.LayerUtil.alert('수령인을 입력해 주십시요.').done(function(){
                        $('#adrsNm').focus();
                    });
                    return false;
                }

                if(memberNo != '') {
                    var addressCheck = false;
                    $('[name=shipping_address]').each(function(){
                        if($(this).is(':checked')) {
                            addressCheck = true;
                        }
                    })
                    if(!addressCheck) {
                        Dmall.LayerUtil.alert('배송지를 선택해 주십시요.').done(function(){
                            $('[name=shipping_address]').focus();
                        });
                        return false;
                    }
                    /*
                    if($('#new_shipping_address01').is(':checked')) {
                        if(trim($('#new_shipping_address01').val()) == '') {
                            Dmall.LayerUtil.alert('배송지명을 입력해 주십시요.').done(function(){
                                $('[name=new_shipping_address02]').focus();
                            });
                            return false;
                        }
                    }
                     */
                }
                //수령인 전화번호(필수X)
                if($.trim($('#adrsTel01').val()) != '' && $.trim($('#adrsTel02').val()) != '' && $.trim($('#adrsTel03').val()) != '') {
                    $('#adrsTel').val($('#adrsTel01').val()+'-'+$.trim($('#adrsTel02').val())+'-'+$.trim($('#adrsTel03').val()));
                }

                //수령인 휴대폰
                if($('#adrsMobile01').val() == '' || $.trim($('#adrsMobile02').val()) == '' || $.trim($('#adrsMobile03').val()) == '') {
                    Dmall.LayerUtil.alert('휴대폰번호를 입력해 주십시요.').done(function(){
                        $('#adrsMobile01').focus();
                    });
                    return false;
                } else {
                    $('#adrsMobile').val($('#adrsMobile01').val()+'-'+$.trim($('#adrsMobile02').val())+'-'+$.trim($('#adrsMobile03').val()));
                    var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                    if(!regExp.test($('#adrsMobile').val())) {
                        Dmall.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br>휴대폰번호를 정확히 입력해 주십시요.').done(function(){
                            $('#adrsMobile01').focus();
                        })
                        return false;
                    }
                }
                //주문자 주소정보
                $('[name=ordrAddr]').val($('#basicPostNo').val() + " " + $('#basicRoadnmAddr').val() + " " + $('#basicDtlAddr').val());
                //수령자 주소정보
                if($('[name=memberGbCd]:checked').val() == '10') {
                    //국내배송지
                    if($.trim($('#postNo').val()) == '' || ($.trim($('#numAddr').val()) == '' && $.trim($('#roadnmAddr').val()) == '')) {
                        Dmall.LayerUtil.alert('배송지를 입력해 주십시요.').done(function(){
                            $('#postNo').focus();
                        });
                        return false;
                    }
                    //국내배송지 상세
                    if($.trim($('#dtlAddr').val()) == '' ) {
                        Dmall.LayerUtil.alert('상세주소를 입력해 주십시요.').done(function(){
                            $('#dtlAddr').focus();
                        });
                        return false;
                    }
                    $('[name=adrsAddr]').val( $('#postNo').val() + " " + (($('#roadnmAddr').val() == "")? $('#numAddr').val() :  $('#roadnmAddr').val())+ " " + $('#dtlAddr').val()  );
                } else {
                    //해외주소
                    $('[name=adrsAddr]').val($('#frgAddrCountry').val()+ " "+$('#frgAddrZipCode').val() + " " + $('#frgAddrState').val() + " " + $('#frgAddrCity').val()+ " " + $('#frgAddrDtl1').val()+ " " + $('#frgAddrDtl2').val());
                }
                //결제수단
                if(Number(paymentAmt) > 0) {
                    if($('input[name=paymentWayCd]').val()== '') {
                        Dmall.LayerUtil.alert('결제수단을 선택해 주십시요.').done(function(){
                            $('#dtlAddr').focus();
                        });
                        return false;
                    }
                }

                //주문동의
                if(!$('#order_agree').is(':checked')) {
                    Dmall.LayerUtil.alert('주문자동의를 체크해 주십시요.').done(function(){
                        $('#order_agree').focus();
                    });
                    return false;
                }

                var paymentPgCd = $('#paymentPgCd').val();
                var paymentWayCd = $('input[name=paymentWayCd]').val();
                if(paymentWayCd != '11' && Number(paymentAmt) > 0) {
                    if(paymentPgCd == '01'){ // KCP
                        $('#frmAGS_pay').attr('action','${_MOBILE_PATH}/front/order/order-insert');
                        createGoodsInfo();
                        $('[name=good_name]').val($('#ordGoodsInfo').val());
                        $('[name=good_mny]').val($('#paymentAmt').val());
                        $('[name=buyr_name]').val($('#ordrNm').val());
                        $('[name=buyr_mail]').val($('#ordrEmail').val());
                        var paymentWayCd = $('input[name=paymentWayCd]').val();
                        var payMethod = '';
                        if(paymentWayCd == '21') { //계좌이체
                            payMethod = 'BANK';
                        } else if(paymentWayCd == '22') { //가상계좌
                            payMethod = 'VCNT';
                        } else if(paymentWayCd == '23') { //신용카드
                            payMethod = 'CARD';
                        } else if(paymentWayCd == '24') { //휴대폰결제
                            payMethod = 'MOBX';
                        }
                        $('[name=pay_method]').val(payMethod);
                        //에스크로
                        if($('input[name=escrowYn]').val() !== undefined) {
                            $('[name=escw_used]').val($('input[name=escrowYn]:checked').val());
                            $('[name=rcvr_name]').val($('#adrsNm').val());
                            $('[name=rcvr_tel1]').val($('#adrsTel').val());
                            $('[name=rcvr_tel2]').val($('#adrsMobile').val());
                            $('[name=rcvr_zipx]').val($('#postNo').val());
                            $('[name=rcvr_add1]').val($('#roadnmAddr').val());
                            $('[name=rcvr_add2]').val($('#dtlAddr').val());
                        }
                        //현금영수증
                        if($('input[name=cashRctYn]') !== 'undefined') {
                            if($('#shop_paper02').is(':checked')) {
                                $('[name=disp_tax_yn]').val('Y');
                            } else {
                                $('[name=disp_tax_yn]').val('N');
                            }
                        }
                        kcp_AJAX();
                        return false;
                    } else if(paymentPgCd == '02'){ //INICIS


                        if(paymentWayCd == '21') { //계좌이체

                            $('[name=P_RESERVED]').val('extension_enable=Y');
	                        var pReserved = $('[name=P_RESERVED]').val();

                            if($('[name=cashRctYn]:checked').val()=='N'){
                               $('[name=P_RESERVED]').val(pReserved+'&bank_receipt=N');
                           }

                            payMethod = 'bank';
                        } else if(paymentWayCd == '22') { //가상계좌
                           if($('[name=cashRctYn]:checked').val()=='Y'){
                               $('[name=P_RESERVED]').val('vbank_receipt=Y');
                           }

                            payMethod = 'vbank';
                        } else if(paymentWayCd == '23') { //신용카드

                            $('[name=P_RESERVED]').val('block_isp=Y&twotrs_isp=Y&twotrs_isp_noti=N&apprun_check=Y');
                            payMethod = 'wcard';
                        } else if(paymentWayCd == '24') { //휴대폰결제
                            payMethod = 'mobile';
                        }

                        $('[name=paymethod]').val(payMethod);
                        $('[name=P_GOODS]').val($('#ordGoodsInfo').val());
                        $('[name=P_UNAME]').val($('#ordrNm').val());
                        $('[name=P_MOBILE]').val($('#ordrMobile').val());
                        $('[name=P_EMAIL]').val($('#ordrEmail').val());
                        $('[name=P_AMT]').val($('#paymentAmt').val());

                        var certUrl = '${_MOBILE_PATH}/front/order/inicis-signature-info';

                        var certparam = jQuery('#frmAGS_pay').serialize();

                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                               /*
                                   WEB VERSION
                                $('[name=mKey]').val(certResult.data.mkey);
                                $('[name=mid]').val(certResult.data.mid);
                                $('[name=signKey]').val(certResult.data.signKey);
                                $('[name=timestamp]').val(certResult.data.timestamp);
                                $('[name=oid]').val(certResult.data.oid);
                                $('[name=price]').val(certResult.data.price);
                                $('[name=cardNoInterestQuota]').val(certResult.data.cardNoInterestQuota);
                                $('[name=cardQuotaBase]').val(certResult.data.cardQuotaBase);
                                $('[name=signature]').val(certResult.data.signature);
                                INIStdPay.pay('frmAGS_pay');
                               */

                               /* MOBILE */
                                $('[name=P_MID]').val(certResult.data.mid);
                                inisisSubmit();
                                return false;
                            } else {
                                Dmall.LayerUtil.alert("결제모듈 호출에 실패하였습니다.", "알림")
                                return false;
                            }
                        });

                        return false;

                    } else if(paymentPgCd == '03'){ //LGU+
                        $('[name=LGD_AMOUNT]').val($('#paymentAmt').val());
                        $('[name=Amt]').val($('#paymentAmt').val());
                        $('[name=LGD_TIMESTAMP]').val(new Date().format('yyyyMMddHHmmss'));
                        var certUrl = '${_MOBILE_PATH}/front/order/'+paymentPgCd+'/cert';
                        var certparam = jQuery('#frmAGS_pay').serialize();
                        //서버에 post 방식으로 요청하여 JSON 데이터를 결과로 반환 받는다.
                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                Dmall.FormUtil.jsonToForm(certResult.extraData, 'frmAGS_pay');
                                //alert("cert 성공");
                                launchCrossPlatform(); // 결제인증창 호출
                            } else {
                                Dmall.LayerUtil.alert("결제모듈 호출에 실패하였습니다.", "알림")
                            }
                        });
                        return false;
                    } else if(paymentPgCd == '04'){ //allthegate

                        if(paymentWayCd == '21') { //계좌이체(모바일 미지원)
                            alert('모바일 에서는 계좌이체를 지원하지 않습니다.');
                            return false;
                            //payMethod = 'bank';
                        } else if(paymentWayCd == '22') { //가상계좌
                            payMethod = 'virtual';
                        } else if(paymentWayCd == '23') { //신용카드
                            payMethod = 'card';
                        } else if(paymentWayCd == '24') { //휴대폰결제
                            payMethod = 'hp';
                            $('[name=ProdCode]').val($('[name=goodsNo]:first').val());
                        }

                        $('[name=Job]').val(payMethod);
                        $('[name=Amt]').val($('#paymentAmt').val());
                        $('[name=ProdNm]').val($('#ordGoodsInfo').val());
                        $('[name=OrdNm]').val($('#ordrNm').val());
                        $('[name=OrdPhone]').val($('#ordrMobile').val());
                        $('[name=OrdAddr]').val($('input[name=adrsAddr]').val());
                        $('[name=UserEmail]').val($('#ordrEmail').val());
                        $('[name=RcpNm]').val($('#adrsNm').val());
                        $('[name=RcpPhone]').val($('input[name=adrsMobile]').val());
                        $('[name=DlvAddr]').val($('input[name=adrsAddr]').val());




                        var paymentWayCd = $('input[name=paymentWayCd]').val();

                        //$('#frmAGS_pay').attr('action','${_MOBILE_PATH}/front/order/order-insert');

                        /* var certUrl = '${_MOBILE_PATH}/front/order/'+paymentPgCd+'/cert';
                        var certparam = jQuery('#frmAGS_pay').serialize();
                        //서버에 post 방식으로 요청하여 JSON 데이터를 결과로 반환 받는다.
                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                Dmall.FormUtil.jsonToForm(certResult.extraData, 'frmAGS_pay');
                                alert("cert 성공");
                                AlltheGatePay($('#frmAGS_pay').get(0)); // 결제인증창 호출
                            } else {
                                alert("cert 실패");
                            }
                        }); */


                        doPay();

                        return false;
                    } else if(paymentPgCd == '81') { // PAYPAL
                        PayPalUtil.openPaypal();
                        return false;
                    } else if(paymentPgCd == '41') { // PAYCO
                        PaycoUtil.callPaycoUrl();
                        return false;
                    }
                } else {
                    if(paymentWayCd == '11') {
                        if($('[name=bankCd]').val() == '') {
                            Dmall.LayerUtil.alert('입금은행을 선택해 주십시요.').done(function(){
                                $('[name=bankCd]').focus();
                            });
                            return false;
                        } else {
                            $('[name=bankCd]').find('option:selected').each(function(){
                                var d = $(this).data();
                                $('#depositActNo').val(d.actNo);
                                $('#depositHolderNm').val(d.holderNm);
                            })
                        }
                    }
                    $('#frmAGS_pay').attr('action','${_MOBILE_PATH}/front/order/order-insert');
                    $('#frmAGS_pay').submit();
                }
            });

            /* 거주지 선택 제어 */
            $('[name=memberGbCd]').on('click',function(){
                $('[class^=radio_con_]').each(function(){
                    $(this).find('input').val();
                })
            })

            /* 결제수단 선택 제어 */
            /* === 결제방법 선택 === */

            $( "ul.payment_method_info" ).hide();
            //$( "ul.payment_method_info:first" ).show();

            $("ul.payment_method li").click(function () {

                var paymentWayCd = $(this).children('input[name=payWayCd]').val();
                $("#paymentWayCd").val(paymentWayCd);
                $('[class^=tr_]').hide();
                $('[class^=tr_]').each(function(){
                    if($(this).hasClass('tr_'+paymentWayCd)) {
                        $(this).show()
                    }
                });

                //간편결제(payco 선택시)
                if(paymentWayCd === '31') {
                    $('#paymentPgCd').val('41');
                } else if(paymentWayCd=== '41') {
                  //페이팔 선택시
                  $('#paymentPgCd').val('81');
                } else {
                    $('#paymentPgCd').val('${pgPaymentConfig.data.pgCd}');
                }

                $("ul.payment_method li").removeClass("active");

                $(this).addClass("active");
                //KCP
                <c:if test="${pgPaymentConfig.data.pgCd eq '01'}">

                    if(paymentWayCd ==='23'){
                    //신용카드
                    $("#ActionResult").val('card');
                    }else if(paymentWayCd ==='21'){
                    //실시간계좌이체
                    $("#ActionResult").val('acnt');
                    }else if(paymentWayCd ==='22'){
                    //가상계좌입금
                    $("#ActionResult").val('vcnt');
                    }else if(paymentWayCd ==='24'){
                    //핸드폰결제
                    $("#ActionResult").val('mobx');
                    }
                    /* else if(paymentWayCd ==='11'){
                    //무통장입금
                    $("#ActionResult").val('mobx');
                    } */

                </c:if>


                initPaymentConfig();

            });

           /*  $('input[name=paymentWayCd]').on('click',function(){
                var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                $('[class^=tr_]').hide();
                $('[class^=tr_]').each(function(){
                    if($(this).hasClass('tr_'+paymentWayCd)) {
                        $(this).show()
                    }
                });

                //간편결제(payco 선택시)
                if($(this).val() === '31') {
                    $('#paymentPgCd').val('41');
                }
                initPaymentConfig();
            }) */

            $('.radio_chack_a').on('click', function(){
                $('li.radio_con_a').show();
                $('li.radio_con_b').hide();
            });
            $('.radio_chack_b').on('click', function(){
                $('li.radio_con_b').show();
                $('li.radio_con_a').hide();
            });

            /* 비회원 약관동의 팝업*/
            $('[class^=btn_agree_view]').on('click', function(){
                var conts =    $(this).siblings("textarea");
                conts.toggle();

/*                 $("#popup_nomember #conts").html(conts);
                Dmall.LayerPopupUtil.open($('#popup_nomember'));*/

            });

            /* === popup coupon === */
            $("#btn").click(function(){
                $.blockUI({
                    message:$('#popup_coupon')
                    ,css:{
                        width:     '100%',
                        position:  'fixed',
                        top:       '50px',
                        left:      '0',
                    }
                    ,onOverlayClick: $.unblockUI
                });
            });

            /* 배송 메세지 */
            $('#shipping_message').on('change',function(){
                if($('#shipping_message').find('option:selected').val() == '') {
                    $('#dlvrMsg').val('');
                    $('#dlvrText').show();
                } else {
                    $('#dlvrText').hide();
                    $('#dlvrMsg').val($('#shipping_message').find('option:selected').val());

                }
            })

        });
        // document ready End

        /* 결제입력정보 초기화 */
        function initPaymentConfig() {
            $('[class^=tr_]').each(function(){
                $(this).find('input[type=text]').val('');
                $(this).find('select').val('');
                $(this).find('select').trigger('change');
            });
            //에스크로 radio 초기화
            $('#service_no').prop('checked',true);
            //매출증빙 radio 초기화
            $('#shop_paper01').prop('checked',true);
            $('.radio_chack1_a').trigger('click');
            $('#shop_view01').prop('checked',false);
            $('#shop_view02').prop('checked',false);
            $('#cashMobile').val('');
            //주문동의 초기화
            $('#order_agree').prop('checked',false);
        }

        function commaNumber(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        };

        /* 마켓포인트 계산 */
        function jsCalcMileageAmt() {
            var mileage = Number($('#mileage').val()); //보유마켓포인트
            var useMileageAmt = Number($('#mileageAmt').val().replace(',','')); //사용 마켓포인트
            var paymentAmt = Number($('#paymentAmt').val()); //결제금액
            $('#mileageTotalAmt').val(useMileageAmt);
            $('#mileageAmt').val(commaNumber(useMileageAmt));
            $('#totalMileageAmt').html('(-) ' + commaNumber(useMileageAmt) +' 원');
            if(useMileageAmt > mileage) {
                Dmall.LayerUtil.alert('사용가능 마켓포인트를 초과 하였습니다.').done(function(){
                    $('#mileageAmt').val(0);
                    $('#mileageTotalAmt').val(0);
                    $('#totalMileageAmt').html('(-) ' + 0 +' 원');
                    jsCalcTotalAmt();
                    return false;
                });
            }
            if(useMileageAmt > paymentAmt) {
                Dmall.LayerUtil.alert('사용 마켓포인트가 결제금액보다 많습니다.').done(function(){
                    $('#mileageAmt').val(0);
                    $('#mileageTotalAmt').val(0);
                    $('#totalMileageAmt').html('(-) ' + 0 +' 원');
                    jsCalcTotalAmt();
                    return false;
                });
            }
            jsCalcTotalAmt();
        }

        /* 마켓포인트 전액 사용 */
        function jsUseAllMileageAmt() {
            var mileage = Number($('#mileage').val()); //보유마켓포인트
            var paymentAmt = Number($('#paymentAmt').val()); //결제금액
            if(paymentAmt > mileage) {
                $('#mileageTotalAmt').val(mileage);
                $('#mileageAmt').val(commaNumber(mileage));
                $('#totalMileageAmt').html('(-) ' + commaNumber(mileage) +' 원');
            } else {
                $('#mileageTotalAmt').val(paymentAmt);
                $('#mileageAmt').val(commaNumber(paymentAmt));
                $('#totalMileageAmt').html('(-) ' + commaNumber(paymentAmt) +' 원');
            }
            jsCalcTotalAmt();
        }

        /* 결제금액 계산 */
        function jsCalcTotalAmt() {
            var orderTotalAmt = Number($('#orderTotalAmt').val()); //총주문금액
            var dcTotalAmt = Number($('#dcAmt').val()); //총할인금액
            var mileageTotalAmt = Number($('#mileageTotalAmt').val()); //마켓포인트
            var dlvrTotalAmt = Number($('#dlvrTotalAmt').val()); //배송비
            var addDlvrAmt = Number($('#addDlvrAmt').val()); //추가배송비
            $('#paymentAmt').val(orderTotalAmt+dlvrTotalAmt+addDlvrAmt-dcTotalAmt-mileageTotalAmt);
            $('#totalPaymentAmt').html(commaNumber(orderTotalAmt+dlvrTotalAmt+addDlvrAmt-dcTotalAmt-mileageTotalAmt)+' 원');
        }

        /* 우편번호 정보 반환 */
        function setZipcode(data) {
            var fullAddr = data.address; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수
            // 기본 주소가 도로명 타입일때 조합한다.
            if (data.addressType === 'R') {
                //법정동명이 있을 경우 추가한다.
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('#postNo').val(data.zonecode);
            $('#numAddr').val(data.jibunAddress);
            $('#roadnmAddr').val(data.roadAddress);
            //지역 추가 배송비 설정
            jsSetAreaAddDlvr();
        }

        /* 이용안내 팝업 */
        function popupInfo(type) {
            if(type == 'vBank') { //가상계좌, 무통장
                Dmall.LayerPopupUtil.open($('#popup_bank'));
            } else if(type == 'isp') { //안전결제
                Dmall.LayerPopupUtil.open($('#popup_safe_checkout'));
            } else if(type == 'safe') { //안심클릭
                Dmall.LayerPopupUtil.open($('#popup_safe_click'));
            } else if(type == 'official') { //공인인증서
                Dmall.LayerPopupUtil.open($('#popup_official'));
            } else if(type == 'account') { //실시간계좌이체
                Dmall.LayerPopupUtil.open($('#popup_account'));
            } else if(type == 'accountTime') { //은행별 이용가능시간
                Dmall.LayerPopupUtil.open($('#popup_account_time'));
            } else if(type == 'evidence') { //증빙발급
                    Dmall.LayerPopupUtil.open($('#popup_evidence'));
            } else if(type == 'hpp') { //휴대폰
                    Dmall.LayerPopupUtil.open($('#popup_hpp'));
            }
        }



        //숫자만 입력 가능 메소드
        function onlyNumDecimalInput(event){
            var code = window.event.keyCode;
            if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
                window.event.returnValue = true;
                return;
            }else{
                window.event.returnValue = false;
                return false;
            }
        }

        //주문자정보와 같음 체크 박스 체크
        function setAdrsInfo() {
            if($('#rule01_agree').is(':checked')) {
                $('#adrsNm').val($('#ordrNm').val());
                $('#adrsTel01').val($('#ordrTel01').val());
                $('#adrsTel02').val($('#ordrTel02').val());
                $('#adrsTel03').val($('#ordrTel03').val());
                $('#adrsMobile01').val($('#ordrMobile01').val());
                $('#adrsMobile02').val($('#ordrMobile02').val());
                $('#adrsMobile03').val($('#ordrMobile03').val());
                $('#shipping_address').prop('checked',true);
                $('#shipping_address').trigger('click');
            } else {
                $('#adrsNm').val('');
                $('#adrsTel01').val('');
                $('#adrsTel02').val('');
                $('#adrsTel03').val('');
                $('#adrsMobile01').val('');
                $('#adrsMobile02').val('');
                $('#adrsMobile03').val('');
                $('[name=shipping_address]').each(function(){
                    $(this).prop('checked',false);
                });
                resetAddr();
                jsSetAreaAddDlvr();
            }
        }

        //배송지 초기화
        function resetAddr() {
            $('#postNo').val('');
            $('#numAddr').val('');
            $('#roadnmAddr').val('');
            $('#dtlAddr').val('');
            $('#frgAddrCountry').val('');
            $('#frgAddrCity').val('');
            $('#frgAddrState').val('');
            $('#frgAddrZipCode').val('');
            $('#frgAddrDtl1').val('');
            $('#frgAddrDtl2').val('');
        }

        //지역 추가 배송비 설정
        function jsSetAreaAddDlvr() {
            var flag = false;
            var postNo = $('#postNo').val();
            if($.trim(postNo) != '') {
                var url = '/front/order/area-additional-cost';
                var param = {};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        //모두 방문 수령인 경우에 지역할인 배송비는 추가되지 않는다.
                        $('input[name="areaDlvrArr"]').each(function(){
                            if($(this).val() != '04') {
                                flag = true;
                            }
                        });
                        if(flag) {
                            for(var i=0; i<result.resultList.length;i++) {
                                if(result.resultList[i].postNo == postNo) {
                                    flag = true;
                                    var addDlvrPrice = result.resultList[i].dlvrc;
                                    var areaDlvrSetNo = result.resultList[i].areaDlvrSetNo;
                                    $('#addDlvrAmt').val(parseInt(addDlvrPrice));
                                    $('#areaDlvrSetNo').val(areaDlvrSetNo);
                                    $('#totalAddDlvrAmt').html('(+) '+commaNumber(parseInt(addDlvrPrice))+' 원');
                                    jsCalcTotalAmt();
                                    break;
                                }
                            }
                        } else {
                            $('#addDlvrAmt').val(0);
                            $('#totalAddDlvrAmt').html('(+) '+0+' 원');
                            jsCalcTotalAmt();
                        }
                    }
                });
            }
        }
        function iniPaySubmit(){
            $('#frmAGS_pay').attr('action','${_MOBILE_PATH}/front/order/order-insert');
            $('#frmAGS_pay').submit();
        }

        //계산서 우편번호 팝업
        function billPost() {
            Dmall.LayerPopupUtil.zipcode(setBillZipcode);
        }

        /* 계산서 우편번호 정보 반환 */
        function setBillZipcode(data) {
            var fullAddr = data.address; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수
            // 기본 주소가 도로명 타입일때 조합한다.
            if (data.addressType === 'R') {
                //법정동명이 있을 경우 추가한다.
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('#billPostNo').val(data.zonecode);
            //$('#numAddr').val(data.jibunAddress);
            $('#billRoadnmAddr').val(data.roadAddress);
        }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 03.LAYOUT: MIDDLE AREA --->
    <div id="middle_area">
        <div class="cart_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            주문결제
        </div>
        <ul class="order_steps">
            <li>
                <span class="icon_steps01"></span>
                <span class="title">장바구니</span>
            </li>
            <li class="selected">
                <span class="icon_steps02"></span>
                <span class="title">주문결제</span>
            </li>
            <li>
                <span class="icon_steps03"></span>
                <span class="title">주문완료</span>
            </li>
        </ul>
    <form name="frmAGS_pay" id="frmAGS_pay" method="post" accept-charset="UTF-8">
        <!--- 주문 목록 --->
        <div class="cart_detail_area">
            <h2 class="cart_stit"><span>주문고객 정보</span></h2>
            <ul class="order_detail_list">
                <li class="form">
                    <span class="title">주문자명</span>
                    <p class="detail">
                        <input type="text" name="ordrNm" id="ordrNm" value="${member_info.data.memberNm}">
                        <c:if test="${deliveryList.resultList ne null && fn:length(deliveryList.resultList) gt 0}">
                        <c:forEach var="deliveryList" items="${deliveryList.resultList}" varStatus="status">
                            <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                            <input type="hidden" name="basicMemberGbCd" id="basicMemberGbCd" value="${deliveryList.memberGbCd}">
                            <input type="hidden" name="basicPostNo" id="basicPostNo" value="${deliveryList.newPostNo}">
                            <input type="hidden" name="basicNumAddr" id="basicNumAddr" value="${deliveryList.strtnbAddr}">
                            <input type="hidden" name="basicRoadnmAddr" id="basicRoadnmAddr" value="${deliveryList.roadAddr}">
                            <input type="hidden" name="basicDtlAddr" id="basicDtlAddr" value="${deliveryList.dtlAddr}">
                            <input type="hidden" name="basicFrgAddrCountry" id="basicFrgAddrCountry" value="${deliveryList.frgAddrCountry}">
                            <input type="hidden" name="basicFrgAddrCity" id="basicFrgAddrCity" value="${deliveryList.frgAddrCity}">
                            <input type="hidden" name="basicFrgAddrState" id="basicFrgAddrState" value="${deliveryList.frgAddrState}">
                            <input type="hidden" name="basicFrgAddrZipCode" id="basicFrgAddrZipCode" value="${deliveryList.frgAddrZipCode}">
                            <input type="hidden" name="basicFrgAddrDtl1" id="basicFrgAddrDtl1" value="${deliveryList.frgAddrDtl1}">
                            <input type="hidden" name="basicFrgAddrDtl2" id="basicFrgAddrDtl2" value="${deliveryList.frgAddrDtl2}">
                            </c:if>
                        </c:forEach>
                        </c:if>
                        <input type="hidden" name="ordrAddr" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">이메일</span>
                    <p class="detail">
                         <input type="text" name="email01" id="email01" style="width:85px;"> @ <input type="text" name="email02" id="email02" style="width:100px;">
                         <label for="email03" class="blind"></label>
                         <select name="email03" id="email03" title="select option">
                             <option value="" selected>- 이메일 선택 -</option>
                             <option value="naver.com">naver.com</option>
                             <option value="daum.net">daum.net</option>
                             <option value="nate.com">nate.com</option>
                             <option value="hotmail.com">hotmail.com</option>
                             <option value="yahoo.com">yahoo.com</option>
                             <option value="empas.com">empas.com</option>
                             <option value="korea.com">korea.com</option>
                             <option value="dreamwiz.com">dreamwiz.com</option>
                             <option value="gmail.com">gmail.com</option>
                             <option value="etc">직접입력</option>
                         </select>
                         <input type="hidden" name="ordrEmail" id="ordrEmail" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">연락처</span>
                    <p class="detail">
                       <select name="ordrTel01" id="ordrTel01" style="width:60px">
                           <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                       </select>
                       -
                       <input type="text" name="ordrTel02" id="ordrTel02" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                       -
                       <input type="text" name="ordrTel03" id="ordrTel03" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                       <input type="hidden" name="ordrTel" id="ordrTel" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">휴대폰</span>
                    <p class="detail">
                       <select name="ordrMobile01" id="ordrMobile01" style="width:60px">
                           <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                       </select>
                       -
                       <input type="text" name="ordrMobile02" id="ordrMobile02" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                       -
                       <input type="text" name="ordrMobile03" id="ordrMobile03" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                       <input type="hidden" name="ordrMobile" id="ordrMobile" value="">
                    </p>
                </li>
            </ul>
            <h2 class="cart_stit">
                <span>배송지 정보</span>
                <div class="qna_check  floatR order_info_checked">
                    <label>
                        <input type="checkbox" name="rule01_agree" id="rule01_agree" onclick="setAdrsInfo();">
                        <span></span>
                    </label>
                    <label for="rule01_agree">주문자정보와 같음</label>
                </div>
            </h2>
            <ul class="order_detail_list">
                <c:if test="${user.session.memberNo ne null}">
                <li class="address_check">
                    <input type="radio" id="shipping_address" name="shipping_address" value="1">
                    <label for="shipping_address"  style="margin-right:15px">
                        <span></span>
                        기본배송지
                    </label>
                    <input type="radio" id="recently_shipping_address" name="shipping_address" value="2">
                    <label for="recently_shipping_address"  style="margin-right:15px">
                        <span></span>
                        최근배송지
                    </label>
                    <input type="radio" id="new_shipping_address01" name="shipping_address" value="3">
                    <label for="new_shipping_address01">
                        <span></span>
                        신규배송지
                    </label>
                    <span id="newDelivery" style="display:none;">

                    </span>
                    <%--  최근 배송지--%>
                    <input type="hidden" name="recentMemberGbCd" id="recentMemberGbCd" value="${recentlyDeliveryInfo.data.memberGbCd}">
                    <input type="hidden" name="recentAdrsTel" id="recentAdrsTel" value="${recentlyDeliveryInfo.data.adrsTel}">
                    <input type="hidden" name="recentAdrsMobile" id="recentAdrsMobile" value="${recentlyDeliveryInfo.data.adrsMobile}">
                    <input type="hidden" name="recentAdrsNm" id="recentAdrsNm" value="${recentlyDeliveryInfo.data.adrsNm}">
                    <input type="hidden" name="recentPostNo" id="recentPostNo" value="${recentlyDeliveryInfo.data.postNo}">
                    <input type="hidden" name="recentNumAddr" id="recentNumAddr" value="${recentlyDeliveryInfo.data.numAddr}">
                    <input type="hidden" name="recentRoadnmAddr" id="recentRoadnmAddr" value="${recentlyDeliveryInfo.data.roadnmAddr}">
                    <input type="hidden" name="recentDtlAddr" id="recentDtlAddr" value="${recentlyDeliveryInfo.data.dtlAddr}">
                    <input type="hidden" name="recentFrgAddrCountry" id="recentFrgAddrCountry" value="${recentlyDeliveryInfo.data.frgAddrCountry}">
                    <input type="hidden" name="recentFrgAddrCity" id="recentFrgAddrCity" value="${recentlyDeliveryInfo.data.frgAddrCity}">
                    <input type="hidden" name="recentFrgAddrState" id="recentFrgAddrState" value="${recentlyDeliveryInfo.data.frgAddrState}">
                    <input type="hidden" name="recentFrgAddrZipCode" id="recentFrgAddrZipCode" value="${recentlyDeliveryInfo.data.frgAddrZipCode}">
                    <input type="hidden" name="recentFrgAddrDtl1" id="recentFrgAddrDtl1" value="${recentlyDeliveryInfo.data.frgAddrDtl1}">
                    <input type="hidden" name="recentFrgAddrDtl2" id="recentFrgAddrDtl2" value="${recentlyDeliveryInfo.data.frgAddrDtl2}">
                </li>
                </c:if>
                <li class="form">
                    <span class="title">수령인</span>
                    <p class="detail">
                        <input type="text" name="adrsNm" id="adrsNm" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">연락처</span>
                    <p class="detail">
                    <select name="adrsTel01" id="adrsTel01" style="width:60px">
                        <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                    </select>
                    -
                    <input type="text" name="adrsTel02" id="adrsTel02" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                    -
                    <input type="text" name="adrsTel03" id="adrsTel03" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                    <input type="hidden" name="adrsTel" id="adrsTel" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">핸드폰</span>
                    <p class="detail total">
                        <select name="adrsMobile01" id="adrsMobile01" style="width:60px">
                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                        </select>
                        -
                        <input type="text" name="adrsMobile02" id="adrsMobile02" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                        -
                        <input type="text" name="adrsMobile03" id="adrsMobile03" style="width:40px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                        <input type="hidden" name="adrsMobile" id="adrsMobile" value="">
                    </p>
                </li>
                <li class="form">
                    <span class="title">거주지</span>
                    <p class="detail total">
                        <input type="radio" id="shipping_internal" name="memberGbCd" value="10" checked="checked">
                        <label for="shipping_internal" class="radio_chack_a" style="margin-right:15px">
                            <span></span>
                            국내
                        </label>
                        <input type="radio" id="shipping_oversea" name="memberGbCd" value="20">
                        <label for="shipping_oversea" class="radio_chack_b" style="margin-right:15px">
                            <span></span>
                            해외
                        </label>
                    </p>
                </li>

                <!--국내 선택시 default-->
                <li class="radio_con_a form">
                    <span class="title">배송지</span>
                    <p class="address_detail">
                        <input type="text" name="postNo" id="postNo" style="width:124px;margin-right:5px" readonly>
                        <button type="button" class="btn_post">우편번호</button><br>

                        지번주소<input type="text" name="numAddr" id="numAddr" style="width:100%;" readonly><br>
                        도로명주소<input type="text" name="roadnmAddr" id="roadnmAddr" style="width:100%;" readonly><br>
                        상세주소<input type="text" name="dtlAddr" id="dtlAddr" style="width:100%;">
                         <input type="hidden" name="adrsAddr" value="">
                    </p>
                </li>
                <!--//국내 선택시 default-->
                <!--해외 선택시-->
                <li class="radio_con_b form" style="display:none;">
                    <span class="title">배송지</span>
                    <p class="address_detail">
                           <span class="address_tit" style="width:65px">Country</span>
                           <select class="select_option" title="select option" name="frgAddrCountry" id="frgAddrCountry">
                               <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true"  mode="S"/>
                           </select>
                           <span class="address_tit" style="width:65px">Zip</span><input type="text" name="frgAddrZipCode" id="frgAddrZipCode" style="width:100%;">
                           <span class="address_tit" style="width:65px">State</span><input type="text" name="frgAddrState" id="frgAddrState" style="width:100%;">
                           <span class="address_tit" style="width:65px">City</span><input type="text" name="frgAddrCity" id="frgAddrCity" style="width:100%;">
                           <span class="address_tit" style="width:65px">address1</span><input type="text" name="frgAddrDtl1" id="frgAddrDtl1" style="width:100%;">
                           <span class="address_tit" style="width:65px">address2</span><input type="text" name="frgAddrDtl2" id="frgAddrDtl2" style="width:100%;">
                    </p>
                </li>
                <!--//해외 선택시-->
                <li class="form">
                    <span class="title02">배송시요구사항</span>
                    <p class="">
                    <select id="shipping_message" style="width:648px">
                       <option value="배송전, 연락바랍니다.">배송전, 연락바랍니다.</option>
                       <option value="부재시, 전화주시거나 또는 문자 남겨주세요.">부재시, 전화주시거나 또는 문자 남겨주세요.</option>
                       <option value="부재시, 경비실에 맡겨주세요.">부재시, 경비실에 맡겨주세요.</option>
                       <option value="">기타</option>
                    </select>
                    <span id="dlvrText" style="display:none">
                    <input type="text" name="dlvrMsg" id="dlvrMsg" style="width:calc(100% - 12px)" value="배송전, 연락바랍니다." placeholder="택배 기사님께 전달할 메세지를 입력해주세요.">
                    </span>
                    </p>
                </li>
            </ul>
            <h2 class="cart_stit"><span>주문상품</span></h2>
            <ul class="order_list">
                <c:set var="orderTotalAmt" value="0"/>
                <c:set var="dlvrTotalAmt" value="0"/>
                <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
                    <c:set var="totalAddOptionAmt" value="0"/><c:set var="totalAddOptionAmt" value="0"/>
                    <c:set var="addOptArr" value=""/>
                <li style="margin-top:-1px">
                    <div class="order_product_info02">
                        <ul class="order_info_top">
                            <li class="order_product_pic"><img src="${orderGoodsList.imgPath}"></li>
                            <li class="order_product_title">${orderGoodsList.goodsNm}</li>
                        </ul>
                        <ul class="order_info_text">
                            <li>
                                <span class="option_title">
                                 <c:if test="${orderGoodsList.itemNm1 ne null}">
                                 ${orderGoodsList.itemNm1}
                                 </c:if>
                                 <c:if test="${orderGoodsList.itemNm2 ne null}">
                                 ${orderGoodsList.itemNm2}
                                 </c:if>
                                 <c:if test="${orderGoodsList.itemNm3 ne null}">
                                 ${orderGoodsList.itemNm3}
                                 </c:if>
                                 <c:if test="${orderGoodsList.itemNm4 ne null}">
                                 ${orderGoodsList.itemNm4}
                                 </c:if>
                                <fmt:formatNumber value="${orderGoodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 개
                                </span>
                                <span class="option_price"><em><fmt:formatNumber value="${orderGoodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
                            </li>
                            <c:if test="${orderGoodsList.goodsAddOptList ne null}">
                            <c:forEach var="goodsAddOptionList" items="${orderGoodsList.goodsAddOptList}" varStatus="status1">
                                <li>
                                <span class="option_title"> ${goodsAddOptionList.addOptNm}:${goodsAddOptionList.addOptValue} / <fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/>개</span>
                                <span class="option_price"><em>(+<fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt*goodsAddOptionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)</em>원</span>
                                </li>
                                <c:if test="${addOptArr ne ''}">
                                    <c:set var="addOptArr" value="${addOptArr}*"/>
                                </c:if>
                                <c:set var="addOptArr" value="${addOptArr}${goodsAddOptionList.addOptNo}^${goodsAddOptionList.addOptDtlSeq}^${goodsAddOptionList.addOptBuyQtt}"/>
                                <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                            </c:forEach>
                            </c:if>
                        </ul>
                            <c:set var="ordQttMinLimitYn" value="N"/>
                            <c:set var="ordQttMaxLimitYn" value="N"/>
                            <c:if test="${orderGoodsList.minOrdLimitYn eq 'Y'}">
                                <c:if test="${orderGoodsList.minOrdQtt gt orderGoodsList.ordQtt}">
                                    <c:set var="ordQttMinLimitYn" value="Y"/>
                                </c:if>
                            </c:if>
                            <c:if test="${orderGoodsList.maxOrdLimitYn eq 'Y'}">
                                <c:if test="${orderGoodsList.maxOrdQtt lt orderGoodsList.ordQtt}">
                                    <c:set var="ordQttMaxLimitYn" value="Y"/>
                                </c:if>
                            </c:if>
                            <input type="hidden" name="minOrdQtt" value="${orderGoodsList.minOrdQtt}"><%-- 구매수량제한 확인용(최소)--%>
                            <input type="hidden" name="ordQttMinLimitYn" value="${ordQttMinLimitYn}"><%-- 구매수량제한 확인용(최소)--%>
                            <input type="hidden" name="maxOrdQtt" value="${orderGoodsList.maxOrdQtt}"><%-- 구매수량제한 확인용(최대)--%>
                            <input type="hidden" name="ordQttMaxLimitYn" value="${ordQttMaxLimitYn}"><%-- 구매수량제한 확인용(최대)--%>
                            <input type="hidden" name="limitItemNm" value="${orderGoodsList.goodsNm}"><%-- 구매수량제한 확인용--%>
                        <ul class="order_price floatC">
                            <li><span class="tit">할인금액</span>
                            <%-- 할인금액 계산(기획전 -> 등급할인 순서) --%>
                             <c:set var="dcPrice" value="0"/> <%-- 할인금액SUM(기획전+등급할인) --%>
                             <c:set var="prmtDcPrice" value="0"/> <%-- 기획전 할인 --%>
                             <c:set var="eachPrmtDcPrice" value="0"/> <%-- 기획전 할인(수량 곱하지 않은 값) --%>
                             <c:set var="memberGradeDcPrice" value="0"/> <%-- 등급 할인 --%>
                             <c:set var="eachMemberGradeDcPrice" value="0"/><%-- 등급 할인(수량 곱하지 않은 값) --%>
                             <%-- 할인금액 계산(기획전)--%>
                             <c:choose>
                                 <c:when test="${orderGoodsList.dcRate == 0}">
                                     <c:set var="prmtDcPrice" value="0"/>
                                 </c:when>
                                 <c:otherwise>
                                     <c:set var="prmtDcPrice" value="${orderGoodsList.saleAmt*(orderGoodsList.dcRate/100)/10}"/>
                                     <c:set var="eachPrmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)}"/>
                                     <c:set var="prmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)*orderGoodsList.ordQtt}"/>
                                 </c:otherwise>
                             </c:choose>
                             <%-- 할인금액 계산(등급할인)--%>
                             <c:if test="${member_info ne null}">
                             <c:choose>
                                 <c:when test="${member_info.data.dcValue == 0}">
                                     <c:set var="memberGradeDcPrice" value="0"/>
                                 </c:when>
                                 <c:otherwise>
                                     <c:choose>
                                         <c:when test="${member_info.data.dcUnitCd eq '1'}">
                                             <c:set var="dcUnitCd" value="01"/>
                                             <c:set var="memberGradeDcPrice" value="${(orderGoodsList.saleAmt-prmtDcPrice)*(member_info.data.dcValue/100)/10}"/>
                                             <c:set var="eachMemberGradeDcPrice" value="${((memberGradeDcPrice-(memberGradeDcPrice%1))*10)}"/>
                                             <c:set var="memberGradeDcPrice" value="${((memberGradeDcPrice-(memberGradeDcPrice%1))*10)*orderGoodsList.ordQtt}"/>
                                         </c:when>
                                         <c:otherwise>
                                             <c:set var="dcUnitCd" value="02"/>
                                             <c:set var="eachMemberGradeDcPrice" value="${member_info.data.dcValue}"/>
                                             <c:set var="memberGradeDcPrice" value="${member_info.data.dcValue*orderGoodsList.ordQtt}"/>
                                         </c:otherwise>
                                     </c:choose>
                                 </c:otherwise>
                             </c:choose>
                             </c:if>
                             <c:set var="dcPrice" value="${prmtDcPrice+memberGradeDcPrice}"/>
                             <c:set var="pvdSvmnAmt" value="0"/>
                             <c:set var="gradePvdSvmnAmt" value="0"/>
                             <c:set var="pvdSvmnTotalAmt" value="0"/>
                             <c:set var="svmnTruncStndrdCd" value="1"/>
                             <%-- 적립예정금 절사 설정 --%>
                             <c:choose>
                                 <c:when test="${site_info.svmnTruncStndrdCd eq '1'}">
                                     <c:set var="svmnTruncStndrdCd" value="10"/>
                                 </c:when>
                                 <c:when test="${site_info.svmnTruncStndrdCd eq '2'}">
                                     <c:set var="svmnTruncStndrdCd" value="100"/>
                                 </c:when>
                             </c:choose>
                             <%-- 적립예정금 계산(상품별) --%>
                             <c:choose>
                                <c:when test="${orderGoodsList.goodsSvmnPolicyUseYn eq 'Y'}">
                                <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                    <c:set var="pvdSvmnAmt" value="${(orderGoodsList.saleAmt-dcPrice)*(site_info.svmnPvdRate/100)/svmnTruncStndrdCd}"/>
                                    <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
                                </c:if>
                                </c:when>
                                <c:when test="${orderGoodsList.goodsSvmnPolicyUseYn eq 'N'}">
                                    <c:set var="pvdSvmnAmt" value="${orderGoodsList.goodsSvmnAmt}"/>
                                </c:when>
                            </c:choose>
                            <%-- 적립예정금 계산(등급혜택) --%>
                            <c:if test="${user.session.memberNo ne null}">
                                <c:set var="gradePvdSvmnAmt" value="${(orderGoodsList.saleAmt-dcPrice)*(member_info.data.svmnValue/100)/svmnTruncStndrdCd}"/>
                                <c:set var="gradePvdSvmnAmt" value="${(gradePvdSvmnAmt-(gradePvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
                            </c:if>
                            <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt + gradePvdSvmnAmt}"/>
                            <span class="fRed">
                                <fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                            </span>
                            </li>

                            <li>
                                <span class="tit">주문금액</span>
                                <c:set var="goodstotalAmt" value="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)+totalAddOptionAmt}"/>
                                <em><fmt:formatNumber value="${goodstotalAmt-dcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
                            </li>
                            <li>
                                <span class="tit">배송비</span>
                                <span class="fRed">
                                <%-- 배송비 계산 --%>
                                <c:choose>
                                    <c:when test="${orderGoodsList.dlvrSetCd eq '1' && orderGoodsList.dlvrcPaymentCd eq '01'}">
                                        <c:set var="grpId" value="${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                    </c:when>
                                    <c:when test="${orderGoodsList.dlvrSetCd eq '1' && orderGoodsList.dlvrcPaymentCd eq '02'}">
                                        <c:set var="grpId" value="${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                    </c:when>
                                    <c:when test="${orderGoodsList.dlvrSetCd eq '4' && orderGoodsList.dlvrcPaymentCd eq '02'}">
                                        <c:set var="grpId" value="${orderGoodsList.goodsNo}**${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="grpId" value="${orderGoodsList.itemNo}**${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${preGrpId ne grpId }">
                                    <c:choose>
                                        <c:when test="${dlvrPriceMap.get(grpId) eq '0'}">
                                            <c:choose>
                                                <c:when test="${orderGoodsList.dlvrcPaymentCd eq '03'}">
                                                    착불
                                                </c:when>
                                                <c:when test="${orderGoodsList.dlvrcPaymentCd eq '04'}">
                                                    매장픽업
                                                </c:when>
                                                <c:otherwise>
                                                    무료
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                        <fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var="dlvrTotalAmt" value="${dlvrTotalAmt+ dlvrPriceMap.get(grpId)}"/>
                                </c:if>
                                <c:set var="preGrpId" value="${grpId}"/>
                                </span>
                            </li>                            
                        </ul>

                    </div>
                    <c:set var="preGrpId" value="${grpId}"/>
                    <c:set var="orderTotalAmt" value="${orderTotalAmt+goodstotalAmt}"/>
                    <fmt:parseNumber var="pvdSvmnTotalAmt" type='number' value='${pvdSvmnTotalAmt+(pvdSvmnAmt*orderGoodsList.ordQtt)}'/>
                    <c:set var="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}"/>
                    <c:set var="promotionTotalDcAmt" value="${promotionTotalDcAmt+prmtDcPrice}"/>
                    <c:set var="memberGradeTotalDcAmt" value="${memberGradeTotalDcAmt+memberGradeDcPrice}"/>
                    <input type="hidden" name="dlvrPriceMap" value="${dlvrPriceMap}">
                    <input type="hidden" name="dlvrCountMap" value="${dlvrCountMap}">
                    <input type="hidden" name="goodsNo" value="${orderGoodsList.goodsNo}">
                    <input type="hidden" name="goodsNm" value="${orderGoodsList.goodsNm}">
                    <input type="hidden" name="itemNo" value="${orderGoodsList.itemNo}">
                    <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                    <input type="hidden" name="escwAmt" value="<fmt:parseNumber  type='number' value='${goodstotalAmt}'/>">
                    <input type="hidden" name="basicDcPrice" value="<fmt:parseNumber type='number' value='${dcPrice}'/>"><%-- 상품별 할인금액 계산용 --%>
                    <%-- 상품별 기획전 할인 정보 배열(프로모션번호▦혜택코드▦혜택값▦총할인금액) --%>
                    <c:choose>
                        <c:when test="${prmtDcPrice gt 0 }">
                        <input type="hidden" name="goodsPromotionDcInfo" value="${orderGoodsList.prmtNo}▦01▦${orderGoodsList.dcRate}▦<fmt:parseNumber type='number' value='${prmtDcPrice}'/>">
                        </c:when>
                        <c:otherwise>
                        <input type="hidden" name="goodsPromotionDcInfo" value="">
                        </c:otherwise>
                    </c:choose>
                    <%-- 상품별 회원등급 할인 정보 배열(회원등급코드▦혜택코드▦혜택값▦총할인금액) --%>
                    <c:choose>
                        <c:when test="${memberGradeDcPrice gt 0 }">
                        <input type="hidden" name="goodsMemberGradeDcInfo" value="${member_info.data.memberGradeNo}▦${dcUnitCd}▦${member_info.data.dcValue}▦<fmt:parseNumber type='number' value='${memberGradeDcPrice}'/>">
                        </c:when>
                        <c:otherwise>
                        <input type="hidden" name="goodsMemberGradeDcInfo" value="">
                        </c:otherwise>
                    </c:choose>
                    <%-- 상품별 총 할인 정보 배열--%>
                    <input type="hidden" name="goodsDcPriceInfo" value="<fmt:parseNumber type='number' value='${dcPrice}'/>">
                    <%-- 상품 정보 배열 --%>
                    <input type="hidden" name="areaDlvrArr" value="${orderGoodsList.dlvrcPaymentCd}">
                    <input type="hidden" name="itemArr" value="${orderGoodsList.goodsNo}▦${orderGoodsList.itemNo}^${orderGoodsList.ordQtt}^${orderGoodsList.dlvrcPaymentCd}▦${addOptArr}▦${orderGoodsList.ctgNo}">
                </li>
                <!-- 쿠폰 조회용 데이터 -->
                    <input type="hidden" class="couponInfo" data-goods-no="${orderGoodsList.goodsNo}" data-item-no="${orderGoodsList.itemNo}" data-goods-nm="${orderGoodsList.goodsNm}" data-goods-qtt="${orderGoodsList.ordQtt}" data-sale-price="<fmt:parseNumber type='number' value='${orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice}'/>" >
                </c:forEach>
                <c:set var="couponTotalAmt" value="0"/>
                <c:set var="mileageTotalAmt" value="0"/>
                <c:set var="paymentTotalAmt" value="${orderTotalAmt+dlvrTotalAmt-promotionTotalDcAmt-memberGradeTotalDcAmt-couponTotalAmt-mileageTotalAmt}"/>
            </ul>

            <ul class="order_detail_list">
                <li class="form">
                    <span class="title">할인쿠폰선택</span>
                    <p class="detail">
                    <c:choose>
                        <c:when test="${user.session.memberNo eq null}">
                        <span class="fRed">쿠폰을 사용하실 수 없습니다.</span>
                        <input type="hidden" name="cpUseAmt" id="cpUseAmt" value="0">
                        </c:when>
                        <c:otherwise>
                        <input type="text" name="cpUseAmt" id="cpUseAmt" value="0" style="width:100px" readonly> 원
                        <button type="button" class="btn_coupon" id="btn_checkout_info" style="margin:0 0 0 0 10px">쿠폰적용</button> <br>사용가능한 쿠폰 <span class="checkout_no" id="use_coupon_cnt">0</span>장 / 보유쿠폰 <span class="checkout_no" id="total_coupon_cnt">0</span>장
                        </c:otherwise>
                    </c:choose>
                    <!--     <input type="text" style="width:100px">
                        <button type="button" class="btn_coupon" id="btn">쿠폰적용</button> -->
                    </p>
                </li>
                <li class="form">
                    <span class="title">마켓포인트</span>
                    <p class="detail">
                        <c:choose>
                             <c:when test="${user.session.memberNo eq null}">
                                 <span class="fRed">마켓포인트를 사용하실 수 없습니다.</span>
                                 <input type="hidden" name="mileageAmt" id="mileageAmt" value="0">
                             </c:when>
                        <c:otherwise>
                        <c:choose>
                            <c:when test="${site_info.svmnUsePsbPossAmt gt member_info.data.prcAmt}">
                                <span class="fRed">마켓포인트를 사용하실 수 없습니다.</span>
                                    현재 <span class="checkout_no"><fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원 보유
                                <input type="hidden" name="mileageAmt" id="mileageAmt" value="0">
                            </c:when>
                            <c:otherwise>
                            <c:choose>
                                <c:when test="${site_info.svmnUseUnitCd eq '1'}">
                                    <c:set var="svmnUseUnitCd" value="10"/>
                                </c:when>
                                <c:when test="${site_info.svmnUseUnitCd eq '2'}">
                                    <c:set var="svmnUseUnitCd" value="100"/>
                                </c:when>
                                <c:when test="${site_info.svmnUseUnitCd eq '3'}">
                                    <c:set var="svmnUseUnitCd" value="1000"/>
                                </c:when>
                            </c:choose>
                                <input type="text" name="mileageAmt" id="mileageAmt" value="0" onKeydown="onlyNumDecimalInput(event);" onblur="jsCalcMileageAmt();" style="width:50px"> 원
                                <button type="button" class="btn_coupon" id="mileageAllUse" style="margin:0 10px 0 20px" onclick="jsUseAllMileageAmt()">전액사용</button>
                                <br>
                                <span class="point_text">현재 <em><fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원 보유</span>
                                (<fmt:formatNumber value="${svmnUseUnitCd}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 단위로 사용가능)
                                <input type="hidden" name="mileage" id="mileage" value="<fmt:parseNumber type='number' value='${member_info.data.prcAmt}'/>">
                            </c:otherwise>
                        </c:choose>
                        </c:otherwise>
                        </c:choose>
                        <!-- <input type="text" style="width:50px">
                        <span class="point_text">원 (보유마켓포인트 : <em>100</em>원)</span> -->
                    </p>
                </li>
                <li class="form">
                    <span class="title">최종결제금액</span>
                    <p class="detail total">
                        <em>
                            <span id="totalPaymentAmt">
                                <fmt:formatNumber value="${paymentTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                            </span>
                        </em>원
                    </p>
                    <%-- 주문 상품명(~~외 몇 건) --%>
                    <c:choose>
                        <c:when test="${fn:length(orderInfo.data.orderGoodsVO) gt 1}">
                        <input type="hidden" name="ordGoodsInfo" id="ordGoodsInfo" value="${orderInfo.data.orderGoodsVO[0].goodsNm} 외 ${fn:length(orderInfo.data.orderGoodsVO)-1}건">
                        </c:when>
                        <c:otherwise>
                        <input type="hidden" name="ordGoodsInfo" id="ordGoodsInfo" value="${orderInfo.data.orderGoodsVO[0].goodsNm}">
                        </c:otherwise>
                    </c:choose>
                    <%-- 총 주문금액 --%>
                    <input type="hidden" name="orderTotalAmt" id="orderTotalAmt" value="<fmt:parseNumber type='number' value='${orderTotalAmt}'/>">
                    <%-- 총 배송비 --%>
                    <input type="hidden" name="dlvrTotalAmt" id="dlvrTotalAmt" value="<fmt:parseNumber type='number' value='${dlvrTotalAmt}'/>">
                    <%-- 지역추가배송비 --%>
                    <input type="hidden" name="addDlvrAmt" id="addDlvrAmt" value="0">
                    <%-- 지역 배송 설정 번호 --%>
                    <input type="hidden" name="areaDlvrSetNo" id="areaDlvrSetNo" value="">
                    <%-- 총 기획전 할인금액 --%>
                    <input type="hidden" name="promotionTotalDcAmt" id="promotionTotalDcAmt" value="<fmt:parseNumber type='number' value='${promotionTotalDcAmt}'/>">
                    <%-- 총 회원등급 할인금액 --%>
                    <input type="hidden" name="memberGradeTotalDcAmt" id="memberGradeTotalDcAmt" value="<fmt:parseNumber type='number' value='${memberGradeTotalDcAmt}'/>">
                    <%-- 총 쿠폰 할인금액 --%>
                    <input type="hidden" name="couponTotalDcAmt" id="couponTotalDcAmt" value="0">
                    <%-- 쿠폰 사용 정보 --%>
                    <input type="hidden" name="couponUseInfo" id="couponUseInfo" value="">
                    <%-- 총 회원등급 할인금액 --%>
                    <input type="hidden" name="memberGradeTotalDcAmt" id="memberGradeTotalDcAmt" value="0">
                    <%-- 기획전+회원등급 할인금액(계산용) --%>
                    <input type="hidden" name="dcPrice" id="dcPrice" value="<fmt:parseNumber type='number' value='${promotionTotalDcAmt+memberGradeTotalDcAmt}'/>">
                    <%-- 총 할인금액(기획전+쿠폰+회원등급) --%>
                    <input type="hidden" name="dcAmt" id="dcAmt" value="<fmt:parseNumber type='number' value='${promotionTotalDcAmt+memberGradeTotalDcAmt}'/>">
                    <%-- 총 마켓포인트 사용금액 --%>
                    <input type="hidden" name="mileageTotalAmt" id="mileageTotalAmt" value="0">
                    <%-- 총 지급 적립 금액 --%>
                    <input type="hidden" name="pvdSvmnTotalAmt" id="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}">
                    <%-- 총 지역 추가 배송비 금액 --%>
                    <input type="hidden" name="addDlvrTotalAmt" id="addDlvrTotalAmt" value="0">
                    <%-- 총 결제금액 --%>
                    <input type="hidden" name="paymentAmt" id="paymentAmt" value="<fmt:parseNumber type='number' value='${paymentTotalAmt}'/>">
                </li>
            </ul>
            <h2 class="cart_stit"><span>결제방법</span></h2>
            <div class="payment_area">
                <ul class="payment_method">
                 <c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">
                    <%--
                     기존 간편결제(페이코)버튼 이미지는 수동으로 적용하였으나
                     페이코측에서 제공하는 버튼 생성 스크립트가 있으므로 그걸 사용한다.
                     --%>

                  <c:choose>
                   <c:when test="${simplePaymentConfig.data.dsnSetCd eq '01'}">
                    <li rel="method07">
                        <input type="hidden" id="paymentWayCd06" name="payWayCd" value="31">
                        <img src="${_MOBILE_PATH}/front/img/product/easypay_a1.png">
                    </li>
                   </c:when>
                   <c:otherwise>
                    <li rel="method07">
                        <input type="hidden" id="paymentWayCd06" name="payWayCd" value="31">
                        <img src="${_MOBILE_PATH}/front/img/product/easypay_a2.png">
                    </li>
                   </c:otherwise>
                  </c:choose>
                 </c:if>
                    <c:if test="${pgPaymentConfig.data.credPaymentYn eq 'Y'}">
                    <li rel="method01">
                        <input type="hidden" id="paymentWayCd03" name="payWayCd" value="23">
                        신용카드
                    </li>
                    </c:if>
                    <c:if test="${pgPaymentConfig.data.acttransPaymentYn eq 'Y'}">
                    <li rel="method02">
                        <input type="hidden" id="paymentWayCd04" name="payWayCd" value="21">
                        실시간계좌이체
                    </li>
                    </c:if>
                    <c:if test="${pgPaymentConfig.data.virtactPaymentYn eq 'Y'}">
                    <li rel="method03">
                        <input type="hidden" id="paymentWayCd02" name="payWayCd" value="22">
                        가상계좌입금
                    </li>
                    </c:if>
                    <c:if test="${pgPaymentConfig.data.mobilePaymentYn eq 'Y'}">
                    <li rel="method04">
                    <input type="hidden" id="paymentWayCd05" name="payWayCd" value="24">
                        핸드폰결제
                    </li>
                    </c:if>
                    <c:if test="${site_info.nopbpaymentUseYn eq 'Y'}">
                    <li rel="method05">
                        <input type="hidden" id="paymentWayCd01" name="payWayCd" value="11">
                        무통장입금
                    </li>
                    </c:if>
                    <c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
                    <li rel="method06">
                        <input type="hidden" id="paymentWayCd07" name="payWayCd" value="41">
                        PAYPAL
                    </li>
                    </c:if>
                </ul>
                <!--- 신용카드 선택시 --->
                <ul class="tr_23 payment_method_info" id="method01">
                    <li>
                        <span class="method_info_title">신용카드 결제안내</span>
                        [결제하기]버튼 클릭시,<br>
                        신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                        <button type="button" class="btn_view_popup" onclick="javascript:popupInfo('isp');">안전결제 안내</button>
                        <button type="button" class="btn_view_popup" onclick="javascript:popupInfo('safe');">안심클릭 안내</button>
                        <button type="button" class="btn_view_popup" onclick="javascript:popupInfo('official');">공인인증서 안내</button>
                    </li>
                </ul>
                <!---// 신용카드 선택시 --->
                <!--- 실시간계좌이체 선택시 --->
                <ul class="tr_21 payment_method_info" id="method02">
                    <li>
                        <span class="method_info_title">실시간 계좌이체 안내</span>
                        [결제하기]버튼 클릭시,<br>
                        실시간 계좌이체 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                        <div class="payment_method_info_btn_area">
                            - 회원님의 계좌에서 바로 이체되는 서비스이며, 이체 수수료는 무료입니다.
                            <button type="button" class="btn_view_popup" style="width:180px" onclick="javascript:popupInfo('account');">실시간계좌이체 이용안내</button>
                            - 23시 이후에는 은행별 이용 가능시간을 미리 확인 하신 후 결제를 진행해 주세요.
                            <button type="button" class="btn_view_popup" style="width:180px" onclick="javascript:popupInfo('accountTime');">은행별 이용가능시간 안내</button>
                        </div>
                    </li>
                </ul>
                <!---// 실시간계좌이체 선택시 --->
                <!--- 가상계좌입금 선택시 --->
                <ul class="tr_22 payment_method_info" id="method03">
                    <li>
                        <span class="method_info_title">가상계좌 입금 안내</span>
                        - 주문자명과 입금자명이 다르더라도 발급된 가상계좌번호로 정확한 금액을 입금하시면
                        정상 입금확인이 가능합니다.<br>
                        - 무통장입금 시 일부 은행(농협 및 국민은행)의 경우 ATM기기 입금이 불가할 수 있습니
                        다. 이 경우 은행 창구 또는 인터넷 뱅킹을 이용해 주시기 바랍니다.
                        <button type="button" class="btn_view_popup" style="width:180px" onclick="javascript:popupInfo('vBank');">가상계좌입금 이용안내</button>
                    </li>
                </ul>
                <!---// 가상계좌입금 선택시 --->
                <!--- 핸드폰결제 선택시 --->
                <ul class="tr_24 payment_method_info" id="method04">
                    <li>
                        <span class="method_info_title">핸드폰결제 안내</span>
                        [결제하기] 버튼 클릭시, <br>
                        핸드폰 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                        <div class="payment_method_info_btn_area">
                            - 핸드폰 결제는 통신사에 따라 결제 한도금액이 다릅니다. 자세한 내용은 핸드폰 결제안내를 확인해주세요.<br>
                            - 핸드폰 결제의 경우 가입하신 이동통신사에서 증빙을 발급 받을 수 있습니다.
                        </div>
                    </li>

                </ul>
                <!---// 핸드폰결제 선택시 --->
                <!--- 무통장입금 선택시 --->
                <ul class="tr_11 payment_method_info" id="method05">
                    <li style="padding: 20px 0 0;">
                        <span class="method_info_stit">입금은행</span>
                        <div class="check_list">
                            <!-- <input type="text" style="width:calc(30% - 12px)">
                            <select style="width:calc(70% - 10px)">
                                <option>입금은행을 선택해주세요.</option>
                            </select> -->

                            <select style="width:calc(70% - 10px)" title="select option" name="bankCd">
                                <option value="" selected="selected">입금은행을 선택해주세요.</option>
                            <c:if test="${nopbListModel.resultList ne null }">
                            <c:forEach var="nopbList" items="${nopbListModel.resultList}" varStatus="status">
                                <option value="${nopbList.bankCd}" data-act-no="${nopbList.actno}" data-holder-nm="${nopbList.holder}">
                                ${nopbList.bankNm}(${nopbList.actno}-${nopbList.holder})
                                </option>
                            </c:forEach>
                            </c:if>
                            </select>
                            <input type="hidden" name="depositActNo" id="depositActNo" value="">
                            <input type="hidden" name="depositHolderNm" id="depositHolderNm" value="">
                        </div>

                    </li>

                </ul>
                <!---// 무통장입금 선택시 --->
                <!--- 페이팔 선택시 --->
                <ul class="tr_41 payment_method_info" id="method06">
                    <li>
                        <span class="method_info_title">PAYPAL결제 안내</span>
                        [결제하기] 버튼 클릭시, <br>
                        PAYPAL 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                    </li>
                </ul>
                <!--// 페이팔 선택시 --->
                <!-- 간편결제 선택시 --->
                <ul class="tr_31 payment_method_info" id="method07">
                    <li>
                        <span class="method_info_title">간편결제 안내</span>
                        [결제하기] 버튼 클릭시, <br>
                        간편 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                        <div class="payment_method_info_btn_area">
                            - PAYCO는 NHN엔터테인먼트가 만든 안전한 간편결제 서비스입니다.<br>
                            - 휴대폰과 카드 명의자가 동일해야 하며 결제금액 제한은 없습니다.<br>
                            - 결제 가능 카드 : 모든 신용/체크 카드 결제 가능

                        </div>
                    </li>
                </ul>
                <!---// 간편결제 선택시 --->
                <!--- 무통장입금 선택시 --->
                <ul class="tr_11 payment_method_info">
                    <li>
                        <span class="method_info_title">무통장입금 안내</span>
                        [결제하기] 버튼 클릭시, <br>
                        무통장입금 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                        <div class="payment_method_info_btn_area">
                            - 주문자명과 입금자명이 다르더라도 발급된 가상계좌번호로 정확한 금액을 입금하시면 정상 입금확인이 가능합니다.<br>
                            - 무통장입금 시 일부 은행(농협 및 국민은행)의 경우 ATM기기 입금이 불가할 수 있습니다. 이 경우 은행 창구 또는 인터넷 뱅킹을 이용해 주시기 바랍니다.<br>
                        </div>
                        <button type="button" class="btn_view_popup" style="width:180px" onclick="javascript:popupInfo('vBank');">무통장입금 이용안내</button>
                    </li>
                </ul>
                <!---// 무통장입금 선택시 --->

                <!-- 에스크로서비스 이용 -->
                <c:if test="${pgPaymentConfig.data.escrowUseYn eq 'Y'}">
                <ul class="tr_21 tr_22 payment_method_info">
                    <li class="agree_check">
                        <span class="method_info_title02">에스크로서비스 이용</span>
                        정부방침에 따라 실시간계좌이체 및 무통장입금(가상계좌)로 주문하시는 경우 에스크로 서비스 이용여부를 선택하실 수 있습니다.
                        <div style="margin-top:10px">
                            <input type="radio" id="service_yes" name="escrowYn" value="Y">
                            <label for="escrow_yes" style="margin-right:20px">
                                <span></span>
                                에스크로 사용
                            </label>
                            <input type="radio" id="service_no" name="escrowYn" value="N" checked>
                            <label for="escrow_no">
                                <span></span>
                                에스크로 미사용
                            </label>
                        </div>
                    </li>
                </ul>
                </c:if>

                <!--- 매출증빙 --->
                <ul class="tr_21 tr_22 tr_23 tr_31 tr_41 payment_method_info" style="margin-top: 15px;">
                <li class="agree_check">
                        <span class="method_info_title03">매출증빙</span>
                        <div>
                            <input type="radio" id="shop_paper01" name="cashRctYn" value="N" checked="checked">
                            <label for="shop_paper01" class="radio_chack1_a" style="margin-right:20px">
                                <span></span>
                                발급안함
                            </label>
                            <c:if test="${pgPaymentConfig.data.cashRctUseYn eq 'Y'}">
                            <span class="tr_21 tr_22" style="display:none;">
                            <input type="radio" id="shop_paper02" name="cashRctYn" value="Y">
                            <label for="shop_paper02" class="radio_chack1_b" style="margin-right:20px">
                                <span></span>
                                현금영수증
                            </label>
                            </span>
                            </c:if>
                            <input type="radio" id="shop_paper03" name="cashRctYn" value="B">
                            <label for="shop_paper03" class="radio_chack1_c" >
                                <span></span>
                                계산서
                            </label>
                            <button type="button" class="btn_view_popup" style="width:180px" onclick="javascript:popupInfo('evidence');">증빙발급 안내</button>
                            <!--계산서 선택시-->
                            <div class="order_card_view radio1_con_b" style="display:none;">
                            <ul class="order_detail_list">
                                <li class="form">
                                    <span class="title">상호명</span>
                                    <p class="detail">
                                        <input type="text" name="billCompanyNm">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">사업자번호</span>
                                    <p class="detail">
                                        <input type="text" name="billBizNo">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">대표자명</span>
                                    <p class="detail">
                                        <input type="text" name="billCeoNm">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">업태/업종</span>
                                    <p class="detail">
                                        <input type="text" name="billBsnsCdts"> <input type="text" name="billItem">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">주소</span>
                                    <p class="detail">
                                        <input type="text" name="billPostNo" id="billPostNo" readonly> <a href="javascript:billPost();"><img src="${_MOBILE_PATH}/front/img/product/btn_post_info.gif" alt="우편번호 검색" style="vertical-align:middle;margin-left:15px"></a>
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">담당자명</span>
                                    <p class="detail">
                                        <input type="text" name="billManagerNm">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">이메일</span>
                                    <p class="detail">
                                        <input type="text" name="billEmail">
                                    </p>
                                </li>
                                <li class="form">
                                    <span class="title">연락처</span>
                                    <p class="detail">
                                        <input type="text" name="billTelNo">
                                    </p>
                                </li>
                            </ul>
                          </div>
                          <!--//계산서 선택시-->
                        </div>
                    </li>
                </ul>
                <!--// 매출증빙 --->

                <!-- 주문동의 -->
                <ul class="tr_11 tr_21 tr_22 tr_23 tr_24 tr_31 tr_41 payment_method_info">
                <li class="agree_check">
                        <span class="agree_check_title">주문동의</span>
                        주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며, 구매에 동의하시겠습니까?
                        (전자상거래법 제8조 제2항)
                        <div class="checkbox" style="margin-top:10px">
                            <label>
                                <input type="checkbox" name="order_agree" id="order_agree">
                                <span></span>
                            </label>
                            동의합니다.
                        </div>
                    </li>
                </ul>
                <!--// 주문동의 -->


            </div>
            <c:if test="${user.session.memberNo eq null}">
            <!--- 비회원 구매시 --->
            <div class="nonmember_area">
                <div class="floatC" style="margin-bottom:8px">
                    <div class="checkbox floatL" style="margin-top:5px">
                        <label>
                            <input type="checkbox" name="nonmember_agree01" id="nonmember_agree01">
                            <span></span>
                        </label>
                        <label for="nonmember_agree01">쇼핑몰 이용약관</label>
                    </div>
                    <button type="button" class="btn_agree_view floatR">내용보기</button>
                    <textarea style="width:100%;height:200px;border:none;resize:none;display:none;" onfocus="this.blur();" readonly>${term_03.data.content}</textarea>
                </div>
                <div class="floatC" style="margin-bottom:8px">
                    <div class="checkbox floatL" style="margin-top:5px">
                        <label>
                            <input type="checkbox" name="nonmember_agree02" id="nonmember_agree02">
                            <span></span>
                        </label>
                        <label for="nonmember_agree02">비회원 개인정보 취급방침 동의</label>
                    </div>
                    <button type="button" class="btn_agree_view floatR">내용보기</button>
                    <textarea style="width:100%;height:200px;border:none;resize:none;display:none;" onfocus="this.blur();" readonly>${term_20.data.content}</textarea>
                </div>
                <c:if test="${term_07.data.useYn eq 'Y'}">
                <div class="floatC" style="margin-bottom:8px">
                    <div class="checkbox floatL" style="margin-top:5px">
                        <label>
                            <input type="checkbox" name="nonmember_agree03" id="nonmember_agree03">
                            <span></span>
                        </label>
                        <label for="nonmember_agree03">개인정보 제 3자 제공동의(선택)</label>
                    </div>
                    <button type="button" class="btn_agree_view floatR">내용보기</button>
                    <textarea style="width:100%;height:100%;border:none;resize:none;display:none;" onfocus="this.blur();" readonly>${term_07.data.content}</textarea>
                </div>
                </c:if>
                <c:if test="${term_08.data.useYn eq 'Y'}">
                <div class="floatC" style="margin-bottom:8px">
                    <div class="checkbox floatL" style="margin-top:5px">
                        <label>
                            <input type="checkbox" name="nonmember_agree04" id="nonmember_agree04">
                            <span></span>
                        </label>
                        <label for="nonmember_agree04">개인정보 취급 위탁 동의(선택)</label>
                    </div>
                    <button type="button" class="btn_agree_view floatR" onclick="javascript:popupNomember('${term_08.data.content}')">내용보기</button>
                    <textarea style="width:100%;height:100%;border:none;resize:none;display:none;" onfocus="this.blur();" readonly>${term_08.data.content}</textarea>
                </div>
                </c:if>
            </div>
            <!---// 비회원 구매시 --->
            </c:if>
            <button type="button" class="btn_go_payment">결제하기</button>
        </div>
    <input type="hidden" name="ordNo" value="${ordNo}"/>
    <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
    <!-- 모바일 전용 20160908 -->
    <input type="hidden" name="paymentWayCd" id="paymentWayCd" value=""/>

    <input type="hidden" id="confirmNo" name="confirmNo" value=""/> <%-- 페이팔, 페이코(reserveOrderNo) 사용 --%>
    <input type="hidden" id="txNo" name="txNo" value=""/> <%-- 페이팔, 페이코(paymentCertifyToken) 사용 --%>
    <input type="hidden" id="logYn" name="logYn" value=""/> <%-- 페이팔, 페이코(logYn) 사용 --%>
    <input type="hidden" id="confirmResultCd" name="confirmResultCd" value=""/> <%-- 페이팔, 페이코() 사용 --%>
    <input type="hidden" id="serverType" name="serverType" value=""/> <%-- 페이팔, 페이코() 사용 --%>

    <%--
        PG CD = ${pgPaymentConfig.data.pgCd}
        PG NM = ${pgPaymentConfig.data.pgNm}
     --%>

	    <c:if test="${pgPaymentConfig.data.pgCd eq '01'}">
	        <!-- KCP연동 -->
	            <%@ include file="include/01/kcp_req.jsp" %>
	        <!--//KCP연동  -->
	    </c:if>

	    <c:if test="${pgPaymentConfig.data.pgCd eq '02' or foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
	        <!-- 이니시스연동 -->
	        <%@ include file="include/inicis/inicis_req.jsp" %>
	        <!--// 이니시스연동 -->
	    </c:if>

	    <c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
	        <!-- PAYPAL연동 -->
	        <%@ include file="include/paypal_req.jsp"%>
	        <!--//PAYPAL연동  -->
	    </c:if>

	    <!-- LGU+ 연동 -->
	    <c:if test="${pgPaymentConfig.data.pgCd eq '03'}">
	        <%@ include file="include/03/PayreqCrossplatform.jsp"%>
	    </c:if>
	    <!-- //LGU+ 연동 -->

	    <!-- ALLTHEGATE -->
	    <c:if test="${pgPaymentConfig.data.pgCd eq '04'}">
	        <%@ include file="include/04/AGS_pay.jsp"%>
	    </c:if>
	    <!--// ALLTHEGATE -->

    </form>
    <!-- frmAGS_pay Form End -->
    </div>

    <br>



    <c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">
        <!-- PAYCO연동 -->
        <%@ include file="include/payco/payco_form.jsp" %>
        <!--// PAYCO연동 -->
    </c:if>
    <!---// 03.LAYOUT: MIDDLE AREA --->


       <!----------------------------------------------------------------------------------------------------------->
       <!----------------------------------------------------------------------------------------------------------->
       <!--------------------------------------------- 안내 LAYER -------------------------------------------------->
       <!----------------------------------------------------------------------------------------------------------->
       <!----------------------------------------------------------------------------------------------------------->

        <!--------------------------------------------- popup 무통장입금(가상계좌) 이용 안내 --------------------------------------------->
        <div class="popup_bank" id="popup_bank" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">무통장입금(가상계좌) 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle">
                    <h3 class="cart_popup_title">무통장입금 결제란?</h3>
                    <ul class="mobile_payment_info_text">
                        <li>고객님에게 지정된 전용 계좌번호로 상품 구매대금이 입금되면 결제처리 되는 방식입니다.</li>
                    </ul>
                </div>
                <div class="popup_middle">
                    <h3 class="cart_popup_title">무통장입금 결제방법</h3>
                    <ul class="mobile_payment_info_text">
                        <li>①상품 주문시 결제정보 입력에서 결제수단으로 '무통장입금(가상계좌)'을 선택하신 후 입금하실 은행을 선택하고 '결제하기' 버튼을 클릭하십시오.</li>
                        <li>②주문완료 페이지에서 보여지는 고객님의 전용계좌번호로 상품 구매대금을 입금하시면 자동으로 입금확인이 완료됩니다.</li>
                        <li>* 무통장입금으로 주문하신 경우, 주문 이후 입금 전까지는 주문상태가 ‘주문접수'로, 입금된 이후에는 '결제완료'로 변경됩니다.</li>
                    </ul>
                </div>
                <div class="popup_middle02">
                    <h3 class="cart_popup_title">무통장입금 결제시 주의사항</h3>
                    <ul class="mobile_payment_info_text">
                        <li>①타행으로 입금시에는 입금 수수료가 발생할 수 있으므로, 고객님께서 계좌를 보유중이신 은행을 선택하시는 것이 좋습니다.</li>
                        <li>②반드시 정확한 상품 구매대금 결제총액을 입금해 주셔야 입금확인이 됩니다.</li>
                        <li>③주문 후 5영업일 이내에 입금확인이 되지 않으면 주문이 자동으로 취소됩니다.</li>
                        <li>④입금확인중 상태에서는 일부 상품 부분취소 처리가 불가합니다. </li>
                        <li>⑤일부 상품만 주문하고자 하시는 경우, 입금확인중 주문 전체 취소 후 해당 상품에 대해서만 다시 주문을 진행해 주십시오. </li>
                    </ul>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 무통장입금(가상계좌) 이용 안내 ----------------------------------------------->

        <!----------------------------------------------- popup 안전결제(ISP) 안내 ----------------------------------------------->
        <div class="popup_safe_checkout" id="popup_safe_checkout" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">안전결제(ISP) 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안전결제(ISP)란 무엇인가요?</h3>
                    <ul class="mobile_payment_info_text">
                        <li>온라인 쇼핑시 주민등록번호, 비밀번호 등의 주요 개인정보를 입력하지 않고, 고객님이 사전에 미리 설정해 둔 인터넷 안전결제(ISP) 비밀번호만 입력하여 결제하도록 하여 개인정보 유출 및 카드 도용 등을 방지해주는 서비스 입니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안심클릭 가능 카드사</h3>
                    <ul class="mobile_payment_info_text">
                        <li>국민카드, BC카드, 우리카드</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안심클릭 사용 가능 카드 및 금액</h3>
                    <table class="tProduct_Con">
                        <caption>
                            <h1 class="blind">안심클릭 사용 가능 카드 및 금액 안내 표 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:33%">
                            <col style="width:34%">
                            <col style="width:33%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textC">카드</th>
                                <th class="textC">30만원 미만</th>
                                <th class="textC">30만원 이상</th>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">국민/BC/우리 제외 모든 카드</td>
                                <td class="popup_f11_fc">안심클릭</td>
                                <td class="popup_f11_fc">안심클릭 + 공인인증</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 안전결제(ISP) 안내 ----------------------------------------------->

        <!----------------------------------------------- popup 안심클릭 안내 ----------------------------------------------->
        <div class="popup_safe_click" id="popup_safe_click" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">안심클릭 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안심클릭이란 무엇인가요?</h3>
                    <ul class="mobile_payment_info_text">
                        <li>온라인 쇼핑시 주민등록번호, 비밀번호 등의 주요 개인정보를 입력하지 않고, 고객님이 사전에 미리 설정해 둔 인터넷 안전결제(ISP) 비밀번호만 입력하여 결제하도록 하여 개인정보 유출 및 카드 도용 등을 방지해주는 서비스 입니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안심클릭 가능 카드사</h3>
                    <ul class="mobile_payment_info_text">
                        <li>국민카드, BC카드, 우리카드</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">안심클릭 사용 가능 카드 및 금액</h3>
                    <table class="tProduct_Con">
                        <caption>
                            <h1 class="blind">안심클릭 사용 가능 카드 및 금액 안내 표 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:33%">
                            <col style="width:34%">
                            <col style="width:33%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textC">카드</th>
                                <th class="textC">30만원 미만</th>
                                <th class="textC">30만원 이상</th>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">국민/BC/우리 제외 모든 카드</td>
                                <td class="popup_f11_fc">안심클릭</td>
                                <td class="popup_f11_fc">안심클릭 + 공인인증</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 안심클릭 안내 ----------------------------------------------->

        <!----------------------------------------------- popup 공인인증안내 ----------------------------------------------->
        <div class="popup_official" id="popup_official" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">공인인증 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">30만원 이상 결제시 공인인증서 의무 사용</h3>
                    <ul class="mobile_payment_info_text">
                        <li>2005년 11월 1일부터 금융감독원의 전자금융거래 안정성 강화정책에 따라 30만원 이상의 모든 신용카드 결제시에 공인인증서를 반드시 사용하도록 하고 있습니다.</li>
                    </ul>
                    <table class="tProduct_Con">
                        <caption>
                            <h1 class="blind">30만원 이상 결제시 공인인증서 의무사용 안내 표 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:33%">
                            <col style="width:34%">
                            <col style="width:33%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th class="textC">카드</th>
                                <th class="textC">30만원 미만</th>
                                <th class="textC">30만원 이상</th>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">국민/BC/우리 카드</td>
                                <td class="popup_f11_fc">안심결제(ISP)</td>
                                <td class="popup_f11_fc">안전결제(ISP) + 공인인증</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">그외 모든 카드</td>
                                <td class="popup_f11_fc">안심클릭</td>
                                <td class="popup_f11_fc">안심클릭 + 공인인증</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">공인인증서 발급</h3>
                    <ul class="mobile_payment_info_text">
                        <li>공인인증서는 인터넷 뱅킹 거래 또는 카드결제시에 본인임을 확인하는 보안장치로, 다음과 같이 발급받으실 수 있습니다</li>
                        <li><img src="${_MOBILE_PATH}/front/img/product/img_popup_official.png" alt="공인인증서 발급 안내"></li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">공인인증서 유효기간</h3>
                    <ul class="mobile_payment_info_text">
                        <li>공인인증서의 유효기간은 1년이며, 유효기간이 만료된 경우에는 해당 인증서를 발급 받으신 등록기관의 홈페이지에서 재발급 받으실 수 있습니다.</li>
                    </ul>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 공인인증안내 ----------------------------------------------->

        <!----------------------------------------------- popup 실시간 계좌이체 이용안내 ----------------------------------------------->
        <div class="popup_account" id="popup_account" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">실시간 계좌이체 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">실시간 계좌이체 결제란?</h3>
                    <ul class="mobile_payment_info_text">
                        <li>- 실시간 계좌이체는 은행을 거치지 않고, 고객님의 계좌에서 결제금액을 실시간으로 인출하여 결제하는 결제 서비스 입니다.</li>
                        <li>- 이체 수수료는 무료이며, 공인인증서가 있어야 서비스를 이용하실 수 있습니다.</li>
                        <li>- 실시간 계좌이체 1일 결제 한도는 200만원 입니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">실시간 계좌이체 결제방법</h3>
                    <ul class="mobile_payment_info_text">
                        <li>① 주문서 결제정보 입력에서 '실시간 계좌이체'를 선택한 후 '결제하기' 버튼을 클릭하십시오.</li>
                        <li>② 계좌이체 결제창에 이체하실 은행명/계좌번호/계좌 비밀번호/예금주명/주민등록번호/이메일을 입력 하십시오.</li>
                        <li>③ 주문상품과 결제금액, 결제 계좌정보를 확인하신 후 '확인' 버튼을 눌러주십시오.</li>
                        <li>④ 고객님의 공인인증서 암호 입력 후 '확인' 버튼을 클릭하시면 최종 결제가 진행됩니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <span class="fRed">※ 법인/개인 사업자 계좌는 이용에 제한이 있을 수 있습니다.</span>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!----------------------------------------------// popup 실시간 계좌이체 이용안내 ----------------------------------------------->

        <!---------------------------------------------- popup 실시간 계좌이체 이용가능 시간안내 ----------------------------------------------->
        <div class="popup_account_time" id="popup_account_time" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">실시간 계좌이체 이용가능 시간 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">은행별 실시간 계좌이체 이용가능 시간</h3>
                    <table class="tProduct_Con">
                        <caption>
                            <h1 class="blind">안심클릭 사용 가능 카드 및 금액 안내 표 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:25%">
                            <col style="width:25%">
                            <col style="width:25%">
                            <col style="width:25%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="textC">은행</th>
                                <th class="textC">이용가능시간</th>
                                <th class="textC">은행</th>
                                <th class="textC">이용가능시간</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="popup_f11_fc">경남은행</td>
                                <td class="popup_f11_fc">08:00 ~ 23:00</td>
                                <td class="popup_f11_fc">우리은행</td>
                                <td class="popup_f11_fc">01:00 ~ 23:30</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">광주은행</td>
                                <td class="popup_f11_fc">05:00 ~ 24:00</td>
                                <td class="popup_f11_fc">우체국</td>
                                <td class="popup_f11_fc">
                                    01:30 ~ 23:40<br>
                                    (사용불가 04:00 ~ 05:00)
                                </td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">국민은행</td>
                                <td class="popup_f11_fc">00:30 ~ 23:30</td>
                                <td class="popup_f11_fc">외환은행</td>
                                <td class="popup_f11_fc">01:00 ~ 24:00</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">기업은행</td>
                                <td class="popup_f11_fc">01:00 ~ 23:30</td>
                                <td class="popup_f11_fc">전북은행</td>
                                <td class="popup_f11_fc">04:00 ~ 24:00</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">농협</td>
                                <td class="popup_f11_fc">04:00 ~ 23:30</td>
                                <td class="popup_f11_fc">조흥은행</td>
                                <td class="popup_f11_fc">06:00 ~ 24:00</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">대구은행</td>
                                <td class="popup_f11_fc">
                                    01:00 ~ 23:30<br>
                                    (공휴일 07:00 ~ 24:00)
                                </td>
                                <td class="popup_f11_fc">제일은행</td>
                                <td class="popup_f11_fc">07:00 ~ 23:00</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">부산은행</td>
                                <td class="popup_f11_fc">07:00 ~ 23:00</td>
                                <td class="popup_f11_fc">제주은행</td>
                                <td class="popup_f11_fc">06:00 ~ 25:30</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">새마을금고</td>
                                <td class="popup_f11_fc">01:00 ~ 23:30</td>
                                <td class="popup_f11_fc">하나은행</td>
                                <td class="popup_f11_fc">01:00 ~ 23:30</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">수협</td>
                                <td class="popup_f11_fc">01:00 ~ 23:30</td>
                                <td class="popup_f11_fc">한국씨티은행</td>
                                <td class="popup_f11_fc">08:00 ~ 23:00</td>
                            </tr>
                            <tr>
                                <td class="popup_f11_fc">신한은행</td>
                                <td class="popup_f11_fc">00:30 ~ 24:00</td>
                                <td class="popup_f11_fc">SC제일은행</td>
                                <td class="popup_f11_fc">00:30 ~ 23:30</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="popup_middle03">
                    <span class="fRed">※ 각 은행의 사정에 따라 시간은 변동될 수 있습니다.</span>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!----------------------------------------------// popup 실시간 계좌이체 이용가능 시간안내 ----------------------------------------------->

        <!---------------------------------------------- popup 휴대폰결제 이용 안내 ----------------------------------------------->
        <div class="popup_official" id="popup_hpp" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">휴대폰결제 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">통신사별 결제한도 운영 정책</h3>
                    <ul class="mobile_payment_info_text">
                        <li>회원별 월별 결제한도는 각 통신사별 운영 정책에 따라 적용 됩니다.</li>
                    </ul>

                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">휴대폰 결제 금액 청구</h3>
                    <ul class="mobile_payment_info_text">
                        <li>결제하신 내역은 익월 휴대폰 요금에 합산 청구됩니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">취소/반품 환불 방법</h3>
                    <table class="tProduct_Con">
                        <caption>
                            <h1 class="blind">취소/반품 환불 방법에 대한 표 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:30%">
                            <col style="width:70%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>결제 당월에 환불처리가 완료된 경우</th>
                                <td class="popup_f11_fc" style="text-align:left; padding-left:10px;">휴대폰 청구금액에 부과예정이던 결제금액이 취소됩니다. </td>
                            </tr>
                            <tr>
                                <th>결제 익월에 환불처리가 완료된 경우</th>
                                <td class="popup_f11_fc" style="text-align:left; padding-left:10px;">휴대폰 청구내역에는 결제금액이 포함되며, 동일한 금액이 환불처리 즉시 고객님의 계좌로 환불 됩니다. </td>
                            </tr>
                        </tbody>
                    </table>
                    <ul class="mobile_payment_info_text">
                        <li>※ 휴대폰 소액결제의 경우 세금계산서와 현금영수증이 발급되지 않습니다<br/>
                        단, 이용료를 수납한 고객분은 해당 이동통신사에서 연말 소득공제를 제공해 드립니다.</li>
                    </ul>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 휴대폰결제 이용 안내 ----------------------------------------------->

        <!----------------------------------------------- popup 증빙발급안내 ----------------------------------------------->
        <div class="popup_evidence" id="popup_evidence" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">증빙발급안내</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">신용카드 매출전표</h3>
                    <ul class="mobile_payment_info_text">
                        <li>- 신용카드 구매시에는 신용카드 매출전표가 자동 발급 됩니다. </li>
                        <li>- 부가세법 시행령 제 57조 2항에 의거하여, 신용카드 전표는 세금계산서 대용으로 세액 공제를 받을 수 있습니다.</li>
                    </ul>
                </div>
                <div class="popup_middle03">
                    <h3 class="cart_popup_title">현금영수증</h3>
                    <ul class="mobile_payment_info_text">
                        <li>- 무통장입금, 실시간 계좌이체로 구매시 현금 결제금액이 1원 이상이면 현금영수증 발급 신청을 하실 수 있습니다.</li>
                        <li>
                            ① 발급조건
                            <ul class="mobile_payment_info_text_s">
                                <li>- 현금 결제액이 1원 이상인 경우에만 발급 가능 합니다.</li>
                                <li>- 쿠폰 및 즉시할인 금액, 인빌머니(마켓포인트) 사용 결제액은 현금영수증 발급 대상에서 제외됩니다.</li>
                                <li>- 현금영수증은 주문서에서 현금영수증 '신청하기' 선택 후 결제를 완료하시면 발급받으실 수 있습니다.</li>
                            </ul>
                        </li>
                        <li>
                            ② 현금영수증 종류
                             <ul class="mobile_payment_info_text_s">
                                <li>- 개인 소득공제용</li>
                                <li style="margin-left:5px">근로소득자가 연말정산을 통해 소득공제를 받을 수 있는 영수증으로, 신청정보는 휴대폰번호, 현금영수증 카드번호 중 선택 할 수 있으며, 타인 명의로도 발급받으실 수 있습니다.</li>
                                <li>- 사업자 지출증빙용</li>
                                <li style="margin-left:5px">사업자가 지정된 기간 내에 사용한 현금에 대해 세액공제를 받을 수 있는 영수증으로, 신청정보로 사업자 등록번호를 입력하시면 됩니다. (세금계산서 대체용)</li>
                             </ul>
                        </li>
                        <li>
                            ③ 현금영수증 발급신청 및 확인 방법
                             <ul class="mobile_payment_info_text_s">
                                <li>- 상품 주문시 주문서 페이지에서 현금영수증 '신청하기'를 선택하십시오.</li>
                                <li>- 주문완료 이후 물품수령확정 전까지는 마이페이지에서 현금영수증 신청정보를 수정하실 수 있습니다.</li>
                                <li>- 발급된 현금영수증은 국세청 현금영수증 홈페이지(<a href="http://www.taxsave.go.kr" target="_blank">http://www.taxsave.go.kr</a>)에서도 확인하실 수 있습니다.</li>
                             </ul>
                        </li>
                    </ul>
                </div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-----------------------------------------------// popup 증빙발급안내 ----------------------------------------------->

        <!----------------------------------------------- popup 약관내용보기 ----------------------------------------------->
        <div class="popup_evidence" id="popup_nomember" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">약관내용</h1>
                <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
            </div>
            <div class="popup_content">
                <div id="conts"></div>
                <div class="popup_btn_area">
                    <button type="button" class="btn_popup_cancel">닫기</button>
                </div>
            </div>
        </div>
        <!-------------------------------------------------// popup 약관내용보기 ------------------------------------------------->

    </t:putAttribute>
</t:insertDefinition>