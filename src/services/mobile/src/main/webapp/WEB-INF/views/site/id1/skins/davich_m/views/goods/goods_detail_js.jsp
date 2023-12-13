<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script>
    fbq('track', 'ViewContent', {
        content_ids : ['${goodsInfo.data.goodsNo}'],
        content_type: 'product',
        value       : '${goodsInfo.data.salePrice}',
        currency    : 'KRW'
    });
</script>
<!-- Event snippet for 장바구니 conversion page In your html page, add the snippet and call gtag_report_conversion when someone clicks on the chosen link or button. -->
<script>
    function gtag_report_conversion(url) {
        var callback = function () {
            if (typeof(url) != 'undefined') { [removed] = url; }
        };
        gtag('event', 'conversion', { 'send_to': 'AW-774029432/25yACNjhuZEBEPiAi_EC', 'value': ${goodsInfo.data.salePrice}, 'currency': 'KRW', 'event_callback': callback });
        return false;
    }
</script>
<script>
    var cate1 = "홈";
    <c:forEach var="navigationList" items="${navigation}" varStatus="status">
    cate1+="/${navigationList.ctgNm}";
    </c:forEach>

    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-128559357-1');
    ga('require', 'ec');

    ga('ec:addProduct', {
        'id': '${goodsInfo.data.goodsNo}', //상품번호
        'name': '${goodsInfo.data.goodsNm}', //상품명
        'category': '${cate1}', //카테고리
        'brand': '${goodsInfo.data.brandNm}', //브랜드명
        'variant': '' //색상 또는 옵션값
    });

    ga('ec:setAction', 'detail');
    ga('send', 'pageview'); // Send product details view with the initial pageview.

    // Called when a product is added to a shopping cart.
    function addToCart(product) {
        ga('ec:addProduct', {
            'id': product.id,                        //상품번호
            'name': product.name,               //상품명
            'category': product.category,       //카테고리
            'brand': product.brand,              //브랜드명
            'variant': product.variant,            //색상 또는 옵션값
            'price': product.price,                //상품 가격
            'quantity': product.qty               //상품 수량
        });
        ga('ec:setAction', 'add');
        ga('send', 'event', 'UX', 'click', 'add to cart');     // Send data using an event.
    }
</script>

<!-- Enliple Shop Log Tracker v3.5 start -->
<script type="text/javascript">
    <!--
    function mobRfShop(){
        var sh = new EN();
        // [상품상세정보]

        sh.setData("sc", "3075c5a7692f80d15b51b02d3853c17f");
        sh.setData("userid", "davich2");
        sh.setData("pcode", "${goodsInfo.data.goodsNo}");
        sh.setData("price", "<fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>");
        sh.setData("pnm", encodeURIComponent(encodeURIComponent("${goodsInfo.data.goodsNm}")));
        <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
        <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
        <c:if test="${imgDtlList.goodsImgType eq '02'}">
        sh.setData("img", encodeURIComponent("http://www.davichmarket.com/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}"));
        </c:if>
        </c:forEach>
        </c:forEach>

        sh.setData("dcPrice", "${dcPrice}"); // 옵션
        <c:if test="${goodsStatus eq '02'}">
        sh.setData("soldOut", "1"); //옵션 1:품절,2:품절아님
        </c:if>
        <c:if test="${goodsStatus ne '02'}">
        sh.setData("soldOut", "2"); //옵션 1:품절,2:품절아님
        </c:if>
        //sh.setData("mdPcode", "추천상품코드1,추천상품코드2,…"); //옵션

        sh.setData("cate1", encodeURIComponent(encodeURIComponent(cate1))); //옵션
        sh.setSSL(true);
        sh.sendRfShop();

        // 장바구니 버튼 클릭 시 호출 메소드(사용하지 않는 경우 삭제)
        document.getElementById("btn_go_cart").onmouseup = sendCart;
        function sendCart() {
            sh.sendCart();
        }
        // 찜,Wish 버튼 클릭 시 호출 메소드(사용하지 않는 경우 삭제)
        document.getElementById("btn_favorite_go").onmouseup = sendWish;
        function sendWish() {
            sh.sendWish();
        }
    }
    //-->
</script>
<script src="https://cdn.megadata.co.kr/js/en_script/3.5/enliple_min3.5.js" defer="defer" onload="mobRfShop()"></script>
<!--// Enliple Shop Log Tracker v3.5 end  -->

