<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
    
    $(function () {	
		$(".menu_area .menu li.view_layer").hover(function() {
			$(this).find('.menu_s_layer').show();
		}, function() {
			$(this).find('.menu_s_layer').hide();
		});
	});
    
});
</script>

<!-- 1차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='1'}">
    <div class="category_visual_area">
    <div class="category_left_menu">
       <%--  <a href="javascript:move_category('${so.ctgNo}', 'all');"><h2 class="sub_tit">${so.ctgNm}</h2></a> --%>
       <h2 class="sub_tit">${so.ctgNm}</h2>
        <%-- <h2 class="sub_tit">${so.ctgNm}</h2> --%>
        <div class="menu_area">
        <c:if test="${category_info.navigExpsYn == 'Y'}">
                <ul class="menu">
                    <%-- BEST 제외 --%>
	                <c:if test="${so.ctgNo ne '434'}">
					<li> <a href="javascript:move_category('${so.ctgNo}', 'all');">전체상품</a></li>
                    </c:if>
            <c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="status"> <!-- 1Depth -->
                <c:if test="${ctgList.ctgNo eq so.ctgNo}">
                    <c:forEach var="ctgList_1" items="${lnb_info.get(ctgList.ctgNo)}" varStatus="status"> <!-- 2Depth -->
                        <li <c:if test="${fn:length(lnb_info.get(ctgList_1.ctgNo)) > 0}">class="view_layer"</c:if>>
                        	<a href="javascript:move_category('${ctgList_1.ctgNo}');">${ctgList_1.ctgNm}</a>
                        	<div class="menu_s_layer" style="display:none;">
                        		<c:forEach var="ctgList_2" items="${lnb_info.get(ctgList_1.ctgNo)}" varStatus="status"> <!-- 3Depth -->
                        			<c:choose>
                        				<c:when test="${fn:length(lnb_info.get(ctgList_2.ctgNo)) > 0 or  ctgList_1.ctgLvl eq 2}">
                        					<p class="stit"><a href="javascript:move_category('${ctgList_2.ctgNo}');">${ctgList_2.ctgNm}</a></p>
                        					<c:forEach var="ctgList_3" items="${lnb_info.get(ctgList_2.ctgNo)}" varStatus="status"> <!-- 4Depth -->
                        						<a href="javascript:move_category('${ctgList_3.ctgNo}');">${ctgList_3.ctgNm}</a>
                        					</c:forEach>
                        				</c:when>
                        				<c:otherwise>
                        					<a href="javascript:move_category('${ctgList_2.ctgNo}');">${ctgList_2.ctgNm}</a>
                        				</c:otherwise>
                        			</c:choose>
                        			
                        			
                        		</c:forEach>
                        	</div>
                        </li>
                    <%--<c:forEach var="ctgList_2" items="${lnb_info.get(ctgList_1.ctgNo)}" varStatus="status" end="12">
                        <c:set var="totalCnt" value="${totalCnt+1}"/>
                    <li><a href="javascript:move_category('${ctgList_2.ctgNo}')">${ctgList_2.ctgNm}</a></li>
                    </c:forEach>--%>
                    </c:forEach>
                </c:if>
            </c:forEach>
					<%--<li class="time_event"><a href="/front/promotion/promotion-detail?prmtNo=25">★ 비비엠아이웨어 30% 이벤트</a></li><!-- 이벤트 메뉴 -->--%>
                </ul>
        </c:if>
        </div>
       <%-- <div class="bottom">
            <a href="#" class="btn_view_brand">브랜드전체</a>
            <button type="button" class="btn_recomm"><i></i>렌즈추천</button>
        </div>--%>
    </div>
        <!-- sub slider -->
        <div class="right_slider">
            <ul class="sub_visual_slider">
            <c:if test="${category_banner.resultList ne null && fn:length(category_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${category_banner.resultList}" varStatus="status">
	                <li>
	                <c:if test="${!empty resultModel.linkUrl}">
	                <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
	                </c:if>
	                <c:if test="${empty resultModel.linkUrl}">
	                <a href="#">
	                </c:if>
	                <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
	                <%-- <img src="${_SKIN_IMG_PATH}/product/sub_visual_banner01.jpg" alt=""></a> --%>
	                </a>	                
	                </li>
                </c:forEach>
            </c:if>            
            </ul>
            <div class="sub_visual_control">
                <button type="button" class="btn_sub_slider_prev">이전으로</button>
                <button type="button" class="btn_sub_slider_next">다음으로</button>
            </div>
        </div>
        <!--// sub slider -->
    </div>	

	<!-- 아이웨어(432), 안경테(1), 안경렌즈(3), 선글라스(2), 콘택트렌즈(4) 카테고리별 노출-->
	<c:if test="${so.ctgNo eq '1' or so.ctgNo eq '2' or so.ctgNo eq '3' or so.ctgNo eq '4' or so.ctgNo eq '432'}">
	<ul class="category_btm <c:if test="${so.ctgNo ne '4'}">w3</c:if>">
        <c:if test="${so.ctgNo eq '1' or so.ctgNo eq '3' or so.ctgNo eq '432'}">
		<li><a href="/front/vision2/vision-check"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner01.gif" alt="DAVICH 큐레이팅 내눈에 딱! 안경렌즈 추천 받기"></a></li> <%--아이웨어, 안경테, 안경렌즈, 선글라스 에서만--%>
        </c:if>

        <c:if test="${so.ctgNo eq '4'}">
		<li><a href="/front/vision2/vision-check"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner04.gif" alt="DAVICH 큐레이팅 내눈에 딱! 콘택트렌즈 추천 받기"></a></li><%--콘택트렌즈 에서만--%>
		<li><a href="javascript:go_contact_wear();"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner06.gif" alt="DAVICH STORE 다비치안경 매장 예약하기"></a></li>
        </c:if>

        <c:if test="${so.ctgNo eq '2'}">
		<li><a href="javascript:Dmall.LayerUtil.alert('준비중인 서비스입니다.');"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner05.gif" alt="DAVICH 큐레이팅 내눈에 딱! 렌즈 추천 받기"></a></li><%--콘택트렌즈 에서만--%>
        </c:if>

		<li><a href="/front/search/category?ctgNo=426"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner02.gif" alt="DAVICH DDS 매장 픽업 제품 한 눈에 보기"></a></li>
		<li><a href="/front/visit/visit-welcome"><img src="${_SKIN_IMG_PATH}/product/category_btm_banner03.gif" alt="DAVICH STORE 다비치안경 매장 예약하기"></a></li>
	</ul>
	</c:if>
	 <!-- 카테고리별 노출 -->

    <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
        <div class="mid_banner_area">
                ${category_info.content}
                <%--<a href="#" class="floatL"><img src="${_SKIN_IMG_PATH}/main/mid_banner01.gif" alt="배너1"></a>
                <a href="#" class="floatR"><img src="${_SKIN_IMG_PATH}/main/mid_banner02.gif" alt="배너2"></a>--%>
        </div>
    </c:if>

