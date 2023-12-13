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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">상품상세</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	<%@ include file="/WEB-INF/views/goods/goods_detail_js.jsp" %>
	<%@ include file="/WEB-INF/views/goods/goods_detail_inc.jsp" %>
	</t:putAttribute>    
    
	<t:putAttribute name="content">
	<!-- 모바일버전 -->
	<form name="goods_form" id="goods_form">
        <input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
        <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
		<!--- 03.LAYOUT:CONTENTS --->
		<div id="middle_area">	
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				상품상세
			</div>	
			<div class="product_top">			
				<div class="goods_title">
					[${goodsInfo.data.goodsNm}]
					<c:set var="ctgIndex" value="0"></c:set>
					<c:forEach var="navigationList" items="${navigation}" varStatus="status">
	                    <c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
	                        <c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">
	                        	<c:if test="${ctgIndex > 0}">, </c:if>${ctgList1.ctgNm}
	                        	<c:set var="ctgIndex" value="${ctgIndex+1}"></c:set>
	                        </c:if>
	                    </c:forEach>
		            </c:forEach>
				</div>
				<div class="product_info">
					${goodsInfo.data.prWords}
				</div>
				<div class="label_area">
					<%--<img src="${_SKIN_IMG_PATH}/product_list/icon_best.png" alt="best">
					<img src="${_SKIN_IMG_PATH}/product_list/icon_new.png" alt="new">
					<img src="${_SKIN_IMG_PATH}/product_list/icon_hot.png" alt="hot">
					<img src="${_SKIN_IMG_PATH}/product_list/icon_only.png" alt="단독">
					<img src="${_SKIN_IMG_PATH}/product_list/icon_low.png" alt="최저가">--%>
				</div>
				<br/><div class="price_info">
					<del><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>
					<em><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원 
					<span class="point_p">
					<c:choose>
                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'Y'}">
	                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
	                        (${site_info.svmnPvdRate}% 적립)
	                        </c:if>
                        </c:when>
                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'N'}">
	                        <fmt:parseNumber var="goodsSvmnAmt" type="number" value="${goodsInfo.data.goodsSvmnAmt}"/>
	                        (<fmt:formatNumber value="${goodsSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 적립)
                        </c:when>
                    </c:choose>
					</span>
				</div>
			</div>
			
			<!-- 상품상세이미지 -->			
			<div class="product_slider_area">
				<ul class="product_slider">
		            <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
		                <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
		                    <c:if test="${imgDtlList.goodsImgType eq '02'}">
		                    <%-- <li><img src="${_SKIN_IMG_PATH}/product/goods_view_img01.gif" alt=""></li> --%>
		                    <li><img src="/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></li>
		                    </c:if>
		                </c:forEach>
		            </c:forEach>
				</ul>
			</div>
			<!-- // 상품상세이미지 -->
            
			<div class="product_detail_area">
				<ul class="product_detail_list">
					<li class="form">
						<span class="title">배송방법</span>
						<p class="detail">
							<c:choose>
	                            <c:when test="${dlvrMehtodCnt ne 0 && dlvrMehtodCnt gt 1}">
	                                    <select class="select_option" name="dlvrMethodCd" id="dlvrMethodCd" title="select option">
	                                        <option selected="selected"  value="">(필수) 선택하세요</option>
	                                        <c:if test="${couriUseYn eq 'Y'}">
	                                        <option value="01">택배</option>
	                                        </c:if>
	                                        <c:if test="${directVisitRecptYn eq 'Y'}">
	                                        <option value="02">매장픽업</option>
	                                        </c:if>
	                                    </select>
	                            </c:when>
	                            <c:otherwise>
	                                    <c:if test="${couriUseYn eq 'Y'}">
	                                    택배&nbsp;
	                                    <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="01">
	                                    </c:if>
	                                    <c:if test="${directVisitRecptYn eq 'Y'}">
	                                    매장픽업
	                                    <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="02">
	                                    </c:if>
	                            </c:otherwise>
	                        </c:choose>
						</p>
					</li>
					
					<c:if test="${goodsDlvrAmt eq '0' }">
                        <li class="form">
                            <span class="title">배송비결제</span>
                            <p class="detail">무료</p>
                            <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="01"> <%-- 무료 --%>
                        </li>
                    </c:if>
                    <c:if test="${goodsDlvrAmt ne '0' }">
                        <li class="form" id="dlvrPaymentKindCd01">
                            <span class="title">배송비결제</span>
                            <p class="detail">
								<c:choose>
	                                <c:when test="${dlvrPaymentKindCdCnt gt 1}">
	                                <select class="select_option" style="width:70%" name="dlvrcPaymentCd" id="dlvrcPaymentCd" title="select option">
	                                    <option selected="selected" value="">(필수) 선택하세요</option>
	                                    <option value="02">주문시 선결제</option>
	                                    <option value="03">수령 후 지불</option>
	                                </select>
	                                </c:when>
	                                <c:otherwise>
	                                    <c:if test="${dlvrPaymentKindCd eq '1'}">
	                                    주문시 선결제
	                                    <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02">
	                                    </c:if>
	                                    <c:if test="${dlvrPaymentKindCd eq '2'}">
	                                    수령 후 지불
	                                    <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="03">
	                                    </c:if>
	                                </c:otherwise>
	                            </c:choose>
	                            <fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
							</p>
                            
                        </li>
                        <li class="form" id="dlvrPaymentKindCd02" style="display:none">
							<span class="title">배송비결제</span>
							<p class="detail">무료</p>
						</li>
                    </c:if>
                    
                    
                    <c:if test="${goodsInfo.data.multiOptYn eq 'Y' || goodsInfo.data.addOptUseYn eq 'Y'}">
		            <!--- 상품 옵션 있을 경우 --->
	                    <c:if test="${goodsInfo.data.goodsOptionList ne null}">
	                        <c:forEach var="optionList" items="${goodsInfo.data.goodsOptionList}" varStatus="status">
	                        <li class="form">
								<span class="title">${optionList.optNm}</span>
								<p class="detail">
									<select class="select_option goods_option" id="goods_option_${status.index}" title="select option" 
											data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
	                                    <option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>
	                                </select>
								</p>
							</li>
	                        </c:forEach>
	                    </c:if>
	                    <c:if test="${goodsInfo.data.goodsAddOptionList ne null}">
	                        <c:forEach var="addOptionList" items="${goodsInfo.data.goodsAddOptionList}" varStatus="status">
	                        <li class="form">
								<span class="title">${addOptionList.addOptNm}</span>
								<p class="detail">
									<select class="select_option goods_addOption" title="select option" 
											data-required-yn="${addOptionList.requiredYn}" data-add-opt-no="${addOptionList.addOptNo}" data-add-opt-nm="${addOptionList.addOptNm}">
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

                                            </c:otherwise>
                                        </c:choose>
                                        <fmt:formatNumber value="${addOptionDtlList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                                        </option>
                                        </c:forEach>
                                    </select>
								</p>
							</li>
	                        </c:forEach>
	                    </c:if>
		            </c:if>
		            <c:if test="${goodsInfo.data.multiOptYn eq 'N'}">
		            <!---// 단일 옵션일 경우 --->
		            <input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
		            <input type="hidden" name="itemPriceArr" id="itemPriceArr" class="itemPriceArr" value="${goodsInfo.data.salePrice}">
		            <input type="hidden" name="stockQttArr" id="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
		            <input type="hidden" name="itemArr" id="itemArr" class="itemArr" value="">
		            <li class="form">
						<span class="title">구매수량</span>
						<p class="detail">
							<select class="select_option input_goods_no" name="buyQttArr" id="input_goods_no" title="select option">
                                <c:forEach var="cnt" begin="1" end="99">
                                <option value="${cnt}">${cnt}</option>
                                </c:forEach>
                            </select>
						</p>
					</li>
		            </c:if>
		            
				</ul>
				<ul class="goods_plus_info02">
		        <!--// 옵션 레이어 영역 //-->
		        </ul>

				<div class="product_price_area_top">
					<div class="product_price_area">
						<c:if test="${goodsStatus eq '01' || goodsStatus eq '02'}">
							<button type="button" class="btn_check_like <c:if test="${interestGoodsCnt > 0}">active</c:if>" 
								data-interest-goods-cnt="${interestGoodsCnt}"><span class="icon_like"></span></button>
						</c:if>
						<span>
							총 상품금액	<em id="totalPriceText"><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em><b>원</b>
							<input type="hidden" name="totalPrice" id="totalPrice" value="0">
						</span>
					</div>
				</div>
				<div class="product_btn_area">
					<ul class="product_btn_list">
						<c:if test="${fn:length(couponList) > 0}">
						<li class="counpon_img">
							<a href="javascript:downloadCoupon();">
		                		<img src="${_MOBILE_PATH}/front/img/product/coupon_img.gif">
								할인쿠폰 다운받기
		                	</a>
						</li>
		                </c:if>
		                <li class="counpon_btn_area">
		                	<c:if test="${goodsStatus eq '01'}">
			                    <button type="button" class="btn_go_cart" id="btn_go_cart">장바구니</button>
								<button type="button" class="btn_go_checkout" id="btn_go_checkout">바로구매</button>
			                </c:if>
			                <c:if test="${goodsStatus eq '02'}">
			                	<c:if test="${user.session.memberNo ne null }">
			                        <button type="button" class="btn_go_checkout" id="btn_alarm_view">재입고알림</button>
			                    </c:if>
			                    <button type="button" class="btn_go_checkout">품절</button>
			                </c:if>
			                <c:if test="${goodsStatus eq '03'}">
			                	<button type="button" class="btn_go_checkout">판매대기</button>
			                </c:if>
			                <c:if test="${goodsStatus eq '04'}">
			                	<button type="button" class="btn_go_checkout">판매중지</button>
			                </c:if>
						</li>
					</ul>
				</div>
				<input type="hidden" name="returnUrl" id="returnUrl" value="">
				
				<div class="product_point_check">
					<div class="check_review" id="check_review">
						상품평 <span><em>${goodsBbsInfo.data.reviewCount}</em>건</span>
					</div>
					<div class="check_star">
						고객평점
						<span class="star_area" id="star_area">
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_gray.png" alt="">
							<img src="${_MOBILE_PATH}/front/img/product/icon_star_gray.png" alt="">
							9.7
						</span>
					</div>
					<div class="check_sns">
						<button type="button" class="btn_view_sns"><span class="icon_go_sns"></span></button>
						<!-- sns 레이어 -->
						<div class="btn_sns_area" style="display:none;">
							<button type="button" class="btn_sns" onClick="jsShareFacebook();"><span class="icon_facebook"></span></button>
							<button type="button" class="btn_sns" onClick="jsShareKastory();"><span class="icon_kakao"></span></button>
						</div>
						<!--// sns 레이어 -->
					</div>
					
				</div>
				<ul class="product_detail_list" style="clear:both">
					<li class="form">
						<span class="title">소비자가격</span>
						<p class="detail">
							<fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
						</p>
					</li>
					<li class="form">
						<span class="title">판매가격</span>
						<p class="detail">
							<c:set var="salePrice" value="${goodsInfo.data.salePrice}"/>
		                    <%-- 기획전 할인 --%>
		                    <c:choose>
		                        <c:when test="${promotionInfo.data eq null}">
		                            <c:set var="dcPrice" value="0"/>
		                            <c:set var="salePrice" value="${salePrice}"/>
		                        </c:when>
		                        <c:otherwise>
		                            <c:set var="dcPrice" value="${goodsInfo.data.salePrice*(promotionInfo.data.prmtDcValue/100)/10}"/>
		                            <c:set var="dcPrice" value="${(dcPrice-(dcPrice%1))*10}"/>
		                            <c:set var="salePrice" value="${salePrice-dcPrice}"/>
		                        </c:otherwise>
		                    </c:choose>
		                    <span class="price_info"><em><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
						</p>
					</li>
	                <li class="form">
						<span class="title">마켓포인트</span>
						<p class="detail">
							<c:set var="pvdSvmnAmt" value="0"/>
		                    <c:choose>
		                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'Y'}">
		                        <c:if test="${site_info.svmnPvdYn eq 'Y'}">
		                            <c:set var="svmnTruncStndrdCd" value="1"/>
		                            <c:choose>
		                                <c:when test="${site_info.svmnTruncStndrdCd eq '2'}">
		                                    <c:set var="svmnTruncStndrdCd" value="10"/>
		                                </c:when>
		                                <c:when test="${site_info.svmnTruncStndrdCd eq '3'}">
		                                    <c:set var="svmnTruncStndrdCd" value="100"/>
		                                </c:when>
		                                <c:when test="${site_info.svmnTruncStndrdCd eq '4'}">
		                                    <c:set var="svmnTruncStndrdCd" value="1000"/>
		                                </c:when>
		                            </c:choose>
		                            <c:set var="pvdSvmnAmt" value="${goodsInfo.data.salePrice*(site_info.svmnPvdRate/100)/svmnTruncStndrdCd}"/>
		                            <c:set var="pvdSvmnAmt" value="${(pvdSvmnAmt-(pvdSvmnAmt%1))*svmnTruncStndrdCd}"/>
		                        </c:if>
		                        </c:when>
		                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'N'}">
		                            <fmt:parseNumber var="goodsSvmnAmt" type="number" value="${goodsInfo.data.goodsSvmnAmt}"/>
		                            <c:set var="pvdSvmnAmt" value="${goodsSvmnAmt}"/>
		                        </c:when>
		                    </c:choose>
	                        <c:if test="${pvdSvmnAmt gt 0}">
	                        <fmt:formatNumber value="${pvdSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
	                        </c:if>
	                        (회원등급별 <!--최대 2%까지 --> 추가 적립)
						</p>
					</li>
					<c:if test="${freebieGoodsList ne null && fn:length(freebieGoodsList) gt 0}">
                    <li class="form">
						<span class="title">사은품</span>
						<p class="detail">
							<button type="button" class="btn_coupon" id="btn_gift">사은품보기</button>
						</p>
					</li>
                    </c:if>
					<li class="form">
						<span class="title">배송비</span>
						<p class="detail">
							<c:if test="${goodsDlvrAmt eq '0' }">
								무료
							</c:if>
                    		<c:if test="${goodsDlvrAmt ne '0' }">
                    			<fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                    		</c:if>
						</p>
					</li>
					<li class="form">
						<span class="title">배송방법</span>
						<p class="detail">
							<c:choose>
	                            <c:when test="${dlvrMehtodCnt ne 0 && dlvrMehtodCnt gt 1}">
	                            	<c:if test="${couriUseYn eq 'Y'}">택배 </c:if>
	                            	<c:if test="${directVisitRecptYn eq 'Y'}">매장픽업</c:if>
	                            </c:when>
	                            <c:otherwise>
                                    <c:if test="${couriUseYn eq 'Y'}">택배 </c:if>
                                    <c:if test="${directVisitRecptYn eq 'Y'}">매장픽업</c:if>
	                            </c:otherwise>
	                        </c:choose>
						</p>
					</li>
					<li class="form">
						<span class="title">배송기간</span>
						<p class="detail">
							결제일로부터 ${goodsInfo.data.dlvrExpectDays}일
						</p>
					</li>
					<li class="form">
						<span class="title">원산지</span>
						<p class="detail">
							${goodsInfo.data.habitat}
						</p>
					</li>
					<li class="form">
						<span class="title">상품번호</span>
						<p class="detail">
							${goodsInfo.data.goodsNo}
						</p>
					</li>
				</ul>
				<ul class="product_information_menu">
					<li>
						<a href="#" id="btn_goods_content" onclick="return false;">
							<span class="icon_product01"></span>상품상세정보						
							<span class="icon_go_detail"></span>	
						</a>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/review/review-list-ajax?goodsNo=${goodsInfo.data.goodsNo}">
							<span class="icon_product02"></span>상품평
							<span class="star_area" id="star_area2">
								<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
								<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
								<img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="">
								<img src="${_MOBILE_PATH}/front/img/product/icon_star_gray.png" alt="">
								<img src="${_MOBILE_PATH}/front/img/product/icon_star_gray.png" alt="">
								(131)
							</span>
							<span class="icon_go_detail"></span>	
						</a>
					</li>
					<li>
						<a href="${_MOBILE_PATH}/front/question/question-list-ajax?goodsNo=${goodsInfo.data.goodsNo}">
							<span class="icon_product03"></span>상품문의						
							<span class="icon_go_detail"></span>	
						</a>
					</li>
					<li>
						<a href="#" id="btn_extra" onclick="return false;">
							<span class="icon_product04"></span>배송/반품/교환안내						
							<span class="icon_go_detail"></span>	
						</a>
					</li>
				</ul>
			</div>
			<!-- 관련상품 -->
			<c:if test="${goodsInfo.data.relateGoodsApplyTypeCd ne '3' &&  goodsInfo.data.relateGoodsApplyTypeCd ne null}">
	    	<h2 class="sub_title">관련상품</h2>
	    	<data:goodsList value="${goodsInfo.data.relateGoodsList}" headYn="N" iconYn="Y" displayTypeCd="04"/>
		    </c:if>
		    <!-- // 관련상품 -->
			
		
		
		<!--- popup 장바구니 등록성공 --->
	    <div class="alert_body" id="success_basket" style="display: none;">
	        <button type="button" class="btn_alert_close"><img src="${_MOBILE_PATH}/front/img/web/common/btn_close_popup02.png" alt="팝업창닫기"></button>
	        <div class="alert_content">
	            <div class="alert_text" style="padding:32px 0 16px">
	                상품이 장바구니에 담겼습니다.
	            </div>
	            <div class="alert_btn_area">
	                <button type="button" class="btn_alert_cancel" id="btn_close_pop">계속 쇼핑</button>
	                <button type="button" class="btn_alert_ok" id="btn_move_basket">장바구니로</button>
	            </div>
	        </div>
	    </div>
	    <!---// popup 장바구니 등록성공 --->
	
	    <!--- popup 재입고 알림 --->
	    <div id="div_restock"></div>
	    <!---// popup 재입고 알림 --->
	
	   
	    <!--- popup_사은품 --->
		<div id="popup_gift_select" class="popup" data-cnt="${fn:length(freebieGoodsList)}">
			<div class="popup_head">
				사은품 이벤트
				<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
				<span class="popup_head_text"><span class="store_name">*</span> 상품을 
				<span class="store_price"><fmt:formatNumber value="${freebieGoodsList[0].freebieEventAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span> 이상 주문하시면
				아래의 사은품 중 <span class="store_num">1개</span>를 증정합니다.</span>
			</div>
			<div class="popup_gift_scroll">
				<ul class="gift_list">
					<li>
	                	<img src="/image/image-view?type=FREEBIEDTL&id1=${freebieGoodsList[0].imgPath}_${freebieGoodsList[0].imgNm}" alt="">
	                    <p>${freebieGoodsList[0].freebieNm}<br/><span></span></p>
	                </li>
				</ul>
			</div>
			<div class="popup_btn_area">
				<button type="button" class="btn_popup_cancel closepopup">닫기</button>
			</div>
		</div>
		<!---// popup_사은품 --->
		
		
		<!---// 배송/반품/환불 안내 --->
		<div id="extraInfo" class="popup">
			<div class="popup_head">
				<button type="button" class="btn_close_popup closepopup"><span class="icon_popup_close"></span></button>
				배송/반품/교환 안내
			</div>			
			<div class="popup_gift_scroll">
				<ul class="shopping_info_list">
					<li class="title">배송안내</li>
					<li>${term_14.data.content}</li>
					<li class="title">반품/교환안내</li>
					<li>${term_15.data.content}</li>
					<li class="title">반품/환불안내</li>
					<li>${term_16.data.content}</li>
				</ul>
			</div>
			<div class="popup_btn_area">
				<button type="button" class="btn_popup_cancel closepopup">닫기</button>
			</div>
		</div>
		<!---// 배송/반품/환불 안내 --->
		
		
		<!-- 상품상세정보 -->
		<div id="goods_content" class="blind">
			<div class="product_head">
				<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
				상품상세정보
			</div>
			<div class="product_info_content">
				${goodsContentVO.content}
			</div>
			<div class="product_detail_area" style="border:none">
				<h2 class="sub_title">상품 필수정보</h2>
				<table class="tProduct_detail">
					<caption>
						<h1 class="blind">상품 상세정보 테이블입니다.</h1>
					</caption>
					<colgroup>
						<col width="50%">
						<col width="*">
					</colgroup>
					<tbody id="tbodyNotify">
					<tr>
						<td colspan="2">						
							<div class="warning_text">							
								해당 내용은 전자상거래 등에서의 상품정보제공 고시에 따라 작성되었습니다.
							</div>
						</td>
					</tr>
					</tbody>
					
				</table>			
			</div>
		</div>
		<!-- // 상품상세정보 -->
		
		
		
		
		
		
		
		
		
		<!---// 03.LAYOUT:CONTENTS --->
	</form>
	<!-- // 모바일버전 -->

	</t:putAttribute>
</t:insertDefinition>