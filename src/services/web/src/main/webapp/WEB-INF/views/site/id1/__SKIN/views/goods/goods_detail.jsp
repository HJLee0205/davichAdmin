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
<t:insertDefinition name="goodsDavichLayout">
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="title">${goodsInfo.data.goodsNm} :: 다비치마켓</t:putAttribute>
	<t:putAttribute name="script">
	<%-- 카카오 모먼트 --%>
    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
    <script type="text/javascript">
          kakaoPixel('59690711162928695').pageView();
          kakaoPixel('59690711162928695').viewContent({
            id: '${goodsInfo.data.goodsNo}'
          });
          kakaoPixel('7385103066531646539').pageView();
		  kakaoPixel('7385103066531646539').viewContent({
			id: '${goodsInfo.data.goodsNo}'
		  });
    </script>
    <%-- // 카카오 모먼트 --%>
     <%-- 텐션DA SCRIPT --%>
    <script>
        ex2cts.push('track', 'product');
    </script>
    <%--// 텐션DA SCRIPT --%>
	<%@ include file="goods_detail_inc.jsp" %>
	<!--- 00.Script --->
    <%@ include file="goods_detail_js.jsp" %>
    <!--- // 00.Script --->
	</t:putAttribute>
	<t:putAttribute name="content">
    <!--- 02.LAYOUT: 상품상세 location --->
    <!--- category header --->
    <!--- navigation --->
    <%@ include file="../category/category_navigation.jsp" %>
    <!---// navigation --->
    <!---// category header --->
    <!---// 02.LAYOUT: 상품상세 location --->

    <!--- 03.LAYOUT: 상품상세 상단 --->
    <!--- product detail top  --->
    <form name="visitForm" id="visitForm">
    	<input type="hidden" name="refererType" value="${refererType}"/>
    	<input type="hidden" name="returnUrl" value="/front/visit/visit-book"/>
    	<input type="hidden" name="goodsNo" id="goodsNo2" value="${goodsInfo.data.goodsNo}">
    	<input type="hidden" name="goodsNoArr" id="goodsNoArr2" value="${goodsInfo.data.goodsNo}">
	</form>
    <div id="product_detail_top">
        <form name="goods_form" id="goods_form">
            <input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
            <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
            <input type="hidden" name="prmtNo" id="prmtNo" value="${promotionInfo.data.prmtNo}">
            <input type="hidden" name="returnUrl" id="returnUrl" value="">
			<input type="hidden" name="exhibitionYn" id="exhibitionYn" value="">            
			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="">
			<input type="hidden" name="refererType" value="${refererType}"/>
			<c:if test="${goodsInfo.data.goodsNo eq 'G2104082005_8744' }">
            <input type="hidden" name="trevuesYn" id="trevuesYn" value="Y">

            </c:if>
            <c:if test="${goodsInfo.data.goodsNo eq 'G2103261158_8727' }">
            <input type="hidden" name="teanseanSampleYn" id="teanseanSampleYn" value="Y">
            </c:if>
            <input type="hidden" name="ch" id="ch" value="${param.ch}">
        <div class="goods_tltle">
            <span>${goodsInfo.data.goodsNm}</span>
                ${goodsInfo.data.iconImgs}
        </div>
        <!--- product photo  --->
        <div id="product_photo">
            <button type="button" class="btn_preview" onclick="javascript:goods_preview('${goodsInfo.data.goodsNo}');">크게보기</button>
            <ul class="goods_view_slider">
                <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                    <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                        <c:if test="${imgDtlList.goodsImgType eq '02'}">
                            <li><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt="" ></li>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </ul>
            <div id="goods_view_s_slider">
                <c:set var="idx" value="0"/>
                <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                    <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                        <c:if test="${imgDtlList.goodsImgType eq '03'}">
                            <a data-slide-index="${idx}" href="javascript:void(0);" onclick="clicked(${idx});"><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt="" width="100px"></a>
                            <c:set var="idx" value="${idx+1}"/>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </div>
            <div class="goods_views_control">
                <button type="button" class="btn_goods_view_prev">이전으로</button>
                <button type="button" class="btn_goods_view_next">다음으로</button>
            </div>
        </div>
        <!---// product photo  --->

        <!--- product information  --->
        <div id="product_information">
            <div class="goods_price">
                <c:if test="${goodsInfo.data.brandNm ne null}">
                <p class="brand">[${goodsInfo.data.brandNm}]</p>
                </c:if>
                <c:if test="${goodsInfo.data.preGoodsYn ne 'Y'}">
	                	<em><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em><span>원</span>
				</c:if>
                <c:choose>
                    <c:when test="${goodsInfo.data.customerPrice gt 0 && salePrice ne goodsInfo.data.customerPrice}">
                        <del><span class="sale_price"><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</del>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${salePrice ne goodsInfo.data.salePrice }">
                        <del><span class="sale_price"><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</del>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                <c:if test="${totalSaleRate>0 and totalSaleRate ne 'NaN'}">
                    <span class="icon_down discount_ratio"><fmt:formatNumber type="NUMBER" value="${totalSaleRate}" pattern="#.#"/></span>%<br>
                </c:if>

                   <%-- <c:choose>
                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'Y'}">
                            <c:if test="${site_info.svmnPvdYn eq 'Y'}">
                                <c:if test="${site_info.svmnPvdRate > 0}">
                                    <span class="view_point">${site_info.svmnPvdRate}% 적립 </span>
                                </c:if>
                            </c:if>
                        </c:when>
                        <c:when test="${goodsInfo.data.goodsSvmnPolicyUseYn eq 'N'}">

                            <fmt:parseNumber var="goodsSvmnAmt" type="number" value="${goodsInfo.data.goodsSvmnAmt}"/>

                            <c:if test="${goodsSvmnAmt> 0}">
                                <span class="view_point">
                                <fmt:formatNumber value="${goodsSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 적립
                                </span>
                            </c:if>

                        </c:when>
                    </c:choose>--%>

                <%-- <c:if test="${fn:length(couponList) > 0}">
                    <a href="javascript:downloadCoupon();"><img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰이미지"></a>
                </c:if> --%>
            </div>
            <!-- 쿠폰적용가 추가 20200625 -->
            <c:if test="${goodsInfo.data.couponApplyAmt < salePrice}">
			<div class="coupon_price">
				<span class="cp_tit">쿠폰 적용가</span>
				<p class="cp_price"><em><fmt:formatNumber value="${goodsInfo.data.couponApplyAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</p>
			</div>
			</c:if>

			<c:if test="${goodsInfo.data.couponApplyAmt >= salePrice and goodsInfo.data.couponBnfCd eq '03' and goodsInfo.data.couponBnfTxt ne null}">
			<div class="coupon_price" style="width:auto;">
				<span class="cp_tit" style="width:auto;">${goodsInfo.data.couponBnfTxt}</span>
			</div>
			</c:if>
			<!--// 쿠폰적용가 추가 20200625 -->

            <c:if test="${goodsInfo.data.prWords ne null}">
            <div class="goods_info">
                <p class="text"> ${goodsInfo.data.prWords }</p>
            </div>
            </c:if>
            <c:if test="${goodsInfo.data.stampYn eq 'Y'}">
                <div class="goods_info">
                    <p class="text">스탬프 적립상품입니다. 제품예약후 방문시 스탬프적립이 가능합니다.</p>
                </div>
            </c:if>
            <div class="goods_plus_info">
                <ul>
                    <%--<li>
                        <span>마켓포인트</span>
                        <c:if test="${pvdSvmnAmt gt 0}">
                            <fmt:formatNumber value="${pvdSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </c:if>
                        (회원등급별 추가 적립)
                    </li>--%>
                    <c:if test="${freebieGoodsList ne null && fn:length(freebieGoodsList) gt 0}">
                        <li><span>사은품</span><button type="button" class="btn_cart_s04" id="btn_view_freebie">사은품 보기</button></li>
                    </c:if>

                        <!-- 배송정보 추가 -->
                        <div class="dds_info_area">
                            <div class="goods_plus_info">
                                <ul>
                                    <li>
                                        <span>수령방법</span>
                                        <c:choose>
                                        <c:when test="${dlvrMehtodCnt ne 0 && dlvrMehtodCnt gt 1}">
                                        <p>
                                            <c:if test="${directVisitRecptYn eq 'Y'}">
                                            <input type="radio" class="order_radio" name="dlvrMethodCd" id="dlvrMethodCd2" value="02">
                                            <label for="dlvrMethodCd2"><span></span>
                                            	<c:choose>
                                            		<c:when test="${navigation[0].ctgNo ne '3' && navigation[0].ctgNo ne '4' && navigation[0].ctgNo ne '5'}">매장픽업</c:when>
													<c:otherwise>방문예약</c:otherwise>
                                            	</c:choose>
                                            </label>
                                            </c:if>
                                            <c:if test="${couriUseYn eq 'Y'}">
                                            <input type="radio" class="order_radio margin" name="dlvrMethodCd" id="dlvrMethodCd1" value="01" >
                                            <label for="dlvrMethodCd1"><span></span>택배</label>
                                            </c:if>
                                        </p>
                                        </c:when>
                                            <c:otherwise>
                                                <p>
                                                    <c:if test="${couriUseYn eq 'Y'}">
                                                        택배
                                                        <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="01">
                                                    </c:if>
                                                    <c:if test="${directVisitRecptYn eq 'Y'}">
                                                    	<c:choose>
		                                            		<c:when test="${navigation[0].ctgNo ne '3' && navigation[0].ctgNo ne '4' && navigation[0].ctgNo ne '5'}">매장픽업</c:when>
															<c:otherwise>방문예약</c:otherwise>
		                                            	</c:choose>
                                                        <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="02">
                                                    </c:if>
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>
                            </div>
                            <c:if test="${directVisitRecptYn eq 'Y'}">
                            <c:if test="${navigation[0].ctgNo ne '3' && navigation[0].ctgNo ne '4' && navigation[0].ctgNo ne '5'}">
                            <div class="shipping_dds">
                                매장픽업
                                <ul class="dot_list">
                                    <li>온라인에서 주문하고 가까운 다비치 매장에서 수령</li>
                                    <li>다비치안경의 전문적인 피팅 서비스</li>
                                    <li>다비치안경 AI GO VCS를 통한 차별화된 비전 컨설팅 시스템</li>
                                </ul>
                            </div>
                            </c:if>
                            </c:if>
                        </div>
                        <!--// 배송정보 추가 -->
                    <%--<li>
                        <span>배송방법</span>
                        <c:choose>
                            <c:when test="${dlvrMehtodCnt ne 0 && dlvrMehtodCnt gt 1}">
                                <div class="select_box28" style="width:200px;display:inline-block">
                                    <c:if test="${couriUseYn eq 'Y'}">
                                    <input type="radio" name="dlvrMethodCd" id="dlvrMethodCd1" class="select_option" value="01" checked>택배
                                   </c:if>
                                    <c:if test="${directVisitRecptYn eq 'Y'}">
                                    <input type="radio" name="dlvrMethodCd" id="dlvrMethodCd2" class="select_option" value="02">매장픽업
                                    </c:if>

                                    &lt;%&ndash;<select class="select_option" name="dlvrMethodCd" id="dlvrMethodCd" title="select option">
                                        <option selected="selected"  value="">선택하세요</option>
                                        <c:if test="${couriUseYn eq 'Y'}">
                                            <option value="01">택배</option>
                                        </c:if>
                                        <c:if test="${directVisitRecptYn eq 'Y'}">
                                            <option value="02">매장픽업</option>
                                        </c:if>
                                    </select>&ndash;%&gt;
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>
                                    <c:if test="${couriUseYn eq 'Y'}">
                                        택배
                                        <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="01">
                                    </c:if>
                                    <c:if test="${directVisitRecptYn eq 'Y'}">
                                        매장픽업
                                        <input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="02">
                                    </c:if>
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </li>--%>

					<!-- 적립금 추가 -->
					<c:set var="goodsSvmnGbCd" value="${goodsInfo.data.goodsSvmnGbCd }"></c:set>
					<%-- 적립예정금 절사 설정 --%>
					<c:set var="svmnTruncStndrdCd" value="1"/>
                    <c:choose>
                        <c:when test="${site_info.svmnTruncStndrdCd eq '1'}">
                            <c:set var="svmnTruncStndrdCd" value="10"/>
                        </c:when>
                        <c:when test="${site_info.svmnTruncStndrdCd eq '2'}">
                            <c:set var="svmnTruncStndrdCd" value="100"/>
                        </c:when>
                    </c:choose>
					<c:choose>
						<c:when test="${goodsInfo.data.goodsSvmnGbCd eq '1' }">
						    <c:set var="goodsSvmnAmt" value="${(salePrice * (goodsInfo.data.goodsSvmnAmt/100))/svmnTruncStndrdCd }"></c:set>
						    <c:set var="goodsSvmnAmt" value="${(goodsSvmnAmt-(goodsSvmnAmt%1))*svmnTruncStndrdCd}"/>
                        </c:when>
						<c:otherwise>
						    <c:set var="goodsSvmnAmt" value="${goodsInfo.data.goodsSvmnAmt }"></c:set>
                        </c:otherwise>
					</c:choose>
					<c:set var="recomPvdRate" value="${salePrice * (goodsInfo.data.recomPvdRate/100) /svmnTruncStndrdCd }"></c:set>
					<c:set var="recomPvdRate" value="${(recomPvdRate-(recomPvdRate%1))*svmnTruncStndrdCd}"/>
					<c:if test="${goodsSvmnAmt > 0 || recomPvdRate > 0 }">
						<li class="d_money_area">
							<div class="d_money_info">
								<span class="tit">적립 마켓포인트 :</span>
								<c:if test="${goodsSvmnAmt eq 0 || recomPvdRate eq 0 }">구매확정시</c:if>
								<c:if test="${goodsSvmnAmt > 0}">구매자 <em><fmt:formatNumber value="${goodsSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</c:if>  
								<c:if test="${recomPvdRate > 0}">
								    <c:if test="${goodsSvmnAmt > 0}">&nbsp;</c:if> 추천인 <em><fmt:formatNumber value="${recomPvdRate}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
                                </c:if>
							</div>
						</li>
					</c:if>
					<!-- 적립금 추가 -->

                    <c:if test="${goodsDlvrAmt eq '0'  && goodsInfo.data.rsvOnlyYn ne 'Y'}">
                        <li>
                            <span>배송비</span>
                            <p>무료</p>
                            <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="01"> <%-- 무료 --%>
                        </li>
                    </c:if>
                    <c:if test="${goodsDlvrAmt ne '0'}">
                            <li id="dlvrPaymentKindCd01">
                                <span>배송비</span>
                                <p>
                                    <fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                    <c:if test="${goodsInfo.data.dlvrSetCd eq '6'}">
                                    <em class="delivery-comment">
                                        (<fmt:formatNumber value="${goodsInfo.data.freeDlvrMinAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시 무료)
                                    </em>
                                    </c:if>
                                </p>
                            </li>
                            <c:choose>
                                <c:when test="${dlvrPaymentKindCdCnt gt 1}">
                                <li id="dlvrPaymentKindCd01">
                                    <span>&nbsp;</span>
                                    <div class="select_box28 add_option">
                                        <select class="select_option" name="dlvrcPaymentCd" id="dlvrcPaymentCd" title="select option">
                                            <option selected="selected" value="">선택하세요</option>
                                            <option value="02">주문시 선결제</option>
                                            <option value="03">수령 후 지불</option>
                                        </select>
                                    </div>
                                </li>
                                </c:when>
                                <c:otherwise>
                                    <li id="dlvrPaymentKindCd01">
                                    <span>&nbsp;</span>
                                        <c:if test="${dlvrPaymentKindCd eq '1'}">
                                            주문시 선결제
                                            <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02">
                                        </c:if>
                                        <c:if test="${dlvrPaymentKindCd eq '2'}">
                                            수령 후 지불
                                            <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="03">
                                        </c:if>
                                    </li>
                                </c:otherwise>								
                            </c:choose>

                        <li id="dlvrPaymentKindCd02" style="display:none">
                            <span>배송비</span>
                            <p>무료</p>
                        </li>
                    </c:if>


                    <c:if test="${goodsInfo.data.rsvOnlyYn ne 'Y'}">
                    <li>
                        <span>배송정보</span>
                        <c:if test="${goodsInfo.data.goodsTypeCd ne '03' and goodsInfo.data.goodsTypeCd ne '04'}">
	                        <p>
	                            평균배송일 : ${goodsInfo.data.dlvrExpectDays}일
	                            <c:if test="${!empty goodsInfo.data.txLimitCndt}">
	                                <br>구매제한조건 : ${goodsInfo.data.txLimitCndt}
	                            </c:if>
	                            <c:if test="${goodsInfo.data.dlvrSetCd eq '1' && seller_info.defaultDlvrcTypeCd eq '3'}">
	                                <br>주문금액 <fmt:formatNumber value="${seller_info.defaultDlvrMinAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 무료배송
	                            </c:if>
	                            <c:if test="${goodsInfo.data.dlvrSetCd eq '4'}">
	                                <br>상품 ${goodsInfo.data.packMaxUnit}개당 배송비 <fmt:formatNumber value="${goodsInfo.data.packUnitDlvrc}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
	                            </c:if>
	                        </p>
	                    </c:if>
                        <c:if test="${goodsInfo.data.goodsTypeCd eq '03' or goodsInfo.data.goodsTypeCd eq '04'}">
	                        <c:if test="${!empty goodsInfo.data.txLimitCndt}">
                            <p>${goodsInfo.data.txLimitCndt}</p>
                            </c:if>
                            <c:if test="${empty goodsInfo.data.txLimitCndt}">
                            <p>예약매장 제품 보유시 당일 픽업 가능</p>
	                        <br>
	                        <p style="margin-left: 115px;">※ 주문해야 할 경우 ${goodsInfo.data.dlvrExpectDays}일 소요 (평일 기준)</p>
                            </c:if>
                        </c:if>
                    </li>
                    </c:if>

                    <c:if test="${goodsStatus eq '01' || (goodsStatus eq '02' and goodsInfo.data.rsvBuyYn != null and goodsInfo.data.rsvBuyYn eq 'Y')}">
                        <!--- 상품 옵션 없을 경우 --->
                        <c:if test="${goodsInfo.data.multiOptYn eq 'N'}">
                            <input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
                            <input type="hidden" name="itemPriceArr" id="itemPriceArr" class="itemPriceArr" value="${salePrice}">
                            <input type="hidden" name="stockQttArr" id="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
                            <input type="hidden" name="itemArr" id="itemArr" class="itemArr" value="">
                            <div class="goods_plus_info" style="border-bottom:1px solid #000; <c:if test="${goodsInfo.data.preGoodsYn eq 'Y' }">display:none;</c:if>">
                                <ul>
                                    <li>
                                        <span>구매수량</span>
                                        <div class="select_box28" style="width:55px;display:inline-block">
                                            <select class="select_option input_goods_no" name="buyQttArr" id="input_goods_no" title="select option">
                                                <c:forEach var="cnt" begin="1" end="99">
                                                    <option value="${cnt}">${cnt}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </c:if>
                        <!---// 상품 옵션 없을 경우 --->
                    </c:if>

                    <c:if test="${goodsInfo.data.multiOptYn eq 'Y' || goodsInfo.data.addOptUseYn eq 'Y'}">
                        <!--- 상품 옵션 있을 경우 --->
                        <c:if test="${!empty goodsInfo.data.goodsOptionList && goodsInfo.data.multiOptYn eq 'Y'}">
                            <c:forEach var="optionList" items="${goodsInfo.data.goodsOptionList}" varStatus="status">
                        <li>
                            <span>${optionList.optNm}</span>
                            <p>
                                <select class="select_options" id="goods_option_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}" data-opt-nm="${optionList.optNm}">
                                    <option selected="selected">선택하세요</option>
                                </select>
                            </p>
                        </li>
                        </c:forEach>
                        </c:if>
                        <!---// 상품 옵션 있을 경우 --->
                        <!--- 상품 추가구성 있을 경우 --->
                        <c:if test="${!empty goodsInfo.data.goodsAddOptionList && goodsInfo.data.addOptUseYn eq 'Y'}">
                            <li class="options_line"><span class="stit_options">추가 구성</span></li>
                            <c:forEach var="addOptionList" items="${goodsInfo.data.goodsAddOptionList}" varStatus="status">
                            <li>
                                <span>${addOptionList.addOptNm}</span>
                                <div class="select_box28 add_option">
                                    <select class="select_option goods_addOption" title="select option" data-required-yn="${addOptionList.requiredYn}" data-add-opt-no="${addOptionList.addOptNo}" data-add-opt-nm="${addOptionList.addOptNm}">
                                        <option selected="selected" value="">선택하세요</option>
                                        <c:forEach var="addOptionDtlList" items="${addOptionList.addOptionValueList}" varStatus="status">
                                            <option value="${addOptionDtlList.addOptDtlSeq}" data-add-opt-amt="${addOptionDtlList.addOptAmt}"
                                                    data-add-opt-amt-chg-cd="${addOptionDtlList.addOptAmtChgCd}" data-add-opt-value="${addOptionDtlList.addOptValue}"
                                                    data-add-opt-dtl-seq="${addOptionDtlList.addOptDtlSeq}" data-add-opt-ver="${addOptionDtlList.optVer}">
                                                <c:choose>
                                                    <c:when test="${addOptionDtlList.addOptAmtChgCd eq '1'}">
                                                    ${addOptionDtlList.addOptValue} (<fmt:formatNumber value="${addOptionDtlList.addOptAmt}" type="number"/>원)
                                                    </c:when>
                                                    <c:otherwise>
                                                    ${addOptionDtlList.addOptValue} (-<fmt:formatNumber value="${addOptionDtlList.addOptAmt}" type="number"/>원)
                                                    </c:otherwise>
                                                </c:choose>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </li>
                        </c:forEach>
                        </c:if>
                        <!---// 상품 추가구성 있을 경우 --->
                    </c:if>

                </ul>
            </div>
            <!-- 옵션 -->

            <!---// 상품 옵션 있을 경우 --->


            <!--옵션 레이어 영역 //-->
            <div class="goods_options">
                <ul class="goods_plus_info02"></ul>
            </div>
            <!--// 옵션 -->
            
            <%-- <div class="plus_price">
                <span class="title">합계</span>
                <span id="totalPriceText" class="" style="float: right;font-size: 30px;font-weight: 700;font-family: 'Century Gothic';"> 
	                <fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
	                <span class="" style="font-size: 20px;font-weight: 400;margin-left: 5px;font-family: 'Malgun Gothic','맑은 고딕', Arial, Helvetica, sans-serif;">원</span>
                </span>
            </div> --%>
            
            <!-- 입고일정표현 (조건 : 판매상태 품절 & 예약구매 Y & 입고예정일정 텍스트) -->
            <c:if test="${goodsStatus eq '02' and goodsInfo.data.rsvBuyYn != null and goodsInfo.data.rsvBuyYn eq 'Y' and goodsInfo.data.inwareScdSch ne ''}">
            <div style="font-size: 14px;padding: 13px 10px 10px 53px;border-bottom: 1px solid #ddd;">
            	${goodsInfo.data.inwareScdSch}
            </div>
            </c:if>
            <!-- 입고일정표현 -->
            
            <!-- 190415 개발적용 -->
            <div class="plus_price" <c:if test="${goodsInfo.data.preGoodsYn eq 'Y' }">style="display:none;"</c:if>>
                <span class="title">합계</span>
                <div class="total_price"> 
					<!-- 세일적용 -->
					<c:if test="${totalSaleRate>0 and totalSaleRate ne 'NaN'}">
						<p class="sale"><fmt:formatNumber type="NUMBER" value="${totalSaleRate}" pattern="#.#"/>%
							<c:choose>
								<c:when test="${goodsInfo.data.customerPrice gt 0 && salePrice ne goodsInfo.data.customerPrice}">
									<del><span id="totalCustomerPriceText"><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</del>
								</c:when>
								<c:otherwise>
		
									<c:if test="${salePrice ne goodsInfo.data.salePrice }">
                                        <del ><span id="totalCustomerPriceText"><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원</del>
									</c:if>
								</c:otherwise>
							</c:choose>
						</p>
					</c:if>

					<em id="totalPriceText"><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em><span class="price_won">원</span>
					<input type="hidden" name="totalPrice" id="totalPrice" value="0">

					<!-- 쿠폰적용가 -->
					<c:set var="bestCouponAmt" value="${salePrice }"/> <!-- 쿠폰적용 최대할인가 -->
					<c:set var="couponAmt" value="0"/> <!-- 쿠폰적용 할인가 -->
					<c:forEach var="couponList" items="${couponList}" varStatus="status">
		        		<c:set var="couponBnfCd" value="${couponList.couponBnfCd}"/> <!-- 쿠폰 혜택 코드(01:할인율, 02:할인금액) -->
		        		<c:set var="couponBnfValue" value="${couponList.couponBnfValue}"/> <!-- 쿠폰 혜택 값 -->
		        		<c:set var="couponBnfDcAmt" value="${couponList.couponBnfDcAmt}"/> <!-- 쿠폰 최대 할인 금액 -->
		        		<c:set var="couponUseLimitAmt" value="${couponList.couponUseLimitAmt}"/> <!-- 사용 제한 금액 -->
		
						<c:choose>
							<c:when test="${couponBnfCd eq '01' }">	<!-- 할인율 적용 쿠폰 -->
								<c:choose>
			        				<c:when test="${salePrice - (salePrice * (1-(couponBnfValue*1/100))) <= couponBnfDcAmt }">	<!-- 최대할인금액이 쿠폰할인가보다 클때 = 쿠폰할인가 적용 -->
			        					<c:if test="${salePrice >= couponUseLimitAmt }">	<!-- 구매합계가 사용제한금액보다 큰지 확인 -->
			        						<c:set var="couponAmt" value="${salePrice * (1-(couponBnfValue*1/100)) }"/>	<!-- 구매합계에서 할인율만큼 할인 -->
			        					</c:if>
			        				</c:when>
			        				<c:otherwise>	<!-- 최대할인금액이 쿠폰할인가보다 작을때 = 최대할인금액 적용 -->
			        					<c:if test="${salePrice > couponUseLimitAmt }">	<!-- 구매합계가 사용제한금액보다 큰지 확인 -->
			        						<c:set var="couponAmt" value="${salePrice - couponBnfDcAmt }"/>	<!-- 구매합계에서 최대할인금액만큼 할인 -->
			        					</c:if>
			        				</c:otherwise>
			        			</c:choose>
							</c:when>
							<c:otherwise>
								<c:if test="${salePrice >= couponUseLimitAmt }">	<!-- 구매합계가 사용제한금액보다 큰지 확인 -->
	        						<c:set var="couponAmt" value="${salePrice - couponBnfDcAmt }"/>	<!-- 구매합계에서 할인금액만큼 할인 -->
	        					</c:if>
							</c:otherwise>
						</c:choose>

		        		<c:if test="${bestCouponAmt > couponAmt }">	<!-- 현재 쿠폰의 할인가가 최대 할인가인지 비교 -->
		        			<c:set var="bestCouponAmt" value="${couponAmt }"/>
		        		</c:if>
		        	</c:forEach>
		        	
					<%-- <p class="sale_price" <c:if test="${empty(bestCouponAmt) || bestCouponAmt <= 0 || fn:length(couponList) < 1}">style="display:none;"</c:if> > 
						<em id="couponSalePriceText"><fmt:formatNumber value="${bestCouponAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>
						<span class="price_won">원</span>
						<span class="sale_coupon">쿠폰할인가</span>
					</p> --%>
				</div>

				<!-- 쿠폰다운위치변경 -->
				<c:if test="${fn:length(couponList) > 0}">
					<a href="javascript:downloadCoupon();" class="coupon_img"><img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰받기"></a>
				</c:if>
				<!--// 쿠폰다운위치변경 -->
            </div>

			<!-- 큐레이팅 -->
			<c:choose>
				<c:when test="${navigation[0].ctgNo eq '1' || navigation[0].ctgNo eq '3'}">
					<a href="/front/vision2/vision-check"><div class="curating_area">내 눈에 딱 맞는 <em>안경렌즈 큐레이팅 서비스 이용하기</em></div></a><!-- 안경테/안경렌즈 -->
				</c:when>
				<c:when test="${navigation[0].ctgNo eq '2'}">
					<a href="javascript:Dmall.LayerUtil.alert('준비중인 서비스입니다.');"><div class="curating_area">내 눈에 딱 맞는 <em>렌즈 큐레이팅 서비스 이용하기</em></div></a><!-- 선글라스 -->
				</c:when>
				<c:when test="${navigation[0].ctgNo eq '4'}">
					<a href="/front/vision2/vision-check?lensType=C"><div class="curating_area">내 눈에 딱 맞는 <em>콘택트렌즈 큐레이팅 서비스 이용하기</em></div></a><!-- 콘택트렌즈 -->
				</c:when>
			</c:choose>
			<!-- 큐레이팅 -->
            
            <div class="order_btn_area">
                <c:if test="${goodsStatus eq '01'}">
                    <button type="button" class="btn_favorite_go" id="btn_favorite_go">좋아요</button>
                    
<%--                <button type="button" class="btn_checkout_go" id="btn_pre_rsv_go">사전예약 ${prmtDcValue}%할인</button> --%>
                    <c:choose>
                        <c:when test="${promotionInfo.data.prmtTypeCd eq '05'}">
                            <%--사전예약--%>
                            <button type="button" class="btn_book_go" id="btn_pre_rsv_go" style="width:346px;">사전예약
                            <c:if test="${prmtDcValue} > 0">
                            ${prmtDcValue}
                                <c:if test="${promotionInfo.data.prmtDcGbCd eq '01'}">
                                    %
                                </c:if>
                                <c:if test="${promotionInfo.data.prmtDcGbCd eq '02'}">
                                    원
                                </c:if>
                            할인</c:if></button>
                        </c:when>
                        <c:otherwise>
                            <%--일반상품--%>
                            <c:if test="${goodsInfo.data.rsvOnlyYn ne 'Y'}">
                                <button type="button" class="btn_cart_go" id="btn_cart_go" onclick="return gtag_report_conversion('http://www.davichmarket.com/front/basket/basket-insert')" >장바구니</button>
                                <%-- <c:choose>
                                    <c:when test="${promotionInfo.data.prmtNo eq '65'}">
                                        <button type="button" class="btn_checkout_go" id="btn_checkout_go">예약구매</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn_checkout_go" id="btn_checkout_go">바로구매</button>
                                    </c:otherwise>
                                </c:choose> --%>
                                <button type="button" class="btn_checkout_go" id="btn_checkout_go">바로구매</button>
                            </c:if>
                            <%--예약전용--%>
                            <c:if test="${goodsInfo.data.rsvOnlyYn eq 'Y'}">
                                <!-- <button type="button" class="btn_cart_go" id="btn_cart_go" >장바구니</button> -->
                                <button type="button" class="btn_book_go" id="btn_rsv_go">예약하기</button>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${goodsStatus eq '02'}">
                	<button type="button" class="btn_favorite_go" id="btn_favorite_go">관심상품</button>
                	<c:choose>
	                	<c:when test="${goodsInfo.data.rsvBuyYn != null and goodsInfo.data.rsvBuyYn eq 'Y'}">
	                		<button type="button" class="btn_cart_go" id="btn_cart_go" onclick="return gtag_report_conversion('http://www.davichmarket.com/front/basket/basket-insert')" >장바구니</button>
	                		<button type="button" class="btn_checkout_go" id="btn_checkout_go">예약구매</button>
	                	</c:when>
	                	<c:otherwise>
		                    <button type="button" class="btn_soldout" disabled>품절</button>
		                    <c:if test="${user.session.memberNo ne null }">
		                        <button type="button" class="btn_checkout_go" id="btn_alarm_view">재입고알림</button>
		                    </c:if>
	                    </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${goodsStatus eq '03'}">
                    <button type="button" class="btn_checkout_go">판매대기</button>
                </c:if>
                <c:if test="${goodsStatus eq '04'}">
                    <button type="button" class="btn_checkout_go">판매중지</button>
                </c:if>
            </div>
            <!-- naver pay -->
            <div>
                <%--<img src="${_SKIN_IMG_PATH}/product/naver_pay.gif" alt="">--%>
            </div>
            <!--// naver pay -->
        </div>
        <!---// product information  --->
        </form>
    </div>
    <!---// 03.LAYOUT: 상품상세 상단 --->

    <!--- 04.LAYOUT: 관련상품/비슷한 상품 --->
        <c:if test="${goodsInfo.data.relateGoodsApplyTypeCd ne '3' &&  goodsInfo.data.relateGoodsApplyTypeCd ne null}">
            <%@ include file="goods_with_item.jsp" %>
        </c:if>
    <!---// 04.LAYOUT: 관련상품/비슷한 상품 --->

    <!-- banner area -->
    <div class="sub_banner_area">
        <c:choose>
            <c:when test="${goods_top_banner.resultList ne null && fn:length(goods_top_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${goods_top_banner.resultList}" varStatus="status">
                    <c:if test="${empty resultModel.linkUrl}">
                        <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="" width="940px;" height="440px;">
                    </c:if>
                    <c:if test="${!empty resultModel.linkUrl}">
                        <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt=""></a>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <%--<li><img src="${_SKIN_IMG_PATH}/main/main_visual01.jpg" alt=""></li>--%>
            </c:otherwise>
        </c:choose>
    </div>
    <!--// banner area -->

    <!--- 05.LAYOUT: 상품상세하단 --->
    <div id="product_bottom">
        <ul class="skin_tabs">
            <li class="active" rel="tab1" style="width:24.9%">상세설명</li>
            <%--<li rel="tab2" style="width:20%">구매가이드</li>--%>
            <li rel="tab2" style="width:24.8%" id="review_tab">상품후기<span id="review_count">${goodsBbsInfo.data.reviewCount}</span></li>
            <li rel="tab3" style="width:24.8%" id="question_tab">상품문의<span id="question_count">${goodsBbsInfo.data.qeustionCount}</span></li>
            <li rel="tab4" style="width:24.9%">배송/반품/환불 </li>
        </ul>

        <!--- tab01: 상품상세정보 --->
        <div class="skin_tab_content" id="tab1">
            <div class="product_contents" id="product_contents">${goodsContentVO.content}</div>
            <div id="notifyDiv"></div>
        </div>
        <!--- tab01: 상품상세정보 --->

        <!--- tab02: 구매가이드 --->
       <%-- <div class="skin_tab_content" id="tab2">
            <div class="product_contents">
                구매가이드
            </div>
        </div>--%>
        <!--- tab02: 구매가이드 --->

        <!--- tab03: 상품후기 --->
        <div class="skin_tab_content" id="tab2"></div>
        <!---// tab03: 상품후기 --->

        <!--- tab03: 상품문의 --->
        <div class="skin_tab_content" id="tab3"></div>
        <!---// tab03: 상품문의 --->

        <!--- tab04: 배송/반품/환불  --->
        <div class="skin_tab_content" id="tab4">
        	<h3 class="product_stit">배송정보</h3>
        	<div><p><span style="font-size: 13.3333px;">고객님이 무통장 입금으로 주문하신 경우에는 입금하신 날로부터, 신용카드로 구매하신 경우에는 구매하신 날로부터 2-3일 이내에(최장 7일이내) 입력하신 배송처로 주문상품이 도착하게 됩니다.&nbsp;</span><br style="font-size: 13.3333px;"><span style="font-size: 13.3333px;">주문하신 상품에 따라 배송기간이 조금 상이할 수 있으니 자세한 사항은 상품 상세 페이지에 명시 되어있는 배송관련 내용을 참조해주시기 바랍니다.&nbsp;</span><br style="font-size: 13.3333px;"><span style="font-size: 13.3333px;">산간벽지나 도서지방은 별도의 추가금액을 지불하셔야 하는 경우가 있습니다.</span><br></p><div><span style="font-size: 13.3333px;"><br></span></div><p><br></p></div>
        	<h3 class="product_stit">반품/교환안내</h3>
        	<div><p>다비치의 제품은 교환 및 반품이 가능합니다.</p><br><table class="agree_tb"><colgroup><col style="width: 35%;"><col style="width: 35%;"><col></colgroup><thead><tr><th>사유</th><th>반송배송비</th><th>비고</th></tr></thead><tbody><tr><td>변심 교환/반품</td><td>고객부담(선불)</td><td><p>5,000원 계좌이체 or 차감환불(왕복 택배비)</p></td></tr><tr><td>물품불량 다른모델교환(=변심교환)</td><td>고객부담 (선불)</td><td><p>편도 2,500원 계좌이체</p></td></tr><tr><td>물품불량 동일모델교환</td><td>무료(착불)</td><td>무료교환</td></tr><tr><td>물품불량 반품</td><td>무료(착불)</td><td>물품확인 후 즉시 환불</td></tr></tbody></table><p><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">교환/반품시에는 반드시 사전에 고객센터 혹은 교환/반품 게시판으로 신청해주시기 바랍니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">상품 불량을 사유로 다른 모델로 교환하시는 경우에는 단순변심 교환과 동일하게 처리됩니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">반드시 배송은 로젠택배 (1588-9988)를 이용해주시기 바랍니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">사전 연락 없이 타 택배사를 이용하여 착불로 보내시면 반송되오니 양해 부탁드립니다.</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">다음의 경우 교환 및 반품이 불가하니 주의해주세요.</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">1. 상품의 사용/하자 여부와 관계없이 수령 후 7일이 지난 경우</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">2. 상품에 부착된 사용방지택을 제거하거나 다시 붙인 경우</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">3. 상품의 보증서, 케이스, 포장비닐, 사은품 등 구성품이 훼손 또는 분실된 경우</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">4. 개인피팅이 가해졌거나 렌즈 작업이 된 경우</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">5. 변심으로 이미 1회 교환한 경우</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">다음의 경우 불량이 아닙니다.</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">1. 제조, 유통시 발생하는 미세 스크레치</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">2. 안경 데모 렌즈의 스크레치</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">3. 피팅 상태의 미비</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">※ 참고해주세요! ※</b><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">온라인으로 구매하신 <strong style="color:red;">제품 중 택배(자택 수령)은</strong> 오프라인 매장에서 교환/반품하실 수 없습니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">고객센터 혹은 교환/반품 게시판으로 신청 후, 꼭 택배로 보내주시기 부탁드립니다.</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;"><strong style="color:red;">DDS(매장픽업)으로 수령하신</strong> 고객님의 경우 제품 불량으로 교환/환불은 픽업하신 매장에서만 가능합니다.</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">깊이가 다른 A/S</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">다비치에서 구입하신 상품을 착용하시다가 불편함이 생기시면 언제든지 찾아주세요.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">10년 경력의 전문가가 정성을 다해 상담과 수리를 진행해 드립니다.</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">※ 참고해주세요! ※</b><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">A/S 안내</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">1. 다비치 마켓에서 구매하신 상품에 대해 A/S가 가능합니다. (매장 구매 제품의 경우 구매하신 매장으로 의뢰)</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">2. <strong style="color:red;">제품구매 후 보증기간(6개월~1년)</strong> 이 내 불량 건에 대해서는 무상수리 진행되며, 보증기간 이 내 사용 중 발생된 파손 등 A/S 발생 건의 경우 수리비가 발생 됩니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">3. 구매 후 1년이 경과된 제품에 대해서는 제품의 상태에 따라 수리비가 발생 됩니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">4. A/S는 코팅, 도금 등 제품을 새로 만드는 공정과 유사하므로 부득이하게 <strong style="color:red;">A/S기간이 최소 일주일에서 30일까지 소요될</strong> 수 있습니다. 양해 부탁 드립니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">5. 부품 교체의 경우 수리비용이 예상보다 더 발생 할 수 있으며, 교체 외 수리비 청구는 수리업체의 수리 실비로 청구됩니다. 또한, A/S접수 시 브랜드와 제품에 따라 부득이하게 택배비가 발생 할 수 있습니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">6. 도금이나 코팅 공정을 거치는 경우 큐빅 장식의 제거 후 제거 후 재 부착이 필요할 수 있으며, 기존의 스크린(브랜드,제품모델명 등) 이 지워질 수 있습니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">7. 도색, 도금 등 작업이 필요한 경우 기존의 색상과 100% 똑같은 색상이 나오지 않을 수 있습니다</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">8. 뿔테 안경의 경우 A/S가 불가능 할 수 있습니다. (부품 교체만 가능)</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><b style="font-size: 13.33px;">* 수리진행 과정 안내 (3주소요)</b><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">접수 → 업체도착/제품해체 → 도금박리 → 용접수리 → 연마 → 1차 베이스 도금 → 2차 외부코팅 → 에폭시 or 레이저 가공 → 조립 → 택배발송</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"></p></div>
        	<h3 class="product_stit">반품/환불안내</h3>
        	<div><p><span style="font-size: 13.33px;">회사는 소비자의 보호를 위해서 규정한 제반 법규를 준수합니다.&nbsp;</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">주문 취소는 미 결제 상태인 경우, 고객님이 직접 취소하실 수 있습니다.&nbsp;</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">결제 후 취소는 저희 고객센터<strong>(070-7433-0137, 070-7405-1003)</strong>로 문의해 주시기 바랍니다.&nbsp;</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">무통장 입금의 경우 일정기간 동안 송금을 하지 않으면 자동 주문 취소가 되고, 구매자가 원하는 경우 인터넷에서 바로 취소 가능하며, 송금을 하신 경우에는 요청에 따라 환불 처리 해드립니다.&nbsp;</span><br style="font-size: 13.33px;"><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">신용카드로 결제하신 경우는 신용카드 승인을 취소하여 결제 대금이 청구되지 않게 합니다. 이때 승인 취소는 카드사에 따라 2-3일 정도 소요될 수 있습니다.</span><br style="font-size: 13.33px;"><span style="font-size: 13.33px;">(단, 신용카드 결제일자에 맞추어 대금이 청구 될수 있으며, 이 경우 익월 신용카드 대금 청구시 카드사에서 환급처리 됩니다.)</span><br></p><br><h3 class="product_stit">반품 주소지 (※ 입점사 상품은 개별 상품페이지 참조)</h3><div>(41494) 대구 북구 노원동3가 1205-20 3층</div><p><br></p></div>

        </div>
        <!---// tab04: 배송/반품/환불  --->
    </div>
    <!---// 05.LAYOUT: 상품상세하단 --->

    <!-- banner area -->
    <div class="sub_banner_area">
        <c:choose>
            <c:when test="${goods_footer_banner.resultList ne null && fn:length(goods_footer_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${goods_footer_banner.resultList}" varStatus="status">
                    <c:if test="${empty resultModel.linkUrl}">
                        <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="" width="940px;" height="440px;">
                    </c:if>
                    <c:if test="${!empty resultModel.linkUrl}">
                        <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt=""></a>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <%--<li><img src="${_SKIN_IMG_PATH}/main/main_visual01.jpg" alt=""></li>--%>
            </c:otherwise>
        </c:choose>
    </div>
    <!--// banner area -->

    <!--- popup 장바구니 등록성공 --->
    <div class="alert_body pop_front" id="success_basket" style="display: none;">
        <button type="button" class="btn_alert_close"><img src="/front/img/common/btn_close_popup02.png" alt="팝업창닫기"></button>
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
    <!---// popup 로그인 여부 --->

    <!--- popup 재입고 알림 --->
    <div id="div_restock"></div>
    <!---// popup 재입고 알림 --->

    <!--- popup 사은품 보기 --->
    <c:if test="${freebieGoodsList ne null && fn:length(freebieGoodsList) gt 0}">
	<div class="popup_present_event pop_front" id="freebie_pop" style="display: none;">
		<div class="popup_header">
			<h1 class="popup_tit">사은품 이벤트</h1>
			<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>
		<div class="popup_content">
			<div class="pop_comment">
			<c:if test="${freebieGoodsList[0].freebieEventAmt > 0}">
			* 상품을<b><fmt:formatNumber value="${freebieGoodsList[0].freebieEventAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></b>원 이상 주문하시면 아래의 사은품을 증정합니다.
            </c:if>
            </div>
			<div class="popup_present_event_scroll">
				<ul class="popup_present_event_list">
                    <c:forEach var="freebieGoodsList" items="${freebieGoodsList}" varStatus="status3">
					<li>
						<span class="present_img">
						<img src="${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1=${freebieGoodsList.imgPath}_${freebieGoodsList.imgNm}" alt="">
						</span>
						<p>
						    <em class="present_tit">${freebieGoodsList.freebieNm}</em>${freebieGoodsList.simpleDscrt}
                        </p>
					</li><!-- 여기가 두번 더나와야합니다. 세번까지 -->
                    </c:forEach>
				</ul>
			</div>
			<div class="popup_btn_area">
				<button type="button" class="btn_popup_cancel">닫기</button>
			</div><br><br><br>
		</div><!-- //popup_content -->
	</div><!-- //popup_present_event -->
    </c:if>

    <!--- popup 사은품 보기 --->
    
    <!-- popup 쿠폰 보기 -->
	<div class="popup_coupon_select" id="coupon_print_popup" style="display:none;width:511px">
		<div class="popup_header">
			<h1 class="popup_tit">쿠폰정보</h1>
			<button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>
		<div class="popup_content"> 
			<div id="print_area">
				<div class="popup_coupon_area">
					<div class="coupon" id="print_div">
						<p class="price" id="print_bnfValue"></p>
						<p class="text" id="print_useLimitAmt"></p>
					</div>
					<div class="barcode">
						<div id="bcTarget_coupon" style="margin: 0 auto"></div>
						<p class="member_no"><span id="cp_issue_no" style="font-size:20px;"></span></p>
					</div>
				</div>
				<div class="popup_coupon_outline">
					<table class="tCart_Insert">
						<caption>쿠폰 정보 내용입니다.</caption>
						<colgroup>
							<col style="width:100px">
							<col style="width:">
						</colgroup>
						<tbody>
							<tr>
								<th>이벤트명</th>
								<td id="print_couponNm">0000-00-00</td>
							</tr>
							<tr>
								<th>사용기간</th>
								<td id="print_usePeriod">0000-00-00 00:00 ~ 0000-00-00 00:00</td>
							</tr>
							<tr>
								<th>사용</th>
								<td>전국 다비치매장 (일부매장 제외)</td>
							</tr>
						</tbody>
					</table>
				</div>					
				<div class="popup_bottom_coupon">
					<p class="tit">※  쿠폰사용안내</p>
					<div class="text_area" id="print_dscrt">
					</div>
				</div>				
				<div class="popup_btn_area print">
		            <button type="button" class="btn_go_okay" onClick="btn_img_print();"><i></i>프린트</button>
		        </div>
			</div>
		</div>
	</div>
	<!--// popup 쿠폰 보기 -->
	
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
    <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "SG" />
    <%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>
	</t:putAttribute>
</t:insertDefinition>