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
   		$('.lens_view_slider ul.slider').bxSlider({
   			mode: 'horizontal',
   			auto: false,
   			controls: true,
   			pager: false
   		});
   		
   	});
</script>

	<input type="hidden" id="wearTotPages" value="${wearTotPages }">
	<c:forEach var="goodsLi" items="${wearImgsetNoList}" varStatus="status">
		<c:choose>
			<c:when test="${status.index % 2 == 0 }"><c:set var="dir" value="fl"/></c:when>
			<c:otherwise><c:set var="dir" value="fr"/></c:otherwise>
		</c:choose>
		<c:if test="${status.index % 4 == 1 || status.index % 4 == 2 }"><c:set var="dir" value="${dir } gray"/></c:if>
		
		<c:if test="${status.index % 2 == 0 }"><div class="lens_slider_area"></c:if>
		<div class="lens_view_slider ${dir}">
			<ul class="slider">
				<c:set var="wearListId" value="wearList_${status.index }"/>
				<c:forEach var="wearLi" items="${wearMap.get(wearListId)}">
					<li>
						<div class="name"><span>${wearLi.wearGoodsNm }</span></div>
						<div class="lens_img_area">
							<img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${wearLi.imgPath}_${wearLi.imgNm}" alt="">
							<span><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${wearLi.lensImgPath}_${wearLi.lensImgNm}" alt=""></span>
						</div>
						<!-- 왼쪽 렌즈 정보 -->
						<ul class="lens_info">
							<li><b>${wearLi.colorValue }</b></li>
							<li>${wearLi.wearCycle }</li>
							<li>${wearLi.grpDmtr }</li>
							<li>${wearLi.materialValue }</li>
							<li>${wearLi.uvInterceptionValue }</li>
							<li>${wearLi.qttValue }</li>
							<li>${wearLi.salePriceValue }</li>
							<li class="benefit"><span>${wearLi.mktBnfValue }</span></li>
							<li class="btn_area"><button type="button" class="btn_view_lens" onClick="goods_detail('${wearLi.goodsNo }');"></button></li>
						</ul>
						<!--// 왼쪽 렌즈 정보 -->
					</li>
				</c:forEach>
			</ul>
		</div>
		<c:if test="${status.index % 2 == 1 }"></div></c:if>
	</c:forEach>
	
