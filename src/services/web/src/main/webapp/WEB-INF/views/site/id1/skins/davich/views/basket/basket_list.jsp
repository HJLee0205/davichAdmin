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
	<t:putAttribute name="title">다비치마켓 :: 장바구니</t:putAttribute>
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

            var goodsNo = jQuery(this).parents('tr').data('goods-no');
            var itemNo = jQuery(this).parents('tr').data('item-no');
            var itemNm = jQuery(this).parents('tr').data('item-nm');
            var itemPrice = jQuery(this).parents('tr').data('item-price');
            var sessionIndex = jQuery(this).parents('tr').data('session-index');

            var param = param = 'goodsNo='+goodsNo+'&itemNo='+itemNo+'&sessionIndex='+sessionIndex;
            var url = '/front/basket/goods-detail?'+param;

            Dmall.AjaxUtil.load(url, function(result) {
                $('#goodsDetail').html(result);
            })
            Dmall.LayerPopupUtil.open($("#success_basket"));
        });

        jQuery('[name=btnBasketUpdateCnt]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var basketNo = $(this).parents('tr').data('basket-no');
            var goodsNo = $(this).parents('tr').data('goods-no');
            var itemNo = $(this).parents('tr').data('item-no');
            var sessionIndex = $(this).parents('tr').data('session-index');
            var buyQtt = $("#buyQtt_"+sessionIndex).val();
            var stockQtt = $(this).parents('tr').data('stock-qtt');
            var itemNm = $(this).data('attr-nm') + ' (재고:' + stockQtt + ')'; //단품명
            var minOrdLimitYn = $(this).parents('tr').data('min-limit-yn'); //최소 주문수량 제한 여부
            var minOrdQtt = $(this).parents('tr').data('min-ord-qtt'); //최소 주문 수량
            var maxOrdLimitYn = $(this).parents('tr').data('max-limit-yn'); //최대 주문수량 제한 여부
            var maxOrdQtt = $(this).parents('tr').data('max-ord-qtt'); //최대 주문 수량

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

            var url = '/front/basket/basket-count-update';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('/front/basket/basket-list', {});
                 }
            })
        });

        jQuery('[name=btnBasketDelete]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var basketNo = jQuery(this).parents('tr').data('basket-no');
            var goodsNo = jQuery(this).parents('tr').data('goods-no');
            var itemNo = jQuery(this).parents('tr').data('item-no');
            var sessionIndex = jQuery(this).parents('tr').data('session-index');
            var buyQtt = jQuery("#buyQtt_"+sessionIndex).val();

            var url = '/front/basket/basket-delete';
            var param = {basketNo:basketNo, goodsNo : goodsNo, itemNo:itemNo, sessionIndex:sessionIndex, buyQtt:buyQtt}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('/front/basket/basket-list', {});
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

            var url = '/front/basket/check-basket-delete';
            var param = $('#basket_form').serialize();

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('/front/basket/basket-list', {});
                 }
            })
        });
        
        
        // 매장픽업
        jQuery('[name=selectPickup]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            $('input:checkbox[name=delBasketNoArr]').each(function() {
                var dlvrcPaymentCd = $(this).parents('tr').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('tr').data('rsv-only-yn');
                
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
        jQuery('[name=selectDeliv]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            $('input:checkbox[name=delBasketNoArr]').each(function() {
                var dlvrcPaymentCd = $(this).parents('tr').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('tr').data('rsv-only-yn');
                
                // 매장픽업/택배
                if (dlvrcPaymentCd == "04" || rsvOnlyYn == "Y") {
                	$(this).prop("checked", false); 
                } else {
                	$(this).prop("checked", true); 
                }
            });
            BasketUtil.paymentTotInfo();
        });          
        

        jQuery('[name=allDelete]').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            var url = '/front/basket/basket-all-delete';
            var param = {}

            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.FormUtil.submit('/front/basket/basket-list', {});
                 }
            })
        });
        /* 전체선택 */
        $("#allCheck").click(function(){
            BasketUtil.allCheckBox('input');
        })

        /* 전체선택버튼 */
        $("#allCheckBtn").click(function(){
            BasketUtil.allCheckBox('checkBtn');
        })

        /* 전체선택해제 */
        $("#allUnCheckBtn").click(function(){
            BasketUtil.allCheckBox('uncheckBtn');
        })

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
                 totalOrdPrice += jQuery(this).parents('tr').data('ord-price'); // 개별 주문 가격
                 if(jQuery(this).parents('tr').data('spc-yn')=='Y'){
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
                var status = $('input:checkbox[name=delBasketNoArr]:checked').parents('tr').data('goods-sale-status-cd');
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
                    var status = $(this).parents('tr').data('goods-sale-status-cd');
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
                var sessionIndex = $(this).parents('tr').data('session-index');
                var buyQtt = $(this).parents('tr').data('buy-qtt');
                var goodsNm = $(this).parents('tr').data('item-nm');
                var stockQtt = $(this).parents('tr').data('stock-qtt');
                var attrNm = $(this).parents('tr').find('.text-attr-nm').val();
                if(attrNm !== '') {
                    goodsNm += '[' + attrNm + '](재고:' + stockQtt + ')';
                }
                var multiOptYn = $(this).parents('tr').data('multi-opt-yn');
                var stockSetYn = $(this).parents('tr').data('stock-set-yn');
                var availStockSaleYn = $(this).parents('tr').data('avail-stock-sale-yn');
                var availStockQtt = $(this).parents('tr').data('avail-stock-qtt');
                var stockQttOk = false;
                var validationStockQtt = $(this).parents('tr').data('stock-qtt');

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
                var sessionIndex = $(this).parents('tr').data('session-index');
                var buyQtt = $(this).parents('tr').data('buy-qtt');
                var minOrdLimitYn = $(this).parents('tr').data('min-limit-yn'); //최소 주문수량 제한 여부
                var minOrdQtt = $(this).parents('tr').data('min-ord-qtt'); //최소 주문 수량
                var maxOrdLimitYn = $(this).parents('tr').data('max-limit-yn'); //최대 주문수량 제한 여부
                var maxOrdQtt = $(this).parents('tr').data('max-ord-qtt'); //최대 주문 수량
                var goodsNm = $(this).parents('tr').data('item-nm');
                var stockQtt = $(this).parents('tr').data('stock-qtt');
                var attrNm = $(this).parents('tr').find('.text-attr-nm').val();
                
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
                        var goods = jQuery("#goodsNm"+basketNo).val();
                        var itemNm = jQuery("#itemNm"+basketNo).val();
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
                var dlvrcPaymentCd = $(this).parents('tr').data('dlvrc-payment-cd');
                var rsvOnlyYn = $(this).parents('tr').data('rsv-only-yn');
                
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
			
			
            var memberNo =  '${user.session.memberNo}';
            var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';
         	var dlvrMethod = false;
			// 매장픽업
            $('input:checkbox[name=delBasketNoArr]:checked').each(function() {
                var dlvrcPaymentCd = $(this).parents('tr').data('dlvrc-payment-cd');
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
	            $('#basket_form').attr('action','${_DMALL_HTTPS_SERVER_URL}/front/order/order-form');
	            $('#basket_form').attr('method','post');
	            $('#basket_form').submit();
			} else {
	            var loginYn = "${memberNoYn}";
	            if(loginYn === 'Y') {
	                Dmall.LayerUtil.confirm('예약전용 상품만을 선택한경우 방문예약 화면으로 이동합니다.', function() {
	    	            $('#basket_form').attr('action','/front/visit/visit-book');
	    	            $('#basket_form').attr('method','post');
	    	            $('#basket_form').submit();
	                });
	            } else {
	                Dmall.LayerUtil.confirm("예약전용 상품인 경우는 로그인이 필요합니다. 지금 로그인 하시겠습니까?",
	                        function() {
	                        var returnUrl = window.location.pathname+window.location.search;
	                        location.href= "/front/login/member-login?returnUrl="+returnUrl;
	                        },''
                    );
	            }
			}
        })
        
        jQuery('[name=regOrdBtnInfo], [name=regRsvBtnInfo]').on('click', function(e){
            e.preventDefault();
            e.stopPropagation();

            var index = jQuery(this).parents('tr').data('session-index');
            var btnItemNo = jQuery("#itemArr"+index).val();
            var goods = jQuery("#goodsNm"+index).val();
            var itemNm = jQuery("#itemNm"+index).val();
            var stockQtt = $(this).parents('tr').data('stock-qtt');
            var validationStockQtt = $(this).parents('tr').data('stock-qtt');
            var itemNm = $(this).data('attr-nm') + ' (재고:' + stockQtt + ')'; //단품명
            //var buyQtt = $("#buyQtt_"+index).val(); //이값은 현재 input tag에 있는 값
            var buyQtt = $(this).parents('tr').data('buy-qtt'); //이값은 DB, session(비회원)에 저장된 값
            var minOrdLimitYn = $(this).parents('tr').data('min-limit-yn'); //최소 주문수량 제한 여부
            var minOrdQtt = $(this).parents('tr').data('min-ord-qtt'); //최소 주문 수량
            var maxOrdLimitYn = $(this).parents('tr').data('max-limit-yn'); //최대 주문수량 제한 여부
            var maxOrdQtt = $(this).parents('tr').data('max-ord-qtt'); //최대 주문 수량
            var multiOptYn = $(this).parents('tr').data('multi-opt-yn');
            var stockSetYn = $(this).parents('tr').data('stock-set-yn');
            var availStockSaleYn = $(this).parents('tr').data('avail-stock-sale-yn');
            var availStockQtt = $(this).parents('tr').data('avail-stock-qtt');
            var stockQttOk = false;
            var dlvrcPaymentCd = $(this).parents('tr').data('dlvrc-payment-cd');
            var memberNo =  '${user.session.memberNo}';
            var integrationMemberGbCd = '${user.session.integrationMemberGbCd}';

            var ordPrice = jQuery(this).parents('tr').data('ord-price'); // 개별 주문 가격
            var spcYn = jQuery(this).parents('tr').data('spc-yn'); // 특가 적용여부 가격

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
   	         	if (integrationMemberGbCd == '02' && dlvrcPaymentCd == '04') {
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
            
            if (e.target.name == "regRsvBtnInfo") {
	            if(loginYn == 'true') {
    	            $('#basket_form').attr('action','/front/visit/visit-book');
    	            $('#basket_form').attr('method','post');
    	            $('#basket_form').submit();
	            } else {
	                Dmall.LayerUtil.confirm("예약전용 상품인 경우는 로그인이 필요합니다. 지금 로그인 하시겠습니까?",
	                        function() {
	                        var returnUrl = window.location.pathname+window.location.search;
	                        location.href= "/front/login/member-login?returnUrl="+returnUrl;
	                        },''
                    );
	            }
            } else {
	             $('#basket_form').attr('action','${_DMALL_HTTPS_SERVER_URL}/front/order/order-form');
	             $('#basket_form').attr('method','post');
	             $('#basket_form').submit();
            }
            
        })


        if("${memberNoYn}"=="N"){
            jQuery(".nonmember_cart_info").show();
        }
        totalItemArr();

        $('.insert-interest').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            BasketUtil.insertInterest($(this).parents('tr').attr('data-goods-no'));
        });
        
        
        /* 계속쇼팡하기 */
        $("#keepSopping").click(function(){
            location.href="/front/main-view";
        })
        
        
    });
    /* 재고 확인 */
    function jsCheckOptionStockQtt(obj) {
        var rtn = true;
        var stockSetYn = $(obj).parents('tr').data('stock-set-yn');
        var availStockSaleYn = $(obj).parents('tr').data('avail-stock-sale-yn');
        var availStockQtt = $(obj).parents('tr').data('avail-stock-qtt');
        var stockQtt = $(obj).parents('tr').data('stock-qtt');
        var buyQtt = $(obj).parents('tr').data('buy-qtt'); //이값은 DB, session(비회원)에 저장된 값


        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
            stockQtt += Number(availStockQtt);
        }
        if(Number(stockQtt) >= Number(buyQtt)) {
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
                itemNoObj += '<input type="hidden" id="goodsNm'+basketNo+'" class="" style="width:500px;" value="'+obj[i].goodsNm+'">';
                itemNoObj += '<input type="hidden" name="itemNoArr" id="itemNoArr'+basketNo+'" class="" style="width:500px;" value="'+obj[i].itemNo+'">';
                itemNoObj += '<input type="hidden" name="itemVerChk" id="itemVerChk'+basketNo+'" class="" style="width:500px;" value="'+obj[i].itemVerChk+'">';
                itemNoObj += '<input type="hidden" name="attrVerChk" id="attrVerChk'+basketNo+'" class="" style="width:500px;" value="'+obj[i].attrVerChk+'">';
                
                var attrNm = "";
                if (obj[i].optNo1Nm != 'N') {
                	attrNm = obj[i].attrNo1Nm;
                }
                if (obj[i].optNo2Nm != 'N') {
                	attrNm += ',' + obj[i].attrNo2Nm;
                }
                if (obj[i].optNo3Nm != 'N') {
                	attrNm += ',' + obj[i].attrNo3Nm;
                }
                if (obj[i].optNo4Nm != 'N') {
                	attrNm += ',' + obj[i].attrNo4Nm;
                }
                itemNoObj += '<input type="hidden" id="itemNm'+basketNo+'" class="" style="width:500px;" value="'+attrNm+'">';

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
        ,
        allCheckBox:function(type) {
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
                var url = '/front/interest/interest-item-insert';
                var param = {goodsNo : goodsNo}
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                        Dmall.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                            location.href="/front/interest/interest-item-list";
                        })
                     }
                })
            } else { //부정한 방법으로 장바구니에 들어갈수도 있기때문에  둔다.
                Dmall.LayerUtil.confirm("로그인이 필요한 서비스입니다.<br>지금 로그인 하시겠습니까?",
                        function() {
                        var returnUrl = window.location.pathname+window.location.search;
                        location.href= "/front/login/member-login?returnUrl="+returnUrl;
                        },''
                    );
            }
        }
        , paymentTotInfo:function(){
        	var calcSaleAmt = 0,
	    		discountAmt = 0,
	    		orderAmt = 0,
	    		dlvrAmt = 0;
			$('.order_check').each(function(){
				if($(this).attr("id") != 'allCheck' && $(this).is(":checked")){
					calcSaleAmt += $(this).parent().parent().find('#calcSaleAmt').val()*1;
					discountAmt += $(this).parent().parent().find('#discountAmt').val()*1;
					dlvrAmt += $(this).parent().parent().find('#dlvrAmt').val()*1;
					//orderAmt += $(this).parent().parent().find('#orderAmt').val()*1;
				}
			});
			$('#em_calcSaleAmt').text(BasketUtil.commaNumber(calcSaleAmt));
			$('#em_discountAmt').text(BasketUtil.commaNumber(discountAmt));
			$('#em_dlvrAmt').text(BasketUtil.commaNumber(dlvrAmt));
			$('#em_orderAmt').text(BasketUtil.commaNumber(calcSaleAmt-discountAmt+dlvrAmt));
        }
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">


    <!---// category header --->
    <form name="basket_form" id="basket_form">

    <!--- category header 카테고리 location과 동일 --->
    <!--- 02.LAYOUT: 주문 메인 --->
    <div class="order_middle">		
		<div class="order_head">
			<h2 class="order_tit">장바구니</h2>
			<ul class="order_steps">
				<li class="active"><span class="step01"><i></i>장바구니</span></li>
				<li><span class="step02"><i></i>주문결제</span></li>
				<li><span class="step03"><i></i>주문완료</span></li>
			</ul>
		</div>
		<div class="order_list_top">
			<h3 class="order_stit">상품 목록</h3>
			<div class="order_info">
				<span class="label_reservation">예약전용</span>
				<span class="order_info_text">상품은 예약 후 지정하신 매장에 방문하시면 바로 구매하실 수 있습니다.</span>
			</div>
		</div>
		<table class="tCart_Board">
			<caption>
				<h1 class="blind">장바구니 목록입니다.</h1>
			</caption>
			<colgroup>
				<col style="width:39px">
				<col style="width:108px">
				<col style="width:">
				<col style="width:95px">
				<col style="width:119px">
				<col style="width:105px">
				<col style="width:146px">
				<col style="width:105px">
			</colgroup>
			<thead>
				<tr>
                    <th>
                          <input type="checkbox" name="freeboard_checkbox" id="allCheck" class="order_check" checked="checked">
                          <label for="allCheck">
                              <span></span>
                          </label>
                    </th>
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
                <c:choose>
                    <c:when test="${basket_list ne null}">
						<input type="hidden" name="rsvOnlyYn" value="Y">
                        <c:set var="basketTotalAmt" value="0"/>
                        <c:set var="dlvrTotalAmt" value="0"/>
                        <c:set var="rsvOnlyDisYn" value="N"/>
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
                                            <c:if test="${basketList.prmtDcGbCd eq '01'}">
                                                <c:set var="prmtDcPrice" value="${((prmtDcPrice-(prmtDcPrice%1))*10)*basketList.buyQtt}"/>
                                            </c:if>
                                            <c:if test="${basketList.prmtDcGbCd eq '02'}">
                                                <c:set var="prmtDcPrice" value="${basketList.dcRate}"/>
                                            </c:if>
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

                        <tr data-goods-no="${basketList.goodsNo}" data-item-no="${basketList.itemNo}" data-item-nm="${basketList.goodsNm}" data-buy-qtt="${basketList.buyQtt}" data-multi-opt-yn="${basketList.multiOptYn}"
                            data-item-price= "${salePrice}" data-session-index="${basketList.basketNo}" data-basket-no = "${basketList.basketNo}" data-stock-qtt="${basketList.stockQtt}"
                            data-min-limit-yn="${basketList.minOrdLimitYn}" data-min-ord-qtt="${basketList.minOrdQtt}" data-max-limit-yn="${basketList.maxOrdLimitYn}" data-max-ord-qtt="${basketList.maxOrdQtt}"
                            data-stock-set-yn="${basketList.stockSetYn}" data-avail-stock-sale-yn="${basketList.availStockSaleYn}" data-avail-stock-qtt="${basketList.availStockQtt}" 
                            data-goods-sale-status-cd="${basketList.goodsSaleStatusCd}" data-rsv-only-yn="${basketList.rsvOnlyYn}" data-dlvrc-payment-cd="${basketList.dlvrcPaymentCd}"
                            data-ord-price="${goodstotalAmt-dcPrice}" data-spc-yn="${spcPriceYn}"
                            >
							<td class="noline valignT">
								<input type="checkbox" name="delBasketNoArr" id="delBasketNoArr_${basketList.basketNo}" value="${basketList.basketNo}" class="order_check" checked="checked">
								<label for="delBasketNoArr_${basketList.basketNo}"><span></span></label>
							</td>
							<td class="noline valignT">
								<div class="cart_img">
									<img src="${_IMAGE_DOMAIN}${basketList.goodsDispImgC}" style="width:100px;height:88px;">
								</div>
							</td>
							<td class="textL">
								<a href="/front/goods/goods-detail?goodsNo=${basketList.goodsNo}">[${basketList.goodsNo}]<br>${basketList.goodsNm}</a>
								<c:set var="attrNm" value=""/>
								<c:if test="${basketList.optNo1Nm ne 'N'}">
									<p class="option">${basketList.optNo1Nm} : ${basketList.attrNo1Nm}
									<c:set var="attrNm" value="${basketList.attrNo1Nm}"/>
								</c:if>
								<c:if test="${basketList.optNo2Nm ne 'N'}">
									<p class="option">${basketList.optNo2Nm} : ${basketList.attrNo2Nm}
									<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}"/>
								</c:if>
								<c:if test="${basketList.optNo3Nm ne 'N'}">
									<p class="option">${basketList.optNo3Nm} : ${basketList.attrNo3Nm}
									<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}, ${basketList.attrNo3Nm}"/>
								</c:if>
								<c:if test="${basketList.optNo4Nm ne 'N'}">
									<p class="option">${basketList.optNo4Nm} : ${basketList.attrNo4Nm}
									<c:set var="attrNm" value="${basketList.attrNo1Nm}, ${basketList.attrNo2Nm}, ${basketList.attrNo3Nm}, ${basketList.attrNo4Nm}"/>
								</c:if>
								<c:if test="${basketList.multiOptYn eq 'Y'}">
										<button type="button" class="btn_cart_s" id = "btnBasketUpdate" name = "btnBasketUpdate" onclick="" >옵션변경</button>
									</p>
								</c:if>

								<c:forEach var="basketAddOptList" items="${basketList.basketOptList}" varStatus="status2">

									<p class="option_s"><%-- ${basketAddOptList.addOptNm} : --%>
										${basketAddOptList.addOptValue} (
											<c:choose>
                                                <c:when test="${basketAddOptList.addOptAmtChgCd eq '1'}">
                                                +
                                                </c:when>
                                                <c:otherwise>
                                                -
                                                </c:otherwise>
										    </c:choose>
										    <fmt:formatNumber value="${basketAddOptList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>)${basketAddOptList.optBuyQtt} 개
									</p>
									<%--<c:choose>
										<c:when test="${basketAddOptList.addOptAmtChgCd eq '1'}">
											<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt+(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
											<c:set var="calcSaleAmt" value="${calcSaleAmt+(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
										</c:when>
										<c:otherwise>
											<c:set var="totalAddOptionAmt" value="${totalAddOptionAmt-(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
											<c:set var="calcSaleAmt" value="${calcSaleAmt-(basketAddOptList.addOptAmt*basketAddOptList.optBuyQtt)}"/>
										</c:otherwise>
									 </c:choose>--%>
								</c:forEach>
								<!-- 사은품추가 2018-09-27  사은품이 없을때 전체가 안나오게 해주세요. 사은품상세이름에는 대괄호없애주세요-->
								<c:if test="${fn:length(basketList.freebieGoodsList) >0}">
									<p class="option_s">사은품 :
										<c:forEach var="freebieGoodsList" items="${basketList.freebieGoodsList}" varStatus="status3">
											<c:out value="${freebieGoodsList.freebieNm}"/>
											<c:if test="${status3.index < (fn:length(basketList.freebieGoodsList)-1)}">
												,
											</c:if>
										</c:forEach>
									</p>
								</c:if>
								<!-- //사은품추가 2018-09-27 -->
								<input type="hidden" class="text-attr-nm" value="${attrNm}"/>
							</td>
							<td class="textC">
								<select class="select_amount" id="buyQtt_${basketList.basketNo}">
										<c:forEach var="cnt" begin="1" end="99">
										<option value="${cnt}" <c:if test="${cnt eq basketList.buyQtt}">selected="selected"</c:if>>
											${cnt}
										</option>
									</c:forEach>
								</select>
								<button type="button" class="btn_cart_s" id = "btnBasketUpdateCnt" name = "btnBasketUpdateCnt" data-attr-nm="${attrNm}">수정</button>
							</td>
							<td>
								<span class="price"><fmt:formatNumber value="${calcSaleAmt+(basketList.salePrice*basketList.buyQtt)}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
								<c:set var="calcSaleAmt" value="${calcSaleAmt+(basketList.salePrice*basketList.buyQtt)}"/>
								<input type="hidden" id="calcSaleAmt" value="${calcSaleAmt}">
							</td>
							<%-- 할인금액 --%>
							<td>
								<c:if test="${basketList.firstSpcOrdYn eq 'N' and basketList.prmtTypeCd eq '06' and member_info.data.firstSpcOrdYn eq 'N' and (member_info.data.newMemberYn eq 'Y' or  member_info.data.oldMemberYn eq 'Y')}">
									특가 할인 <br>
								</c:if>
								<input type="hidden" id="discountAmt" value="${prmtDcPrice+memberGradeDcPrice}">
								<span class="discount"><fmt:formatNumber value="${prmtDcPrice+memberGradeDcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
							</td>
							<%-- 합계 --%>
							<%--<c:set var="goodstotalAmt" value="${(basketList.salePrice*basketList.buyQtt)+totalAddOptionAmt}"/>--%>
							<%-- 주문금액 --%>
							<td>
								<c:choose>
									<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
										<c:set var="rsvOnlyDisYn" value="Y"/>
										<p class="all_price"><em>매장결제</em></p>
										<button type="button" name="regRsvBtnInfo" class="btn_cart_recomm" data-attr-nm="${attrNm}">예약하기</button>
									</c:when>
									<c:otherwise>
										<p class="all_price"><em><fmt:formatNumber value="${goodstotalAmt-dcPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</p>
										<button type="button" name="regOrdBtnInfo" class="btn_cart_order" data-attr-nm="${attrNm}">주문하기</button>
									</c:otherwise>
								</c:choose>
								<div class="cart_sbtn_area">
								   <c:if test="${memberNoYn eq 'Y' and basketList.favYn eq 'Y'}">
										<button type="button" class="btn_cart_favorite active">관심상품</button>
								   </c:if>
								   <c:if test="${memberNoYn eq 'Y' and basketList.favYn ne 'Y'}">
										<button type="button" class="btn_cart_favorite insert-interest">관심상품</button>
								   </c:if>
									<button type="button" class="btn_cart_del" id = "btnBasketDelete" name = "btnBasketDelete">삭제</button>
								</div>

							</td>
							<%-- **** 배송비 계산 **** --%>
							<c:choose>
								<c:when test="${basketList.dlvrSetCd eq '1' && basketList.dlvrcPaymentCd eq '01'}">
									<c:set var="grpId" value="${basketList.sellerNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
								</c:when>
								<c:when test="${basketList.dlvrSetCd eq '1' && (basketList.dlvrcPaymentCd eq '02')}"><%-- or basketList.dlvrcPaymentCd eq '04'--%>
									<c:set var="grpId" value="${basketList.sellerNo}**${basketList.dlvrSetCd}**${basketList.dlvrcPaymentCd}"/>
								</c:when>
								<c:when test="${basketList.dlvrSetCd eq '4' && (basketList.dlvrcPaymentCd eq '02')}"><%-- or basketList.dlvrcPaymentCd eq '04'--%>
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
									<c:when test="${dlvrPriceMap.get(grpId) eq '0' || empty dlvrPriceMap.get(grpId)}">
										<c:choose>
											<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
												<td rowspan="${dlvrCountMap.get(grpId)}"><span class="label_reservation">예약전용</span>
												    <p class="option_s">${basketList.sellerNm}</p>
												</td>
											</c:when>
											<c:otherwise>
											    <td rowspan="${dlvrCountMap.get(grpId)}">
												<c:choose>
													<c:when test="${basketList.dlvrcPaymentCd eq '03'}">
                                                        <p>무료</p>
                                                        <p>착불</p>
                                                        <p class="option_s">${basketList.sellerNm}</p>
													</c:when>
													<c:when test="${basketList.dlvrcPaymentCd eq '04'}">
                                                         <p>무료</p>
                                                         <span class="label_shop">매장픽업</span>
                                                         <p class="option_s">${basketList.sellerNm}</p>
													</c:when>
													<c:otherwise>
														무료
														<p class="option_s">${basketList.sellerNm}</p>
													</c:otherwise>
												</c:choose>
												</td>
											</c:otherwise>
										</c:choose>
											   <input type="hidden" id="dlvrAmt" value="0">
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${basketList.rsvOnlyYn eq 'Y'}">
												<td rowspan="${dlvrCountMap.get(grpId)}"><span class="label_reservation">예약전용</span>
												<input type="hidden" id="dlvrAmt" value="0">
												<p class="option_s">${basketList.sellerNm}</p>
												</td>
											</c:when>
											<c:otherwise>
											    <td rowspan="${dlvrCountMap.get(grpId)}">
												<c:choose>
													<c:when test="${basketList.dlvrcPaymentCd eq '03'}">
                                                        <p>(<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)</p>
                                                        <p>착불</p>
                                                        <p class="option_s">${basketList.sellerNm}</p>
													</c:when>
													<c:when test="${basketList.dlvrcPaymentCd eq '04'}">
                                                         <p><fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</p>
                                                            <span class="label_shop">매장픽업</span>
                                                         <p class="option_s">${basketList.sellerNm}</p>
													</c:when>
													<c:otherwise>
														<fmt:formatNumber value="${dlvrPriceMap.get(grpId)}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
														<p class="option_s">${basketList.sellerNm}</p>
													</c:otherwise>
												</c:choose>
												</td>
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
						</tr>
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
									content_ids : ['${basketList.goodsNo}'],
									content_type: 'product',
									value       : '${salePrice}',
									currency    : 'KRW'
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
                       <tr>
                           <td colspan="10">장바구니에 등록된 상품이 없습니다.</td>
                       </tr>
                   </c:otherwise>
               </c:choose>
			</tbody>
		</table>
		
		<div class="cart_btn_area">
            <button type="button" class="btn_select_del" id="selectDelete" name ="selectDelete">선택상품 삭제</button>
            <button type="button" class="btn_select_del" id="selectPickup" name ="selectPickup" style="width:150px;">매장픽업 상품만 선택</button>
            <button type="button" class="btn_select_del" id="selectDeliv" name ="selectDeliv">택배상품만 선택</button>
			<p class="text">장바구니 상품은 로그인시 ${site_info.goodsKeepDcnt}일간 보관됩니다.  품절 상품은 자동삭제됩니다.</p>
		</div>
		<div class="cart_bottom_box">
			<div class="count">
				<span>상품금액</span>
				<em id="em_calcSaleAmt"><fmt:formatNumber value="${empty basketTotalAmt?'0':basketTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
			</div>
			<i class="minus"></i>
			<div class="count">
				<span>할인금액</span>
				<em id="em_discountAmt"><fmt:formatNumber value="${promotionTotalDcAmt+memberGradeTotalDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</div>
			<i class="plus"></i>
			<div class="count">
				<span>배송비</span>
				<em id="em_dlvrAmt"><fmt:formatNumber value="${empty dlvrTotalAmt ? '0' : dlvrTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
			</div>
			<i class="equal"></i>
			<div class="count total">
				<span>결제예정금액</span>
				<em id="em_orderAmt"><fmt:formatNumber value="${empty paymentTotalAmt ? '0' : paymentTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
				<c:if test="${rsvOnlyDisYn eq 'Y'}">
					<div class="alret_reservation">
						<em>매장결제</em> 상품은 <br><em>결제예정금액</em>에서<br>제외됩니다.
					</div>
				</c:if>
			</div>
		</div>
        <div id="itemNoArrDiv">
        </div>
		<div class="cart_bottom_btn_area">
			<button type="button" class="btn_select_checkout" id="keepSopping">쇼핑계속하기</button>
			<button type="button" class="btn_all_checkout" id="regSelectOrdInfo">주문하기</button>
		</div>
	</div>
    <!---// 02.LAYOUT: 주문 메인 --->	
    
    </form>
    <!---// 장바구니 --->
 
    <!--- popup 주문조건 추가/변경 --->
    <div id="success_basket"  class="popup_goods_plus" style="display: none;"><div id ="goodsDetail"></div></div>
    <!---// wishlist  --->
    </t:putAttribute>
</t:insertDefinition>