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
	//카테고리 더보기 버튼클릭
    $('.btn_more_category').on('click',function(){
		$("[id^='sub_category_']").show();
		$(this).hide();
        $(".btn_close_category").show();

    });
    $('.btn_close_category').on('click',function(){

        $("[id^='sub_category_']").each(function(){
        	var rownum = $(this).attr("id").split('_')[2];
        	if(rownum >2){
                $(this).hide();
        	}

        })
        $(this).hide();
        $(".btn_more_category").show();
    });
    
});
</script>

<c:if test="${so.ctgLvl =='1'}">
<!-- 2depth category -->
	<div class="brand_top">
		<ul class="brand_top_slider img_area">
			<%-- <li><img src="${_SKIN_IMG_PATH}/product/category_brand_img.jpg" alt=""></li> --%>
			<c:if test="${category_banner.resultList ne null && fn:length(category_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${category_banner.resultList}" varStatus="status">
	                <li>
	                <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
	                <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
	                </a>
	                </li>
                </c:forEach>
            </c:if>       
		</ul>
		<div class="sub_visual_control">
			<c:if test="${category_banner.resultList ne null && fn:length(category_banner.resultList) gt 0}">
			<button type="button" class="btn_sub_slider_prev">이전으로</button>
			<button type="button" class="btn_sub_slider_next">다음으로</button>
			</c:if>
		</div>
	</div>

	<!-- 카테고리별 링크 추가 -->
	<!-- 아이웨어(432), 안경테(1), 안경렌즈(3), 선글라스(2), 콘택트렌즈(4) 카테고리별 노출-->
	<c:if test="${so.ctgNo eq '1' or so.ctgNo eq '2' or so.ctgNo eq '3' or so.ctgNo eq '4' or so.ctgNo eq '432'}">
	<ul class="category_btm">
        <c:if test="${so.ctgNo eq '1' or so.ctgNo eq '3' or so.ctgNo eq '432'}">
			<li><a href="${_MOBILE_PATH}/front/vision2/vision-check"><i class="icon_btm01"></i>안경렌즈 추천</a></li> <%--아이웨어, 안경테, 안경렌즈, 선글라스 에서만--%>
        </c:if>

        <c:if test="${so.ctgNo eq '4'}">
			<li><a href="${_MOBILE_PATH}/front/vision2/vision-check"><i class="icon_btm01"></i>콘택트렌즈 추천</a></li><%--콘택트렌즈 에서만--%>
        </c:if>

        <c:if test="${so.ctgNo eq '2'}">
			<li><a href="javascript:Dmall.LayerUtil.alert('준비중인 서비스입니다.');"><i class="icon_btm01"></i>렌즈 추천</a></li><%--콘택트렌즈 에서만--%>
        </c:if>

		<c:choose>
			<c:when test="${so.ctgNo eq '4'}">
				<li><a href="javascript:go_contact_wear();"><i class="icon_btm04"></i>렌즈착용샷</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="${_MOBILE_PATH}/front/search/category?ctgNo=426"><i class="icon_btm02"></i>매장 픽업</a></li>
			</c:otherwise>
		</c:choose>
		<li><a href="${_MOBILE_PATH}/front/visit/visit-welcome"><i class="icon_btm03"></i>매장 예약</a></li>
	</ul>
	</c:if>
	 <!-- 카테고리별 노출 -->


	<c:if test="${category_info.navigExpsYn == 'Y' and so.wearYn ne 'Y'}">
		<c:set value="0" var="totRow" />
		<ul class="sub_category_list">
			<c:forEach var="ctgList" items="${lnb_info.get('0')}" varStatus="vstatus">
				<c:if test="${ctgList.ctgNo eq so.ctgNo}">
					<c:set var="rownum" value="1"/>
					<c:forEach var="ctgList_1" items="${lnb_info.get(ctgList.ctgNo)}" varStatus="status">

						<li id="sub_category_${rownum}" <c:if test="${rownum >2}">style="display:none;"</c:if>><a href="javascript:move_category('${ctgList_1.ctgNo}');">${ctgList_1.ctgNm}</a></li>
						<c:if test="${(status.index+1)%2 eq 0}">
							<c:set var="rownum" value="${rownum+1}"/>
						</c:if>
						<c:set value="${totRow+1}" var="totRow" />
					</c:forEach>
				</c:if>
			</c:forEach>
		</ul>
		<c:if test="${totRow > 4 }">
			<div class="btn_more_category">
				<a href="javascript:;">더보기<i></i></a>
			</div>
			<div class="btn_close_category" style="display: none;">
				<a href="javascript:;">닫기<i></i></a>
			</div>
		</c:if>
	</c:if>
	<c:if test="${category_info.ctgMainUseYn eq 'Y'}">
		<div class="mid_banner_area">
				${category_info.content}
		</div>
	</c:if>

<!--// 2depth category -->
</c:if>

<c:if test="${so.ctgLvl =='2'}">
<!-- 3depth category -->
<div class="brand_category">
		<p class="name">${category_info.ctgNm}</p>
		<select id="selCategoryHead" class="floatR">
			<option value="${so.upCtgNo}">선택</option>
			<c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status">
			<option value="${ctgList.ctgNo}">${ctgList.ctgNm}</option>
			</c:forEach>
		</select>
</div>
	<c:if test="${category_info.ctgMainUseYn eq 'Y' and so.searchAll ne 'all'}">
		<div class="mid_banner_area">
				${category_info.content}
		</div>
	</c:if>

<!-- //brand_category -->
<!--// 3depth category -->
</c:if>
<c:if test="${so.ctgLvl =='3'}">
	<c:if test="${category_info.ctgMainUseYn eq 'Y'}">
		<div class="mid_banner_area">
				${category_info.content}
		</div>
	</c:if>
	<div class="brand_category">
		<p class="name">${category_info.ctgNm}</p>
	</div>
    <%--<div class="category_middle">
        <!-- 4depth category -->
        <ul class="gategory_menu">
	    	<c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status">
				<c:if test="${status.index == 0}">
					<li><a href="javascript:move_category('${so.upCtgNo}');">전체</a></li>
				</c:if>
				<li><a href="javascript:move_category('${ctgList.ctgNo}');">${ctgList.ctgNm}</a></li>
	    	</c:forEach>
		</ul>
        <!--// 4depth category -->
    </div>--%>
	<%--<div class="brand_category">
		<p class="name">${category_info.ctgNm}</p>
		<select id="selCategoryHead" class="floatR">
			<option value="${so.upCtgNo}">전체</option>
			<c:forEach var="ctgList" items="${lnb_info.get(so.ctgNo)}" varStatus="status" end="7">
				<option value="${ctgList.ctgNo}">${ctgList.ctgNm}</option>
			</c:forEach>
		</select>
	</div>--%>
</c:if>