<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="with_item_divice_line"></div>
   <!--- with item  --->
<div id="with_item">
    <h2 class="with_item_title">
        관련상품
        <span>새로나온 제품들을 소개합니다.</span>
    </h2>
    <ul class="product_list_typeA">
        <c:forEach var="resultModel" items="${relateGoodsList.resultList}" varStatus="status">
        <li>
            <div class="goods_image_area">
                <div class="img_menu">
                    <a href="#"><span class="menu01" title="미리보기"></span></a>
                    <a href="#"><span class="menu02" title="장바구니"></span></a>
                    <a href="#"><span class="menu03" title="관심상품"></span></a>
                </div>
                <img src="/m/front/img/product/product_180_180.gif" alt="상품이미지">
            </div>
            <div class="brand_title">
                <a href="">${resultModel.modelNm}</a>
            </div>
            <div class="goods_title">
                <a href="">
                    ${resultModel.goodsNm}
                </a>
            </div>
            <div class="product_info">
                ${resultModel.prWords}
            </div>
            <div class="price_info">
                \${resultModel.salePrice}
            </div>
            <div class="label_area">
                <img src="/front/img/product/icon_best.png" alt="best"><img src="/front/img/product/icon_new.png" alt="new"><img src="/front/img/product/icon_hot.png" alt="hot"><img src="/front/img/product/icon_only.png" alt="단독"><img src="/front/img/product/icon_low.png" alt="최저가">
            </div>
        </li>
        </c:forEach>
    </ul>
</div>
<!---// with item  --->
