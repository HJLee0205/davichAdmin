<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
    //최근본상품등록
    function setLatelyGoods() {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
        var LatelyGoods = getCookie('LATELY_GOODS');
        var thisItem='${goodsInfo.data.goodsNo}'+"@"+'${goodsInfo.data.goodsNm}'+"@"+'${goodsInfo.data.latelyImg}';
        var itemCheck='${goodsInfo.data.goodsNo}';
        if (thisItem){
            if (LatelyGoods != "" && LatelyGoods != null) {
                if (LatelyGoods.indexOf(itemCheck) ==-1 ){ //값이 없으면
                    setCookie('LATELY_GOODS',thisItem+","+LatelyGoods,expdate);
                }
            } else {
                if (LatelyGoods == "" || LatelyGoods == null) {
                    setCookie('LATELY_GOODS',thisItem+",",expdate);
                }
            }
        }
    }

    var carousel;
    var slider;
    $(document).ready(function(){
        $.ajaxSetup({ cache: false });
        //옵션 정보 호출
        jsSetOptionInfo(0,'');
        //상품평 호출
        ajaxReviewList();
        //상품문의 호출
        ajaxQuestionList();
        //상품고시정보 호출
        ajaxNotifyList();
        //상품 배송/반품/환불 정보 호출
        ajaxGoodsExtraInfo();
        //최근본상품에 담기
        setLatelyGoods();

        //상세설명 리사이즈
        resizeFrame();

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
        $('#btn_cart_go').on('click', function(){
            var formCheck = false;
            formCheck = jsFormValidation();

            if(formCheck) {
                var basketPageMovYn = '${site_info.basketPageMovYn}';
                var url = '/front/basket/basket-insert';
                var param = $('#goods_form').serialize();
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success){
                        if(basketPageMovYn === 'Y') {
                            Dmall.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                        } else {
                            location.href = "/front/basket/basket-list";
                        }
                    } else {
                        if(result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                            location.href = '/front/interest/adult-restriction';
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
            location.href = "/front/basket/basket-list";
        });

        //관심상품등록 호출
        $('#btn_favorite_go').on('click', function(){

            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                    //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                    function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= "/front/login/member-login?returnUrl="+returnUrl;
                    },''
                );
            } else {

                var url = '/front/interest/interest-item-insert';
                var param = {goodsNo : '${goodsInfo.data.goodsNo}'}
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                        Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                            location.href="/front/interest/interest-item-list";
                        })
                     }
                })
            }
        });


        /* 바로구매 */
        $('#btn_checkout_go').on('click', function(){
            var memberNo =  '${user.session.memberNo}';
            var formCheck = false;
            formCheck = jsFormValidation(); //폼체크
            var itemArr = ''
            if(formCheck) {
                var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
                var goodsNo = '${goodsInfo.data.goodsNo}';
                var addOptArr = '';
                var dlvrMethod = $('#dlvrMethodCd').val(); //01:택배, 02:매장픽업
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
                    $('#goods_form').attr('action',HTTPS_SERVER_URL+'/front/order/order-form');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                } else {
                    $('#goods_form').attr('action',HTTPS_SERVER_URL+'/front/login/member-login');
                    $('#goods_form').find('#returnUrl').val(HTTPS_SERVER_URL+'/front/order/order-form');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                }
            }
        });

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
                            //itemNm += '&nbsp;&nbsp;(재고:'+commaNumber(stockQtt)+')';
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

                    if(addLayer) {
                        //옵션레이어 추가
                        k++;
                        var optLayer = $('.goods_plus_info02');
                        var optObj = "";
                        optObj += '<li id="option_layer_'+k+'" data-item-nm="'+itemNm+'">';
                        optObj += '    <span class="floatL">'+itemNm+'</span>';
                        optObj += '    <div class="floatR">';
                        optObj += '        <div class="goods_no_select">';
                        optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="1" onKeydown="onlyNumDecimalInput(event);" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+salePrice+');">';
                        optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                        optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                        optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
                        optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
                        optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
                        optObj += '            <input type="hidden" name="itemArr" class="itemArr" value="">';
                        optObj += '            <input type="hidden" name="noBuyQttArr" class="noBuyQttArr" value  ="N" >';
                        optObj += '        </div>';
                        optObj += '        <div class="goods_price_select">';
                        if(stockQtt <= 0) {
                            optObj += '            품절';
                            optObj += '            <input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                            optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_SKIN_IMG_PATH}/product/btn_goods_del.gif" alt=""></button>';
                        } else {
                            optObj += '            <span class="itemSumPriceText"></span>';
                            optObj += '            <input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                            optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_SKIN_IMG_PATH}/product/btn_goods_del.gif" alt=""></button>';
                        }
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
                        //옵션 레이어 금액 셋팅(총금액 포함)
                        jsSetOptionLayerPrice('opt', k, itemPrice);
                    }

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
                    var optObj = "";
                    optObj += '<li id="add_option_layer_'+k+'" data-required-yn="'+requiredYn+'" data-add-opt-no="'+addOptNo+'">';
                    optObj += '    <span class="floatL">'+addOptValue+'</span>';
                    optObj += '    <div class="floatR">';
                    optObj += '        <div class="goods_no_select">';
                    optObj += '            <input type="text" name="addOptBuyQttArr" class="input_goods_no" value="1" onKeydown="onlyNumDecimalInput(event);" onkeyup="jsSetOptionLayerPrice(\'add_opt\', '+k+', '+addOptAmt+');">';
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

                    //추가옵션 레이어 금액 셋팅(총금액 포함)
                    jsSetOptionLayerPrice('add_opt', k, addOptAmt);
                }

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
            var goodsNm = '${goodsInfo.data.goodsNm}';
            var url = '/front/goods/restock-pop';
            var param = {'goodsNo':'${goodsInfo.data.goodsNo}', 'goodsNm':goodsNm};
            Dmall.AjaxUtil.loadByPost(url, param, function(result) {
                $('#div_restock').html(result).promise().done(function(){
                    $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
                }); ;
                Dmall.LayerPopupUtil.open($('#restock_pop'));
            })
        });

        // 사은품보기 팝업
        $('#btn_view_freebie').on('click',function (){
            Dmall.LayerPopupUtil.open($('#freebie_pop'));
        });
    });

    /* 상품후기조회 */
    function ajaxReviewList(){
        var param = $('#form_review_search').serialize();
        var url = '/front/review/review-list-ajax?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#tab2').html(result).promise().done(function(){
                $('#selectivizr').attr('src',$('#selectivizr').attr('src')+'?id='+new Date().getMilliseconds() );
            });
        })
    }

    /* 상품문의조회 */
    function ajaxQuestionList(){
        var param = $('#form_question_search').serialize();
        var url = '/front/question/question-list-ajax?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#tab3').html(result);
        })
    }

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


    /* 쿠폰 다운로드 팝업 */
    function downloadCoupon() {
        $('#couponPop').remove();
        var couponLayerPop = "";
        var couponList = "";
        var url = '/front/coupon/coupon-download-pop';
        var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                if(result.resultList.length > 0) {
                    for(var i=0; i < result.resultList.length; i++) {
                        var couponInfo = ''; //제한금액
                        var couponPeriodInfo = '';//기간제한
                        var couponBnf = '';//혜택
                        var button = '';
                        if(result.resultList[i].couponUseLimitAmt > 0) {
                            couponInfo = commaNumber(result.resultList[i].couponUseLimitAmt)+'원 이상 구매시';
                        }
                        if(result.resultList[i].couponApplyPeriodCd == '01') {
                            var applyStartDttm = parseDate(result.resultList[i].applyStartDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                            var applyEndDttm = parseDate(result.resultList[i].applyEndDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                            couponPeriodInfo = applyStartDttm +'<br>~'+applyEndDttm;
                        } else {
                            couponPeriodInfo = '발급일로부터 '+result.resultList[i].couponApplyIssueAfPeriod+'일'
                        }
                        if(result.resultList[i].couponBnfCd == '01') {
                            couponBnf = result.resultList[i].couponBnfValue + '% 할인(최대'+commaNumber(result.resultList[i].couponBnfDcAmt)+'원)' ;
                        } else {
                            couponBnf = result.resultList[i].couponBnfValue + '원 할인(최대'+commaNumber(result.resultList[i].couponBnfDcAmt)+'원)' ;
                        }
                        if(result.resultList[i].issueYn == 'Y') {
                            button = '<button type="button" class="btn_cart_s">발급완료</button>';
                        } else {
                            button = '<button type="button" class="btn_cart_s" id="cp_btn_'+result.resultList[i].couponNo+'" onClick="issueCoupon(\''+result.resultList[i].couponNo+'\')">DOWN</button>';
                        }
                        couponList += '                    <tr class="cp_list" data-issue-yn="'+result.resultList[i].issueYn+'">';
                        couponList += '                        <td class="text11">'+result.resultList[i].couponNm+'</td>';
                        couponList += '                        <td class="text11">'+couponInfo+'</td>';
                        couponList += '                        <td class="text11">'+couponPeriodInfo+'</td>';
                        couponList += '                        <td class="textL11">'+couponBnf+'</td>';
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
                    couponLayerPop += '            <table class="tProduct_Board">';
                    couponLayerPop += '                <caption>';
                    couponLayerPop += '                    <h1 class="blind">쿠폰 목록입니다.</h1>';
                    couponLayerPop += '                </caption>';
                    couponLayerPop += '                <colgroup>';
                    couponLayerPop += '                    <col style="width:20%">';
                    couponLayerPop += '                    <col style="width:20%">';
                    couponLayerPop += '                    <col style="width:25%">';
                    couponLayerPop += '                    <col style="width:25%">';
                    couponLayerPop += '                    <col style="width:10%">';
                    couponLayerPop += '                </colgroup>';
                    couponLayerPop += '                <thead>';
                    couponLayerPop += '                    <tr>';
                    couponLayerPop += '                        <th>쿠폰명</th>';
                    couponLayerPop += '                        <th>제한금액</th>';
                    couponLayerPop += '                        <th>기간제한</th>';
                    couponLayerPop += '                        <th>혜택</th>';
                    couponLayerPop += '                        <th>다운받기</th>';
                    couponLayerPop += '                    </tr>';
                    couponLayerPop += '                </thead>';
                    couponLayerPop += '                <tbody>';
                    couponLayerPop +=                  couponList
                    couponLayerPop += '                </tbody>';
                    couponLayerPop += '            </table>';
                    couponLayerPop += '        </div>';
                    couponLayerPop += '        <div class="popup_address_top">';
                    couponLayerPop += '            <button type="button" class="floatL btn_address_plus" onclick="issueCouponAll();">전체 다운로드</button>';
                    couponLayerPop += '        </div>';
                    couponLayerPop += '    </div>';
                    couponLayerPop += '</div>';
                    $('body').append(couponLayerPop);
                    Dmall.LayerPopupUtil.open($('#couponPop'));
                }
            } else {
                Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
            }
        });
    }

    /* 쿠폰 건별 발급 */
    function issueCoupon(couponNo) {
        var url = '/front/coupon/coupon-issue';
        var param = {couponNo:couponNo};

        Dmall.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $('#cp_btn_'+couponNo).html('발급완료');
                $('#cp_btn_'+couponNo).attr('onClick','');
                $('#cp_btn_'+couponNo).parents('td').parents('tr').data().issueYn = 'Y';
                Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
            } else {
                Dmall.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');
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
            var url = '/front/coupon/coupon-issue-all';
            var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('[id^=cp_btn_]').html('발급완료');
                    $('.cp_list').each(function(){
                        var d = $(this).data();
                        if(d.issueYn == 'N') {
                            d.issueYn = 'Y';
                        }
                    });
                    Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
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

        var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
        var optLayerCnt = $('[id^=option_layer_]').length; //필수옵션 레이어 갯수
        var optionSelectOk = true; //필수옵션 선택 확인
        var addOptionUseYn = '${goodsInfo.data.addOptUseYn}'; //추가 옵션 사용 여부
        var addOptRequiredYn = 'N'; //추가옵션(필수) 존재 여부;
        var addOptRequiredOptNo = new Array(); //추가옵션(필수) 선택한 옵션 번호 배열;
        var addOptBoxCnt = 0;//추가옵션(필수) 셀렉트박스 갯수
        var addOptionSelectOk = true; //추가옵션(필수) 선택 확인
        var maxOrdLimitYn = "${goodsInfo.data.maxOrdLimitYn}"; //최대 주문수량 제한 여부
        var maxOrdLimitOk = true;
        var maxOrdQtt = "${goodsInfo.data.maxOrdQtt}"; //최대 주문 수량
        var minOrdLimitYn = "${goodsInfo.data.minOrdLimitYn}"; //최소 주문수량 제한 여부
        var minOrdLimitOk = true;
        var minOrdQtt = "${goodsInfo.data.minOrdQtt}"; //최소 주문 수량
        var optionNm = ''; //옵션명
        var itemNm = ''; //단품명
        var stockQtt = 0; //재고수량
        var stockSetYn = '${goodsInfo.data.stockSetYn}'; //가용재고 설정 여부
        var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'; //가용재고 판매 여부
        var availStockQtt = '${goodsInfo.data.availStockQtt}'; //가용 재고 수량

        //배송방법
        if($('select[id=dlvrMethodCd]') !== 'undefined') {
            if($('select[id=dlvrMethodCd]').val() == '') {
                Dmall.LayerUtil.alert("배송방법을 선택해 주십시요.");
                $(this).focus()
                return false;
            }
        }

        //배송비 결제(선불/착불)
        if($('select[id=dlvrcPaymentCd]') !== 'undefined') {
            if($('select[id=dlvrcPaymentCd]').val() == '' && $('#dlvrMethodCd').val() != '02') {
                Dmall.LayerUtil.alert("배송비 결제를 선택해 주십시요.");
                $(this).focus()
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
        //최대 구매 수량 확인
        if(maxOrdLimitYn == 'Y') {
            if(multiOptYn == 'Y') {
                $('[id^=option_layer_]').each(function(){
                    var ordQtt = $(this).find('.input_goods_no').val();
                    if(Number(maxOrdQtt) < Number(ordQtt)) {
                        maxOrdLimitOk = false;
                    }
                    itemNm = $(this).data().itemNm;
                    if(!maxOrdLimitOk) {
                        return false;
                    }
                });
            } else {
                var ordQtt = $('#goods_form').find('.input_goods_no').val();
                if(Number(maxOrdQtt) < Number(ordQtt)) {
                    maxOrdLimitOk = false;
                }
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
            if(multiOptYn == 'Y') {
                $('[id^=option_layer_]').each(function(){
                    var ordQtt = $(this).find('.input_goods_no').val();
                    if(Number(minOrdQtt) > Number(ordQtt)) {
                        minOrdLimitOk = false;
                    }
                    itemNm = $(this).data().itemNm;
                    if(!minOrdLimitOk) {
                        return false;
                    }
                });
            } else {
                var ordQtt = $('#goods_form').find('.input_goods_no').val();
                if(Number(minOrdQtt) > Number(ordQtt)) {
                    minOrdLimitOk = false;
                }
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
        var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
        var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=10");
    }

    //카카오스토리 공유하기
    function jsShareKastory(){
        Kakao.Story.share({
          url: document.location.href,
          text: '${goodsInfo.data.goodsNm}'
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
            return;
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

</script>