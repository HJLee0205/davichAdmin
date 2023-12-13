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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
<t:putAttribute name="title">다비치마켓 :: 렌즈착용샷</t:putAttribute>
<t:putAttribute name="script">
<script>
	/*   lens view slider   */
	$(function () {
		var firstBrandNo = $('ul.lens_tabs>li:first').data().brandno;
		ajax_contact_wear_list(firstBrandNo);
		
		$('a[class^=lens_tab]').click(function(){
	    	$('a[class^=lens_tab]').removeClass('active');
	    	$(this).addClass('active');
	    	var brandNo = $(this).parent('li').data().brandno;
			ajax_contact_wear_list(brandNo);
	    })
	});
	
	function ajax_contact_wear_list(brandNo) {
		var param = 'brandNo='+brandNo;
		var url = '/front/search/contact-wear-list-ajax?'+param;
        Dmall.AjaxUtil.load(url, function(result) {
            $('#lens_slider_area').html(result);
        })
	}
	
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- 02.LAYOUT: 카테고리 메인 --->
    <div class="category_middle">
        
        <!--- 카테고리배너&검색필터 --->
        <%@ include file="category_search_filter.jsp" %>
        <!---// 카테고리배너&검색필터 --->
        
		<!-- 콘택트렌즈 착용샷 -->
        <div id="div_contact_wear">
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
	        		</c:if>
	        	</c:forEach>
			</ul>
	        <div id="lens_slider_area" class="lens_slider_area"></div>
		</div>
        <!-- 콘택트렌즈 착용샷 -->
	</div>
	
</t:putAttribute>
</t:insertDefinition>