<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>

    <c:if test="${!empty goodsInfo.data.relateGoodsList}">
        <h2 class="sub_title goodsdetail">
			관련상품			
			<div class="product_list_control product_list_control01">
				<button type="button" class="btn_sub_slider_prev">이전으로</button>
				<button type="button" class="btn_sub_slider_next">다음으로</button>
			</div>
		</h2>
        <div class="product_list_area">
        <ul id="product_list_slider" class="bxslider product_list_typeA product_list_slider01"  data-call="bxslider" data-call="bxslider" data-options="slideMargin:10, autoReload:true" data-breaks="[{screen:0, slides:2, pager:true},{screen:640, slides:2},{screen:768, slides:3}]">
        <data:goodsList value="${goodsInfo.data.relateGoodsList}" headYn="N" iconYn="N" displayTypeCd="07"/>
        </ul>
        </div>
    </c:if>

    <c:if test="${!empty goodsInfo.data.similarGoodsList}">
    <h2 class="sub_title goodsdetail">
		비슷한 상품
		<div class="product_list_control product_list_control02">
			<button type="button" class="btn_sub_slider_prev">이전으로</button>
			<button type="button" class="btn_sub_slider_next">다음으로</button>
		</div>
	</h2>
        <div class="product_list_area">
        <ul id="product_list_slider" class="bxslider product_list_typeA product_list_slider02"  data-call="bxslider" data-call="bxslider" data-options="slideMargin:10, autoReload:true" data-breaks="[{screen:0, slides:2, pager:true},{screen:640, slides:2},{screen:768, slides:3}]">
    <data:goodsList value="${goodsInfo.data.similarGoodsList}" headYn="N" iconYn="N" displayTypeCd="07"/>
        </ul>
        </div>    
    </c:if>