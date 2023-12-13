<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="content">
        
        <%@ include file="main_visual.jsp" %>
        <c:if test="${!empty displayGoods1}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods1}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods2}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods2}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods3}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods3}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods4}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods4}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods5}">
            <div class="main_layout_middle">
                <div id="main_best_product">
                <data:goodsList value="${displayGoods5}" headYn="Y" iconYn="Y" />
                </div>
            </div>
        </c:if>

        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
        <%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>
        <!-- 상품이미지 미리보기 팝업 -->
        <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
            <div id ="goodsPreview"></div>
        </div>
        <!--- popup 장바구니 등록성공 --->
        <div class="alert_body" id="success_basket" style="display: none;">
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
        
    </t:putAttribute>
</t:insertDefinition>