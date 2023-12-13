<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%
    Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    cal.add(Calendar.DATE, 5);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String date = sdf.format(cal.getTime())+"235959";
%>
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
<jsp:useBean id="su" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<c:set var="date" value="<%=date%>"/>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 주문하기</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">

            <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
            <c:if test="${server ne 'product'}">
                <!-- 테스트 JS(샘플에 제공된 테스트 MID 전용) -->
                <%-- TODO... 반드시 커밋할땐 풀어야함 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --%>
                <script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>

                <%-- 상용 JS(가맹점 MID 변경 시 주석 해제, 테스트용 JS 주석 처리 필수!) --%>
                <%-- TODO... 반드시 커밋할땐 지워야함(운영용) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --%>
                <%--<script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>--%>

            </c:if>
            <c:if test="${server eq 'product'}">
                <!-- 상용 JS(가맹점 MID 변경 시 주석 해제, 테스트용 JS 주석 처리 필수!) -->
                <script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
            </c:if>
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
                    /* var _tel = '${member_info.data.tel}';
                    if(_tel != '') {
                        var temp_tel = Dmall.formatter.tel(_tel).split('-');
                        if(temp_tel.length == 3) {
                            $('#ordrTel01').val(temp_tel[0]);
                            $('#ordrTel02').val(temp_tel[1]);
                            $('#ordrTel03').val(temp_tel[2]);
                            $('#ordrTel01').trigger('change');
                        }
                    } */

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
                        //특가상품 제외
                        if(d.spcYn!='Y'){
                            params[i++]=d;
                        }
                    });
                    return params;
                }

                $('#agree_check_all').click(function(){

                    $('#agree_check01').click();
                    $('#agree_check02').click();
                });

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
                        var basicAdrsTel = $('#basicAdrsTel').val();
                        var basicAdrsMobile = $('#basicAdrsMobile').val();

                        if(basicAdrsMobile !=''){
                            $('#adrsMobile01').val(basicAdrsMobile.split('-')[0]);
                            $('#adrsMobile02').val(basicAdrsMobile.split('-')[1]);
                            $('#adrsMobile03').val(basicAdrsMobile.split('-')[2]);

                        }

                        if(basicAdrsTel !=''){
                            $('#adrsTel01').val(basicAdrsTel.split('-')[0]);
                            $('#adrsTel02').val(basicAdrsTel.split('-')[1]);
                            $('#adrsTel03').val(basicAdrsTel.split('-')[2]);

                        }
                        $('#adrsNm').val($('#basicAdrsNm').val());
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


                            var recentAdrsTel = $('#recentAdrsTel').val();
                            var recentAdrsMobile = $('#recentAdrsMobile').val();

                            if(recentAdrsMobile!=''){
                                $('#adrsMobile01').val(recentAdrsMobile.split('-')[0]);
                                $('#adrsMobile02').val(recentAdrsMobile.split('-')[1]);
                                $('#adrsMobile03').val(recentAdrsMobile.split('-')[2]);
                            }

                            if(recentAdrsTel!=''){
                                $('#adrsTel01').val(recentAdrsTel.split('-')[0]);
                                $('#adrsTel02').val(recentAdrsTel.split('-')[1]);
                                $('#adrsTel03').val(recentAdrsTel.split('-')[2]);
                            }

                            $('#adrsNm').val($('#recentAdrsNm').val());
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

                /* 나의 배송 주소록*/
                $('#my_shipping_address').on('click',function(){
                    $('#myDeliveryList').html('');
                    var myDelivery = '/front/order/myDelivery-list';
                    Dmall.AjaxUtil.load(myDelivery, function(result) {
                        $('#myDeliveryList').html(result);
                        Dmall.LayerPopupUtil.open($("#div_myDelivery"));
                    });
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

                            var orgPaymentAmt = Number($('#orgPaymentAmt').val()); //할인전 결제금액
                            var paymentAmt = Number($('#paymentAmt').val()); //결제금액
                            var couponTotalDcAmt = $('#couponTotalDcAmt').val();
                            var promotionTotalDcAmt = $('#promotionTotalDcAmt').val();
                            var memberGradeTotalDcAmt = $('#memberGradeTotalDcAmt').val();
                            var dcTotalAmt = Number(couponTotalDcAmt)+Number(promotionTotalDcAmt)+Number(memberGradeTotalDcAmt);

                            if(couponTotalDcAmt > orgPaymentAmt) {
                                Dmall.LayerUtil.alert('할인 금액이 결제금액보다 많습니다.');
                                $('#cpUseAmt').val(0);
                                $('#couponTotalDcAmt').val(0);
                                $('#dcAmt').val(0);
                                $('#totalDcAmt').html('(-) ' + 0 +' 원');
                                jsCalcTotalAmt();
                                return false;
                            }

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
                    var applyCouponData = [];
                    var i = 0;
                    var couponDcAmt = 0;
                    var couponTotalDcAmt = 0;
                    //자동쿠폰 적용
                    $(".item_list").each(function(){

                        var applyCouponNo=$(this).data().couponNo;

                        if(applyCouponNo!="") {
                            var salePrice = $(this).data().salePrice;
                            var qtt = $(this).data().ordQtt;
                            var couponUseLimitAmt = $(this).data().couponUseLimitAmt;
                            var check_use_goods_coupon = false;   //상품 쿠폰 중복 사용 체크
                            var check_useLimitAmt = false;   //최소 사용금액 제한 체크
                            var check_solo_use_yn = false;   //단독 사용 쿠폰 여부 체크

                            //최소사용금액 제한
                            if ((salePrice * qtt) > couponUseLimitAmt) {
                                check_useLimitAmt = true;
                                 //단독 사용 쿠폰일 경우 하나만 적용
                                 var couponSoloUseYn = $(this).data().couponSoloUseYn;
                                 if (couponSoloUseYn == "Y") {
                                    applyCouponData = [];
                                    applyCouponData[0] = $(this).data();
                                    couponDcAmt = $(this).data().couponDcAmt;
                                    if (couponDcAmt !== undefined && couponDcAmt != "") {
                                        couponTotalDcAmt = parseInt(couponDcAmt);
                                    }
                                    return false;
                                 }else{

                                    if(applyCouponData.length==0){
                                        applyCouponData[i] = $(this).data();
                                        couponDcAmt = $(this).data().couponDcAmt;
                                        if (couponDcAmt !== undefined && couponDcAmt != "") {
                                            couponTotalDcAmt += parseInt(couponDcAmt);
                                        }
                                    }
                                    for(var j=0;j<applyCouponData.length;j++){
                                         //같은 쿠폰 한번만 적용
                                        if(applyCouponData[j].couponNo!=$(this).data().couponNo){
                                            applyCouponData[i] = $(this).data();
                                            couponDcAmt = $(this).data().couponDcAmt;
                                            if (couponDcAmt !== undefined && couponDcAmt != "") {
                                                couponTotalDcAmt += parseInt(couponDcAmt);
                                            }
                                        }
                                    }
                                 }
                            }
                            i++;
                        }
                    });
                    var applyCouponResult = {};

                     try{applyCouponResult.dcTotalAmt = couponTotalDcAmt;
                            }catch (e) {applyCouponResult.dcTotalAmt="0";}
                    if(applyCouponData.length > 0) {
                        applyCouponResult.applyCouponData = applyCouponData;
                        autoApplyCoupon(applyCouponResult);
                    }else{
                        applyCouponResult.selectorData = [];
                        autoApplyCoupon(applyCouponResult);

                    }


                }

                /* 결제수단 선택 */
                $("input:radio[name=payment_select]").on('change', function(e) {
                    $('#paymentPgCd').val($(this).val());
                });

                /* 이전 */
                $('.btn_prev').on("click", function(){
                    window.history.back();
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
                    var pgCd =$('input[name=paymentWayCd]:checked').attr("pgCd");
                    $('[class^=tr_]').hide();
                    $('[class^=tr_]').each(function(){
                        if($(this).hasClass('tr_'+paymentWayCd)) {
                            $(this).show()
                        }
                    });

                    //간편결제(payco ,카카오페이, 삼성페이 ,Npay선택시 -- inicis)
                    if($(this).val() === '31') {
                        if(pgCd=="42"){
                            $('#paymentPgCd').val('42');
                        }else{
                            $('#paymentPgCd').val('02');
                        }

                    } else if($(this).val() === '41') {
                        //페이팔 선택시
                        $('#paymentPgCd').val('81');
                    } else if($(this).val() === '42') {
                        //Alipay 선택시
                        $('#paymentPgCd').val('82');
                    } else if($(this).val() === '43') {
                        //텐페이 선택시
                    $('#paymentPgCd').val('83');
                    } else if($(this).val() === '44') {
                        //위챗페이 선택시
                        $('#paymentPgCd').val('84');
                    } else {
                        $('#paymentPgCd').val('${pgPaymentConfig.data.pgCd}');
                    }
                    initPaymentConfig();
                });
                //기본 결제수단 신용카드로 체크
                $('input[name=paymentWayCd][value="23"]').prop("checked",true).trigger('click');

                /* 배송 메세지 */
                $('#shipping_message').on('change',function(){
                    if($('#shipping_message').find('option:selected').val() == '') {
                        $('#dlvrMsg').val('');
                        $('#dlvrText').show();
                    } else {
                        $('#dlvrText').hide();
                        $('#dlvrMsg').val($('#shipping_message').find('option:selected').val());
                    }
                });


                /* 시/도 선택시 */
                $('#sel_sidoCode').on('change',function (){
                    var optionSelected = $(this).find("option:selected").val();
                    var url = '/front/visit/change-sido';
                    var param = {def1 : optionSelected};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        $('#sel_guGunCode').empty();
                        $('#sel_guGunCode').append('<option value="">구/군</option>');
                        
			            var sortData = result;
			            sortData.sort(function(a,b){
			            	return (a.dtlNm < b.dtlNm) ? -1 : (a.dtlNm > b.dtlNm) ? 1 : 0;
			            });

                        // 취득결과 셋팅
                        jQuery.each(sortData, function(idx, obj) {
                            $('#sel_guGunCode').append('<option value="'+ obj.dtlCd + '">' + obj.dtlNm + '</option>');
                        });
                        
                        getSidoStoreList(optionSelected);                    
                    });
                });

                /* 구/군 선택시 */
                $('#sel_guGunCode').on('change',function (){

                    var optionSelected = $(this).find("option:selected").val();
                    var url = '/front/visit/store-list';
                    var sidoCode = $('#sel_sidoCode').find("option:selected").val();

                    //var hearingAidYn = hearingAidChk();
                    var param = {sidoCode : sidoCode, gugunCode : optionSelected};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        var address= [];
                        
    	            	if (result.strList.length == 0) {
    	                    alert('선택한 지역은 매장이 존재하지 않습니다.');
    	                    return false;
    	            	}			        	

                        // 취득결과 셋팅
                        jQuery.each(result.strList, function(idx, obj) {
                            var addr = obj.addr1||' '||obj.addr2;
                            var strCode = obj.strCode;
                            var strName = obj.strName;
                            address.push({"address":addr,"storeNo":strCode,"storeNm":strName});
                        });

                        searchGeoByAddr(address);
                    });
                });

                //방문예약일자 SET
                setVisitDate();

                //방문예약일시 변경시
                $('#sel_visit_date').on('change', function() {
                    var optionSelected = $(this).find("option:selected").val();
                    if (optionSelected == '' || optionSelected == undefined) {
                        alert("방문예정일을  선택해 주세요.");
                        $("#sel_visit_date").val("").prop("selected", true);
                        $("#sel_visitTime").val("");
                   	 	$('.visit_day_area').hide();
                        return false;
                    }

                    var storeNo = $('#storeNo').val();
                    if (storeNo == '' || storeNo == undefined) {
                        alert("방문하실 매장을 먼저 선택해 주세요.");
                        $("#sel_visit_date").val("").prop("selected", true);
                        return false;
                    }

                    var date = new Date(optionSelected);

                    //방문정보 setting
                    $('#storeTitle').text($('#storeNm').val() + "  :  " + date.format("yyyy년 MM월 dd일"));  //매장
                    $('#sel_visitTime').val('');
                    $('input[name=rsvDate]').val(date.format("yyyy-MM-dd"));

               	 	$('.visit_day_area').show();
                    getTimeTableList(optionSelected);
                });


                $("#my_shop").change(function(){
                    if($("#my_shop").is(":checked")){

                        var url = '/front/visit/store-info';
                        Dmall.AjaxUtil.load(url, function(result) {
                            var rs = JSON.parse(result);

                            var address= [];
                            var addr = rs.addr1||' '||rs.addr2;
                            var strCode = rs.strCode;
                            var strName = rs.strName;

                            if (strName == null || strName == '' || strName == undefined) {
                                alert("설정된 단골매장이 없습니다.");
                                $("#my_shop").attr('checked', false);
                                return false;
                            } else {
                                address.push({"address":addr,"storeNo":strCode,"storeNm":strName});

                                searchGeoByAddr(address);
                                $("#storeNo").val(strCode);
                                $("#storeNm").val(strName);
                            }
                        });
                    }
                });
                
              	//매장 텍스트 검색
                $('#btn_search_store').click(function(){
                	
                    var url = '/front/visit/store-list';
                    //var sidoCode = $('#sel_sidoCode').find("option:selected").val();
                    //var guGunCode = $('#sel_guGunCode').find("option:selected").val();
                    var strName = $('#searchStoreNm').val();
                    if(strName == null || strName == ''){
                    	Dmall.LayerUtil.alert('매장명을 입력해주세요.',"확인");
                        return false;
                    }else{
                    	//텍스트 검색일 경우 시도구군 상관없이 조회
                    	$('#sel_sidoCode option:eq(0)').prop('selected', true);
                    	$('#sel_guGunCode option:eq(0)').prop('selected', true);
                    }
                    
                    var hearingAidYn = hearingAidChk();
                    if (hearingAidYn != "Y") {
                    	hearingAidYn = "";
                    }
                    
                    if('${isHa}' == 'Y') hearingAidYn = 'Y';
                    
                    var erpItmCode = "";
                    $('input[name="erpItmCode"]').each(function() {
                    	if(erpItmCode != "") erpItmCode += ",";
                    	if($(this).val() != "") erpItmCode += $(this).val();
                    });
                    
                    var param = {hearingAidYn : hearingAidYn, erpItmCode : erpItmCode, strName : strName};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    	var address= [];
                    	
                    	if (result.strList.length == 0) {
                            Dmall.LayerUtil.alert('해당 매장이 존재하지 않습니다.',"확인");
                            return false;
                    	}		            	
                    	
                        // 취득결과 셋팅
                        jQuery.each(result.strList, function(idx, obj) {
                        	var addr = obj.addr1||' '||obj.addr2;
                        	var strCode = obj.strCode;
                        	var strName = obj.strName;
                            address.push({"address":addr,"storeNo":strCode,"storeNm":strName});
                        });
                    	
                        searchGeoByAddr(address);
                    });
                });

                //매장상세정보
                $("#store_info").on('click', function() {

                    var storeNm = $("#storeNm").val();

                    if (storeNm == null || storeNm == '') {
                        Dmall.LayerUtil.alert("매장을 먼저 선택해 주세요.", "확인");
                        return false;
                    }

                    var url = '/front/visit/store-detail-pop?storeCode=' + $("#storeNo").val();
                    Dmall.AjaxUtil.load(url, function(result) {
                        $('#div_store_detail_popup').html(result);
                        //$('#div_store_detail_popup').html(result).promise().done(function(){
                        //$('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
                        //});
//                     Dmall.LayerPopupUtil.open($("#div_store_detail_popup"));

                        map3 = new daum.maps.Map(document.getElementById('map3'), {
                            center: new daum.maps.LatLng(37.537123, 127.005523),
                            level: 3
                        });
                    })
                });
                
                //추천인 아이디 체크
                $('#btnRecomChk').click(function(){
                	var recomId = $('#recomMemberId').val();
                	if(recomId==''){
                	    Dmall.LayerUtil.alert("추천인 아이디를 입력해 주세요.", "확인");
                        return false;
                	}
                	
                    var hanExp = jQuery('#recomMemberId').val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
                    if( hanExp > -1 ){
                        Dmall.LayerUtil.alert("한글은 아이디에 사용하실수 없습니다.", "확인");
                        return false;
                    }
                    var memberNo = '${user.session.memberNo}';
                    var url = '/front/member/recomMember-id-check';
                    var param = {recomId : recomId};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    	if(result.success) {
                    	    if(memberNo==result.extraString){
                    	    Dmall.LayerUtil.alert("구매자 아이디는 추천인이 될 수 없습니다.", "확인");

                    	    $('#recomMemberId').val('');
                    		$('#recomMemberNo').val('');
                    	    }else{
                    	    Dmall.LayerUtil.alert("확인되었습니다.", "확인");
                    		$('#recomMemberNo').val(result.extraString);
                    	    }

                    	}else{
                    		Dmall.LayerUtil.alert("등록되지 않은 아이디입니다. 확인 후 다시 입력해주세요.", "확인");
                    	}
                    });
                	
                });
                
                // 추천인 변경시 추천인 번호 초기화
                $("#recomMemberId").on('change', function(e) {
                    $('#recomMemberNo').val("");
                });
                

                // 배송지정보 default - 기본배송지 셋팅
                $('#shipping_address').click();

                //INIStdPay.allowpopup();
            });


            /* 최대 사용 제한 */
            function svmnMaxUseLimit() {
            	var rtn = true ;

                var mileageTotalAmt = $('#mileageTotalAmt').val();

                //마켓포인트 사용 최대 제한 (기준정보)
                var svmnMaxUseGbCd = '${site_info.svmnMaxUseGbCd}';
                var svmnMaxUseAmt = '${site_info.svmnMaxUseAmt}';

                if (svmnMaxUseGbCd == '1') {
                	var svmnMaxUseTot = Number(goodsOrdTotAmt*svmnMaxUseAmt/100);

                    if(Number(svmnMaxUseTot) < Number(mileageTotalAmt)) {
                        Dmall.LayerUtil.alert('마켓포인트은 최대'+commaNumber(svmnMaxUseTot)+'원 까지 사용 가능합니다.').done(function(){
                            $('#mileageAmt').focus();
                        });
                        rtn = false;
                        return false;
                    }
                } else if (svmnMaxUseGbCd == '2') {
                    if(Number(svmnMaxUseAmt) < Number(mileageTotalAmt)) {
                        Dmall.LayerUtil.alert('마켓포인트은 최대'+commaNumber(svmnMaxUseAmt)+'원 까지 사용 가능합니다.').done(function(){
                            $('#mileageAmt').focus();
                        });
                        rtn = false;
                        return false;
                    }
                }

                //마켓포인트 사용 최대 제한 (상품별)
                var idx = 0;
                var maxUseAmt = 0;
                var goodsOrdTotAmt = 0;
                $('[name=goodsOrdAmt]').each(function(){

                	var goodsOrdAmt = $(this).val();
                	goodsOrdTotAmt += Number(goodsOrdAmt);
                	var policyCd = $("input[name=goodsSvmnMaxUsePolicyCd]:eq(" + idx + ")").val() ;

                	if (policyCd == "02") {
                    	var ctgSvmnMaxUseRate = $("input[name=ctgSvmnMaxUseRate]:eq(" + idx + ")").val() ;
                    	maxUseAmt += Number(goodsOrdAmt*ctgSvmnMaxUseRate/100);
                	} else if (policyCd == "03") {
                    	var sellerSvmnMaxUseRate = $("input[name=sellerSvmnMaxUseRate]:eq(" + idx + ")").val() ;
                    	maxUseAmt += Number(goodsOrdAmt*sellerSvmnMaxUseRate/100);
                	} else if (policyCd == "04") {
                    	var goodsSvmnMaxUseRate = $("input[name=goodsSvmnMaxUseRate]:eq(" + idx + ")").val() ;
                    	maxUseAmt += Number(goodsOrdAmt*goodsSvmnMaxUseRate/100);
                	}

                	idx ++;
                });

                // 상품별 최대 제한금액 합계 체크
            	if (Number(mileageTotalAmt) > maxUseAmt) {
                    Dmall.LayerUtil.alert('마켓포인트은 최대'+commaNumber(maxUseAmt)+'원 까지 사용 가능합니다.').done(function(){
                    });
                    rtn = false;
                    return false;
            	}

            	/////////////////////////////////////////
            	// 마켓포인트 사용금액 상세분배
                /////////////////////////////////////////
           	    var conditionAmt = 0;     // 마켓포인트 사용금액 분배시 최대제한금액 초과분이 있을경우
        	    var tmpAmt = 0;   		  // (임시)마켓포인트 계산시 초과금액 계산
        	    var tmpOrdTotAmt = 0;  	  // (임시)주문금액합계 (적용 대상 제외분)
        	    var exOrdAmt = 0;         // 주문금액합계 (적용 대상 제외분)

                do {
                	var tmpMaileageUseAmt = 0;   // 마켓포인트 분배금액 합계
            	    var kdx = 0;                 // 나머지 분배금액 처리 (마지막 row에 할당)
            	    var jdx = 0;
            	    exOrdAmt = tmpOrdTotAmt;     // 주문금액합계 (적용 대상 제외분)에 할당
            	    tmpOrdTotAmt = 0;            // (임시)초기화

                    $('[name=goodsOrdAmt]').each(function(){

                    	// 제한금액이 초과되었을경우 체크
                    	var maxYn = $("input[name=goodsDmoneyUseMaxYn]:eq(" + jdx + ")").val();

                    	// 최대제한 초과시에는 대상에서 제외처리
                    	if (maxYn != "Y") {
	                    	var goodsOrdAmt = $(this).val();

	                    	// 초과분이 있을경우 (LOOP 수행후 초과분이 있을경우)
	                    	if (conditionAmt > 0) {
		                    	var eachMileageAmt = Math.floor(conditionAmt * goodsOrdAmt / exOrdAmt);
// 								console.info(jdx + "초과eachMileageAmt=========" + eachMileageAmt);
// 								console.info(jdx + "초과conditionAmt=========" + conditionAmt);
// 								console.info(jdx + "초과goodsOrdAmt=========" + goodsOrdAmt);
// 								console.info(jdx + "초과exOrdAmt=========" + exOrdAmt);
	                    	} else {
	                    		// 초과분이 없을경우 (사용마일리지 * 상품주문금액 /전체주문금액) ※ 주문금액비율로 분배
		                    	var eachMileageAmt = Math.floor(mileageTotalAmt * goodsOrdAmt / goodsOrdTotAmt);
	                    	}

	                    	// 상품별 최대 사용 제한 금액
	                    	var policyCd = $("input[name=goodsSvmnMaxUsePolicyCd]:eq(" + jdx + ")").val() ;
	                    	if (policyCd == "02") {   // 카테고리 최대 제한설정
	                        	var ctgSvmnMaxUseRate = $("input[name=ctgSvmnMaxUseRate]:eq(" + jdx + ")").val() ;
	                        	maxUseAmt = Math.floor(Number(goodsOrdAmt*ctgSvmnMaxUseRate/100));
	                    	} else if (policyCd == "03") {  // 판매자 최대 제한설정
	                        	var sellerSvmnMaxUseRate = $("input[name=sellerSvmnMaxUseRate]:eq(" + jdx + ")").val() ;
	                        	maxUseAmt = Math.floor(Number(goodsOrdAmt*sellerSvmnMaxUseRate/100));
	                    	} else if (policyCd == "04") {  // 상품 최대 제한설정
	                        	var goodsSvmnMaxUseRate = $("input[name=goodsSvmnMaxUseRate]:eq(" + jdx + ")").val() ;
	                        	maxUseAmt = Math.floor(Number(goodsOrdAmt*goodsSvmnMaxUseRate/100));
	                    	}

// 							console.info(jdx + "maxUseAmt=========" + maxUseAmt);
// 							console.info(jdx + "eachMileageAmt=========" + eachMileageAmt);

							// 기존 할당된 분배금액 조회
                    		var tmpGoodsDmoneyUseAmt = Number($("input[name=goodsDmoneyUseAmt]:eq(" + jdx + ")").val());
	                    	// 상품별 부담금액
	                    	var goodsDmoneyUseAmt = 0;

	                    	// 주문금액별 분배금이 최대제한 설정금액을 초과하는지 체크
	                    	// 1) 초과하면,최대금액만큼만 할당
	                    	//    -- 최대금액 초과분만큼 재할당처리
	                    	//    -- 최대금액할당시는 초과분 LOOP시 제외처리를 위해서 'Y'
	                    	// 2) 초과하지 않으면, 주문금액별 분배금이 할당
	                    	//    -- 최대금액에 도달하지 않은 대상금액만 합계
	                    	if ((eachMileageAmt + tmpGoodsDmoneyUseAmt) >  maxUseAmt) {
	                    		goodsDmoneyUseAmt = maxUseAmt;
	                    		tmpAmt += Math.floor(eachMileageAmt - maxUseAmt);
	                        	$("input[name=goodsDmoneyUseMaxYn]:eq(" + jdx + ")").val("Y");
	                    	} else {
	                    		goodsDmoneyUseAmt = Number(eachMileageAmt + tmpGoodsDmoneyUseAmt);
		                    	tmpOrdTotAmt += Number(goodsOrdAmt);  // 제외분합계
	                    	}

// 							console.info(jdx + "goodsDmoneyUseAmt=========" + goodsDmoneyUseAmt);
// 							console.info(jdx + "tmpAmt=========" + tmpAmt);

	                    	// 마켓포인트 분배금액 할당
			               	$("input[name=goodsDmoneyUseAmt]:eq(" + jdx + ")").val(goodsDmoneyUseAmt);
			               	kdx++;
                    	}

                    	// d-머니 배분금액 합계 (실제 할당된 마켓포인트 상세할당 금액 합계)
                    	tmpMaileageUseAmt += Number($("input[name=goodsDmoneyUseAmt]:eq(" + jdx + ")").val());
                    	jdx ++;
                    });

					// 마켓포인트 사용금액과 실제 할당된 마켓포인트를 비교해서 끝전이 남았을경우
					// 마지막 레코드에 끝전을  할당한다.
                    var modAmt = Number(mileageTotalAmt - tmpMaileageUseAmt);
	               	if (modAmt < 10) {
		               	var tmpGoodsDmoneyUseAmt = Number($("input[name=goodsDmoneyUseAmt]:eq(" + kdx + ")").val());
		               	$("input[name=goodsDmoneyUseAmt]:eq(" + kdx + ")").val(Number(tmpGoodsDmoneyUseAmt + modAmt));
		               	tmpAmt = 0;
		        	}

                    conditionAmt = tmpAmt;   // 최대설정금액 초과분에 대해서 할당
                    tmpAmt = 0;              // (임시) 초기화
                }
                while (conditionAmt > 0);


            	return rtn;
            }


            /* 결제하기 */
            function go_pay(){
                var paymentAmt = $('#paymentAmt').val();
                var memberNo = '${user.session.memberNo}';

                var flag = true;
                var clalityYn ="N"; //G1907101559_5479
                var teanseanYn ="N"; //G2002141031_7301
                //시험착용렌즈 체크
                $('[name=goodsNo]').each(function(){
                    if($(this).val() =='G1907101559_5479'){
                        clalityYn = "Y";
                    }
                    if($(this).val() =='G2002141031_7301'){
                        teanseanYn = "Y";
                    }
                });

                if(teanseanYn=='Y' ){
                     errorMsg = '방문예약 전용 상품은 주문 하실 수 없습니다.';
                     flag = false;
                }
                if(clalityYn =='Y' ){
                    errorMsg = '방문예약 전용 상품은 주문 하실 수 없습니다.';
                     flag = false;
                }

                //특가상품 확인
                var spcPrdCnt = 0;
                var totalOrdPrice = 0;
                $('.end_line').each(function(idx) {
                     totalOrdPrice += jQuery(this).data('ord-price'); // 개별 주문 가격
                     if(jQuery(this).data('spc-yn')=='Y'){
                        spcPrdCnt++;
                     }
                });

                if(spcPrdCnt>0){
                    if(spcPrdCnt > 1) {
                        errorMsg = '프로모션 특가 할인 적용 상품은 하나만 구매 하실 수 있습니다.';
                        flag = false;
                    }else {
                        if (totalOrdPrice < 10000) {
                            errorMsg = '프로모션 특가 할인 적용 상품이 포합되어 있습니다. <br> 10,000원 이상 구매시 주문하실 수 있습니다.';
                            flag = false;
                        }
                    }
                }

                if(!flag) {
                    Dmall.LayerUtil.alert(errorMsg);
                    return false;
                }

                if(memberNo == '') {
                    //비회원 주문동의
                    if(!$('#agree_check01').is(':checked')){
                        Dmall.LayerUtil.alert('쇼핑몰 이용약관에 동의해 주세요.').done(function(){
                            $('#agree_check01').focus();
                        });
                        return false;
                    }
                    if(!$('#agree_check02').is(':checked')){
                        Dmall.LayerUtil.alert('비회원 구매 및 결제 개인정보 취급방침에 동의해 주세요.').done(function(){
                            $('#agree_check02').focus();
                        });
                        return false;
                    }
                    /* if(!$('#nonmember_agree03').is(':checked')){ //선택? 07
                        Dmall.LayerUtil.alert('개인정보 제3자 제공 동의를 체크해 주세요.').done(function(){
                            $('#nonmember_agree03').focus();
                        });
                        return false;
                    }
                    if(!$('#nonmember_agree04').is(':checked')){ //선택? 08
                        Dmall.LayerUtil.alert('개인정보 취급 위탁 동의를 체크해 주세요.').done(function(){
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
//                     var svmnMaxUseAmt = '${site_info.svmnMaxUseAmt}';
//                     if(Number(svmnMaxUseAmt) < Number(mileageTotalAmt)) {
//                         Dmall.LayerUtil.alert('마켓포인트은 최대'+commaNumber(svmnMaxUseAmt)+'원 까지 사용 가능합니다.').done(function(){
//                             $('#mileageAmt').focus();
//                         });
//                         return false;
//                     }

                    //마켓포인트 사용 최대 금액
// 					var rtn = svmnMaxUseLimit();
//                     if (!rtn) {
//                         return false;
//                     }

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
                
                // 추천인 확인
                var recomMemberId = $('#recomMemberId').val();
                if (recomMemberId != null && recomMemberId != '') {
                	
                    var recomMemberNo = $('#recomMemberNo').val();
                	if (recomMemberNo == null || recomMemberNo == '' || recomMemberNo == undefined) {
                        Dmall.LayerUtil.alert('추천인 아이디 확인 버튼을 클릭해주세요.');
                        return false;
                	}
                	
                	if (recomMemberNo == memberNo) {
                        Dmall.LayerUtil.alert('본인 아이디를 추천인으로 사용할수 없습니다.');
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
                    Dmall.LayerUtil.alert('주문자명을 입력해 주세요.').done(function(){
                        $('#ordrNm').focus();
                    });
                    return false;
                }

                //주문자이메일
                if($.trim($('#email01').val()) == '' || $.trim($('#email02').val()) == '') {
                    Dmall.LayerUtil.alert('이메일을 입력해 주세요.').done(function(){
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
                    Dmall.LayerUtil.alert('휴대전화번호를 입력해 주세요.').done(function(){
                        $('#ordrMobile01').focus();
                    });
                    return false;
                } else {
                    $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                    var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                    if(!regExp.test($('#ordrMobile').val())) {
                        Dmall.LayerUtil.alert('유효하지 않은 휴대전화번호 입니다.<br>휴대전화번호를 정확히 입력해 주세요.').done(function(){
                            $('#ordrMobile01').focus();
                        });
                        return false;
                    }
                }
                //주문자 주소정보
                $('[name=ordrAddr]').val($('#basicPostNo').val() + " " + $('#basicRoadnmAddr').val() + " " + $('#basicDtlAddr').val());

                //매장픽업일경우 수령인 정보 없고 주문자 정보만 세팅..
                var orderFormType = $("#orderFormType").val();
                if(orderFormType=='01') {
                    //수령인
                    if ($.trim($('#adrsNm').val()) == '') {
                        Dmall.LayerUtil.alert('받는 사람을 입력해 주세요.').done(function () {
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
                            Dmall.LayerUtil.alert('배송지를 선택해 주세요.').done(function(){
                                $('[name=shipping_address]').focus();
                            });
                            return false;
                        }
                        /*
                        if($('#new_shipping_address01').is(':checked')) {
                            if(trim($('#new_shipping_address01').val()) == '') {
                                Dmall.LayerUtil.alert('배송지명을 입력해 주세요.').done(function(){
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

                    //수령인 휴대전화
                    if($('#adrsMobile01').val() == '' || $.trim($('#adrsMobile02').val()) == '' || $.trim($('#adrsMobile03').val()) == '') {
                        Dmall.LayerUtil.alert('휴대전화번호를 입력해 주세요.').done(function(){
                            $('#adrsMobile01').focus();
                        });
                        return false;
                    } else {
                        $('#adrsMobile').val($('#adrsMobile01').val()+'-'+$.trim($('#adrsMobile02').val())+'-'+$.trim($('#adrsMobile03').val()));
                        var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                        if(!regExp.test($('#adrsMobile').val())) {
                            Dmall.LayerUtil.alert('유효하지 않은 휴대전화번호 입니다.<br>휴대전화번호를 정확히 입력해 주세요.').done(function(){
                                $('#adrsMobile01').focus();
                            });
                            return false;
                        }
                    }

                    //수령자 주소정보
                    //국내배송지
                    if($.trim($('#postNo').val()) == '' || ($.trim($('#numAddr').val()) == '' && $.trim($('#roadnmAddr').val()) == '')) {
                        Dmall.LayerUtil.alert('배송지 주소를 입력해 주세요.').done(function(){
                            $('#postNo').focus();
                        });
                        return false;
                    }
                    //국내배송지 상세
                    if($.trim($('#dtlAddr').val()) == '' ) {
                        Dmall.LayerUtil.alert('상세주소를 입력해 주세요.').done(function(){
                            $('#dtlAddr').focus();
                        });
                        return false;
                    }
                    $('[name=adrsAddr]').val( $('#postNo').val() + " " + (($('#roadnmAddr').val() == "")? $('#numAddr').val() :  $('#roadnmAddr').val())+ " " + $('#dtlAddr').val()  );

                }else{

                    //매장
                    if($('input[name=storeNm]').val() == '') {
                        Dmall.LayerUtil.alert("방문매장을 선택해 주세요.", "확인");
                        return false;
                    }
                    //날짜
                    if($('input[name=rsvDate]').val() == '') {
                        Dmall.LayerUtil.alert("방문 예약날짜를 선택해 주세요.", "확인");
                        return false;
                    }
                    //시간
                    if($('input[name=rsvTime]').val() == '') {
                        Dmall.LayerUtil.alert("방문 예약시간을 선택해 주세요.", "확인");
                        return false;
                    }

                    // 매장픽업일 경우 주문자 정보와 매장 정보를 수령인 정보로 세팅한다..
                    $('#adrsNm_02').val($('#ordrNm').val());
                    $('#dlvrMsg_02').val('매장픽업상품입니다');
                    $('#adrsAddr_02').val($("#numAddr_02").val());
                    $('#dtlAddr_02').val($("#storeNm").val());
                    $('#adrsTel_02').val($('#ordrTel').val());
                    $('#adrsMobile_02').val( $('#ordrMobile').val());

                }
                //결제수단
                if(Number(paymentAmt) > 0) {
                    if($('input[name=paymentWayCd]:checked').length == 0 ) {
                        Dmall.LayerUtil.alert('결제수단을 선택해 주세요.').done(function(){
                            $('#dtlAddr').focus();
                        });
                        return false;
                    }
                }

                // 입금은행
                if($('input[name=paymentWayCd]:checked').val() == '11') {
                    if($('[name=bankCd]').val() == '') {
                        Dmall.LayerUtil.alert('입금은행을 선택해 주세요.').done(function(){
                            $('[name=bankCd]').focus();
                        });
                        return false;
                    }
                }

                //주문동의
                if(!$('#order_agree01').is(':checked')) {
                    Dmall.LayerUtil.alert('주문자동의를 체크해 주세요.').done(function(){
                        $('#order_agree01').focus();
                    });
                    return false;
                }

                if(Number(mileageTotalAmt) > 0) {
                    //마켓포인트 사용 최대 금액
					var rtn = svmnMaxUseLimit(); 
                    var idx = 0;
                    if (!rtn) {
                        $('[name=goodsOrdAmt]').each(function(){
    		               	$("input[name=goodsDmoneyUseAmt]:eq(" + idx + ")").val('0');
                       	});                    	
                        return false;
                    }
				}					                
                
                var paymentPgCd = $('#paymentPgCd').val();
                var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                var pgCd = $('input[name=paymentWayCd]:checked').attr("pgCd");
                var payMethod="";
                var acceptmethod="";
                var onlykakaopay="";
                var escrowYn = $('input[name=escrowYn]:checked').val(); // 에스크로 사용여부
                var cashRctYn = $('input[name=cashRctYn]:checked').val(); // 현금영수증 발급여부

                //무통장 입금이 아니고 결제금액이 0보다 클경우
                if(paymentWayCd != '11' && Number(paymentAmt) > 0) {
                    if(paymentPgCd == '01'){ // KCP

                    } else if(paymentPgCd == '02'){ //INICIS
                        if(paymentWayCd == '21') { //계좌이체
                            payMethod = 'DirectBank';
                            //에스크로 사용여부
                            if(escrowYn=='Y'){acceptmethod+=":useescrow";}
                            //현금영수증 발급여부
                            if(cashRctYn!='Y') {acceptmethod += ":no_receipt";}
                        } else if(paymentWayCd == '22') { //가상계좌
                            payMethod = 'Vbank';
                            acceptmethod="vbank(${date})"; //입금 기한 일자
                            //에스크로 사용여부
                            if(escrowYn=='Y'){acceptmethod+=":useescrow";}
                            //현금영수증 발급여부
                            //현금영수증 발급 UI 표시 옵션 -주민번호만 표시
                            if(cashRctYn=='Y') { acceptmethod += ":va_receipt";}

                        } else if(paymentWayCd == '23') { //신용카드
                            payMethod = 'Card';
                            acceptmethod="cardpoint:below1000";
                            //에스크로 사용여부
                            if(escrowYn=='Y'){acceptmethod+=":useescrow";}
                        } else if(paymentWayCd == '24') { //휴대전화결제
                            payMethod = 'HPP';
                        } else if(paymentWayCd == '31') {
                            if(pgCd=="41"){ //payco
                                payMethod = 'onlypayco';
                                acceptmethod="cardonly";
                            }else if(pgCd=="43"){//카카오페이
                                //payMethod = 'onlykakaopay';
                                //acceptmethod="cardonly";
                                onlykakaopay = 'Y';
                                payMethod = 'Card';

                            }else if(pgCd=="44"){ //삼성페이
                                payMethod = 'onlyssp';
                                acceptmethod="cardonly";
                            }else if(pgCd=="45"){ //lpay
                                payMethod = 'onlylpay';
                                acceptmethod="cardonly";
                            }else if(pgCd=="46"){ //ssg pay
                                payMethod = 'onlyssgcard';
                                acceptmethod="cardonly";
                            }
                        }

                        $('[name=onlykakaopay]').val(onlykakaopay);
                        $('[name=gopaymethod]').val(payMethod);
                        if(acceptmethod!="") {
                            $('[name=acceptmethod]').val(acceptmethod);
                        }

                        $('[name=goodname]').val($('#ordGoodsInfo').val());
                        $('[name=buyername]').val($('#ordrNm').val());
                        $('[name=buyertel]').val($('#ordrMobile').val());
                        $('[name=buyeremail]').val($('#ordrEmail').val());
                        $('[name=price]').val($('#paymentAmt').val());
                        $('[name=oid]').val("${ordNo}");

                        var certUrl = '/front/order/inicis-signature-info';
                        var certparam = jQuery('#frmAGS_pay').serialize();


                        Dmall.AjaxUtil.getPayCert(certUrl, certparam, function(certResult) {
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

                                INIStdPay.$stdPopupInterval = setInterval(function(){
                                if(typeof(INIStdPay.$stdPopup)=='undefined' || INIStdPay.$stdPopup.closed) {
                                        clearInterval(INIStdPay.$stdPopupInterval);
                                        INIStdPay.popupClose();
                                        Dmall.waiting.payStop();
                                    }
                                }, 2000);

                                return false;
                            } else {
                                Dmall.LayerUtil.alert("결제모듈 호출에 실패하였습니다.", "알림");
                                return false;
                            }
                        });

                    } else if(paymentPgCd == '03'){ //LGU+

                    } else if(paymentPgCd == '04'){ //allthegate

                    } else if(paymentPgCd == '81') { // PAYPAL
                        PalUtil.openPaypal();
                        return false;
                    } else if(paymentPgCd == '82') { // AliPay
                        AlipayUtil.openAlipay();
                        return false;
                    } else if(paymentPgCd == '83') { // TenPay
                        TenpayUtil.openTenpay();
                        return false;
                    } else if(paymentPgCd == '84') { // 위챗페이
                        /*TenpayUtil.openTenpay();*/
                        alert('wechat');
                        return false;
                    } else if(paymentPgCd == '42') { // NPAY
                        alert('npay');
                        return false;
                    }
                    /*else if(paymentPgCd == '41') { // PAYCO
                        PaycoUtil.callPaycoUrl();
                        return false;
                    }*/
                } else {
                    if(paymentWayCd == '11') {
                        if($('[name=bankCd]').val() == '') {
                            Dmall.LayerUtil.alert('입금은행을 선택해 주세요.').done(function(){
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
                    Dmall.waiting.start();

                    $('#frmAGS_pay').attr('action','/front/order/order-insert');
                    $('#frmAGS_pay').submit();
                }

            }
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
                //$('#order_agree').prop('checked',false);
                $('#order_agree01').prop('checked',false);
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

            /* 가맹점포인트 계산 */
            function jsCalcPointAmt() {
                var point = Number($('#point').val()); //보유 가맹점 포인트
                var usePointAmt = Number($('#pointAmt').val().replace(',','')); //사용 가맹점 포인트
                var paymentAmt = Number($('#paymentAmt').val()); //결제금액
                $('#pointTotalAmt').val(usePointAmt);
                $('#pointAmt').val(commaNumber(usePointAmt));
                $('#totalPointAmt').html('(-) ' + commaNumber(usePointAmt) +' 원');
                if(usePointAmt > point) {
                    Dmall.LayerUtil.alert('사용가능 가맹점 포인트를 초과 하였습니다.').done(function(){
                        $('#pointAmt').val(0);
                        $('#pointTotalAmt').val(0);
                        $('#totalPointAmt').html('(-) ' + 0 +' 원');
                        jsCalcTotalAmt();
                        return false;
                    });
                }
                if(usePointAmt > paymentAmt) {
                    Dmall.LayerUtil.alert('사용 가맹점 포인트가 결제금액보다 많습니다.').done(function(){
                        $('#pointAmt').val(0);
                        $('#pointTotalAmt').val(0);
                        $('#totalPointAmt').html('(-) ' + 0 +' 원');
                        jsCalcTotalAmt();
                        return false;
                    });
                }
                jsCalcTotalAmt();
            }

            /* 가맹점 포인트 전액 사용 */
            function jsUseAllPointAmt() {
                var point = Number($('#point').val()); //보유마켓포인트
                var paymentAmt = Number($('#paymentAmt').val()); //결제금액
                if(paymentAmt > point) {
                    $('#pointTotalAmt').val(point);
                    $('#pointAmt').val(commaNumber(point));
                    $('#totalPointAmt').html('(-) ' + commaNumber(point) +' 원');
                } else {
                    $('#pointTotalAmt').val(paymentAmt);
                    $('#pointAmt').val(commaNumber(paymentAmt));
                    $('#totalPointAmt').html('(-) ' + commaNumber(paymentAmt) +' 원');
                }
                jsCalcTotalAmt();
            }

            /* 결제금액 계산 */
            function jsCalcTotalAmt() {
                var orderTotalAmt = Number($('#orderTotalAmt').val()); //총주문금액
                var dcTotalAmt = Number($('#dcAmt').val()); //총할인금액
                var mileageTotalAmt = Number($('#mileageTotalAmt').val()); //마켓포인트
                var pointTotalAmt = Number($('#pointTotalAmt').val()); //마켓포인트
                var dlvrTotalAmt = Number($('#dlvrTotalAmt').val()); //배송비
                var addDlvrAmt = Number($('#addDlvrAmt').val()); //추가배송비

                var paymentAmt = (orderTotalAmt+dlvrTotalAmt+addDlvrAmt-dcTotalAmt-mileageTotalAmt-pointTotalAmt);



                $('#paymentAmt').val(paymentAmt);
                $('#totalPaymentAmt').html(commaNumber(paymentAmt));
            }

            function autoApplyCoupon(obj){
                $('#cpUseAmt').val(commaNumber(obj.dcTotalAmt));
                $('#couponTotalDcAmt').val(obj.dcTotalAmt);
                var paymentAmt = Number($('#paymentAmt').val()); //결제금액
                var couponTotalDcAmt = $('#couponTotalDcAmt').val();
                var promotionTotalDcAmt = $('#promotionTotalDcAmt').val();
                var memberGradeTotalDcAmt = $('#memberGradeTotalDcAmt').val();
                var dcTotalAmt = Number(couponTotalDcAmt)+Number(promotionTotalDcAmt)+Number(memberGradeTotalDcAmt);

                if(couponTotalDcAmt > paymentAmt) {
                    Dmall.LayerUtil.alert('할인 금액이 결제금액보다 많습니다.');
                    $('#cpUseAmt').val(0);
                    $('#couponTotalDcAmt').val(0);
                    $('#dcAmt').val(0);
                    $('#totalDcAmt').html('(-) ' + 0 +' 원');
                    jsCalcTotalAmt();
                    return false;
                }

                $('#dcAmt').val(dcTotalAmt);
                $('#totalDcAmt').html('(-) '+ commaNumber(dcTotalAmt) +' 원');
                //쿠폰사용정보 생성
                var couponUseInfo = '';
                if(obj.applyCouponData != null && obj.applyCouponData.length > 0) {
                    for(var i=0; i<obj.applyCouponData.length; i++) {
                        if(couponUseInfo != '') {
                            couponUseInfo += '▦';
                        }
                        couponUseInfo += obj.applyCouponData[i].itemNo+'^'+obj.applyCouponData[i].memberCpNo+'^'+obj.applyCouponData[i].couponNo+'^'+obj.applyCouponData[i].couponDcAmt;
                        //쿠폰 선택 후 상품별 할인금액 셋팅
                        var itemLength = $('[name=itemNo]').length;
                        for(var k=0; k<itemLength; k++) {
                            if($('[name=itemNo]').eq(k).val() == obj.applyCouponData[i].itemNo) {
                                var dcPrice = $('[name=basicDcPrice]').eq(k).val(); //기획전+등급할인 금액
                                //총상품 할인금액 셋팅(기획전+등급+쿠폰)
                                $('[name=goodsDcPriceInfo]').eq(k).val(Number(dcPrice)+Number(obj.applyCouponData[i].couponDcAmt));
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
                } else if(type == 'hpp') { //휴대전화
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
                if($('#rule01_agree').is(':checked') == true) {
                    $('#shipping_address').prop('checked',true);
                    $('#shipping_address').trigger('click');

                    $('#adrsNm').val($('#ordrNm').val());
                    $('#adrsTel01').val($('#ordrTel01').val());
                    $('#adrsTel02').val($('#ordrTel02').val());
                    $('#adrsTel03').val($('#ordrTel03').val());
                    $('#adrsMobile01').val($('#ordrMobile01').val());
                    $('#adrsMobile02').val($('#ordrMobile02').val());
                    $('#adrsMobile03').val($('#ordrMobile03').val());
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
                $('#adrsNm').val('');
                $('#adrsMobile02').val('');
                $('#adrsMobile03').val('');
                $('#adrsTel02').val('');
                $('#adrsTel03').val('');

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
                    param = $('#frmAGS_pay').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            //모두 방문 수령인 경우에 지역할인 배송비는 추가되지 않는다.
                            $('input[name="areaDlvrArr"]').each(function(){
                                if($(this).val() != '04') {
                                    flag = true;
                                }
                            });
                            if(flag) {
                                var addDlvrPrice =0;
                                var addDlvrPriceString="";
                                var areaDlvrSetNo ="";
                                var idx =0;
                                for(var i=0; i<result.resultList.length;i++) {
                                    if(result.resultList[i].postNo == postNo) {
                                        flag = true;
                                        if(idx>0){
                                            addDlvrPriceString +=",";
                                        }
                                        addDlvrPriceString+=result.resultList[i].sellerNo+":"+result.resultList[i].dlvrc+":"+result.resultList[i].areaDlvrSetNo;

                                        addDlvrPrice += parseInt(result.resultList[i].dlvrc);
                                        if(idx>0){
                                            areaDlvrSetNo +=",";
                                        }
                                        areaDlvrSetNo += result.resultList[i].sellerNo+":"+result.resultList[i].areaDlvrSetNo;
                                        idx++;
                                    }
                                }
                                   $('#addDlvrAmt').val(addDlvrPrice);
                                    $('#addDlvrAmtString').val(addDlvrPriceString);
                                    $('#areaDlvrSetNo').val(areaDlvrSetNo);
                                    $('#totalAddDlvrAmt').html('(+) '+commaNumber(parseInt(addDlvrPrice))+' 원');
                                    jsCalcTotalAmt();
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

            function getDates(startDate, endDate) {
                var dates = [],
                    currentDate = startDate,
                    addDays = function(days) {
                        var date = new Date(this.valueOf());
                        date.setDate(date.getDate() + days);
                        return date.format('yyyy-MM-dd');
                    };
                while (currentDate <= endDate) {
//                 	var weekDays = new Date(currentDate).getDay()
//                 	if (weekDays != '0' && weekDays != '6') {
//                         dates.push(currentDate);
//                 	}
                    dates.push(currentDate);
                    currentDate = addDays.call(currentDate, 1);
                }
                return dates;
            };

            function dayOfWeek(strDate) {
                var week = ['(일)', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)'];
                var dayOfWeek = week[new Date(strDate).getDay()];
                return dayOfWeek;
            }
            
            // 배송예정일 기간중 휴일 일수 찾기
            function getAddHolidayDays(startDate, adays) {
				var rtnDays = 0;
            	
// 				startDate.setDate(startDate.getDate() + 4);
// 				console.log(startDate);
				
				var toDate = new Date();
				toDate.setDate(startDate.getDate() + adays);
				var endDate =  toDate.format('yyyy-MM-dd');
                var currentDate = startDate.format('yyyy-MM-dd');
                var startDate = startDate.format('yyyy-MM-dd');
                
                var addDays = function(days) {
                    var date = new Date(this.valueOf());
                    date.setDate(date.getDate() + days);
                    return date.format('yyyy-MM-dd');
                };
                    
                while (currentDate <= endDate) {
                 	var weekDays = new Date(currentDate).getDay();
                 	if (weekDays == '0' || weekDays == '6') {
						rtnDays ++;	
                 	} 
                    currentDate = addDays.call(currentDate, 1);
                }
                
             	var startdays = new Date(startDate).getDay();
             	if (startdays == '0' || startdays == '6') {
             		rtnDays = rtnDays - 1;	
             	} 
                
             	var enddays = new Date(endDate).getDay();
             	if (enddays == '6') {
             		rtnDays = rtnDays + 1;	
             	}
                
                return rtnDays;
            };			
            
            
            // 최소 배송일 구하기
            function getDlvrExpectDays(strDate) {
            	var rtnDays = 0;
            	
            	//최소 배송일 구하기
            	var tmpDays = 100; 
            	$('[name=dlvrExpectDays]').each(function(){
                	var days = Number($(this).val());
                	if (days <= tmpDays) {
                		tmpDays = days;	
                	}
                });
            	rtnDays = tmpDays;
            	return rtnDays;
            }

            function setVisitDate() {

                var date = new Date();
                
                // 최소 배송일 구하기 (최소)
                var addDays = getDlvrExpectDays(date.getDate());
                // 기간중 휴일구하기
                var holiDays = getAddHolidayDays(date, addDays + 1);
                
                date.setDate(date.getDate() + addDays + holiDays + 1);
                var strDate = date.format('yyyy-MM-dd');

                date.setDate(date.getDate() + 14);
                var endDate = date.format('yyyy-MM-dd');

                //기간별 날짜 조회
                var dateArr = getDates(strDate, endDate);

                $('#sel_visit_date').append('<option value="">방문예약일 선택</option>');
                $.each(dateArr, function(index, item){
                    var date = new Date(dateArr[index]);
                    var display = date.format('yyyy년MM월dd일') + ' ' + dayOfWeek(dateArr[index]);
                    //방문시간
                    $('#sel_visit_date').append('<option value="'+ dateArr[index] + '">' + display + '</option>');
                });
            }

            // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
            function searchGeoByAddrByMap3(address){
                // 주소-좌표 변환 객체를 생성합니다
                var geocoder = new daum.maps.services.Geocoder()
                    , bounds = new daum.maps.LatLngBounds()
                    , positions = []// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
                ;
                // 주소로 좌표를 검색합니다
                if (address != null) {
                    address.forEach(function(item,index,array){
                        geocoder.addressSearch(item.address, function (result, status) {
                            // 정상적으로 검색이 완료됐으면
                            if (status === daum.maps.services.Status.OK) {
                                // positions.push( {"latlng": new daum.maps.LatLng(result[0].y, result[0].x)})
                                var coords = new daum.maps.LatLng(result[0].y, result[0].x);
                                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                                // LatLngBounds 객체에 좌표를 추가합니다
                                bounds.extend(coords);

                                // 결과값으로 받은 위치를 마커로 표시합니다
                                var marker = new daum.maps.Marker({
                                    map: map3,
                                    position: coords
                                });

                                // 인포윈도우로 장소에 대한 설명을 표시합니다
                                var infowindow = new daum.maps.InfoWindow({
                                    content: '<div style="width:150px;text-align:center;padding:6px 0;">'+item.storeNm+'</div>',
                                    removable : true

                                });

                                // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
                                map3.setBounds(bounds);
                            }
                        });

                    });
                }
            }
            
            
            // 시도별 매장목록 조회
            function getSidoStoreList(sidoCode) {
                var url = '${_MOBILE_PATH}/front/visit/store-list';
                
                var param = {sidoCode : sidoCode};
                
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    var address= [];
                    // 취득결과 셋팅
                    jQuery.each(result.strList, function(idx, obj) {
                        var addr = obj.addr1||' '||obj.addr2;
                        var strCode = obj.strCode;
                        var strName = obj.strName;
                        address.push({"address":addr,"storeNo":strCode,"storeNm":strName});
                    });

                    searchSidoGeoByAddr(address);
                });	        
            }            


        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>

        <!--- 02.LAYOUT: 주문 메인 --->
        <form name="frmAGS_pay" id="frmAGS_pay" method="post">
            <div class="order_middle">
                <div class="order_head">
                    <h2 class="order_tit"><c:if test="${user.session.memberNo eq null}">비회원 </c:if>주문결제</h2>
                    <ul class="order_steps">
                        <li><span class="step01"><i></i>장바구니</span></li>
                        <li class="active"><span class="step02"><i></i>주문결제</span></li>
                        <li><span class="step03"><i></i>주문완료</span></li>
                    </ul>
                </div>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">주문 상품 목록입니다.</h1>
                    </caption>
                    <colgroup>
                            <%--<col style="width:39px">--%>
                        <col style="width:39px">
                        <col style="width:">
                        <col style="width:95px">
                        <col style="width:119px">
                        <col style="width:105px">
                        <col style="width:105px">
                        <col style="width:146px">
                    </colgroup>
                    <thead>
                    <tr>
                        <th></th>
                        <th>상품정보</th>
                        <th>수량</th>
                        <th>상품금액</th>
                        <th>할인금액</th>
                        <th>주문금액</th>
                        <th>배송비</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:set var="orderTotalAmt" value="0"/>
                    <c:set var="dlvrTotalAmt" value="0"/>
                    <c:set var="pvdSvmnTotalAmt" value="0"/>
                    <c:set var="recomPvdSvmnTotalAmt" value="0"/>
                    <c:set var="orderFormType" value="01"/>
                    <%-- logCorpAScript --%>
                    <c:set var="logGoods" value=""/>
                    <%-- // logCorpAScript --%>
                    <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">

                        <c:set var="totalAddOptionAmt" value="0"/>
                        <c:set var="addOptArr" value=""/>
                        <c:set var="calcSaleAmt" value="0"/>
                          <%-- 할인금액 계산(기획전 -> 등급할인 순서) --%>
                        <c:set var="dcPrice" value="0"/> <%-- 할인금액SUM(기획전+등급할인) --%>
                        <c:set var="prmtDcPrice" value="0"/> <%-- 기획전 할인 --%>
                        <c:set var="eachPrmtDcPrice" value="0"/> <%-- 기획전 할인(수량 곱하지 않은 값) --%>
                        <c:set var="memberGradeDcPrice" value="0"/> <%-- 등급 할인 --%>
                        <c:set var="eachMemberGradeDcPrice" value="0"/><%-- 등급 할인(수량 곱하지 않은 값) --%>
                        <c:set var="spcPriceYn" value="N"/> <%-- 특가 상품 여부 --%>
                        <c:set var="goodstotalAmt" value="0"/>

                        <!--
                        첫구매프로모션 참여여부 : ${member_info.data.firstSpcOrdYn}
                        첫구매프로모션 상품구입 여부 : ${orderGoodsList.firstSpcOrdYn}
                        프로모션 유형 코드 : ${orderGoodsList.prmtTypeCd}
                        신규회원여부 : ${member_info.data.newMemberYn}
                        기존회원 여부 : ${member_info.data.oldMemberYn}
                        -->

                        <%--추가옵션 계산--%>
                        <c:forEach var="goodsAddOptionList" items="${orderGoodsList.goodsAddOptList}" varStatus="status1">
                            <c:if test="${addOptArr ne ''}">
                                <c:set var="addOptArr" value="${addOptArr}*"/>
                            </c:if>
                            <c:set var="addOptArr" value="${addOptArr}${goodsAddOptionList.addOptNo}^${goodsAddOptionList.addOptDtlSeq}^${goodsAddOptionList.addOptBuyQtt}"/>

                            <c:choose>
                                <c:when test="${goodsAddOptionList.addOptAmtChgCd eq '1'}">
                                    <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                                    <c:set var="calcSaleAmt" value="${calcSaleAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt-(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                                    <c:set var="calcSaleAmt" value="${calcSaleAmt-(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
                                </c:otherwise>
                             </c:choose>
                        </c:forEach>

                        <%-- 할인금액 계산 --%>
                        <c:choose>
                            <c:when test="${orderGoodsList.firstSpcOrdYn eq 'N' and orderGoodsList.prmtTypeCd eq '06'and member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
                                    <c:set var="prmtDcPrice" value="${orderGoodsList.saleAmt*orderGoodsList.ordQtt-orderGoodsList.firstBuySpcPrice*orderGoodsList.ordQtt}"/>
                                    <c:set var="spcPriceYn" value="Y"/>
                            </c:when>
                            <c:otherwise>
                                <%-- 할인금액 계산(기획전)--%>
                                <c:choose>
                                    <c:when test="${orderGoodsList.dcRate == 0}">
                                        <c:set var="prmtDcPrice" value="0"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="prmtDcPrice" value="${orderGoodsList.saleAmt*(orderGoodsList.dcRate/100)/10}"/>
                                        <c:set var="eachPrmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)}"/>
                                        <c:if test="${orderGoodsList.prmtDcGbCd eq '01'}">
                                            <c:set var="prmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)*orderGoodsList.ordQtt}"/>
                                        </c:if>
                                        <c:if test="${orderGoodsList.prmtDcGbCd eq '02'}">
                                            <c:set var="prmtDcPrice" value="${orderGoodsList.dcRate}"/>
                                        </c:if>
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
                            </c:otherwise>
                        </c:choose>

                        <c:set var="dcPrice" value="${prmtDcPrice+memberGradeDcPrice}"/>
                        <c:set var="calcSaleAmt" value="${calcSaleAmt+(orderGoodsList.saleAmt*orderGoodsList.ordQtt)}"/>
                        <c:set var="goodstotalAmt" value="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)+totalAddOptionAmt}"/>

                        <tr class="end_line item_list" data-ord-price="${goodstotalAmt-dcPrice}" data-spc-yn="${spcPriceYn}"
                        data-goods-no="${orderGoodsList.goodsNo}" data-coupon-no="${orderGoodsList.couponAvlNo}" data-coupon-bnf-cd="${orderGoodsList.couponBnfCd}"
                        data-coupon-bnf-value="${orderGoodsList.couponBnfValue}" data-coupon-use-limit-amt="${orderGoodsList.couponUseLimitAmt}" data-coupon-bnf-dc-amt="${orderGoodsList.couponBnfDcAmt}"
                        data-coupon-kind-cd="${orderGoodsList.couponKindCd}" data-apply-start-dttm="${orderGoodsList.couponApplyStartDttm}" data-apply-end-dttm="${orderGoodsList.couponApplyEndDttm}"
                        data-item-no="${orderGoodsList.itemNo}" data-member-cp-no="${orderGoodsList.couponMemberCpNo}" data-coupon-solo-use-yn="${orderGoodsList.couponSoloUseYn}"
                        data-coupon-dc-amt="${orderGoodsList.couponDcAmt}" data-sale-price="${orderGoodsList.saleAmt}" data-ord-qtt="${orderGoodsList.ordQtt}"
                        >
                        <%--<tr class="end_line" data-ord-price="${goodstotalAmt-dcPrice}" data-spc-yn="${spcPriceYn}">--%>
                                <%--<td class="noline">
                                    <input type="checkbox" name="cart_check00" id="cart_check02" class="order_check">
                                    <label for="cart_check02"><span></span></label>
                                </td>--%>
                            <td class="noline">
                                <div class="cart_img">
                                    <img src="${_IMAGE_DOMAIN}${orderGoodsList.imgPath}">
                                </div>
                            </td>
                            <td class="textL">
                                <a href="javascript:goods_detail('${orderGoodsList.goodsNo}')">${orderGoodsList.goodsNm}</a>
                                <c:if test="${orderGoodsList.itemNm1 ne null}">
                                    <p class="option">${orderGoodsList.itemNm1}</p>
                                </c:if>
                                <c:if test="${orderGoodsList.itemNm2 ne null}">
                                    <p class="option">${orderGoodsList.itemNm2}</p>
                                </c:if>
                                <c:if test="${orderGoodsList.itemNm3 ne null}">
                                    <p class="option">${orderGoodsList.itemNm3}</p>
                                </c:if>
                                <c:if test="${orderGoodsList.itemNm4 ne null}">
                                    <p class="option">${orderGoodsList.itemNm4}</p>
                                </c:if>
                                <c:if test="${orderGoodsList.goodsAddOptList ne null}">
                                    <c:forEach var="goodsAddOptionList" items="${orderGoodsList.goodsAddOptList}" varStatus="status1">
                                        <p class="option_s">
                                                ${goodsAddOptionList.addOptNm}:${goodsAddOptionList.addOptValue}
                                            (<fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/>개)
                                            (
                                                    <c:choose>
                                                    <c:when test="${goodsAddOptionList.addOptAmtChgCd eq '1'}">
                                                        +
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                    </c:choose>
                                            <fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt*goodsAddOptionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                        </p>
                                        <%--<c:if test="${addOptArr ne ''}">
                                            <c:set var="addOptArr" value="${addOptArr}*"/>
                                        </c:if>
                                        <c:set var="addOptArr" value="${addOptArr}${goodsAddOptionList.addOptNo}^${goodsAddOptionList.addOptDtlSeq}^${goodsAddOptionList.addOptBuyQtt}"/>

			                            <c:choose>
			                                <c:when test="${goodsAddOptionList.addOptAmtChgCd eq '1'}">
		                                        <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
		                                        <c:set var="calcSaleAmt" value="${calcSaleAmt+(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
			                                </c:when>
			                                <c:otherwise>
		                                        <c:set var="totalAddOptionAmt" value="${totalAddOptionAmt-(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
		                                        <c:set var="calcSaleAmt" value="${calcSaleAmt-(goodsAddOptionList.addOptAmt*goodsAddOptionList.addOptBuyQtt)}"/>
			                                </c:otherwise>
			                             </c:choose>--%>
                                    </c:forEach>
                                </c:if>

								<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
                                <c:if test="${orderGoodsList.freebieGoodsList ne null and fn:length(orderGoodsList.freebieGoodsList)>0}">
                                    <p class="option_s">사은품 :
                                        <c:forEach var="freebieGoodsList" items="${orderGoodsList.freebieGoodsList}" varStatus="status3">
                                            <c:out value="${freebieGoodsList.freebieNm}"/>
                                            <c:if test="${status3.index < (fn:length(orderGoodsList.freebieGoodsList)-1)}">
                                            ,
                                            </c:if>
                                        </c:forEach>
                                    </p>
                                </c:if>
								<!-- //사은품추가 2018-09-27 -->
                            </td>
                            <td>
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
                                <fmt:formatNumber value="${orderGoodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                                <input type="hidden" name="minOrdQtt" value="${orderGoodsList.minOrdQtt}"><%-- 구매수량제한 확인용(최소)--%>
                                <input type="hidden" name="ordQttMinLimitYn" value="${ordQttMinLimitYn}"><%-- 구매수량제한 확인용(최소)--%>
                                <input type="hidden" name="maxOrdQtt" value="${orderGoodsList.maxOrdQtt}"><%-- 구매수량제한 확인용(최대)--%>
                                <input type="hidden" name="ordQttMaxLimitYn" value="${ordQttMaxLimitYn}"><%-- 구매수량제한 확인용(최대)--%>
                                <input type="hidden" name="limitItemNm" value="${orderGoodsList.goodsNm}"><%-- 구매수량제한 확인용--%>
                            </td>
                            <td>

                                <span class="price"><fmt:formatNumber value="${calcSaleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
                                <c:set var="goodsPvdSvmnAmt" value="0"/>
                                <c:set var="pvdSvmnAmt" value="0"/>
                                <c:set var="recomPvdSvmnAmt" value="0"/>
                                <c:set var="gradePvdSvmnAmt" value="0"/>
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
                                    <%-- 기본 --%>
                                    <c:when test="${orderGoodsList.goodsSvmnPolicyCd eq '01'}">
                                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                            <c:set var="pvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(orderGoodsList.svmnPvdRate/100)/svmnTruncStndrdCd}"/>
                                            <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
                                            <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                        </c:if>
                                    </c:when>
                                    <%-- 카테고리 --%>
                                    <c:when test="${orderGoodsList.goodsSvmnPolicyCd eq '02'}">
                                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                        	<c:choose>
                                        		<c:when test="${orderGoodsList.ctgSvmnGbCd eq '1'}">
                                        		    <c:set var="pvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(orderGoodsList.ctgSvmnAmt/100)/svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                        		</c:when>
                                        		<c:otherwise>
		                                            <c:set var="pvdSvmnAmt" value="${orderGoodsList.ctgSvmnAmt}"/>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </c:if>
                                    </c:when>
                                    <%-- 판매자 --%>
                                    <c:when test="${orderGoodsList.goodsSvmnPolicyCd eq '03'}">
                                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                        	<c:choose>
                                        		<c:when test="${orderGoodsList.sellerSvmnGbCd eq '1'}">
		                                            <c:set var="pvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(orderGoodsList.sellerSvmnAmt/100)/svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                        		</c:when>
                                        		<c:otherwise>
		                                            <c:set var="pvdSvmnAmt" value="${orderGoodsList.sellerSvmnAmt}"/>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </c:if>
                                    </c:when>
                                    <%-- 상품별 --%>
                                    <c:when test="${orderGoodsList.goodsSvmnPolicyCd eq '04'}">
                                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                        	<c:choose>
                                        		<c:when test="${orderGoodsList.goodsSvmnGbCd eq '1'}">
		                                            <c:set var="pvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(orderGoodsList.goodsSvmnAmt/100)/svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
		                                            <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                        		</c:when>
                                        		<c:otherwise>
		                                            <c:set var="pvdSvmnAmt" value="${orderGoodsList.goodsSvmnAmt}"/>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </c:if>
                                    </c:when>
                                </c:choose>
                                <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                    <c:set var="recomPvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(orderGoodsList.recomPvdRate/100)/svmnTruncStndrdCd}"/>
                                    <c:set var="recomPvdSvmnAmt" value="${(recomPvdSvmnAmt-(recomPvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
                                    <c:set var="recomPvdSvmnAmt" value="${recomPvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                </c:if>
                                    <%-- 적립예정금 계산(등급혜택) --%>
                                <c:if test="${user.session.memberNo ne null && user.session.integrationMemberGbCd ne '02'}">
                                    <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                        <c:set var="gradePvdSvmnAmt" value="${(orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice)*(member_info.data.svmnValue/100)/svmnTruncStndrdCd}"/>
                                        <c:set var="gradePvdSvmnAmt" value="${(gradePvdSvmnAmt-(gradePvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
                                        <c:set var="gradePvdSvmnAmt" value="${gradePvdSvmnAmt*orderGoodsList.ordQtt}"/>
                                    </c:if>
                                </c:if>
                                <c:set var="pvdSvmnAmt" value="${pvdSvmnAmt + gradePvdSvmnAmt}"/>
                                    <%-- <li><span class="cart_point"><fmt:formatNumber value="${pvdSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span></li> --%>
                            </td>
                            <td>
                                <span class="discount"><fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${orderGoodsList.rsvOnlyYn eq 'Y'}">
                                        <p class="all_price"><em>매장결제</em></p>
                                        <%--<c:set var="goodstotalAmt" value="0"/>--%>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${orderGoodsList.firstSpcOrdYn eq 'N' and orderGoodsList.prmtTypeCd eq '06' and member_info.data.firstSpcOrdYn eq 'N' and member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
                                            특가 할인 <br>
                                        </c:if>
                                        <%--<c:set var="goodstotalAmt" value="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)+totalAddOptionAmt}"/>--%>
                                        <p class="all_price"><em><fmt:formatNumber value="${goodstotalAmt-dcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</p>
                                    </c:otherwise>
                                </c:choose>

                            </td>
                                <%-- **** 배송비 계산 **** --%>
                            <c:choose>
                                <c:when test="${orderGoodsList.dlvrSetCd eq '1' && orderGoodsList.dlvrcPaymentCd eq '01'}">
                                    <c:set var="grpId" value="${orderGoodsList.sellerNo}**${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsList.dlvrSetCd eq '1' && (orderGoodsList.dlvrcPaymentCd eq '02')}"> <%-- or orderGoodsList.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${orderGoodsList.sellerNo}**${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsList.dlvrSetCd eq '4' && (orderGoodsList.dlvrcPaymentCd eq '02')}"> <%--or orderGoodsList.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${orderGoodsList.goodsNo}**${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${orderGoodsList.dlvrSetCd eq '6' && (orderGoodsList.dlvrcPaymentCd eq '02')}"><%-- or orderGoodsList.dlvrcPaymentCd eq '04'--%>
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
                                            <c:when test="${orderGoodsList.rsvOnlyYn eq 'Y'}">
                                                <td rowspan="${dlvrCountMap.get(grpId)}">
                                                	<span class="label_reservation">예약전용</span>
						                            <p class="option_s">${orderGoodsList.sellerNm}</p>
                                                </td>
                                                <c:set var="orderFormType" value="02"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${orderGoodsList.dlvrcPaymentCd eq '03'}">
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
							                                                        착불
						                                <p class="option_s">${orderGoodsList.sellerNm}</p>
						                                <input type="hidden" name="addDlvrItem" value="${orderGoodsList.itemNo}@${orderGoodsList.sellerNo}">
						                                <input type="hidden" name="fsellerNo" value="${orderGoodsList.sellerNo}">
                                                        </td>
                                                    </c:when>
                                                    <c:when test="${orderGoodsList.dlvrcPaymentCd eq '04'}">
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">
                                                            <p>무료</p>
                                                            <span class="label_shop">매장픽업</span>
							                                <p class="option_s">${orderGoodsList.sellerNm}</p>
                                                        </td>
                                                        <c:set var="orderFormType" value="02"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td rowspan="${dlvrCountMap.get(grpId)}">무료
							                                <p class="option_s">${orderGoodsList.sellerNm}</p>
							                                <input type="hidden" name="addDlvrItem" value="${orderGoodsList.itemNo}@${orderGoodsList.sellerNo}">
							                                <input type="hidden" name="fsellerNo" value="${orderGoodsList.sellerNo}">
                                                        </td>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${orderGoodsList.rsvOnlyYn eq 'Y'}">
                                                <td rowspan="${dlvrCountMap.get(grpId)}">
                                                	<span class="label_reservation">예약전용</span>
						                            <p class="option_s">${orderGoodsList.sellerNm}</p>

                                                </td>
                                                <c:set var="orderFormType" value="02"/>
                                            </c:when>
                                            <c:otherwise>
		                  						<c:choose>
				                                    <c:when test="${orderGoodsList.dlvrcPaymentCd eq '03'}">
				                                        <td rowspan="${dlvrCountMap.get(grpId)}">
															<p>(<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)</p>
															<p>착불</p>
															<p class="option_s">${orderGoodsList.sellerNm}</p>
						                                </td>
				                                    </c:when>
				                                    <c:when test="${orderGoodsList.dlvrcPaymentCd eq '04'}">
				                                        <td rowspan="${dlvrCountMap.get(grpId)}">
															 <p><fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</p>
															 <span class="label_shop">매장픽업</span>
						                                	 <p class="option_s">${orderGoodsList.sellerNm}</p>
                                                        	 <c:set var="orderFormType" value="02"/>
				                                        </td>
				                                    </c:when>
				                                    <c:otherwise>
						                            	<td rowspan="${dlvrCountMap.get(grpId)}"><fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
						                                <p class="option_s">${orderGoodsList.sellerNm}</p>
						                                <input type="hidden" name="addDlvrItem" value="${orderGoodsList.itemNo}@${orderGoodsList.sellerNo}">
						                                <input type="hidden" name="fsellerNo" value="${orderGoodsList.sellerNo}">
						                                </td>
				                                    </c:otherwise>
 												</c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>

							    <c:if test="${orderGoodsList.dlvrcPaymentCd ne '03' and orderGoodsList.rsvOnlyYn ne 'Y'}" >
                                	<c:set var="dlvrTotalAmt" value="${dlvrTotalAmt+ dlvrPriceMap.get(grpId)}"/>
                                </c:if>
                            </c:if>

                            <c:set var="preGrpId" value="${grpId}"/>

                            <c:set var="orderTotalAmt" value="${orderTotalAmt+goodstotalAmt}"/>

							<input type="hidden" name="goodsOrdAmt" value="${orderGoodsList.saleAmt*orderGoodsList.ordQtt-dcPrice}"/>
							<input type="hidden" name="goodsDmoneyUseAmt" value="0"/>
							<input type="hidden" name="goodsDmoneyUseMaxYn" value=""/>
							<input type="hidden" name="goodsSvmnMaxUsePolicyCd" value="${orderGoodsList.goodsSvmnMaxUsePolicyCd}"/>
							<input type="hidden" name="goodsSvmnMaxUseRate" value="${orderGoodsList.goodsSvmnMaxUseRate}"/>
							<input type="hidden" name="ctgSvmnMaxUseRate" value="${orderGoodsList.ctgSvmnMaxUseRate}"/>
							<input type="hidden" name="sellerSvmnMaxUseRate" value="${orderGoodsList.sellerSvmnMaxUseRate}"/>
							<input type="hidden" name="svmnMaxUseGbCd" value="${orderGoodsList.svmnMaxUseGbCd}"/>
							<input type="hidden" name="svmnMaxUseAmt" value="${orderGoodsList.svmnMaxUseAmt}"/>
							<input type="hidden" name="dlvrExpectDays" value="${orderGoodsList.dlvrExpectDays}"/>

                            <fmt:parseNumber var="pvdSvmnTotalAmt" type='number' value='${pvdSvmnTotalAmt+pvdSvmnAmt}'/>
                            <fmt:parseNumber var="recomPvdSvmnTotalAmt" type='number' value='${recomPvdSvmnTotalAmt+recomPvdSvmnAmt}'/>
                            <c:set var="goodsPvdSvmnAmt" value="${pvdSvmnAmt}"/>
                            <c:set var="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}"/>
                            <c:set var="recomPvdSvmnTotalAmt" value="${recomPvdSvmnTotalAmt}"/>
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

                            	<%-- 상품별 마켓포인트 적립금 --%>
                            <input type="hidden" name="goodsPvdSvmnAmt" value="<fmt:parseNumber type='number' value='${goodsPvdSvmnAmt}'/>">
                            	<%-- 상품별 마켓포인트 추천인 적립금 --%>
                            <input type="hidden" name="recomPvdSvmnAmt" value="<fmt:parseNumber type='number' value='${recomPvdSvmnAmt}'/>">
                            	<%-- 상품별 총 할인 정보 배열--%>
                            <input type="hidden" name="goodsDcPriceInfo" value="<fmt:parseNumber type='number' value='${dcPrice}'/>">
                                <%-- 상품 정보 배열 --%>

                            <input type="hidden" name="areaDlvrArr" value="${orderGoodsList.dlvrcPaymentCd}">
                            <input type="hidden" name="itemArr" value="${orderGoodsList.goodsNo}▦${orderGoodsList.itemNo}^${orderGoodsList.ordQtt}^${orderGoodsList.dlvrcPaymentCd}▦${addOptArr}▦${orderGoodsList.ctgNo}▦${orderGoodsList.sellerNo}">
                            <!-- 쿠폰 조회용 데이터 -->
                            <input type="hidden" class="couponInfo" data-goods-no="${orderGoodsList.goodsNo}" data-item-no="${orderGoodsList.itemNo}" data-goods-nm="${orderGoodsList.goodsNm}"
                                   data-goods-qtt="${orderGoodsList.ordQtt}"
                                   data-sale-price="<fmt:parseNumber type='number' value='${orderGoodsList.saleAmt-eachPrmtDcPrice-eachMemberGradeDcPrice}'/>"
                                   data-rsv-only-yn="${orderGoodsList.rsvOnlyYn}" data-prmt-type="${orderGoodsList.prmtTypeCd}"
                                   data-spc-yn="${spcPriceYn}"
                                   >
		                    <input type="hidden" name="goodsTypeCd" value="${orderGoodsList.goodsTypeCd}">

                        </tr>
                        <%-- logCorpAScript --%>
                        <c:set var="logGoodsVal" value="${orderGoodsList.goodsNm}_${goodstotalAmt-dcPrice}_${orderGoodsList.ordQtt}"/>
                        <c:choose>
                        <c:when test="${status.index>0}">
                            <c:set var="logGoods" value="${logGoods};${logGoodsVal}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="logGoods" value="${logGoodsVal}"/>
                        </c:otherwise>
                        </c:choose>
                        <%--// logCorpAScript --%>
                    </c:forEach>
                    <c:set var="couponTotalAmt" value="0"/>
                    <c:set var="mileageTotalAmt" value="0"/>
                    <c:set var="paymentTotalAmt" value="${orderTotalAmt+dlvrTotalAmt-promotionTotalDcAmt-memberGradeTotalDcAmt-couponTotalAmt-mileageTotalAmt}"/>
                        <%-- logCorpAScript --%>
                        <%--구매전환상품 (상품명_가격_제품수량) 여러개 경우 ';'로 구분 / 상품명에 언더바[_]가 포함되어서는 안됩니다.--%>
                        <c:set var="http_MP" value="${logGoods}" scope="request"/>
                        <%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
                    	<c:set var="http_SO" value="cartend" scope="request"/>
                    	<%--// logCorpAScript --%>
                    </tbody>
                </table>

                <c:if test="${user.session.memberNo eq null || user.session.memberNo eq ''}">
                    <div class="no_member_agree">
                        <div class="agree_top">
                            <h3 class="no_member_tit">
                                비회원 구매를 위한 약관동의
                                <p class="no_member_text">비회원으로 다비치몰 상품을 구매하시려면 아래 약관에 동의해 주세요.</p>
                            </h3>
                            <p class="no_member_all">
                                <input type="checkbox" class="order_check" id="agree_check_all">
                                <label for="agree_check_all"><span class=""></span>모두 동의합니다.</label>
                            </p>
                        </div>
                        <div class="left">
                            <div class="agree_area">
                                <div class="top">
                                    <p class="tit_agree">서비스 이용약관 <em>(필수)</em></p>
                                    <a href="#" class="btn_agree_all">전체보기</a>
                                </div>
                                <div class="agree_scroll">
                                    <pre>${term_03.data.content}</pre>
                                </div>
                                <div class="check_agree">
                                    <input type="checkbox" class="order_check" id="agree_check01">
                                    <label for="agree_check01"><span></span>동의합니다.</label>
                                </div>
                            </div>
                        </div>

                        <div class="right">
                            <div class="agree_area">
                                <div class="top">
                                    <p class="tit_agree">개인정보 수집 및 이용동의 <em>(필수)</em></p>
                                    <a href="#" class="btn_agree_all">전체보기</a>
                                </div>
                                <div class="agree_scroll">
                                        ${term_20.data.content}
                                </div>
                                <div class="check_agree">
                                    <input type="checkbox" class="order_check" id="agree_check02">
                                    <label for="agree_check02"><span></span>동의합니다.</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                    <%-- 주문서 Type 일반(01) 매장픽업(02) --%>
                <input type="hidden" name="orderFormType" id="orderFormType" value="${orderFormType}">
                <input type="hidden" name="memberGbCd" value="10">

                <div class="payment_area">
                    <div class="left">
                        <div class="tCart_outline">
                            <table class="tCart_Insert">
                                <caption>배송지 정보 입력폼입니다.</caption>
                                <colgroup>
                                    <col style="width:145px">
                                    <col style="width:">
                                </colgroup>
                                <thead>
                                <c:if test="${orderFormType eq '01'}">
                                    <tr>
                                        <th <c:if test="${user.session.memberNo eq null}"> colspan="2"</c:if>>배송지정보</th>
                                        <c:if test="${user.session.memberNo ne null}">
                                            <td>
                                                <input type="radio" class="order_radio" id="shipping_address" name="shipping_address" value="1" checked="checked">
                                                <label for="shipping_address"><span></span>기본배송지</label>
                                                <input type="radio" class="order_radio" id="recently_shipping_address" name="shipping_address" value="2">
                                                <label for="recently_shipping_address"><span></span>최근배송지</label>
                                                <input type="radio" class="order_radio" id="new_shipping_address01" name="shipping_address" value="3">
                                                <label for="new_shipping_address01"><span></span>신규배송지</label>
                                                    <%--<span id="newDelivery" style="display:none;"></span>--%>
                                                <button type="button" id="my_shipping_address" class="btn_shipping_list">배송지목록</button> &nbsp; &nbsp;
                                                 <label>
													<input type="checkbox" name="rule01_agree" id="rule01_agree" class="order_check" onclick="setAdrsInfo();">
													<label for="rule01_agree"><span></span> 주문자정보와 같음</label>
												</label>

												<!-- <label>
                                                    <input type="checkbox" name="rule01_agree" id="rule01_agree" onclick="setAdrsInfo();">
                                                    <span></span>
                                                </label>
                                                <label for="rule01_agree">주문자정보와 같음</label> -->
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
                                        </c:if>
                                    </tr>
                                </c:if>
                                <c:if test="${orderFormType eq '02'}">
                                    <tr>
                                        <th>배송지정보</th>
                                        <td>
                                        	<c:if test="${user.session.memberNo ne null}">
                                        	<p class="myshop_check" style="margin-right: 10px;">
                                                <input type="checkbox" class="order_check" id="my_shop">
                                                <label for="my_shop"><span></span>내 단골매장에서 받기</label>
                                            </p>
                                            </c:if>
                                            <span class="label_shop">매장픽업</span>
                                            <span class="order_info_text">상품수령을 원하시는 다비치 매장을 선택해 주세요.</span>
                                        </td>
                                    </tr>
                                </c:if>
                                </thead>
                                <tbody>

                                <c:if test="${orderFormType eq '01'}">
                                    <tr>
                                        <th>받는사람</th>
                                        <td><input type="text" name="adrsNm" id="adrsNm" value=""></td>
                                    </tr>
                                    <tr>
                                        <th>휴대전화</th>
                                        <td>
                                            <select name="adrsMobile01" id="adrsMobile01" class="select_tel">
                                                <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                            </select>
                                            -

                                            <input type="text" name="adrsMobile02" id="adrsMobile02" class="form_tel"maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            -
                                            <input type="text" name="adrsMobile03" id="adrsMobile03" class="form_tel"maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            <input type="hidden" name="adrsMobile" id="adrsMobile" value="">

                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label for="">연락처</label>
                                        </th>
                                        <td>
                                            <select name="adrsTel01" id="adrsTel01" class="select_tel">
                                                <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                            </select>
                                            -
                                            <input type="text" name="adrsTel02" id="adrsTel02" class="form_tel"maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            -
                                            <input type="text" name="adrsTel03" id="adrsTel03" class="form_tel"maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            <input type="hidden" name="adrsTel" id="adrsTel" value="">

                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="vaT">주소</th>
                                        <td>

                                            <input type="text" name="postNo" id="postNo" readonly>
                                            <button type="button" class="btn_form btn_post">우편번호</button>
                                            <input type="text" name="roadnmAddr" id="roadnmAddr" class="form_address" readonly><br>
                                            <input type="text" name="dtlAddr" id="dtlAddr" class="form_address" placeholder="상세주소">

                                            <input type="hidden" name="numAddr" id="numAddr">
                                            <input type="hidden" name="adrsAddr" value="">

                                        </td>
                                    </tr>
                                    <c:if test="${user.session.memberNo ne null}">
                                    <tr>
                                        <th>

                                        </th>
                                        <td>
                                            <label>
                                                <input type="checkbox" name="defaultYn" id="defaultYn" class="order_check" value="Y">
                                                <label for="defaultYn"><span></span> 기본배송지로 저장</label>
                                            </label> &nbsp; &nbsp; &nbsp;
                                            <label>
                                                <input type="checkbox" name="addDeliveryYn" id="addDeliveryYn" class="order_check" value="Y">
                                                <label for="addDeliveryYn"><span></span> 자주쓰는 배송지로 추가</label>
                                            </label>
                                        </td>
                                    </tr>
                                    </c:if>
                                    <tr>
                                        <th>배송메모</th>
                                        <td>
                                            <select id="shipping_message" class="select_memo">
                                                <option value="배송전, 연락바랍니다.">배송전, 연락바랍니다.</option>
                                                <option value="부재시, 전화주시거나 또는 문자 남겨주세요.">부재시, 전화주시거나 또는 문자 남겨주세요.</option>
                                                <option value="부재시, 경비실에 맡겨주세요.">부재시, 경비실에 맡겨주세요.</option>
                                                <option value="">기타</option>
                                            </select>
                                            <span id="dlvrText" style="display:none"><input type="text" name="dlvrMsg" id="dlvrMsg" style="width:636px" value="배송전, 연락바랍니다."></span>

                                        </td>
                                    </tr>
                                </c:if>
                                <c:if test="${orderFormType eq '02'}">
                                    <input type="hidden" name="adrsNm" id="adrsNm_02" value="">
                                    <input type="hidden" name="dlvrMsg" id="dlvrMsg_02" value="매장픽업상품입니다.">
                                    <input type="hidden" name="adrsTel" id="adrsTel_02" value="">
                                    <input type="hidden" name="adrsMobile" id="adrsMobile_02" value="">
                                    <input type="hidden" name="adrsAddr" id="adrsAddr_02" value="">
                                    <input type="hidden" name="numAddr" id="numAddr_02">
                                    <input type="hidden" name="dtlAddr" id="dtlAddr_02">
                                    <tr>
                                        <td colspan="2">
                                            <select id="sel_sidoCode" style="width:150px">
                                                <option value="">시/도</option>
                                                <c:forEach items="${codeListModel}" var="list">
                                                    <option value="${list.dtlCd}">${list.dtlNm}</option>
                                                </c:forEach>
                                            </select>
                                            <select id="sel_guGunCode" style="width:150px">
                                                <option value="">구/군</option>
                                            </select>
                                            
                                            <input type="text" id="searchStoreNm" name="searchStoreNm" onkeydown="if(event.keyCode == 13){$('#btn_search_store').click();}" style="width:150px">
                                  			<button type="button" class="btn_form" id="btn_search_store">검색</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <div id="map" style="width:100%px;height:400px;"></div>
                                            <%@ include file="map/mapApi.jsp" %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>선택매장</th>
                                        <td>
                                            <input type="hidden" name="storeNo" id="storeNo"><%--개발후 hidden 값으로 변경--%>
                                            <input type="text" name="storeNm" id="storeNm" readonly>
                                            <button type="button" class="btn_form" id="store_info">매장상세정보</button>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th>방문예정일시</th>
                                        <td>
                                            <select id="sel_visit_date">
                                            </select>
                                            <input type="hidden" id="rsvDate" name="rsvDate">
                                            <input type="hidden" id="rsvTime" name="rsvTime">
                                            <input type="text" id="sel_visitTime" name="sel_visitTime" style="width:103px;" placeholder="시간선택" readonly>
                                            <div class="visit_day_area" style="display:none">
                                                <div class="time_table_area">
                                                    <div class="tit" id="storeTitle"></div>
                                                    <ul class="time_table_list">
                                                    </ul>
                                                </div>
                                                ※ 시간대별 혼잡도를 참조하여 방문시간을 선택해 주세요.<br>
                                                ※ 예약 상품이 품절인 경우 2일 (주말, 공휴일 제외) 안에 재입고하여 구매/수령 가능합니다.
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>

                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="right">
                        <div class="tCart_outline">
                            <table class="tCart_Insert">
                                <caption>주문고객 정보 입력폼입니다.</caption>
                                <colgroup>
                                    <col style="width:100px">
                                    <col style="width:">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th colspan="2">주문고객정보</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>주문자명</th>
                                    <td>
                                        <input type="text" name="ordrNm" id="ordrNm" style="width:275px;" value="${member_info.data.memberNm}">
                                        <c:if test="${deliveryList.resultList ne null && fn:length(deliveryList.resultList) gt 0}">
                                            <c:forEach var="deliveryList" items="${deliveryList.resultList}" varStatus="status">
                                                <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                                                    <input type="hidden" name="basicMemberGbCd" id="basicMemberGbCd" value="${deliveryList.memberGbCd}">
                                                    <input type="hidden" name="basicPostNo" id="basicPostNo" value="${deliveryList.newPostNo}">
                                                    <input type="hidden" name="basicNumAddr" id="basicNumAddr" value="${deliveryList.strtnbAddr}">
                                                    <input type="hidden" name="basicRoadnmAddr" id="basicRoadnmAddr" value="${deliveryList.roadAddr}">
                                                    <input type="hidden" name="basicDtlAddr" id="basicDtlAddr" value="${deliveryList.dtlAddr}">
                                                    <input type="hidden" name="basicAdrsTel" id="basicAdrsTel" value="${su.phoneNumber(deliveryList.tel)}">
                                                    <input type="hidden" name="basicAdrsMobile" id="basicAdrsMobile" value="${su.phoneNumber(deliveryList.mobile)}">
                                                    <input type="hidden" name="basicAdrsNm" id="basicAdrsNm" value="${deliveryList.adrsNm}">
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
                                    <th>이메일</th>
                                    <td>
                                        <input type="text" name="email01" id="email01" class="form_email"> @ <input type="text" name="email02" id="email02" class="form_email">
                                        <select name="email03" id="email03" title="select option">
                                            <option value="etc" selected="selected">직접입력</option>
                                            <option value="naver.com">naver.com</option>
                                            <option value="hanmail.net">hanmail.net</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="nate.com">nate.com</option>
                                            <!-- <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option> -->
                                        </select>
                                        <input type="hidden" name="ordrEmail" id="ordrEmail" value="">
                                    </td>
                                </tr>
                                    <%-- <tr>
                                        <th>전화번호</th>
                                        <td>
                                            <select name="ordrTel01" id="ordrTel01" class="select_tel">
                                                <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                            </select>
                                            -
                                            <input type="text" name="ordrTel02" id="ordrTel02" class="form_tel" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            -
                                            <input type="text" name="ordrTel03" id="ordrTel03" class="form_tel" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                            <input type="hidden" name="ordrTel" id="ordrTel" value="">
                                        </td>
                                    </tr> --%>
                                <tr>
                                    <th>휴대전화</th>
                                    <td>
                                        <select name="ordrMobile01" id="ordrMobile01" class="select_tel">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        -
                                        <input type="text" name="ordrMobile02" id="ordrMobile02" class="form_tel" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                        -
                                        <input type="text" name="ordrMobile03" id="ordrMobile03" class="form_tel" maxlength="4" onKeydown="return onlyNumDecimalInput(event);">
                                        <input type="hidden" name="ordrMobile" id="ordrMobile" value="">
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="payment_area02">
                    <div class="left">
                        <div class="tCart_outline02">
                            <table class="tCart_Insert">
                                <caption>할인적용 입력폼입니다.</caption>
                                <colgroup>
                                    <col style="width:145px">
                                    <col style="width:">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th colspan="2">할인적용</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>할인쿠폰</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.session.memberNo eq null || user.session.integrationMemberGbCd eq '02'}">
                                                <span class="fRed">쿠폰을 사용하실 수 없습니다.</span>
                                                <input type="hidden" name="cpUseAmt" id="cpUseAmt" value="0">
                                            </c:when>
                                            <c:otherwise>
                                                <input type="text" name="cpUseAmt" id="cpUseAmt" value="0" class="form_sale" readonly><span class="text_won">원</span>
                                                <button type="button" id="btn_checkout_info" class="btn_sale">쿠폰적용</button>
                                                <span class="sale_info">사용가능 : <em id="use_coupon_cnt">0</em>장 / 전체 : <em id="total_coupon_cnt">0</em>장</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <%--<tr>
                                    <th>마켓포인트</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.session.memberNo eq null || user.session.integrationMemberGbCd eq '02'}">
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
                                                        <input type="text" name="mileageAmt" id="mileageAmt" value="0" onKeydown="return onlyNumDecimalInput(event);" onblur="jsCalcMileageAmt();" class="form_sale"><span class="text_won">원</span>
                                                        <button type="button" id="mileageAllUse" class="btn_sale" onclick="jsUseAllMileageAmt()">전액사용</button>
                                                        <span class="sale_info">사용가능 : <em><fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원

                                                    (<fmt:formatNumber value="${svmnUseUnitCd}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 단위로 사용가능)
                                                    </span>
                                                        <input type="hidden" name="mileage" id="mileage" value="<fmt:parseNumber type='number' value='${member_info.data.prcAmt}'/>">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>--%>
                                <c:if test="${user.session.integrationMemberGbCd eq '03'}">
                                    <%--<tr>
                                        <th>가맹점 포인트</th>
                                        <td>
                                            <input type="text" name="pointAmt" id="pointAmt" value="0" onKeydown="return onlyNumDecimalInput(event);" onblur="jsCalcPointAmt();" class="form_sale"><span class="text_won">원</span>
                                            <button type="button" id="pointAllUse" class="btn_sale" onclick="jsUseAllPointAmt()">전액사용</button>
                                            <span class="sale_info">사용가능 : <em><fmt:formatNumber value="${member_info.data.prcPoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>P
                                    <input type="hidden" name="point" id="point" value="<fmt:parseNumber type='number' value='${member_info.data.prcPoint}'/>">
                                        </td>
                                    </tr>--%>
                                </c:if>

                                <tr>
                                    <th>적립혜택</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.session.memberNo ne null && user.session.integrationMemberGbCd ne '02'}">
                                            	<c:choose>
                                            		<c:when test="${pvdSvmnTotalAmt >0 || recomPvdSvmnTotalAmt > 0}">
                                            			구매확정시 마켓포인트
                                            			<c:if test="${pvdSvmnTotalAmt >0 }">구매자 <span class="checkout_no" style="color:#006cfe;font-weight:600;"><fmt:formatNumber value="${pvdSvmnTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</c:if>
                                            			<c:if test="${recomPvdSvmnTotalAmt > 0 }">·&nbsp;추천인<span class="checkout_no" style="color:#006cfe;font-weight:600;"><fmt:formatNumber value="${recomPvdSvmnTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</c:if>
                                            			지급
                                            		</c:when>
                                            		<c:otherwise>
                                            			<span>적립혜택이 없습니다.</span>
                                            		</c:otherwise>
                                            	</c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="fRed">적립혜택이 없습니다.</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <c:if test="${recomPvdSvmnTotalAmt > 0 }">
	                                <tr>
	                                	<th class="vaT">추천인 아이디</th>
						            	<td>
						            		<input type="text" id="recomMemberId" style="width:232px;" data-validation-engine="validate[maxSize[20]]">
						            		<button type="button" class="btn_form" id="btnRecomChk">아이디 확인</button>
						            		<input type="hidden" id="recomMemberNo" name="recomMemberNo">
						            	</td>
	                                </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                        <div class="tCart_outline03">
                            <table class="tCart_Insert">
                                <caption>결제수단 입력폼입니다.</caption>
                                <colgroup>
                                    <col style="width:159px">
                                    <col style="width:">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>결제수단</th>
                                    <td>


                                        <c:if test="${pgPaymentConfig.data.credPaymentYn eq 'Y'}">
                                            <input type="radio" class="order_radio" id="paymentWayCd01" name="paymentWayCd" value="23">
                                            <label for="paymentWayCd01" class="radio_chack2_c">
                                                <span></span>
                                                신용카드
                                            </label>
                                        </c:if>

                                        <c:if test="${site_info.nopbpaymentUseYn eq 'Y'}">
                                            <input type="radio" class="order_radio" id="paymentWayCd02" name="paymentWayCd" value="11">
                                            <label for="paymentWayCd02" class="radio_chack2_a">
                                                <span></span>
                                                무통장입금
                                            </label>
                                        </c:if>

                                            <%--<c:if test="${site_info.npayUseYn eq 'Y'}">--%>
                                            <%--<input type="radio" class="order_radio" id="paymentWayCd03" name="paymentWayCd" value="31" pgCd="42">
                                            <label for="paymentWayCd03" class="radio_chack2_a">
                                                <span></span>
                                                NPay
                                            </label>--%>
                                            <%--</c:if>--%>

                                            <%--<c:if test="${site_info.kakaoPayUseYn eq 'Y'}">--%>
                                        <%--<input type="radio" class="order_radio" id="paymentWayCd04" name="paymentWayCd" value="31" pgCd="43">
                                        <label for="paymentWayCd04" class="radio_chack2_a">
                                            <span></span>
                                            카카오페이
                                        </label>--%>
                                            <%--</c:if>--%>

                                            <%--<c:if test="${site_info.samsungPayUseYn eq 'Y'}">--%>
                                        <input type="radio" class="order_radio" id="paymentWayCd05" name="paymentWayCd" value="31" pgCd="44">
                                        <label for="paymentWayCd05" class="radio_chack2_a">
                                            <span></span>
                                            삼성페이
                                        </label>
                                            <%--</c:if>--%>


                                        <input type="radio" class="order_radio" id="paymentWayCd06" name="paymentWayCd" value="31" pgCd="45">
                                        <label for="paymentWayCd06" class="radio_chack2_a">
                                            <span></span>
                                            LPay
                                        </label>

                                        <input type="radio" class="order_radio" id="paymentWayCd07" name="paymentWayCd" value="31" pgCd="46">
                                        <label for="paymentWayCd07" class="radio_chack2_a">
                                            <span></span>
                                            SSG Pay
                                        </label>

                                            <%--<c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">--%>
                                        <input type="radio" class="order_radio"  id="paymentWayCd00" name="paymentWayCd" value="31" pgCd="41">
                                        <label for="paymentWayCd00" class="radio_chack2_c">
                                            <span></span>
                                            payco
                                        </label>
                                            <%--  <span class="img"></span>
                                              <c:choose>
                                                  <c:when test="${simplePaymentConfig.data.dsnSetCd eq '01'}">
                                                      <img src="/front/img/product/easypay_a1.png">
                                                  </c:when>
                                                  <c:otherwise>
                                                      <img src="/front/img/product/easypay_a2.png">
                                                  </c:otherwise>
                                              </c:choose>--%>
                                            <%-- </c:if>--%>



                                            <%--<c:if test="${user.session.memberNo eq '1000'}">--%>

                                            <c:if test="${pgPaymentConfig.data.virtactPaymentYn eq 'Y'}">
                                                <input type="radio" class="order_radio" id="paymentWayCd08" name="paymentWayCd" value="22">
                                                <label for="paymentWayCd08" class="radio_chack2_c">
                                                    <span></span>
                                                    가상계좌
                                                </label>
                                            </c:if>

                                            <c:if test="${pgPaymentConfig.data.acttransPaymentYn eq 'Y'}">
                                                <input type="radio" class="order_radio" id="paymentWayCd09" name="paymentWayCd" value="21">
                                                <label for="paymentWayCd09" class="radio_chack2_c">
                                                    <span></span>
                                                    계좌이체
                                                </label>
                                            </c:if>
                                            <%--</c:if>--%>
                                             <%--<c:if test="${site_info.aliPayUseYn eq 'Y'}">--%>
                                            <input type="radio" class="order_radio" id="paymentWayCd10" name="paymentWayCd" value="42">
                                            <label for="paymentWayCd10" class="radio_chack2_a">
                                                <span></span>
                                                AliPay
                                            </label>
                                            <%--<input type="radio" class="order_radio" id="paymentWayCd11" name="paymentWayCd" value="43">
                                            <label for="paymentWayCd11" class="radio_chack2_a">
                                                <span></span>
                                                텐페이
                                            </label>--%>
                                            <%--<input type="radio" class="order_radio" id="paymentWayCd12" name="paymentWayCd" value="44">
                                            <label for="paymentWayCd12" class="radio_chack2_a">
                                                <span></span>
                                                위챗페이
                                            </label>--%>
                                            <%--</c:if>--%>

                                            <%--<c:if test="${pgPaymentConfig.data.mobilePaymentYn eq 'Y'}">
                                                <input type="radio" class="order_radio" id="paymentWayCd05" name="paymentWayCd" value="24">
                                                <label for="paymentWayCd05" style="margin-right:30px" class="radio_chack2_e">
                                                    <span></span>
                                                    휴대전화결제
                                                </label>
                                            </c:if>--%>
                                            <%--<c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
                                                <input type="radio" class="order_radio" id="paymentWayCd07" name="paymentWayCd" value="41">
                                                <label for="paymentWayCd07" class="radio_chack2_g">
                                                    <span></span>
                                                    PAYPAL
                                                </label>
                                            </c:if>--%>

                                    </td>
                                </tr>
                                </thead>
                                <tbody>
                                <!--무통장-->
                                <tr class="tr_11" style="display:none;">
                                    <th class="order_tit">입금은행</th>
                                    <td>
                                        <div id="bank_select" class="select_box28" style="width:450px;">
                                            <select class="select_option" title="select option" name="bankCd" style="width:100%;">
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
                                <!-- 무통장입금안내 -->
                                <tr class="tr_11" style="display:none;">
                                    <th class="vaT">무통장입금안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li class="fBlack">[결제하기] 버튼을 눌러 주문을 완료하신 후 지정하신 입금계좌로 주문금액을 입금해 주세요.</li>
                                            <li>* 주문하실 날로부터 5일 이내 미입금시 주문이 자동 취소됩니다.</li>
                                            <li>* 입금자명과 주문자명이 동일해야 정상적인 입금확인이 가능합니다.</li>
											<li>* 무통장 입금의 경우, 은행에 따라 오후 11시 30분 이후로는 온라인 입금이 제한 될 수 있습니다.</li>
                                            <li><button type="button" class="btn_pay" onclick="javascript:popupInfo('vBank');">무통장입금 안내</button></li>
                                        </ul>
                                    </td>
                                </tr>

                                <!-- 가상계좌 입금안내 -->
                                <tr class="tr_22" style="display:none;">
                                    <th class="vaT">가상계좌 안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li class="blank">[결제하기] 버튼 클릭시, 무통장입금 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                            <li>* 주문자명과 입금자명이 다르더라도 발급된 가상계좌번호로 정확한 금액을 입금하시면 정상 입금확인이 가능합니다.</li>
                                            <li>* 무통장입금 시 일부 은행(농협 및 국민은행)의 경우 ATM기기 입금이 불가할 수 있습니다. 이 경우 은행 창구 또는 인터넷 뱅킹을 이용해 주시기 바랍니다. </li>
                                            <li><a href="javascript:popupInfo('vBank')"><img src="../img/product/btn_bank_info.gif" alt="무통장입금 이용안내" style="margin-left:10px"></a></li>
                                        </ul>
                                    </td>
                                </tr>

                                <!-- 신용카드 결제 안내 -->
                                <tr class="tr_23" style="display:none;">
                                    <th class="vaT">신용카드 결제안내</th>
                                    <td>
                                        [결제하기] 버튼 클릭시, 신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.
                                        <div class="btn_pay_area">
                                            <button type="button" class="btn_pay" onclick="javascript:popupInfo('isp');">안전결제 안내</button>
                                            <button type="button" class="btn_pay" onclick="javascript:popupInfo('safe');">안심클릭 안내</button>
                                            <button type="button" class="btn_pay" onclick="javascript:popupInfo('official');">공인인증서 안내</button>
                                        </div>
                                    </td>
                                </tr>

                                <!--실시간 계좌이체 안내-->
                                <tr class="tr_21" style="display:none;">
                                    <th class="vaT">실시간 계좌이체 안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li class="blank">[결제하기] 버튼 클릭시, 실시간 계좌이체 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                            <li>* 회원님의 계좌에서 바로 이체되는 서비스이며, 이체 수수료는 무료입니다.<a href="javascript:popupInfo('account');"><img src="../img/product/btn_bank01_info.gif" alt="실시간계좌이체 이용안내" style="vertical-align:middle;margin-left:10px"></a></li>
                                            <li>* 23시 이후에는 은행별 이용 가능시간을 미리 확인하신 후 결제를 진행해 주세요. <a href="javascript:popupInfo('accountTime');"><img src="../img/product/btn_bank02_info.gif" alt="은행별 이용가능시간 이용안내" style="vertical-align:middle;margin-left:10px"></a></li>
                                            <li></li>
                                        </ul>
                                    </td>
                                </tr>
                                <!-- 휴대전화 결제 안내 -->
                                <tr class="tr_24" style="display:none;">
                                    <th class="vaT">휴대전화 결제안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li>휴대전화 결제는 통신사에 따라 결제 한도금액이 다릅니다. 자세한 내용은 휴대전화 결제안내를 확인해주세요.</li>
                                            <li>
                                                휴대전화 결제의 경우 가입하신 이동통신사에서 증빙을 발급 받을 수 있습니다.
                                                <a href="javascript:popupInfo('hpp');"><img src="../img/product/btn_mobile_pay.gif" alt="휴대전화 결제안내" style="vertical-align:middle;margin-left:10px"></a>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <!-- 간편결제 안내 -->
                                <tr class="tr_31" style="display:none;">
                                    <th class="vaT">간편결제 안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li class="blank">  [결제하기] 버튼 클릭시, 간편 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                            <li class="blank">
                                                    <%--- PAYCO는 NHN엔터테인먼트가 만든 안전한 간편결제 서비스입니다.<br/>--%>
                                                - 휴대전화과 카드 명의자가 동일해야 하며 결제금액 제한은 없습니다.<br/>
                                                - 결제 가능 카드 : 모든 신용/체크 카드 결제 가능

                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                                <!-- PAYPAL결제 안내 -->
                                <tr class="tr_41 tr_42 tr_43 tr_44" style="display:none;">
                                    <th class="vaT">해외 결제 안내</th>
                                    <td>
                                        <ul class="order_info_list">
                                            <li class="blank"> [결제하기] 버튼 클릭시, 해외 결제 사이트 로그인 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                        </ul>
                                    </td>
                                </tr>

                                <!-- 에스크로서비스 이용 -->
                                <c:if test="${pgPaymentConfig.data.escrowUseYn eq 'Y'}">
                                    <tr class="tr_21 tr_22" style="display:none;">
                                        <th class="vaT">에스크로서비스 이용</th>
                                        <td>
                                            <ul class="order_info_list">
                                                <li>
                                                    <input type="radio" class="order_radio" id="service_yes" name="escrowYn" value="Y">
                                                    <label for="service_yes">
                                                        <span></span>
                                                        예
                                                    </label>
                                                    <input type="radio" class="order_radio" id="service_no" name="escrowYn" value="N" checked>
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
                                    <th class="vaT">매출증빙</th>
                                    <td>
                                        <input type="radio" class="order_radio" id="shop_paper01" name="cashRctYn" value="N" checked="checked">
                                        <label for="shop_paper01"><span></span>발급안함</label>
                                        <c:if test="${pgPaymentConfig.data.cashRctUseYn eq 'Y'}">
											<span class="tr_21 tr_22" style="display:none;">
												<input type="radio" class="order_radio" id="shop_paper02" name="cashRctYn" value="Y">
												<label for="shop_paper02" style="margin-left:30px"><span></span>현금영수증</label>
											</span>
                                        </c:if>
                                        <input type="radio" class="order_radio" id="shop_paper03" name="cashRctYn" value="B">
                                        <label for="shop_paper03"><span></span>계산서</label>
                                        <button type="button" class="btn_pay marginL10" onclick="javascript:popupInfo('evidence');">증빙발급 안내</button>
                                        <!--계산서 선택시-->
                                        <div class="order_card_view radio1_con_b" style="display:none;">
                                            <table>
                                                <colgroup>
                                                    <col width="15%">
                                                    <col width="85%">
                                                </colgroup>
                                                <tbody>
                                                <tr>
                                                    <th>상호명</th>
                                                    <td><input type="text" name="billCompanyNm"></td>
                                                </tr>
                                                <tr>
                                                    <th>사업자번호</th>
                                                    <td><input type="text" name="billBizNo" maxlength="13"></td>
                                                </tr>
                                                <tr>
                                                    <th>대표자명</th>
                                                    <td><input type="text" name="billCeoNm"></td>
                                                </tr>
                                                <tr>
                                                    <th>업태/업종</th>
                                                    <td><input type="text" name="billBsnsCdts"> <input type="text" name="billItem"></td>
                                                </tr>
                                                <tr>
                                                    <th class="vaT">주소</th>
                                                    <td>
                                                        <input type="text" name="billPostNo" id="billPostNo" readonly="">
                                                        <button type="button" class="btn_form" onclick="javascript:billPost();">우편번호</button>
                                                        <input type="text" class="form_card_address" name="billRoadnmAddr" id="billRoadnmAddr" readonly="">
                                                        <input type="text" class="form_card_address" name="billDtlAddr">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>담당자명</th>
                                                    <td><input type="text" name="billManagerNm"></td>
                                                </tr>
                                                <tr>
                                                    <th>이메일</th>
                                                    <td><input type="text" name="billEmail"></td>
                                                </tr>
                                                <tr>
                                                    <th>연락처</th>
                                                    <td><input type="text" name="billTelNo"></td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!--//계산서 선택시-->
                                    </td>
                                </tr>

                                    <%-- <tr>
                                        <th class="vaT">주문자동의</th>
                                        <td>
                                            <p class="order_agree">
                                                주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며, 구매에 동의하시겠습니까?<br>
                                                (전자상거래법 제8조 제2항)<br>
                                                <input type="checkbox" class="order_check" id="order_agree">
                                                <label for="order_agree"><span></span>동의합니다.</label>
                                            </p>
                                        </td>
                                    </tr> --%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="right">
                        <div class="tCart_outline04">
                            <table class="tCart_Insert pay_total">
                                <caption>결제금액 정보입니다.</caption>
                                <colgroup>
                                    <col style="width:100px">
                                    <col style="width:">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th colspan="2">결제금액</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th>
                                        <label for="">총상품금액</label>
                                    </th>
                                    <td class="textR">
                                        <span id="totalOrderAmt"><fmt:formatNumber value="${orderTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <label for="">배송비</label>
                                    </th>
                                    <td class="textR">
                                        <span id="totalDlvrAmt">(+) <fmt:formatNumber value="${dlvrTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <label for="">추가배송비</label>
                                    </th>
                                    <td class="textR">
                                        <span id="totalAddDlvrAmt">(+) 0 원</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <label for="">할인금액</label>
                                    </th>
                                    <td class="textR">
                                        <span id="totalDcAmt">(-) <fmt:formatNumber value="${promotionTotalDcAmt+memberGradeTotalDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원</span>
                                    </td>
                                </tr>
                               <%-- <tr>
                                    <th>
                                        <label for="">마켓포인트</label>
                                    </th>
                                    <td class="textR">
                                        <span id="totalMileageAmt">(-) 0 원</span>
                                    </td>
                                </tr>--%>
                                <c:if test="${user.session.integrationMemberGbCd eq '03'}">
                                    <%--<tr>
                                        <th>
                                            <label for="">가맹점포인트</label>
                                        </th>
                                        <td class="textR">
                                            <span id="totalPointAmt">(-) 0 원</span>
                                        </td>
                                    </tr>--%>
                                </c:if>
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
                                    <%-- 상품별 지역추가배송비--%>
                                <input type="hidden" name="addDlvrAmtString" id="addDlvrAmtString" value="">
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
                                <%--<input type="hidden" name="memberGradeTotalDcAmt" id="memberGradeTotalDcAmt" value="0">--%>
                                    <%-- 기획전+회원등급 할인금액(계산용) --%>
                                <input type="hidden" name="dcPrice" id="dcPrice" value="<fmt:parseNumber type='number' value='${promotionTotalDcAmt+memberGradeTotalDcAmt}'/>">
                                    <%-- 총 할인금액(기획전+쿠폰+회원등급) --%>
                                <input type="hidden" name="dcAmt" id="dcAmt" value="<fmt:parseNumber type='number' value='${promotionTotalDcAmt+memberGradeTotalDcAmt}'/>">
                                    <%-- 총 마켓포인트 사용금액 --%>
                                <input type="hidden" name="mileageTotalAmt" id="mileageTotalAmt" value="0">
                                    <%-- 총 가맹점포인트 사용금액 --%>
                                <input type="hidden" name="pointTotalAmt" id="pointTotalAmt" value="0">
                                    <%-- 총 지급 적립 금액 --%>
                                <input type="hidden" name="pvdSvmnTotalAmt" id="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}">
                                	<%-- 추천인 총 지급 적립 금액 --%>
                                <input type="hidden" name="recomPvdSvmnTotalAmt" id="recomPvdSvmnTotalAmt" value="${recomPvdSvmnTotalAmt}">
                                    <%-- 총 지역 추가 배송비 금액 --%>
                                <input type="hidden" name="addDlvrTotalAmt" id="addDlvrTotalAmt" value="0">
                                    <%-- 총 결제금액 --%>
                                <input type="hidden" name="paymentAmt" id="paymentAmt" value="<fmt:parseNumber type='number' value='${paymentTotalAmt}'/>">
                                <input type="hidden" name="orgPaymentAmt" id="orgPaymentAmt" value="<fmt:parseNumber type='number' value='${paymentTotalAmt}'/>">
                                </tbody>
                            </table>
                        </div>
                        <div class="tCart_outline04_price">
                            <p class="total_won"><em id="totalPaymentAmt"><fmt:formatNumber value="${paymentTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> </em>원</p>
                            <p class="total_check_area">
                                <input type="checkbox" class="order_check" id="order_agree01">
                                <label for="order_agree01"><span></span>상품의 구매조건을 확인하였으며 결제진행에 동의합니다.</label>
                            </p>
                        </div>
                        <div class="btn_area">
                            <button type="button" class="btn_prev">이전</button><button type="button" class="btn_go_pay" onclick="javascript:go_pay();">결제하기</button>
                        </div>
                    </div>
                </div>

            </div>
            <!---// 02.LAYOUT: 주문 메인 --->
            <!--- popup 무통장입금(가상계좌) 이용 안내 --->
            <div class="popup_bank" id="popup_bank" style="display:none;">
                <div class="popup_header">
                    <h1 class="popup_tit">무통장입금 이용 안내</h1>
                    <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
                </div>
                <div class="popup_content">
                    <div class="popup_middle">
                        <h3 class="cart_popup_title">무통장입금 결제방법</h3>
                        <ul class="mobile_payment_info_text">
                            <li>상품 주문시 결제정보 입력에서 결제수단으로 '무통장입금'을 선택하신 후 입금하실 은행을 선택하고 '결제하기' 버튼을 클릭하십시오.</li>
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
            <!--- popup 휴대전화결제 이용 안내 --->
            <div class="popup_official" id="popup_hpp" style="display:none;">
                <div class="popup_header">
                    <h1 class="popup_tit">휴대전화결제 이용 안내</h1>
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
                        <h3 class="cart_popup_title">휴대전화 결제 금액 청구</h3>
                        <ul class="mobile_payment_info_text">
                            <li>결제하신 내역은 익월 휴대전화 요금에 합산 청구됩니다.</li>
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
                                <td class="popup_f11_fc" style="text-align:left; padding-left:10px;">휴대전화 청구금액에 부과예정이던 결제금액이 취소됩니다. </td>
                            </tr>
                            <tr>
                                <th>결제 익월에 환불처리가 완료된 경우</th>
                                <td class="popup_f11_fc" style="text-align:left; padding-left:10px;">휴대전화 청구내역에는 결제금액이 포함되며, 동일한 금액이 환불처리 즉시 고객님의 계좌로 환불 됩니다. </td>
                            </tr>
                            </tbody>
                        </table>
                        <ul class="mobile_payment_info_text">
                            <li>※ 휴대전화 소액결제의 경우 세금계산서와 현금영수증이 발급되지 않습니다<br/>
                                단, 이용료를 수납한 고객분은 해당 이동통신사에서 연말 소득공제를 제공해 드립니다.</li>
                        </ul>
                    </div>
                    <div class="popup_btn_area">
                        <button type="button" class="btn_popup_cancel">닫기</button>
                    </div>
                </div>
            </div>
            <!---// popup 휴대전화결제 이용 안내 --->

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
                                    <li style="margin-left:5px">근로소득자가 연말정산을 통해 소득공제를 받을 수 있는 영수증으로, 신청정보는 휴대전화번호, 현금영수증 카드번호 중 선택 할 수 있으며, 타인 명의로도 발급받으실 수 있습니다.</li>
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
            <!-- 나의 배송 주소록 팝업 -->
            <div id="div_myDelivery" style="display: none;">
                <div id ="myDeliveryList"></div>
            </div>

            <input type="hidden" name="ordNo" value="${ordNo}"/>
            <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
            <input type="hidden" id="confirmNo" name="confirmNo" value=""/> <%-- 페이팔, 페이코(reserveOrderNo) 사용 --%>
            <input type="hidden" id="txNo" name="txNo" value=""/> <%-- 페이팔, 페이코(paymentCertifyToken) 사용 --%>
            <input type="hidden" id="logYn" name="logYn" value=""/> <%-- 페이팔, 페이코(logYn) 사용 --%>
            <input type="hidden" id="confirmResultCd" name="confirmResultCd" value=""/> <%-- 페이팔, 페이코() 사용 --%>
            <input type="hidden" id="confirmResultMsg" name="confirmResultMsg" value=""/>
            <input type="hidden" id="confirmDttm" name="confirmDttm" value=""/>
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
                <%@ include file="/WEB-INF/views/order/include/01/kcp_req.jsp" %>
                <!--//KCP연동  -->
            </c:if>
            <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
                <!-- 이니시스연동 -->
                <%--<font color="blue" size="5"><b>== 여기부터 이니시스 ================================================================================================</b></font>--%>
                <%@ include file="/WEB-INF/views/order/include/inicis/inicis_req.jsp" %>
                <!--// 이니시스연동 -->
            </c:if>
            <c:if test="${pgPaymentConfig.data.pgCd eq '03'}">
                <%--<font color="blue" size="5"><b>== 여기부터 LGU+ ================================================================================================</b></font>--%>
                <%@ include file="/WEB-INF/views/order/include/03/PayreqCrossplatform.jsp"%>
            </c:if>
            <c:if test="${pgPaymentConfig.data.pgCd eq '04'}">
                <%--<font color="blue" size="5"><b>== 여기부터 올더게이트 ================================================================================================</b></font>--%>
                <%@ include file="/WEB-INF/views/order/include/04/AGS_pay.jsp"%>
            </c:if>
        </form>

        <c:if test="${foreignPaymentConfig.data.frgPaymentYn eq 'Y'}">
            <!-- PAYPAL연동 -->
            <%--<font color="blue" size="5"><b>== 여기부터 PAYPAL ================================================================================================</b></font>--%>
            <%-- <%@ include file="include/paypal_req.jsp"%> --%>
            <!--//PAYPAL연동  -->
        </c:if>
        <%--알리페이 연동--%>
         <%@ include file="/WEB-INF/views/order/include/alipay_req.jsp"%>
        <%--//알리페이 연동--%>

        <%--텐페이 연동--%>
         <%@ include file="/WEB-INF/views/order/include/tenpay_req.jsp"%>
        <%--//텐페이 연동--%>

        <c:if test="${simplePaymentConfig.data.simplepayUseYn eq 'Y'}">
            <!-- PAYCO연동 -->
            <br/>
            <%--<font color="blue" size="5"><b>== 여기부터 PAYCO ================================================================================================</b></font>--%>
            <br>
            <%@ include file="/WEB-INF/views/order/include/payco/payco_form.jsp" %>
            <!--// PAYCO연동 -->
        </c:if>

        <div id="div_store_detail_popup" >
            <div id="map3" style="width:100%px;height:400px;"></div>
        </div>

        <!-- popup 결제중로딩 -->
        <div class="popup popup_pay_ing" style="display: none;">
            <img src="${_SKIN_IMG_PATH}/order/pay_loading.gif" alt="로딩중">
            <p class="pay_ing_tit">결제가 <em>진행중</em>입니다.</p>
            <p>결제 진행중 브라우저를 닫거나, 새로고침 하시면<br>결제 오류가 발생할 수 있으니<br>주문이 완료될때까지 잠시만 기다려주세요.</p>
        </div>
		<!--// popup 결제중로딩 -->


        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "SO" />
        <%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>
    </t:putAttribute>
</t:insertDefinition>