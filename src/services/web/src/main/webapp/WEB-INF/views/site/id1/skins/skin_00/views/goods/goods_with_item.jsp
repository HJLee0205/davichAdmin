<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<c:if test="${!empty goodsInfo.data.relateGoodsList}">
<div class="with_item_divice_line"></div>
   <!--- with item  --->
<div id="with_item">
    <div class="with_item_direction">
        <a href="#" class="btn_with_list_pre"><img src="${_SKIN_IMG_PATH}/product/btn_with_list_pre.png" alt="이전"></a>
        <a href="#" class="btn_with_list_nex"><img src="${_SKIN_IMG_PATH}/product/btn_with_list_nex.png" alt="다음"></a>
    </div>
    <h2 class="with_item_title">WITH ITEM</h2>
    <data:goodsList value="${goodsInfo.data.relateGoodsList}" displayTypeCd="01" headYn="N" iconYn="Y"/>
</div>
<!---// with item  --->
</c:if>
