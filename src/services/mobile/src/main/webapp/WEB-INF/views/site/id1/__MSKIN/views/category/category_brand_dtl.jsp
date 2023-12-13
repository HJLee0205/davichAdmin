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
<t:putAttribute name="title">브랜드관</t:putAttribute>
<t:putAttribute name="script">
<script>
	
	$(document).ready(function(){
		// 카테고리검색 정렬기준 변경
	    $('select[name=selectAlign]').on('change',function(){
	            chang_sort($(this).val());
	    });
	 	
	    var $div_id_detail = $('#div_id_detail');
    	var $totalPageCount = $('#totalPageCount');
    	var totalPageCount = Number('${resultListModel.totalPages}');
    	var $list_page_view_em = $('.list_page_view em');
    	var page = Number('${resultListModel.page}');
    	// 페이지 번호에 따른 페이징div hide
    	console.log(totalPageCount)
    	console.log(Number(page))
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
        		var param = $('#form_id_search').serialize();
         		var url = '${_MOBILE_PATH}/front/brand-category-paging';
		        Dmall.AjaxUtil.loadByPost(url, param, function(result) {
		        	$list_page_view_em.text(pageIndex);
		        	$('#div_id_detail').append(result);
		        	if(totalPageCount == pageIndex){
		        		$('.list_bottom').hide();		
		        	}
		        });
	        }else{
 				$('.list_bottom').hide();	
	        }
        });
		
	});
	
	// 카테고리검색 전시타입변경
	function chang_dispType(type){
	    $('#displayTypeCd').val(type);
	    $('#page').val("1");
	    
	    var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
        
		Dmall.FormUtil.submit('${_MOBILE_PATH}/front/brand-category-dtl',param);
	}
		
	// 카테고리검색 정렬기준 변경
	function chang_sort(type){
	    $('#sortType').val(type);
		$('#page').val("1");
	    
	    var data = $('#form_id_search').serializeArray();
        var param = {};
        $(data).each(function(index,obj){
            param[obj.name] = obj.value;
        });
        
	    Dmall.FormUtil.submit('${_MOBILE_PATH}/front/brand-category-dtl',param);
	}	
	
</script>
</t:putAttribute>
	<t:putAttribute name="content">

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			${brand.brandNm}
		</div>
		<div class="brand_top">
			<div class="img_area">
				<img src="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${brand.dtlImgPath}_${brand.dtlImgNm}" alt="${brand.dtlImgNm}">
			</div>
		</div>
		
		<form:form id="form_id_search" commandName="so">
		<form:hidden path="ctgNo" id="ctgNo" />
		<form:hidden path="page" id="page" />
		<form:hidden path="rows" id="rows" />
		<form:hidden path="sortType" id="sortType" />
		<form:hidden path="displayTypeCd" id="displayTypeCd" />
		<form:hidden path="filterTypeCd" id="filterTypeCd" />
		<input type="hidden" name="searchBrands" value="${brand.brandNo}"/>
		
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
					<c:if test="${category_info.filterApplyYn eq 'Y'}">
						<button type="button" class="btn_filter btn_view_filter active">필터</button>
					</c:if>
					<c:choose>
						<c:when test='${so.displayTypeCd eq "01"}'>
							<button type="button" class="btn_img_type active" id="selectOption_image" rel="tab1" onclick="chang_dispType('02');">이미지형</button>&nbsp;
						</c:when>
						<c:otherwise>
	                    	<button type="button" class="btn_list_type active" id="selectOption_list" rel="tab2" onclick="chang_dispType('01');">리스트형</button>
	                    </c:otherwise>
                    </c:choose>
					<select name="selectAlign" class="select_align" id="changeSort">
						<option value="01" <c:if test="${so.sortType eq '01'}">selected</c:if>>인기판매순</option>
						<option value="02" <c:if test="${so.sortType eq '02'}">selected</c:if>>신상품순</option>
						<option value="03" <c:if test="${so.sortType eq '03'}">selected</c:if>>낮은가격</option>
						<option value="04" <c:if test="${so.sortType eq '04'}">selected</c:if>>높은가격순</option>
						<option value="05" <c:if test="${so.sortType eq '05'}">selected</c:if>>상품평 많은순</option>
					</select>
				</div>
			</div>
		</div>
		<!--// 목록헤드 -->
	
		<!--// 목록헤드 -->
	
		</form:form>
		<!-- 목록영역 -->
		<div class="product_list_area" id="div_id_detail">
			<c:choose>
				<c:when test="${resultListModel.resultList ne null}">
					<data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="N"/>
				</c:when>
				<c:otherwise>
					<p>등록된 상품이 없습니다.</p>
				</c:otherwise>
			</c:choose>
		</div>
		<!--// 목록영역 -->
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
		<!-- banner area -->
		<div class="sub_banner_area">
			<c:choose>
				<c:when test="${visual_banner.resultList ne null && fn:length(visual_banner.resultList) gt 0}">
					<c:forEach var="resultModel" items="${visual_banner.resultList}" varStatus="status">
							<c:if test="${empty resultModel.linkUrl}">
								<img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="" width="940px;" height="440px;">
							</c:if>
							<c:if test="${!empty resultModel.linkUrl}">
								<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt=""></a>
							</c:if>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<%--<li><img src="${_SKIN_IMG_PATH}/main/main_visual01.jpg" alt=""></li>--%>
				</c:otherwise>
			</c:choose>
		</div>
	</div><!-- //middle_area -->
	<!---// 03.LAYOUT:CONTENTS --->
    </t:putAttribute>
</t:insertDefinition>