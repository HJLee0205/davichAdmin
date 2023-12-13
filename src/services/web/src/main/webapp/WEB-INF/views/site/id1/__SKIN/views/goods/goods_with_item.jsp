<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>

<%--
<c:if test="${!empty goodsInfo.data.relateGoodsList}">
<div class="with_item_divice_line"></div>
   <!--- with item  --->
<div id="with_item">
    <div class="with_item_direction">
        <a href="#" class="btn_with_list_pre"><img src="${_SKIN_IMG_PATH}/product/btn_with_list_pre.png" alt="이전"></a>
        <a href="#" class="btn_with_list_nex"><img src="${_SKIN_IMG_PATH}/product/btn_with_list_nex.png" alt="다음"></a>
    </div>
    <h2 class="with_item_title">WITH ITEM</h2>
    <data:goodsList value="${goodsInfo.data.relateGoodsList}" displayTypeCd="07" headYn="N" iconYn="Y" />
</div>
<!---// with item  --->
</c:if>
--%>

<c:if test="${!empty goodsInfo.data.relateGoodsList}">
    <!--- with item  --->
<div id="with_item">
    <div class="left">
        <h2 class="with_item_title">관련상품</h2>
        <div class="outline">
            <ul class="product_list_typeA leftslider">
                <data:goodsList value="${goodsInfo.data.relateGoodsList}" displayTypeCd="07" headYn="N" iconYn="Y" topYn="N"/>
            </ul>
        </div>
        <div class="with_item_control">
            <%--<span class="page"><em>1</em>/5</span>--%>
            <button type="button" class="btn_with_list_prev">dd</button>
            <button type="button" class="btn_with_list_next">dd</button>
        </div>
    </div>

    <div class="right">
        <h2 class="with_item_title">비슷한 상품</h2>
        <div class="outline">
            <ul class="product_list_typeA rightslider">
                <data:goodsList value="${goodsInfo.data.similarGoodsList}" displayTypeCd="07" headYn="N" iconYn="Y" topYn="N"/>
            </ul>
        </div>
        <div class="with_item_control">
            <%--<span class="page"><em>1</em>/5</span>--%>
            <button type="button" class="btn_with_list_prev">dd</button>
            <button type="button" class="btn_with_list_next">dd</button>
        </div>
    </div>
</div>
    <!---// with item  --->
</c:if>