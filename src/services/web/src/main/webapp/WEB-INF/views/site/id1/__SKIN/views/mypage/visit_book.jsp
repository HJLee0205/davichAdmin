<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<t:insertDefinition name="davichLayout">
    <c:set var="ordCnt" value="${fn:length(orderInfo.data.orderGoodsVO)}"/>
    <c:set var="vision" value="${fn:split(visionChk,'|')}"/>

    <%--
    기획전 정보

    현제 상품은 1개만 가지고 있다.
    추후 상품이 여러개 일수 있음, 상품이 여러개일경우 프로모션 정보를 가져오는 방법도 변경이 필요함
    --%>
    <c:if test="${orderInfo.data.exhibitionYn eq 'Y'}">
        <c:forEach var="orderGoods" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
            <c:set var="prmtNo" value="${orderGoods.prmtNo}"/>
            <c:set var="prmtNm" value="${orderGoods.prmtNm}"/>
            <c:set var="prmtSDate" value="${orderGoods.prmtSDate}"/>
            <c:set var="prmtEDate" value="${orderGoods.prmtEDate}"/>
        </c:forEach>
    </c:if>

    <t:putAttribute name="title">다비치마켓 :: 방문예약</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script src="/front/js/moment.min.js" charset="utf-8"></script>
        <script src="/front/js/fullcalendar.js" charset="utf-8"></script>
        <script>
            let map3 = new daum.maps.Map(document.getElementById('map3'), {
                center: new daum.maps.LatLng(37.537123, 127.005523),
                level : 3
            });
            let eventData = [];
            <%-- 프로모션 정보 --%>
            <c:choose>
            <c:when test="${orderInfo.data.exhibitionYn eq 'Y'}">
            let isPromotion = true;
            let promotion = {
                prmtNm: "${prmtNm}",
                prmtNo: "${prmtNo}",
                prmtSDate: new Date(Date.parse("${prmtSDate}T00:00:00")),
                prmtEDate: new Date(Date.parse("${prmtEDate}T23:59:59")),
                bookingTerm: [],
            }
            // 예약가능일 설정
            // todo : 임시로 프로모션 제목에 방문가능일을 설정 해 둠. 프로모션 관리자에 예약가능일 설정기능 추가 필요
            let bookingTerm = promotion.prmtNm.match(/[0-9]{4}-[0-9]{2}-[0-9]{2}\s?~\s?[0-9]{4}-[0-9]{2}-[0-9]{2}/);
            if (bookingTerm) {
                bookingTerm = bookingTerm[0].split('~');
                promotion.bookingTerm.push(new Date(Date.parse(bookingTerm[0].trim() + "T00:00:00")));
                promotion.bookingTerm.push(new Date(Date.parse(bookingTerm[1].trim() + "T23:59:59")));
            }
            </c:when>
            <c:otherwise>
            let isPromotion = false;
            let promotion = {};
            let bookingTerm = [];
            </c:otherwise>
            </c:choose>

            /* Event snippet for 예약하기 conversion page*/
            function gtag_report_conversion(url) {
                let callback = function () {
                    if (typeof (url) != 'undefined') {
                        [removed] = url;
                    }
                };
                gtag('event', 'conversion', {'send_to': 'AW-774029432/JASfCLSH15IBEPiAi_EC'});
                return false;
            }

            <%-- 프로모션 기간 체크 --%>
            function checkPromotionTerm(date, beginDate, endDate, title){
                if (beginDate) {
                    let beginDateString = beginDate.toLocaleDateString('ko-KR');
                    let endDateString = endDate.toLocaleDateString('ko-KR');
                    if (date.isBefore(beginDate) || date.isAfter(endDate)) {
                        Dmall.LayerUtil.alert(
                            title + " 기간은 <br>" + beginDateString + " ~ " + endDateString + "사이의 날짜만 선택 하실 수 있습니다.",
                            '확인'
                        );
                        return false;
                    }
                    return true;
                }
                return true;
            }

            $(document).ready(function () {
                <%-- 유입 체널 --%>
                let ch = "${ch}";
                let storeNm = '${storeNm}';
                let storeCode = '${storeCode}';
                let eventGubun = [ch];
                <%-- 체널유입이 아닐경우 프로모션 제품이 아니다 --%>
                if (ch === '') isPromotion = false;

                if (storeNm){
                    $('#searchStoreNm').val(storeNm);
                    $('#storeNm').val(storeNm);
                    $("#storeNo").val(storeCode);
                    $('#visitStore').text(storeNm);
                    setTimeout(()=>$('#btn_search_store').click(), 2500);
                }

                $('#calendar').fullCalendar({
                    header: {
                        left  : 'none',
                        center: 'title'
                    },
                    titleFormat: {
                        month: 'YYYY. MM'
                    },
                    buttonText: {
                        today: '오늘'
                    },
                    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                    events: eventData,

                    dayClick : function (date, allDay, jsEvent, view) {
                        if (isPromotion && promotion.bookingTerm.length){
                            if(!checkPromotionTerm(date, promotion.bookingTerm[0], promotion.bookingTerm[1], promotion.prmtNm)){
                                return false;
                            }
                        } else {
                            $('[name=goodsNo]').each(function(){
                                //todo : 상품 정보를 방문 목적으로 사옹한다.
                            });
                        }

                        $("#calendar").fullCalendar('refetchEvents');

                        var events = $('#calendar').fullCalendar('clientEvents');
                        for (var i = 0; i < events.length; i++) {

                            if (events[i].className == 'visit_disabled' && convertDate(events[i].start) == date.format("YYYY-MM-DD")) {
                                // Dmall.LayerUtil.alert("해당 선택일은 방문예약을 할수 없습니다.", "확인");
                                Dmall.LayerUtil.alert("<알림> <br>"+
                                    "고객님게서 선택하신 안경원("+$('#storeNm').val()+")은<br>"+
                                    "해당 일정에 정기 휴무 입니다.<br>"+
                                    "다른 일자 또는 해당 일정의 다른 매장의 예약을 부탁드립니다.<br>"+
                                    "[전 매장 정기 휴무 : 설, 추석 명절 당일]<br>", "확인");
                                return false;
                            }

                            if (events[i].className == 'visit_delivery_disabled' &&
                                convertDate(events[i].start) <= date.format("YYYY-MM-DD") &&
                                date.format("YYYY-MM-DD") < convertDate(events[i].end)
                            ) {
                                Dmall.LayerUtil.alert("[알림]<br>고객님께서 선택하신 일정은 예약이 불가합니다.<br>다른 일자 또는 다른 매장의 예약을 부탁드립니다.<br>고맙습니다. ", "확인");
                                return false;
                            }
                        }

                        $("#calendar").fullCalendar('renderEvent', {
                            start    : date.format("YYYY-MM-DD"),
                            end      : date.format("YYYY-MM-DD"),
                            className: 'visit_abled'
                        });

                        var storeNo = $('#storeNo').val();
                        var sucess = true;
                        if (storeNo == '' || storeNo == undefined) {
                            $("#calendar").fullCalendar('refetchEvents');
                            Dmall.LayerUtil.alert("방문하실 매장을 먼저 선택해 주세요.", "확인");
                            return false;
                        }

                        if (today() > date.format("YYYYMMDD")) {
                            $("#calendar").fullCalendar('refetchEvents');
                            Dmall.LayerUtil.alert("오늘 날짜 이후로 선택해 주세요.", "확인");
                            return false;
                        }

                        // 방문정보 setting
                        $('#storeTitle').text($('#storeNm').val() + "  :  " + date.format("YYYY년 MM월 DD일"));  //매장
                        $('#visitDate').text(date.format("YYYY-MM-DD") + "  " + dayOfWeek(date.format("YYYY-MM-DD")));   //예약일자
                        $('#visitStore').text($('#storeNm').val());  //매장
                        $('input[name=rsvDate]').val(date.format("YYYY-MM-DD"));
                        // 혼잡시간표 가져오기
                        getTimeTableList(date.format("YYYY-MM-DD"));
                    }
                });

                $('#sel_sidoCode').on('change', function () {
                    var optionSelected = $(this).find("option:selected").val();

                    if (optionSelected.length == 0) {
                        $('#sel_guGunCode').empty();
                        $('#sel_guGunCode').append('<option value="">구/군</option>');
                        return;
                    }

                    var url = '/front/visit/change-sido';
                    var param = {def1: optionSelected};

                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        $('#sel_guGunCode').empty();
                        $('#sel_guGunCode').append('<option value="">구/군</option>');

                        var sortData = result;
                        sortData.sort(function (a, b) {
                            return (a.dtlNm < b.dtlNm) ? -1 : (a.dtlNm > b.dtlNm) ? 1 : 0;
                        });

                        // 취득결과 셋팅
                        jQuery.each(sortData, function (idx, obj) {
                            $('#sel_guGunCode').append('<option value="' + obj.dtlCd + '">' + obj.dtlNm + '</option>');
                        });

                        getSidoStoreList(optionSelected);
                    });
                });


                $('#sel_guGunCode').on('change', function () {

                    var optionSelected = $(this).find("option:selected").val();
                    var url = '/front/visit/store-list';
                    var sidoCode = $('#sel_sidoCode').find("option:selected").val();

                    var hearingAidYn = hearingAidChk();
                    if (hearingAidYn != "Y") {
                        hearingAidYn = "";
                    }

                    if ('${isHa}' == 'Y') hearingAidYn = 'Y';

                    var erpItmCode = "";
                    $('input[name="erpItmCode"]').each(function () {
                        if (erpItmCode != "") erpItmCode += ",";
                        if ($(this).val() != "") erpItmCode += $(this).val();
                    });

                    var param = {sidoCode: sidoCode, gugunCode: optionSelected, hearingAidYn: hearingAidYn, erpItmCode: erpItmCode};
                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var address = [];

                        if (result.strList.length == 0) {
                            Dmall.LayerUtil.alert('선택한 지역은 매장이 존재하지 않습니다.', "확인");
                            return false;
                        }

                        // 취득결과 셋팅
                        jQuery.each(result.strList, function (idx, obj) {
                            var addr = obj.addr1 || ' ' || obj.addr2;
                            var strCode = obj.strCode;
                            var strName = obj.strName;
                            address.push({"address": addr, "storeNo": strCode, "storeNm": strName});
                        });

                        searchGeoByAddr(address);
                    });

                });

                $('#sel_visitTime').on('change', function () {
                    var optionSelected = $(this).find("option:selected").val();
                    $('input[name=rsvTime]').val(optionSelected);
                });

                $('input:checkbox[name="purpose_check"]').on('click', function () {
                    let purposeCd = [];
                    let purposeNm = [];

                    <c:choose>
                    <c:when test="${orderInfo.data.preGoodsYn ne 'Y' and orderInfo.data.exhibitionYn ne 'Y' and rsvOnlyYn ne 'Y' and teanseonMiniYn ne 'Y' and eyeluvYn ne 'Y' and teanseonNewYn ne 'Y' and trevuesYn ne 'Y' and teanseanSampleYn ne 'Y'}">
                    var visitPurpose=[];
                    var visitPurposeCd=[];

                    $('#purpose li').each(function() {
                        if( $(this).hasClass('active') ) {
                            var _purposeNm = $(this).data('purpose-nm');
                            var _purposeGb = $(this).data('purpose');
                            purposeCd = [];
                            purposeNm = [];
                            $('[id^=purpose_check_'+_purposeGb+']').each(function(){
                                if( $(this).is(':checked') ) {
                                    purposeCd.push($(this).val());
                                    purposeNm.push($.trim($('label[for=' + this.id + ']').text()));
                                }
                            });

                            if(_purposeGb=='06'){
                                purposeCd.push("29");
                                purposeNm.push("재구매(매장)");
                                visitPurposeCd.push(purposeCd.join(","));
                                visitPurpose.push(purposeNm.join(","));
                            }else{
                                if(purposeCd!=null && purposeCd.length>0 )
                                    visitPurposeCd.push(purposeCd.join(","));
                                if(purposeNm!=null && purposeNm.length>0){
                                    visitPurpose.push(_purposeNm+'-'+purposeNm.join(","));
                                }else{
                                    visitPurpose.push(_purposeNm);
                                }
                            }
                        }
                    });

                    $('#visitPurpose').html(visitPurpose.join("|"));
                    $('input[name=eventGubun]').val(eventGubun);
                    $('input[name=visitPurposeCd]').val(visitPurposeCd);
                    $('input[name=visitPurposeNm]').val(visitPurpose.join("|"));
                    </c:when>
                    <c:otherwise>

                    $('input:checkbox[name="purpose_check"]').each(function() {
                        if( $(this).is(':checked') ) {
                            purposeCd.push($(this).val());
                            purposeNm.push($.trim($('label[for=' + this.id + ']').text()));
                        }
                    });

                    $('#visitPurpose').html("▶" + purposeNm.join('&nbsp;&nbsp;&nbsp;▶'));
                    $('input[name=eventGubun]').val(eventGubun);
                    $('input[name=visitPurposeCd]').val(purposeCd.join(","));
                    $('input[name=visitPurposeNm]').val("▶" + purposeNm.join('   ▶'));
                    </c:otherwise>
                    </c:choose>
                });

                $('#purpose li').on('click',function (){
                    var _img = $(this).find('img').attr("src");
                    var purpose = $(this).data('purpose');
                    var optionYn = "N";

                    if($(this).hasClass('active')){
                        _img =  _img.split('_over')[0]+"."+_img.split('.')[1];
                        $(this).removeClass('active');
                        $(this).find('img').attr("src",_img);
                        $('#visit_check_area_'+purpose).hide();


                    }else{
                        _img = _img.split('.')[0]+"_over."+_img.split('.')[1];
                        $(this).addClass('active');
                        $(this).find('img').attr("src",_img);

                    }
                    var purposeCd = [];
                    var purposeNm = [];
                    var visitPurpose=[];
                    var visitPurposeCd=[];

                    $('#purpose li').each(function(){
                        var _purposeNm = $(this).data('purpose-nm');
                        var _purposeGb = $(this).data('purpose');
                        if($(this).hasClass('active')){
                            optionYn = "Y";

                            purposeCd = [];
                            purposeNm = [];
                            $('[id^=purpose_check_'+_purposeGb+']').each(function(){
                                if( $(this).is(':checked') ) {
                                    purposeCd.push($(this).val());
                                    purposeNm.push($.trim($('label[for=' + this.id + ']').text()));
                                }
                            });
                            if(_purposeGb=='06'){
                                purposeCd.push("29");
                                purposeNm.push("재구매(매장)");
                                visitPurposeCd.push(purposeCd.join(","));
                                visitPurpose.push(purposeNm.join(","));
                            }else{
                                if(purposeCd!=null && purposeCd.length>0 )
                                    visitPurposeCd.push(purposeCd.join(","));
                                if(purposeNm!=null && purposeNm.length>0){
                                    visitPurpose.push(_purposeNm+'-'+purposeNm.join(","));
                                }else{
                                    visitPurpose.push(_purposeNm);
                                }
                            }

                        }
                    });

                    $('#visitPurpose').html(visitPurpose.join("|"));
                    $('input[name=visitPurposeCd]').val(visitPurposeCd);
                    $('input[name=visitPurposeNm]').val(visitPurpose.join("|"));

                    if(optionYn=='Y'){
                        var optionLayer="";
                        if(purpose!='06'){
                            optionLayer+='<li style="width:50%">';
                            optionLayer+='	<img src="${_SKIN_IMG_PATH}/mypage/visit_check_07.png" alt="선택상세보기">';
                            optionLayer+='	<span>선택상세보기</span>';
                            optionLayer+='</li>';
                        }
                        if(purpose!='06') {
                            optionLayer += '<li style="width:50%">';
                        }else{
                            optionLayer += '<li style="width:100%">';
                        }
                        optionLayer+='<a href="/front/vision2/vision-check">';
                        optionLayer+='	<img src="${_SKIN_IMG_PATH}/mypage/visit_check_08.png" alt="내 눈에 맞는 추천">';
                        optionLayer+='</a>';
                        optionLayer+='	<span>내 눈에 맞는 추천</span>';
                        optionLayer+='</li>';
                        $('#purpsoe_option').html(optionLayer);
                        $('#purpsoe_option').show();

                        $('#purpsoe_option li').on('click',function (){
                            var _img = $(this).find('img').attr("src");

                            if($(this).hasClass('active')){
                                _img =  _img.split('_over')[0]+"."+_img.split('.')[1];
                                $(this).removeClass('active');
                                $(this).find('img').attr("src",_img);
                            }else{
                                _img = _img.split('.')[0]+"_over."+_img.split('.')[1];
                                $(this).addClass('active');
                                $(this).find('img').attr("src",_img);
                            }

                            $('#purpose li').each(function(){
                                if($(this).hasClass('active')){
                                    var purpose = $(this).data('purpose');
                                    $("#visit_check_area_"+purpose).show();
                                }
                            });
                        });

                    }else{
                        $('#purpsoe_option').hide();
                    }
                });

                // 접수하기
                $('.btn_go_receipt').off("click").on('click', function () {
                    var preGoodsYn='${orderInfo.data.preGoodsYn}'; //증정상품여부
                    var preAvailable='${orderInfo.data.preAvailableYn}'; //증정상품 예약 가능여부

                    var goodsNo = $('input[name=goodsNo]').val() || null;
                    var nomemberNm = $('input[name=nomemberNm]').val();
                    var nomobile = $('input[name=nomobile]').val();
                    var storeNm = $('input[name=storeNm]').val();
                    var rsvDate = $('input[name=rsvDate]').val();
                    var rsvTime = $('input[name=rsvTime]').val();
                    var reqMatr = $('input[name=reqMatr]').val();
                    var visitPurposeNm = $('input[name=visitPurposeNm]').val();

                    // 이름
                    if (nomemberNm == undefined || nomemberNm.trim() == '') {
                        Dmall.LayerUtil.alert("이름을 입력해주세요.", "확인");
                        return false;
                    }

                    if (! /^[a-zA-Z가-흻 ]+$/.test(nomemberNm)){
                        Dmall.LayerUtil.alert("특수문자는 이름에 사용할 수 없습니다.", "확인");
                        $('input[name=nomemberNm]').focus();
                        return false
                    }

                    // 연락처
                    if (nomobile == undefined || nomobile.trim() == '') {
                        Dmall.LayerUtil.alert("연락처를 입력해주세요.", "확인");
                        return false;
                    }

                    if (! /^[0-9]+$/.test(nomobile)){
                        Dmall.LayerUtil.alert("연락처는 숫자만 사용 가능합니다.", "확인");
                        $('input[name=nomobile]').focus();
                        return false
                    }

                    //방문목적
                    if (visitPurposeNm == '▶' || visitPurposeNm == '' || visitPurposeNm == undefined) {
                        Dmall.LayerUtil.alert("방문목적을 선택해주세요.", "확인");
                        return false;
                    }

                    //매장
                    if (storeNm == '') {
                        Dmall.LayerUtil.alert("매장을 선택해 주세요.", "확인");
                        return false;
                    }

                    //날짜
                    if (rsvDate == '') {
                        Dmall.LayerUtil.alert("예약 날짜를 선택해 주세요.", "확인");
                        return false;
                    }

                    //시간
                    if (rsvTime == '') {
                        Dmall.LayerUtil.alert("예약 시간을 선택해 주세요.", "확인");
                        return false;
                    }

                    if(preGoodsYn=='Y'){
                        if(preAvailable != 'Y'){
                            Dmall.LayerUtil.alert("해당 상품의 재고가 품절 되었습니다.", "확인");
                            return false;
                        }

                        var url = '/front/goods/pre-goods-rsv-chk';
                        var param = {memberNo:'${user.session.memberNo}', goodsNo:goodsNo};
                        Dmall.AjaxUtil.getJSON(url, param, function(result) {
                            if(!result.success){
                                Dmall.LayerUtil.alert('이미 예약된 상품입니다.', '','');
                                return false;
                            }else{
                                var url = '/front/visit/exists-rsv-time';
                                var param = {strRsvDate: rsvDate, rsvTime: rsvTime, goodsNo: goodsNo};
                                Dmall.AjaxUtil.getJSON(url, param, function (result) {

                                    if (parseInt(result.cnt) == 0) {
                                        $('#frmVisitBook').attr('action', '/front/visit/visit-rsv-regist');
                                        $('#frmVisitBook').submit();
                                    } else {
                                        Dmall.LayerUtil.alert('이미 동일 방문예약일시로 방문예약된건이 존재합니다.\n 예약시간을 다시 선택해주세요', "확인");
                                        return false;
                                    }
                                });
                            }
                        });
                    }else{
                        <c:if test="${member_info ne null}">
                        var url = '/front/visit/exists-rsv-time';
                        var param = {strRsvDate: rsvDate, rsvTime: rsvTime, goodsNo: goodsNo};
                        Dmall.AjaxUtil.getJSON(url, param, function (result) {

                            if (parseInt(result.cnt) == 0) {
                                $('#frmVisitBook').attr('action', '/front/visit/visit-rsv-regist');
                                $('#frmVisitBook').submit();
                            } else {
                                Dmall.LayerUtil.alert('이미 동일 방문예약일시로 방문예약된건이 존재합니다.\n 예약시간을 다시 선택해주세요', "확인");
                                return false;
                            }
                        });
                        </c:if>
                        <c:if test="${member_info eq null}">
                        $('#frmVisitBook').attr('action', '/front/visit/visit-rsv-regist');
                        $('#frmVisitBook').submit();
                        </c:if>

                    }

                });

                //매장 텍스트 검색
                $('#btn_search_store').click(function () {

                    var url = '/front/visit/store-list';
                    //var sidoCode = $('#sel_sidoCode').find("option:selected").val();
                    //var guGunCode = $('#sel_guGunCode').find("option:selected").val();
                    var strName = $('#searchStoreNm').val();
                    if (strName == null || strName == '') {
                        Dmall.LayerUtil.alert('매장명을 입력해주세요.', "확인");
                        return false;
                    } else {
                        //텍스트 검색일 경우 시도구군 상관없이 조회
                        $('#sel_sidoCode option:eq(0)').prop('selected', true);
                        $('#sel_guGunCode option:eq(0)').prop('selected', true);
                    }

                    var hearingAidYn = hearingAidChk();
                    if (hearingAidYn != "Y") {
                        hearingAidYn = "";
                    }

                    if ('${isHa}' == 'Y') hearingAidYn = 'Y';

                    var erpItmCode = "";
                    $('input[name="erpItmCode"]').each(function () {
                        if (erpItmCode != "") erpItmCode += ",";
                        if ($(this).val() != "") erpItmCode += $(this).val();
                    });

                    var param = {hearingAidYn: hearingAidYn, erpItmCode: erpItmCode, strName: strName};
                    Dmall.AjaxUtil.getJSON(url, param, function (result) {
                        var address = [];

                        if (result.strList.length == 0) {
                            Dmall.LayerUtil.alert('해당 매장이 존재하지 않습니다.', "확인");
                            return false;
                        }

                        // 취득결과 셋팅
                        jQuery.each(result.strList, function (idx, obj) {
                            var addr = obj.addr1 || ' ' || obj.addr2;
                            var strCode = obj.strCode;
                            var strName = obj.strName;
                            address.push({"address": addr, "storeNo": strCode, "storeNm": strName});
                        });

                        searchGeoByAddr(address);

                    });
                });

                //매장상세정보
                $("#store_info").on('click', function () {

                    var storeNm = $("#storeNm").val();

                    if (storeNm == null || storeNm == '') {
                        Dmall.LayerUtil.alert("매장을 먼저 선택해 주세요.", "확인");
                        return false;
                    }

                    var url = '/front/visit/store-detail-pop?storeCode=' + $("#storeNo").val();
                    Dmall.AjaxUtil.load(url, function (result) {
                        $('#div_store_detail_popup').html(result);

                        map3 = new daum.maps.Map(document.getElementById('map3'), {
                            center: new daum.maps.LatLng(37.537123, 127.005523),
                            level : 3
                        });
                    })
                });

                $("#my_shop").change(function () {
                    if ($("#my_shop").is(":checked")) {

                        var storeNo = $("#my_shop_no").val();

                        if (storeNo == null || storeNo == '') {
                            Dmall.LayerUtil.alert("설정된 단골매장이 없습니다.", "확인");
                            return false;
                        }

                        var erpItmCode = "";
                        $('input[name="erpItmCode"]').each(function () {
                            if (erpItmCode != "") erpItmCode += ",";
                            if ($(this).val() != "") erpItmCode += $(this).val();
                        });

                        var url = '/front/visit/store-info?storeCode=' + storeNo + '&erpItmCode=' + erpItmCode;
                        Dmall.AjaxUtil.load(url, function (result) {
                            var rs = JSON.parse(result);
                            if (rs.message != "") {
                                Dmall.LayerUtil.alert(rs.message, "알림");
                                $('#my_shop').attr('checked', false);
                                return false;
                            }

                            var address = [];
                            var addr = rs.addr1 || ' ' || rs.addr2;
                            var strCode = rs.strCode;
                            var strName = rs.strName;

                            address.push({"address": addr, "storeNo": strCode, "storeNm": strName});

                            searchGeoByAddr(address);
                            $("#storeNo").val(strCode);
                            $("#storeNm").val(strName);

                            // 매장선택시 초기화
                            $('#visitStore').text("");  //매장
                            $('#visitDate').text("");  //날짜
                            $('input[name=rsvDate]').val("");
                            $('input[name=rsvTime]').val("");
                            $('#sel_visitTime').val("0900");
                            $('.time_table_list').empty();
                            $('#storeTitle').text("");

                            // 매장별 휴일가져오기
                            getHoliday(storeNo, today().substring(0, 6));

                        })
                    } else {
                        $("#storeNo").val('');
                        $("#storeNm").val('');
                    }
                });

                // 왼쪽 버튼을 클릭하였을 경우
                jQuery("button.fc-prev-button").click(function (e) {
                    var date = jQuery("#calendar").fullCalendar("getDate");
                    var storeCode = $("#storeNo").val();

                    var targetYM = convertYm(date);

                    // 매장별 휴일가져오기
                    getHoliday(storeCode, targetYM);
                });

                // 오른쪽 버튼을 클릭하였을 경우
                jQuery("button.fc-next-button").click(function () {
                    var date = jQuery("#calendar").fullCalendar("getDate");
                    var storeCode = $("#storeNo").val();
                    var targetYM = convertYm(date);


                    // 매장별 휴일가져오기
                    getHoliday(storeCode, targetYM);
                });

                //사전예약상품 디폴트 체크
                var exhibitionYn = "${orderInfo.data.exhibitionYn}";
                var rsvOnlyYn = "${rsvOnlyYn}";
                var teanMiniYn ="${teanseonMiniYn}";
                var vegemilYn ="${vegemilYn}";
                var eyeluvYn ="${eyeluvYn}";
                var teanseonNewYn ="${teanseonNewYn}";

                if (exhibitionYn == 'Y' || rsvOnlyYn == 'Y' || teanMiniYn=='Y' || vegemilYn=='Y' || eyeluvYn=='Y' || teanseonNewYn=='Y') {
                    $('input:checkbox[name="purpose_check"]').click();
                }
            });


            // 시도별 매장목록 조회
            function getSidoStoreList(sidoCode) {
                var url = '/front/visit/store-list';
                var hearingAidYn = hearingAidChk();
                if (hearingAidYn != "Y") {
                    hearingAidYn = "";
                }

                if ('${isHa}' == 'Y') hearingAidYn = 'Y';

                var erpItmCode = "";
                $('input[name="erpItmCode"]').each(function () {
                    if (erpItmCode != "") erpItmCode += ",";
                    if ($(this).val() != "") erpItmCode += $(this).val();
                });

                var param = {sidoCode: sidoCode, hearingAidYn: hearingAidYn, erpItmCode: erpItmCode};

                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var address = [];
                    // 취득결과 셋팅
                    jQuery.each(result.strList, function (idx, obj) {
                        var addr = obj.addr1 || ' ' || obj.addr2;
                        var strCode = obj.strCode;
                        var strName = obj.strName;
                        address.push({"address": addr, "storeNo": strCode, "storeNm": strName});
                    });

                    searchSidoGeoByAddr(address);
                });
            }


            // 년월 변경
            function convertYm(date) {
                var date = new Date(date);
                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + month;
            }

            // 날짜 변경
            function convertDate(date) {
                var date = new Date(date);
                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + "-" + month + "-" + day;
            }


            function getTimeTable() {
                var url = '/front/visit/time-table';
                var param = $('#form_id_update').serializeArray();
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    if (result.success) {
                        Dmall.LayerUtil.alert("회원정보가 성공적으로 변경되었습니다.", "알림");
                        location.href = "/front/member/information-update-form";
                    }
                });
            }

            // 매장목록 가져오기
            function getDefaultStoreList(sidoCode) {
                var url = '/front/visit/store-list';
                var hearingAidYn = hearingAidChk();
                if (hearingAidYn != "Y") {
                    hearingAidYn = "";
                }

                if ('${isHa}' == 'Y') hearingAidYn = 'Y';

                var erpItmCode = "";
                $('input[name="erpItmCode"]').each(function () {
                    if (erpItmCode != "") erpItmCode += ",";
                    if ($(this).val() != "") erpItmCode += $(this).val();
                });

                var param = {sidoCode: sidoCode, hearingAidYn: hearingAidYn, erpItmCode: erpItmCode};
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    Dmall.LayerUtil.alert(result.strList.length, "확인");
                    var addr = [];
                    searchGeoByAddr()
                });
            }

            function today() {
                var date = new Date();
                var year = date.getFullYear();
                var month = date.getMonth() + 1; // 0부터 시작하므로 1더함 더함
                var day = date.getDate();

                if (("" + month).length == 1) {
                    month = "0" + month;
                }
                if (("" + day).length == 1) {
                    day = "0" + day;
                }

                return year + "" + month + "" + day;
            }

            function dayOfWeek(strDate) {
                var week = ['(일)', '(월)', '(화)', '(수)', '(목)', '(금)', '(토)'];
                var dayOfWeek = week[new Date(strDate).getDay()];
                return dayOfWeek;
            }

            /** 매장별 휴일 가져오기  **/
            function getHoliday(storeCode, targetYM) {

                //매장
                if (storeCode == '') {
                    Dmall.LayerUtil.alert("매장을 선택해 주세요.", "확인");
                    return false;
                }
                //날짜
                if (targetYM == '') {
                    Dmall.LayerUtil.alert("예약 년월이 없습니다.", "확인");
                    return false;
                }

                var url = '/front/visit/store-holiday';
                var param = {storeCode: storeCode, targetYM: targetYM};
                Dmall.AjaxUtil.getJSON(url, param, function (result) {
                    var holiday = "";
                    eventData.length = 0;
                    jQuery.each(result.holidayList, function (idx, obj) {

                        holiday = targetYM.substring(0, 4) + "-" + targetYM.substring(4, 6) + "-" + pad(obj);

                        eventData.push({
                            className: 'visit_disabled',  /* 예약불가 */
                            start    : holiday,
                            end      : holiday
                        });
                    });

                    var CAL = $('#calendar').fullCalendar('getCalendar');
                    $('#calendar').fullCalendar('removeEvents', function(event) {
                        return event.className = "visit_abled";
                    });
                    CAL.addEventSource(eventData);

                    getDlvrExpectDays(new Date().getDate(), result.holidayList);


                    <%-- 프로모션 기간 표시 --%>
                    if (isPromotion) {
                        if (!isPromotion) return;

                        var CAL = $('#calendar').fullCalendar('getCalendar');
                        var teanseaonDate = [];

                        let end = new Date(promotion.bookingTerm[1]);
                        end.setDate(end.getDate() + 1);
                        teanseaonDate.push({
                            start: promotion.bookingTerm[0].format('yyyy-MM-dd'),
                            end: end.format('yyyy-MM-dd'),
                            color: "#99CCFF",
                            rendering: "background"
                        });

                        CAL.addEventSource(teanseaonDate);

                        $("#teanseonInfo").show();
                    } else {
                        $("#teanseonInfo").hide();
                    }
                });
            }

            // 최소 배송일 구하기, 최소 배송일 이전에는 예약 불가능
            function getDlvrExpectDays(date, holidayList) {
                <%--
                김학훈 부장 요청 사항:

                최소 배송일 구하기 ex)
                예를들어, 오늘 월요일(9일) 마켓에서
                상품예약 시에는 목요일(12)부터
                매장 방문 가능도록 설정되어야
                합니다. +3일 기준으로 설정(주말
                포함 시 +5일)

                최소 배송일에 공휴일, 매장휴일 날자가 있다면 휴일 날자만큼 더하여 최소 배송일을 구한다.
                --%>

                var rtnDays = 0;
                holidayList = !holidayList? []: holidayList;


                if($('[name=dlvrExpectDays]').length) {


                    //최소 배송일 구하기
                    var tmpDays = 100;
                    $('[name=dlvrExpectDays]').each(function () {
                        var days = Number($(this).val());
                        if (days <= tmpDays) {
                            tmpDays = days;
                        }
                    });
                    rtnDays = tmpDays;

                    let date = new Date();
                    let holiday;
                    for (var i = 0; i < rtnDays; i++) {
                        if (holidayList.indexOf(date.getDate().toString()) > -1 || [0, 6].indexOf(date.getDay())  > -1) {
                            i--;
                        }
                        date.setDate(date.getDate() + 1);
                        holiday = date.format('yyyy-MM-dd');
                    }

                    date.setDate(date.getDate() + 1);
                    while([0, 6].indexOf(date.getDay()) > -1){
                        date.setDate(date.getDate() + 1);
                        holiday = date.format('yyyy-MM-dd');
                    }

                    eventData.push({
                        className: 'visit_delivery_disabled',  /* 예약불가 */
                        start    : new Date().format('yyyy-MM-dd'),
                        end      : holiday,
                        color: "#FFA0A0",
                        rendering: "background"
                    });
                    $('#calendar').fullCalendar('getCalendar').addEventSource(eventData);
                }
                return rtnDays;
            }

            function pad(n) {
                n = n + '';
                return n.length >= 2 ? n : new Array(2 - n.length + 1).join('0') + n;
            }


            // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다
            function searchGeoByAddrByMap3(address) {
                // 주소-좌표 변환 객체를 생성합니다
                var geocoder = new daum.maps.services.Geocoder();
                var bounds = new daum.maps.LatLngBounds();
                var positions = [];   // 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다

                // 주소로 좌표를 검색합니다
                if (address != null) {
                    address.forEach(function (item, index, array) {
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
                                    map     : map3,
                                    position: coords
                                });

                                // 인포윈도우로 장소에 대한 설명을 표시합니다
                                var infowindow = new daum.maps.InfoWindow({
                                    content  : '<div style="width:150px;text-align:center;padding:6px 0;">' + item.storeNm + '</div>',
                                    removable: true

                                });

                                // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
                                map3.setBounds(bounds);
                            }
                        });

                    });
                }
            };

        </script>
    </t:putAttribute>


    <t:putAttribute name="content">
        <!--- 마이페이지 메인 --->
        <c:if test="${member_info ne null}">
            <!--- 마이페이지 category header 메뉴 --->
            <%@ include file="include/mypage_category_menu.jsp" %>
            <!---// 마이페이지 category header 메뉴 --->
        </c:if>
        <!--- 02.LAYOUT: 마이페이지 --->
        <div class="mypage_middle">
            <c:if test="${member_info ne null}">
                <!--- 마이페이지 왼쪽 메뉴 --->
                <%@ include file="include/mypage_left_menu.jsp" %>
                <!---// 마이페이지 왼쪽 메뉴 --->
            </c:if>
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div id="mypage_content" <c:if test="${member_info eq null}">
                style="float: none;margin: 0 auto;"
            </c:if>>
                <c:if test="${member_info ne null}">
                    <!--- 마이페이지 탑 --->
                    <%@ include file="include/mypage_top_menu.jsp" %>
                </c:if>
                <form name="frmVisitBook" id="frmVisitBook" method="post" action="">
                    <input type="hidden" name="refererType" value="${refererType}"/>
                    <input type="hidden" name="eventGubun"/>
                    <input type="hidden" name="memberYn" value="${memberYn}"/>

                    <div class="mypage_body">
                        <h3 class="my_tit">방문예약</h3>

                        <c:choose>
                            <c:when test="${fn:length(visionChk) gt 0}">
                                <h4 class="my_stit">예약하실 ${vision[1]} 정보입니다.</h4>
                                <div class="lens_recomm">
                                    <p class="recomm_text"><em>${vision[2]}</em> 관련 활동을 많이 하시는</p>
                                    <p class="recomm_text"><c:if test="${fn:trim(vision[0]) eq 'G' || fn:trim(vision[0]) eq 'C'}"><em>${vision[3]}</em>의 </c:if><b>${user.session.memberNm}</b> 고객님께 추천해 드리는 ${vision[1]}입니다.</p>
                                    <c:set var="lenz" value="${fn:split(vision[4],',')}"/>
                                    <div class="keyword_area">
                                        <c:forEach var="len" items="${lenz}" varStatus="g">
                                            <span style="width:auto; height:auto; padding:0px 13px;">${len}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${ordCnt > 0}">
                                    <h4 class="my_stit">예약중인 상품이 <em>${ordCnt}</em>있습니다.</h4>
                                    <table class="tCart_Board">
                                        <caption>
                                            <h1 class="blind">사전예약 목록입니다.</h1>
                                        </caption>
                                        <colgroup>
                                            <col style="width:120px">
                                            <col style="">
                                            <col style="width:100px">
                                            <col style="width:130px">
                                            <col style="width:100px">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th></th>
                                            <th>상품정보</th>
                                            <th>수량</th>
                                            <th>상품금액</th>
                                            <th>할인금액</th>
                                            <th>구분</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <%--<c:set var="teanseonMiniYn" value="N"/>--%>
                                        <c:set var="tse07" value=""/>
                                        <c:set var="tse08" value=""/>
                                        <c:set var="tse09" value=""/>
                                        <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
                                            <c:set var="addOptArr" value=""/>
                                            <tr>
                                                <td class="noline">
                                                    <div class="cart_img">
                                                        <img src="${_IMAGE_DOMAIN}${orderGoodsList.imgPath}">
                                                    </div>
                                                </td>
                                                <td class="textL vaT">
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
                                                                (+<fmt:formatNumber value="${goodsAddOptionList.addOptBuyQtt*goodsAddOptionList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)
                                                            </p>
                                                            <c:if test="${addOptArr ne ''}">
                                                                <c:set var="addOptArr" value="${addOptArr}*"/>
                                                            </c:if>
                                                            <c:set var="addOptArr" value="${addOptArr}${goodsAddOptionList.addOptNo}^${goodsAddOptionList.addOptDtlSeq}^${goodsAddOptionList.addOptBuyQtt}"/>
                                                        </c:forEach>
                                                    </c:if>
                                                </td>
                                                <td><fmt:formatNumber value="${orderGoodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                                                <td>
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
                                                    <c:set var="dcPrice" value="${prmtDcPrice+memberGradeDcPrice}"/>
                                                    <span class="price"><fmt:formatNumber value="${orderGoodsList.saleAmt * orderGoodsList.ordQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
                                                </td>
                                                <td>
                                                    <span class="discount">-<fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
                                                </td>
                                                <td>
                                                    <span class="label_reservation">예약전용</span>
                                                </td>
                                            </tr>
                                            <input type="hidden" name="goodsTypeCd" value="${orderGoodsList.goodsTypeCd}">
                                            <input type="hidden" name="goodsNo" value="${orderGoodsList.goodsNo}">
                                            <input type="hidden" name="goodsNm" value="${orderGoodsList.goodsNm}">
                                            <input type="hidden" name="itemNo" value="${orderGoodsList.itemNo}">
                                            <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                                            <input type="hidden" name="itemArr" value="${orderGoodsList.goodsNo}▦${orderGoodsList.itemNo}^${orderGoodsList.ordQtt}^${orderGoodsList.dlvrcPaymentCd}▦${addOptArr}▦${orderGoodsList.ctgNo}">
                                            <input type="hidden" name="erpItmCode" value="${orderGoodsList.erpItmCode}">
                                            <input type="hidden" name="dlvrExpectDays" value="${orderGoodsList.dlvrExpectDays}"/>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>

                                <h4 class="my_stit top_margin">
                                    방문 목적을 선택해 주세요. <span>(중복 선택 가능)</span>
                                </h4>
                                <c:choose>
                                    <%-- 프로모션 --%>
                                    <c:when test="${orderInfo.data.exhibitionYn eq 'Y' && ch ne ''}">
                                        <div class="myvisit_purpose">
                                            <code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check" usrDfn1Val="Y" etc=" - <b>${prmtNm}</b>" />
                                            <input type="hidden" name="exhibitionYn" value="Y"/>
                                        </div>
                                    </c:when>

                                    <c:when test="${orderInfo.data.exhibitionYn eq 'Y'}">
                                        <div class="myvisit_purpose">
                                            <code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check" usrDfn2Val="Y" etc=" - <b>${prmtNm}</b>"/>
                                            <input type="hidden" name="exhibitionYn" value="Y"/>
                                        </div>
                                    </c:when>

                                    <c:when test="${ordCnt > 0}">
                                        <div class="myvisit_purpose">
                                            <code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check" usrDfn2Val="Y" etc=""/>
                                            <input type="hidden" name="rsvOnlyYn" value="Y"/>
                                        </div>
                                    </c:when>

                                    <c:when test="${orderInfo.data.preGoodsYn eq 'Y'}">
                                        <div class="myvisit_purpose">
                                            <code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check" usrDfn4Val="Y" etc=""/>
                                            <input type="hidden" name="rsvOnlyYn" value="Y"/>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check" usrDfn3Val="Y"/>--%>
                                        <input type="hidden" name="exhibitionYn" value="N" />
                                        <!-- 방문목적 선택 -->
                                        <ul class="visit_type_new" id="purpose">
                                            <li data-purpose="01" data-purpose-nm="상담(검사)">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_01.png" alt="상담(검사)">
                                                <span>상담(검사)</span>
                                            </li>
                                            <li data-purpose="02" data-purpose-nm="일반 안경">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_02.png" alt="일반 안경">
                                                <span>일반 안경</span>
                                            </li>
                                            <li data-purpose="03" data-purpose-nm="누진 안경">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_03.png" alt="누진 안경">
                                                <span>누진 안경</span>
                                            </li>
                                            <li data-purpose="04" data-purpose-nm="콘택트렌즈">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_04.png" alt="콘택트렌즈">
                                                <span>콘택트렌즈</span>
                                            </li>
                                            <li data-purpose="05" data-purpose-nm="기타">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_05.png" alt="기타">
                                                <span>기타</span>
                                            </li>
                                            <li data-purpose="06" data-purpose-nm="재구매(매장)">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_06.png" alt="재구매(매장)">
                                                <span>재구매(매장)</span>
                                            </li>
                                        </ul>
                                        <!--// 방문목적 선택 -->

                                        <!-- 방문목적 선택 후 메뉴 -->
                                        <ul class="visit_type_new option" id="purpsoe_option" style="display: none;">
                                            <li style="width:50%">
                                                <img src="${_SKIN_IMG_PATH}/mypage/visit_check_07.png" alt="선택상세보기">
                                                <span>선택상세보기</span>
                                            </li>
                                            <li style="width:50%">
                                                <a href="/front/vision2/vision-check">
                                                    <img src="${_SKIN_IMG_PATH}/mypage/visit_check_08.png" alt="내 눈에 맞는 추천">
                                                </a>
                                                <span>내 눈에 맞는 추천</span>
                                            </li>
                                        </ul>
                                        <!--// 방문목적 선택 후 메뉴 -->

                                        <!-- 상담(검사) -->
                                        <div class="visit_check_area" id="visit_check_area_01" style="display: none;">
                                                <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check_01" usrDfn5Val="01" />--%>
                                            <input type="checkbox" name="purpose_check" id="purpose_check_01_01" value="08" class="order_check">
                                            <label for="purpose_check_01_01"><span></span>일반 검사</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_01_02" value="09" class="order_check">
                                            <label for="purpose_check_01_02"><span></span>정밀 검사</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_01_03" value="10" class="order_check">
                                            <label for="purpose_check_01_03"><span></span>상담</label>
                                        </div>
                                        <!--// 상담(검사) -->

                                        <!-- 일반안경 -->
                                        <div class="visit_check_area" id="visit_check_area_02" style="display: none;">
                                                <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check_02" usrDfn5Val="02" />--%>
                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_01" value="11" class="order_check">
                                            <label for="purpose_check_02_01"><span></span>블루라이트차단</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_02" value="12" class="order_check">
                                            <label for="purpose_check_02_02"><span></span>변색</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_03" value="13" class="order_check">
                                            <label for="purpose_check_02_03"><span></span>착색안경</label><br>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_04" value="14" class="order_check">
                                            <label for="purpose_check_02_04"><span style="margin-left:0"></span>일반안경</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_05" value="15" class="order_check">
                                            <label for="purpose_check_02_05"><span></span>시력보호용</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_02_06" value="16" class="order_check">
                                            <label for="purpose_check_02_06"><span></span>근용안경</label>
                                        </div>

                                        <!-- 누진안경-->
                                        <div class="visit_check_area" id="visit_check_area_03" style="display: none;">
                                                <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check_03" usrDfn5Val="03" />--%>
                                            <input type="checkbox" name="purpose_check" id="purpose_check_03_01" value="17" class="order_check">
                                            <label for="purpose_check_03_01"><span></span>개인맞춤누진</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_03_02" value="18" class="order_check">
                                            <label for="purpose_check_03_02"><span></span>사무용 누진</label>
                                        </div>
                                        <!--// 누진안경 -->

                                        <!-- 콘택트렌즈 -->
                                        <div class="visit_check_area" id="visit_check_area_04" style="display: none;">
                                                <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check_04" usrDfn5Val="04" />--%>
                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_01" value="19" class="order_check">
                                            <label for="purpose_check_04_01"><span></span>컬러렌즈</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_02" value="20" class="order_check">
                                            <label for="purpose_check_04_02"><span></span>팩렌즈</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_03" value="21" class="order_check">
                                            <label for="purpose_check_04_03"><span></span>난시교정렌즈</label><br>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_04" value="22" class="order_check">
                                            <label for="purpose_check_04_04"><span style="margin-left:0"></span>멀티포컬렌즈</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_05" value="23" class="order_check">
                                            <label for="purpose_check_04_05"><span></span>일반콘택트</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_04_06" value="24" class="order_check">
                                            <label for="purpose_check_04_06"><span></span>샘플예약</label>
                                        </div>
                                        <!--// 콘택트렌즈 -->

                                        <!-- 기타 -->
                                        <div class="visit_check_area" id="visit_check_area_05" style="display: none;">
                                                <%--<code:checkboxNew name="purpose_check" codeGrp="VISIT_PURPOSE_CD" idPrefix="purpose_check_05" usrDfn5Val="05" />--%>
                                            <input type="checkbox" name="purpose_check" id="purpose_check_05_01" value="25" class="order_check">
                                            <label for="purpose_check_05_01"><span></span>피팅</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_05_02" value="26" class="order_check">
                                            <label for="purpose_check_05_02"><span></span>불편상담</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_05_03" value="27" class="order_check">
                                            <label for="purpose_check_05_03"><span></span>AS</label>

                                            <input type="checkbox" name="purpose_check" id="purpose_check_05_04" value="28" class="order_check">
                                            <label for="purpose_check_05_04"><span></span>선글라스</label>
                                        </div>

                                        <!--// 체크박스 타입 05 -->
                                    </c:otherwise>
                                </c:choose>
                                <div class="visit_comment">안경렌즈 또는 콘택트렌즈 구매 희망시, 본인의 시력정보를 알고 계시다면 방문접수 '요청사항'란에 좌/우 시력정보를 입력해 주세요. <br>&nbsp; &nbsp; &nbsp; 보다 빠르게 준비해 드리겠습니다.</div>


                            </c:otherwise>
                        </c:choose>

                        <h4 class="my_stit top_margin">방문하실 매장을 선택해 주세요.
                            <c:if test="${member_info ne null}">
                                <p class="myshop_check">
                                    <input type="checkbox" class="order_check" id="my_shop">
                                    <label for="my_shop"><span></span>내 단골매장에서 받기</label>
                                    <input type="hidden" id="my_shop_no" value="${member_info.data.customStoreNo}">
                                </p>
                            </c:if>
                        </h4>
                        <table class="tCart_Insert myshop">
                            <caption>방문 매장 정보 입력폼입니다.</caption>
                            <colgroup>
                                <col style="width:145px">
                                <col>
                            </colgroup>
                            <tbody>
                            <tr>
                                <td colspan="2">
                                    <select id="sel_sidoCode">
                                        <option value="">시/도</option>
                                        <c:forEach items="${codeListModel}" var="list">
                                            <option value="${list.dtlCd}">${list.dtlNm}</option>
                                        </c:forEach>
                                    </select>
                                    <select id="sel_guGunCode">
                                        <option value="">구/군</option>
                                    </select>
                                    <input type="text" id="searchStoreNm" name="searchStoreNm" onkeydown="if(event.keyCode == 13){$('#btn_search_store').click();}">
                                    <button type="button" class="btn_form" id="btn_search_store">검색</button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div id="map" style="width:100%;height:400px;"></div>
                                    <%@ include file="../order/map/mapApi.jsp" %>
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
                            </tbody>
                        </table>

                        <h4 class="my_stit top_margin">방문희망 일시를 선택해 주세요.</h4>
                        <p class="visit_warning">
                            ※ 최상의 예약 상품 준비/검수를 위하여 평균 3일(주말, 공휴일 제외)의 기간이 소요됩니다.<br>
                            ※ 시간대별 예상혼잡도를 참조하여 방문시간을 선택해 주세요.
                        </p>
                        <div class="visit_day_area02">
                            <div class="left">
                                <div class="select_calendar_area">
                                    <!-- full calendar -->
                                    <div id="calendar"></div>
                                    <!--// full calendar -->
                                </div>
                                <p class="calendar_bottom">
                                    <span class="won_disabled"></span>예약불가
                                    <span id="teanseonInfo" style="display:none;"><span class="won_disabled" style="background:#99CCFF;"></span>예약가능</span>
                                </p>

                            </div>
                            <div class="right">
                                <div class="time_table_area">
                                    <div class="tit" id="storeTitle"></div>
                                    <div>
                                        <ul class="time_table_list">
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="bottom">
                                <div class="tit">
                                    방문예약신청
                                </div>
                                <table class="tCart_Insert">
                                    <caption>방문예약신청 정보 입력폼입니다.</caption>
                                    <colgroup>
                                        <col style="width:15%">
                                        <col style="width:35%">
                                        <col style="width:15%">
                                        <col style="width:35%">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th><span class="dot">고객명</span></th>
                                        <td>
                                            <c:if test="${member_info ne null}">
                                                <input type="hidden"  name="nomemberNm" pattern="[a-zA-Z가-흻]{2,10}" value="${user.session.memberNm}">
                                                ${user.session.memberNm}
                                            </c:if>
                                            <c:if test="${member_info eq null}">
                                                <input type="text"  name="nomemberNm" maxlength="10" value="${nomemberNm}">
                                            </c:if>
                                        </td>
                                        <th class="vaT" rowspan="3"><span class="dot">요청사항</span></th>
                                        <td class="vaT" rowspan="3">
                                            <textarea class="form_needs" name="reqMatr" id="reqMatr"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span class="dot">연락처</span></th>
                                        <td>
                                        <c:if test="${member_info ne null}">
                                            <input type="text"  name="nomobile" maxlength="11"  value="${fn:replace(user.session.mobile, '-', '')}">
                                        </c:if>
                                        <c:if test="${member_info eq null}">
                                            <input type="text"  name="nomobile" maxlength="11" value="${fn:replace(user.session.mobile, '-', '')}">
                                        </c:if>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span class="dot">날짜</span></th>
                                        <td><span id="visitDate"></span>
                                            <input type="hidden" name="rsvDate"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span class="dot">시간</span></th>
                                        <td>
                                            <input type="hidden" name="rsvTime"/>
                                            <select id="sel_visitTime">
                                            </select>
                                        </td>
                                        <th class="vaT"><span class="dot">방문목적</span></th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fn:length(visionChk) gt 0}">
                                                    <span id="visitPurpose">▶추천렌즈예약:${fn:substring(visionChk,3,fn:length(visionChk))}</span>
                                                    <input type="hidden" name="visitPurposeCd"/>
                                                    <input type="hidden" name="visitPurposeNm" value="▶추천렌즈예약:${fn:substring(visionChk,3,fn:length(visionChk))}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span id="visitPurpose"></span>
                                                    <input type="hidden" name="visitPurposeCd"/>
                                                    <input type="hidden" name="visitPurposeNm"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span class="dot">검사필요여부</span></th>
                                        <td>
                                            <input type="radio" id="checkupYn_y" name="checkupYn" value="Y" checked="checked">
                                            <label for="checkupYn_y" style="margin-right:10px">
                                                <span></span>
                                                예
                                            </label>
                                            <input type="radio" id="checkupYn_n" value="N" name="checkupYn">
                                            <label for="checkupYn_n">
                                                <span></span>
                                                아니요
                                            </label>
                                        </td>

                                        <th class="vaT"><span class="dot">매장</span></th>
                                        <td><span id="visitStore"></span></td>
                                    </tr>
                                    </tbody>
                                </table>
                                <div>
                                    <div class="btn_area">
                                        <button type="button" class="btn_go_receipt" onclick="return gtag_report_conversion('/front/visit/visit-rsv-regist')">접수하기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
            <!--// content -->
            <div id="div_store_detail_popup" style="display:none;">
                <div id="map3"></div>
            </div>

        </div>
        <!---// 02.LAYOUT: 마이페이지 --->

    </t:putAttribute>
</t:insertDefinition>

