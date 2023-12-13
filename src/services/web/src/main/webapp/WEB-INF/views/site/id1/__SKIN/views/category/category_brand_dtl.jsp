<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="du" class="dmall.framework.common.util.DateUtil"></jsp:useBean>
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
<t:putAttribute name="title">다비치마켓 :: 브랜드관</t:putAttribute>
<t:putAttribute name="script">
<script>
	
    $(document).ready(function(){
    	
    	$('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
    	
    	
    	// 카테고리검색 정렬기준 변경
        $('select[name=selectAlign]').on('change',function(){
                chang_sort($(this).val());
        });
    	
     	// 페이지당 상품 조회수량 변경
        $("#view_count").on("change",function(){
            change_view_count();
        });
     	
        $(".img_menu").hide();
		
        $(".goods_image_area").mouseover(function() {
		  $(this).children('.img_menu').stop().fadeIn('slow');
		});
		
		
		$(".goods_image_area").mouseleave(function() {
		  $(this).children('.img_menu').stop().fadeOut();
		});
    });
    
 	// 카테고리검색 전시타입변경
    function chang_dispType(type){
        $('#displayTypeCd').val(type);
        if($('#searchType').val() == undefined || $('#searchType').val() == ''){
            category_search(type);
        }else{
            goods_search(type)
        }
    }
 	
 	// 카테고리상품검색
    function category_search(type){
    	//var param = $('#form_id_search').serialize();
		//Dmall.FormUtil.submit('/front/brand-category-dtl?'+param);
		
		var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
		Dmall.FormUtil.submit('/front/brand-category-dtl',param);
    }
 	
 	// 상품검색
    function goods_search(type){
    	//var param = $('#form_id_search').serialize();
		//Dmall.FormUtil.submit('/front/brand-category-dtl?'+param);
		
		var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
		Dmall.FormUtil.submit('/front/brand-category-dtl',param);
    }
 	
 	// 카테고리검색 정렬기준 변경
    function chang_sort(type){
        $('#sortType').val(type);
        if($('#searchType').val() == undefined || $('#searchType').val() == ''){
            category_search();
        }else{
            goods_search()
        }
    }
 	
  	//노출상품갯수변경
    function change_view_count(){
        $('#rows').val($('#view_count option:selected').val());
        if('${so.rows}' != $('#rows').val()){
            if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                category_search();
            }else{
                goods_search()
            }
        }
    }
</script>
</t:putAttribute>
    <t:putAttribute name="content">
    
    <div class="category_middle">
    	<!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <span class="location_bar"></span><a href="/">홈</a><span>&gt;</span><a href="/front/brand-category">브랜드관</a><span>&gt;</span>
                	<c:choose>
                		<c:when test="${brand.brandNm != '' and brand.brandNm ne null}">
                			${brand.brandNm}
                		</c:when>
                		<c:otherwise>
                			${brand.brandEnnm}
                		</c:otherwise>
                	</c:choose>
            </div>
        </div>
        <!---// category header --->
        
		<form:form id="form_id_search" commandName="so">
	    <form:hidden path="ctgNo" id="ctgNo" />
	    <form:hidden path="page" id="page" />
	    <form:hidden path="rows" id="rows" />
	    <form:hidden path="sortType" id="sortType" />	<!-- 신상품순 -->
	    <form:hidden path="displayTypeCd" id="displayTypeCd" />	<!-- 바둑판 -->
	    <form:hidden path="filterTypeCd" id="filterTypeCd" />
	    <input type="hidden" name="searchBrands" value="${brand.brandNo}"/>
	    <%-- <form:hidden path="searchBrands" id="searchBrands"/> --%>
	    
	    <!-- 브랜드 배너 -->
		<div class="brand_banner_area">
			<img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${brand.dtlImgPath}_${brand.dtlImgNm}" alt="${brand.dtlImgNm}">
		</div>
		<!-- 브랜드 배너 -->
			
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
	</div>
	
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
	
	</t:putAttribute>
</t:insertDefinition>