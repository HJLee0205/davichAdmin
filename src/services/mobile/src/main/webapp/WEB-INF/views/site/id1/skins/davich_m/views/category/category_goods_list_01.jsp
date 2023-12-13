<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">${so.ctgNm}</t:putAttribute>
	<t:putAttribute name="script">
	<script>
	$(document).ready(function(){
		/* var $div_id_detail = $('#div_id_detail');
    	var $totalPageCount = $('#totalPageCount');
    	var totalPageCount = Number('${so.totalPageCount}');
    	var $list_page_view_em = $('.list_page_view em');
    	// 페이지 번호에 따른 페이징div hide
		if(totalPageCount == Number($('#page').val())){
 			$('.list_bottom').hide();
		}
		$list_page_view_em.text(Number($('#page').val()));
        $totalPageCount.text(totalPageCount);
		// 더보기 버튼 클릭시 append 이벤트
        $('.more_view').off('click').on('click', function() {
        	var pageIndex = Number($('#page').val())+1;
        	if(totalPageCount < pageIndex){
        		$("#page").val(pageIndex);
	          	var param = "page="+pageIndex;
	     		var url = '${_MOBILE_PATH}/front/search/category?ctgNo=${so.ctgNo}&'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
		        	$list_page_view_em.text(pageIndex);
			        var detail = $(result).find('#div_id_detail');
			        $div_id_detail.append(detail.html());
		        });
	        }else{
 		$('.list_bottom').hide();	
	        }
        }); */
        
    });

    //베스트 브랜드
    $(function(){
        var BsetSlider = $( '.best_brand .product_bb' ).bxSlider({
            pager: false,
            slideWidth: 178,
			slideMargin:4,
            infiniteLoop: true,
            moveSlides: 1,
            minSlides: 2,      // 최소 노출 개수
            maxSlides: 2,      // 최대 노출 개수
            auto: false,
        });
        $('.best_brand .btn_product_bb_prev').click(function () {
            var current = BsetSlider.getCurrentSlide();

            BsetSlider.goToPrevSlide(current) - 1;
            if(current<=0){
                current=${fn:length(brand_list)};
            }else{
                current = (current+1)-1;
            }
            $(this).parents("div").find("em").html(current);
        });
        $('.best_brand .btn_product_bb_next').click(function () {
            var current = BsetSlider.getCurrentSlide();

            BsetSlider.goToNextSlide(current) + 1;

            if(current+1==${fn:length(brand_list)}){
                current = 1;
            }else{
                current=(current+1)+1;;
            }
            $(this).parents("div").find("em").html(current);
        });
    });
    
 	// 컬러렌즈 착용샷 보기 탭버튼
	function go_contact_wear() {
		var ctgNo = "${so.ctgNo}";
		location.href = "${_MOBILE_PATH}/front/search/category?ctgNo="+ctgNo+"&wearYn=Y";
	}
	
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<!--- navigation --->
		<%@ include file="navigation.jsp" %>
		<!---// navigation --->

		<!--- 카테고리배너&검색필터 --->
		<%@ include file="search_filter.jsp" %>
		<!---// 카테고리배너&검색필터 --->

		<!-- <div class="cont_body"> -->
		<div class="">
			<!-- 베스트 브랜드 -->
			<c:if test="${category_info.bestBrandUseYn eq 'Y'}">
			<div class="best_brand">
				<h3 class="category_mid_tit">베스트 브랜드</h3>
				<div class="cont_body">
					<ul class="product_bb">
						<c:forEach var="brandList" items="${brand_list}" varStatus="status">
							<li>
								<a href="${_MOBILE_PATH}/front/brand-category-dtl?searchBrands=${brandList.brandNo}">
									<div class="img_area">
										<img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${brandList.listImgPath}_${brandList.listImgNm}" alt="" onerror="this.src='/front/img/common/no_image.png'">
									</div>

									<%--<div class="text_area">
										<p class="name">${brandList.brandNm}</p>
									</div>--%>
								</a>
							</li>

						</c:forEach>
					</ul>
				</div>
			</div>
			</c:if>
			<!--// 베스트 브랜드 -->

			<!-- MDs PICK -->
			<c:if test="${fn:length(category_list) > 0}">
			<div class="category_MD_area">
				<h3 class="category_mid_tit">MD’s  PICK</h3>
				<!--- 카테고리 전시상품영역 --->
				<%@ include file="display_goods.jsp" %>
				<!---// 카테고리 전시상품영역 --->
			</div>
			</c:if>
			<!--// MDs PICK -->
			<!-- 콘택트렌즈 착용샷 -->
			<c:if test="${so.ctgNo eq '4'}">
	        	<div id="div_contact_wear" style="display:none;">
	        		<input type="hidden" id="wear_page" value="1">
	        		<input type="hidden" id="wear_brand" value="">
	        		<div class="lens_view_title">
						콘택트렌즈 착용샷
					</div>
	        		<ul class="lens_tabs">
			        	<c:forEach var="li" items="${contact_wear_brand_list}" varStatus="status">
			        		<c:if test="${li.brandNo eq '11' || li.brandNo eq '12' || li.brandNo eq '77' || li.brandNo eq '139'}">
			        			<c:choose>
			        				<c:when test="${li.brandNo eq '11'}"><c:set var="tabNo" value="01"/></c:when>
			        				<c:when test="${li.brandNo eq '12'}"><c:set var="tabNo" value="02"/></c:when>
			        				<c:when test="${li.brandNo eq '77'}"><c:set var="tabNo" value="03"/></c:when>
			        				<c:when test="${li.brandNo eq '139'}"><c:set var="tabNo" value="04"/></c:when>
			        				<c:otherwise><c:set var="tabNo" value="00"/></c:otherwise>
			        			</c:choose>
			        			<li data-brandNo="${li.brandNo }"><a href="javascript:;" class="lens_tab${tabNo } <c:if test="${status.first }"> active</c:if>">${li.brandNm }</a></li>
			        			<c:if test="${status.first }"><c:set var="firstTab" value="${tabNo }"/></c:if>
			        		</c:if>
			        	</c:forEach>
					</ul>	
					<div class="lens_brand_tit">
						<img src="${_SKIN_IMG_PATH}/product/trevues_tit.png" alt="TREVUES" id="brand_no_11" style="display:none;">
						<img src="${_SKIN_IMG_PATH}/product/eyeluv_tit.png" alt="EYE LUV" id="brand_no_12" style="display:none;">
						<img src="${_SKIN_IMG_PATH}/product/tenten_tit.png" alt="TEN TEN" id="brand_no_77" style="display:none;">
						<img src="${_SKIN_IMG_PATH}/product/seventeen_tit.png" alt="SEVENTEEN" id="brand_no_139" style="display:none;">
					</div>	
			        <div id="lens_slider_area" class="cont_body"></div>
			        <div class="list_bottom">
						<a href="javascript:fn_wear_more_view();" class="more_view">
							20개 더보기<span class="icon_more_view"></span>
						</a>
					</div>
	        	</div>
	        </c:if>
        	<!-- 콘택트렌즈 착용샷 -->
		</div><!-- //cont_body -->
	</div><!-- //middle_area -->
	<!---// 03.LAYOUT:CONTENTS --->
	<!-- 예약바로가기 20200706 -->
	<c:if test="${user.login}">
	<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-book" class="btn_go_reservation">
	</c:if>
	<c:if test="${!user.login}">
	<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome" class="btn_go_reservation">
	</c:if>
	${storeTotCnt}개 매장예약
	</a>
	<!--// 예약바로가기 20200706 -->

	</t:putAttribute>
</t:insertDefinition>