<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
$(document).ready(function(){
    //검색버튼 클릭
    $('.btn_category_search').on('click',function(){
        category_search();
    });
    //검색초기화버튼 클릭
    $('.btn_category_search_reset').on('click',function(){
        var checkObj = $("input[type='checkbox'");
        checkObj.prop("checked",false);
    });

    $('#brand_check_all').bind('click',function (){
        if($('#brand_check_all').is(':checked')) {
            $('input[name=searchBrands]:checkbox').each(function(){
               $(this).prop('checked', true);
            });
        }else{
            $('input[name=searchBrands]:checkbox').each(function(){
                $(this).prop('checked', false);
             });
        }
    });
});
</script>
<!-- 1차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='1'}">
    <div class="category_middle">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="category_banner">
                ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.navigExpsYn == 'Y'}">
        <ul class="category_step1">
            <c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status">
                <c:if test="${ctgList.ctgNo eq so.ctgNo}">
                    <c:forEach var="ctgList_1" items="${lnb_info.get(ctgList.ctgNo)}" varStatus="status">
                        <li>
                            <span class="title cursorP" onclick="move_category('${ctgList_1.ctgNo}');">${ctgList_1.ctgNm}</span>
                            <ul>
                            <c:set var="totalCnt" value="0"/>
                            <c:forEach var="ctgList_2" items="${lnb_info.get(ctgList_1.ctgNo)}" varStatus="status" end="12">
                                <c:set var="totalCnt" value="${totalCnt+1}"/>
                                <li><a href="javascript:move_category('${ctgList_2.ctgNo}')">${ctgList_2.ctgNm}</a></li>
                            </c:forEach>
                            <c:if test="${totalCnt%6 != 0}">
                                <c:forEach var="emptyAdd" begin="1" varStatus="status" end="${6-(totalCnt%6)}"><li><span></span></li></c:forEach>
                            </c:if>
                            <c:if test="${totalCnt == 0}">
                                <c:forEach begin="1" end="6"><li><span></span></li></c:forEach>
                            </c:if>
                            </ul>
                        </li>
                    </c:forEach>
                </c:if>
            </c:forEach>
        </ul>
        </c:if>
    </div>
</c:if>
<!--// 1차 카테고리 검색필터 -->


<!-- 2차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='2'}">
    <div class="category_middle">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="category_banner">
                ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.navigExpsYn == 'Y'}">
        <ul class="category_step2">
            <c:set var="totalCnt" value="0"/>
            <c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status" end="7">
                <c:set var="totalCnt" value="${totalCnt+1}"/>
                <li><a href="javascript:move_category('${ctgList.ctgNo}')">${ctgList.ctgNm}</a></li>
            </c:forEach>
            <c:if test="${totalCnt%7 != 0}">
                <c:forEach var="emptyAdd" begin="1" varStatus="status" end="${7-(totalCnt%7)}"><li><span></span></li></c:forEach>
            </c:if>
            <c:if test="${totalCnt == 0}">
                <c:forEach begin="1" end="7"><li><span></span></li></c:forEach>
            </c:if>
        </ul>
        </c:if>
        <!-- //카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
    </div>
</c:if>
<!--// 2차 카테고리 검색필터 -->


<!-- 3차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='3'}">
    <div class="category_middle">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="category_banner">
                ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.navigExpsYn == 'Y'}">
        <ul class="category_step2">
            <c:set var="totalCnt" value="0"/>
            <c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status">
                <c:set var="totalCnt" value="${totalCnt+1}"/>
                <li><a href="javascript:move_category('${ctgList.ctgNo}')">${ctgList.ctgNm}</a></li>
            </c:forEach>
            <c:if test="${totalCnt%7 != 0}">
            <c:forEach var="emptyAdd" begin="1" varStatus="status" end="${7-(totalCnt%7)}"><li><span></span></li></c:forEach>
            </c:if>
            <c:if test="${totalCnt == 0}">
                <c:forEach begin="1" end="7"><li><span></span></li></c:forEach>
            </c:if>
        </ul>
        <table class="category_step3">
            <colgroup>
                <col style="width:14.28%">
                <col style="">
                <col style="width:14.28%">
            </colgroup>
            <tbody>
            <tr>
                <th>
                    <div class="category_check_all">
                        <label>
                            <input type="checkbox" id="brand_check_all">
                            <span></span>
                        </label>
                        <label for="category_check">브랜드 전체</label>
                    </div>
                </th>
                <td>
                    <c:forEach var="brandList" items="${brand_list}" varStatus="status">
                    <div class="category_check">
                        <label>
                            <input type="checkbox" id="searchBrands" name="searchBrands" value="${brandList.brandNo}"
                                <c:forEach var="selectbrandList" items="${so.searchBrands}" varStatus="status">
                                <c:if test="${brandList.brandNo eq selectbrandList }">checked="checked"</c:if>
                                </c:forEach>
                            >
                            <span></span>
                        </label>
                        <label for="category_check">${brandList.brandNm}</label>
                    </div>
                    </c:forEach>
                </td>
                <td rowspan="2" class="textC">
                    <button type="button" class="btn_category_search" style="margin-bottom:7px">검색</button>
                    <button type="button" class="btn_category_search_reset">검색초기화</button>
                </td>
            </tr>
        </table>
        </c:if>
        <!-- //카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
    </div>
</c:if>
<!--// 3차 카테고리 검색필터 -->


<!-- 4차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='4'}">
    <div class="category_middle">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="category_banner">
                ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.navigExpsYn == 'Y'}">
        <ul class="category_step2">
            <c:set var="totalCnt" value="0"/>
            <c:forEach var="ctgList" items="${lnb_info.get(so.upCtgNo)}" varStatus="status">
                <c:set var="totalCnt" value="${totalCnt+1}"/>
                <li><a href="javascript:move_category('${ctgList.ctgNo}')">${ctgList.ctgNm}</a></li>
            </c:forEach>
            <c:if test="${totalCnt%7 != 0}">
            <c:forEach var="emptyAdd" begin="1" varStatus="status" end="${7-(totalCnt%7)}"><li><span></span></li></c:forEach>
            </c:if>
            <c:if test="${totalCnt == 0}">
                <c:forEach begin="1" end="7"><li><span></span></li></c:forEach>
            </c:if>
        </ul>
        <table class="category_step3">
            <colgroup>
                <col style="width:14.28%">
                <col style="">
                <col style="width:14.28%">
            </colgroup>
            <tbody>
            <tr>
                <th>
                    <div class="category_check_all">
                        <label>
                            <input type="checkbox" id="brand_check_all">
                            <span></span>
                        </label>
                        <label for="category_check">브랜드 전체</label>
                    </div>
                </th>
                <td>
                    <c:forEach var="brandList" items="${brand_list}" varStatus="status">
                    <div class="category_check">
                        <label>
                            <input type="checkbox" id="searchBrands" name="searchBrands" value="${brandList.brandNo}"
                                <c:forEach var="selectbrandList" items="${so.searchBrands}" varStatus="status">
                                <c:if test="${brandList.brandNo eq selectbrandList }">checked="checked"</c:if>
                                </c:forEach>
                            >
                            <span></span>
                        </label>
                        <label for="category_check">${brandList.brandNm}</label>
                    </div>
                    </c:forEach>
                </td>
                <td rowspan="2" class="textC">
                    <button type="button" class="btn_category_search" style="margin-bottom:7px">검색</button>
                    <button type="button" class="btn_category_search_reset">검색초기화</button>
                </td>
            </tr>
        </table>
        </c:if>
        <!-- //카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
    </div>
</c:if>
<!-- 4차 카테고리 검색필터 -->