<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
    //최근본상품등록
    function setLatelyGoods() {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
        var LatelyGoods = getCookie('LATELY_GOODS');
        var arr_goods = LatelyGoods? LatelyGoods.split('||') :[];//상품구분
        var goods_cnt = arr_goods.length;
        var thisItem='${goodsInfo.data.goodsNo}'+"@"+'${goodsInfo.data.goodsNm}'+"@"+'${goodsInfo.data.latelyImg}'+"@"+'${goodsInfo.data.salePrice}';
        var itemCheck='${goodsInfo.data.goodsNo}';
        if (thisItem){
            if(goods_cnt > 15){
                // 마지막 상품 쿠키삭제
                arr_goods.splice(goods_cnt-2,1);
                LatelyGoods = arr_goods.join('||');
            }

            if (LatelyGoods != "" && LatelyGoods != null) {
                if (LatelyGoods.indexOf(itemCheck) !=-1 ){ //값이 있으면 삭제 후 최근상품 다시 세팅
                    LatelyGoods = delLatlyGoods(itemCheck);
                }
                setCookie('LATELY_GOODS',thisItem+"||"+LatelyGoods,expdate);

            } else {
                if (LatelyGoods == "" || LatelyGoods == null) {
                    setCookie('LATELY_GOODS',thisItem+"||",expdate);
                }
            }
        }
    }

    function delLatlyGoods(goodsNo) {
        var goods_list = getCookie('LATELY_GOODS');
        var items = goods_list? goods_list.split('||') :[];//상품구분
        var items_cnt = items.length;
        var new_items = '';
        for(var i=0; i< items_cnt-1;i++){
            if(items[i].indexOf(goodsNo) == -1){
                new_items += items[i] + '||';
            }
        }

        return new_items;
    }

    var opt = "${so.opt}";

    $(document).ready(function(){
        $.ajaxSetup({ cache: false });
        //옵션 정보 호출
        jsSetOptionInfo(0,'');
        //상품평 호출
        //ajaxReviewList();
        //상품문의 호출
        //ajaxQuestionList();
        //상품고시정보 호출
        ajaxNotifyList();
        //상품 배송/반품/환불 정보 호출
//         ajaxGoodsExtraInfo();
        //최근본상품에 담기
        setLatelyGoods();

        // 문의탭을 바로 띄우기위한 처리
        if(opt == 'inquiry'){
            $('#question_tab').click();
            ajaxQuestionList(opt);
            opt = '';
        }else if(opt == 'review'){
            $('#review_tab').click();
            ajaxReviewList(opt);
            opt = '';
        }

        //이미지 슬라이더
        $('.product_slider').bxSlider({
            auto: false,
            infiniteLoop: false
        });

        var PLslider = $('.product_list_slider01' ).bxSlider({
            controls: false,
            pager: false,
            slideWidth: '187',
            slideMargin:22,
            minSlides:3,
            maxSlides:3,
            infiniteLoop: false
        });
        $('.product_list_control01 .btn_sub_slider_prev').click(function () {
            var current = PLslider.getCurrentSlide();
            PLslider.goToPrevSlide(current) - 1;
        });
        $('.product_list_control01 .btn_sub_slider_next').click(function () {
            var current = PLslider.getCurrentSlide();
            PLslider.goToNextSlide(current) + 1;
        });

        var NLslider = $('.product_list_slider02' ).bxSlider({
            controls: false,
            pager: false,
            slideWidth: '187',
            slideMargin:22,
            minSlides:3,
            maxSlides:3,
            infiniteLoop: false
        });
        $('.product_list_control02 .btn_sub_slider_prev').click(function () {
            var current = NLslider.getCurrentSlide();
            NLslider.goToPrevSlide(current) - 1;
        });
        $('.product_list_control02 .btn_sub_slider_next').click(function () {
            var current = NLslider.getCurrentSlide();
            NLslider.goToNextSlide(current) + 1;
        });

        $(document).on('click','.my_qna_table .title td',function(){
            var article = (".my_qna_table .show");
            var myArticle =$(this).parents().next("tr");
            if($(myArticle).hasClass('hide')) {
                $(article).removeClass('show').addClass('hide');
                $(myArticle).removeClass('hide').addClass('show');
            }else {
                $(myArticle).addClass('hide').removeClass('show');
            }
        });

        $('[id^=dlvrMethodCd]').on('change',function(){
            if($(this).val() == '02') {
                $('#dlvrPaymentKindCd01').hide();
                $('#dlvrPaymentKindCd02').show();
            } else {
                $('#dlvrPaymentKindCd01').show();
                $('#dlvrPaymentKindCd02').hide();
            }
        });

        //장바구니등록
        $('#btn_go_cart').on('click', function(){
            var formCheck = false;
            formCheck = jsFormValidation();

            if(formCheck) {
                var basketPageMovYn = '${site_info.basketPageMovYn}';
                var url = '${_MOBILE_PATH}/front/basket/basket-insert';
                var param = $('#goods_form').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success){
                        if(basketPageMovYn === 'Y') {
                            Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                            /*
                                'id': product.id,                        //상품번호
                                'name': product.name,               //상품명
                                'category': product.category,       //카테고리
                                'brand': product.brand,              //브랜드명
                                'variant': product.variant,            //색상 또는 옵션값
                                'price': product.price,                //상품 가격
                                'quantity': product.qty               //상품 수량
                            * */
                            if($("[name=itemNoArr]").length>1){
                                $("li[id^=option_layer_]").each(function(){
                                    var product ={
                                        id:'${goodsInfo.data.goodsNo}'
                                        ,name:'${goodsInfo.data.goodsNm}'
                                        ,category:cate1
                                        ,brand:'${goodsInfo.data.brandNm}'
                                        ,variant:$(this).data('item-nm')
                                        ,price:$(this).find("[name=itemPriceArr]").val()
                                        ,qty:$(this).find("[name=buyQttArr]").val()
                                    };

                                    addToCart(product);
                                });
                            }else{
                                var product ={
                                    id:'${goodsInfo.data.goodsNo}'
                                    ,name:'${goodsInfo.data.goodsNm}'
                                    ,category:cate1
                                    ,brand:'${goodsInfo.data.brandNm}'
                                    ,variant:''
                                    ,price:$("[name=itemPriceArr]").val()
                                    ,qty:$("[name=buyQttArr]").val()
                                };

                                addToCart(product);

                            }
                        } else {
                            location.href = "${_MOBILE_PATH}/front/basket/basket-list";
                        }
                    } else {
                        if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                            location.href = '${_MOBILE_PATH}/front/interest/adult-restriction';
                        }
                    }
                });
            }
        });

        //계속쇼핑
        $('#btn_close_pop').on('click', function(){
            Dmall.LayerPopupUtil.close('success_basket');
        });
        //장바구니이동
        $('#btn_move_basket').on('click', function(){
            location.href = "${_MOBILE_PATH}/front/basket/basket-list";
        });

        //관심상품등록 호출
        $('.btn_check_like').off('click').on('click', function(){

            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                    },''
                );
            } else {
                var cnt = $(this).data('interest-goods-cnt');
                if(cnt > 0){
                    Dmall.LayerUtil.alert('이미 등록된 상품이 있습니다.');
                }else{
                    var url = '${_MOBILE_PATH}/front/interest/interest-item-insert';
                    var param = {goodsNo : '${goodsInfo.data.goodsNo}'};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                                location.href="${_MOBILE_PATH}/front/interest/interest-item-list";
                            })
                        }
                    });
                    if(!$(this).hasClass('active')){
                        $(this).addClass('active');
                    }
                }


            }
        });


        /* 바로구매 */
        $('#btn_go_checkout').on('click', function(){
            var memberNo =  '${user.session.memberNo}';
            var formCheck = false;
            var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';

            var dlvrMethod = $('[name=dlvrMethodCd]:checked').val();
            var dlvrMehtodCnt = "${dlvrMehtodCnt}";
            if(dlvrMehtodCnt != "0" && Number(dlvrMehtodCnt) > 1){
                if(dlvrMethod == null || dlvrMethod == ''){
                    Dmall.LayerUtil.alert("제품 수령방법을 선택해주세요.");
                    return false;
                }
            }

            //비회원 주문일 경우
            if (memberNo == null ||  memberNo == '' || memberNo == 'undefined') {
                // 매장픽업
                /*if (dlvrMethod == '02') {
                    Dmall.LayerUtil.confirm("비회원은 택배 수령으로만 주문 가능합니다.<br>수령방법을 변경하거나 로그인 하신 다음 주문해 주세요."
                         , function() {
                             var returnUrl = window.location.pathname+window.location.search;
                             location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl=" + returnUrl;
                    	},'','', '', '닫기', '로그인하기');
  	             	return false;
 	         	}*/
            } else {
                var dlvrMethod = $('[name=dlvrMethodCd]:checked').val();
                // 매장픽업
                if (integrationMemberGbCd == '02' && dlvrMethod == '02') {
                    Dmall.LayerUtil.alert("간편회원일 경우는 매장픽업으로 주문을 진행할수 없습니다.수령방법을 택배로 선택 후 주문해주세요.");
                    return false;
                }
            }

            formCheck = jsFormValidation(); //폼체크
            var itemArr = '';

            if(formCheck) {
                var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
                var goodsNo = '${goodsInfo.data.goodsNo}';
                var addOptArr = '';
                var dlvrMethod = $('[name=dlvrMethodCd]:checked').val(); //01:택배, 02:매장픽업
                var dlvrcPaymentCd = $('#dlvrcPaymentCd').val(); //01:무료, 02:선불, 03:착불, 04:매장픽업
                if(dlvrMethod == '02') {
                    dlvrcPaymentCd = '04';
                }
                if(multiOptYn == "Y") {
                    //아이템+추가옵션 배열 생성
                    var optionLayerCnt = $('[id^=option_layer_]').length;
                    $('[id^=option_layer_]').each(function(index){
                        itemArr = '';
                        if(itemArr != '') {
                            itemArr += '▦';
                        }
                        itemArr += goodsNo +'▦'+$(this).find('.itemNoArr').val()+'^'+$(this).find('.input_goods_no').val()+'^'+dlvrcPaymentCd+'▦';
                        if(index === optionLayerCnt - 1 ) {
                            //추가옵션 배열 생성
                            var addOptArr = '';
                            $('[id^=add_option_layer_]').each(function(index){
                                if(addOptArr != '') {
                                    addOptArr += '*';
                                }
                                addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
                            });
                            itemArr += addOptArr;
                        }
                        itemArr += '▦'+ '${so.ctgNo}';
                        $(this).find('.itemArr').val(itemArr);
                    });
                } else {
                    itemArr += goodsNo +'▦'+$('#itemNoArr').val()+'^'+$('#input_goods_no').val()+'^'+dlvrcPaymentCd+'▦';
                    //추가옵션 배열 생성
                    var addOptArr = '';
                    $('[id^=add_option_layer_]').each(function(index){
                        if(addOptArr != '') {
                            addOptArr += '*';
                        }
                        addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
                    });
                    itemArr += addOptArr + '▦';
                    itemArr += '${so.ctgNo}';
                    $('#itemArr').val(itemArr);
                }

                if (memberNo != null && memberNo != '') {
                    $('#goods_form').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/order/order-form');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                } else {
                    $('#goods_form').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/order/order-form');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                    /*$('#goods_form').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/login/member-login');
                    $('#goods_form').find('#returnUrl').val(HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/order/order-form');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();*/
                }
            }
        });

        /* 사전예약 */
        $('#btn_pre_rsv_go,#btn_rsv_go').on('click', function(e){

            // 같은 상품번호로 예약된게 있는지 체크
            var preGoodsYn = "${goodsInfo.data.preGoodsYn}";
            if(preGoodsYn == 'Y'){
                var url = '${_MOBILE_PATH}/front/goods/pre-goods-rsv-chk';
                var param = {memberNo:'${user.session.memberNo}', goodsNo:'${goodsInfo.data.goodsNo}'};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(!result.success){
                        Dmall.LayerUtil.alert('이미 예약된 상품입니다.', '','');
                        return false;
                    }else{
                        rsv_go(e.target.id);
                    }
                });
            }else{
                rsv_go(e.target.id);
            }
        });

        var teanseonOptNm ="";
        /* 옵션 레이어 추가(필수)*/
        var k = 0; //옵션레이어 순번
        $('select.select_option.goods_option').on('change',function(){

            //하위 옵션 동적 생성
            var val = $(this).find(':selected').val();
            var seq = $(this).data().optionSeq;
            jsSetOptionInfo(seq, val);

            var optAdd = true;
            $('select.select_option.goods_option').each(function(index){
                if($(this).val() == '') {
                    optAdd = false;
                    return false;
                }
            });

            //필수옵션을 모두 선택하면 레이어 생성
            if (optAdd) {


                //단품번호 조회
                var optNo1=0, optNo2=0, optNo3=0, optNo4=0, attrNo1=0, attrNo2=0, attrNo3=0, attrNo4=0;
                $('select.select_option.goods_option').each(function(index){
                    var d=$(this).data();
                    switch(d.optionSeq) {
                        case 1:
                            optNo1 = d.optNo;
                            attrNo1 = $(this).find('option:selected').val();
                            break;
                        case 2:
                            optNo2 = d.optNo;
                            attrNo2 = $(this).find('option:selected').val();
                            break;
                        case 3:
                            optNo3 = d.optNo;
                            attrNo3 = $(this).find('option:selected').val();
                            break;
                        case 4:
                            optNo4 = d.optNo;
                            attrNo4 = $(this).find('option:selected').val();
                            break;
                    }
                });

                var itemInfo = '${goodsItemInfo}';
                if (itemInfo != '') {
                    var obj = jQuery.parseJSON(itemInfo); //단품정보
                    var addLayer = true;    //레이어 추가 여부
                    var itemNo = "";    //단품번호
                    var itemNm = "";    //단품명
                    var salePrice = '${goodsInfo.data.salePrice}';  //상품가격
                    var itemPrice = 0;  //단품가격
                    var stockQtt = 0;   //재고수량
                    var promotionDcRate = '${promotionInfo.data.prmtDcValue}'; //기획전 할인율
                    var promotionDcAmt = 0; //기획전 할인금액
                    var memberNo = '${user.session.memberNo}'; //회원번호
                    var memberGradeUnitCd = '${member_info.data.dcUnitCd}'; //회원등급 할인구분
                    var memberGradeUnitValue = '${member_info.data.dcValue}'; //회원등급 할인값
                    var memberGradeDcAmt = 0; //회원등급 할인금액
                    var stockSetYn = '${goodsInfo.data.stockSetYn}'; //가용재고 설정여부
                    var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'; //가용재고판매여부
                    var availStockQtt = '${goodsInfo.data.availStockQtt}'; //가용재고 수량
                    var preGoodsYn = "${goodsInfo.data.preGoodsYn}";

                    for(var i=0; i<obj.length; i++) {
                        if(obj[i].attrNo1 == null) {
                            obj[i].attrNo1 = 0;
                        }
                        if(obj[i].attrNo2 == null) {
                            obj[i].attrNo2 = 0;
                        }
                        if(obj[i].attrNo3 == null) {
                            obj[i].attrNo3 = 0;
                        }
                        if(obj[i].attrNo4 == null) {
                            obj[i].attrNo4 = 0;
                        }

                        if(obj[i].attrNo1 == attrNo1 && obj[i].attrNo2 == attrNo2 && obj[i].attrNo3 == attrNo3 && obj[i].attrNo4 == attrNo4) {
                            itemNo = obj[i].itemNo;
                            if (obj[i].attrValue1 != null) {
                                if(itemNm != '') itemNm +=', ';
                                itemNm += obj[i].attrValue1;
                            }
                            if (obj[i].attrValue2 != null) {
                                if(itemNm != '') itemNm +=', ';
                                itemNm += obj[i].attrValue2;
                            }
                            if (obj[i].attrValue3 != null) {
                                if(itemNm != '') itemNm +=', ';
                                itemNm += obj[i].attrValue3;
                            }
                            if (obj[i].attrValue4 != null) {
                                if(itemNm != '') itemNm +=', ';
                                itemNm += obj[i].attrValue4;
                            }
                            //기획전 할인
                            if(promotionDcRate != '') {
                                promotionDcAmt = Math.floor(parseInt(obj[i].salePrice*(promotionDcRate/100))/10)*10;
                                salePrice = obj[i].salePrice - promotionDcAmt;
                            } else {
                                promotionDcAmt = 0;
                                salePrice = obj[i].salePrice;
                            }
                            //회원등급할인
                            /*
                            if(memberNo != '') {
                                if(memberGradeUnitValue != '') {
                                    if(memberGradeUnitCd == '1') { // 1: %
                                        memberGradeDcAmt = Math.floor(parseInt(salePrice*(memberGradeUnitValue/100))/10)*10;
                                        salePrice = salePrice - memberGradeDcAmt;
                                    } else { // 2:원
                                        memberGradeDcAmt = memberGradeUnitValue;
                                    }
                                    salePrice = salePrice - memberGradeDcAmt;
                                } else {
                                    memberGradeDcAmt = 0;
                                    salePrice = salePrice;
                                }
                            }
                            */

                            itemPrice = salePrice;//obj[i].salePrice;
                            stockQtt = obj[i].stockQtt;
                            itemNm += '&nbsp;&nbsp;(재고:'+commaNumber(stockQtt)+')';
                            if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                                stockQtt += Number(availStockQtt);
                            }
                            if(stockQtt <= 0) {
                                itemPrice = 0;
                            }
                        }
                    }



                    if($('.itemNoArr').length > 0) {
                        $('.itemNoArr').each(function(index){
                            if($(this).val() == itemNo) {
                                $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                                addLayer = false;

                                var seq = $(this).parents('li').attr('id').replace('option_layer_','');
                                //옵션 레이어 금액 셋팅(총금액 포함)
                                jsSetOptionLayerPrice('opt', seq, itemPrice);
                            }
                        });
                    }

                    //텐션샘플렌즈 별도 조건처리..
                    if('${goodsInfo.data.goodsNo}' == 'G2002141031_7301') {
                        teanseonOptNm =itemNm.split(",")[0];
                        $("li[id^=option_layer_]").each(function () {
                            if (teanseonOptNm != "" && teanseonOptNm != $(this).data("item-nm").split(",")[0]) {
                                Dmall.LayerUtil.alert('컬러는 한가지 컬러만 선택 가능합니다.');
                                addLayer = false;
                                return false;
                            }
                            teanseonOptNm = $(this).data("item-nm").split(",")[0];
                        });
                    }

                    if(addLayer) {
                        //옵션레이어 추가
                        k++;
                        var optLayer = $('.goods_plus_info02');
                        var displayYn = "";
                        if(preGoodsYn == "Y") {
                            //displayYn = "style='display:none;'";
                            //optLayer.empty();
                        }

                        var optObj = "";
                        optObj += '<li id="option_layer_'+k+'" class="product_option_list" data-item-nm="'+itemNm+'">';
                        optObj += '    <span class="title">'+itemNm+'</span>';
                        optObj += '    <p class="form">';
                        optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="1" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+itemPrice+');" '+displayYn+'>';
                        //if(preGoodsYn != "Y") {
                        optObj += '            <button type="button" class="btn_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_plus"></span></button>';
                        optObj += '            <button type="button" class="btn_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_minus"></span></button>';
                        //}
                        optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
                        optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
                        optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
                        optObj += '            <input type="hidden" name="itemArr" class="itemArr" value="">';
                        optObj += '            <input type="hidden" name="noBuyQttArr" id="noBuyQttArr" value  ="N" >';
                        optObj += '            <span class="product_option_price">';
                        if(stockQtt <= 0) {
                            optObj += '				품절';
                        } else {
                            if(preGoodsYn != "Y") {
                                optObj += '            	<em class="itemSumPriceText">'+itemPrice+'</em>원';
                            }

                        }
                        optObj += '            		<input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                        optObj += '            		<button type="button" class="btn_del" onclick="deleteLine(this);"><span class="icon_del"></span></button>';
                        optObj += '            </span>';
                        optObj += '    </p>';
                        optObj += '</li>';

                        if(optLayer.find('[id^=option_layer_]').length > 0) {
                            optLayer.find('[id^=option_layer_]').last().after(optObj);
                        } else {
                            if(optLayer.find('[id^=add_option_layer_]').length > 0) {
                                optLayer.find('[id^=add_option_layer_]').first().before(optObj);
                            } else {
                                optLayer.append(optObj);
                            }
                        }
                        //옵션 레이어 금액 셋팅(총금액 포함)
                        jsSetOptionLayerPrice('opt', k, itemPrice);
                    }

                    //옵션선택 초기화
                    jsOptionInit();
                }
            }
        });

        /* 추가옵션 레이어 추가 */
        $('select.select_option.goods_addOption').on('change',function(){

            var addOptValue, addOptAmt, addOptAmtChgCd, addOptDtlSeq, addOptNo, addOptVer;
            var addLayer = true;
            var requiredYn = $(this).data().requiredYn;
            var preGoodsYn = "${goodsInfo.data.preGoodsYn}";
            if($(this).find(':selected').val() != '') {
                $(this).find(':selected').each(function(){
                    var d = $(this).data();
                    addOptValue = d.addOptValue;
                    addOptAmt = d.addOptAmt;
                    addOptAmtChgCd = d.addOptAmtChgCd;
                    addOptDtlSeq = d.addOptDtlSeq;
                    addOptVer = d.addOptVer;
                });
                addOptNo = $(this).data().addOptNo;

                if(addOptAmtChgCd == '1') {
                    addOptAmt = addOptAmt * 1
                } else {
                    addOptAmt = addOptAmt * (-1)
                }

                if($('.addOptDtlSeqArr').length > 0) {
                    $('.addOptDtlSeqArr').each(function(index){
                        if($(this).val() == addOptDtlSeq) {
                            $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                            addLayer = false;

                            var seq = $(this).parents('li').attr('id').replace('add_option_layer_','');
                            //추가옵션 레이어 금액 셋팅(총금액 포함)
                            jsSetOptionLayerPrice('add_opt', seq, addOptAmt);
                        }
                    });
                }

                if(addLayer) {
                    //추가 옵션 레이어 추가
                    k++;
                    var optLayer = $('.goods_plus_info02');
                    var displayYn = "";
                    if(preGoodsYn == "Y") {
                        displayYn = "style='display:none;'";
                        /*optLayer.find('li').each(function(){
                            console.log($(this).data('add-opt-no'))
                            if($(this).data('add-opt-no') == addOptNo){
                                $(this).remove();
                            }
                        });*/
                    }

                    var optObj = "";
                    optObj += '<li id="add_option_layer_'+k+'" class="product_option_list" data-required-yn="'+requiredYn+'" data-add-opt-no="'+addOptNo+'">';
                    optObj += '    <span class="title">'+addOptValue+'</span>';
                    optObj += '    <p class="form">';
                    optObj += '            <input type="text" name="addOptBuyQttArr" class="input_goods_no" value="1" onkeyup="jsSetOptionLayerPrice(\'add_opt\', '+k+', '+addOptAmt+');" '+displayYn+'>';
                    if(preGoodsYn != "Y") {
                        optObj += '            <button type="button" class="btn_up" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'up\')">추가</button>';
                        optObj += '            <button type="button" class="btn_down" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'down\')">차감</button>';
                    }
                    optObj += '            <input type="hidden" name="addOptNoArr" class="addOptNoArr" value="'+addOptNo+'">';
                    optObj += '            <input type="hidden" name="addOptVerArr" class="addOptVerArr" value="'+addOptVer+'">';
                    optObj += '            <input type="hidden" name="addOptDtlSeqArr" class="addOptDtlSeqArr" value="'+addOptDtlSeq+'">';
                    optObj += '            <input type="hidden" name="addOptAmtArr" class="addOptAmtArr" value="'+addOptAmt+'">';
                    optObj += '            <input type="hidden" name="addOptAmtChgCdArr" class="addOptAmtChgCdArr" value="'+addOptAmtChgCd+'">';
                    optObj += '            <input type="hidden" name="addOptArr" class="addOptArr" value="">';
                    optObj += '            <input type="hidden" name="addNoBuyQttArr" id="addNoBuyQttArr" value  ="N" >';
                    optObj += '        <span class="product_option_price">';
                    optObj += '            <em class="addOptSumAmtText" '+displayYn+'></em>';
                    if(preGoodsYn != "Y") {
                        optObj += '원';
                    }
                    optObj += '            <input type="hidden" name="addOptSumAmtArr" class="addOptSumAmtArr" value="'+addOptAmt+'">';
                    optObj += '            <button type="button" class="btn_del" onclick="deleteLine(this);">삭제</button>';
                    optObj += '        </span>';
                    optObj += '    </p>';
                    optObj += '</li>';
                    optLayer.append(optObj);

                    //추가옵션 레이어 금액 셋팅(총금액 포함)
                    jsSetOptionLayerPrice('add_opt', k, addOptAmt);
                }

                //옵션선택 초기화
                $(this).val('');
                $(this).trigger('change');
            }
        });

        /* 셀렉트박스 수량 변경(옵션X) */
