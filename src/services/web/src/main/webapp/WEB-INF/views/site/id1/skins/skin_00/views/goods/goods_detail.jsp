<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
<t:insertDefinition name="goodsLayout">
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="title">상품상세</t:putAttribute>
	<t:putAttribute name="content">
    <div class="contents">
    <!--- 00.Script --->
    <%@ include file="/WEB-INF/views/goods/goods_detail_js.jsp" %>
    <%@ include file="/WEB-INF/views/goods/goods_detail_inc.jsp" %>
    <!--- // 00.Script --->
	<!--- 01.LAYOUT: 상품상세 location --->
    <!--- category header 카테고리 location과 동일 --->
    <div id="category_header">
        <div id="category_location" style="background:none;">
            <a href="javascript:history.back();" class="skin_navi">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a>
            <c:forEach var="navigationList" items="${navigation}" varStatus="status">
            <div class="category_selectBox select_box" style="width:120px;">
                <label for="navigation_combo_${status.index}">[[1depth]]</label>
                <select class="select_option" title="select option" id="navigation_combo_${status.index}">
                    <c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
                        <option value="${ctgList1.ctgNo}" <c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">selected</c:if>>${ctgList1.ctgNm}</option>
                    </c:forEach>
                </select>
            </div>
            </c:forEach>
        </div>
    </div>
    <!---// category header --->
    <!---// 01.LAYOUT: 상품상세 location --->

    <!--- 02.LAYOUT: 상품상세 상단 --->
    <!--- product detail top  --->
    <div id="product_detail_top">
    <form name="goods_form" id="goods_form">
        <input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
        <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
        <input type="hidden" name="prmtNo" id="prmtNo" value="${promotionInfo.data.prmtNo}">
        <!--- product photo  --->
        <div id="product_photo">
            <ul class="goods_view_slider">
            <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                    <c:if test="${imgDtlList.goodsImgType eq '02'}">
                    <li><img src="/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></li>
                    </c:if>
                </c:forEach>
            </c:forEach>
            </ul>
            <div id="goods_view_s_slider">
            <c:set var="idx" value="0"/>
            <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                    <c:if test="${imgDtlList.goodsImgType eq '03'}">
                    <a data-slide-index="${idx}" href="javascript:void(0);" onclick="clicked(${idx});"><img src="/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></a>
                    <c:set var="idx" value="${idx+1}"/>
                    </c:if>
                </c:forEach>
            </c:forEach>
            </div>
        </div>
        <!---// product photo  --->

        <!--- product information  --->
        <div id="product_information">
            <div class="goods_plus_tltle" style="position:relative;">
                ${goodsInfo.data.goodsNo}
                <p class="goods_plus_tltle_text">
                    <span>${goodsInfo.data.goodsNm}</span>
                </p>
                <c:if test="${site_info.contsUseYn eq 'Y'}">
                <div class="goods_plus_tltle_sns">
                    <a href="javascript:jsShareKastory();" class="floatR" style="margin-left:3px">
                        <img src="${_SKIN_IMG_PATH}/product/icon_sns_kakao_s.gif" alt="카카오톡">
                    </a>
                    <a href="javascript:jsShareFacebook();" class="floatR">
                        <img src="${_SKIN_IMG_PATH}/product/icon_sns_facebook_s.gif" alt="페이스북">
                    </a>
                </div>
                </c:if>
                ${goodsInfo.data.prWords}
            </div>

            <div class="goods_plus_coupon">
                <c:if test="${fn:length(couponList) > 0}">
                <a href="javascript:downloadCoupon();"><img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰이미지"></a>
                </c:if>
                <div class="goods_plus_coupon_price">
                    <c:choose>
                        <c:when test="${goodsInfo.data.customerPrice gt 0 }">
                        <del><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>
                        </c:when>
                        <c:otherwise>
                        <del><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>
                        </c:otherwise>
                    </c:choose>
                    <fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                    <span>
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
            <div class="goods_plus_info">
                <ul>
                    <li>
                        <span>브랜드</span>
                        ${goodsInfo.data.brandNm}
                    </li>
                    <li>
                        <span>마켓포인트</span>
                        <c:if test="${pvdSvmnAmt gt 0}">
                        <fmt:formatNumber value="${pvdSvmnAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </c:if>
                        (회원등급별 추가 적립)
                    </li>
                    <c:if test="${freebieGoodsList ne null && fn:length(freebieGoodsList) gt 0}">
                    <li><span>사은품</span><button type="button" class="btn_cart_s04" id="btn_view_freebie">사은품 보기</button></li>
                    </c:if>
                </ul>
            </div>

            <div class="goods_plus_info">
                <ul>
                    <li>
                        <span>배송방법</span>
                        <c:choose>
                            <c:when test="${dlvrMehtodCnt ne 0 && dlvrMehtodCnt gt 1}">
                                <div class="select_box28" style="width:200px;display:inline-block">
                                    <label for="select_option">(필수) 선택하세요</label>
                                    <select class="select_option" name="dlvrMethodCd" id="dlvrMethodCd" title="select option">
                                        <option selected="selected"  value="">(필수) 선택하세요</option>
                                        <c:if test="${couriUseYn eq 'Y'}">
                                        <option value="01">택배</option>
                                        </c:if>
                                        <c:if test="${directVisitRecptYn eq 'Y'}">
                                        <option value="02">매장픽업</option>
                                        </c:if>
                                    </select>
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
                    </li>
                    <c:if test="${goodsDlvrAmt eq '0' }">
                        <li>
                            <span>배송비</span>
                            <p>무료</p>
                            <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="01"> <%-- 무료 --%>
                        </li>
                    </c:if>
                    <c:if test="${goodsDlvrAmt ne '0' }">
                        <li id="dlvrPaymentKindCd01">
                            <span>배송비</span>
                            <c:choose>
                                <c:when test="${dlvrPaymentKindCdCnt gt 1}">
                                <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                                    <label for="select_option">(필수) 선택하세요</label>
                                    <select class="select_option" name="dlvrcPaymentCd" id="dlvrcPaymentCd" title="select option">
                                        <option selected="selected" value="">(필수) 선택하세요</option>
                                        <option value="02">주문시 선결제</option>
                                        <option value="03">수령 후 지불</option>
                                    </select>
                                </div>
                                </c:when>
                                <c:otherwise>
                                <p>
                                    <c:if test="${dlvrPaymentKindCd eq '1'}">
                                    주문시 선결제
                                    <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02">
                                    </c:if>
                                    <c:if test="${dlvrPaymentKindCd eq '2'}">
                                    수령 후 지불
                                    <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="03">
                                    </c:if>
                                </p>
                                </c:otherwise>
                            </c:choose>
                            <fmt:formatNumber value="${goodsDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                        </li>
                        <li id="dlvrPaymentKindCd02" style="display:none">
                            <span>배송비</span>
                            <p>무료</p>
                        </li>
                    </c:if>
                    <li>
                        <span>배송정보</span>
                        <p>
                            평균배송일 : ${goodsInfo.data.dlvrExpectDays}일<br>
                            <c:if test="${!empty goodsInfo.data.txLimitCndt}">
                            구매제한조건 : ${goodsInfo.data.txLimitCndt}
                            </c:if>
                            <c:if test="${goodsInfo.data.dlvrSetCd eq '1' && site_info.defaultDlvrcTypeCd eq '3'}">
                                <br>주문금액 <fmt:formatNumber value="${site_info.defaultDlvrMinAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 무료배송
                            </c:if>
                            <c:if test="${goodsInfo.data.dlvrSetCd eq '4'}">
                                <br>상품 ${goodsInfo.data.packMaxUnit}개당 배송비 <fmt:formatNumber value="${goodsInfo.data.packUnitDlvrc}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                            </c:if>
                        </p>
                    </li>
                </ul>
            </div>

            <c:if test="${goodsStatus eq '01'}">
                <c:if test="${goodsInfo.data.multiOptYn eq 'Y' || goodsInfo.data.addOptUseYn eq 'Y'}">
                <!--- 상품 옵션 있을 경우 --->
                <div class="goods_plus_info">
                    <ul>
                        <c:if test="${!empty goodsInfo.data.goodsOptionList && goodsInfo.data.multiOptYn eq 'Y'}">
                            <c:forEach var="optionList" items="${goodsInfo.data.goodsOptionList}" varStatus="status">
                            <li>
                                <span>${optionList.optNm}</span>
                                <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                                    <label for="select_option">(필수) 선택하세요</label>
                                    <select class="select_option goods_option" id="goods_option_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}"
                                    data-opt-nm="${optionList.optNm}">
                                        <option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>
                                    </select>
                                </div>
                            </li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${!empty goodsInfo.data.goodsAddOptionList && goodsInfo.data.addOptUseYn eq 'Y'}">
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
                <input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
                <input type="hidden" name="itemPriceArr" id="itemPriceArr" class="itemPriceArr" value="${goodsInfo.data.salePrice}">
                <input type="hidden" name="stockQttArr" id="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
                <input type="hidden" name="itemArr" id="itemArr" class="itemArr" value="">
                <div class="goods_plus_info" style="border-bottom:1px solid #000;">
                    <ul>
                        <li>
                            <span>구매수량</span>
                            <div class="select_box28" style="width:55px;display:inline-block">
                                <label for="select_option">1</label>
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
                <ul class="goods_plus_info02">
                <!--// 옵션 레이어 영역 //-->
                </ul>

                <div class="plus_price">
                    총 상품 금액 : <span id="totalPriceText"><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span>
                    <input type="hidden" name="totalPrice" id="totalPrice" value="0">
                </div>
            </c:if>

            <div class="order_btn_area">
                <c:if test="${goodsStatus eq '01'}">
                    <button type="button" class="btn_checkout_go" id="btn_checkout_go">바로구매</button>
                    <button type="button" class="btn_cart_go" id="btn_cart_go" style="margin:0 9px">장바구니</button>
                    <button type="button" class="btn_favorite_go" id="btn_favorite_go">관심상품</button>
                </c:if>
                <c:if test="${goodsStatus eq '02'}">
                    <c:if test="${user.session.memberNo ne null }">
                        <button type="button" class="btn_checkout_go" id="btn_alarm_view">재입고알림</button>
                    </c:if>
                    <button type="button" class="btn_checkout_go">품절</button>
                    <button type="button" class="btn_favorite_go" id="btn_favorite_go">관심상품</button>
                </c:if>
                <c:if test="${goodsStatus eq '03'}">
                <button type="button" class="btn_checkout_go">판매대기</button>
                </c:if>
                <c:if test="${goodsStatus eq '04'}">
                <button type="button" class="btn_checkout_go">판매중지</button>
                </c:if>
            </div>
        </div>
        <!---// product information  --->
        <input type="hidden" name="returnUrl" id="returnUrl" value="">
    </form>
    </div>
    <!---// 02.LAYOUT: 상품상세 상단 --->

    <!--- 03.LAYOUT: 관련상품 --->
    <c:if test="${goodsInfo.data.relateGoodsApplyTypeCd ne '3' &&  goodsInfo.data.relateGoodsApplyTypeCd ne null}">
    <%@ include file="goods_with_item.jsp" %>
    </c:if>
    <!---// 03.LAYOUT: 관련상품 --->

    <!--- 04.LAYOUT: 상품상세하단 --->
    <div id="product_bottom">
        <ul class="skin_tabs">
            <li class="active" rel="tab1" style="width:24.9%">상품상세정보</li>
            <li rel="tab2" style="width:24.8%" id="review_tab">구매후기<span id="review_count">(${goodsBbsInfo.data.reviewCount})</span></li>
            <li rel="tab3" style="width:24.8%" id="question_tab">상품문의<span id="question_count">(${goodsBbsInfo.data.qeustionCount})</span></li>
            <li rel="tab4" style="width:24.9%">배송/반품/환불</li>
        </ul>

        <!--- tab01: 상품상세정보 --->
        <div class="skin_tab_content" id="tab1">
            <div class="product_contents" id="product_contents">
            ${goodsContentVO.content}
            </div>
            <div id="notifyDiv"></div>
        </div>
        <!--- tab01: 상품상세정보 --->

        <!--- tab02: 구매후기 --->
        <div class="skin_tab_content" id="tab2"></div>
        <!---// tab02: 구매후기 --->

        <!--- tab03: 상품문의 --->
        <div class="skin_tab_content" id="tab3"></div>
        <!---// tab03: 상품문의 --->

        <!--- tab04: 배송/반품/환불 --->
        <div class="skin_tab_content" id="tab4"></div>
        <!---// tab04: 배송/반품/환불 --->

    </div>
    <!---// 04.LAYOUT: 상품상세하단 --->

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
            <span>* 상품을 <b><fmt:formatNumber value="${freebieGoodsList[0].freebieEventAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></b>원 이상 주문하시면 아래의 사은품 중 1개를 증정합니다.</span>
            <div class="popup_present_event_scroll">
                <ul class="popup_present_event_list">
                    <li>
                        <img src="/image/image-view?type=FREEBIEDTL&id1=${freebieGoodsList[0].imgPath}_${freebieGoodsList[0].imgNm}" alt="">
                        <div class="event_check">
                            <label for="event_check01">
                                <span></span>
                                ${freebieGoodsList[0].freebieNm}
                            </label>
                        </div>
                    </li>
                </ul>
            </div>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_cancel">닫기</button>
            </div>
        </div>
    </div>
    </c:if>
    <!--- popup 사은품 보기 --->
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
	</t:putAttribute>
</t:insertDefinition>