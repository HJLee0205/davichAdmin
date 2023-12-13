<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<script>
    $(document).ready(function() {
        //$(".product_list_typeB").hide();
        $(".product_list_typeB:first").show();
        $("div.category_MD_menu a:first").addClass("active");
        $("div.category_MD_menu a:first").css('display', 'inline');
        $("div.category_MD_menu a:first").trigger("click");

        $("div.category_MD_menu a").click(function () {
            $("div.category_MD_menu a").removeClass("active");
            $(this).addClass("active");
            $(".product_list_typeB").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });

        $(".btn_product_bb_prev").click(function () {
        	
        	var tot_cnt = $('div.category_MD_menu a').length;
        	var _this = $('div.category_MD_menu').find('a.active');
        	var this_idx = $('div.category_MD_menu a').index(_this);
        	var prev_idx = this_idx-1;
        	
        	if(this_idx == 0){
        		prev_idx = tot_cnt-1;
        	}
        	
        	$("div.category_MD_menu a:eq("+prev_idx+")").show();
            $("div.category_MD_menu a:eq("+prev_idx+")").trigger("click");
            $("div.category_MD_menu a:eq("+this_idx+")").hide();
        });

        $(".btn_product_bb_next").click(function () {
        	
        	var tot_cnt = $('div.category_MD_menu a').length;
        	var _this = $('div.category_MD_menu').find('a.active');
        	var this_idx = $('div.category_MD_menu a').index(_this);
        	var next_idx = this_idx+1;
        	
        	if(tot_cnt == next_idx){
        		next_idx = 0;
        	}
        	
        	$("div.category_MD_menu a:eq("+next_idx+")").show();
            $("div.category_MD_menu a:eq("+next_idx+")").trigger("click");
            $("div.category_MD_menu a:eq("+this_idx+")").hide();
        });

    });

</script>
<!-- 1차 카테고리 -->

<c:if test="${so.ctgLvl =='1'}">
    <div class="category_MD_menu">
    	<c:if test="${fn:length(category_list) > 1}">
        <button type="button" class="btn_product_bb_prev">이전으로</button>
        <button type="button" class="btn_product_bb_next">다음으로</button>
        </c:if>
        <c:forEach var="category_list" items="${category_list}" varStatus="ctgstatus">
            <c:if test="${category_list.ctgExhbtionTypeCd eq '2'}">
                <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${category_list.ctgDispzoneImgPath}_${category_list.ctgDispzoneImgNm}" />
            </c:if>
            <c:if test="${category_list.ctgExhbtionTypeCd eq '1'}">
                <a href="javascript:;" rel="md_menu_${category_list.ctgDispzoneNo}" style="display: none;">${category_list.dispzoneNm}</a>
            </c:if>
        </c:forEach>

    </div>
    <!-- 상품목록(바둑판형) -->
    <c:forEach var="category_list" items="${category_list}" varStatus="status">
        <ul class="product_list_typeB" id="md_menu_${category_list.ctgDispzoneNo}" style="display: none;">
            <c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
            <c:set var="list" value="${requestScope.get(goods_list)}" />
            <data:goodsList value="${list}" displayTypeCd="05" headYn="N"/>
        </ul>
    </c:forEach>
    <!--// 상품목록(바둑판형) -->

</c:if>
<!--// 1차 카테고리  -->
<c:if test="${so.ctgLvl =='2'}">
<script>
    $(document).ready(function() {
        $(".btn_count_open").hide();
        $(".btn_count_close").click(function () {
            $(this).hide();
            $(this).parents('h3').next("ul.category_bb").slideUp("100");
            $(this).next(".btn_count_open").show();
        });

        $(".btn_count_open").click(function () {
            $(this).hide();
            $(this).parents('h3').next("ul.category_bb").slideDown("100");
            $(this).prev(".btn_count_close").show();
        });
    });

</script>
<!-- 전시존  -->
<div class="category_best">
    <c:forEach var="category_list" items="${category_list}" varStatus="status">
        <h3 class="category_mid_tit">
            <c:if test="${category_list.ctgExhbtionTypeCd eq '2'}">
                <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${category_list.ctgDispzoneImgPath}_${category_list.ctgDispzoneImgNm}" />
            </c:if>
            <c:if test="${category_list.ctgExhbtionTypeCd eq '1'}">
                ${category_list.dispzoneNm}
            </c:if>
            <!-- <button type="button" class="btn_count_close">접기<i></i></button>
            <button type="button" class="btn_count_open">열기<i></i></button> -->
        </h3>
		
        <c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
        <c:set var="list" value="${requestScope.get(goods_list)}" />
        <div class="cont_body">
		<ul class="category_bb">
            <data:goodsList value="${list}" displayTypeCd="06" headYn="N" iconYn="N" topYn="N"/>
        </ul>
		</div>
    </c:forEach>
</div>
<!--// 전시존 -->
</c:if>