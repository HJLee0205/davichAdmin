<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="tag" uri="http://www.springframework.org/tags/form" %>
<!-- <script src="/admin/js/common.js" charset="utf-8"></script> -->

<!-- layer_popup1 -->
<div id="layer_popup_goods_select" class="layer_popup">
    <div class="pop_wrap size4">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">상품검색</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form:form id="form_id_pop_search" >
        <input type="hidden" name="page" id="hd_pop_page" value="1" />
        <input type="hidden" name="sord" id="hd_pop_srod" value="" />
        <input type="hidden" name="rows" id="hd_pop_rows" value="" />
        <div class="pop_con">
            <div>
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 상품검색 검색 표 입니다. 구성은 카테고리, 판매가격, 판매상태, 전시상태, 검색어 입니다.">
                            <caption>상품검색 검색</caption>
                            <colgroup>
                                <col width="150px">
                                <col width="">
                            </colgroup>
                            <tbody id="tbody_pop_goods_select">
                            <tr>
                                <th>상품코드</th>
                                <td>
                                    <span class="intxt long">
                                        <input type="text" name="goodsNo" id="txt_search_goodsno" value="">
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>카테고리</th>
                                <td id="td_pop_goods_select_ctg">
                                    <span class="select">
                                        <label for="sel_pop_ctg_1">1차 카테고리</label>
                                        <select name="searchCtg1" id="sel_pop_ctg_1">
                                            <option id="opt_ctg_1_def" value="">1차 카테고리</option>
                                        </select>
                                    </span>
                                    <span class="select">
                                        <label for="sel_pop_ctg_2">2차 카테고리</label>
                                        <select name="searchCtg2" id="sel_pop_ctg_2">
                                            <option id="opt_ctg_2_def" value="">2차 카테고리</option>
                                        </select>
                                    </span>
                                    <span class="select">
                                        <label for="sel_pop_ctg_3">3차 카테고리</label>
                                        <select name="searchCtg3" id="sel_pop_ctg_3">
                                            <option id="opt_ctg_3_def" value="">3차 카테고리</option>
                                        </select>
                                    </span>
                                    <span class="select">
                                        <label for="sel_pop_ctg_4">4차 카테고리</label>
                                        <select name="searchCtg4" id="sel_pop_ctg_4">
                                            <option id="opt_ctg_4_def" value="">4차 카테고리</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 유형</th>
                                <td>
                                    <tags:checkbox id="chk_search_normalyn" name="normalYn" value="Y" compareValue="" text="일반"/>
                                    <tags:checkbox id="chk_search_newgoodsyn" name="newGoodsYn" value="Y" compareValue="" text="신상품"/>
                                    <tags:checkbox id="chk_search_mallorderyn" name="mallOrderYn" value="Y" compareValue="" text="웹발주용"/>
                                    <tags:checkbox id="chk_search_stampyn" name="stampYn" value="Y" compareValue="" text="스탬프"/>
                                </td>
                            </tr>
                            <tr>
                                <th>판매가격</th>
                                <td>
                                    <span class="intxt"><input type="text" name="searchPriceFrom" id="txt_pop_search_price_from" value="" class="txtr comma" maxlength="10"/></span> 원
                                    ~
                                    <span class="intxt"><input type="text" name="searchPriceTo" id="txt_pop_search_price_to" value="" class="txtr comma" maxlength="10"/></span> 원
                                </td>
                            </tr>
                            <tr>
                                <th>판매상태</th>
                                <td id="tb_goods_status">
                                    <code:checkboxUDV codeGrp="GOODS_SALE_STATUS_CD" name="goodsStatus" idPrefix="chk_goods_status" usrDfn1Val="DISP" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th>판매자</th>
                                <td>
                                    <span class="select">
                                        <label for="searchSeller"></label>
                                        <select name="searchSeller" id="searchSeller">
                                            <code:sellerOption siteno="${siteNo}" includeTotal="true"/>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>전시상태</th>
                                <td id="tb_goods_display">
                                    <tags:checkboxs codeStr="Y:전시;N:미전시" name="goodsDisplay" idPrefix="chk_goods_dispyn" value="" />
                                </td>
                            </tr>
                            <tr>
                                <th>검색어</th>
                                <td>
                                    <span class="intxt w100p">
                                        <input type="hidden" name="searchType" id="hd_pop_search_type" value="5" />
                                        <input type="text" name="searchWord" id="txt_pop_search_word" placeholder="상품명 및 SEO 태그값을 입력해주세요." />
                                    </span>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button class="btn--black_small mt20 mb20" id="btn_popup_goods_search">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- tblh -->
                <div class="tblh mt20">
                    <table summary="이표는 상품검색 리스트 표 입니다. 구성은 상품명, 판매가격, 판매상태, 등록 입니다.">
                        <caption>상품검색 리스트</caption>
                        <colgroup>
                            <col width="4%">
                            <col width="6%">
                            <col width="16%">
                            <col width="12%">
                            <col width="10%">
                            <col width="10%">
                            <col width="7%">
                            <col width="7%">
                            <col width="8%">
                            <col width="10%">
                            <col width="300px">
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
                                <th>다비젼<br>상품코드</th>
                                <th>등록</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_popup_goods_data">
                        <tr id="tr_popup_goods_data_template" >
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="sortNum"></td>
                            <td class="txtl" data-bind="popGoodsInfo" data-bind-type="function" data-bind-function="GoodsSelectPopup.setGoodsDetail" data-bind-value="goodsNm">
                                <img id="td_popup_goods_detail_template" src="" width="52" height="52" alt="" />
                            </td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="goodsNm"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="goodsNo"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="brandNm"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="sellerNm"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="commanumber" data-bind-value="salePrice"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="commanumber" data-bind-value="stockQtt"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="goodsSaleStatusNm"></td>
                            <td data-bind="popGoodsInfo" data-bind-type="string" data-bind-value="erpItmCode"></td>
                            <td data-bind="popGoodsInfo" data-bind-value="goodsNo" data-bind-type="function" data-bind-function="GoodsSelectPopup.setGoodsSelect"><a href="#none" class="btn_blue">등록</a></td>
                        </tr>
                        <tr id="tr_popup_no_goods_data"><td colspan="11">데이터가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <div class="pageing"  id="div_id_pop_paging"></div>
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