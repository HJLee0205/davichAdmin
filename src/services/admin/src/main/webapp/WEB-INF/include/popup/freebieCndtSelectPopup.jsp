<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!-- <script src="/admin/js/common.js" charset="utf-8"></script> -->

<!-- layer_popup1 -->
<div id="layer_popup_freebie_select" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">사은품검색</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <form:form id="form_id_pop_search_freebie" >
        <input type="hidden" name="page" id="freebie_hd_pop_page" value="1" />
        <input type="hidden" name="sord" id="freebie_hd_pop_srod" value="" />
        <input type="hidden" name="rows" id="freebie_hd_pop_rows" value="" />
        <input type="hidden" name="isPromotion" value="Y" />
        <div class="pop_con">
            <div>
                <!-- search_box -->
                <div class="search_box">
                    <!-- search_tbl -->
                    <div class="search_tbl">
                        <table summary="이표는 사은품검색 검색 표 입니다. 구성은 카테고리, 판매가격, 판매상태, 전시상태, 검색어 입니다.">
                            <caption>사은품검색 검색</caption>
                            <colgroup>
                                <col width="15%">
                                <col width="85%">
                            </colgroup>
                            
                            <tbody id="tbody_pop_freebie_select">
                                <tr>
                                    <th>검색어</th>
                                    <td>
                                        <div class="select_inp">
                                            <span>
                                                <label for="sel_search_type"></label>
                                                <select name="searchType" id="sel_search_type" >
                                                    <tags:option codeStr="1:사은품명;2:사은품번호" />
                                                </select>
                                            </span>
                                            <input type="text" name="searchWord" id="txt_search_word" value=""/>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //search_tbl -->
                    <div class="btn_box txtc">
                        <button type="button" class="btn green" id="btn_popup_freebie_search">검색</button>
                    </div>
                </div>
                <!-- //search_box -->
                <!-- tblh -->
                <div class="tblh tblmany line_no">
                    <table summary="이표는 사은품검색 리스트 표 입니다. 구성은 사은품명, 판매가격, 판매상태, 등록 입니다.">
                        <caption>사은품검색 리스트</caption>
                        <colgroup>
                            <col width="16%">
                            <col width="70%">
                            <col width="14%">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>이미지</th>
                                <th>사은품명</th>
                                <th>등록</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_popup_freebie_data">
                            <tr id="tr_popup_freebie_data_template" >
                                <td class="txtl" data-bind="popFreebieInfo" data-bind-value="freebieNm" data-bind-type="function" data-bind-function="FreebieSelectPopup.setFreebieDetail">
                                    <img id="td_popup_freebie_detail_template" src="" width="52" height="52" alt="사은품이미지" />
                                </td>
                                <td data-bind="popFreebieInfo" data-bind-value="freebieNo" data-bind-type="function" data-bind-function="FreebieSelectPopup.setFreebieSelect"><a href="#none" class="btn_blue">등록</a></td>
                            </tr>
                            <tr id="tr_popup_no_freebie_data"><td colspan="4">데이터가 없습니다.</td></tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <div class="pageing"  id="div_id_pop_paging_freebie">
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