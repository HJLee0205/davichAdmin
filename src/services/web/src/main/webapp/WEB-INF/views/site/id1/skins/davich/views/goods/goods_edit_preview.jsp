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
<t:insertDefinition name="previewLayout">
	<t:putAttribute name="title">다비치마켓 :: 상품상세 미리보기</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="content">

	<!--- // 00.Script --->
	<%@ include file="goods_edit_preview_js.jsp" %>
	<%@ include file="goods_detail_inc.jsp" %>
	<!--- // 00.Script --->

	<!--- 01.LAYOUT: 상품상세 location --->
	<!--- category header 카테고리 location과 동일 --->
		<%--<%@ include file="../category/category_navigation.jsp" %>--%>
	<!---// category header --->
	<!---// 01.LAYOUT: 상품상세 location --->

	<!--- 02.LAYOUT: 상품상세 상단 --->
	<!--- product detail top  --->
	<div id="product_detail_top">
		<form name="goods_form" id="goods_form">
			<input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
			<input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
			<input type="hidden" name="prmtNo" id="prmtNo" value="${promotionInfo.data.prmtNo}">
			<input type="hidden" name="returnUrl" id="returnUrl" value="">
			<input type="hidden" name="exhibitionYn" id="exhibitionYn" value="">
			<input type="hidden" name="rsvOnlyYn" id="rsvOnlyYn" value="">
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
								<a data-slide-index="${idx}" href="javascript:void(0);" onclick="clicked(${idx});"><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></a>
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
					<em><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>
					<c:choose>
						<c:when test="${goodsInfo.data.customerPrice gt 0 && salePrice ne goodsInfo.data.customerPrice}">
							<del><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></del>
						</c:when>
						<c:otherwise>
							<%--<del><fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>--%>
						</c:otherwise>
					</c:choose>
					<c:if test="${totalSaleRate>0}">
						<span class="icon_down"><fmt:formatNumber type="NUMBER" value="${totalSaleRate}" pattern="#"/>%</span>
					</c:if>

					<c:choose>
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
					</c:choose>

					<c:if test="${fn:length(couponList) > 0}">
						<a href="javascript:downloadCoupon();"><img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰이미지"></a>
					</c:if>
				</div>

				<c:if test="${goodsInfo.data.prWords ne null}">
					<div class="goods_info">
						<p class="text"> ${goodsInfo.data.prWords}</p>
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
														<input type="radio" class="order_radio" name="dlvrMethodCd" id="dlvrMethodCd2" value="02" checked>
														<label for="dlvrMethodCd2"><span></span>DDS(다비치 다이렉트 서비스)</label>
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
														DDS(다비치 다이렉트 서비스)
														<input type="hidden" name="dlvrMethodCd" id="dlvrMethodCd" value="02">
													</c:if>
												</p>
											</c:otherwise>
										</c:choose>
									</li>
								</ul>
							</div>
							<c:if test="${directVisitRecptYn eq 'Y'}">
								<div class="shipping_dds">
									DDS(다비치 다이렉트 서비스)
									<ul class="dot_list">
										<li>온라인에서 주문하고 가까운 다비치 매장에서 수령</li>
										<li>다비치안경의 전문적인 피팅 서비스</li>
										<li>다비치안경 AI GO VCS를 통한 차별화된 비전 컨설팅 시스템</li>
									</ul>
								</div>
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
						<c:if test="${goodsStatus eq '01'}">
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
						</c:if>

					</ul>
				</div>
				<!-- 옵션 -->

				<!---// 상품 옵션 있을 경우 --->
				<c:if test="${goodsInfo.data.multiOptYn eq 'N'}">
					<input type="hidden" name="itemNoArr" id="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
					<input type="hidden" name="itemPriceArr" id="itemPriceArr" class="itemPriceArr" value="${goodsInfo.data.salePrice}">
					<input type="hidden" name="stockQttArr" id="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
					<input type="hidden" name="itemArr" id="itemArr" class="itemArr" value="">
					<div class="goods_plus_info" style="border-bottom:1px solid #000;">
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

				<!--옵션 레이어 영역 //-->
				<div class="goods_options">
					<ul class="goods_plus_info02">
							<%-- <li>
                                 <span class="name">인디언핑크</span>
                                 <div class="goods_no_select">
                                     <button type="button" class="btn_goods_down"></button>
                                     <input type="text" value="1">
                                     <button type="button" class="btn_goods_up"></button>
                                 </div>
                                 <span class="goods_price_select">
                                 70,000
                                 <button type="button" class="btn_goods_del"></button>
                             </span>
                             </li>
                             <li>
                                 <span class="name">그레이블루</span>
                                 <div class="goods_no_select">
                                     <button type="button" class="btn_goods_down"></button>
                                     <input type="text" value="1">
                                     <button type="button" class="btn_goods_up"></button>
                                 </div>
                                 <span class="goods_price_select">
                                 70,000
                                 <button type="button" class="btn_goods_del"></button>
                             </span>
                             </li>--%>
					</ul>
				</div>
				<!--// 옵션 -->
				<div class="plus_price">
					<span class="title">합계</span>
					<span id="totalPriceText" class="total_price"> <fmt:formatNumber value="${salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
				</div>
				</c:if>
				<div class="order_btn_area">
					<c:if test="${goodsStatus eq '01'}">
						<button type="button" class="btn_favorite_go" id="btn_favorite_go">좋아요</button>

						<%--                <button type="button" class="btn_checkout_go" id="btn_pre_rsv_go">사전예약 ${prmtDcValue}%할인</button> --%>
						<c:choose>
							<c:when test="${promotionInfo.data.prmtTypeCd eq '05'}">
								<%--사전예약--%>
								<button type="button" class="btn_checkout_go" id="btn_pre_rsv_go" style="width:346px;">사전예약
										${prmtDcValue}
									<c:if test="${promotionInfo.data.prmtDcGbCd eq '01'}">
										%
									</c:if>
									<c:if test="${promotionInfo.data.prmtDcGbCd eq '02'}">
										원
									</c:if>
									할인</button>
							</c:when>
							<c:otherwise>
								<%--일반상품--%>
								<c:if test="${goodsInfo.data.rsvOnlyYn ne 'Y'}">
									<button type="button" class="btn_cart_go" id="btn_cart_go" >장바구니</button>
									<button type="button" class="btn_checkout_go" id="btn_checkout_go">바로구매</button>
								</c:if>
								<%--예약전용--%>
								<c:if test="${goodsInfo.data.rsvOnlyYn eq 'Y'}">
									<button type="button" class="btn_cart_go" id="btn_cart_go" >장바구니</button>
									<button type="button" class="btn_checkout_go" id="btn_rsv_go">예약하기</button>
								</c:if>
							</c:otherwise>
						</c:choose>
					</c:if>
					<c:if test="${goodsStatus eq '02'}">
						<button type="button" class="btn_favorite_go" id="btn_favorite_go">관심상품</button>
						<button type="button" class="btn_soldout" disabled>품절</button>
						<c:if test="${user.session.memberNo ne null }">
							<button type="button" class="btn_checkout_go" id="btn_alarm_view">재입고알림</button>
						</c:if>
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
	<!---// 02.LAYOUT: 상품상세 상단 --->

	<!--- 03.LAYOUT: 관련상품 --->
	<c:if test="${goodsInfo.data.relateGoodsApplyTypeCd ne '3' &&  goodsInfo.data.relateGoodsApplyTypeCd ne null}">
	<%@ include file="goods_with_item.jsp" %>
	</c:if>
	<!---// 03.LAYOUT: 관련상품 --->

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
					<div class="pop_comment">* 상품을 <b><fmt:formatNumber value="${freebieGoodsList[0].freebieEventAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></b>원 이상 주문하시면 아래의 사은품 중 1개를 증정합니다.</div>
					<div class="popup_present_event_scroll">
						<ul class="popup_present_event_list">
							<li>
								<span class="present_img"><img src="${_IMAGE_DOMAIN}/image/image-view?type=FREEBIEDTL&id1=${freebieGoodsList[0].imgPath}_${freebieGoodsList[0].imgNm}" alt=""></span><p><em class="present_tit">${freebieGoodsList[0].freebieNm}</em>간략설명 100자</p></div>
					</li><!-- 여기가 두번 더나와야합니다. 세번까지 -->
					</ul>
				</div>
				<div class="popup_btn_area">
					<button type="button" class="btn_popup_cancel">닫기</button>
				</div><br><br><br>
			</div><!-- //popup_content -->
			</div><!-- //popup_present_event -->
		</c:if>

		<!--- popup 사은품 보기 --->
		<!-- 상품이미지 미리보기 팝업 -->
		<div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
			<div id ="goodsPreview"></div>
		</div>

	</t:putAttribute>
</t:insertDefinition>