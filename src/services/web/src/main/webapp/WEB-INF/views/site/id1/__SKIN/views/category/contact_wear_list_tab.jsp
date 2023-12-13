<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="du" class="dmall.framework.common.util.DateUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
	/*   lens view slider   */
	$(function () {
		 var LLslider = $('.lens_view_slider.fl > ul').bxSlider({
			mode: 'horizontal',
			auto: false,
			controls: false,
			touchEnabled: false,
			pager: true,
			pagerType: 'short'
		});
		$('.btn_LL_prev').click(function () {
			var current = LLslider.getCurrentSlide();
			LLslider.goToPrevSlide(current) - 1;
		});
		$('.btn_LL_next').click(function () {
			var current = LLslider.getCurrentSlide();
			LLslider.goToNextSlide(current) + 1;
		});
	
		var LRslider = $('.lens_view_slider.fr > ul').bxSlider({
			mode: 'horizontal',
			auto: false,
			controls: false,
			pager: true,
			pagerType: 'short'
		});
		$('.btn_LR_prev').click(function () {
			var current = LRslider.getCurrentSlide();
			LRslider.goToPrevSlide(current) - 1;
		});
		$('.btn_LR_next').click(function () {
			var current = LRslider.getCurrentSlide();
			LRslider.goToNextSlide(current) + 1;
		});
	});
</script>

	<!-- 왼쪽 렌즈 슬라이더 -->
	<div class="lens_view_slider fl">
		<ul>
			<c:forEach var="li_l" items="${left_wear_list}" varStatus="status">
			<li>
				<div class="lens_img_area">
					<img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${li_l.imgPath}_${li_l.imgNm}" alt="">
					<span><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${li_l.lensImgPath}_${li_l.lensImgNm}" alt=""></span>
				</div>
				<!-- 왼쪽 렌즈 정보 -->
				<ul class="info">
					<li class="name">${li_l.wearGoodsNm }</li>
					<li>${li_l.colorValue }</li>
					<li>${li_l.wearCycle }</li>
					<li>${li_l.grpDmtr }</li>
					<li>${li_l.materialValue }</li>
					<li>${li_l.uvInterceptionValue }</li>
					<li>${li_l.qttValue }</li>
					<li>${li_l.salePriceValue }</li>
					<li>${li_l.mktBnfValue }</li>
					<li class="btn_area"><button type="button" class="btn_view_lens" onClick="goods_detail('${li_l.goodsNo }');"></button></li>
				</ul>
				<!--// 왼쪽 렌즈 정보 -->
			</li>
			</c:forEach>
		</ul>
		<button type="button" class="btn_LL_prev">prev</button>
		<button type="button" class="btn_LL_next">next</button>
	</div>
	<!--// 왼쪽 렌즈 슬라이더 -->

	<!-- 오른쪽 렌즈 슬라이더 -->
	<div class="lens_view_slider fr">
		<ul>
			<c:forEach var="li_r" items="${right_wear_list}" varStatus="status">
			<li>
				<div class="lens_img_area">
					<img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${li_r.imgPath}_${li_r.imgNm}" alt="">
					<span><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${li_r.lensImgPath}_${li_r.lensImgNm}" alt=""></span>
				</div>
				<!-- 오른쪽 렌즈 정보 -->
				<ul class="info">
					<li class="name">${li_r.wearGoodsNm }</li>
					<li>${li_r.colorValue }</li>
					<li>${li_r.wearCycle }</li>
					<li>${li_r.grpDmtr }</li>
					<li>${li_r.materialValue }</li>
					<li>${li_r.uvInterceptionValue }</li>
					<li>${li_r.qttValue }</li>
					<li>${li_r.salePriceValue }</li>
					<li>${li_r.mktBnfValue }</li>
					<li class="btn_area"><button type="button" class="btn_view_lens" onClick="goods_detail('${li_r.goodsNo }');"></button></li>
				</ul>
				<!--// 오른쪽 렌즈 정보 -->
			</li>
			</c:forEach>
		</ul>
		<button type="button" class="btn_LR_prev">prev</button>
		<button type="button" class="btn_LR_next">next</button>
	</div>
	<!--// 오른쪽 렌즈 슬라이더 -->
	
	<ul class="center">
		<li class="name">상품명</li>
		<li>컬러</li>
		<li>착용주기</li>
		<li>그래픽직경</li>
		<li>재질</li>
		<li>자외선차단</li>
		<li>개수</li>
		<li>판매가격</li>
		<li>마켓혜택</li>
		<li class="btn_area"></li>
	</ul>
	
