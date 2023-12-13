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
<script>
//최근본상품등록
function setLatelyGoods() {
    var expdate = new Date();
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
    var LatelyGoods = getCookie('LATELY_GOODS');
    var thisItem='${goodsInfo.data.goodsNo}'+"&"+'${goodsInfo.data.goodsNm}'+"&"+'${goodsInfo.data.latelyImg}';
    if (thisItem){
        if (LatelyGoods != "" && LatelyGoods != null) {
            if (LatelyGoods.indexOf(thisItem) ==-1 ){ //값이 없으면
                setCookie('LATELY_GOODS',thisItem+","+LatelyGoods,expdate);
            }
        } else {
            if (LatelyGoods == "" || LatelyGoods == null) {
                setCookie('LATELY_GOODS',thisItem+",",expdate);
            }
        }
    }
}

var k = 0; //옵션레이어 순번
$(document).ready(function(){
    //장바구니 정보
    basketInfo();
    basketAddOptInfo();
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
    //이미지 슬라이더
    $('.goods_view_slider').bxSlider({
      pagerCustom: '#goods_view_s_slider'
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

    //장바구니등록
    $('.btn_review_ok').on('click', function(){
        var formCheck = false;
        formCheck = jsFormValidation();
        
        if(formCheck) {
            var url = '/front/basket/basket-insert';
            var param = $('#goods_form').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Dmall.LayerUtil.alert("옵션이 변경 되었습니다.").done(function(){
                        location.href = "/front/basket/basket-list";
                    })
                }
            });
        }
    });
    //창 닫기
    $('#btn_close_pop').on('click', function(){
        Dmall.LayerPopupUtil.close('success_basket');
    });
    //취소 버튼
    $('#btn_close_pop2').on('click', function(){
        Dmall.LayerPopupUtil.close('success_basket');
    });

    //관심상품등록 호출
    $('.btn_favorite_go').on('click', function(){

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


    /* 바로구매(임시) */
    $('.btn_checkout_go').on('click', function(){
        var formCheck = false;
        formCheck = jsFormValidation();
        
        if(formCheck) {
            var url = '/front/order/order-form';
            var data = $('#goods_form').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit(url, param);
        }
    });

    /* 옵션 레이어 추가(필수)*/
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
                for(var i=0; i<obj.length; i++) {
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
                    optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="1" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+itemPrice+');">';
                    optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                    optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                    optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
                    optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
                    optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
                    optObj += '            <input type="hidden" name="noBuyQttArr" id="noBuyQttArr" value  ="N" >';
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

});

/* 상품후기조회 */
function ajaxReviewList(){
    var param = $('#form_review_search').serialize();
    var url = '/front/review/review-list-ajax?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
    Dmall.AjaxUtil.load(url, function(result) {
        $('#tab2').html(result);
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


/* 쿠폰 다운로드 */
function downloadCoupon() {
    var url = '/front/coupon/coupon-download-pop';
    var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
    Dmall.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            Dmall.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
        } else {
            Dmall.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
        }
    });
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
    var stockQtt = $(obj).find('.stockQttArr').val();
    var optionQtt = $(obj).find('.input_goods_no').val();
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
    if(totalPrice == 0) {
        totalPrice = '${goodsInfo.data.salePrice}';
    }
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
    var itemNo =  goods.find('.itemNoArr').val();
    var addOptNo =  goods.find('.addOptNoArr').val();
    var addOptDtlSeq =  goods.find('.addOptDtlSeqArr').val();
    var basketAddOptNo =  goods.find('.basketAddOptNoArr').val();

    jQuery("#delChkYn").val("Y");
    var optLayer = $('.popup_btn_area');
    var text = '';
    if(itemNo != null){
        text = '<input type="hidden" id = "delItemYn" name = "delItemYn" value ="Y">';
    }

    if(basketAddOptNo != null && basketAddOptNo!=0){
        text = '<input type="hidden" id = "delBasketAddOptNo" name = "delBasketAddOptNo" value ="'+basketAddOptNo+'">';
    }else{
        if(addOptNo != null && addOptDtlSeq != null){
            text = '<input type="hidden" id = "delAddOptNo" name = "delAddOptNo" value ="'+addOptNo+'">';
            text += '<input type="hidden" id = "delAddOptDtlSeq" name = "delAddOptDtlSeq" value ="'+addOptDtlSeq+'">';
        }
    }
    optLayer.append(text);
    
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
    var optionNm = ''; //옵션명
    var itemNm = ''; //단품명
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
            itemNm = $(this).data().itemNm;
            if(!stockQttOk) {
                return false;
            }
        });
    } else {
        stockQttOk = jsCheckOptionStockQtt($('#goods_form'));
    }
    if(!stockQttOk) {
        if(itemNm == '') {
            Dmall.LayerUtil.alert('재고수량을 확인해 주시기 바랍니다.');
        } else {
            Dmall.LayerUtil.alert(itemNm+'<br>재고수량을 확인해 주시기 바랍니다.');
        }
        return false;
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
      url: encodeURIComponent(document.location.href),
      text: '${goodsInfo.data.goodsNm}'
    });
}

