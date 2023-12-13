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
    <%@ include file="/WEB-INF/views/category/search_list_js.jsp" %>
    <!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">
        <div class="mypage_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            검색결과
        </div>
        
        <!--- 검색 필터 영역 --->
        <form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />
        <form:hidden path="rows" id="rows" />
        <form:hidden path="sortType" id="sortType" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />

        <!--- 검색 필터 영역 --->                               
        <div class="myshopping_all_view_area">  
            <ul class="my_order_detail">
                <li>
                    <span class="title">상품분류(1차)</span>
                    <p class="detail">
                        <select name="searchCtg1" id="sel_ctg_1">
                            <option selected="selected" value="">1차 카테고리</option>
                        </select>
                    </p>
                </li>
                <li>
                    <span class="title">상품분류(2차)</span>
                    <p class="detail">
                        <select name="searchCtg2" id="sel_ctg_2">
                            <option selected="selected" value="">2차 카테고리</option>
                        </select>
                    </p>
                </li>
                <li>
                    <span class="title">상품분류(3차)</span>
                    <p class="detail">
                        <select name="searchCtg3" id="sel_ctg_3">
                            <option selected="selected" value="">3차 카테고리</option>
                        </select>
                    </p>
                </li>
                <li>
                    <span class="title">상품분류(4차)</span>
                    <p class="detail">
                        <select name="searchCtg4" id="sel_ctg_4">
                            <option selected="selected" value="">4차 카테고리</option>
                        </select>
                    </p>
                </li>
                
                <li>
                    <span class="title">검색조건</span>
                    <p class="detail">
                        <select id="searchType" name="searchType" style="width:calc(38%);">
                            <option value="0">선택하세요.</option>
                            <option value="1">상품명</option>
                            <option value="2">브랜드</option>
                            <option value="3">모델명</option>
                            <option value="4">제조사</option>
                        </select>
                        <input type="text" id="searchWord" name="searchWord" style="width:calc(53%);">
                    </p>
                </li>
                <li>
                    <span class="title">판매가격대</span>
                    <p class="detail">
                        <input type="text" id="searchPriceFrom" name="searchPriceFrom" style="width:calc(40%);"> 
                        <span class="txt_b">~</span> 
                        <input type="text" id="searchPriceTo" name="searchPriceTo" style="width:calc(40%);">
                    </p>
                </li>
            </ul>
            
            <div class="btn_area"><button type="button" class="btn_member_login btn_category_search" id="btn_agree">검색</button></div>
        </div>
        <!---// 검색 필터 영역 --->

        <div style="height: 18px;"></div>
        <!--- 카테고리 상품영역 --->
        <div class="list_head">
            <div class="list_selectBox">
                <span class="selected"></span>
                <span class="selectArrow"></span>
                <div class="selectOptions">
                    <span class="selectOption <c:if test="${so.sortType eq '01'}">selected</c:if>" value="인기판매순" onclick="javascript:chang_sort('01');">인기판매순</span>
                    <span class="selectOption <c:if test="${so.sortType eq '02'}">selected</c:if>" value="신상품순" onclick="javascript:chang_sort('02');">신상품순</span>
                    <span class="selectOption <c:if test="${so.sortType eq '03'}">selected</c:if>" value="낮은가격순" onclick="javascript:chang_sort('03');">낮은가격순</span>
                    <span class="selectOption <c:if test="${so.sortType eq '04'}">selected</c:if>" value="높은가격순" onclick="javascript:chang_sort('04');">높은가격순</span>
                    <span class="selectOption <c:if test="${so.sortType eq '05'}">selected</c:if>" value="상품평 많은순" onclick="javascript:chang_sort('05');">상품평 많은순</span>
                </div>
            </div>
            <div class="list_selectBox" id="list_view_selectBox">
                <span class="selected"></span>
                <span class="selectArrow"></span>
                <div class="selectOptions">
                    <span class="selectOption <c:if test='${so.displayTypeCd eq "01"}'>selected</c:if>" value="이미지보기" id="selectOption_image" rel="tab1" onclick="chang_dispType('05');"><span class="icon_imageview"></span>이미지보기</span>
                    <span class="selectOption <c:if test='${so.displayTypeCd eq "02"}'>selected</c:if>" value="리스트보기" id="selectOption_list" rel="tab2" onclick="chang_dispType('02');"><span class="icon_listview"></span>리스트보기</span>
                </div>
            </div>
        </div>
        
        <!-- 상품정보영역 -->
        <div id="div_id_detail">
        <c:choose>
            <c:when test="${resultListModel.resultList ne null}">
                <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="N"/>
            </c:when>
            <c:otherwise>
                <div style="text-align:center;margin-top: 20px;margin-bottom: 20px;">등록된 상품이 없습니다.</div>
            </c:otherwise>
        </c:choose>
        </div>
        <!-- // 상품정보영역 -->
        
        <!--- 페이징 --->
        <div class="list_bottom">
            <a href="#" class="more_view" onclick="return false;">
                30개 더보기<span class="icon_more_view"></span>
            </a>            
            <div class="list_page_view">
                <em></em> / <span id="totalPageCount"></span>
            </div>
        </div>
        <!---// 페이징 --->
        
        
        
        
        </form:form>
        <!---// 카테고리 상품영역 --->
        
    </div>
    <!---// 03.LAYOUT:CONTENTS --->
    

    </t:putAttribute>
</t:insertDefinition>