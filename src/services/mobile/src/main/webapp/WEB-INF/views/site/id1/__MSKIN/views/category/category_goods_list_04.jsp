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
	<t:putAttribute name="title">4차 카테고리</t:putAttribute>
	
	
	
	
	<t:putAttribute name="script">
	<script>
	$(document).ready(function(){
		var $div_id_detail = $('#div_id_detail');
    	var $totalPageCount = $('#totalPageCount');
    	var totalPageCount = Number('${resultListModel.totalPages}');
    	var $list_page_view_em = $('.list_page_view em');
    	var page = Number('${resultListModel.page}');
    	// 페이지 번호에 따른 페이징div hide
    	if(totalPageCount == Number(page)){
 			$('.list_bottom').hide();
		}
    	$list_page_view_em.text(Number(page));
        $totalPageCount.text(totalPageCount);
		// 더보기 버튼 클릭시 append 이벤트
        $('.more_view').off('click').on('click', function() {
        	
        	var page =$("#page").val();
        	var pageIndex = Number(page)+1;
        	if(totalPageCount >= pageIndex){
        		$("#page").val(pageIndex);
	          	var param = "page="+pageIndex;
	     		var url = '${_MOBILE_PATH}/front/search/category?ctgNo=${so.ctgNo}&'+param;
		        Dmall.AjaxUtil.load(url, function(result) {
		        	$list_page_view_em.text(pageIndex);
			        var detail = $(result).find('#div_id_detail');
			        $div_id_detail.append(detail.html());
			        if(totalPageCount == pageIndex){
		        		$('.list_bottom').hide();		
		        	}
		        });
	        }else{
 				$('.list_bottom').hide();	
	        }
        });
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			카테고리
		</div>

	    <!--- navigation --->
	    <%@ include file="/WEB-INF/views/category/navigation.jsp" %>
	    <!---// navigation --->
	
	    <!--- 카테고리배너&검색필터 --->
	    <%@ include file="/WEB-INF/views/category/search_filter.jsp" %>
	    <!---// 카테고리배너&검색필터 --->
	
	    <!--- 카테고리 전시상품영역 --->
<%-- 	    <%@ include file="/WEB-INF/views/category/display_goods.jsp" %> --%>
	    <!---// 카테고리 전시상품영역 --->
	    
	    <!--- 카테고리 상품영역 --->
	    <form:form id="form_id_search" commandName="so">
	    <form:hidden path="ctgNo" id="ctgNo" />
	    <form:hidden path="page" id="page" />
	    <form:hidden path="rows" id="rows" />
	    <form:hidden path="sortType" id="sortType" />
	    <form:hidden path="displayTypeCd" id="displayTypeCd" />
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
					<span class="selectOption <c:if test='${so.displayTypeCd eq "05"}'>selected</c:if>" value="이미지보기" id="selectOption_image" rel="tab1" onclick="chang_dispType('05');"><span class="icon_imageview"></span>이미지보기</span>
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
				20개 더보기<span class="icon_more_view"></span>
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