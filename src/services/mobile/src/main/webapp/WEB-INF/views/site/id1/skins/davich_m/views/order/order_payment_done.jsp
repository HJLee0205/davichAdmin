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
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">주문완료</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <%-- 텐션DA SCRIPT --%>
	<script>
		ex2cts.push('track', 'purchase');
		var purchasePrice = 0;

        purchasePrice = "${orderVO.orderInfoVO.paymentAmt}";

        ex2cts.push('purchase', {value:purchasePrice});
	</script>
	<%--// 텐션DA SCRIPT --%>
    <script>
        fbq('track', 'Purchase', {
            content_ids: ['${orderVO.orderInfoVO.ordNo}'],
            content_type: 'product',
            value: '${orderVO.orderInfoVO.paymentAmt}',
            currency: 'KRW'
            });
    </script>
    <!-- adinsight 주문 총금액 받아옴. start -->
    <script language='javascript'>
     var TRS_AMT='${orderVO.orderInfoVO.paymentAmt}';
     var TRS_ORDER_ID='${orderVO.orderInfoVO.ordNo}';
    </script>
    <!-- adinsight 주문 총금액 받아옴. end -->
    <!-- adinsight 주문 상품별 아이디 받아옴. start-->
    <script type="text/javascript">
        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:set var="itemNm" value=""/>
            <c:if test="${goodsList.itemNm eq null}">
                <c:set var="itemNm" value="${goodsList.goodsNm}"/>
            </c:if>
            <c:if test="${goodsList.itemNm ne null}">
                <c:set var="itemNm" value="${goodsList.goodsNm} ${goodsList.itemNm}"/>
            </c:if>
             if(typeof TRS_PRODUCT == 'undefined'){
              var TRS_PRODUCT = '' + '${goodsList.itemNo}';
             }else{
              TRS_PRODUCT = TRS_PRODUCT + ' $ '+ '${goodsList.itemNo}';
             }
        </c:forEach>
    </script>
    <!-- adinsight 주문 상품별 아이디 받아옴. end-->
    <%-- 카카오 모먼트 --%>
    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
    <script type="text/javascript">
          kakaoPixel('59690711162928695').pageView();
          kakaoPixel('7385103066531646539').pageView();
         var kko_param =
              {
               "total_quantity": "${fn:length(orderVO.orderGoodsVO)}", // 주문 내 상품 개수(optional)
                "total_price": "${orderVO.orderInfoVO.paymentAmt}",  // 주문 총 가격(optional)
                "currency": "KRW",     // 주문 가격의 화폐 단위(optional, 기본 값은 KRW)
                "products": [] // 주문 내 상품 정보(optional)
              };
          var kkoproduct = new Array();
          var kkoitems;
          <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:set var="itemNm" value=""/>
            <c:if test="${goodsList.itemNm eq null}">
                <c:set var="itemNm" value="${goodsList.goodsNm}"/>
            </c:if>
            <c:if test="${goodsList.itemNm ne null}">
                <c:set var="itemNm" value="${goodsList.goodsNm} ${goodsList.itemNm}"/>
            </c:if>
            kkoitems = new Object();
            kkoitems.name='${itemNm}';
            kkoitems.quantity='${goodsList.ordQtt}';
            kkoitems.price='${goodsList.saleAmt}';
            kkoproduct.push(kkoitems);
            kko_param.products = kkoproduct;
          </c:forEach>
          kakaoPixel('59690711162928695').purchase(kko_param);
          kakaoPixel('7385103066531646539').purchase(kko_param);
    </script>
    <%-- // 카카오 모먼트 --%>
    <script>
        gtag('event', 'conversion', {'send_to': 'AW-760445332/RfZGCL2twpYBEJTzzeoC','value': 1.0,'currency': 'KRW','transaction_id': '${orderVO.orderInfoVO.ordNo}'});
        /* gtag전자상거래 분석 START */
        var shipping =0;
        var value =0;
        var purchase_param = {
                  "transaction_id": "${orderVO.orderInfoVO.ordNo}",
                  "affiliation": "Davich Market",
                  "value": value,
                  "currency": "KRW",
                  "tax": 0,
                  "shipping": shipping,
                  "items": []
          };

      var purchase_product = new Array();
      var purchase_items;
      <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
        purchase_items = new Object();
        purchase_items.id='${goodsList.goodsNo}';
        purchase_items.name='${goodsList.goodsNm}';
        purchase_items.list_name='Order Product List';
        purchase_items.brand='${goodsList.brandNm}';
        purchase_items.category='${goodsList.ctgName}';
        purchase_items.variant='${goodsList.itemNm}';
        purchase_items.list_position='${status.index+1}';
        purchase_items.quantity='${goodsList.ordQtt}';
	    purchase_items.price='${goodsList.saleAmt}';
        purchase_product.push(purchase_items);
        purchase_param.items= purchase_product;
        //배송비
        purchase_param.shipping += ${goodsList.realDlvrAmt};
        purchase_param.value += ${goodsList.payAmt};
      </c:forEach>
        gtag('event', 'purchase', purchase_param);
        /* gtag전자상거래 분석 END */

    </script>
    <%--Cauly CPA 광고--%>
	<%--<script type="text/javascript" src="//image.cauly.co.kr/cpa/util_sha1.js" ></script>
	<script type="text/javascript">
	  var etc_param =
          {
            "order_id":"${orderVO.orderInfoVO.ordNo}",
            "order_price":"${orderVO.orderInfoVO.paymentAmt}",
            "products":[]
          };
      var product = new Array();
	  var items;
      <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
        items = new Object();
        items.id='${goodsList.itemNo}';
	    items.price='${goodsList.saleAmt}';
  	    items.quantity='${goodsList.ordQtt}';
  	    product.push(items);
  	    etc_param.products = product;
      </c:forEach>
	  window._paq = window._paq || [];
	  _paq.push(['track_code',"a9a01f1f-8e03-4d4d-af16-1b95e46fe041"]);
      _paq.push(['event_name','CA_PURCHASE']);
      _paq.push(['etc_param',etc_param]);
	  _paq.push(['send_event']);
	  (function(){ var u="//image.cauly.co.kr/script/"; var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'caulytracker_async.js'; s.parentNode.insertBefore(g,s); })();
	</script>--%>
	<%-- // Cauly CPA 광고--%>

    <!-- Event snippet for 구매완료 conversion page -->
    <script> gtag('event', 'conversion', { 'send_to': 'AW-774029432/X6czCLvWwJEBEPiAi_EC', 'value': ${orderVO.orderInfoVO.paymentAmt}, 'currency': 'KRW', 'transaction_id': '${orderVO.orderInfoVO.ordNo}' }); </script>

    <!-- Enliple Tracker v3.5 [결제전환] start -->
    <script type="text/javascript">
	    function mobConv(){
	        var cn = new EN();
	        cn.setData("uid", "davich2");
	        cn.setData("ordcode", "${orderVO.orderInfoVO.ordNo}"); //필수
	        //cn.setData("pcode", "제품 코드"); //옵션
	        cn.setData("qty", "${fn:length(orderVO.orderGoodsVO)}"); //필수
	        cn.setData("price", "${orderVO.orderInfoVO.paymentAmt}"); //필수
	        cn.setData("pnm", encodeURIComponent(encodeURIComponent("${orderVO.orderGoodsVO[0].goodsNm}"))); //옵션
	        cn.setSSL(true);
	        cn.sendConv();
	    }
    </script>
    <script src="https://cdn.megadata.co.kr/js/en_script/3.5/enliple_min3.5.js" defer="defer" onload="mobConv()"></script>
    <!-- Enliple Tracker v3.5 [결제전환] end -->

    <c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
        <c:if test="${paymentList.paymentPgCd eq '04'}">
          <script language=javascript>
          // 올더게이트 "지불처리중"팝업창 닫는 부분
          /*var openwin = window.open("about:blank","popup","width=300,height=160");
          openwin.close();*/
          </script>
        </c:if>
    </c:forEach>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- 03.LAYOUT:CONTENTS --->
        <c:set var="recomm_show" value="N"/>
        <c:set var="contact_lens_exist" value="콘텍트"/>
        <c:set var="lensType" value="C"/>
        <%-- logCorpAScript --%>
         <%--시나리오(cart:카트,cartend:주소기입,payend:결제완료,REGC:회원가입 또는 약관동의,REGF:입력폼,REGO:회원완료)--%>
         <c:set var="http_SO" value="payend" scope="request"/>
         <c:set var="http_OD" value="${orderVO.orderInfoVO.ordNo}" scope="request"/> <%--//주문서코드--%>
         <%--// logCorpAScript --%>
        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <%--주문상풍유형이 안경테일경우 주문완료 폼 설정--%>
            <c:if test="${goodsList.goodsTypeCd eq '01' || goodsList.goodsTypeCd eq '02' || goodsList.goodsTypeCd eq '03' || goodsList.goodsTypeCd eq '04' || goodsList.goodsTypeCd eq '05'}">
                <c:set var="recomm_show" value="Y"/>
                <c:if test="${goodsList.goodsTypeCd ne '04'}">
                	<c:set var="contact_lens_exist" value="안경"/>
                	<c:set var="lensType" value="G"/>
                </c:if>
            </c:if>
        </c:forEach>
        <div id="middle_area">
            <div class="product_head">
                <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
                주문완료
            </div>

            <div class="cont_body">

                <h2 class="order_completed_tit"><i></i><br>주문이 완료되었습니다.</h2>
                <div class="completed_detail">
                    <!-- <p class="completed_greeding">"주문해 주셔서 감사합니다."</p> -->
                    <ul class="detail_info">
                        <li>
                            <span class="tit">주문번호</span>
                            <span class="text"><b>${orderVO.orderInfoVO.ordNo}</b></span>
                        </li>
                        <li>
                            <span class="tit">주문상품</span>
                            <span class="text">${orderVO.orderGoodsVO[0].goodsNm}
                            <c:if test="${fn:length(orderVO.orderGoodsVO) > 1}">
                            외
                            </c:if>
                            </span>
                        </li>
                        <li>
                            <span class="tit">결제금액</span>
                            <span class="text">
                                <%-- 네이버 스크립트 용 변수&값 --%>
                                <input type="hidden" name="naverPaymentAmt" id="naverPaymentAmt" value="${orderVO.orderInfoVO.paymentAmt}"/>
								<c:set var="payText" value="최종 결제금액/수단"/>
								<c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
									<c:if test="${paymentList.paymentWayCd eq '11' || paymentList.paymentWayCd eq '22'}">
										<c:set var="payText" value="입금할금액/정보/날짜"/>
									</c:if>
								</c:forEach>
								<c:forEach var="paymentList" items="${orderVO.orderPayVO}" varStatus="status">
									<c:if test="${paymentList.paymentWayCd ne '01' }">

											<em class="price">
												<c:if test="${paymentList.paymentWayCd eq '23'}"> <%-- 신용카드 --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}_${paymentList.cardNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '11'}"> <%-- 무통장 --%>
													<fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span> 
													${paymentList.paymentWayNm}<br> 
													${paymentList.bankNm}&nbsp;${paymentList.actNo}&nbsp;${paymentList.holderNm} 
													<span class="bar">|</span> 
													<fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" />까지
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '21'}"> <%-- 실시간계좌이체 --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}_${paymentList.bankNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '22'}"> <%-- 가상계좌 --%>
													<fmt:parseDate var="dpstScdDt" value="${paymentList.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}_${paymentList.bankNm}&nbsp;${paymentList.actNo}<br>
													<span class="bar">|</span>
													<fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd" />까지
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '24'}"> <%-- 핸드폰결제 --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '31'}"> <%-- 간편결제(PAYCO) --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '41'}"> <%-- PAYPAL --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '42'}"> <%-- ALIPAY --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '43'}"> <%-- TENPAY --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
												<c:if test="${paymentList.paymentWayCd eq '44'}"> <%-- WECHPAY --%>
													<fmt:formatNumber value="${paymentList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
													<span class="bar">|</span>
													${paymentList.paymentWayNm}
												</c:if>
											</em>
											<%--<span class="bar">|</span>${paymentList.paymentWayNm}--%>
									</c:if>
								</c:forEach>
                            </span>
                        </li>
                        <li>
                            <span class="tit">배송지</span>
                            <span class="text">
                            <c:choose>
                                <c:when test="${orderVO.orderInfoVO.memberGbCd eq '10'}">
                                    <c:if test="${orderVO.orderInfoVO.postNo ne null}">
                                        [${orderVO.orderInfoVO.postNo}]
                                    </c:if>
                                    ${orderVO.orderInfoVO.roadnmAddr eq null?orderVO.orderInfoVO.numAddr:orderVO.orderInfoVO.roadnmAddr} <span class="bar"></span>${orderVO.orderInfoVO.dtlAddr}
                                </c:when>
                                <c:otherwise>
                                </c:otherwise>
                            </c:choose>
                            <span class="bar">/</span>${orderVO.orderInfoVO.adrsNm}
                            </span>
                        </li>
                    </ul>
                    <p class="info_text">자세한 구매내역은 <a href="javascript:;" id="move_order">마이페이지 &gt; 나의 주문 메뉴</a>에서 확인하실 수 있습니다.</p>
                    <c:if test="${recomm_show eq 'Y'}">
                    <div class="order_completed_reservation">
                        <p class="text01">
                            <em class="member">${orderVO.orderInfoVO.ordrNm}</em>님,<br>고객님의 시력과 라이프 스타일에 맞는 ${contact_lens_exist }렌즈를<br>추천해 드릴게요!<br>
                            <button type="button" class="btn_recomm_check" onclick="javascript:location.href='${_MOBILE_PATH}/front/vision2/vision-check?lensType=${lensType}'">${contact_lens_exist }렌즈 추천받기<i></i></button>
                        </p>
                        <p class="text02">맘에 드는 <em class="point">${contact_lens_exist }렌즈를 예약</em>하시고 <em class="point">할인된 가격</em>으로 <em class="point">매장에서 구매</em>해 보세요.</p>
                    </div>
                    <script type="text/javascript">
                    	$(document).ready(function(){
                    		//Dmall.LayerUtil.alert("고객님께 맞는 ${contact_lens_exist }렌즈를 <br>추천해 드립니다.", "알림");
                    		Dmall.LayerPopupUtil.open($('#lens_recom_popup'));
                    		
                    		// 팝업 닫기
                    		$('.btn_alert_cancel, .btn_alert_close').click(function(){
                    			Dmall.LayerPopupUtil.close('lens_recom_popup');
                    		});
                    	});
                    </script>
                    </c:if>
                </div>

                <div class="btn_area_ordered">
                    <button type="button" class="btn_select_checkout" onclick="location.href='/m/front'">쇼핑계속하기</button>
                    <button type="button" class="btn_ordered_detail" id="move_order">주문내역확인</button>
                </div>


            </div>
        </div>
        <!---// 03.LAYOUT: MIDDLE AREA --->
        
        <!--- 렌즈추천 popup --->
		<div class="alert_body" id="lens_recom_popup" style="display:none">
		    <button type="button" class="btn_alert_close"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		    <div class="alert_content">
		        <div class="alert_text">
		        	고객님께 맞는 ${contact_lens_exist }렌즈를 추천해 드립니다.
		        </div>
		        <div class="alert_btn_area">
		            <button type="button" class="btn_alert_cancel">닫기</button>
		            <button type="button" class="btn_alert_ok" onclick="javascript:location.href='${_MOBILE_PATH}/front/vision2/vision-check?lensType=${lensType}'">지금 추천받기</button>
		        </div>
		    </div>
		</div>
		<!---// 렌즈추천 popup --->

    </t:putAttribute>
</t:insertDefinition>