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
            <script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
        </c:if>
        <c:if test="${pgPaymentConfig.data.pgCd eq '04'}">
            <!-- 올더게이트 웹표준 방식에 따른 결제 호출 및 관련 자바스크립트 추가 (위치변경금지)  -->
            <!-- jquery 버전 충돌로 Dmall에서 사용하는 상위버전 jquery-1.12.2.min.js 를 그대로 사용하도록 올더게이트에서 제공하는 것 막음 -->
            <!-- script type="text/javascript" src="https://www.allthegate.com/plugin/jquery-1.11.1.js"></script  -->
            <script type="text/javascript" src="//www.allthegate.com/payment/webPay/js/ATGClient_new.js" charset="UTF-8"></script>
        </c:if>
        <script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
        <script src="/front/js/coupon.js" type="text/javascript" charset="utf-8"></script>
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
            $('.btn_payment').on("click", function(){
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
                        });
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
                    });
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
                        });
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
                    if($('input[name=paymentWayCd]:checked').length == 0 ) {
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
                var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                if(paymentWayCd != '11' && Number(paymentAmt) > 0) {
                    if(paymentPgCd == '01'){ // KCP
                        $('#frmAGS_pay').attr('action','/front/order/order-insert');
                        createGoodsInfo();
                        $('[name=good_name]').val($('#ordGoodsInfo').val());
                        $('[name=good_mny]').val($('#paymentAmt').val());
                        $('[name=buyr_name]').val($('#ordrNm').val());
                        $('[name=buyr_mail]').val($('#ordrEmail').val());
                        var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                        var payMethod = '';
                        if(paymentWayCd == '21') { //계좌이체
                            payMethod = '010000000000';
                        } else if(paymentWayCd == '22') { //가상계좌
                            payMethod = '001000000000';
                        } else if(paymentWayCd == '23') { //신용카드
                            payMethod = '100000000000';
                        } else if(paymentWayCd == '24') { //휴대폰결제
                            payMethod = '000010000000';
                        }
                        $('[name=pay_method]').val(payMethod);
                        //에스크로
                        if($('input[name=escrowYn]') !== 'undefined') {
                            $('[name=pay_mod]').val($('input[name=escrowYn]:checked').val());
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
                        jsf__pay(document.forms[0]);
                        return false;
                    } else if(paymentPgCd == '02'){ //INICIS
                        if(paymentWayCd == '21') { //계좌이체
                            payMethod = 'DirectBank';
                        } else if(paymentWayCd == '22') { //가상계좌
                            payMethod = 'Vbank';
                        } else if(paymentWayCd == '23') { //신용카드
                            payMethod = 'Card';
                        } else if(paymentWayCd == '24') { //휴대폰결제
                            payMethod = 'HPP';
                        }
                        $('[name=gopaymethod]').val(payMethod);
                        $('[name=goodname]').val($('#ordGoodsInfo').val());
                        $('[name=buyername]').val($('#ordrNm').val());
                        $('[name=buyertel]').val($('#ordrMobile').val());
                        $('[name=buyeremail]').val($('#ordrEmail').val());
                        $('[name=price]').val($('#paymentAmt').val());
                        var certUrl = '/front/order/inicis-signature-info';
                        var certparam = jQuery('#frmAGS_pay').serialize();
                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
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
                                return false;
                            } else {
                                Dmall.LayerUtil.alert("결제모듈 호출에 실패하였습니다.", "알림");
                                return false;
                            }
                        });

                    } else if(paymentPgCd == '03'){ //LGU+
                        $('[name=LGD_AMOUNT]').val($('#paymentAmt').val());
                        $('[name=Amt]').val($('#paymentAmt').val());
                        $('[name=LGD_TIMESTAMP]').val(new Date().format('yyyyMMddHHmmss'));
                        var certUrl = '/front/order/'+paymentPgCd+'/cert';
                        var certparam = jQuery('#frmAGS_pay').serialize();
                        //서버에 post 방식으로 요청하여 JSON 데이터를 결과로 반환 받는다.
                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                Dmall.FormUtil.jsonToForm(certResult.extraData, 'frmAGS_pay');
                                launchCrossPlatform();
                                return false;
                            } else {
                                alert("결제모듈 호출에 실패하였습니다.");
                                return false;
                            }
                        });
                        return false;
                    } else if(paymentPgCd == '04'){ //allthegate
                        $('[name=Amt]').val($('#paymentAmt').val());
                        $('#frmAGS_pay').attr('action','/front/order/order-insert');
                        var certUrl = '/front/order/'+paymentPgCd+'/cert';
                        var certparam = jQuery('#frmAGS_pay').serialize();
                        //서버에 post 방식으로 요청하여 JSON 데이터를 결과로 반환 받는다.
                        Dmall.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                Dmall.FormUtil.jsonToForm(certResult.extraData, 'frmAGS_pay');
                                AlltheGatePay($('#frmAGS_pay').get(0));
                                return false;
                            } else {
                                alert("결제모듈 호출에 실패하였습니다.");
                                return false;
                            }
                        });
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
                    $('#frmAGS_pay').attr('action','/front/order/order-insert');
                    $('#frmAGS_pay').submit();
                }
            });

            /* 거주지 선택 제어 */
            $('[name=memberGbCd]').on('click',function(){
                $('[class^=radio_con_]').each(function(){
                    $(this).find('input').val();
                })
            });

            /* 결제수단 선택 제어 */
            $('input[name=paymentWayCd]').on('click',function(){
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
                } else if($(this).val() === '41') {
                  //페이팔 선택시
                    $('#paymentPgCd').val('81');
                } else {
                    $('#paymentPgCd').val('${pgPaymentConfig.data.pgCd}');
                }
                initPaymentConfig();
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
        }
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
            $('#frmAGS_pay').attr('action','/front/order/order-insert');
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
    <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
    <form name="frmAGS_pay" id="frmAGS_pay" method="post" action="">
        <!-- category header 카테고리 location과 동일 -->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>주문결제
            </div>
        </div>
        <!-- // category header -->

        <!-- best product -->
        <div id="cart">
            <div id="best_product">
                <h2 class="sub_title">주문결제<span>주문결제가 진행중입니다. 주문상품과 배송정보를 확인하세요</span></h2>
                <ul class="checkout_steps">
                    <li>장바구니</li>
                    <li class="thisstep">주문결제</li>
                    <li>주문완료</li>
                </ul>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문결제 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:68px">
                        <col style="width:">
                        <col style="width:220px">
                        <col style="width:85px">
                        <col style="width:95px">
                        <col style="width:85px">
                        <col style="width:107px">
                        <col style="width:75px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="2">상품명</th>
                            <th>옵션</th>
                            <th>수량</th>
                            <th>상품금액</th>
                            <th>할인금액</th>
                            <th>합계</th>
                            <th>배송비</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:set var="orderTotalAmt" value="0"/>
                    <c:set var="dlvrTotalAmt" value="0"/>
                    <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
                        <c:set var="totalAddOptionAmt" value="0"/>
                        <c:set var="addOptArr" value=""/>
                        <tr>
                            <td class="pix_img">
                                <img src="${orderGoodsList.imgPath}">
                            </td>
                            <td class="textL">
                                <a href="javascript:goods_detail('${orderGoodsList.goodsNo}')">${orderGoodsList.goodsNm}</a>
                            </td>
                            <td class="textL">
                                <ul class="cart_s_list">
                                    <c:if test="${orderGoodsList.itemNm1 ne null}">
                                    <li>${orderGoodsList.itemNm1}</li>
                                    </c:if>
                                    <c:if test="${orderGoodsList.itemNm2 ne null}">
                                    <li>${orderGoodsList.itemNm2}</li>
                                    </c:if>
                                    <c:if test="${orderGoodsList.itemNm3 ne null}">
                                    <li>${orderGoodsList.itemNm3}</li>
                                    </c:if>
                                    <c:if test="${orderGoodsList.itemNm4 ne null}">
                                    <li>${orderGoodsList.itemNm4}</li>
                                    </c:if>
                                    <c:if test="${orderGoodsList.goodsAddOptList ne null}">
                                    <c:forEach var="goodsAddOptionList" items="${orderGoodsList.goodsAddOptList}" varStatus="status1">
                                        <li>
                                            ${goodsAddOptionList.addOptNm}:${goodsAddOptionList.addOptValue}
                                            (<fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/>개)
                                            (+<fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt*goodsAddOptionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                        </li>
                                        <c:if test="${addOptArr ne ''}">
                                            <c:set var="addOptArr" value="${addOptArr}*"/>
                                        </c:if>
                                        <c:set var="addOptArr" value="${addOptArr}${goodsAddOptionList.addOptNo}^${goodsAddOptionList.addOptDtlSeq}^${goodsAddOptionList.addOptBuyQtt}"/>
                                        <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                                    </c:forEach>
                                    </c:if>
                                </ul>
                            </td>
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
                            <td class="textC"><fmt:formatNumber value="${orderGoodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                            <input type="hidden" name="minOrdQtt" value="${orderGoodsList.minOrdQtt}"><%-- 구매수량제한 확인용(최소)--%>
                            <input type="hidden" name="ordQttMinLimitYn" value="${ordQttMinLimitYn}"><%-- 구매수량제한 확인용(최소)--%>
                            <input type="hidden" name="maxOrdQtt" value="${orderGoodsList.maxOrdQtt}"><%-- 구매수량제한 확인용(최대)--%>
                            <input type="hidden" name="ordQttMaxLimitYn" value="${ordQttMaxLimitYn}"><%-- 구매수량제한 확인용(최대)--%>
                            <input type="hidden" name="limitItemNm" value="${orderGoodsList.goodsNm}"><%-- 구매수량제한 확인용--%>
                            <td>
                                <ul class="cart_s_list">
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
                                    <li><fmt:formatNumber value="${orderGoodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</li>
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
                                    <%-- <li><span class="cart_point"><fmt:formatNumber value="${pvdSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span></li> --%>
                                </ul>
                            </td>
                            <td><fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                            <c:set var="goodstotalAmt" value="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)+totalAddOptionAmt}"/>
                            <td><fmt:formatNumber value="${goodstotalAmt-dcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
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
                                <c:when test="${orderGoodsList.dlvrSetCd eq '6' && orderGoodsList.dlvrcPaymentCd eq '02'}">
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
                                                <td rowspan="${dlvrCountMap.get(grpId)}">착불</td>
                                            </c:when>
                                            <c:when test="${orderGoodsList.dlvrcPaymentCd eq '04'}">
                                                <td rowspan="${dlvrCountMap.get(grpId)}">매장픽업</td>
                                            </c:when>
                                            <c:otherwise>
                                                <td rowspan="${dlvrCountMap.get(grpId)}">무료</td>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                    <td rowspan="${dlvrCountMap.get(grpId)}"><fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                                    </c:otherwise>
                                </c:choose>
                                <c:set var="dlvrTotalAmt" value="${dlvrTotalAmt+ dlvrPriceMap.get(grpId)}"/>
                            </c:if>
                        </tr>
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
                        <!-- 쿠폰 조회용 데이터 -->
                        <input type="hidden" class="couponInfo" data-goods-no="${orderGoodsList.goodsNo}" data-item-no="${orderGoodsList.itemNo}" data-goods-nm="${orderGoodsList.goodsNm}" data-goods-qtt="${orderGoodsList.ordQtt}" data-sale-price="<fmt:parseNumber type='number' value='${orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice}'/>" >
                    </c:forEach>
                    <c:set var="couponTotalAmt" value="0"/>
                    <c:set var="mileageTotalAmt" value="0"/>
                    <c:set var="paymentTotalAmt" value="${orderTotalAmt+dlvrTotalAmt-promotionTotalDcAmt-memberGradeTotalDcAmt-couponTotalAmt-mileageTotalAmt}"/>
                    </tbody>
                </table>

                <c:if test="${user.session.memberNo eq null}">
                <!-- 비회원 이용약관 -->
                <h3 class="product_stit">이용약관</h3>
                <table class="tProduct_Insert">
                    <caption>
                        <h1 class="blind">이용약관 내용 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:140px">
                        <col style="width:">
                        <col style="width:282px">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="order_tit">쇼핑몰 이용약관</th>
                            <td class="f12">
                                <div class="order_agree_check" style="margin-top:10px">
                                    <label>
                                        <input type="checkbox" name="nonmember_agree01" id="nonmember_agree01">
                                        <span></span>
                                    </label>
                                    <label for="nonmember_agree01" class="f100">쇼핑몰 이용약관에 대하여 동의합니다.</label>
                                </div>
                                <div class="nonmember_agree_scroll" style="overflow:hidden">
                                    <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_03.data.content}</textarea>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">비회원 구매 및 결제<br>개인정보 취급방침</th>
                            <td class="f12">
                                <div class="order_agree_check" style="margin-top:10px">
                                    <label>
                                        <input type="checkbox" name="nonmember_agree02" id="nonmember_agree02">
                                        <span></span>
                                    </label>
                                    <label for="nonmember_agree02" class="f100">비회원 구매 및 결제 개인정보처리방침에 대하여 동의합니다.</label>
                                </div>
                                <div class="nonmember_agree_scroll" style="overflow:hidden">
                                    <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_20.data.content}</textarea>
                                </div>
                            </td>
                        </tr>
                        <c:if test="${term_07.data.useYn eq 'Y'}">
                        <tr>
                            <th class="order_tit">개인정보<br>제3자 제공 동의(선택)</th>
                            <td class="f12">
                                <div class="order_agree_check" style="margin-top:10px">
                                    <label>
                                        <input type="checkbox" name="nonmember_agree03" id="nonmember_agree03">
                                        <span></span>
                                    </label>
                                    <label for="nonmember_agree03" class="f100">개인정보 제3자 제공동의에 대하여 동의합니다.</label>
                                </div>
                                <div class="nonmember_agree_scroll" style="overflow:hidden">
                                    <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_07.data.content}</textarea>
                                </div>
                            </td>
                        </tr>
                        </c:if>
                        <c:if test="${term_08.data.useYn eq 'Y'}">
                        <tr>
                            <th class="order_tit">개인정보<br>취급 위탁 동의(선택)</th>
                            <td class="f12">
                                <div class="order_agree_check" style="margin-top:10px">
                                    <label>
                                        <input type="checkbox" name="nonmember_agree04" id="nonmember_agree04">
                                        <span></span>
                                    </label>
                                    <label for="nonmember_agree04" class="f100">개인정보 취급 위탁 동의에 대하여 동의합니다.</label>
                                </div>
                                <div class="nonmember_agree_scroll" style="overflow:hidden">
                                    <textarea style="width:100%;height:100%;border:none;resize:none" readonly>${term_08.data.content}</textarea>
                                </div>
                            </td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- //비회원 이용약관 -->
                </c:if>

                <h3 class="product_stit">할인 및 최종 결제금액</h3>
                <table class="tProduct_Insert">
                    <caption>
                        <h1 class="blind">할인 및 최종 결제금액 내용 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:140px">
                        <col style="width:">
                        <col style="width:282px">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="order_tit">할인쿠폰</th>
                            <td class="f12">
                            <c:choose>
                                <c:when test="${user.session.memberNo eq null}">
                                <span class="fRed">쿠폰을 사용하실 수 없습니다.</span>
                                <input type="hidden" name="cpUseAmt" id="cpUseAmt" value="0">
                                </c:when>
                                <c:otherwise>
                                <input type="text" name="cpUseAmt" id="cpUseAmt" value="0" readonly> 원
                                <button type="button" class="btn_checkout_info" id="btn_checkout_info" style="margin:0 10px 0 20px">쿠폰적용</button> 사용가능한 쿠폰 <span class="checkout_no" id="use_coupon_cnt">0</span>장 / 보유쿠폰 <span class="checkout_no" id="total_coupon_cnt">0</span>장
                                </c:otherwise>
                            </c:choose>
                            </td>
                            <td rowspan="4" style="padding:0">
                                <div class="checkout_info" style="width:282px;margin-bottom: 0">
                                    <ul style="margin-bottom:0">
                                        <li>- 총 주문금액 <span id="totalOrderAmt"><fmt:formatNumber value="${orderTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span></li>
                                        <li>- 배송비 <span id="totalDlvrAmt">(+) <fmt:formatNumber value="${dlvrTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span></li>
                                        <li>- 추가 배송비 <span id="totalAddDlvrAmt">(+) 0 원</span></li>
                                        <li>- 할인금액 <span id="totalDcAmt">(-) <fmt:formatNumber value="${promotionTotalDcAmt+memberGradeTotalDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span></li>
                                        <li>- 마켓포인트 <span id="totalMileageAmt">(-) 0 원</span></li>
                                        <li class="checkout_total" style="margin-top:10px">결제금액 <span id="totalPaymentAmt"><fmt:formatNumber value="${paymentTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span></li>
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
                                    </ul>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">마켓포인트</th>
                            <td class="f12">
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
                                            <input type="text" name="mileageAmt" id="mileageAmt" value="0" onKeydown="onlyNumDecimalInput(event);" onblur="jsCalcMileageAmt();"> 원
                                            <button type="button" class="btn_checkout_info" id="mileageAllUse" style="margin:0 10px 0 20px" onclick="jsUseAllMileageAmt()">전액사용</button> 현재 <span class="checkout_no">
                                            <fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원 보유
                                            (<fmt:formatNumber value="${svmnUseUnitCd}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 단위로 사용가능)
                                            <input type="hidden" name="mileage" id="mileage" value="<fmt:parseNumber type='number' value='${member_info.data.prcAmt}'/>">
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">배송비</th>
                            <td class="f12">
                                <span class="checkout_no"><fmt:formatNumber value="${dlvrTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">적립혜택</th>
                            <td class="f12">
                                <c:choose>
                                    <c:when test="${user.session.memberNo ne null}">
                                    물품수령 확인 시 마켓포인트 <span class="checkout_no"><fmt:formatNumber value="${pvdSvmnTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원 지급
                                    </c:when>
                                    <c:otherwise>
                                    <span class="fRed">적립혜택이 없습니다.</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="product_stit">
                    주문고객 정보
                </h3>
                <table class="tProduct_Insert">
                    <caption>
                        <h1 class="blind">주문고객 정보 입력폼 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:140px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="order_tit">주문자명</th>
                            <td>
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
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">이메일</th>
                            <td>
                                <input type="text" name="email01" id="email01" style="width:232px;"> @ <input type="text" name="email02" id="email02" style="width:124px;">
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
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">연락처</th>
                            <td>
                                <select name="ordrTel01" id="ordrTel01" style="width:69px">
                                    <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                </select>
                                -
                                <input type="text" name="ordrTel02" id="ordrTel02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                -
                                <input type="text" name="ordrTel03" id="ordrTel03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                <input type="hidden" name="ordrTel" id="ordrTel" value="">
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit"><em>*</em>휴대폰</th>
                            <td>
                                <select name="ordrMobile01" id="ordrMobile01" style="width:69px">
                                    <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                </select>
                                -
                                <input type="text" name="ordrMobile02" id="ordrMobile02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                -
                                <input type="text" name="ordrMobile03" id="ordrMobile03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                <input type="hidden" name="ordrMobile" id="ordrMobile" value="">
                            </td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="product_stit">
                    배송지 정보 <span class="insert_checkout_info"><em>*</em> 필수입력</span>
                    <%-- <c:if test="${user.session.memberNo ne null}">
                    <button type="button" class="btn_address_plus floatR">새배송지 등록</button>
                    </c:if> --%>
                    <div class="qna_check  floatR order_info_checked">
                        <label>
                            <input type="checkbox" name="rule01_agree" id="rule01_agree" onclick="setAdrsInfo();">
                            <span></span>
                        </label>
                        <label for="rule01_agree">주문자정보와 같음</label>
                    </div>
                </h3>
                <table class="tProduct_Insert">
                    <caption>
                        <h1 class="blind">배송지 정보 입력폼 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:140px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="order_tit"><em>*</em>수령인</th>
                            <td>
                                <input type="text" name="adrsNm" id="adrsNm" value="">
                            </td>
                        </tr>
                        <c:if test="${user.session.memberNo ne null}">
                        <tr>
                            <th class="order_tit"><em>*</em>배송지 선택</th>
                            <td>
                                <input type="radio" id="shipping_address" name="shipping_address" value="1">
                                <label for="shipping_address" style="margin-right:15px">
                                    <span></span>
                                    기본배송지
                                </label>
                                <input type="radio" id="recently_shipping_address" name="shipping_address" value="2">
                                <label for="recently_shipping_address" style="margin-right:15px">
                                    <span></span>
                                    최근배송지
                                </label>
                                <input type="radio" id="new_shipping_address01" name="shipping_address" value="3">
                                <label for="new_shipping_address01" style="margin-right:15px">
                                    <span></span>
                                    신규배송지
                                </label>
                                <span id="newDelivery" style="display:none;">
                                <!-- <input type="text" id="new_shipping_address02" placeholder="배송지명" style="margin-right:5px"> -->
                                </span>
                                <!-- <button type="button" class="btn_checkout_info">나의 배송 주소록</button> -->
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
                            </td>
                        </tr>
                        </c:if>
                        <%-- <tr>
                            <th class="order_tit">이메일</th>
                            <td>
                                <input type="text" name="email01" id="email01" style="width:232px;"> @ <input type="text" name="email02" id="email02" style="width:124px;">
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
                                <input type="hidden" name="adrsEmail" id="adrsEmail" value="">
                            </td>
                        </tr> --%>
                        <tr>
                            <th class="order_tit">연락처</th>
                            <td>
                                <select name="adrsTel01" id="adrsTel01" style="width:69px">
                                    <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                </select>
                                -
                                <input type="text" name="adrsTel02" id="adrsTel02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                -
                                <input type="text" name="adrsTel03" id="adrsTel03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                <input type="hidden" name="adrsTel" id="adrsTel" value="">
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit"><em>*</em>휴대폰</th>
                            <td>
                                <select name="adrsMobile01" id="adrsMobile01" style="width:69px">
                                    <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                </select>
                                -
                                <input type="text" name="adrsMobile02" id="adrsMobile02" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                -
                                <input type="text" name="adrsMobile03" id="adrsMobile03" style="width:67px" maxlength="4" onKeydown="onlyNumDecimalInput(event);">
                                <input type="hidden" name="adrsMobile" id="adrsMobile" value="">
                            </td>
                        </tr>
                        <tr>
                            <th class="order_tit">거주지</th>
                            <td>
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
                            </td>
                        </tr>

                        <!--국내 선택시 default-->
                        <tr class="radio_con_a">
                            <th class="order_tit" ><em>*</em>배송지</th>
                            <td>
                                <ul class="address_insert">
                                    <li><input type="text" name="postNo" id="postNo" style="width:124px;margin-right:5px" readonly>
                                        <button type="button" class="btn_post">우편번호</button>
                                        <%-- <c:if test="${user.session.memberNo ne null}">
                                        <div class="order_delivery_check">
                                            <label class="pdl">
                                                <input type="checkbox" name="order_agree">
                                                <span></span>
                                            </label>
                                            <label for="order_agree">배송지목록에 추가</label>

                                            <label class="pdl">
                                                <input type="checkbox" name="order_agree">
                                                <span></span>
                                            </label>
                                            <label for="order_agree">기본 배송지로 선택</label>

                                            <label class="pdl">
                                                <input type="checkbox" name="order_agree">
                                                <span></span>
                                            </label>
                                            <label for="order_agree">회원정보 업데이트</label>
                                        </div>
                                        </c:if> --%>
                                    </li>
                                    <li><span class="address_tit" style="width:65px">지번주소</span><input type="text" name="numAddr" id="numAddr" style="width:571px;" readonly></li>
                                    <li><span class="address_tit" style="width:65px">도로명주소</span><input type="text" name="roadnmAddr" id="roadnmAddr" style="width:571px;" readonly></li>
                                    <li style="margin-bottom:2px"><span class="address_tit" style="width:65px">상세주소</span><input type="text" name="dtlAddr" id="dtlAddr" style="width:571px"></li>
                                    <input type="hidden" name="adrsAddr" value="">
                                </ul>
                            </td>
                        </tr>
                        <!--//국내 선택시 default-->

                        <!--해외 선택시-->
                        <tr class="radio_con_b" style="display:none;">
                            <th class="order_tit" ><em>*</em>배송지</th>
                            <td>
                                <ul class="address_insert">
                                    <li><span class="address_tit" style="width:65px">Country</span>
                                        <div id="shipping_country" class="select_box28" style="width:578px;display:inline-block">
                                            <label for="select_option">- 선택 -</label>
                                            <select class="select_option" title="select option" name="frgAddrCountry" id="frgAddrCountry">
                                                <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true"  mode="S"/>
                                            </select>
                                        </div>
                                    </li>
                                    <li><span class="address_tit" style="width:65px">Zip</span><input type="text" name="frgAddrZipCode" id="frgAddrZipCode" style="width:571px;"></li>
                                    <li><span class="address_tit" style="width:65px">State</span><input type="text" name="frgAddrState" id="frgAddrState" style="width:571px;"></li>
                                    <li><span class="address_tit" style="width:65px">City</span><input type="text" name="frgAddrCity" id="frgAddrCity" style="width:571px;"></li>
                                    <li><span class="address_tit" style="width:65px">address1</span><input type="text" name="frgAddrDtl1" id="frgAddrDtl1" style="width:571px;"></li>
                                    <li><span class="address_tit" style="width:65px">address2</span><input type="text" name="frgAddrDtl2" id="frgAddrDtl2" style="width:571px;"></li>
                                </ul>
                            </td>
                        </tr>
                        <!--//해외 선택시-->

                        <tr>
                            <th class="order_tit">배송메세지</th>
                            <td>
                                <ul class="order_info_list">
                                    <li>
                                        <select id="shipping_message" style="width:648px">
                                            <option value="배송전, 연락바랍니다.">배송전, 연락바랍니다.</option>
                                            <option value="부재시, 전화주시거나 또는 문자 남겨주세요.">부재시, 전화주시거나 또는 문자 남겨주세요.</option>
                                            <option value="부재시, 경비실에 맡겨주세요.">부재시, 경비실에 맡겨주세요.</option>
                                            <option value="">기타</option>
                                        </select>
                                    </li>
                                    <li>
                                        <span id="dlvrText" style="display:none"><input type="text" name="dlvrMsg" id="dlvrMsg" style="width:636px" value="배송전, 연락바랍니다."></span>
                                        <p class="ship_text">예약상품인 경우 꼭 상품상세페이지 확인 후 희망배송일자를 입력해주세요. (상품마다 내용이 상이할 수 있습니다.)</p>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <h3 class="product_stit">결제수단 선택</h3>
                <table class="tProduct_Insert">
                    <caption>
                        <h1 class="blind">결제수단 선택 정보 입력폼 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:140px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="order_tit">결제수단</th>
                            <td>
                                <c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">
                                <div style="width:240px; height:36px;">
                                    <input type="radio" id="paymentWayCd06" name="paymentWayCd" value="31">
                                    <label for="paymentWayCd06" style="margin-right:30px" class="radio_chack2_f">
                                        <span class="img"></span>
                                        <c:choose>
                                            <c:when test="${simplePaymentConfig.data.dsnSetCd eq '01'}">
                                            <img src="/front/img/product/easypay_a1.png">
                                            </c:when>
                                            <c:otherwise>
                                            <img src="/front/img/product/easypay_a2.png">
                                            </c:otherwise>
                                        </c:choose>
                                    </label>
                                </div>
                                </c:if>
                                <%--페이코 버튼 스크립트 적용방법--%>
                                <%--
                                <div style="width:240px; height:36px;">
                                    //기존 간편결제(페이코)버튼 이미지는 수동으로 적용하였으나
                                    //페이코측에서 제공하는 버튼 생성 스크립트가 있으므로 그걸 사용한다.
                                    <input type="radio" id="paymentWayCd06" name="paymentWayCd" value="31">
                                    <label for="paymentWayCd06" style="margin-right:30px" class="radio_chack2_f">
                                        <span></span>
                                        <q id="paycoBtnWrapper" style="display:inline"></q>
                                    </label>
                                </div>
                                --%>
                                <c:if test="${site_info.nopbpaymentUseYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd01" name="paymentWayCd" value="11">
                                <label for="paymentWayCd01" style="margin-right:30px" class="radio_chack2_a">
                                    <span></span>
                                    무통장입금
                                </label>
                                </c:if>
                                <c:if test="${pgPaymentConfig.data.virtactPaymentYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd02" name="paymentWayCd" value="22">
                                <label for="paymentWayCd02" style="margin-right:30px" class="radio_chack2_b">
                                    <span></span>
                                    가상계좌
                                </label>
                                </c:if>
                                <c:if test="${pgPaymentConfig.data.credPaymentYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd03" name="paymentWayCd" value="23">
                                <label for="paymentWayCd03" style="margin-right:30px" class="radio_chack2_c">
                                    <span></span>
                                    신용카드 결제
                                </label>
                                </c:if>
                                <c:if test="${pgPaymentConfig.data.acttransPaymentYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd04" name="paymentWayCd" value="21">
                                <label for="paymentWayCd04" style="margin-right:30px" class="radio_chack2_d">
                                    <span></span>
                                    실시간 계좌이체
                                </label>
                                </c:if>
                                <c:if test="${pgPaymentConfig.data.mobilePaymentYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd05" name="paymentWayCd" value="24">
                                <label for="paymentWayCd05" style="margin-right:30px" class="radio_chack2_e">
                                    <span></span>
                                    휴대폰결제
                                </label>
                                </c:if>
                                <c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
                                <input type="radio" id="paymentWayCd07" name="paymentWayCd" value="41">
                                <label for="paymentWayCd07" class="radio_chack2_g">
                                    <span></span>
                                    PAYPAL
                                </label>
                                </c:if>
                            </td>
                        </tr>

                        <!--무통장-->
                        <tr class="tr_11" style="display:none;">
                            <th class="order_tit">입금은행</th>
                            <td>
                                <div id="bank_select" class="select_box28" style="width:250px;">
                                    <label for="select_option">- 선택 -</label>
                                    <select class="select_option" title="select option" name="bankCd">
                                        <option value="" selected="selected">- 선택 - </option>
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
                            </td>
                        </tr>
                        <!-- 가상계좌 -->
                        <!--
                        <tr class="tr_22" style="display:none;">
                            <th class="order_tit">은행선택</th>
                            <td>
                                <div id="bank_select" class="select_box28" style="width:150px;">
                                    <label for="select_option">은행선택</label>
                                    <select class="select_option" title="select option">
                                        <option selected="selected">000</option>
                                        <option>000</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        -->
                        <!-- 무통장 입금안내 -->
                        <tr class="tr_11" style="display:none;">
                            <th class="order_tit">무통장입금안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank">[결제하기] 버튼 클릭시, 무통장입금 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    <li>* 주문자명과 입금자명이 다르더라도 발급된 가상계좌번호로 정확한 금액을 입금하시면 정상 입금확인이 가능합니다.</li>
                                    <li>* 무통장입금 시 일부 은행(농협 및 국민은행)의 경우 ATM기기 입금이 불가할 수 있습니다. 이 경우 은행 창구 또는 인터넷 뱅킹을 이용해 주시기 바랍니다. </li>
                                    <li><a href="javascript:popupInfo('vBank');"><img src="../img/product/btn_bank_info.gif" alt="무통장입금 이용안내" style="margin-left:10px"></a></li>
                                </ul>
                            </td>
                        </tr>
                        <!-- 가상계좌 입금안내 -->
                        <tr class="tr_22" style="display:none;">
                            <th class="order_tit">가상계좌 안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank">[결제하기] 버튼 클릭시, 무통장입금 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    <li>* 주문자명과 입금자명이 다르더라도 발급된 가상계좌번호로 정확한 금액을 입금하시면 정상 입금확인이 가능합니다.</li>
                                    <li>* 무통장입금 시 일부 은행(농협 및 국민은행)의 경우 ATM기기 입금이 불가할 수 있습니다. 이 경우 은행 창구 또는 인터넷 뱅킹을 이용해 주시기 바랍니다. </li>
                                    <li><a href="javascript:popupInfo('vBank')"><img src="../img/product/btn_bank_info.gif" alt="무통장입금 이용안내" style="margin-left:10px"></a></li>
                                </ul>
                            </td>
                        </tr>
                        <!--신용카드 결제-->
                        <%--
                        <tr class="tr_23" style="display:none;">
                            <th class="order_tit">신용카드 결제</th>
                            <td>
                                <input type="radio" id="shop_card01" name="shop_card" checked>
                                <label for="shop_card01">
                                    <span></span>
                                    안전결제
                                </label>
                                <div id="card01" class="select_box28" style="width:137px;display:inline-block; margin-left:25px;" name="shop_card_01">
                                    <label for="card01">선택</label>
                                    <select class="select_option" title="select option" name="cccpnCd_01">
                                        <code:optionUDV codeGrp="CARD_CD" includeTotal="true" mode="S"/>
                                    </select>
                                </div>
                                <div id="card02" class="select_box28" style="width:67px;display:inline-block; margin-right:25px;" name="shop_card_01">
                                    <label for="card02">선택</label>
                                    <select class="select_option" title="select option">
                                        <option value="" selected="selected">선택</option>
                                        <option value="01">일시불</option>
                                    </select>
                                </div>

                                <input type="radio" id="shop_card02" name="shop_card">
                                <label for="shop_card02">
                                    <span></span>
                                    안심클릭
                                </label>
                                 <div id="card03" class="select_box28" style="width:137px;display:inline-block; margin-left:25px;" name="shop_card_02">
                                    <label for="card03">선택</label>
                                    <select class="select_option" title="select option" name="cccpnCd_02">
                                        <code:optionUDV codeGrp="CARD_CD" includeTotal="true" mode="S"/>
                                    </select>
                                </div>
                                <div id="card04" class="select_box28" style="width:67px;display:inline-block; margin-right:25px;" name="shop_card_02">
                                    <label for="card04">선택</label>
                                    <select class="select_option" title="select option">
                                        <option selected="selected">선택</option>
                                        <option>일시불</option>
                                    </select>
                                </div>

                            </td>
                        </tr>
                         --%>
                        <!-- 신용카드 결제 안내 -->
                        <tr class="tr_23" style="display:none;">
                            <th class="order_tit">신용카드 결제안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank">[결제하기] 버튼 클릭시, 신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    <li><a href="javascript:popupInfo('isp');"><img src="../img/product/btn_card1_info.gif" alt="안전결제 안내"></a> <a href="javascript:popupInfo('safe');"><img src="../img/product/btn_card2_info.gif" alt="안심클릭 안내" style="margin-left:10px"></a> <a href="javascript:popupInfo('official');"><img src="../img/product/btn_card3_info.gif" alt="공인인증서 안내" style="margin-left:10px"></a></li>
                                </ul>
                            </td>
                        </tr>
                        <!--실시간 계좌이체 안내-->
                        <tr class="tr_21" style="display:none;">
                            <th class="order_tit">실시간 계좌이체 안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank">[결제하기] 버튼 클릭시, 실시간 계좌이체 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    <li>* 회원님의 계좌에서 바로 이체되는 서비스이며, 이체 수수료는 무료입니다.<a href="javascript:popupInfo('account');"><img src="../img/product/btn_bank01_info.gif" alt="실시간계좌이체 이용안내" style="vertical-align:middle;margin-left:10px"></a></li>
                                    <li>* 23시 이후에는 은행별 이용 가능시간을 미리 확인하신 후 결제를 진행해 주세요. <a href="javascript:popupInfo('accountTime');"><img src="../img/product/btn_bank02_info.gif" alt="은행별 이용가능시간 이용안내" style="vertical-align:middle;margin-left:10px"></a></li>
                                    <li></li>
                                </ul>
                            </td>
                        </tr>
                        <!-- 휴대폰 결제 안내 -->
                        <tr class="tr_24" style="display:none;">
                            <th class="order_tit">휴대폰 결제안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li>휴대폰 결제는 통신사에 따라 결제 한도금액이 다릅니다. 자세한 내용은 휴대폰 결제안내를 확인해주세요.</li>
                                    <li>
                                        휴대폰 결제의 경우 가입하신 이동통신사에서 증빙을 발급 받을 수 있습니다.
                                        <a href="javascript:popupInfo('hpp');"><img src="../img/product/btn_mobile_pay.gif" alt="휴대폰 결제안내" style="vertical-align:middle;margin-left:10px"></a>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <!-- 간편결제 안내 -->
                        <tr class="tr_31" style="display:none;">
                            <th class="order_tit">간편결제 안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank">  [결제하기] 버튼 클릭시, 간편 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    <li class="blank">- PAYCO는 NHN엔터테인먼트가 만든 안전한 간편결제 서비스입니다.<br/>
                                    - 휴대폰과 카드 명의자가 동일해야 하며 결제금액 제한은 없습니다.<br/>
                                    - 결제 가능 카드 : 모든 신용/체크 카드 결제 가능

                                    </li>
                                </ul>
                            </td>
                        </tr>
                        <!-- PAYPAL결제 안내 -->
                        <tr class="tr_41" style="display:none;">
                            <th class="order_tit">PAYPAL결제 안내</th>
                            <td>
                                <ul class="order_info_list">
                                    <li class="blank"> [결제하기] 버튼 클릭시, PAYPAL 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                </ul>
                            </td>
                        </tr>
                        <!-- 에스크로서비스 이용 -->
                        <c:if test="${pgPaymentConfig.data.escrowUseYn eq 'Y'}">
                        <tr class="tr_21 tr_22" style="display:none;">
                            <th class="order_tit">에스크로서비스 이용</th>
                            <td>
                                <ul class="order_info_list">
                                    <li>
                                        <input type="radio" id="service_yes" name="escrowYn" value="Y">
                                        <label for="service_yes">
                                            <span></span>
                                            예
                                        </label>
                                        <input type="radio" id="service_no" name="escrowYn" value="N" checked>
                                        <label for="service_no" style="margin-left:30px">
                                            <span></span>
                                            아니오
                                        </label>
                                    </li>
                                    <li>정부방침에 따라 실시간계좌이체 및 무통장입금(가상계좌)로 주문하시는 경우 에스크로 서비스 이용여부를 선택하실 수 있습니다.</li>
                                </ul>
                            </td>
                        </tr>
                        </c:if>
                        <!-- 매출증빙 -->
                        <tr class="tr_21 tr_22 tr_31 tr_41" style="display:none;">
                            <th class="order_tit">매출증빙</th>
                            <td>
                                <input type="radio" id="shop_paper01" name="cashRctYn" value="N" checked="checked">
                                <label for="shop_paper01" class="radio_chack1_a">
                                    <span></span>
                                    발급안함
                                </label>
                                <c:if test="${pgPaymentConfig.data.cashRctUseYn eq 'Y'}">
                                <span class="tr_21 tr_22" style="display:none;">
                                <input type="radio" id="shop_paper02" name="cashRctYn" value="Y">
                                <label for="shop_paper02" class="radio_chack1_b" style="margin-left:30px">
                                    <span></span>
                                    현금영수증
                                </label>
                                </span>
                                </c:if>
                                <input type="radio" id="shop_paper03" name="cashRctYn" value="B">
                                <label for="shop_paper03" class="radio_chack1_c" style="margin-left:30px">
                                    <span></span>
                                    계산서
                                </label>
                                <a href="javascript:popupInfo('evidence');"><img src="../img/product/btn_pay_paper.gif" alt="증빙발급 안내" style="vertical-align:middle;margin-left:15px"></a>
                                <%--
                                <!--현금영수증 선택시-->
                                <div class="order_card_view radio1_con_a" style="display:none;">
                                    <table>
                                        <colgroup>
                                            <col width="20%">
                                            <col width="80%">
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th>발행용도</th>
                                                <td class="txt11">
                                                    <input type="radio" id="shop_view01" name="shop_view">
                                                    <label for="shop_view01" style="margin-right:15px;">
                                                        <span style="padding:0;"></span>
                                                       개인소득공제용
                                                    </label>
                                                    <input type="radio" id="shop_view02" name="shop_view">
                                                    <label for="shop_view02">
                                                        <span style="padding:0;"></span>
                                                       사업자지출용
                                                    </label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>인증번호</th>
                                                <td class="txt11">휴대폰 번호 <input type="text" name="cashMobile" id="cashMobile"> ("-"없이 입력)</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                   <span>* PG 결제창이나 PG 사에 현금 영수증을 직접 신청하면 중복 발행될 수 있으니 주의하시길 바랍니다.</span>
                                </div>
                                <!--//현금영수증 선택시-->
                                --%>

                                <!--계산서 선택시-->
                                <div class="order_card_view radio1_con_b" style="display:none;">
                                    <table>
                                        <colgroup>
                                            <col width="20%">
                                            <col width="80%">
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <th>상호명</th>
                                                <td class="txt11"><input type="text" name="billCompanyNm"></td>
                                            </tr>
                                            <tr>
                                                <th>사업자번호</th>
                                                <td class="txt11"><input type="text" name="billBizNo" maxlength="13"></td>
                                            </tr>
                                            <tr>
                                                <th>대표자명</th>
                                                <td class="txt11"><input type="text" name="billCeoNm"></td>
                                            </tr>
                                            <tr>
                                                <th>업태/업종</th>
                                                <td class="txt11"><input type="text" name="billBsnsCdts"> <input type="text" name="billItem"></td>
                                            </tr>
                                            <tr>
                                                <th rowspan="2">주소</th>
                                                <td class="txt11"><input type="text" name="billPostNo" id="billPostNo" readonly> <a href="javascript:billPost();"><img src="../img/product/btn_post_info.gif" alt="우편번호 검색" style="vertical-align:middle;margin-left:15px"></a></td>
                                            </tr>
                                            <tr>
                                                <td class="txt11"><input type="text" name="billRoadnmAddr" id="billRoadnmAddr" readonly> <input type="text" name="billDtlAddr"></td>
                                            </tr>
                                            <tr>
                                                <th>담당자명</th>
                                                <td class="txt11"><input type="text" name="billManagerNm"></td>
                                            </tr>
                                            <tr>
                                                <th>이메일</th>
                                                <td class="txt11"><input type="text" name="billEmail"></td>
                                            </tr>
                                            <tr>
                                                <th>연락처</th>
                                                <td class="txt11"><input type="text" name="billTelNo"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--//계산서 선택시-->
                            </td>
                        </tr>
                        <!-- 주문 동의 -->
                        <tr>
                            <th class="order_tit">주문자동의</th>
                            <td>
                                <ul class="order_info_list">
                                    <li><b>주문동의</b></li>
                                    <li>주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며, 구매에 동의하시겠습니까? (전자상거래법 제8조 제2항)</li>
                                    <div class="order_agree_check">
                                        <label>
                                            <input type="checkbox" name="order_agree" id="order_agree">
                                            <span></span>
                                        </label>
                                        <label for="order_agree">동의합니다.</label>
                                    </div>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="btn_area">
                    <button type="button" class="btn_payment" >결제하기</button>
                    <button type="button" class="btn_pre_page">이전페이지</button>
                </div>
            </div>
        </div>
        <!---// best product --->

        <!--- popup 무통장입금(가상계좌) 이용 안내 --->
        <div class="popup_bank" id="popup_bank" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">무통장입금(가상계좌) 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 무통장입금(가상계좌) 이용 안내 --->
        <!--- popup 안전결제(ISP) 안내 --->
        <div class="popup_safe_checkout" id="popup_safe_checkout" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">안전결제(ISP) 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 안전결제(ISP) 안내 --->
        <!--- popup 안심클릭 안내 --->
        <div class="popup_safe_click" id="popup_safe_click" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">안심클릭 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 안심클릭 안내 --->
        <!--- popup 공인인증안내 --->
        <div class="popup_official" id="popup_official" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">공인인증 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
                        <li><img src="/front/img/product/img_popup_official.png" alt="공인인증서 발급 안내"></li>
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
        <!---// popup 공인인증안내 --->
        <!--- popup 실시간 계좌이체 이용안내 --->
        <div class="popup_account" id="popup_account" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">실시간 계좌이체 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 실시간 계좌이체 이용안내 --->
        <!--- popup 실시간 계좌이체 이용가능 시간안내 --->
        <div class="popup_account_time" id="popup_account_time" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">실시간 계좌이체 이용가능 시간 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 실시간 계좌이체 이용가능 시간안내 --->
        <!--- popup 휴대폰결제 이용 안내 --->
        <div class="popup_official" id="popup_hpp" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">휴대폰결제 이용 안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 휴대폰결제 이용 안내 --->

        <!--- popup 증빙발급안내 --->
        <div class="popup_evidence" id="popup_evidence" style="display:none;">
            <div class="popup_header">
                <h1 class="popup_tit">증빙발급안내</h1>
                <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
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
        <!---// popup 증빙발급안내 --->

    <input type="hidden" name="ordNo" value="${ordNo}"/>
    <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
    <input type="hidden" id="confirmNo" name="confirmNo" value=""/> <%-- 페이팔, 페이코(reserveOrderNo) 사용 --%>
    <input type="hidden" id="txNo" name="txNo" value=""/> <%-- 페이팔, 페이코(paymentCertifyToken) 사용 --%>
    <input type="hidden" id="logYn" name="logYn" value=""/> <%-- 페이팔, 페이코(logYn) 사용 --%>
    <input type="hidden" id="confirmResultCd" name="confirmResultCd" value=""/> <%-- 페이팔, 페이코() 사용 --%>
    <input type="hidden" id="serverType" name="serverType" value=""/> <%-- 페이팔, 페이코() 사용 --%>
    <%--
    PG 선택 >>  <select id="paymentPgCd" name="orderPayPO.paymentPgCd">
    <code:optionUDV codeGrp="PAYMENT_PG_CD" />
    </select>
     --%>
    <!-- 매핑 input 태그 추가 -->
    <%--
    <input type="hidden" id="confirmResultCd" name="orderPayPO.confirmResultCd" value=""/>
    <input type="hidden" id="confirmResultMsg" name="orderPayPO.confirmResultMsg" value=""/>
    <input type="hidden" id="confirmDttm" name="orderPayPO.confirmDttm" value=""/>
    <input type="hidden" id="memoContent" name="orderInfoPO.memoContent" value=""/>
    <input type="hidden" id="paymentWayCd" name="orderPayPO.paymentWayCd" value="41"/> 41:페이팔(hidden값으로 테스트)
    <input type="hidden" name="ordNo" value="${ordNo}"/>
    <input type="hidden" name="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
    --%>
    <c:if test="${pgPaymentConfig.data.pgCd eq '01'}">
    <!-- KCP연동 -->
    <!-- <font color="blue" size="5"><b>== 여기부터 KCP ===================================================================================================</b></font> -->
    <%@ include file="include/01/kcp_req.jsp" %>
    <!--//KCP연동  -->
    </c:if>
    <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
    <!-- 이니시스연동 -->
    <%--<font color="blue" size="5"><b>== 여기부터 이니시스 ================================================================================================</b></font>--%>
    <%@ include file="include/inicis/inicis_req.jsp" %>
    <!--// 이니시스연동 -->
    </c:if>
    <c:if test="${pgPaymentConfig.data.pgCd eq '03'}">
    <%--<font color="blue" size="5"><b>== 여기부터 LGU+ ================================================================================================</b></font>--%>
    <%@ include file="include/03/PayreqCrossplatform.jsp"%>
    </c:if>
    <c:if test="${pgPaymentConfig.data.pgCd eq '04'}">
    <%--<font color="blue" size="5"><b>== 여기부터 올더게이트 ================================================================================================</b></font>--%>
    <%@ include file="include/04/AGS_pay.jsp"%>
    </c:if>
    </form>

    <c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
    <!-- PAYPAL연동 -->
    <%--<font color="blue" size="5"><b>== 여기부터 PAYPAL ================================================================================================</b></font>--%>
    <%-- <%@ include file="include/paypal_req.jsp"%> --%>
    <!--//PAYPAL연동  -->
    </c:if>
    <c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">
    <!-- PAYCO연동 -->
    <br/>
    <%--<font color="blue" size="5"><b>== 여기부터 PAYCO ================================================================================================</b></font>--%>
    <br>
    <%@ include file="include/payco/payco_form.jsp" %>
    <!--// PAYCO연동 -->
    </c:if>
    </t:putAttribute>
</t:insertDefinition>