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
<t:putAttribute name="title">렌즈착용샷</t:putAttribute>
<t:putAttribute name="script">
<script>
   	/*   lens view slider   */
   	$(function () {
   		var firstBrandNo = $('ul.lens_tabs>li:first').data().brandno;
		ajax_contact_wear_list(firstBrandNo, 1);
   		
   		// 착용샷 브랜드 탭 버튼
        $('a[class^=lens_tab]').click(function(){
        	$('a[class^=lens_tab]').removeClass('active');
        	$(this).addClass('active');
        	var brandNo = $(this).parent('li').data().brandno;
        	$('#lens_slider_area').empty();
    		ajax_contact_wear_list(brandNo, 1);
        });
   		
   	});
   	
 	// 착용샷 목록 더보기 버튼
	function fn_wear_more_view() {
		var wear_page = Number($("#wear_page").val())+1;
		var brandNo = $('#wear_brand').val();
    	ajax_contact_wear_list(brandNo, wear_page);
	}
 
 	// 착용샷 목록 가져오기
	function ajax_contact_wear_list(brandNo, page) {
		$('.lens_brand_tit img').hide();
		$('#brand_no_'+brandNo).show();
		
		var param = 'brandNo='+brandNo+'&page='+page;
		var url = '${_MOBILE_PATH}/front/search/mobile-contact-wear-list-ajax?'+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#lens_slider_area').append(result);
            var totalPageCount = $('#wearTotPages').val();
            if(totalPageCount <= page){
        		$('.list_bottom').hide();		
        	}else{
        		$('.list_bottom').show();
        	}
            $('#wear_page').val(page);
            $('#wear_brand').val(brandNo);
        });
	}
</script>
</t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<!--- navigation --->
		<%@ include file="navigation.jsp" %>
		<!---// navigation --->

		<!--- 카테고리배너&검색필터 --->
		<%@ include file="search_filter.jsp" %>
		<!---// 카테고리배너&검색필터 --->
		
		<div class="">
			<!-- 콘택트렌즈 착용샷 -->
        	<div id="div_contact_wear">
        		<input type="hidden" id="wear_page" value="1">
        		<input type="hidden" id="wear_brand" value="">
        		<div class="lens_view_title">
					콘택트렌즈 착용샷
				</div>
        		<ul class="lens_tabs">
		        	<c:forEach var="li" items="${contact_wear_brand_list}" varStatus="status">
		        		<c:if test="${li.brandNo eq '11' || li.brandNo eq '12' || li.brandNo eq '77' || li.brandNo eq '149'}">
		        			<c:choose>
		        				<c:when test="${li.brandNo eq '11'}"><c:set var="tabNo" value="01"/></c:when>
		        				<c:when test="${li.brandNo eq '12'}"><c:set var="tabNo" value="02"/></c:when>
		        				<c:when test="${li.brandNo eq '77'}"><c:set var="tabNo" value="03"/></c:when>
		        				<c:when test="${li.brandNo eq '149'}"><c:set var="tabNo" value="04"/></c:when>
		        				<c:otherwise><c:set var="tabNo" value="00"/></c:otherwise>
		        			</c:choose>
		        			<li data-brandNo="${li.brandNo }"><a href="javascript:;" class="lens_tab${tabNo } <c:if test="${status.first }"> active</c:if>">${li.brandNm }</a></li>
		        			<c:if test="${status.first }"><c:set var="firstTab" value="${tabNo }"/></c:if>
		        		</c:if>
		        	</c:forEach>
				</ul>	
				<div class="lens_brand_tit">
					<img src="${_SKIN_IMG_PATH}/product/trevues_tit.png" alt="TREVUES" id="brand_no_11" style="display:none;">
					<img src="${_SKIN_IMG_PATH}/product/eyeluv_tit.png" alt="EYE LUV" id="brand_no_12" style="display:none;">
					<img src="${_SKIN_IMG_PATH}/product/tenten_tit.png" alt="TEN TEN" id="brand_no_77" style="display:none;">
					<img src="${_SKIN_IMG_PATH}/product/tensean.png" alt="TENSEAN" id="brand_no_149" style="display:none;">
				</div>	
		        <div id="lens_slider_area" class="cont_body"></div>
		        <div class="list_bottom">
					<a href="javascript:fn_wear_more_view();" class="more_view">
						20개 더보기<span class="icon_more_view"></span>
					</a>
				</div>
        	</div>
        	<!-- 콘택트렌즈 착용샷 -->
		</div><!-- //cont_body -->
	</div><!-- //middle_area -->
	<!---// 03.LAYOUT:CONTENTS --->

	</t:putAttribute>
</t:insertDefinition>
