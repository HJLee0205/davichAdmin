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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">장바구니</t:putAttribute>
    <t:putAttribute name="script">
    <%-- 텐션DA SCRIPT --%>
	<script>
		ex2cts.push('track', 'cart');
	</script>
	<%--// 텐션DA SCRIPT --%>
    <%-- 카카오 모먼트 --%>
	<script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
	<script type="text/javascript">
		  kakaoPixel('59690711162928695').pageView();
		  kakaoPixel('59690711162928695').viewCart();
		  kakaoPixel('7385103066531646539').pageView();
      	  kakaoPixel('7385103066531646539').viewCart();
	</script>
	<%-- // 카카오 모먼트 --%>

	<script>
	  gtag('event', 'conversion', {'send_to': 'AW-760445332/V0FYCK6azpYBEJTzzeoC','value': 1.0,'currency': 'KRW'});
	</script>
	<script src="${_MOBILE_PATH}/front/js/coupon.js" type="text/javascript" charset="utf-8"></script>

	<%--Cauly CPA 광고--%>
    <%--<script type="text/javascript" src="//image.cauly.co.kr/cpa/util_sha1.js" ></script>
    <script type="text/javascript">
      window._paq = window._paq || [];
      _paq.push(['track_code',"a9a01f1f-8e03-4d4d-af16-1b95e46fe041"]);
      _paq.push(['event_name','CA_BASKET']);
      _paq.push(['send_event']);
      (function() { var u="//image.cauly.co.kr/script/"; var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'caulytracker_async.js'; s.parentNode.insertBefore(g,s); }
      )();
    </script>--%>
    <%-- // Cauly CPA 광고--%>
    <script>
    $(document).ready(function(){
    	
    	//상품 체크박스 클릭
    	$('.order_check').click(function(){
    		BasketUtil.paymentTotInfo();
    	});
    	
        jQuery('[name=btnBasketUpdate]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var goodsNo = jQuery(this).parents('li').data('goods-no');
            var itemNo = jQuery(this).parents('li').data('item-no');
            var itemNm = jQuery(this).parents('li').data('item-nm');
            var itemPrice = jQuery(this).parents('li').data('item-price');
            var sessionIndex = jQuery(this).parents('li').data('session-index');

            var param = param = 'goodsNo='+goodsNo+'&itemNo='+itemNo+'&sessionIndex='+sessionIndex;
            var url = '${_MOBILE_PATH}/front/basket/goods-detail?'+param;

            Dmall.AjaxUtil.load(url, function(result) {
                $('#goodsDetail').html(result);
            })
            Dmall.LayerPopupUtil.open($("#success_basket"));
        });

        jQuery('[name=btnBasketUpdateCnt]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var basketNo = $(this).parents('li').data('basket-no');
            var goodsNo = $(this).parents('li').data('goods-no');
            var itemNo = $(this).parents('li').data('item-no');
            var sessionIndex = $(this).parents('li').data('session-index');
            var buyQtt = $("#buyQtt_"+sessionIndex).val();
            var stockQtt = $(this).parents('li').data('stock-qtt');
            var itemNm = $(this).data('attr-nm') + ' (재고:' + stockQtt + ')'; //단품명
            var minOrdLimitYn = $(this).parents('li').data('min-limit-yn'); //최소 주문수량 제한 여부
            var minOrdQtt = $(this).parents('li').data('min-ord-qtt'); //최소 주문 수량
            var maxOrdLimitYn = $(this).parents('li').data('max-limit-yn'); //최대 주문수량 제한 여부
            var maxOrdQtt = $(this).parents('li').data('max-ord-qtt'); //최대 주문 수량

            //검증
            //재고 확인
            if(Number(stockQtt) < Number(buyQtt)) {
                if(itemNm == '') {
                    Dmall.LayerUtil.alert('재고수량을 확인해 주시기 바랍니다.');
                } else {
                    Dmall.LayerUtil.alert(itemNm+'<br>재고수량을 확인해 주시기 바랍니다.');
                }
                return false;
            }

            //최소 구매 수량 확인
            if(minOrdLimitYn == 'Y') {
                if(Number(minOrdQtt) > Number(buyQtt)) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }

             //최대 구매 수량 확인
            if(maxOrdLimitYn == 'Y') {
                if(Number(maxOrdQtt) < Number(buyQtt)) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }

            var url = '${_MOBILE_PATH}/front/basket/basket-count-update';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('${_MOBILE_PATH}/front/basket/basket-list', {});
                 }
            })
        });
        
        

        
        // 매장픽업
        jQuery('#chkPickup').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            $('input:checkbox[name=delBasketNoArr]').each(function() {
                var dlvrcPaymentCd = $(this).parents('li').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('li').data('rsv-only-yn');
                
                // 매장픽업/택배
                if (dlvrcPaymentCd == "04" || rsvOnlyYn == "Y") {
                	$(this).prop("checked", true); 
                } else {
                	$(this).prop("checked", false); 
                }
            });
            BasketUtil.paymentTotInfo();
        });       
        
        
        // 택배상품만
        jQuery('#chkDeliv').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            $('input:checkbox[name=delBasketNoArr]').each(function() {
                var dlvrcPaymentCd = $(this).parents('li').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('li').data('rsv-only-yn');
                
                // 매장픽업/택배
                if (dlvrcPaymentCd == "04" || rsvOnlyYn == "Y") {
                	$(this).prop("checked", false); 
                } else {
                	$(this).prop("checked", true); 
                }
            });
            BasketUtil.paymentTotInfo();
        });               

        jQuery('[name=btn_basket_del2]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var basketNo = jQuery(this).parents('li').data('basket-no');
            var goodsNo = jQuery(this).parents('li').data('goods-no');
            var itemNo = jQuery(this).parents('li').data('item-no');
            var sessionIndex = jQuery(this).parents('li').data('session-index');
            var buyQtt = jQuery("#buyQtt_"+sessionIndex).val();
            
            var url = '${_MOBILE_PATH}/front/basket/basket-delete';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('${_MOBILE_PATH}/front/basket/basket-list', {});
                 }
            })
        });
        

        jQuery('[name=selectDelete]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var delChk = $('input:checkbox[name=delBasketNoArr]').is(':checked');
            if(delChk==false){
                Dmall.LayerUtil.alert('삭제할 상품을 체크해 주세요');
                return;
            }

            var url = '${_MOBILE_PATH}/front/basket/check-basket-delete';
            var param = $('#basket_form').serialize();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('${_MOBILE_PATH}/front/basket/basket-list', {});
                 }
            })
        });

        jQuery('[name=allDelete]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var url = '${_MOBILE_PATH}/front/basket/basket-all-delete';
            var param = {}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('${_MOBILE_PATH}/front/basket/basket-list', {});
                 }
            })
        });
        /* 전체선택 */
        $("#allCheck").on('click', function(e) {
            BasketUtil.allCheckBox('input');
        });

        /* 전체선택버튼 */
        $("#allCheckBtn").on('click', function(e) {
            BasketUtil.allCheckBox('checkBtn');
        });

        /* 전체선택해제 */
        $("#allUnCheckBtn").on('click', function(e) {
            BasketUtil.allCheckBox('uncheckBtn');
        });

        
        $("#regSelectOrdInfo").click(function(){
            var delChk = $('input:checkbox[name=delBasketNoArr]').is(':checked');
            if(delChk==false){
                Dmall.LayerUtil.alert('주문할 상품을 체크해 주세요');
                return;
            }

            var errorMsg = '';
            var flag = true;

            //특가상품 주문 가격 확인
            var spcPrdCnt = 0;
            var totalOrdPrice = 0;
            $('input:checkbox[name=delBasketNoArr]:checked').each(function(idx) {
                 totalOrdPrice += jQuery(this).parents('li').data('ord-price'); // 개별 주문 가격
                 if(jQuery(this).parents('li').data('spc-yn')=='Y'){
                    spcPrdCnt++;
                 }
            });

            if(spcPrdCnt>0){
                if(spcPrdCnt > 1) {
                        errorMsg = '프로모션 특가 할인 적용 상품은 하나만 구매 하실 수 있습니다.';
                        flag = false;
                }else {
                    if (totalOrdPrice < 10000) {
                        errorMsg = '프로모션 특가 할인 적용 상품이 포합되어 있습니다. <br> 10,000원 이상 구매시 주문하실 수 있습니다.'
                        flag = false;
                    }
                }
            }

            if(!flag) {
                Dmall.LayerUtil.alert(errorMsg);
                return;
            }

            if($('input:checkbox[name=delBasketNoArr]:checked').length === 1) {
                var status = $('input:checkbox[name=delBasketNoArr]:checked').parents('li').data('goods-sale-status-cd');
                if(status === 2) {
                    errorMsg = '품절 상품입니다';
                    flag = false;
                } else if(status === 3) {
                    errorMsg = '판매대기 상품입니다';
                    flag = false;
                } else if(status === 4) {
                    errorMsg = '판매중지 상품입니다';
                    flag = false;
                }
            } else {
                $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                    var status = $(this).parents('li').data('goods-sale-status-cd');
                    if(status !== 1) {
                        errorMsg = '품절, 판매중지, 판매대기된 상품이 존재합니다';
                        flag = false;
                    }
                });
            }

            if(!flag) {
                Dmall.LayerUtil.alert(errorMsg);
                return;
            }

          //재고수량확인
            var msgArr1 = '';
            $('input:checkbox[name=delBasketNoArr]:checked').each(function(idx) {
                var sessionIndex = $(this).parents('li').data('session-index');
                var buyQtt = $(this).parents('li').data('buy-qtt');
                var goodsNm = $(this).parents('li').data('item-nm');
                var stockQtt = $(this).parents('li').data('stock-qtt');
                var attrNm = $(this).parents('li').find('.text-attr-nm').val();
                if(attrNm !== '') {
                    goodsNm += '[' + attrNm + '](재고:' + stockQtt + ')';
                }
                var multiOptYn = $(this).parents('li').data('multi-opt-yn');
                var stockSetYn = $(this).parents('li').data('stock-set-yn');
                var availStockSaleYn = $(this).parents('li').data('avail-stock-sale-yn');
                var availStockQtt = $(this).parents('li').data('avail-stock-qtt');
                var stockQttOk = false;
                var validationStockQtt = $(this).parents('li').data('stock-qtt');
                //재고 확인
                if(multiOptYn == 'Y') {
                    stockQttOk = jsCheckOptionStockQtt(this);
                    if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                        validationStockQtt += Number(availStockQtt);
                    }

                    if(!stockQttOk) {
                        flag = false;
                    }
                } else {
                    if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                        validationStockQtt += Number(availStockQtt);
                    }
                    stockQttOk = jsCheckOptionStockQtt(this);
                }
                if(!stockQttOk) {
                    if(validationStockQtt < 0) {
                        validationStockQtt = 0;
                    }

                    if(idx === 0) {
                        msgArr1 += goodsNm;
                    } else {
                        msgArr1 += '<br/><br/>' + goodsNm;
                    }
                    msgArr1 += '<br/>재고: '+commaNumber(validationStockQtt)+'개<br>재고수량을 확인해 주시기 바랍니다.';
                    flag = false;
                }
            });

            if(!flag) {
                Dmall.LayerUtil.alert(msgArr1);
                return;
            }

            var msgArr = '';
            $('input:checkbox[name=delBasketNoArr]:checked').each(function(idx) {
                var sessionIndex = $(this).parents('li').data('session-index');
                var buyQtt = $(this).parents('li').data('buy-qtt');
                var minOrdLimitYn = $(this).parents('li').data('min-limit-yn'); //최소 주문수량 제한 여부
                var minOrdQtt = $(this).parents('li').data('min-ord-qtt'); //최소 주문 수량
                var maxOrdLimitYn = $(this).parents('li').data('max-limit-yn'); //최대 주문수량 제한 여부
                var maxOrdQtt = $(this).parents('li').data('max-ord-qtt'); //최대 주문 수량
                var goodsNm = $(this).parents('li').data('item-nm');
                var stockQtt = $(this).parents('li').data('stock-qtt');
                var attrNm = $(this).parents('li').find('.text-attr-nm').val();
                if(attrNm !== '') {
                    goodsNm += '[' + attrNm + '](재고:' + stockQtt + ')';
                }

                if(minOrdLimitYn == 'Y') { //최소 구매 수량 확인
                    if(Number(minOrdQtt) > Number(buyQtt)) {
                        if(idx === 0) {
                            msgArr += goodsNm;
                        } else {
                            msgArr += '<br/><br/>' + goodsNm;
                        }
                        msgArr += '<br/>최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.';
                        flag = false;
                    }
                }

                if(maxOrdLimitYn == 'Y') { //최대 구매 수량 확인
                    if(Number(maxOrdQtt) < Number(buyQtt)) {
                        if(idx === 0) {
                            msgArr += goodsNm;
                        } else {
                            msgArr += '<br/><br/>' + goodsNm;
                        }
                        msgArr += '<br/>최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.';
                        flag = false;
                    }
                }
            });

            if(!flag) {
                Dmall.LayerUtil.alert(msgArr);
                return;
            }

            var basketList = '${basket_list_json}';
            if(basketList != ''){
                var obj = jQuery.parseJSON(basketList); //단품정보
                for(var i=0;i<obj.length;i++){
                    var basketNo = obj[i].basketNo;
                    var multiOptYn = obj[i].multiOptYn;
                    if(jQuery("#delBasketNoArr_"+basketNo).prop("checked")){
                        var goods = jQuery("#goodsNo"+basketNo).val();
                        var itemNo = jQuery("#itemNoArr"+basketNo).val();
                        if(multiOptYn === 'Y') {
                            if(jQuery("#itemVerChk"+basketNo).val()=="N"){
                            	Dmall.LayerUtil.alert(goods+'의 옵션이 변경되어 주문이 불가능합니다.<br>삭제 후 장바구니에 다시 담아주세요.');
                                return;
                            }
                            if(jQuery("#attrVerChk"+basketNo).val()=="N"){
                            	Dmall.LayerUtil.alert(goods+'의 옵션이 변경되어 주문이 불가능합니다.<br>삭제 후 장바구니에 다시 담아주세요.');
                                return;
                            }
                        }
                    }
                }
            }

            if(basketList != ''){
                var obj = jQuery.parseJSON(basketList); //단품정보
                for(var i=0;i<obj.length;i++){
                    var basketNo = obj[i].basketNo;

                    if(!jQuery("#delBasketNoArr_"+basketNo).prop("checked")){
                        jQuery("#itemArr"+basketNo).remove();
                    }
                }
            }
            
			var deliv = false;
			var storeVisit = false;
			
			// 택배,매장픽업,예약전용 주문 체크
            $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                var dlvrcPaymentCd = $(this).parents('li').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('li').data('rsv-only-yn');
                
                // 매장픽업/택배
                if (dlvrcPaymentCd == "04" || rsvOnlyYn == "Y") {
                	storeVisit = true;
                } else {
                	deliv = true;
                }
            });
			
            if(deliv && storeVisit){
                Dmall.LayerUtil.alert('택배상품은 매장픽업 또는 예약전용 상품과 같이 주문진행을 하실수 없습니다.');
                return;
            }
            
            
			var orderYn = true;
			// 주문인지 예약인지 확인
            if($('input:checkbox[name=delBasketNoArr]:checked').length === 1) {
                var rsvYn = $('input:checkbox[name=delBasketNoArr]:checked').parents('li').data('rsv-only-yn');
                
                if (rsvYn == "Y") {
                	orderYn = false ;
                }
			                
            } else {
            	var chk = 0;
                $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                	chk++;
                });
            	
				var rsvChk = 0;            	
                $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                    var rsvYn = $(this).parents('li').data('rsv-only-yn');
                    if (rsvYn == "Y") {
						rsvChk++;                    	
                    }
                });
                
                if (chk <= rsvChk) {
                	orderYn = false ;
                }
            }	      
			
            var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
            var memberNo =  '${user.session.memberNo}';
            
        	var dlvrMethod = false;
			// 매장픽업
            $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                var dlvrcPaymentCd = $(this).parents('li').data('dlvrc-payment-cd');
                // 매장픽업/택배
                if (dlvrcPaymentCd == "04") {
                	dlvrMethod = true;
                }
            });
			
            //비회원 주문일 경우
  	         if (memberNo == null ||  memberNo == '' || memberNo == 'undefined') {
  	         	// 매장픽업
  	         	if (dlvrMethod) {
  	             	Dmall.LayerUtil.alert("비회원 주문일 경우는 매장픽업으로 주문을 진행할수 없습니다.");
  	             	return false;
  	         	}
  	         } else {
   	         	// 매장픽업
   	         	if (integrationMemberGbCd == '02' && dlvrMethod) {
   	             	Dmall.LayerUtil.alert("간편회원일 경우는 매장픽업으로 주문을 진행할수 없습니다.");
   	             	return false;
   	         	}
    	     }          			
			
			if (orderYn) {
	            $('#basket_form').attr('action','${_DMALL_HTTPS_SERVER_URL}/${_MOBILE_PATH}/front/order/order-form');
	            $('#basket_form').attr('method','post');
	            $('#basket_form').submit();
			} else {
                Dmall.LayerUtil.alert("예약전용 상품만을 선택한경우 방문예약 화면으로 이동합니다.").done(function(){
    	            $('#basket_form').attr('action','${_MOBILE_PATH}/front/visit/visit-book');
    	            $('#basket_form').attr('method','post');
    	            $('#basket_form').submit();
                });
			}			
         });
        
        
        jQuery('[name=btn_basket_order], [name=btn_basket_book]').on('click', function(e){
            e.preventDefault();
            e.stopPropagation();

            var index = jQuery(this).parents('li').data('session-index');
            var btnItemNo = jQuery("#itemArr"+index).val();
            var goods = jQuery("#goodsNo"+index).val();
            var itemNo = jQuery("#itemNoArr"+index).val();
            var stockQtt = $(this).parents('li').data('stock-qtt');
            var validationStockQtt = $(this).parents('li').data('stock-qtt');
            var itemNm = $(this).parents('li').find('.text-attr-nm').val(); // + ' (재고:' + stockQtt + ')'; //단품명
            //var buyQtt = $("#buyQtt_"+index).val(); //이값은 현재 input tag에 있는 값
            var buyQtt = $(this).parents('li').data('buy-qtt'); //이값은 DB, session(비회원)에 저장된 값
            var minOrdLimitYn = $(this).parents('li').data('min-limit-yn'); //최소 주문수량 제한 여부
            var minOrdQtt = $(this).parents('li').data('min-ord-qtt'); //최소 주문 수량
            var maxOrdLimitYn = $(this).parents('li').data('max-limit-yn'); //최대 주문수량 제한 여부
            var maxOrdQtt = $(this).parents('li').data('max-ord-qtt'); //최대 주문 수량
            var multiOptYn = $(this).parents('li').data('multi-opt-yn');
            var stockSetYn = $(this).parents('li').data('stock-set-yn');
            var availStockSaleYn = $(this).parents('li').data('avail-stock-sale-yn');
            var availStockQtt = $(this).parents('li').data('avail-stock-qtt');
            var stockQttOk = false;
            var dlvrcPaymentCd = $(this).parents('li').data('dlvrc-payment-cd');
            var memberNo =  '${user.session.memberNo}';
            var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';

            var ordPrice = jQuery(this).parents('li').data('ord-price'); // 개별 주문 가격
            var spcYn = jQuery(this).parents('li').data('spc-yn'); // 특가 적용여부 가격

            //특가적용 상품일경우
            if(spcYn=='Y'){
                if(ordPrice < 10000){
                    Dmall.LayerUtil.alert("프로모션 특가 할인 적용 상품입니다. <br> 10,000원 이상 구매시 주문하실 수 있습니다.");
  	             	return false;
                }
            }

            //비회원 주문일 경우
  	        if (memberNo == null ||  memberNo == '' || memberNo == 'undefined') {
  	         	// 매장픽업
  	         	if (dlvrcPaymentCd == '04') {
  	             	Dmall.LayerUtil.alert("비회원 주문일 경우는 매장픽업으로 주문을 진행할수 없습니다.");
  	             	return false;
  	         	}
  	        } else {
   	         	// 매장픽업
   	         	if (integrationMemberGbCd == '02' && dlvrcPaymentCd == '04' ) {
   	             	Dmall.LayerUtil.alert("간편회원일 경우는 매장픽업으로 주문을 진행할수 없습니다.");
   	             	return false;
   	         	}
  	        }                 
            
            //재고 확인
            if(multiOptYn == 'Y') {
                stockQttOk = jsCheckOptionStockQtt(this);
                if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                    validationStockQtt += Number(availStockQtt);
                }

                if(!stockQttOk) {
                    return false;
                }
            } else {
                if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                    validationStockQtt += Number(availStockQtt);
                }
                stockQttOk = jsCheckOptionStockQtt(this);
            }
            if(!stockQttOk) {
                if(validationStockQtt < 0) {
                    validationStockQtt = 0;
                }
                if(itemNm == '') {
                    Dmall.LayerUtil.alert('재고: '+commaNumber(validationStockQtt)+'개<br>재고수량을 확인해 주시기 바랍니다.');
                } else {
                    Dmall.LayerUtil.alert(itemNm+'<br>재고수량을 확인해 주시기 바랍니다.');
                }
                return false;
            }

            //최소 구매 수량 확인
            if(minOrdLimitYn == 'Y') {
                if(Number(minOrdQtt) > Number(buyQtt)) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }

             //최대 구매 수량 확인
            if(maxOrdLimitYn == 'Y') {
                if(Number(maxOrdQtt) < Number(buyQtt)) {
                    if(itemNm == '') {
                        Dmall.LayerUtil.alert('최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    } else {
                        Dmall.LayerUtil.alert(itemNm+'<br>최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.');
                    }
                    return false;
                }
            }

             if(multiOptYn === 'Y') {
                 if(jQuery("#itemVerChk"+index).val()=="N"){
                	 Dmall.LayerUtil.alert(goods+'의 옵션이 변경되어 주문이 불가능합니다.<br>삭제 후 장바구니에 다시 담아주세요.');
                     return;
                 }
                 if(jQuery("#attrVerChk"+index).val()=="N"){
                	 Dmall.LayerUtil.alert(goods+'의 옵션이 변경되어 주문이 불가능합니다.<br>삭제 후 장바구니에 다시 담아주세요.');
                     return;
                 }
             }

            jQuery("#itemNoArrDiv").empty();
            var itemNoObj="";
            itemNoObj = '<input type="hidden" name="itemArr" id="itemArr'+index+'" class="" style="width:500px;" value="'+btnItemNo+'">';

            var itemNoArrDiv = jQuery("#itemNoArrDiv");
            itemNoArrDiv.append(itemNoObj);
            
            
            if (e.target.name == "btn_basket_book") {
	            if(loginYn) {
    	            $('#basket_form').attr('action','${_MOBILE_PATH}/front/visit/visit-book');
    	            $('#basket_form').attr('method','post');
    	            $('#basket_form').submit();
	            } else {
	                Dmall.LayerUtil.confirm("예약전용 상품인 경우는 로그인이 필요합니다. 지금 로그인 하시겠습니까?",
	                        function() {
	                        var returnUrl = window.location.pathname+window.location.search;
	                        location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
	                        },''
                    );
	            }
            } else {
	             $('#basket_form').attr('action','${_DMALL_HTTPS_SERVER_URL}/${_MOBILE_PATH}/front/order/order-form');
	             $('#basket_form').attr('method','post');
	             $('#basket_form').submit();
            }
        })

        $("#regTotalOrdInfo").click(function(){
            var basket_size = '${basket_size}';
            if(basket_size === '0') {
                Dmall.LayerUtil.alert('장바구니에 상품이 존재하지 않습니다.');
                return;
            }

            var flag = true;
            $('input:checkbox[name=delBasketNoArr]').each(function() {
                var status = $(this).parents('tr').data('goods-sale-status-cd');
                if(status !== 1) {
                    Dmall.LayerUtil.alert('품절, 판매중지, 판매대기된 상품이 존재합니다');
                    flag = false;
                }
            });

            if(!flag) {
                return;
            }

            //재고수량확인
            var msgArr1 = '';
            $('input:checkbox[name=delBasketNoArr]').each(function(idx) {
                var sessionIndex = $(this).parents('li').data('session-index');
                var buyQtt = $(this).parents('li').data('buy-qtt');
                var goodsNm = $(this).parents('li').data('item-nm');
                var stockQtt = $(this).parents('li').data('stock-qtt');
                var attrNm = $(this).parents('li').find('.text-attr-nm').val();
                if(attrNm !== '') {
                    goodsNm += '[' + attrNm + '](재고:' + stockQtt + ')';
                }
                var multiOptYn = $(this).parents('li').data('multi-opt-yn');
                var stockSetYn = $(this).parents('li').data('stock-set-yn');
                var availStockSaleYn = $(this).parents('li').data('avail-stock-sale-yn');
                var availStockQtt = $(this).parents('li').data('avail-stock-qtt');
                var stockQttOk = false;
                var validationStockQtt = $(this).parents('li').data('stock-qtt');

                //재고 확인
                if(multiOptYn == 'Y') {
                    stockQttOk = jsCheckOptionStockQtt(this);
                    if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                        validationStockQtt += Number(availStockQtt);
                    }

                    if(!stockQttOk) {
                        flag = false;
                    }
                } else {
                    if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                        validationStockQtt += Number(availStockQtt);
                    }
                    stockQttOk = jsCheckOptionStockQtt(this);
                }
                if(!stockQttOk) {
                    if(validationStockQtt < 0) {
                        validationStockQtt = 0;
                    }

                    if(idx === 0) {
                        msgArr1 += goodsNm;
                    } else {
                        msgArr1 += '<br/><br/>' + goodsNm;
                    }

                    msgArr1 += '<br/>재고: '+commaNumber(validationStockQtt)+'개<br>재고수량을 확인해 주시기 바랍니다.';
                    flag = false;
                }
            });

            if(!flag) {
                Dmall.LayerUtil.alert(msgArr1);
                return;
            }

            var msgArr = '';
            $('input:checkbox[name=delBasketNoArr]').each(function(idx) {
                var sessionIndex = $(this).parents('li').data('session-index');
                var buyQtt = $(this).parents('li').data('buy-qtt');
                var minOrdLimitYn = $(this).parents('li').data('min-limit-yn'); //최소 주문수량 제한 여부
                var minOrdQtt = $(this).parents('li').data('min-ord-qtt'); //최소 주문 수량
                var maxOrdLimitYn = $(this).parents('li').data('max-limit-yn'); //최대 주문수량 제한 여부
                var maxOrdQtt = $(this).parents('li').data('max-ord-qtt'); //최대 주문 수량
                var goodsNm = $(this).parents('li').data('item-nm');
                var stockQtt = $(this).parents('li').data('stock-qtt');
                var attrNm = $(this).parents('li').find('.text-attr-nm').val();
                if(attrNm !== '') {
                    goodsNm += '[' + attrNm + '](재고:' + stockQtt + ')';
                }

                if(minOrdLimitYn == 'Y') { //최소 구매 수량 확인
                    if(Number(minOrdQtt) > Number(buyQtt)) {
                        if(idx === 0) {
                            msgArr += goodsNm;
                        } else {
                            msgArr += '<br/><br/>' + goodsNm;
                        }
                        msgArr += '<br/>최소 구매 수량은 '+minOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.';
                        flag = false;
                    }
                }

                if(maxOrdLimitYn == 'Y') { //최대 구매 수량 확인
                    if(Number(maxOrdQtt) < Number(buyQtt)) {
                        if(idx === 0) {
                            msgArr += goodsNm;
                        } else {
                            msgArr += '<br/><br/>' + goodsNm;
                        }
                        msgArr += '<br/>최대 구매 수량은 '+maxOrdQtt+'개 입니다.<br>구매수량을 확인해 주시기 바랍니다.';
                        flag = false;
                    }
                }
            });

            if(!flag) {
                Dmall.LayerUtil.alert(msgArr);
                return;
            }

            var basketList = '${basket_list_json}';
            if(basketList != ''){
                var obj = jQuery.parseJSON(basketList); //단품정보
                for(var i=0;i<obj.length;i++){
                    var basketNo = obj[i].basketNo;
                    var goods = jQuery("#goodsNo"+basketNo).val();
                    var itemNo = jQuery("#itemNoArr"+basketNo).val();
                    var multiOptYn = obj[i].multiOptYn;

                    if(multiOptYn === 'Y') {
                        if(jQuery("#itemVerChk"+basketNo).val()=="N"){
                            Dmall.LayerUtil.alert('상품('+goods+')의 아이템('+itemNo+') 버전이 변경 되엇습니다. 확인하여 주세요.');
                            return;
                        }
                        if(jQuery("#attrVerChk"+basketNo).val()=="N"){
                            Dmall.LayerUtil.alert('상품('+goods+')의 속성('+itemNo+') 버전이 변경 되었습니다. 확인하여 주세요.');
                            return;
                        }
                    }
                }
            }

            if(basketList != ''){
                var obj = jQuery.parseJSON(basketList); //단품정보
                for(var i=0;i<obj.length;i++){
                    var basketNo = obj[i].basketNo;
                    var status = obj[i].goodsSaleStatusCd;
                    if(status !== '1'){
                        jQuery("#itemArr"+basketNo).remove();
                    }
                }
            }
            
            
			var orderYn = true;
			
			// 주문인지 예약인지 확인
            if($('input:checkbox[name=delBasketNoArr]:checked').length === 1) {
                var rsvYn = $('input:checkbox[name=delBasketNoArr]:checked').parents('tr').data('rsv-only-yn');
                
                if (rsvYn == "Y") {
                	orderYn = false ;
                }
			                
            } else {
            	var chk = 0;
                $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                	chk++;
                });
            	
				var rsvChk = 0;            	
                $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                    var rsvYn = $(this).parents('tr').data('rsv-only-yn');
                    if (rsvYn == "Y") {
						rsvChk++;                    	
                    }
                });
                
                if (chk <= rsvChk) {
                	orderYn = false ;
                }
            }	
			
            $('#basket_form').attr('action','${_DMALL_HTTPS_SERVER_URL}/${_MOBILE_PATH}/front/order/order-form');
            $('#basket_form').attr('method','post');
            $('#basket_form').submit();
			
        })

        if("${memberNoYn}"=="N"){
            jQuery(".nonmember_cart_info").show();
        }
        totalItemArr();

        $('.insert-interest').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            BasketUtil.insertInterest($(this).parents('li').attr('data-goods-no'));
        });
    });
    
    
    /* 재고 확인 */
    function jsCheckOptionStockQtt(obj) {
        var rtn = true;
        var stockSetYn = $(obj).parents('li').data('stock-set-yn');
        var availStockSaleYn = $(obj).parents('li').data('avail-stock-sale-yn');
        var availStockQtt = $(obj).parents('li').data('avail-stock-qtt');
        var stockQtt = $(obj).parents('li').data('stock-qtt');
        var buyQtt = $(obj).parents('li').data('buy-qtt'); //이값은 DB, session(비회원)에 저장된 값


        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
            stockQtt += Number(availStockQtt);
        }
        if(Number(stockQtt) > Number(buyQtt)) {
            rtn = true;
        } else {
            rtn = false;
        }
        return rtn;
    }

    function totalItemArr(){
        var totalItemArr = '';
        var basketList = '${basket_list_json}';
        if(basketList != ''){
            var obj = jQuery.parseJSON(basketList); //단품정보
            for(var i=0;i<obj.length;i++){
                var goodsNo = obj[i].goodsNo;
                var itemNo = obj[i].itemNo;
                var buyQtt = obj[i].buyQtt;
                var basketNo = obj[i].basketNo;
                
                var dlvrcPaymentCd = obj[i].dlvrcPaymentCd;
                var ctgNo = obj[i].ctgNo;
                if(totalItemArr != '') {
                    totalItemArr += '*';
                }
                totalItemArr=goodsNo+"▦"+itemNo+"^"+buyQtt+"^"+dlvrcPaymentCd+"▦";

                var basketOptList = obj[i].basketOptList;
                var addOptArr = '';
                if(basketOptList != ''){
                   for(var j = 0; j < basketOptList.length; j++){
                       var addOptNo = basketOptList[j].addOptNo;
                       var addOptDtlSeq = basketOptList[j].addOptDtlSeq;
                       var optBuyQtt = basketOptList[j].optBuyQtt;

                       if(addOptArr != '') {
                           addOptArr += '*';
                       }
                       addOptArr += addOptNo+"^"+addOptDtlSeq+"^"+optBuyQtt;

                   }
                }
                totalItemArr+=addOptArr + '▦';
                totalItemArr+= ctgNo;
                var itemNoObj="";
                itemNoObj += '<input type="hidden" name="itemArr" id="itemArr'+basketNo+'" class="" style="width:500px;" value="'+totalItemArr+'">';
                itemNoObj += '<input type="hidden" name="goodsNo" id="goodsNo'+basketNo+'" class="" style="width:500px;" value="'+obj[i].goodsNo+'">';
                itemNoObj += '<input type="hidden" name="itemNoArr" id="itemNoArr'+basketNo+'" class="" style="width:500px;" value="'+obj[i].itemNo+'">';
                itemNoObj += '<input type="hidden" name="itemVerChk" id="itemVerChk'+basketNo+'" class="" style="width:500px;" value="'+obj[i].itemVerChk+'">';
                itemNoObj += '<input type="hidden" name="attrVerChk" id="attrVerChk'+basketNo+'" class="" style="width:500px;" value="'+obj[i].attrVerChk+'">';

                var itemNoArrDiv = jQuery("#itemNoArrDiv");
                itemNoArrDiv.append(itemNoObj);
            }
        }
    }

    BasketUtil = {
      commaNumber:function(p) {
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        }
        ,allCheckBox:function(type) {
            if(type === 'input') {
                if($("#allCheck").prop("checked")) {
                    //해당화면에 전체 checkbox들을 체크해준다a
                    $("input[name=delBasketNoArr]").prop("checked",true);
                // 전체선택 체크박스가 해제된 경우
                } else {
                    //해당화면에 모든 checkbox들의 체크를해제시킨다.
                    $("input[name=delBasketNoArr]").prop("checked",false);
                }
                BasketUtil.paymentTotInfo();
            } else if(type === 'checkBtn') {
                $("input[name=delBasketNoArr]").prop("checked",true);
            } else if(type === 'uncheckBtn') {
                $("input[name=delBasketNoArr]").prop("checked",false);
            }
        }
        //관심상품담기
        , insertInterest:function(goodsNo){
            var loginYn = "${memberNoYn}";
            if(loginYn === 'Y') {
                var url = '${_MOBILE_PATH}/front/interest/interest-item-insert';
                var param = {goodsNo : goodsNo}
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                        Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                            location.href="${_MOBILE_PATH}/front/interest/interest-item-list";
                        })
                     }
                })
            } else { //부정한 방법으로 장바구니에 들어갈수도 있기때문에  둔다.
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                        function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "${_MOBILE_PATH}/front/login/member-login?returnUrl="+returnUrl;
                        },''
                    );
            }
        }
        , paymentTotInfo:function(){
                var calcSaleAmt = 0,
                    discountAmt = 0,
                    orderAmt = 0,
                    dlvrAmt = 0;
                $('.order_check').each(function () {
                    if ($(this).attr("id") != 'allCheck' && $(this).is(":checked")) {
                        calcSaleAmt += $(this).parent().parent().parent().find('#calcSaleAmt').val() * 1;
                        discountAmt += $(this).parent().parent().parent().find('#discountAmt').val() * 1;
                        dlvrAmt += $(this).parent().parent().parent().find('#dlvrAmt').val() * 1;
                        //orderAmt += $(this).parent().parent().find('#orderAmt').val()*1;
                    }
                });
                $('#totCalcSaleAmt').text(BasketUtil.commaNumber(calcSaleAmt));
                $('#totDiscountAmt').text("- " + BasketUtil.commaNumber(discountAmt));
                $('#totDlvrAmt').text("+ " + BasketUtil.commaNumber(dlvrAmt));
                $('#totOrderAmt').text(BasketUtil.commaNumber(calcSaleAmt - discountAmt + dlvrAmt));
        }
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 03.LAYOUT: MIDDLE AREA --->
    <div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			장바구니
		</div>
        
		<!-- 일반상품 탭 -->
		<div class="tabs_basket_content" id="basket01" style="display: block;">
        <form name="basket_form" id="basket_form">
        <!--- 주문 목록 --->
        <div class="cart_detail_area">

            <ul class="order_list">
            <c:choose>
            <c:when test="${basket_list ne null}">
				<input type="hidden" name="rsvOnlyYn" value="Y">
                <c:set var="basketTotalAmt" value="0"/>
                <c:set var="dlvrTotalAmt" value="0"/>
                <%-- logCorpAScript --%>
				<c:set var="logGoods" value=""/>
				<%-- // logCorpAScript --%>
                <c:forEach var="basketList" items="${basket_list}" varStatus="status">
                <c:set var="totalAddOptionAmt" value="0"/>
                <c:set var="calcSaleAmt" value="0"/>
                <c:set var="salePrice" value="${basketList.salePrice}"/>
                <%-- 할인금액 계산(기획전 -> 등급할인 순서) --%>
                <c:set var="dcPrice" value="0"/> <%-- 할인금액SUM(기획전+등급할인) --%>
                <c:set var="prmtDcPrice" value="0"/> <%-- 기획전 할인 --%>
                <c:set var="eachPrmtDcPrice" value="0"/> <%-- 기획전 할인(수량 곱하지 않은 값) --%>
                <c:set var="memberGradeDcPrice" value="0"/> <%-- 등급 할인 --%>
                <c:set var="eachMemberGradeDcPrice" value="0"/><%-- 등급 할인(수량 곱하지 않은 값) --%>
                <c:set var="spcPriceYn" value="N"/> <%-- 특가 상품 여부 --%>

				<!--
				첫구매프로모션 참여여부 : ${member_info.data.firstSpcOrdYn}
				첫구매프로모션 상품구입 여부 : ${basketList.firstSpcOrdYn}
				프로모션 유형 코드 : ${basketList.prmtTypeCd}
				신규회원여부 : ${member_info.data.newMemberYn}
				기존회원 여부 : ${member_info.data.oldMemberYn}
				-->

                <c:forEach var="basketAddOptList" items="${basketList.basketOptList}" varStatus="status2">
					<c:choose>
						<c:when test="${basketAddOptList.addOptAmtChgCd eq '1'}">
							<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
							<c:set var="calcSaleAmt" value="${calcSaleAmt+(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
						</c:when>
						<c:otherwise>
							<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt-(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
							<c:set var="calcSaleAmt" value="${calcSaleAmt-(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
						</c:otherwise>
					 </c:choose>
				</c:forEach>


				<c:choose>
                    <c:when test="${basketList.firstSpcOrdYn eq 'N' and basketList.prmtTypeCd eq '06' and member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
                            <c:set var="prmtDcPrice" value="${salePrice*basketList.buyQtt-basketList.firstBuySpcPrice*basketList.buyQtt}"/>
                            <c:set var="salePrice" value="${basketList.firstBuySpcPrice}"/>
                            <c:set var="spcPriceYn" value="Y"/>
                    </c:when>
                    <c:otherwise>
                    <%-- 할인금액 계산(기획전)--%>
                    <c:choose>
                        <c:when test="${basketList.dcRate == 0}">
                            <c:set var="prmtDcPrice" value="0"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="prmtDcPrice" value="${salePrice*(basketList.dcRate/100)/10}"/>
                            <c:set var="eachPrmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)}"/>
                            <c:set var="prmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)*basketList.buyQtt}"/>
                        </c:otherwise>
                    </c:choose>
                    <%-- 할인금액 계산(등급할인)--%>
                    <%-- <c:if test="${member_info ne null}">
                    <c:choose>
                        <c:when test="${member_info.data.dcValue == 0}">
                            <c:set var="memberGradeDcPrice" value="0"/>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${member_info.data.dcUnitCd eq '1'}">
                                    <c:set var="dcUnitCd" value="01"/>
                                    <c:set var="memberGradeDcPrice" value="${(salePrice-prmtDcPrice)*(member_info.data.dcValue/100)/10}"/>
                                    <c:set var="eachMemberGradeDcPrice" value="${((memberGradeDcPrice-(memberGradeDcPrice%1))*10)}"/>
                                    <c:set var="memberGradeDcPrice" value="${((memberGradeDcPrice-(memberGradeDcPrice%1))*10)*basketList.buyQtt}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="dcUnitCd" value="02"/>
                                    <c:set var="eachMemberGradeDcPrice" value="${member_info.data.dcValue}"/>
                                    <c:set var="memberGradeDcPrice" value="${member_info.data.dcValue*basketList.buyQtt}"/>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                    </c:if> --%>
                     </c:otherwise>
               </c:choose>
				<c:set var="dcPrice" value="${prmtDcPrice+memberGradeDcPrice}"/>
				<c:set var="goodstotalAmt" value="${(basketList.salePrice*basketList.buyQtt)+totalAddOptionAmt}"/>
                <li data-goods-no="${basketList.goodsNo}" data-item-no="${basketList.itemNo}" data-item-nm="${basketList.goodsNm}" data-buy-qtt="${basketList.buyQtt}" data-multi-opt-yn="${basketList.multiOptYn}"
                            data-item-price= "${salePrice}" data-session-index="${basketList.basketNo}" data-basket-no="${basketList.basketNo}" data-stock-qtt="${basketList.stockQtt}"
                            data-min-limit-yn="${basketList.minOrdLimitYn}" data-min-ord-qtt="${basketList.minOrdQtt}" data-max-limit-yn="${basketList.maxOrdLimitYn}" data-max-ord-qtt="${basketList.maxOrdQtt}"
                            data-stock-set-yn="${basketList.stockSetYn}" data-avail-stock-sale-yn="${basketList.availStockSaleYn}" data-avail-stock-qtt="${basketList.availStockQtt}"
                            data-goods-sale-status-cd="${basketList.goodsSaleStatusCd}" data-rsv-only-yn="${basketList.rsvOnlyYn}" data-dlvrc-payment-cd="${basketList.dlvrcPaymentCd}"
                            data-ord-price="${goodstotalAmt-dcPrice}" data-spc-yn="${spcPriceYn}"
                            >
                            
                    <div class="checkbox">
                        <label>
                            <input type="checkbox" name="delBasketNoArr" id="delBasketNoArr_${basketList.basketNo}" value="${basketList.basketNo}" class="order_check" checked="checked">
                            <span></span>
                        </label>
                    </div>
                    <div class="order_product_info">
                        <ul class="order_info_top">
                            <li class="order_product_pic">
								<div class="product_pic"><img src="${_IMAGE_DOMAIN}${basketList.goodsDispImgC}"></div>
							<!-- 2018-09-04위치옮김 -->
								<c:choose>
									<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
										<%--<p class="label_area"><span class="label_reservation">예약전용</span></p>--%>
									</c:when>
									<c:otherwise>
										  <c:if test="${basketList.dlvrcPaymentCd eq '04'}">
											<%--<p class="label_area"><span class="label_shop">매장픽업</span></p>--%>
										  </c:if>
									</c:otherwise>
								</c:choose>
							<!--// 2018-09-04위치옮김 -->
							</li>
                            <li class="order_product_title">
                            	<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${basketList.goodsNo}">[${basketList.goodsNo}]<br>${basketList.goodsNm}</a>
							
								<!-- 2018-09-03수정 -->
								<div class="order_info_text">
									<span class="option_title">
									<c:set var="attrNm" value=""/>
									<c:if test="${basketList.optNo1Nm ne 'N'}">
										${basketList.optNo1Nm}:${basketList.attrNo1Nm} /
										<c:set var="attrNm" value="${basketList.attrNo1Nm}"/>
									</c:if>
									<c:if test="${basketList.optNo2Nm ne 'N'}">
										${basketList.optNo2Nm}:${basketList.attrNo2Nm} /
										<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}"/>
									</c:if>
									<c:if test="${basketList.optNo3Nm ne 'N'}">
										${basketList.optNo3Nm}:${basketList.attrNo3Nm} /
										<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}, ${basketList.attrNo3Nm}"/>
									</c:if>
									<c:if test="${basketList.optNo4Nm ne 'N'}">
										${basketList.optNo4Nm}:${basketList.attrNo4Nm} /
										<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}, ${basketList.attrNo3Nm}, ${basketList.attrNo4Nm}"/>
									</c:if>
										 ${basketList.buyQtt} 개
									</span>
									
									<span class="option_price">
										<em>

										<fmt:formatNumber value="${basketList.salePrice*basketList.buyQtt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
										</em>원
									</span>
								
									<c:forEach var="basketAddOptList" items="${basketList.basketOptList}" varStatus="status2">
										<!-- <li> -->
											<span class="option_title"> ${basketAddOptList.addOptValue} / ${basketAddOptList.optBuyQtt} 개</span>
											<span class="option_price"><em>
											<c:choose>
											   <c:when test="${basketAddOptList.addOptAmtChgCd eq '1'}">
											   +
											   </c:when>
											   <c:otherwise>
											   -
											   </c:otherwise>
											</c:choose>
											   <fmt:formatNumber value="${basketAddOptList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em> 원
											</span>
										<!-- </li> -->
										
										<%--<c:choose>
											<c:when test="${basketAddOptList.addOptAmtChgCd eq '1'}">
												<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
											</c:when>
											<c:otherwise>
												<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt-(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
											</c:otherwise>
										 </c:choose>   --%>
									</c:forEach>
									<input type="hidden" class="text-attr-nm" value="${attrNm}"/>
								<!-- </ul> -->

								<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
									<c:if test="${fn:length(basketList.freebieGoodsList) >0}">
										<p class="option_title">사은품 :
											<c:forEach var="freebieGoodsList" items="${basketList.freebieGoodsList}" varStatus="status3">
												<c:out value="${freebieGoodsList.freebieNm}"/>
												<c:if test="${status3.index < (fn:length(basketList.freebieGoodsList)-1)}">
													,
												</c:if>
											</c:forEach>
										</p>
									</c:if>
								<!-- //사은품추가 2018-09-27 -->
								
								</div><!-- //order_info_text -->
								<!-- //2018-09-03수정 -->
							</li>
                        </ul>
                    </div>
                    <ul class="order_price">
                        <li>
                            <span class="tit">할인금액</span>
                            <span class="fRed">
                                <c:if test="${basketList.firstSpcOrdYn eq 'N' and basketList.prmtTypeCd eq '06' and member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
									 <br>특가 할인
								</c:if>
                                <fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                                <input type="hidden" id="discountAmt" value="${prmtDcPrice+memberGradeDcPrice}">
                            </span>
                        </li>
                        <li>
                            <span class="tit">주문금액</span>
							<c:choose>
								<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
									<em>매장결제

									</em>
								</c:when>
								<c:otherwise>
		                            <em>
		                                <fmt:formatNumber value="${goodstotalAmt-dcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
		                                <c:set var="calcSaleAmt" value="${calcSaleAmt+(basketList.salePrice*basketList.buyQtt)}"/>
		                            </em>원
								</c:otherwise>
							</c:choose>
                            <input type="hidden" id="calcSaleAmt" value="${calcSaleAmt}">
                            
                        </li>
                        <li>
                            <span class="tit">배송비</span>
                            <span>
                            <%-- **** 배송비 계산 **** --%>
                            <c:choose>
                                <c:when test="${basketList.dlvrSetCd eq '1' && basketList.dlvrcPaymentCd eq '01'}">
                                    <c:set var="grpId" value="${basketList.sellerNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${basketList.dlvrSetCd eq '1'  && (basketList.dlvrcPaymentCd eq '02')}"><%-- or basketList.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${basketList.sellerNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${basketList.dlvrSetCd eq '4'  && (basketList.dlvrcPaymentCd eq '02')}"><%-- or basketList.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${basketList.goodsNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:when test="${basketList.dlvrSetCd eq '6' && (basketList.dlvrcPaymentCd eq '02')}"><%-- or basketList.dlvrcPaymentCd eq '04'--%>
                                    <c:set var="grpId" value="${basketList.goodsNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="dlvrcPaymentCd" value="${basketList.dlvrcPaymentCd}"/>
                                    <c:if test="${basketList.dlvrcPaymentCd eq null}">
                                        <c:set var="dlvrcPaymentCd" value="null"/>
                                    </c:if>
                                    <c:set var="grpId" value="${basketList.itemNo}**${basketList.dlvrSetCd}**${dlvrcPaymentCd}"/>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${preGrpId ne grpId }">
                                <c:choose>
                                    <c:when test="${dlvrPriceMap.get(grpId) eq '0'  || empty dlvrPriceMap.get(grpId)}">
                                        <c:choose>
											<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
												<p class="option_s"><span class="label_reservation">예약전용</span> /${basketList.sellerNm}</p>
		                            		</c:when>
		                            		<c:otherwise>
				                                <c:choose>
				                                    <c:when test="${basketList.dlvrcPaymentCd eq '03'}">
														    무료 / 착불 / ${basketList.sellerNm}
				                                    </c:when>
				                                    <c:when test="${basketList.dlvrcPaymentCd eq '04'}">
														 	무료 / <span class="label_shop">매장픽업</span> / ${basketList.sellerNm}
				                                    </c:when>
				                                    <c:otherwise>
														 	무료 / ${basketList.sellerNm}
				                                    </c:otherwise>
				                                </c:choose>
		                            		</c:otherwise>
		                            	</c:choose>
		                            	<input type="hidden" id="dlvrAmt" value="0">
		                            </c:when>	
		                            <c:otherwise>
		                            	<c:choose>
											<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
												<p class="option_s"><span class="label_reservation">예약전용</span> / ${basketList.sellerNm}</p>
												<input type="hidden" id="dlvrAmt" value="0">
		                            		</c:when>
		                            		<c:otherwise>
				                                <c:choose>
				                                    <c:when test="${basketList.dlvrcPaymentCd eq '03'}">
													    (<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
													    	/ 착불 / ${basketList.sellerNm}
				                                    </c:when>
				                                    <c:when test="${basketList.dlvrcPaymentCd eq '04'}">
															 <fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
															 	/ <span class="label_shop">매장픽업</span> / ${basketList.sellerNm}
				                                    </c:when>
				                                    <c:otherwise>
						                            	<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
						                            		/ ${basketList.sellerNm}
				                                    </c:otherwise>
				                                </c:choose>
				                                <input type="hidden" id="dlvrAmt" value="${dlvrPriceMap.get(grpId)}">
		                            		</c:otherwise>
		                            	</c:choose>
		                            </c:otherwise>		                            	
                                </c:choose>
                                <c:if test="${basketList.dlvrcPaymentCd ne '03' and basketList.rsvOnlyYn ne 'Y'}" >
                                	<c:set var="dlvrTotalAmt" value="${dlvrTotalAmt+ dlvrPriceMap.get(grpId)}"/>
                                </c:if>
                             </c:if>
                             <c:if test="${preGrpId eq grpId }">
							    <c:choose>
									<c:when test="${dlvrPriceMap.get(grpId) eq '0' || empty dlvrPriceMap.get(grpId)}">
									    <input type="hidden" id="dlvrAmt" value="0">
                                    </c:when>
									<c:otherwise>
									    <c:choose>
											<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
											    <input type="hidden" id="dlvrAmt" value="0">
											</c:when>
											<c:otherwise>
											    <input type="hidden" id="dlvrAmt" value="${dlvrPriceMap.get(grpId)}">
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
                            </c:if>
                            <c:set var="preGrpId" value="${grpId}"/>
                            </span>
                        </li>
                    </ul>
					<div class="basket_btn_area">
						<button type="button" name="btn_basket_del2" class="btn_basket_del2">삭제</button>
						<c:choose>
							<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
								<button type="button" name="btn_basket_book" class="btn_basket_book">예약하기</button>
							</c:when>
							<c:otherwise>
								<button type="button" name="btn_basket_order" class="btn_basket_order">주문하기</button>
							</c:otherwise>
						</c:choose>
					</div>
                </li>
				   <c:if test="${basketList.rsvOnlyYn ne 'Y'}" >
                    <c:set var="basketTotalAmt" value="${basketTotalAmt+goodstotalAmt}"/>
                    <c:set var="promotionTotalDcAmt" value="${promotionTotalDcAmt+prmtDcPrice}"/>
                    <c:set var="memberGradeTotalDcAmt" value="${memberGradeTotalDcAmt+memberGradeDcPrice}"/>
                   </c:if>
                   <%-- logCorpAScript --%>
					<c:set var="logGoodsVal" value="${basketList.goodsNm}_${basketList.buyQtt}"/>
					<c:choose>
					<c:when test="${status.index>0}">
						<c:set var="logGoods" value="${logGoods};${logGoodsVal}"/>
					</c:when>
					<c:otherwise>
						<c:set var="logGoods" value="${logGoodsVal}"/>
					</c:otherwise>
					</c:choose>
					<%--// logCorpAScript --%>
					<script>
					fbq('track', 'AddToCart', {
						content_ids: ['${basketList.goodsNo}'],
						content_type: 'product',
						value: '${salePrice}',
						currency: 'KRW'
						});
					</script>
                </c:forEach>
                    <c:set var="couponTotalAmt" value="0"/>
                    <c:set var="mileageTotalAmt" value="0"/>
                    <c:set var="paymentTotalAmt" value="${basketTotalAmt+dlvrTotalAmt-promotionTotalDcAmt-memberGradeTotalDcAmt-couponTotalAmt-mileageTotalAmt}"/>
                    <%-- logCorpAScript --%>
					<%--장바구니(상품명_수량)  여러개 경우 ';'로 구분 (상품명1_수량;상품명2_수량)--%>
					<c:set var="http_PA" value="${logGoods}" scope="request"/>
					<%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
					<c:set var="http_SO" value="cart" scope="request"/>
					<%-- //logCorpAScript --%>
                </c:when>
                <c:otherwise>
                <li>
                    <div class="no_order_history" style="border-top:none;">
                        장바구니에 등록된 상품이 없습니다.
                    </div>
                </li>
                    <!-- <li>장바구니에 등록된 상품이 없습니다.</li> -->
                </c:otherwise>
                </c:choose>
            </ul>
            <c:if test="${basket_list ne null}">
            <div class="order_price_area">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="freeboard_checkbox" id="allCheck" class="order_check" checked="checked">
                        <span></span>
                    </label>
                    <label for="allCheck">전체선택</label>
                </div>
				<button type="button" class="btn_basket_del" id="selectDelete" name ="selectDelete">선택삭제</button>
            </div>
			<div class="cart_btn_area2">
                <button type="button" class="btn_basket_check"  id="chkPickup" >매장픽업상품만 선택</button>
                <button type="button" class="btn_basket_check"  id="chkDeliv" >택배상품만 선택</button>
            </div>
            <ul class="order_price_detail_list">
                <li class="form">
                    <span class="title">상품 금액 합</span>
                    <p class="detail total" id="totCalcSaleAmt">
                        <fmt:formatNumber value="${basketTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
                    </p>
                </li>
                <li class="form">
                    <span class="title">할인금액 합</span>
                    <p class="detail" id="totDiscountAmt">
                        -&nbsp<fmt:formatNumber value="${promotionTotalDcAmt+memberGradeTotalDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
                    </p>
                </li>
                <li class="form" style="padding-bottom:10px;">
                    <span class="title">배송비 합</span>
                    <p class="detail" id="totDlvrAmt">
                        +&nbsp<fmt:formatNumber value="${dlvrTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
                    </p>
                </li>
                <li class="form">
                    <span class="title">총 결제예정금액</span>
                    <p class="detail total">
                        <em id="totOrderAmt"><fmt:formatNumber value="${paymentTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
                    </p>
                </li>
            </ul>
            <div id="itemNoArrDiv"></div>
            <div class="cart_btn_area">
                <!-- <button type="button" class="btn_select_delete" id="selectDelete" name ="selectDelete">선택삭제</button> -->
                <button type="button" class="btn_checkout"  id= "regSelectOrdInfo" >주문하기</button>
            </div>
            </c:if>
        </div>
        </form>
    </div>
    </div>
    <!---// 03.LAYOUT: MIDDLE AREA --->

    </t:putAttribute>
</t:insertDefinition>