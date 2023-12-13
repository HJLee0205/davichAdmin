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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">${so.ctgNm}</t:putAttribute>

	<t:putAttribute name="script">
	<script>


	$(document).ready(function(){
        var pageUrl = window.location.href;


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
		/*localStorage.setItem("page",1);*/
        $('.more_view').off('click').on('click', function(e) {
			Dmall.EventUtil.stopAnchorAction(e);
        	var page =$("#page").val();
        	var pageIndex = Number(page)+1;
        	if(totalPageCount >= pageIndex){
        		$("#page").val(pageIndex);
	          	var param = $('#form_id_search').serialize()+'&page='+pageIndex;
	     		var url = '${_MOBILE_PATH}/front/search/category';
		        Dmall.AjaxUtil.loadByPost(url, param, function(result) {

		        	$list_page_view_em.text(pageIndex);
			        var detail = $(result).find('#div_id_detail');
			        $div_id_detail.append(detail.html());
			        if(totalPageCount == pageIndex){
		        		$('.list_bottom').hide();		
		        	}
		        	history.replaceState({list:$div_id_detail.html(), page:pageIndex},'Page '+pageIndex, pageUrl+'##');

		        	$('.product_list_typeB').last().find('li:eq(0)').attr("tabindex",pageIndex).focus();

					return false;

		        });
	        }else{
 				$('.list_bottom').hide();	
	        }


        });

        /*$(".filter_detail_area").hide();*/
        $(".btn_view_filter").click(function() {
            $(this).toggleClass("active");
            $(".filter_detail_area").slideToggle("100");
            
            if($(this).hasClass('active')){
            	$('.btn_filter_area').show();	
            }else{
            	$('.btn_filter_area').hide();
            }
            
        });

        $("#changeSort").on('change',function() {
			var _val = $(this).val();
            chang_sort(_val);
		});

		if(location.hash){
            var data = history.state;
            if(data){
               $div_id_detail.html(data.list);
               $("#page").val(data.page);
               $list_page_view_em.text(data.page);
            }
        }


    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
	<style>
		li:focus { outline: none; }
	</style>
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<!--- navigation --->
		<%@ include file="navigation.jsp" %>
		<!---// navigation --->

		<!--- 카테고리배너&검색필터 --->
		<%@ include file="search_filter.jsp" %>
		<!---// 카테고리배너&검색필터 --->

		<!-- <div class="cont_body"> -->

		<form:form id="form_id_search" commandName="so">

		<form:hidden path="ctgNo" id="ctgNo" />
		<form:hidden path="rows" id="rows" />
		<form:hidden path="sortType" id="sortType" />
		<form:hidden path="displayTypeCd" id="displayTypeCd" />
		<form:hidden path="filterTypeCd" id="filterTypeCd" />
		<form:hidden path="searchAll" id="searchAll" />
		<input type="hidden" name="page" id="page" value="${resultListModel.page}">
		<!-- 목록헤드 -->
		<div class="list_head">
			<div class="top">
				<div class="left search_area">
					<span class="view_no">${resultListModel.filterdRows} 개</span>
					<c:if test="${category_info.filterApplyYn eq 'Y'}">
						<button type="button" class="btn_view_all" id="btn_all_search">전체</button>
					</c:if>
				</div>
				<div class="right search_area">
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
		<c:if test="${category_info.filterApplyYn eq 'Y'}">
			<!-- 필터영역 -->
			<%@ include file="category_goods_filter.jsp" %>
			<!--// 필터영역 -->
		</c:if>

		</form:form>
		
		<c:if test="${so.searchAll ne 'all'}">
		<div class="">
			<!--- 카테고리 전시상품영역 --->
		     <%@ include file="display_goods.jsp" %>
			<!---// 카테고리 전시상품영역 --->
		</div><!-- //cont_body -->
		</c:if>
		
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
			<a href="javascript:;" name="more_view" class="more_view" onclick="return false;">
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
		<!--// banner area -->
		<!-- 예약바로가기 20200706 -->
		<c:if test="${user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-book" class="btn_go_reservation">
		</c:if>
		<c:if test="${!user.login}">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/visit/visit-welcome" class="btn_go_reservation">
		</c:if>
		${storeTotCnt}개 매장예약
		</a>
		<!--// 예약바로가기 20200706 -->

    </t:putAttribute>
</t:insertDefinition>