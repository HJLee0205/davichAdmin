<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
$(document).ready(function(){
    //이미지 슬라이더
    $('.goods_view_slider').bxSlider({
      pagerCustom: '#goods_view_s_slider'
    });
    $('.btn_close_popup').on('click',function (){
        close_goods_preview();
    });
});
</script>
<!--- product photo  --->
<div id="product_photo">
    <div class="popup_header">
        <h1 class="popup_tit" id="popup_tit"></h1>
        <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <ul class="goods_view_slider">
    <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
        <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
            <c:if test="${imgDtlList.goodsImgType eq '02'}">
            <li><img src="${imgDtlList.imgUrl}" alt=""></li>
            </c:if>
        </c:forEach>
    </c:forEach>
    </ul>
    <div id="goods_view_s_slider">
    <c:set var="idx" value="0"/>
    <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
        <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
            <c:if test="${imgDtlList.goodsImgType eq '03'}">
            <a data-slide-index="${idx}" href=""><img src="${imgDtlList.imgUrl}" alt=""></a>
            <c:set var="idx" value="${idx+1}"/>
            </c:if>
        </c:forEach>
    </c:forEach>
    </div>
</div>
<!---// product photo  --->