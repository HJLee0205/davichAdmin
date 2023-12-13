<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<div id="quick_menu">
    <div class="quick_area">
        <h2 class="quick_title">QUICK MENU</h2>
        <div class="quick_body">
            <ul class="quick_smenu">
                <li><a href="#none" style="cursor:default">최근본상품 <span id="lately_count"></span></a></li>
                <li><a href="javascript:move_basket();">장바구니 <span id="basket_count"></span></a></li>
                <li><a href="javascript:move_interest();">위시리스트 <span id="interest_count"></span></a></li>
            </ul>
            <p>
                <a href="#" class="btn_quick_pre">
                    <img src="${_SKIN_IMG_PATH}/quick/btn_quick_pre.png" alt="이전">
                </a>
            </p>
            <!-- 최근본상품 -->
            <ul class="quick_view"></ul>
            <!-- 최근본상품 -->
            <p>
                <a href="#" class="btn_quick_next">
                    <img src="${_SKIN_IMG_PATH}/quick/btn_quick_next.png" alt="다음">
                </a>
            </p>
        </div>
        <a href="#none" class="btn_quick_top">TOP</a>
    </div>
</div>