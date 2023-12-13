'use strict';

/**
 * Version 1.0.0
 * 
 * 
 *  defaultSettings {
 *      
 *      //쿠폰 div ID
 *      couponDiv : "popup_coupon",
 * 
 *      //쿠폰 조회 ajax URL(json)
 *      url : "",
 * 
 *      //쿠폰 조회 버튼
 *      couponbtn : _self.selector,
 * 
 *      //상품정보
 *      params : false,
 *      
 *      //총주문금액(주문서쿠폰 관련)
 *      orderTotalAmt : 0,
 * 
 *      //쿠폰 로드 후 실행
 *      onLoad : false,
 * 
 *      //적용버튼 클릭시 실행
 *      onApply : false
 * };
 * 
 */

(function ($, document, window) {
    
    $.fn.coupon = function(options) {

        var commaNumber = (function(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        });
        
        var trim = (function(p){
            return (p+'').replace(/^\s+|\s+$/g, "");
        });

        var commaString = (function(p){
            var num = parseFloat(p+'');
            if( isNaN(num) ) return "0";
            return commaNumber(num);
        });

        var comma = (function(p){return commaString(p+'');});

        var dateFormat = (function(v){
            var d =  (v+'').split('-').join('');
            d =  d.split('/').join('');
            d =  d.split(':').join('');

            if(d.length>7){
                return d.substring(2,4)+'/'+d.substring(4,6)+'/'+d.substring(6,8);
            }else{
                return d;
            }
            });

        var replaceAll = (function(p,o, n){
              var v = (p+'');
              return v.split(o).join(n);
        });
        
        var htmlCouponPopup = "";
        var _self = $(this);
        var _version = "1.0.0";
        var settings = {
            couponDiv : "popup_coupon",
            url : "",
            couponbtn : _self.selector,
            params : false,
            orderTotalAmt : 0,
            onLoad : false,
            onApply : false
        }
        
        if(options) {
            $.extend(settings, options);
        };
        
        //상품쿠폰 할인금액 계산
        var calcGoodsDcAmt = function(obj,d){
            var dc = 0;
            if(obj != null) {
                //var salePrice   = $(obj).parents("li").parents("ul").children().eq(2).data().salePrice;   //선택한 상품 판매 가격
                //var qtt         = $(obj).parents("li").parents("ul").children().eq(1).data().goodsQtt;    //선택한 상품 수량
                var salePrice   = $(obj).parents("li").find("div:first .price_area").data().salePrice;   //선택한 상품 판매 가격
                var qtt         = $(obj).parents("li").find("div:first .qtt_area").data().goodsQtt;    //선택한 상품 수량
                var li_dcAmt    = $(obj).parents("li").find('.discount_no');//할인금액 li
                
                dc = calcDcAmt(d, salePrice*qtt);
            }    
            $(li_dcAmt).data("dc_amt",dc);
            $(obj).data("dc-amt",dc);
            $(li_dcAmt).html(commaNumber(dc)+"원");
            
            //총 할인금액계산
            calcTotalDcAmt();
        }
        
        // 주문서 쿠폰 할인금액 계산
        var calcOrderDcAmt = function(obj,d){
            var dc = 0;
            if(obj != null) {                
                dc = calcDcAmt(d,settings.orderTotalAmt);
            }    
            $("#orderCouponAmt").data("orderCouponAmt",dc);
            
            //총 할인금액계산
            calcTotalDcAmt();
        }
        
        //할인금액 계산
        var calcDcAmt = function(d,price) {
            var dc="";
            if(d.couponBnfCd == "01") { //정률
                dc = Math.round(parseInt(price * (d.couponBnfValue/100))/10)*10;
            } else if(d.couponBnfCd == "02") { //정액
                dc = d.couponBnfDcAmt;
            } else {
                dc = "0";
            }
            
            // 주문쿠폰 최대 할인 금액
            if(dc > d.couponBnfDcAmt) {
                dc = d.couponBnfDcAmt;
            }
            return dc;
        }
        
        //총할인금액 계산
        var calcTotalDcAmt = function(){
            var goodsDcAmt = 0;
            var goodsTotalDcAmt = 0;
            var orderTotalDcAmt = $("#orderCouponAmt").data().orderCouponAmt;
            
            $(".coupon_list").each(function(){
                if($(this).find('.price_area span').data()!=undefined){
                    goodsDcAmt = $(this).find('.price_area span').data().dc_amt;
                }
                if(goodsDcAmt !== undefined) {
                    goodsTotalDcAmt += parseInt(goodsDcAmt);
                }
            });
            
            //상품쿠폰 총 할인
            $("#goodsCouponAmt").html(commaNumber(parseInt(goodsTotalDcAmt))+"원");
            $("#goodsCouponAmt").data("goodsCouponAmt",goodsTotalDcAmt);
            //주문쿠폰 총 할인
            $("#orderCouponAmt").html(commaNumber(parseInt(orderTotalDcAmt))+"원");
            $("#orderCouponAmt").data("orderCouponAmt",orderTotalDcAmt);
            //상품쿠폰 + 주문쿠폰 총 할인
            $("#totalCouponAmt").html(commaNumber(parseInt(goodsTotalDcAmt)+parseInt(orderTotalDcAmt))+"원");
            $("#totalCouponAmt").data("totalCouponAmt",goodsTotalDcAmt+orderTotalDcAmt);
        }
        
        var createPop = (function(){
            var documentCouponPopup = $("body");
            
            var htmlCouponList = "";
            var couponGoodsList = "";   //상품쿠폰
            var couponOrderList = "";   //주문쿠폰
            var goodsList = "";         //상품정보

            var couopnGoodsInfoList = {};
            $(settings.params).each(function(i){
                var obj = settings.params[i];
                $.each(obj,function(key,value){
                    couopnGoodsInfoList['couopnGoodsInfoList['+i+'].'+key] = value;
                })
            });
            
            var _goods_qtt = 0;
            var _order_qtt = 0;            
                $.ajax({
                    type : "POST",
                    url : MOBILE_CONTEXT_PATH+"/front/coupon/available-ordercoupon-list",
                    data : couopnGoodsInfoList,
                    dataType : "json",
                    
                    success : function(data){
                        /*상품쿠폰*/
                        $.each(settings.params, function (i){
                           /*
                        	goodsList += "    <ul class='tCoupon_List' data-goods-no='"+settings.params[i].goodsNo+"'>";
                            goodsList += "        <li class='col01'>"+settings.params[i].goodsNm+"</li>";
                            goodsList += "        <li class='col02' data-goods-qtt='"+settings.params[i].goodsQtt+"'>"+settings.params[i].goodsQtt+"개</li>";
                            goodsList += "        <li class='col03' data-sale-price='"+settings.params[i].salePrice+"'>"+commaNumber(settings.params[i].salePrice*settings.params[i].goodsQtt)+"원</li>";
                            
                            couponGoodsList  = "";
                            couponGoodsList += "    <div class='select_box28' style='width:95%;display:inline-block'>";
                            couponGoodsList += "    <label for='selectGoodsCoupon'>선택</label>";
                            couponGoodsList += "    <select style='width:95%' class='select_option selectGoodsCoupon' id='selectGoodsCoupon"+i+"' title='select option'>";
                            couponGoodsList += "        <option value=''>선택</option>";
                            var couponGoodsCnt = 0;
                            $.each(data.resultList, function (j){
                                if(settings.params[i].goodsNo == data.resultList[j].goodsNo) {
                                    couponGoodsList += "        <option value='"+data.resultList[j].couponNo+"' data-goods-no='"+data.resultList[j].goodsNo+"' data-coupon-no='"+data.resultList[j].couponNo+"' data-coupon-bnf-cd='"+data.resultList[j].couponBnfCd+"'";
                                    couponGoodsList += "        data-coupon-bnf-value='"+data.resultList[j].couponBnfValue+"' data-coupon-use-limit-amt='"+data.resultList[j].couponUseLimitAmt+"' data-coupon-bnf-dc-amt='"+data.resultList[j].couponBnfDcAmt+"'"; 
                                    couponGoodsList += "        data-coupon-kind-cd='"+data.resultList[j].couponKindCd+"' data-apply-start-dttm='"+data.resultList[j].applyStartDttm+"' data-apply-end-dttm='"+data.resultList[j].applyEndDttm+"'";
                                    couponGoodsList += "        data-item-no='"+settings.params[i].itemNo+"'>";
                                    couponGoodsList +=          data.resultList[j].couponNm;
                                    couponGoodsList += "        </option>";
                                    
                                    couponGoodsCnt++;
                                }
                            });
                            couponGoodsList +=  "    </select>";
                            couponGoodsList +=  "    </div>";
                            
                            if(couponGoodsCnt == 0) {
                                couponGoodsList = "<span class='fRed'>사용 가능한 쿠폰이 없습니다.</span>";
                            }
                            
                            goodsList += "        <li class='col01'>"+couponGoodsList+"</li>";
                            goodsList += "        <li class='col02_02'>할인금액</li>";
                            goodsList += "        <li class='col03'>0원</li>";
                            goodsList += "    </ul>";
                            */
	                        goodsList += '		<ul class="coupon_list" data-goods-no="'+settings.params[i].goodsNo+'">';
							goodsList += '			<li>';
							goodsList += '				<div class="floatC">';
							goodsList += '					<div class="coupon_area">';
							goodsList += '						<div class="ellipsis">';
							goodsList += '							'+settings.params[i].goodsNm;
							goodsList += '						</div>';
							goodsList += '						<div class="qtt_area" data-goods-qtt="'+settings.params[i].goodsQtt+'">'+settings.params[i].goodsQtt+'개</div>';
							goodsList += '					</div>';
							goodsList += '					<div class="price_area" data-sale-price="'+settings.params[i].salePrice+'">';
							goodsList += '					'+commaNumber(settings.params[i].salePrice*settings.params[i].goodsQtt)+'원';
							goodsList += '					</div>';
							goodsList += '				</div>';
							goodsList += '				<div class="floatC">';
							couponGoodsList  = "";
							couponGoodsList += '			<div class="coupon_area">';
							couponGoodsList += '				<select class="select_option selectGoodsCoupon" id="selectGoodsCoupon'+i+'" title="select option">';
							couponGoodsList += '					<option value="">선택해주세요.</option>';
							var couponGoodsCnt = 0;
                            $.each(data.resultList, function (j){
                                if(settings.params[i].goodsNo == data.resultList[j].goodsNo) {
                                    couponGoodsList += "        <option value='"+data.resultList[j].couponNo+"' data-goods-no='"+data.resultList[j].goodsNo+"' data-coupon-no='"+data.resultList[j].couponNo+"' data-coupon-avl-no='"+data.resultList[j].couponAvlNo+"' data-coupon-bnf-cd='"+data.resultList[j].couponBnfCd+"'";
                                    couponGoodsList += "        data-coupon-bnf-value='"+data.resultList[j].couponBnfValue+"' data-coupon-use-limit-amt='"+data.resultList[j].couponUseLimitAmt+"' data-coupon-bnf-dc-amt='"+data.resultList[j].couponBnfDcAmt+"'"; 
                                    couponGoodsList += "        data-coupon-kind-cd='"+data.resultList[j].couponKindCd+"' data-apply-start-dttm='"+data.resultList[j].applyStartDttm+"' data-apply-end-dttm='"+data.resultList[j].applyEndDttm+"'";
                                    couponGoodsList += "        data-item-no='"+settings.params[i].itemNo+"' data-member-cp-no='"+data.resultList[j].memberCpNo+"' data-coupon-solo-use-yn='"+data.resultList[j].couponSoloUseYn+"'>";
                                    couponGoodsList +=          data.resultList[j].couponNm;
                                    if(data.resultList[j].couponSoloUseYn=='Y'){
                                        couponGoodsList += "        (단독사용쿠폰)";
                                    }
                                    couponGoodsList += "        </option>";
                                    
                                    couponGoodsCnt++;
                                }
                            });
							couponGoodsList += '				</select>';
							couponGoodsList += '			</div>';
							if(couponGoodsCnt == 0) {
                                couponGoodsList = "<span class='fRed'>사용 가능한 쿠폰이 없습니다.</span>";
                            }
							goodsList +=	couponGoodsList;
							goodsList += '					<div class="price_area">';
							goodsList += '						할인 : <span class="discount_no">0원</span>';
							goodsList += '					</div>';
							
							goodsList += '				</div>';
							goodsList += '			</li>';
                        	
                        });
                        
                        /*주문쿠폰*/                        
                        couponOrderList  =  "";
                        couponOrderList +=  "   <ul class='coupon_list02'>";
                        
                        var couponOrderCnt = 0;
                        $.each(data.resultList, function (j){
                            if(data.resultList[j].goodsNo == "" || data.resultList[j].goodsNo == null) {
                                couponOrderList += "        <li class='post_search' style='margin-bottom:0;'>";
                                couponOrderList += "            <input type='radio' id='order_coupon"+j+"' name='order_coupon' class='selectOrderCoupon' data-coupon-no='"+data.resultList[j].couponNo+"' data-coupon-avl-no='"+data.resultList[j].couponAvlNo+"' data-coupon-bnf-cd='"+data.resultList[j].couponBnfCd+"'";
                                couponOrderList += "            data-coupon-bnf-value='"+data.resultList[j].couponBnfValue+"' data-coupon-use-limit-amt='"+data.resultList[j].couponUseLimitAmt+"' data-coupon-bnf-dc-amt='"+data.resultList[j].couponBnfDcAmt+"'";
                                couponOrderList += "            data-coupon-kind-cd='"+data.resultList[j].couponKindCd+"' data-apply-start-dttm='"+data.resultList[j].applyStartDttm+"' data-apply-end-dttm='"+data.resultList[j].applyEndDttm+"'>";
                                couponOrderList += "            <label for='order_coupon"+j+"'>";
                                couponOrderList += "                <span></span>";
                                couponOrderList += "                 "+data.resultList[j].couponNm;
                                couponOrderList += "            </label>";
                                couponOrderList += "        </li>";
                                
                                couponOrderCnt++;
                            }
                        });
                        //주문서 쿠폰이 없으면
                        if(couponOrderCnt == 0) {
                            couponOrderList += "                    <li style='padding-top:45px;'>";
                            couponOrderList += "                        <span class='fRed'>사용 가능한 쿠폰이 없습니다.</span>";
                            couponOrderList += "                    </li>";
                        }
                        couponOrderList  +=  "   </ul>";
                        /*
                        htmlCouponPopup += "    <div class='popup_coupon' id='popup_coupon'style='display:none'>";
                        htmlCouponPopup += "        <div class='popup_header'>";
                        htmlCouponPopup += "            <h1 class='popup_tit'>쿠폰 할인 적용</h1>";
                        htmlCouponPopup += "            <button type='button' class='btn_close_popup'><img src='../img/common/btn_close_popup.png' alt='팝업창닫기'></button>";
                        htmlCouponPopup += "        </div>";
                        htmlCouponPopup += "        <div class='popup_content'>";
                        htmlCouponPopup += "            <div class='coupon_scroll_tit'>";
                        htmlCouponPopup += "                - 상품쿠폰 <span>(상품별 사용 가능한 쿠폰만 보여집니다.)</span>";
                        htmlCouponPopup += "                <button type='button' class='floatR btn_my_coupon'>내쿠폰함</button>";
                        htmlCouponPopup += "            </div>";
                        htmlCouponPopup += "            <div class='coupon_scroll'>"+goodsList+"</div>";
                        htmlCouponPopup += "            <div class='coupon_scroll_tit02'>";
                        htmlCouponPopup += "                - 주문서 쿠폰 <span>(사용 가능한 주문서 쿠폰만 보여집니다.)</span>";
                        htmlCouponPopup += "            </div>";
                        htmlCouponPopup += "            <div class='coupon_scroll02'>";
                        htmlCouponPopup += "                <ul class='tCoupon_List02'>"+couponOrderList+"</ul>";
                        htmlCouponPopup += "            </div>";
                        htmlCouponPopup += "            <ul class='popup_coupon_price'>";
                        htmlCouponPopup += "                <li>";
                        htmlCouponPopup += "                    상품쿠폰<span id='goodsCouponAmt' data-goods-coupon-amt='0'>0원</span>";
                        htmlCouponPopup += "                </li>";
                        htmlCouponPopup += "                <li class='icon'>";
                        htmlCouponPopup += "                    <img src='../img/product/icon_plus.png' alt='더하기'>";
                        htmlCouponPopup += "                </li>";
                        htmlCouponPopup += "                <li>";
                        htmlCouponPopup += "                    주문할인쿠폰";
                        htmlCouponPopup += "                    <span id='orderCouponAmt' data-order-coupon-amt='0'>0원</span>";
                        htmlCouponPopup += "                </li>";
                        htmlCouponPopup += "                <li class='icon'>";
                        htmlCouponPopup += "                    <img src='../img/product/icon_total_price.png' alt='적용'>";
                        htmlCouponPopup += "                </li>";
                        htmlCouponPopup += "                <li>";
                        htmlCouponPopup += "                    총할인";
                        htmlCouponPopup += "                    <span class='fRed' id='totalCouponAmt' data-total-coupon-amt='0'>0원</span>";
                        htmlCouponPopup += "                </li>";
                        htmlCouponPopup += "            </ul>";
                        htmlCouponPopup += "            <div class='popup_btn_area'>";
                        htmlCouponPopup += "                <button type='button' class='btn_popup_ok'>확인</button>";
                        htmlCouponPopup += "                <button type='button' class='btn_popup_cancel'>닫기</button>";
                        htmlCouponPopup += "            </ul>";
                        htmlCouponPopup += "        </div>";
                        htmlCouponPopup += "    </div>";
                        */
                        /***********************************************************/
                        htmlCouponPopup += '<div id="popup_coupon" class="popup" style="height:600px;overflow:auto; -webkit-overflow-scrolling: touch;display:none">';
						htmlCouponPopup += '	<div class="pop_wrap">';
						htmlCouponPopup += '	<div class="popup_header">';
						htmlCouponPopup += '	<h1 class="popup_tit">쿠폰 할인 적용</h1> ';
						htmlCouponPopup += '	<button type="button" class="btn_close_popup" id="btn_restock_close"><img src="/m/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button> ';
						//htmlCouponPopup += '		<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>';
						//htmlCouponPopup += '		<span class="popup_head_text">사용가능 쿠폰만 노출됩니다.</span>';
						htmlCouponPopup += '	</div>';
						htmlCouponPopup += '            <div class="coupon_scroll_tit">';
                        htmlCouponPopup += "                쿠폰 적용 <span>(상품별 사용 가능한 쿠폰만 보여집니다.)</span>";
                        //htmlCouponPopup += "                <button type='button' class='floatR btn_my_coupon'>내쿠폰함</button>";
                        htmlCouponPopup += "            </div>";
						htmlCouponPopup += '	<div class="popup_coupon_scroll">'+goodsList;
						htmlCouponPopup += '	</div>';
						//htmlCouponPopup += '            <div class="coupon_scroll_tit">';
                        //htmlCouponPopup += "                주문서 쿠폰 <span>(사용 가능한 주문서 쿠폰만 보여집니다.)</span>";
                        //htmlCouponPopup += "            </div>";
						//htmlCouponPopup += '	<div class="popup_coupon_scroll">'+couponOrderList;
						//htmlCouponPopup += '	</div>';
						htmlCouponPopup += '	<div class="coupon_discount" style="display: none;">';
                        htmlCouponPopup += '       상품할인<span id="goodsCouponAmt" data-goods-coupon-amt="0"> 0원 </span>';
                        htmlCouponPopup += '        + 주문할인<span id="orderCouponAmt" data-order-coupon-amt="0"> 0원 </span> = ';
						htmlCouponPopup += '	   총할인 : <em><span class="fRed" id="totalCouponAmt" data-total-coupon-amt="0">0원</span></em>';
						htmlCouponPopup += '	</div>';
						htmlCouponPopup += '	<div class="popup_btn_area">';
						htmlCouponPopup += '		<button type="button" class="btn_popup_cancel closepopup">취소</button>';
						htmlCouponPopup += '		<button type="button" class="btn_popup_ok">적용</button>';
						htmlCouponPopup += '	</div>';
						htmlCouponPopup += '	</div>';
						htmlCouponPopup += '</div>';
                        /***********************************************************/
                        
                        documentCouponPopup.append(htmlCouponPopup);
                        
                        documentCouponPopup.find(".btn_popup_cancel").click(function(){
                            //$.unblockUI();
                            Dmall.LayerPopupUtil.close(settings.couponDiv);
                        });
                        
                        if(typeof settings.onLoad === 'function'){
                            var _available_coupon_cnt = 0;
                            var list = new Array();
                            var d={};
                            $('.select_option.selectGoodsCoupon').find('option').each(function(){
                                if($(this).val() != '') {
                                    var data = $(this).data();
                                    if($.inArray(data.couponNo,list) < 0) {
                                        list.push(data.couponNo);
                                    }
                                }
                            });
                            d.useCouponCnt = list.length;       //사용가능쿠폰 수량
                            if(settings.onLoad(d)){
                                /*$.blockUI({
                                    message:$('#popup_coupon')
                                    ,css:{
                                        width:     '100%',
                                        position:  'fixed',
                                        top:       '50px',
                                        left:      '0',
                                    }
                                    ,onOverlayClick: $.unblockUI
                                });*/
                                Dmall.LayerPopupUtil.open(($(settings.couponDiv)));
                            }
                        }else{
                            /*$.blockUI({
                                message:$('#popup_coupon')
                                ,css:{
                                    width:     '100%',
                                    position:  'fixed',
                                    top:       '50px',
                                    left:      '0',
                                }
                                ,onOverlayClick: $.unblockUI
                            });*/
                        	Dmall.LayerPopupUtil.open(($(settings.couponDiv)));
                        }
                        
                        /*내쿠폰함*/
                        documentCouponPopup.find(".btn_my_coupon").click(function(){
                            location.href=MOBILE_CONTEXT_PATH+'/front/coupon/coupon-list';
                        });
                        
                        /*상품 쿠폰 선택(변경)*/
                        documentCouponPopup.find(".selectGoodsCoupon").on("change", function(){
                            var dc = "";
                            var selected    = $(this).children("option:selected");  //선택한 옵션
                            var salePrice   = $(this).parents("li").find("div:first .price_area").data().salePrice;   //선택한 상품 판매 가격
                            var qtt         = $(this).parents("li").find("div:first .qtt_area").data().goodsQtt;    //선택한 상품 수량
                            var goods_no    = $(this).parents("li").parents("ul").data().goodsNo;  //선택한 상품 번호
                            var check_use_goods_coupon = false;   //상품 쿠폰 중복 사용 체크
                            var check_use_order_coupon = false;   //주문서 쿠폰 중복 사용 체크
                            var check_solo_use_yn = false;   //단독 사용 쿠폰 여부 체크
                            var coupon_no = $(selected).data().couponNo;
                            
                            $(this).each(function(){
                                var d=$(selected).data();
                                
                                //최소사용금액 제한
                                if((salePrice*qtt) < d.couponUseLimitAmt) {
                                    /*$.unblockUI();*/
                                    Dmall.LayerPopupUtil.close(settings.couponDiv);
                                    Dmall.LayerUtil.alert("해당 쿠폰의 최소 사용 가능금액은 "+commaNumber(d.couponUseLimitAmt)+"원 이상입니다.");
                                    $(this).val("");
                                    Dmall.SelectUtil.reset(this);   //셀렉트박스 초기화(label)
                                    return false;
                                }
                               
                                //상품 쿠폰 중복 사용 체크
                                documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                    if($(this).val() != "") {
                                        if(coupon_no == $(this).data().couponNo && $(this).parents().attr("id") != $(selected).parents().attr("id")) {
                                            check_use_goods_coupon = true;
                                        }
                                    }
                                });
                                //단독 사용 쿠폰 적용 체크
                                documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                    var couponSoloUseYn = $(this).data().couponSoloUseYn;
                                    if(couponSoloUseYn== "Y") {
                                        check_solo_use_yn = true;
                                    }
                                });

                                if(check_solo_use_yn){
                                    Dmall.LayerUtil.confirm("단독 사용쿠폰을 사용하신 경우엔 다른쿠폰과 함꼐 사용하실 수 없습니다.<br/>선택하신 상품에 쿠폰을 사용하시겠습니까?",
                                        function(){
                                            documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                                if($(this).parents().attr("id") != $(selected).parents().attr("id")) {
                                                    $(this).parent().val("").trigger("change");
                                                }
                                            });
                                            calcOrderDcAmt(null);
                                            calcGoodsDcAmt(selected,d);
                                            return false;
                                        },
                                        function(){
                                            $(selected).parent().val("").trigger("change");
                                            return false;
                                        }
                                    )

                                }
                                
                                //주문서 쿠폰 중복 사용 체크
                                if($(this).val() != "") {
                                    documentCouponPopup.find("#" + settings.couponDiv).find("input:radio:checked").each(function(){
                                        check_use_order_coupon = true;
                                    });
                                }
                                
                                if(check_use_goods_coupon || check_use_order_coupon) {
                                    if(check_use_goods_coupon) {
                                        Dmall.LayerUtil.confirm("동일한 쿠폰은 한번만 사용 가능합니다.<br/>선택하신 상품에 쿠폰을 사용하시겠습니까?",
                                                function(){
                                                    documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                                        if($(this).parents().attr("id") != $(selected).parents().attr("id")) {
                                                            $(this).parent().val("").trigger("change");
                                                        }
                                                    });
                                                    calcOrderDcAmt(null);
                                                    calcGoodsDcAmt(selected,d);
                                                    return false;
                                                },
                                                function(){
                                                    $(selected).parent().val("").trigger("change");
                                                    return false;
                                                }
                                            )
                                    }
                                    
                                    if(check_use_order_coupon) {
                                        Dmall.LayerUtil.confirm("상품쿠폰과 주문서 쿠폰은 중복 사용이 불가능합니다.<br/>선택하신 쿠폰을 사용하시겠습니까?",
                                            function(){
                                                documentCouponPopup.find("#" + settings.couponDiv).find("input:radio").each(function(){
                                                    $(this).prop("checked",false);
                                                });
                                                calcOrderDcAmt(null);
                                                calcGoodsDcAmt(selected,d);
                                                return false;
                                            },
                                            function(){
                                                $(selected).parent().val("").trigger("change");
                                                return false;
                                            }
                                        )
                                    }
                                } else {
                                    calcGoodsDcAmt(selected,d);
                                }
                                
                            });
                            
                        });
                        
                        /*주문서 쿠폰 선택(변경)*/
                        documentCouponPopup.find(".selectOrderCoupon").on("change", function(){
                            var dc = "";
                            var check_use_goods_coupon = false;   //상품 쿠폰 중복 사용 체크
                            var d=$(this).data();
                            
                            //최소사용금액 제한
                            if(settings.orderTotalAmt < d.couponUseLimitAmt) {
                                /*$.unblockUI();*/
                                Dmall.LayerPopupUtil.close(settings.couponDiv);
                                Dmall.LayerUtil.alert("해당 쿠폰의 최소 사용 가능금액은 "+commaNumber(d.couponUseLimitAmt)+"원 이상입니다.");
                                $(this).prop("checked",false);
                                return false;
                            }
                            
                            //상품 쿠폰 중복 사용 체크
                            documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                if($(this).val() != "") {
                                    check_use_goods_coupon = true;
                                }
                            });                                
                            if(check_use_goods_coupon) {
                                Dmall.LayerUtil.confirm("상품쿠폰과 주문서 쿠폰은 중복 사용이 불가능합니다.<br/>선택하신 쿠폰을 사용하시겠습니까?",
                                    function(){
                                        documentCouponPopup.find("#" + settings.couponDiv).find("select").each(function(){
                                            $(this).val("");
                                            $(this).trigger("change")
                                        });
                                        calcOrderDcAmt(documentCouponPopup.find(".selectOrderCoupon:checked"),d);
                                        return false;
                                    },
                                    function(){
                                        documentCouponPopup.find(".selectOrderCoupon:checked").prop("checked",false);
                                        return false;
                                    }
                                )
                            } else {
                                calcOrderDcAmt(this,d);
                            }
                            
                        });
                        
                        /*적용*/
                        documentCouponPopup.find(".btn_popup_ok").on("click", function(){
                            var i = 0;
                            var selectData = [];
                            documentCouponPopup.find("#" + settings.couponDiv).find("select option:selected").each(function(){
                                if($(this).val() != "") {
                                    selectData[i] = $(this).data();
                                    i++;
                                }
                            });
                            documentCouponPopup.find("#" + settings.couponDiv).find("input:radio:checked").each(function(){
                                if($(this).val() != "") {
                                    selectData[i] = $(this).data();
                                    i++;
                                }
                            });
                            
                            var result = {};
                            
                            try{
                                result.dcTotalAmt = $("#totalCouponAmt").data().totalCouponAmt;
                            }catch (e) {
                                result.dcTotalAmt="0";
                            }
                            
                            if(selectData.length > 0) {
                                result.selectData = selectData;
                                if(typeof settings.onApply === 'function' ){
                                    settings.onApply(result);
                                    Dmall.LayerPopupUtil.close(settings.couponDiv);
                                    //$.unblockUI();
                                }else{
                                    Dmall.LayerPopupUtil.close(settings.couponDiv);
                                    //$.unblockUI();
                                }
                            } else {
                                if(typeof settings.onApply === 'function' ){
                                    result.selectorData = [];
                                    settings.onApply(result);
                                }
                                Dmall.LayerPopupUtil.close(settings.couponDiv);
                                //$.unblockUI();
                            }
                        })
                        
                    },
                    error : function(XMLHttpRequest, textStatus, errorThrown) {
                        
                        if(settings.log) {
                            try{ console.log("textStatus : "+textStatus+"\n"+errorThrown)} catch(e) {} 
                        }
                    }
                    
                })
                /*var kkk = function(arg) {
                    alert(arg);
                }*/
        });
        
        this.each( function() {
            $(this).click(function(){
                if(htmlCouponPopup){
                    var option_cnt = 0;
                    var i = 0;
                    var j = 0;
                    //상품쿠폰
                    $("#" + settings.couponDiv).find("select").each(function(){
                        option_cnt += $(this).children("option").length;
                        i++;
                    });
                    //주문서쿠폰
                    $("#" + settings.couponDiv).find("input[type='radio']").each(function(){
                        j++;
                    });
                    if(i == 0 && j==0){ 
                        Dmall.LayerUtil.alert("사용 가능한 쿠폰이 없습니다.");
                    } else {

                      Dmall.LayerPopupUtil.open(($('#'+settings.couponDiv)));

                       $('.select_option.selectGoodsCoupon').find('option').each(function(){
                                if($(this).parent().val()==''){
                                    if($(this).val() != '') {
                                        var data = $(this).data();
                                        var couponNo = data.couponNo;
                                        var couponAvlNo =data.couponAvlNo;
                                        if(couponNo==couponAvlNo){
                                            $(this).parent().val(couponNo).trigger("change");
                                        }
                                    }
                                }else{
                                }
                            });

                      /*  $('body').css('overflow-y','hidden').on('touchstart', function(e){
                            
                            e.preventDefault();
                            
                            });*/

                        /*$.blockUI({
                            message:$('#popup_coupon')
                            ,css:{
                                width:     '100%',
                                position:  'fixed',
                                top:       '0px',
                                left:      '0'
                            }
                            ,onOverlayClick: $.unblockUI
                        });*/

                    }
                }else{

                    if(typeof settings.onError === 'function' ){
                        settings.onError();
                    }else if(typeof settings.onError === 'string' ){
                        alert(settings.onError);
                    }
                }
            });
        });
        
        createPop();
        
    }    
})(jQuery, document, window)