</c:if>
<!--// 1차 카테고리 검색필터 -->


<!-- 2차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='2'}">
    <div class="brand_top">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y' and so.searchAll ne 'all'}">
            <div class="img_area">
                ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->

        <div class="brand_category">
            <p class="name">${category_info.ctgNm}</p>
            <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
            <c:if test="${category_info.navigExpsYn == 'Y'}">
            <ul class="menu">
                <c:set var="totalCnt" value="0"/>
<%--                 <c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status" end="7"> --%>
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
            </c:if>
            <!-- //카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        </div>
    </div>

</c:if>
<!--// 2차 카테고리 검색필터 -->


<!-- 3차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='3'}">
    <div class="brand_top">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="img_area">
                    ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->

        <div class="brand_category">
            <p class="name">${category_info.ctgNm}</p>
            <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
            <c:if test="${category_info.navigExpsYn == 'Y'}">
                <ul class="menu">
                    <c:set var="totalCnt" value="0"/>
<%--                     <c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status" end="7"> --%>
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
            </c:if>
            <!-- //카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
        </div>
    </div>
    <%--<div class="category_middle">
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
    </div>--%>


</c:if>
<!--// 3차 카테고리 검색필터 -->


<!-- 4차 카테고리 검색필터 -->
<c:if test="${so.ctgLvl =='4'}">
    <div class="brand_top">
        <!-- 카테고리 배너(설정에 따라 노출여부 구분됨) -->
        <c:if test="${category_info.ctgMainUseYn eq 'Y'}">
            <div class="img_area">
                    ${category_info.content}
            </div>
        </c:if>
        <!--// 카테고리 배너(설정에 따라 노출여부 구분됨) -->

        <div class="brand_category">
            <p class="name">${category_info.ctgNm}</p>
            <!-- 카테고리 목록 (카테고리 설정에 따라 노출여부 구분됨) -->
            <c:if test="${category_info.navigExpsYn == 'Y'}">
                <ul class="menu">
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
    </div>
    <%--<div class="category_middle">
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
    </div>--%>
</c:if>
<!-- 4차 카테고리 검색필터 -->