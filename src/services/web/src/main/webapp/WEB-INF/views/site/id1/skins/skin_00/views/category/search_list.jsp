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
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">검색결과</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){
    $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
});
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <div class="contents">
    <!---script --->
    <%@ include file="/WEB-INF/views/category/search_list_js.jsp" %>
    <!--- script --->
    <!--- contents --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">HOME</a><span>&gt;</span>검색결과
            </div>
        </div>
        <!---// category header --->
        <!--- 검색 필터 영역 --->
        <form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />
        <form:hidden path="rows" id="rows" />
        <form:hidden path="sortType" id="sortType" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />
        <ul class="search_filter">
            <li style="width:77.9%;border-right:none">
                <table class="tQna_Insert">
                    <caption>
                        <h1 class="blind">검색 필터 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:130px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textC">상품분류</th>
                            <td id="td_goods_select_ctg">
                                <div class="select_box28" style="width:120px;margin-right:5px;display:inline-block">
                                    <label for="sel_ctg_1">1차 카테고리</label>
                                    <select class="select_option" name="searchCtg1" id="sel_ctg_1">
                                        <option selected="selected" value="">1차 카테고리</option>
                                    </select>
                                </div>
                                <div class="select_box28" style="width:120px;margin-right:5px;display:inline-block">
                                    <label for="sel_ctg_2">2차 카테고리</label>
                                    <select class="select_option" name="searchCtg2" id="sel_ctg_2">
                                        <option selected="selected" value="">2차 카테고리</option>
                                    </select>
                                </div>
                                <div class="select_box28" style="width:120px;margin-right:5px;display:inline-block">
                                    <label for="sel_ctg_3">3차 카테고리</label>
                                    <select class="select_option" name="searchCtg3" id="sel_ctg_3">
                                        <option selected="selected" value="">3차 카테고리</option>
                                    </select>
                                </div>
                                <div class="select_box28" style="width:120px;margin-right:5px;display:inline-block">
                                    <label for="sel_ctg_4">4차 카테고리</label>
                                    <select class="select_option" name="searchCtg4" id="sel_ctg_4">
                                        <option selected="selected" value="">4차 카테고리</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th class="textC">검색조건</th>
                            <td>
                                <div class="select_box28" style="width:198px;display:inline-block">
                                    <label for="select_option">선택하세요.</label>
                                    <select class="select_option" title="select option" id="searchType" name="searchType">
                                        <option selected="selected" value="0">선택하세요.</option>
                                        <option value="1">상품명</option>
                                        <option value="2">브랜드</option>
                                        <option value="3">모델명</option>
                                        <option value="4">제조사</option>
                                    </select>
                                </div>
                                <input type="text" id="searchWord" name="searchWord" style="width:61.8%;margin-left:10px">
                            </td>
                        </tr>
                        <tr>
                            <th class="textC">판매가격대</th>
                            <td>
                                <input type="text" id="searchPriceFrom" name="searchPriceFrom" style="width:188px"> ~
                                <input type="text" id="searchPriceTo" name="searchPriceTo" style="width:188px">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </li>
            <li style="width:14.28%" class="textC">
                <button type="button" class="btn_category_search" style="margin:32px 0 7px">검색</button>
                <button type="button" class="btn_category_search_reset">검색초기화</button>
            </li>
        </ul>
        <!---// 검색 필터 영역 --->

        <div style="height: 18px;"></div>
        <!--- 카테고리 상품영역 --->
        <div class="category_middle">
            <h3 class="category_middle_stit">
                총 <em>${resultListModel.filterdRows}</em>개의 상품이 있습니다.
            </h3>
            <div class="category_product_menu">
                <ul class="product_menu_list_left">
                    <li><a href="javascript:chang_sort('01');" <c:if test="${so.sortType eq '01'}">class='selected'</c:if>>인기순</a></li>
                    <li><a href="javascript:chang_sort('02');" <c:if test="${so.sortType eq '02'}">class='selected'</c:if>>신상품순</a></li>
                    <li><a href="javascript:chang_sort('03');" <c:if test="${so.sortType eq '03'}">class='selected'</c:if>>낮은가격</a></li>
                    <li><a href="javascript:chang_sort('04');" <c:if test="${so.sortType eq '04'}">class='selected'</c:if>>높은가격순</a></li>
                </ul>
                <ul class="product_menu_view_select">
                    <li class="btn_view_image <c:if test='${so.displayTypeCd eq "01"}'>selected</c:if>" rel="tab1" onclick="chang_dispType('01');">
                    <span class="icon_view_image"></span>이미지보기
                    </li>
                    <li class="btn_view_image <c:if test='${so.displayTypeCd eq "02"}'>selected</c:if>" rel="tab2" onclick="chang_dispType('02');">
                    <span class="icon_view_list"></span>리스트보기
                    </li>
                    <li>
                        <div class="select_box" style="width:120px">
                            <label for="view_count">10개씩 보기</label>
                            <select class="select_option" title="select option" id="view_count" name="view_count">
                                <option <c:if test="${so.rows eq '20'}">selected="selected"</c:if> value="20">20개씩 보기</option>
                                <option <c:if test="${so.rows eq '50'}">selected="selected"</c:if> value="50">50개씩 보기</option>
                            </select>
                        </div>
                    </li>
                </ul>
            </div>
            <c:choose>
                <c:when test="${resultListModel.resultList ne null}">
                    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
                </c:when>
                <c:otherwise>
                    <p class="no_blank" style="padding:50px 0 50px 0;">등록된 상품이 없습니다.</p>
                </c:otherwise>
            </c:choose>
            <!---- 페이징 ---->
            <div class="tPages" id="div_id_paging">
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!----// 페이징 ---->
        </div>
        </form:form>
        <!---// 카테고리 상품영역 --->
    </div>
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
    <!--// 상품이미지 미리보기 팝업 -->
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
    <!---// popup 장바구니 등록성공 --->

    <!---// contents --->
    </div>
    </t:putAttribute>
</t:insertDefinition>