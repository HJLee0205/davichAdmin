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
<t:insertDefinition name="davichLayout">
<t:putAttribute name="title">다비치마켓 :: ${so.ctgNm}</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){

    Dmall.common.numeric();
    Dmall.common.comma();

    $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징

    // filter layer setting...
    $("[id^=check_]").on("click",function(){
        var obj = $(this);
        var _filterIdx = $(this).attr("id").split("_")[1];

        if(obj.prop("checked")){
            if(!$(".filter_detail_area").is(':visible')){
                $(".btn_view_filter").trigger("click");
            }
            //$("#filterLayer_"+_filterIdx).show();
            $("#filterLayer_"+_filterIdx).find("input[type=checkbox]").trigger("click");
        }else{
            if($("[id^=check_]:checked").length==0){
                //$(".btn_view_filter").trigger("click");
            }
            $("#filterLayer_"+_filterIdx).find("input[type=checkbox]").prop("checked",false);
            $("#filterLayer_"+_filterIdx).find("input[type=hidden]").val('');
            $("#filterLayer_"+_filterIdx).find("input[type=text]").val('');
            //$("#filterLayer_"+_filterIdx).hide();
        }
    });

    $("[id^=filterLayer_] input[type=checkbox]").on("click",function(){
        var filterGbCd =$(this).parents('[id^=filterLayer_]').attr("id").split('_')[1];
        $("[name=filterGbCd][value="+filterGbCd+"]").prop("checked",true);
    });


    // 찾기 버튼 클릭
    $('.btn_good_search').on('click',function(){
        category_search();
    });

    //초기화
    $('.btn_refresh').on('click',function(){
        var obj = $("[name=filterGbCd]");
        obj.each(function(){
            if($(this).prop("checked")){
                $(this).trigger('click');
            }
        });
    });

    //전체
    $('.btn_view_all').on('click',function(){
        var obj = $("[name=filterGbCd]");
        obj.each(function(){
            if($(this).prop("checked")){
                $(this).trigger('click');
            }
        });
        category_search();

    });

    //필터 영역 펼치기
    var filterGbCd ="";
    <c:forEach var="filterGbCd" items="${so.filterGbCd}" varStatus="status">
        $("[name=filterGbCd][value=${filterGbCd}]").prop("checked",true);
        filterGbCd += '${filterGbCd}';
    </c:forEach>
    if(filterGbCd!=""){
        $(".btn_view_filter").trigger('click');
    }


    // 색상선택
    /*$('span[name=colorCd]').on('click',function(){
        $(this).parents('.color_pick').find('input').val($(this).attr("value"));
    });*/


    var stPrice = $("[name=stPrice]").val()?$("[name=stPrice]").val().replaceAll(",",""):0;
    var endPrice = $("[name=endPrice]").val()?$("[name=endPrice]").val().replaceAll(",",""):50000;

    $( "#slider-range" ).slider({
        range: true,
        min: 5000,
        max: 3000000,
        values: [ stPrice, endPrice ],
        slide: function( event, ui ) {

            var barstyle = $(this).find('div').attr('style');

            $(this).find('p').attr('style',barstyle);

            $("[name=stPrice]").val(ui.values[0]).trigger("change");
            $("[name=endPrice]").val(ui.values[1]).trigger("change");

            Dmall.common.numeric();
            Dmall.common.comma();
        }
    });

    // 가격 slider setting..
    var barstyle = $( "#slider-range" ).find('div').attr('style');
    $( "#slider-range" ).find('p').attr('style',barstyle);

    $(".btn_view_filter").click(function() {
       /* var obj = $("[name=filterGbCd]");
        obj.each(function(){
            if(!$(this).prop("checked")){
                $(this).trigger('click');
            }
        });*/

        $("[id^=filterLayer_]").show();

    });

    $("[name=stPrice]").on('change',function(){
        var val = $(this).val();
        if(val!=""){
            $("[name=filterGbCd][value=02]").prop("checked",true);
        }else{
            $("[name=filterGbCd][value=02]").prop("checked",false);
        }
    });
    $("[name=endPrice]").on('change',function(){
        var val = $(this).val();
        if(val!=""){
            $("[name=filterGbCd][value=02]").prop("checked",true);
        }else{
            $("[name=filterGbCd][value=02]").prop("checked",false);
        }
    });

});
</script>
</t:putAttribute>
<t:putAttribute name="content">

    <!--- navigation --->
    <%@ include file="category_navigation.jsp" %>
    <!---// navigation --->

    <div class="category_middle">
        <!--- 카테고리배너&검색필터 --->
        <%@ include file="category_search_filter.jsp" %>
        <!---// 카테고리배너&검색필터 --->

        <!--- 카테고리 전시상품영역 --->
        <c:if test="${so.searchAll ne 'all'}">
        <%@ include file="category_display_goods.jsp" %>
        </c:if>
        <!---// 카테고리 전시상품영역 --->

        <form:form id="form_id_search" commandName="so" action="/front/search/category">
        <form:hidden path="ctgNo" id="ctgNo" />
        <form:hidden path="page" id="page" />
        <form:hidden path="rows" id="rows" />
        <form:hidden path="sortType" id="sortType" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />
        <form:hidden path="filterTypeCd" id="filterTypeCd" />
        <form:hidden path="searchAll" id="searchAll" />

        <!-- 목록헤드 -->
        <div class="list_head">
            <div class="top">
                <div class="left">
                    <span class="view_no">${resultListModel.filterdRows} 개</span>
                    <c:if test="${category_info.filterApplyYn eq 'Y'}">
                    <button type="button" class="btn_view_all">전체</button>
                    </c:if>
                </div>
                <div class="right">
                    <button type="button" class="btn_img_type <c:if test='${so.displayTypeCd eq "01"}'>active</c:if>" rel="tab1" onclick="chang_dispType('01');">이미지형</button>
                    <button type="button" class="btn_list_type <c:if test='${so.displayTypeCd eq "02"}'>active</c:if>" rel="tab2" onclick="chang_dispType('02');">리스트형</button>
                    <select name="selectAlign" class="select_align">
                        <option value="01" <c:if test="${so.sortType eq '01'}">selected</c:if>>판매순</option>
                        <option value="02" <c:if test="${so.sortType eq '02'}">selected</c:if>>신상품순</option>
                        <option value="03" <c:if test="${so.sortType eq '03'}">selected</c:if>>낮은가격</option>
                        <option value="04" <c:if test="${so.sortType eq '04'}">selected</c:if>>높은가격순</option>
                        <option value="05" <c:if test="${so.sortType eq '05'}">selected</c:if>>상품평 많은순</option>
                    </select>
                    <select class="selcet_count" title="select option" id="view_count" name="view_count">
                        <option <c:if test="${so.rows eq '10'}">selected="selected"</c:if> value="10">10개씩 보기</option>
                        <option <c:if test="${so.rows eq '20'}">selected="selected"</c:if> value="20">20개씩 보기</option>
                        <option <c:if test="${so.rows eq '50'}">selected="selected"</c:if> value="50">50개씩 보기</option>
                    </select>
                </div>
            </div>
        </div>
        <!--// 목록헤드 -->
        <c:if test="${category_info.filterApplyYn eq 'Y'}">
        <!-- 필터영역 -->
        <%@ include file="category_goods_filter.jsp" %>
        <!--// 필터영역 -->
        </c:if>
        </form:form>

        <!-- 목록영역 -->
        <div class="product_list_area">
            <c:choose>
                <c:when test="${resultListModel.resultList ne null}">
                    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="N" iconYn="Y"/>
                </c:when>
                <c:otherwise>
                    <p>등록된 상품이 없습니다.</p>
                </c:otherwise>
            </c:choose>
            <!-- pageing -->
            <div class="tPages" id="div_id_paging">
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!-- //pageing -->
        </div>
        <!--// 목록영역 -->


        <!-- 상품이미지 미리보기 팝업 -->
        <div id="div_goodsPreview"  class="popup_goods_plus pop_front" style="display: none;">
            <div id ="goodsPreview"></div>
        </div>
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
    </div>

    <!-- banner area -->
    <div class="sub_banner_area">
        <c:choose>
            <c:when test="${visual_banner.resultList ne null && fn:length(visual_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${visual_banner.resultList}" varStatus="status">
                <c:if test="${resultModel.linkUrl ne null}">
                    <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
                </c:if>
                <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
                <c:if test="${resultModel.linkUrl ne null}">
                </a>
                </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>

            </c:otherwise>
        </c:choose>

    </div>
    <!--// banner area -->

    </t:putAttribute>
</t:insertDefinition>