//         $('.input_goods_no').click(function(){
//             jsSetTotalPriceNoOpt();
//         });
        $('.input_goods_no').on('change', function(){
            jsSetTotalPriceNoOpt();
        });

        /* currency(3자리수 콤마) */
        var commaNumber = (function(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        });

        // 사은품보기 팝업
        $('#btn_gift').off('click').on('click',function (){
            Dmall.LayerPopupUtil.open($('#popup_gift_select'));
        });

        /* 배송/반품/환불 안내 */
        /* $('#btn_extra').off('click').on('click',function (){
        	$('.shopping_info_list').html($('.shopping_info_list').html().replace(/(\r\n|\n\r|\r|\n)/g, "<br>"));
        	Dmall.LayerPopupUtil.open($('#extraInfo'));
        }); */
        // 사은품보기 팝업 닫기
        $(".closepopup").click(function(){
            $.unblockUI();
        });

        $('#btn_goods_content').off('click').on('click', function(){
            $('#goods_content').removeClass('blind');
            $('#middle_area').html($('#goods_content'));
            $('.btn_go_prev').off('click').on('click',function(){
                location.href = '${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}';
            });
            window.scrollTo(0,0);
        });

        // 재입고 알림 팝업
        $('#btn_alarm_view').on('click',function (){
            var goodsNm = '${goodsInfo.data.goodsNm}';
            var url = '${_MOBILE_PATH}/front/goods/restock-pop';
            var param = {'goodsNo':'${goodsInfo.data.goodsNo}', 'goodsNm':goodsNm};
            Dmall.AjaxUtil.loadByPost(url, param, function(result) {
                $('#div_restock').html(result).promise().done(function(){
                    $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
                });
                Dmall.LayerPopupUtil.open($('#restock_pop'));
            })
        });

        /* === sns 버튼 === */
        <c:if test="${site_info.contsUseYn ne 'Y'}">
        $(".btn_view_sns, .btn_sns");off('click').on('click', function(){
            Dmall.LayerUtil.alert('이 상품은 컨텐츠 공유를 사용할 수 없습니다.');
        });
        </c:if>

        <c:if test="${promotionInfo.data.prmtTypeCd eq '06'}">
        <c:choose>
        <c:when test="${member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">

        </c:when>
        <c:otherwise>
        Dmall.LayerUtil.alert('특가상품 프로모션에 참여하실 수 없습니다.<br><br> 참여하신 이력이 없고 <br> 신규회원은 가입 후 3일,<br> 기존회원은 쿠폰 발급 후 3일 <br><br> 이내에 참여하실 수 있습니다. <br><br> ※ 상품의 정상 판매 가격으로 구매 할 수 있습니다.');
        </c:otherwise>
        </c:choose>
        </c:if>

    });

    /* 상품상세 레이어보기 */

    function rsv_go(target_id) {
        var memberNo =  '${user.session.memberNo}';
        var formCheck = false;
        var itemArr = '';

        var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
        var dlvrMethod = $('[name=dlvrMethodCd]:checked').val();

        var msg = "";

        // 사전예약
        if (target_id == "btn_pre_rsv_go") {
            msg = "사전예약";
        }
        else {  // 예약
            msg = "예약";
        }

        formCheck = jsFormValidation(); //폼체크

        if(formCheck) {
            var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
            var goodsNo = '${goodsInfo.data.goodsNo}';
            var addOptArr = '';
            var dlvrMethod = $('[name=dlvrMethodCd]').val(); //01:택배, 02:매장픽업
            var dlvrcPaymentCd = $('#dlvrcPaymentCd').val(); //01:무료, 02:선불, 03:착불, 04:매장픽업
            if(dlvrMethod == '02') {
                dlvrcPaymentCd = '04';
            }
            if(multiOptYn == "Y") {
                //아이템+추가옵션 배열 생성
                var optionLayerCnt = $('[id^=option_layer_]').length;
                $('[id^=option_layer_]').each(function(index){
                    itemArr = '';
                    if(itemArr != '') {
                        itemArr += '▦';
                    }
                    itemArr += goodsNo +'▦'+$(this).find('.itemNoArr').val()+'^'+$(this).find('.input_goods_no').val()+'^'+dlvrcPaymentCd+'▦';
                    if(index === optionLayerCnt - 1 ) {
                        //추가옵션 배열 생성
                        var addOptArr = '';
                        $('[id^=add_option_layer_]').each(function(index){
                            if(addOptArr != '') {
                                addOptArr += '*';
                            }
                            addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
                        });
                        itemArr += addOptArr;
                    }
                    itemArr += '▦'+ '${so.ctgNo}';
                    $(this).find('.itemArr').val(itemArr);
                });
            } else {
                itemArr += goodsNo +'▦'+$('#itemNoArr').val()+'^'+$('#input_goods_no').val()+'^'+dlvrcPaymentCd+'▦';
                //추가옵션 배열 생성
                var addOptArr = '';
                $('[id^=add_option_layer_]').each(function(index){
                    if(addOptArr != '') {
                        addOptArr += '*';
                    }
                    addOptArr += $(this).find('.addOptNoArr').val()+'^'+$(this).find('.addOptDtlSeqArr').val()+'^'+$(this).find('.input_goods_no').val();
                });
                itemArr += addOptArr + '▦';
                itemArr += '${so.ctgNo}';
                $('#itemArr').val(itemArr);
            }

            var clickId = target_id;
            if (clickId == "btn_pre_rsv_go") {
                $('#exhibitionYn').val('Y');
            } else if (clickId == "btn_rsv_go") {
                $('#rsvOnlyYn').val('Y');
            }
            /*$('#goods_form').attr('action',HTTPS_SERVER_URL+'${_MOBILE_PATH}/front/visit/visit-book');
            $('#goods_form').attr('method','post');
            $('#goods_form').submit();*/

            if(loginYn == 'true') {
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';

                if (integrationMemberGbCd == '02' ) {
                    Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
                        , function() {
                            var returnUrl = window.location.pathname+window.location.search;
                            location.href= "${_MOBILE_PATH}/front/member/information-update-form";
                        },'','', '', '닫기', '정회원 전환');

                    return false;
                }

                // 같은 상품번호로 예약된게 있는지 체크
                var preGoodsYn = "${goodsInfo.data.preGoodsYn}";
                var goodsNo = "${goodsInfo.data.goodsNo}";
                if(preGoodsYn == 'Y' || goodsNo =='G2104082005_8744' || goodsNo=='G2103261158_8727'){
                    var url = '${_MOBILE_PATH}/front/goods/pre-goods-rsv-chk';
                    var param = {memberNo:'${user.session.memberNo}', goodsNo:'${goodsInfo.data.goodsNo}'};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(!result.success){
                            Dmall.LayerUtil.alert('이미 예약된 상품입니다.', '','');
                            return false;
                        }else{
                            $('#goods_form').attr('action','${_MOBILE_PATH}/front/visit/visit-book');
                            $('#goods_form').attr('method','post');
                            $('#goods_form').submit();
                        }
                    });
                }else{
                    $('#goods_form').attr('action','${_MOBILE_PATH}/front/visit/visit-book');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                }
            }
        }

        function detailShow(){
            $("#desc_content").show();
            $("#tabs_content").hide();
            window.location.href = "#goods_content";

        }

        /* 상품후기조회+고객평점 */
        function ajaxReviewList(opt){
            var param = $('#form_review_search').serialize();
            if(opt == 'review') param += '&opt=review';

            var url = '${_MOBILE_PATH}/front/review/review-list-ajax?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
            Dmall.AjaxUtil.load(url, function(result) {
                /*var $review = $(result);
                var averageScore = $review.find('span.per_no').text();
                var star = $review.find('div.graph_star_groups').html();
                $('#star_area').html(star+averageScore);
                $('#star_area2').html(star+'(${goodsBbsInfo.data.reviewCount})');
        	$('#star_area2').css('margin-right', '5%');*/
                $("#desc_content").hide();
                $("#tabs_content").html(result);
                $("#tabs_content").show();
                window.location.href = "#goods_content";

            })
        }

        /* 상품문의조회 */
        function ajaxQuestionList(opt){
            var param = $('#form_question_search').serialize();
            if(opt == 'inquiry') param += '&opt=inquiry';

            var url = '${_MOBILE_PATH}/front/question/question-list-ajax?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
            Dmall.AjaxUtil.load(url, function(result) {
                /*$('#tab3').html(result);*/
                $("#desc_content").hide();
                $("#tabs_content").html(result);
                $("#tabs_content").show();
                window.location.href = "#goods_content";
            })
        }

        function shoppingInfoShow(){
            /*$('.shopping_info_list').html($('.shopping_info_list').html().replace(/(\r\n|\n\r|\r|\n)/g, "<br>"));*/
            $("#tabs_content").html($('#extraInfo').html());
            $("#desc_content").hide();
            $("#tabs_content").show();
        }

        /* 상품 고시정보 조회 */
        function ajaxNotifyList(){
            var param = 'goodsNo=${goodsInfo.data.goodsNo}&notifyNo=${goodsInfo.data.notifyNo}';
            var url = '${_MOBILE_PATH}/front/goods/notify-list?'+param;
            Dmall.AjaxUtil.load(url, function(result) {
                var tbodyResult = $(result).find('tbody').html();
                var tbodyNotify = $('#tbodyNotify').html();
                $('#tbodyNotify').html(tbodyResult+tbodyNotify);
            })
        }



        /* 쿠폰 다운로드 팝업 */
        function downloadCoupon() {
            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인을 하시면 고객님의 쿠폰이 추가 적용됩니다.",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                    },'','','','닫기','로그인'
                );
                return false;
            }else{
                var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
                if (integrationMemberGbCd == '02' ) {
                    Dmall.LayerUtil.confirm("간편회원은 사용하실 수 없습니다.<br>정회원 전환 후 이용해 주세요."
                        , function() {
                            var returnUrl = window.location.pathname+window.location.search;
                            location.href= "${_MOBILE_PATH}/front/member/information-update-form";
                        },'','', '', '닫기', '정회원 전환');
                    return false;
                }
            }

            $('#couponPop').remove();
            var couponLayerPop = "";
            var couponList = "";
            var url = '${_MOBILE_PATH}/front/coupon/coupon-download-pop';
            var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    if(result.resultList.length > 0) {
                        /*  if(result.resultList.length == 1) {
                             Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
                         } else { */

                        for(var i=0; i < result.resultList.length; i++) {
                            var couponPeriodInfo = '';//기간제한
                            var couponBnf = '';//혜택
                            var button = '';
                            if(result.resultList[i].couponApplyPeriodCd == '01') {
                                var applyStartDttm = parseDate(result.resultList[i].applyStartDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                                var applyEndDttm = parseDate(result.resultList[i].applyEndDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                                couponPeriodInfo = applyStartDttm +'<br>~'+applyEndDttm;
                            } else {
                                couponPeriodInfo = '발급일로부터 '+result.resultList[i].couponApplyIssueAfPeriod+'일'
                            }
                            if(result.resultList[i].couponBnfCd == '01') {
                                couponBnf = result.resultList[i].couponBnfValue + '% 할인(최대'+commaNumber(result.resultList[i].couponBnfDcAmt)+'원)' ;
                            }else if(result.resultList[i].couponBnfCd == '02') {
                                couponBnf = commaNumber(result.resultList[i].couponBnfDcAmt) + '원 할인' ;
                            } else {
                                couponBnf = result.resultList[i].couponBnfTxt;
                            }
                            if(result.resultList[i].issueYn == 'Y') {
                                button = '<span class="pointB">발급완료</span>';
                            } else {
                                button =' <span class="pointB"></span>';
                                button += '<button type="button" class="btn_cart_s" id="cp_btn_'+result.resultList[i].couponNo+'" onClick="issueCoupon(\''+result.resultList[i].couponNo+'\',\''+result.resultList[i].offlineOnlyYn+'\')">DOWN</button>';
                            }
                            couponList += '                    <tr class="cp_list" data-issue-yn="'+result.resultList[i].issueYn+'">';
                            couponList += '                        <td class="text11 textL">'+result.resultList[i].couponNm+'</td>';
                            couponList += '                        <td class="text11 textL">'+couponPeriodInfo+'</td>';
                            couponList += '                        <td class="textL11 textL">'+couponBnf+'</td>';
                            couponList += '                        <td>';
                            couponList +=                          button;
                            couponList += '                        </td>';
                            couponList += '                    </tr>';
                        }

                        couponLayerPop += '<div class="popup_my_shipping_address pop_front" id="couponPop" style="display:none">';
                        couponLayerPop += '    <div class="popup_header">';
                        couponLayerPop += '        <h1 class="popup_tit">쿠폰받기</h1>';
                        couponLayerPop += '        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>';
                        couponLayerPop += '    </div>';
                        couponLayerPop += '    <div class="popup_content">';
                        couponLayerPop += '        <div class="popup_address_scroll" style="height:380px;">';
                        couponLayerPop += '            <table class="tProduct_Board tb_fixed coupon_tb">';
                        couponLayerPop += '                <caption>';
                        couponLayerPop += '                    <h1 class="blind">쿠폰 목록입니다.</h1>';
                        couponLayerPop += '                </caption>';
                        couponLayerPop += '                <colgroup>';
                        couponLayerPop += '                    <col style="">';
                        couponLayerPop += '                    <col style="width:20%">';
                        couponLayerPop += '                    <col style="width:25%">';
                        couponLayerPop += '                    <col style="width:70px">';
                        couponLayerPop += '                </colgroup>';
                        couponLayerPop += '                <thead>';
                        couponLayerPop += '                    <tr>';
                        couponLayerPop += '                        <th>쿠폰명</th>';
                        couponLayerPop += '                        <th>기간제한</th>';
                        couponLayerPop += '                        <th>혜택</th>';
                        couponLayerPop += '                        <th>다운받기</th>';
                        couponLayerPop += '                    </tr>';
                        couponLayerPop += '                </thead>';
                        couponLayerPop += '                <tbody>';
                        couponLayerPop +=                  couponList;
                        couponLayerPop += '                </tbody>';
                        couponLayerPop += '            </table>';
                        couponLayerPop += '        </div>';
                        couponLayerPop += '        <div class="popup_address_top">';
                        couponLayerPop += '            <button type="button" class="btn_address_plus" onclick="issueCouponAll();">전체 다운로드</button>';
                        couponLayerPop += '        </div>';
                        couponLayerPop += '    </div>';
                        couponLayerPop += '</div>';
                        $('body').append(couponLayerPop);
                        Dmall.LayerPopupUtil.open($('#couponPop'));
                        /* } */
                    }
                } else {
                    Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
                }
            });
        }

        /* 쿠폰 건별 발급 */
        function issueCoupon(couponNo, offYn) {

            var url = '${_MOBILE_PATH}/front/coupon/coupon-issue';
            var param = {couponNo:couponNo};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('#cp_btn_'+couponNo).hide();
                    $('#cp_btn_'+couponNo).prev('.pointB').html('발급완료');
                    /*$('#cp_btn_'+couponNo).html('발급완료');*/
                    $('#cp_btn_'+couponNo).attr('onClick','');
                    $('#cp_btn_'+couponNo).parents('td').parents('tr').data().issueYn = 'Y';
                    if(offYn == 'Y'){
                        //Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다. <a href="javascript:couponPrintPop(\''+couponNo+'\');" style="text-decoration:underline;color:blue;">쿠폰보기</a>', '','');
                        Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                                couponPrintPop(couponNo);
                            },'','','','닫기','쿠폰보기'
                        );

                    }else{
                        //Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다. <a href="${_MOBILE_PATH}/front/coupon/coupon-list" style="text-decoration:underline;color:blue;">마이페이지</a>', '','');
                        Dmall.LayerUtil.confirm("쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.",
                            //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                            function() {
                                location.href= "${_MOBILE_PATH}/front/coupon/coupon-list";
                            },'','','','닫기','마이페이지'
                        );
                    }
                } else {
                    Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');
                }
            });
        }

        function couponPrintPop(couponNo) {

            var url = "${_MOBILE_PATH}/front/coupon/coupon-info-ajax";
            var param = {couponNo:couponNo};

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                    var data = result.data;

                    var endDttm = data.cpApplyStartDttm + ' ~ ' + data.cpApplyEndDttm;
                    if(data.couponApplyPeriodCd != '01'){
                        endDttm = data.couponApplyPeriodDttm;
                    }
                    var bnfDc = data.couponUseLimitAmt + '원 이상 구매시';
                    if(data.couponBnfCd == '01' && data.couponBnfDcAmt > 0){
                        bnfDc += '/ 최대 ' + data.couponBnfDcAmt + '원';
                    }
                    var dcAmt = data.couponBnfDcAmt;
                    var dcUnit = '원';
                    if(data.couponBnfCd == '01'){
                        dcAmt = data.couponBnfValue;
                        dcUnit = '%';
                    }
                    var divType = "coupon";
                    if(data.goodsTypeCd == '01') divType += " off01";
                    else if(data.goodsTypeCd == '02') divType += " off04";
                    else if(data.goodsTypeCd == '03') divType += " off03";
                    else if(data.goodsTypeCd == '04') divType += " off02";
                    else divType += " off00";
                    $('#print_div').attr('class', divType);
                    $('#print_regDttm').text(data.issueDttm);
                    $('#print_usePeriod').text(endDttm);
                    $('#print_couponNm').text(data.couponNm);
                    $('#print_useLimitAmt').text(commaNumber(bnfDc));
                    if(data.couponBnfCd != '03') {
                        $('#print_bnfValue').html('<em>' + commaNumber(dcAmt) + '</em>' + dcUnit + ' 할인');
                    }else{
                        $('#print_bnfValue').html('<em style="font-size:23px;">' + data.couponBnfTxt+'</em>');
                    }
                    $('#print_dscrt').text(data.couponDscrt);

                    var cpIssueNo = data.cpIssueNo;

                    $("#bcTarget_coupon").barcode(cpIssueNo, "code128",{barWidth:2});
                    $('#cp_issue_no').text("NO. " + cpIssueNo.substring(0,2) + "-" + cpIssueNo.substring(2,5) + "-" + cpIssueNo.substring(5,9) + "-" + cpIssueNo.substring(9,13));

                    Dmall.LayerUtil.close('div_id_alert');
                    $('#couponPop').remove();
                    Dmall.LayerPopupUtil.open($('#coupon_print_popup'));
                }
            });
        }

        /* 쿠폰 전체 발급 */
        function issueCouponAll() {
            var couponAvailCnt = 0;
            $('.cp_list').each(function(){
                var d = $(this).data();
                if(d.issueYn == 'N') {
                    couponAvailCnt++;
                }
            });
            if(couponAvailCnt > 0) {
                var url = '${_MOBILE_PATH}/front/coupon/coupon-issue-all';
                var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        /*$('[id^=cp_btn_]').html('발급완료');*/
                        $('[id^=cp_btn_]').prev('.pointB').html('발급완료');
                        $('[id^=cp_btn_]').hide();
                        $('.cp_list').each(function(){
                            var d = $(this).data();
                            if(d.issueYn == 'N') {
                                d.issueYn = 'Y';
                            }
                        });
                        Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다. <a href="${_MOBILE_PATH}/front/coupon/coupon-list" style="text-decoration:underline;color:blue;">마이페이지</a>', '','');
                    } else {
                        Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
                    }
                });
            } else {
                Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
            }
        }

        /* 상품 옵션 초기화 */
        function jsOptionInit(){
            $('select.select_option.goods_option').each(function(index){
                $(this).val('');
                $(this).trigger('change');
            });
        }

        /* 옵션 재고 확인(옵션O) */
        function jsCheckOptionStockQtt(obj) {
            var rtn = true;
            var stockSetYn = '${goodsInfo.data.stockSetYn}';
            var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}';
            var availStockQtt = '${goodsInfo.data.availStockQtt}';
            var stockQtt = $(obj).find('.stockQttArr').val();
            var optionQtt = $(obj).find('.input_goods_no').val();
            if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                stockQtt += Number(availStockQtt);
            }
            if(Number(stockQtt) >= Number(optionQtt)) {
                rtn = true;
            } else {
                rtn = false;
            }
            return rtn;
        }

        /* 옵션 레이어 구매 수량 증/감 함수(옵션O) */
        function jsUpdateLayerQtt(sort, seq, type) {
            var objId = '';
            var amtClass = '';
            if(sort == 'opt') {
                objId = 'option_layer_';
                amtClass = 'itemPriceArr';
            } else {
                objId = 'add_option_layer_';
                amtClass = 'addOptAmtArr';
            }
            var qttObj = $('#'+objId+seq).find('.input_goods_no');
            if(type == 'up') {
                qttObj.val(Number(qttObj.val())+1);
            } else if(type == 'down') {
                if(Number(qttObj.val()) > 1) {
                    qttObj.val(Number(qttObj.val())-1);
                }
            }

            //옵션 레이어 금액 변경
            var amt = $('#'+objId+seq).find('.'+amtClass).val();
            jsSetOptionLayerPrice(sort, seq, amt);
        }

        /* (추가)옵션 레이어 금액 셋팅(옵션O) */
        function jsSetOptionLayerPrice(sort, seq, amt) {
            // 옵션 수량이 0일 경우 강제로 1셋팅
            if($('input[name="buyQttArr"]').val() == '0'){
                $('input[name="buyQttArr"]').val('1');
            }

            var objId = "";
            var textClass = "";
            var amtClass = "";
            if(sort == 'opt') {
                objId= "option_layer_";
                textClass = "itemSumPriceText";
                amtClass = "itemSumPriceArr";
            } else {
                objId= "add_option_layer_";
                textClass = "addOptSumAmtText";
                amtClass = "addOptSumAmtArr";
            }
            var qtt = Number($('#'+objId+seq).find('.input_goods_no').val());
            $('#'+objId+seq).find('.'+textClass).html(commaNumber(qtt*amt));
            $('#'+objId+seq).find('.'+amtClass).val(qtt*amt);

            //총 상품금액 변경
            var multiOptYn = '${goodsInfo.data.multiOptYn}';
            if(multiOptYn == 'Y') {
                jsSetTotalPrice();
            } else {
                jsSetTotalPriceNoOpt();
            }
        }

        /* 총 상품금액 셋팅(옵션O) */
        function jsSetTotalPrice() {
            var totalPrice = 0;
            $('[id^=option_layer_]').each(function(){
                totalPrice += Number($(this).find('.itemSumPriceArr').val());
            });
            $('[id^=add_option_layer_]').each(function(){
                totalPrice += Number($(this).find('.addOptSumAmtArr').val());
            });
            $('#totalPriceText').html(commaNumber(totalPrice));
            $('#totalPrice').val(totalPrice);

            //setCouponSalePrice(totalPrice);
        }

        /* 총 상품금액 셋팅(옵션X) */
        function jsSetTotalPriceNoOpt() {
            var totalPrice = 0;
            var salePrice = Number($('.itemPriceArr').val());
            var buyQtt = Number($('.input_goods_no').val());
            totalPrice = salePrice * buyQtt;
            $('[id^=add_option_layer_]').each(function(){
                totalPrice += Number($(this).find('.addOptSumAmtArr').val());
            });
            if(totalPrice == 0) {
                totalPrice = '${goodsInfo.data.salePrice}';
            }
            $('#totalPriceText').html(commaNumber(totalPrice));
            $('#totalPrice').val(totalPrice);

            //setCouponSalePrice(totalPrice);
        }

        //쿠폰할인가 계산
        function setCouponSalePrice(totalPrice) {
            <c:if test="${fn:length(couponList) > 0}">
            var bestCouponAmt = totalPrice;	//쿠폰적용 최대할인가
            var couponAmt = 0;	//쿠폰적용 할인가

            <c:forEach var="couponList" items="${couponList}" varStatus="status">
            var couponBnfCd = "${couponList.couponBnfCd}";	//쿠폰 혜택 코드(01:할인율, 02:할인금액)
            var couponBnfValue = parseInt("${couponList.couponBnfValue}");	//쿠폰 혜택 값
            var couponBnfDcAmt = parseInt("${couponList.couponBnfDcAmt}");	//쿠폰 최대 할인 금액
            var couponUseLimitAmt = parseInt("${couponList.couponUseLimitAmt}");	//사용 제한 금액

            if(couponBnfCd == "01"){	//할인율 적용 쿠폰
                if((totalPrice - (totalPrice * (1-(couponBnfValue*1/100)))) <= couponBnfDcAmt){ //최대할인금액이 쿠폰할인가보다 클때 = 쿠폰할인가 적용
                    if(totalPrice >= couponUseLimitAmt){	//구매합계가 사용제한금액보다 큰지 확인
                        couponAmt = totalPrice * (1-(couponBnfValue*1/100))	//구매합계에서 할인율만큼 할인
                    }
                }else{	//최대할인금액이 쿠폰할인가보다 작을때 = 최대할인금액 적용
                    if(totalPrice >= couponUseLimitAmt){	//구매합계가 사용제한금액보다 큰지 확인
                        couponAmt = totalPrice - couponBnfDcAmt;	//구매합계에서 최대할인금액만큼 할인
                    }
                }
            }else{	//할인금액 적용 쿠폰
                if(totalPrice >= couponUseLimitAmt){	//구매합계가 사용제한금액보다 큰지 확인
                    couponAmt = totalPrice - couponBnfDcAmt;	//구매합계에서 할인금액만큼 할인
                }
            }
            if(bestCouponAmt > couponAmt) bestCouponAmt = couponAmt;	//현재 쿠폰의 할인가가 최대 할인가인지 비교
            </c:forEach>
            if(bestCouponAmt > 0 && bestCouponAmt < totalPrice){
                $('p.sale_price').css('display', 'block');
            }else{
                $('p.sale_price').css('display', 'none');
            }

            $('#couponSalePriceText').html(commaNumber(Math.round(bestCouponAmt)));
            </c:if>
        }

        /* 선택옵션 삭제 */
        function deleteLine(obj) {
            var goods = $(obj).parents('li');
            goods.remove();

            //총 상품금액 변경
            var multiOptYn = '${goodsInfo.data.multiOptYn}';
            if(multiOptYn == 'Y') {
                jsSetTotalPrice();
            } else {
                jsSetTotalPriceNoOpt();
            }
        }

        function commaNumber(p) {
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        }
        /* 옵션 셀렉트 박스 동적 생성 */
        function jsSetOptionInfo(seq, val) {
            $('#goods_option_'+seq).find("option").remove();

            var itemInfo = '${goodsItemInfo}';
            var standardPrice = 0;
            if(itemInfo != '') {
                var obj = jQuery.parseJSON(itemInfo); //단품정보
                var optionHtml = '<option selected="selected"  value="">선택하세요</option>';
                var preAttrNo = '';
                var selectBoxCount = $('[id^=goods_option_]').length;

                if(seq == 0) {  //최초 셀렉트박스 옵션 생성
                    //기준가격 설정
                    for(var i=0; i<obj.length; i++) {
                        if (obj[i].standardPriceYn == 'Y') {
                            standardPrice = obj[i].salePrice;
                        }
                    }
                    for(var i=0; i<obj.length; i++) {
                        /*if(obj[i].standardPriceYn=='Y'){
                            standardPrice=obj[i].salePrice;
                        }*/
                        var addPrice ="";
                        addPrice = obj[i].salePrice-standardPrice;
                        if(addPrice > 0 ){
                            addPrice = " (+"+addPrice+")";
                        }else if(addPrice < 0 ){
                            addPrice = " ("+addPrice+")";
                        }else{
                            addPrice="";
                        }
                        if(preAttrNo != obj[i].attrNo1) {
                            optionHtml += '<option value="'+obj[i].attrNo1+'">'+obj[i].attrValue1+addPrice+'</option>';
                            preAttrNo = obj[i].attrNo1;
                        }
                    }
                } else {

                    var attrNo = [];
                    for(var i=0; i<seq; i++) {
                        attrNo[i] = $('#goods_option_'+i).find(':selected').val();
                    }

                    //하위 옵션 셀렉트 박스 초기화
                    if(val == '') {
                        for(var i=seq; i<selectBoxCount; i++) {
                            $('#goods_option_'+i).find("option").remove();
                        }
                    }

                    for(var i=0; i<obj.length; i++) {
                        var len = attrNo.length;

                        if(seq==1) {
                            if(attrNo[0] == obj[i].attrNo1) {
                                if(preAttrNo != obj[i].attrNo2) {
                                    optionHtml += '<option value="'+obj[i].attrNo2+'">'+obj[i].attrValue2+'</option>';
                                    preAttrNo = obj[i].attrNo2;
                                }
                            }
                        } else if(seq==2) {
                            if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2) {
                                if(preAttrNo != obj[i].attrNo3) {
                                    optionHtml += '<option value="'+obj[i].attrNo3+'">'+obj[i].attrValue3+'</option>';
                                    preAttrNo = obj[i].attrNo3;
                                }
                            }
                        } else if(seq==3) {
                            if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2 && attrNo[2] == obj[i].attrNo3) {
                                if(preAttrNo != obj[i].attrNo4) {
                                    optionHtml += '<option value="'+obj[i].attrNo4+'">'+obj[i].attrValue4+'</option>';
                                    preAttrNo = obj[i].attrNo4;
                                }
                            }
                        }
                    }
                }
                $('#goods_option_'+seq).append(optionHtml);
            }
        }

        /* 폼 필수 체크 */
        function jsFormValidation() {

            var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
            var optLayerCnt = $('[id^=option_layer_]').length; //필수옵션 레이어 갯수
            var optionSelectOk = true; //필수옵션 선택 확인
            var addOptionUseYn = '${goodsInfo.data.addOptUseYn}'; //추가 옵션 사용 여부
            var addOptRequiredYn = 'N'; //추가옵션(필수) 존재 여부;
            var addOptRequiredOptNo = []; //추가옵션(필수) 선택한 옵션 번호 배열;
            var addOptBoxCnt = 0;//추가옵션(필수) 셀렉트박스 갯수
            var addOptionSelectOk = true; //추가옵션(필수) 선택 확인
            var maxOrdLimitYn = "${goodsInfo.data.maxOrdLimitYn}"; //최대 주문수량 제한 여부
            var maxOrdLimitOk = true;
            var maxOrdQtt = "${goodsInfo.data.maxOrdQtt}"; //최대 주문 수량
            var minOrdLimitYn = "${goodsInfo.data.minOrdLimitYn}"; //최소 주문수량 제한 여부
            var minOrdLimitOk = true;
            var minOrdQtt = "${goodsInfo.data.minOrdQtt}"; //최소 주문 수량
            var totalOrdQtt = 0;
            var optionNm = ''; //옵션명
            var itemNm = ''; //단품명
            var stockQtt = 0; //재고수량
            var stockSetYn = '${goodsInfo.data.stockSetYn}'; //가용재고 설정 여부
            var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'; //가용재고 판매 여부
            var availStockQtt = '${goodsInfo.data.availStockQtt}'; //가용 재고 수량
            var rsvBuyYn = '${goodsInfo.data.rsvBuyYn}'; //예약구매가능여부

            //배송방법
            if($('radio[name=dlvrMethodCd]') !== 'undefined') {
                if($('radio[name=dlvrMethodCd]').val() == '') {
                    Dmall.LayerUtil.alert("배송방법을 선택해 주십시요.");
                    $(this).focus();
                    return false;
                }
            }

            //배송비 결제(선불/착불)
            if($('select[id=dlvrcPaymentCd]') !== 'undefined') {
                if($('select[id=dlvrcPaymentCd]').val() == '' && $('[name=dlvrMethodCd]').val() != '02') {
                    Dmall.LayerUtil.alert("배송비 결제를 선택해 주십시요.");
                    $(this).focus();
                    return false;
                }
            }

            $('[id^=add_option_layer_]').each(function(index){
                if($(this).data().requiredYn == 'Y') {
                    addOptRequiredOptNo.push($(this).data().addOptNo);
                }
            });
            $('select.select_option.goods_addOption').each(function(){
                if($(this).data().requiredYn == 'Y') {
                    addOptBoxCnt++;
                }
            });


            /* 필수 옵션 선택 확인 */
            if(multiOptYn == 'Y' && optLayerCnt == 0) {
                $('select.select_option.goods_option').each(function(){
                    if($(this).find(':selected').val() == ''){
                        optionNm = $(this).data().optNm;
                        optionSelectOk = false;
                        return false;
                    }
                });
                if(!optionSelectOk) {
                    Dmall.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
                    return false;
                }
            }

            /* 필수 추가 옵션 선택 확인 */
            if(addOptionUseYn == 'Y' && addOptBoxCnt > 0) { // 필수 추가옵션이 있다면
                $('select.select_option.goods_addOption').each(function(){
                    if($(this).data().requiredYn == 'Y') {
                        if(addOptRequiredOptNo.length == 0) {   //선택한 필수 추가 옵션이 없다면
                            optionNm = $(this).data().addOptNm;
                            addOptionSelectOk = false;
                            return false;
                        } else { //선택한 필수 추가 옵션이 있다면
                            if($.inArray($(this).data().addOptNo,addOptRequiredOptNo) == -1) {
                                optionNm = $(this).data().addOptNm;
                                addOptionSelectOk = false;
                                return false;
                            }
                        }
                    }
                });
                if(!addOptionSelectOk) {
                    Dmall.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
                    return false;
                }
            }

            //재고 확인
            if(rsvBuyYn == null || rsvBuyYn == 'N'){
                if(multiOptYn == 'Y') {
                    $('[id^=option_layer_]').each(function(){
                        stockQttOk = jsCheckOptionStockQtt($(this));
                        stockQtt = Number($(this).find('.stockQttArr').val());
                        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                            stockQtt += Number(availStockQtt);
                        }
                        itemNm = $(this).data().itemNm;
                        if(!stockQttOk) {
                            return false;
                        }
                    });
                } else {
                    stockQtt = Number($('#goods_form').find('.stockQttArr').val());
                    if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                        stockQtt += Number(availStockQtt);
                    }
                    stockQttOk = jsCheckOptionStockQtt($('#goods_form'));
                }
                if(!stockQttOk) {
                    if(stockQtt < 0) {
                        stockQtt = 0;
                    }
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('재고: '+commaNumber(stockQtt)+'개<br>재고수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'(재고:'+commaNumber(stockQtt)+'개)<br>재고수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }
            //최대 구매 수량 확인
            if(maxOrdLimitYn == 'Y') {
                if(multiOptYn == 'Y') {
                    $('[id^=option_layer_]').each(function(){
                        var ordQtt = $(this).find('.input_goods_no').val();
                        totalOrdQtt  += Number(ordQtt);
                        /* if(Number(maxOrdQtt) < Number(ordQtt)) {
                             maxOrdLimitOk = false;
                         }
                         itemNm = $(this).data().itemNm;*/
                        /*if(!maxOrdLimitOk) {
                            return false;
                        }*/

                    });
                } else {
                    var ordQtt = $('#goods_form').find('.input_goods_no').val();
                    totalOrdQtt  +=  Number(ordQtt);
                    /* if(Number(maxOrdQtt) < Number(ordQtt)) {
                         maxOrdLimitOk = false;
                     }*/

                }

                //최대 구매수량 전체 주문 수량으로 변경
                if(Number(maxOrdQtt) < totalOrdQtt ){
                    maxOrdLimitOk = false;
                    itemNm ="";
                }

                if(!maxOrdLimitOk) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }
            //최소 구매 수량 확인
            if(minOrdLimitYn == 'Y') {
                totalOrdQtt =0;
                if(multiOptYn == 'Y') {
                    $('[id^=option_layer_]').each(function(){
                        var ordQtt = $(this).find('.input_goods_no').val();
                        totalOrdQtt  += Number(ordQtt);
                        /* if(Number(minOrdQtt) > Number(ordQtt)) {
                             minOrdLimitOk = false;
                         }
                         itemNm = $(this).data().itemNm;*/
                        /* if(!minOrdLimitOk) {
                             return false;
                         }*/
                    });
                } else {
                    var ordQtt = $('#goods_form').find('.input_goods_no').val();
                    totalOrdQtt  += Number(ordQtt);
                    /* if(Number(minOrdQtt) > Number(ordQtt)) {
                         minOrdLimitOk = false;
                     }*/
                }
                //최소 구매수량 전체 주문 수량으로 변경
                if(Number(minOrdQtt) > totalOrdQtt ){
                    minOrdLimitOk = false;
                    itemNm ="";
                }

                if(!minOrdLimitOk) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }
            return true;
        }

        // 페이스북 공유하기
        function jsShareFacebook() {
            var url = encodeURIComponent(document.location.href);
            url = url.replaceAll('%2Fm', "")
            var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
            var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=10");
        }

        //카카오스토리 공유하기
        function jsShareKastory(){
            /* Kakao.Story.share({
                 url: document.location.href,
                text: '${goodsInfo.data.goodsNm}'
        }); */

            Kakao.init('${snsMap.get('javascriptKey')}');

            Kakao.Link.sendDefault({
                objectType: 'feed',
                content: {
                    title: '${goodsInfo.data.goodsNm}',
                    description: '${goodsInfo.data.prWords}',
                    imageUrl: '${_DMALL_HTTP_SERVER_URL}${goodsInfo.data.snsImg}',
                    link: {
                        mobileWebUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}',
                        webUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}'
                    }
                },
                social: {
                    likeCount: 286,
                    commentCount: 45,
                    sharedCount: 845
                }
                /* ,buttons: [
                  {
                    title: '웹으로 보기',
                    link: {
                      mobileWebUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}',
                  webUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}'
                }
              },
              {
                title: '앱으로 보기',
                link: {
                  mobileWebUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}',
                  webUrl: '${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}'
                }
              }
            ] */
            });
        }

        ///상세 리사이즈
        function resizeFrame(){
            var innerBody;
            innerBody =  $('#product_contents');
            $(innerBody).find('img').each(function(i){
                var imgWidth = $(this).width();
                var imgHeight = $(this).height();
                var resizeWidth = $(innerBody).width();
                var resizeHeight = resizeWidth / imgWidth * imgHeight;

                $(this).css("max-width", "970px");

                $(this).css("width", resizeWidth);
                $(this).css("height", resizeHeight);

            });
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

        //날짜 형변환
        function parseDate(strDate) {
            var _strDate = strDate;
            var _year = _strDate.substring(0,4);
            var _month = _strDate.substring(4,6)-1;
            var _day = _strDate.substring(6,8);
            var _dateObj = new Date(_year,_month,_day);
            return _dateObj;
        }

        function isAndroidWebview() {
            return (navigator.userAgent.indexOf("davich_android")) > 0;
        }

        function isIOSWebview() {
            return (navigator.userAgent.indexOf("davich_ios")) > 0;
        }
    }
</script>