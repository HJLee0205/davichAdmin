<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
    //이미지 슬라이더
    $(document).ready(function(){

        var PrevSlider = $( '.layer_preview .goods_preview_slider' ).bxSlider({
            pager: false,
            infiniteLoop: true,
            auto: false,
        });
        $('.layer_preview .btn_goods_preview_prev').click(function () {
            var current = PrevSlider.getCurrentSlide();
            PrevSlider.goToPrevSlide(current) - 1;
        });
        $('.layer_preview .btn_goods_preview_next').click(function () {
            var current = PrevSlider.getCurrentSlide();
            PrevSlider.goToNextSlide(current) + 1;
        });


        $('.btn_close_preview').on('click',function (){
            close_goods_preview();
        });
    });
    function clicked(position) {
        slider.goToSlide(position);
    }
</script>

<!-- layer_preview -->
<div class="layer_preview">
    <div class="head">
        <h1>${goodsInfo.data.goodsNm}</h1>
        <button type="button" class="btn_close_preview">창닫기</button>
    </div>
    <ul class="goods_preview_slider">
        <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
            <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                <c:if test="${imgDtlList.goodsImgType eq '02'}">
                    <li><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></li>
                </c:if>
            </c:forEach>
        </c:forEach>
       <%-- <li><img src="${_SKIN_IMG_PATH}/product/preview_img01.jpg" alt=""></li>
        <li><img src="${_SKIN_IMG_PATH}/product/preview_img01.jpg" alt=""></li>
        <li><img src="${_SKIN_IMG_PATH}/product/typeB_product01.jpg" alt=""></li>
        <li><img src="${_SKIN_IMG_PATH}/product/preview_img01.jpg" alt=""></li>
        <li><img src="${_SKIN_IMG_PATH}/product/product_detail01.jpg" alt=""></li>
        <li><img src="${_SKIN_IMG_PATH}/product/preview_img01.jpg" alt=""></li>--%>
    </ul>
    <div class="goods_preview_control">
        <button type="button" class="btn_goods_preview_prev">이전으로</button>
        <button type="button" class="btn_goods_preview_next">다음으로</button>
    </div>
    <%--<div class="goods_preview_control">
        <span class="page"><em>1</em>/5</span>
    </div>--%>
</div>
<!-- layer_preview -->
<%--

<div class="popup_header">
    <h1 class="popup_tit">상품 미리보기</h1>
    <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>
<div class="popup_content">
    <div id="product_photo" style="margin:0 auto;float:none;">
        <ul class="goods_view_slider">
        <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
            <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                <c:if test="${imgDtlList.goodsImgType eq '02'}">
                <li><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></li>
                </c:if>
            </c:forEach>
        </c:forEach>
        </ul>
        <div id="goods_view_s_slider">
        <c:set var="idx" value="0"/>
        <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
            <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                <c:if test="${imgDtlList.goodsImgType eq '03'}">
                <a data-slide-index="${idx}" href="javascript:void()" onclick="clicked(${idx});"><img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></a>
                <c:set var="idx" value="${idx+1}"/>
                </c:if>
            </c:forEach>
        </c:forEach>
        </div>
    </div>
</div>--%>