function basketInfo(){
    var itemNo = '${basketInfo.itemNo}';
    var buyQtt = '${basketInfo.buyQtt}';
    var itemNm = '';
    var itemPrice = '${itemInfo.salePrice}';
    var stockQtt = '${itemInfo.stockQtt}';

    if('${basketInfo.itemVerChk}' == 'N'){
        return;
    }
    if('${basketInfo.attrVerChk}' == 'N'){
        return;
    }
    
    var attrValue1 = '${itemInfo.attrValue1}';
    var attrValue2 = '${itemInfo.attrValue2}';
    var attrValue3 = '${itemInfo.attrValue3}';
    var attrValue4 = '${itemInfo.attrValue4}';

    if (attrValue1 != null && '${itemInfo.optNo1}' !='0') {
        if(itemNm != '') itemNm +=', ';
        itemNm += attrValue1;
    }
    if (attrValue2 != null && '${itemInfo.optNo2}' !='0') {
        if(itemNm != '') itemNm +=', ';
        itemNm += attrValue2;
    }
    if (attrValue3 != null && '${itemInfo.optNo3}' !='0') {
        if(itemNm != '') itemNm +=', ';
        itemNm += attrValue3;
    }
    if (attrValue4 != null && '${itemInfo.optNo4}' !='0') {
        if(itemNm != '') itemNm +=', ';
        itemNm += attrValue4;
    }
    if(itemNm == ''){
        itemNm = '${goodsInfo.data.goodsNm}'
    }
    
    itemNm += '&nbsp;&nbsp;(재고:'+commaNumber(stockQtt)+')';
    
    var optLayer = $('.goods_plus_info02');
    var optObj = "";
    optObj += '<li id="option_layer_0" data-item-nm="'+itemNm+'">';
    optObj += '    <span class="floatL">'+itemNm+'</span>';
    optObj += '    <div class="floatR">';
    optObj += '        <div class="goods_no_select">';
    optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="'+buyQtt+'" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+itemPrice+');">';
    optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
    optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
    optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
    optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
    optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
    optObj += '            <input type="hidden" name="noBuyQttArr" id="noBuyQttArr" value  ="Y" >';
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
    
    var stockQtt = '${itemInfo.stockQtt}';
    
    //옵션 레이어 금액 셋팅(총금액 포함)
    jsSetOptionLayerPrice('opt', k, itemPrice);

    //옵션선택 초기화
    jsOptionInit();
}
function basketAddOptInfo(){
    var basketOptInfo = '${basketOptInfo}';

    var obj = jQuery.parseJSON(basketOptInfo); //단품정보

    for(i=0;i<obj.length;i++){
        k++;
        
        if(obj[i].addOptAmtChgCd == '1') {
            obj[i].addOptAmt = obj[i].addOptAmt * 1
        } else {
            obj[i].addOptAmt = obj[i].addOptAmt * (-1)
        }
        var optLayer = $('.goods_plus_info02');
        var optObj = "";
        optObj += '<li id="add_option_layer_'+k+'" data-required-yn="'+obj[i].requiredYn+'" data-add-opt-no="'+obj[i].addOptNo+'">';
        optObj += '    <span class="floatL">'+obj[i].addOptValue+'</span>';
        optObj += '    <div class="floatR">';
        optObj += '        <div class="goods_no_select">';
        optObj += '            <input type="text" name="addOptBuyQttArr" class="input_goods_no" value="'+obj[i].optBuyQtt+'" onkeyup="jsSetOptionLayerPrice(\'add_opt\', '+k+', '+obj[i].addOptAmt+');">';
        optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
        optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
        optObj += '            <input type="hidden" name="basketAddOptNoArr" class="basketAddOptNoArr" value="'+obj[i].basketAddOptNo+'">';
        optObj += '            <input type="hidden" name="addOptNoArr" class="addOptNoArr" value="'+obj[i].addOptNo+'">';
        optObj += '            <input type="hidden" name="addOptVerArr" class="addOptVerArr" value="'+obj[i].addOptVer+'">';
        optObj += '            <input type="hidden" name="addOptDtlSeqArr" class="addOptDtlSeqArr" value="'+obj[i].addOptDtlSeq+'">';
        optObj += '            <input type="hidden" name="addOptAmtArr" class="addOptAmtArr" value="'+obj[i].addOptAmt+'">';
        optObj += '            <input type="hidden" name="addOptAmtChgCdArr" class="addOptAmtChgCdArr" value="'+obj[i].addOptAmtChgCd+'">';
        optObj += '            <input type="hidden" name="addNoBuyQttArr" id="addNoBuyQttArr" value  ="Y" >';
        optObj += '        </div>';
        optObj += '        <div class="goods_price_select">';
        optObj += '            <span class="addOptSumAmtText"></span>';
        optObj += '            <input type="hidden" name="addOptSumAmtArr" class="addOptSumAmtArr" value="'+obj[i].addOptAmt+'">';
        optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_SKIN_IMG_PATH}/product/btn_goods_del.gif" alt=""></button>';
        optObj += '        </div>';
        optObj += '    </div>';
        optObj += '</li>';
        optLayer.append(optObj);
        
        //추가옵션 레이어 금액 셋팅(총금액 포함)
        jsSetOptionLayerPrice('add_opt', k, obj[i].addOptAmt);
    }
    

    //옵션선택 초기화
    $(this).val('');
    $(this).trigger('change');
}
</script>
<!-- layer_popup1 -->
    <div class="popup_header">
        <h1 class="popup_tit">주문조건 추가/변경</h1>
        <button type="button" id="btn_close_pop" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <form name="goods_form" id="goods_form">
    <div class="popup_content">
        <div class="popup_goods_plus_img">
            <img src="/front/img/product/popop_product_img01.gif" alt="">
        </div>          
        <div class="popup_goods_plus_scroll">
            <div class="goods_plus_tltle">
                <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
                <input type="hidden" name="basketNo" class="basketNo" value="${basketInfo.basketNo}">
                ${goodsInfo.data.goodsNo}
                <p class="goods_plus_tltle_text">
                    <span>${goodsInfo.data.goodsNm}</span>
                    <a href="" class="floatR" style="margin-left:3px">
                        <img src="${_SKIN_IMG_PATH}/product/icon_sns_kakao_s.gif" alt="카카오톡">
                    </a>
                    <a href="" class="floatR">
                        <img src="${_SKIN_IMG_PATH}/product/icon_sns_facebook_s.gif" alt="페이스북">
                    </a>
                </p>
                <!-- 네추럴하면서도 멋스러운 가디건 아우터 소개해드릴게요<br>
                적당한 두께감으로 초봄,늦가을까지 두루두루 활용하기 좋은 아우터인데요<br>
                음.. 촘촘하고 탄탄한 소재감이라 가벼운 코트느낌으로 입어주시기 좋아요<br>
                특히 힘있지만 툭하고 떨어지는 핏감이 정말 이쁘구요 은근 여성스러우면서도 코디에따라 캐주얼하게도 연출이 가능해요 -->
                ${goodsInfo.data.prWords}
            </div>  
            <div class="goods_plus_coupon">
            <c:if test="${fn:length(couponList) > 0}">
            <a href="javascript:downloadCoupon();"><img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰이미지"></a>
            </c:if>
            <div class="goods_plus_coupon_price">
                <del><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>
                <fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                <span>(1%적립)</span>
            </div>
        </div>
        <div class="goods_plus_info">
            <ul>
                <!-- <li><span>마켓포인트</span>1,590원 (회원등급별 최대 2%까지 추가 적립)</li> -->
                <li><span>원산지</span>${goodsInfo.data.habitat}</li>
                <li><span>사은품</span><button type="button" class="btn_cart_s04">사은품 보기</button></li>
            </ul>
        </div>
        
        <c:if test="${goodsInfo.data.multiOptYn eq 'Y' || goodsInfo.data.addOptUseYn eq 'Y'}">
        <!--- 상품 옵션 있을 경우 --->
        <div class="goods_plus_info">
            <ul>
                <c:if test="${goodsInfo.data.goodsOptionList ne null}">
                    <c:forEach var="optionList" items="${goodsInfo.data.goodsOptionList}" varStatus="status">
                    <li>
                        <span>${optionList.optNm}</span>
                        <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                            <label for="select_option">(필수) 선택하세요</label>
                            <select class="select_option goods_option" id="goods_option_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}"
                            data-opt-nm="${optionList.optNm}">
                                <option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>
                                <%-- <c:forEach var="optionDtlList" items="${optionList.attrValueList}" varStatus="status">
                                <option value="${optionDtlList.attrNo}" data-option-add-price="2000">${optionDtlList.attrNm}</option>
                                </c:forEach> --%>
                            </select>
                        </div>
                    </li>
                    </c:forEach>
                </c:if>
                <c:if test="${goodsInfo.data.goodsAddOptionList ne null}">
                    <c:forEach var="addOptionList" items="${goodsInfo.data.goodsAddOptionList}" varStatus="status">
                        <li>
                            <span>${addOptionList.addOptNm}</span>
                            <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                                <label for="select_option">선택하세요</label>
                                <select class="select_option goods_addOption" title="select option" data-required-yn="${addOptionList.requiredYn}" data-add-opt-no="${addOptionList.addOptNo}"
                                data-add-opt-nm="${addOptionList.addOptNm}">
                                    <option selected="selected" value="">선택하세요</option>
                                    <c:forEach var="addOptionDtlList" items="${addOptionList.addOptionValueList}" varStatus="status">
                                    <option value="${addOptionDtlList.addOptDtlSeq}" data-add-opt-amt="${addOptionDtlList.addOptAmt}"
                                    data-add-opt-amt-chg-cd="${addOptionDtlList.addOptAmtChgCd}" data-add-opt-value="${addOptionDtlList.addOptValue}"
                                    data-add-opt-dtl-seq="${addOptionDtlList.addOptDtlSeq}" data-add-opt-ver="${addOptionDtlList.optVer}">
                                    ${addOptionDtlList.addOptValue}(
                                    <c:choose>
                                        <c:when test="${addOptionDtlList.addOptAmtChgCd eq '1'}">
                                        +
                                        </c:when>
                                        <c:otherwise>
                                        -
                                        </c:otherwise>
                                    </c:choose>
                                    <fmt:formatNumber value="${addOptionDtlList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                                    </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>
        </div>
        </c:if>
        <c:if test="${goodsInfo.data.multiOptYn eq 'N'}">
        <!---// 상품 옵션 있을 경우 --->
        <input type="hidden" name="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
        <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="${goodsInfo.data.salePrice}">
        <input type="hidden" name="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
        
        
        <div class="goods_plus_info" style="border-bottom:1px solid #000;">
            <ul>
                <li>
                    <span>구매수량</span>
                    <div class="select_box28" style="width:55px;display:inline-block">
                        <label for="select_option">1</label>
                        <select class="select_option input_goods_no" name="buyQttArr" id="select_option" title="select option">
                            <c:forEach var="cnt" begin="1" end="99">
                            <option value="${cnt}">${cnt}</option>
                            </c:forEach>
                        </select>
                    </div>
                </li>
            </ul>
        </div>
        </c:if>
        <ul class="goods_plus_info02">
        <!--// 옵션 레이어 영역 //-->
        </ul>

        <div class="plus_price">
            총 상품 금액 : <span id="totalPriceText"><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span>
            <input type="hidden" name="totalPrice" id="totalPrice" value="0">
        </div>
        </div>
        <div class="popup_btn_area">
            <input type="hidden" id = "oldItemNo" name = "oldItemNo" value ="${basketInfo.itemNo}" />
            <input type="hidden" id = "delChkYn" name = "delChkYn" value ="N" />
            <button type="button" class="btn_review_ok">변경</button>
            <button type="button" id="btn_close_pop2" class="btn_review_cancel">취소</button>
        </div>  
    </div>
    </form>
<!-- //layer_popup1 -->