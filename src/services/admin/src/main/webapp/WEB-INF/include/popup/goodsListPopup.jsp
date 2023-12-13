<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!-- <script src="/admin/js/common.js" charset="utf-8"></script> -->

<!-- layer_popup1 -->
<div id="layer_popup_goods_list" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">상품 목록</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form:form id="form_id_pop_search" >
        <input type="hidden" name="page" id="hd_pop_page" value="1" />
        <input type="hidden" name="sord" id="hd_pop_srod" value="" />
        <input type="hidden" name="rows" id="hd_pop_rows" value="" />
        <input type="hidden" id="url" value="" />
        <div class="pop_con">
            <div>
                <!-- tblh -->
                <div class="tblh">
                    <table summary="이표는 판매상품목록 리스트 표 입니다. 구성은  번호, 카테고리, 상품명, 판매가, 재고/가용, 배송비, 판매상태, 전시상태, 관리 입니다.">
                        <caption>판매상품관리 리스트</caption>
                        <colgroup>
                            <col width="66px">
                            <col width="200px">
                            <col width="20%">
                            <col width="15%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
                            <col width="7%">
                            <col width="7%">
                            <col width="7%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>이미지</th>
                                <th>상품명</th>
                                <th>상품코드</th>
                                <th>브랜드</th>
                                <th>판매자</th>
                                <th>판매가</th>
                                <th>재고</th>
                                <th>판매상태</th>
                                <th>다비전 <br>상품코드</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_popup_goods_list">
                            <tr id="tr_popup_goods_list_template" >
                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="rownum" ></td>
                                <td><img src="" data-bind="popGoodsInfo" data-bind-type="img" data-bind-value="goodsImg02"></td>

                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="brandNm" ></td>
                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="sellerNm" ></td>
                                <td data-bind="popGoodsInfo" data-bind-type="function" data-bind-function="GoodsListPopup.setSalePrice"  data-bind-value="salePrice" maxlength="10"></td>
                                <td data-bind="popGoodsInfo" data-bind-type="function" data-bind-function="GoodsListPopup.setStockQtt" data-bind-value="stockQtt" maxlength="4"></td>
                                <td data-bind="popGoodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="GoodsListPopup.setGoodsStatusText">
                                    <input type="hidden" data-bind="popGoodsInfo" data-bind-value="goodsSaleStatusCd" data-bind-type="function" data-bind-function="GoodsListPopup.setGoodsStatusInput">
                                </td>
                                <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                            </tr>
                            <tr id="tr_popup_no_goods_list"><td colspan="10">데이터가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <div class="pageing"  id="div_id_pop_list_paging">
                    </div>
                    <!-- //pageing -->
                </div>
                <!-- //bottom_lay -->
            </div>
        </div>
        </form:form>
        <!-- //pop_con -->
    </div>
</div>
<!-- //layer_popup1 -->