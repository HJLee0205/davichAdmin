<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
    //최근본상품등록

    $(document).ready(function(){

        //옵션 정보 호출
        jsSetOptionInfo(0,'');
        //상품평 호출
        // ajaxReviewList();
        //상품문의 호출
        // ajaxQuestionList();
        //상품고시정보 호출
        ajaxNotifyList();
        //상품 배송/반품/환불 정보 호출
        ajaxGoodsExtraInfo();
        //최근본상품에 담기

        //이미지 슬라이더
        carousel = $('#goods_view_s_slider').bxSlider({
            slideWidth: 91,
            minSlides: 2,
            maxSlides: 5,
            moveSlides: 1,
            slideMargin: 10,
            pager: false
        });
        slider = $('.goods_view_slider').bxSlider({
            captions: true,
            controls: false,
            pager: false
        });
        //관련상품 슬라이드
        var mySlider = $( '.with_view_slider' ).bxSlider({
            pager: false,
            slideWidth: 194,
            infiniteLoop: false,
            moveSlides: 1,
            minSlides: 5,      // 최소 노출 개수
            maxSlides: 5,      // 최대 노출 개수
            auto: false
        });
        $( '.btn_with_list_pre' ).on( 'click', function () {
            mySlider.goToPrevSlide();
            return false;
        } );
        $( '.btn_with_list_nex' ).on( 'click', function () {
            mySlider.goToNextSlide();
            return false;
        } );

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

        $('#dlvrMethodCd').on('change',function(){
            if($(this).val() == '02') {
                $('#dlvrPaymentKindCd01').hide();
                $('#dlvrPaymentKindCd02').show();
            } else {
                $('#dlvrPaymentKindCd01').show();
                $('#dlvrPaymentKindCd02').hide();
            }
        })

        //장바구니등록

        //계속쇼핑

        //장바구니이동

        //관심상품등록 호출
        $('#btn_favorite_go').on('click', function(){
            return false;
        });

        /* 바로구매 */

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
                    // var promotionDcRate = '${promotionInfo.data.prmtDcValue}'; //기획전 할인율
                    // var promotionDcAmt = 0; //기획전 할인금액
                    // var memberNo = '${user.session.memberNo}'; //회원번호
                    // var memberGradeUnitCd = '${member_info.data.dcUnitCd}'; //회원등급 할인구분
                    // var memberGradeUnitValue = '${member_info.data.dcValue}'; //회원등급 할인값
                    // var memberGradeDcAmt = 0; //회원등급 할인금액
                    for(var i=0; i<obj.length; i++) {
                        if (!obj[i].attrNo1) { obj[i].attrNo1 = 0}
                        if (!obj[i].attrNo2) { obj[i].attrNo2 = 0}
                        if (!obj[i].attrNo3) { obj[i].attrNo3 = 0}
                        if (!obj[i].attrNo4) { obj[i].attrNo4 = 0}

                        if(obj[i].attrNo1 == attrNo1 && obj[i].attrNo2 == attrNo2 && obj[i].attrNo3 == attrNo3 && obj[i].attrNo3 == attrNo3) {
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
                            itemPrice = obj[i].salePrice;
                            stockQtt = obj[i].stockQtt;
                            itemNm += '&nbsp;&nbsp;(재고:'+commaNumber(stockQtt)+')';
                        }
                    }


                    if($('.itemNoArr').length > 0) {
                        $('.itemNoArr').each(function(index){
                            if($(this).val() == itemNo) {
                                $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                                addLayer = false;
                            }
                        });
                    }

                    if(addLayer) {
                        //옵션레이어 추가
                        k++;
                        var optLayer = $('.goods_plus_info02');
                        var optObj = "";
                        optObj += '<li id="option_layer_'+k+'" data-item-nm="'+itemNm+'">';
                        optObj += '    <span class="floatL">'+itemNm+'</span>';
                        optObj += '    <div class="floatR">';
                        optObj += '        <div class="goods_no_select">';
                        optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="1" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+salePrice+');">';
                        optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                        optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                        optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
                        optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
                        optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
                        optObj += '            <input type="hidden" name="itemArr" class="itemArr" value="">';
                        optObj += '            <input type="hidden" name="noBuyQttArr" class="noBuyQttArr" value  ="N" >';
                        optObj += '        </div>';
                        optObj += '        <div class="goods_price_select">';
                        optObj += '            <span class="itemSumPriceText"></span>';
                        optObj += '            <input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                        optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_SKIN_IMG_PATH}/product/btn_goods_del.gif" alt=""></button>';
                        optObj += '        </div>';
                        optObj += '    </div>';
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
                    }


                    //옵션 레이어 금액 셋팅(총금액 포함)
                    jsSetOptionLayerPrice('opt', k, itemPrice);

                    //옵션선택 초기화
                    jsOptionInit();
                }
            }
        })

        /* 추가옵션 레이어 추가 */
        $('select.select_option.goods_addOption').on('change',function(){

            var addOptValue, addOptAmt, addOptAmtChgCd, addOptDtlSeq, addOptNo, addOptVer;
            var addLayer = true;
            var requiredYn = $(this).data().requiredYn;
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
                        }
                    });
                }

                if(addLayer) {
                    //추가 옵션 레이어 추가
                    k++;
                    var optLayer = $('.goods_plus_info02');
                    var optObj = "";
                    optObj += '<li id="add_option_layer_'+k+'" data-required-yn="'+requiredYn+'" data-add-opt-no="'+addOptNo+'">';
                    optObj += '    <span class="floatL">'+addOptValue+'</span>';
                    optObj += '    <div class="floatR">';
                    optObj += '        <div class="goods_no_select">';
                    optObj += '            <input type="text" name="addOptBuyQttArr" class="input_goods_no" value="1" onkeyup="jsSetOptionLayerPrice(\'add_opt\', '+k+', '+addOptAmt+');">';
                    optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                    optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                    optObj += '            <input type="hidden" name="addOptNoArr" class="addOptNoArr" value="'+addOptNo+'">';
                    optObj += '            <input type="hidden" name="addOptVerArr" class="addOptVerArr" value="'+addOptVer+'">';
                    optObj += '            <input type="hidden" name="addOptDtlSeqArr" class="addOptDtlSeqArr" value="'+addOptDtlSeq+'">';
                    optObj += '            <input type="hidden" name="addOptAmtArr" class="addOptAmtArr" value="'+addOptAmt+'">';
                    optObj += '            <input type="hidden" name="addOptAmtChgCdArr" class="addOptAmtChgCdArr" value="'+addOptAmtChgCd+'">';
                    optObj += '            <input type="hidden" name="addOptArr" class="addOptArr" value="">';
                    optObj += '            <input type="hidden" name="addNoBuyQttArr" class="addNoBuyQttArr" value  ="N" >';
                    optObj += '        </div>';
                    optObj += '        <div class="goods_price_select">';
                    optObj += '            <span class="addOptSumAmtText"></span>';
                    optObj += '            <input type="hidden" name="addOptSumAmtArr" class="addOptSumAmtArr" value="'+addOptAmt+'">';
                    optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_SKIN_IMG_PATH}/product/btn_goods_del.gif" alt=""></button>';
                    optObj += '        </div>';
                    optObj += '    </div>';
                    optObj += '</li>';
                    optLayer.append(optObj);
                }

                //추가옵션 레이어 금액 셋팅(총금액 포함)
                jsSetOptionLayerPrice('add_opt', k, addOptAmt);

                //옵션선택 초기화
                $(this).val('');
                $(this).trigger('change');
            }
        })

        /* 셀렉트박스 수량 변경(옵션X) */
        $('.input_goods_no').click(function(){
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


        // 재입고 알림 팝업
        $('#btn_alarm_view').on('click',function (){
            return false;
        });

        // 사은품보기 팝업
        $('#btn_view_freebie').on('click',function (){
            Dmall.LayerPopupUtil.open($('#freebie_pop'));
        });

        $('a').not('.slider').click(function () {return false;});

        //상세설명 리사이즈
        resizeFrame();

        $(".skin_tab_content:first,.tab_content:first").show();
    });

    /* 상품후기조회 */

    /* 상품문의조회 */

    /* 상품 고시정보 조회 */
    function ajaxNotifyList(){
        var param = 'goodsNo=${goodsInfo.data.goodsNo}&notifyNo=${goodsInfo.data.notifyNo}';
        var url = '/front/goods/notify-list?'+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#notifyDiv').html(result);
        })
    }
    /* 상품 배송/반품/환불 정보 조회 */
    function ajaxGoodsExtraInfo(){
        var url = '/front/goods/goods-extra-info';
        Dmall.AjaxUtil.load(url, function(result) {
            $('#tab4').html(result);
        })
    }


    /* 쿠폰 다운로드 */
    function downloadCoupon() {
        return false;
    }

    /* 상품 옵션 초기화 */
    function jsOptionInit(){
        $('select.select_option.goods_option').each(function(index){
            $(this).val('');
            $(this).trigger('change');
        });
    }

    /* 재고 확인 */
    function jsCheckOptionStockQtt(obj) {
        var rtn = true;
        var stockSetYn = '${goodsInfo.data.stockSetYn}'
        var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'
        var availStockQtt = '${goodsInfo.data.availStockQtt}';
        var stockQtt = $(obj).find('.stockQttArr').val();
        var optionQtt = $(obj).find('.input_goods_no').val();
        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
            stockQtt += Number(availStockQtt);
        }
        if(Number(stockQtt) > Number(optionQtt)) {
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
        $('#totalPriceText').html(commaNumber(totalPrice)+"원");
        $('#totalPrice').val(totalPrice);
    }

    /* 총 상품금액 셋팅(옵션X) */
    function jsSetTotalPriceNoOpt() {
        var totalPrice = 0;
        var salePrice = Number($('.itemPriceArr').val());
        var buyQtt = Number($('.input_goods_no').val());

        totalPrice = salePrice * buyQtt
        $('[id^=add_option_layer_]').each(function(){
            totalPrice += Number($(this).find('.addOptSumAmtArr').val());
        });
        if(totalPrice == 0) {
            totalPrice = '${goodsInfo.data.salePrice}';
        }
        $('#totalPriceText').html(commaNumber(totalPrice)+"원");
        $('#totalPrice').val(totalPrice);
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
    };

    /* 옵션 셀렉트 박스 동적 생성 */
    function jsSetOptionInfo(seq, val) {
        $('#goods_option_'+seq).find("option").remove();

        var itemInfo = '${goodsItemInfo}'
        if(itemInfo != '') {
            var obj = jQuery.parseJSON(itemInfo); //단품정보
            var optionHtml = '<option selected="selected"  value="">(필수) 선택하세요</option>';
            var preAttrNo = ''
            var selectBoxCount = $('[id^=goods_option_]').length;

            if(seq == 0) {  //최초 셀렉트박스 옵션 생성
                for(var i=0; i<obj.length; i++) {
                    if(preAttrNo != obj[i].attrNo1) {
                        optionHtml += '<option value="'+obj[i].attrNo1+'">'+obj[i].attrValue1+'</option>';
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
                                preAttrNo = obj[i].attrNo1;
                            }
                        }
                    } else if(seq==2) {
                        if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2) {
                            if(preAttrNo != obj[i].attrNo3) {
                                optionHtml += '<option value="'+obj[i].attrNo3+'">'+obj[i].attrValue3+'</option>';
                                preAttrNo = obj[i].attrNo1;
                            }
                        }
                    } else if(seq==3) {
                        if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2 && attrNo[3] == obj[i].attrNo3) {
                            if(preAttrNo != obj[i].attrNo4) {
                                optionHtml += '<option value="'+obj[i].attrNo4+'">'+obj[i].attrValue4+'</option>';
                                preAttrNo = obj[i].attrNo1;
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
        return false;
    }

    // 페이스북 공유하기
    function jsShareFacebook() {
        return false;
    }

    //카카오스토리 공유하기
    function jsShareKastory(){
        return false;
    }

    ///상세 리사이즈
    function resizeFrame(){
        var innerBody;
        innerBody =  $('#product_contents');
        $(innerBody).find('img').each(function(i){
            var imgWidth = $(this).width();
            var imgHeight = $(this).height();
            var resizeWidth = $(innerBody).width() > 0 ? $(innerBody).width():$('#product_bottom').width();
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
            return;
        }else{
            window.event.returnValue = false;
            return false;
        }
    }

    //이미지 슬라이더 관련
    function clicked(position) {
        slider.goToSlide(position);
    }
</script>