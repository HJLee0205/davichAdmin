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

});
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">
        <c:if test="${fn:length(category_list) > 0}">
	        <!-- 상품목록(바둑판형) -->
		    <c:forEach var="category_list" items="${category_list}" varStatus="status">
		    <h3 class="best_area_tit">${category_list.dispzoneNm} BEST</h3>
		    <ul class="product_list_typeB">
		        <c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
		        <c:set var="list" value="${requestScope.get(goods_list)}" />
		        <data:goodsList value="${list}" displayTypeCd="01" headYn="N" iconYn="N" topYn="N" bestCtgYn="Y"/>
		    </ul>
		    <c:set var="moveCtgNo" value="434"/>
		    <c:choose>
		    	<c:when test="${category_list.dispzoneNm eq '안경테'}"><c:set var="moveCtgNo" value="1"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '콘택트렌즈'}"><c:set var="moveCtgNo" value="4"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '안경렌즈'}"><c:set var="moveCtgNo" value="3"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '선글라스'}"><c:set var="moveCtgNo" value="2"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq 'D.라이프'}"><c:set var="moveCtgNo" value="499"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '아이웨어'}"><c:set var="moveCtgNo" value="762"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '헬스케어'}"><c:set var="moveCtgNo" value="170"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '리빙'}"><c:set var="moveCtgNo" value="169"/></c:when>
		    	<c:when test="${category_list.dispzoneNm eq '뷰티'}"><c:set var="moveCtgNo" value="171"/></c:when>
		    </c:choose>
		    <div class="best_divice"><a href="javascript:move_category('${moveCtgNo }')" class="go_more">${category_list.dispzoneNm} 더보기<i></i></a></div>
		    </c:forEach>
	    <!--// 상품목록(바둑판형) -->
        </c:if>
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