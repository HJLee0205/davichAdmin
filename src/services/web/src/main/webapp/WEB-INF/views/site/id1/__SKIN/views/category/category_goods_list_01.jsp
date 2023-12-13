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
<t:putAttribute name="title">다비치마켓 :: ${so.ctgNm}</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){
    $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징

    //베스트 브랜드
    $(function(){
        var BsetSlider = $( '.best_brand .product_bb' ).bxSlider({
            pager: false,
            slideWidth: 285,
            infiniteLoop: true,
            moveSlides: 1,
            minSlides: 4,      // 최소 노출 개수
            maxSlides: 4,      // 최대 노출 개수
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

});

	// 컬러렌즈 착용샷 보기 탭버튼
	function go_contact_wear() {
		var ctgNo = "${so.ctgNo}";
		location.href = "/front/search/category?ctgNo="+ctgNo+"&wearYn=Y";
	}
	
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">

        <!--- 카테고리배너&검색필터 --->
        <%@ include file="category_search_filter.jsp" %>
        <!---// 카테고리배너&검색필터 --->

        <!-- 베스트 브랜드 -->
        <c:if test="${category_info.bestBrandUseYn eq 'Y'}">
        <div class="best_brand">
            <h3 class="category_mid_tit">베스트 브랜드</h3>
            <ul class="product_bb">
                <c:forEach var="brandList" items="${brand_list}" varStatus="status">
                <li>
                    <a href="/front/brand-category-dtl?searchBrands=${brandList.brandNo}">
                        <div class="img_area">
                            <img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${brandList.listImgPath}_${brandList.listImgNm}" width="283px" height="244px" alt="" onerror="this.src='/front/img/common/no_image.png'">
                        </div>
                        <%--<div class="text_area">
                            <p class="name">${brandList.brandNm}</p>
                        </div>--%>
                    </a>
                </li>
                </c:forEach>
            </ul>
            <div class="best_brand_control">
                <span class="page"><em>1</em>/${fn:length(brand_list)}</span>
                <button type="button" class="btn_product_bb_prev">이전으로</button>
                <button type="button" class="btn_product_bb_next">다음으로</button>
            </div>
        </div>
        </c:if>
        <!--// 베스트 브랜드 -->

        <!-- MDs PICK -->
        <c:if test="${fn:length(category_list) > 0}">
        <div class="category_MD_area">
            <h3 class="category_mid_tit">MD’s  PICK</h3>
            <!--- 카테고리 전시상품영역 --->
            <%@ include file="category_display_goods.jsp" %>
            <!---// 카테고리 전시상품영역 --->
        </div>
        </c:if>
        <!--// MDs PICK -->

    </div>
    <!---// 02.LAYOUT: 카테고리 메인 --->

    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>

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
    </div>
    </t:putAttribute>
</t:insertDefinition>