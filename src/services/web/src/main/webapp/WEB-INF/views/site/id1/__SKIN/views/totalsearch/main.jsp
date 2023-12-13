<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
<%@ include file="../category/search_list_js.jsp" %>
        <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
        <script>
        $(document).ready(function(){
        	var searchWord = '${searchWord}';

        	//인기검색어
        	/* $.ajax({
        		url : "http://localhost:7614/ksf/api/rankings?domain_no=0",
        		dataType : "jsonp",
        		success : function(data) {
        			$('#rankings').html(data);
        		},
        		error : function() {
        			alert('에러');
        		}
        	}) */

        	$("#searchText").val(searchWord);
        	var url = "/front/totalsearch/inc/inc_total";
        	var formData = $("form[name=totalSearchForm]").serialize();
       		$.ajax ({
       			type : "GET",                   // GET 또는 POST
   	    		url : url,						// 서버측에서 가져올 페이지
        		data : formData,				// 서버측에 전달할 parameter
       			dataType : 'html',              // html , javascript, text, xml, jsonp 등이 있다
				success : function(data) {     	// 정상적으로 완료되었을 경우에 실행된다
					 $("#innerContentArea").html(data);
       			},
        		error : function(request, status, error ) {   // 오류가 발생했을 때 호출된다.
	        		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        		},
        		complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수

        		}
       		});

        	var Bottomslider = $('.MD_top ul' ).bxSlider({
        		controls: false,
        		pager: false,
        	});
        	$('.MD_prev').click(function () {
        		var current = Bottomslider.getCurrentSlide();
        		Bottomslider.goToPrevSlide(current) - 1;
        	});
        	$('.MD_next').click(function () {
        		var current = Bottomslider.getCurrentSlide();
        		Bottomslider.goToNextSlide(current) + 1;
        	});
        	
        	$(document).on('click','#btn_goods_detail_search',function(){
        		if($("#searchDetailWord").val() != null && $("#searchDetailWord").val() != ""){
        			if($("#searchType").val() == "0"){
        				alert("검색조건을 선택하세요");
                		return;
        			}
        		}
        		jsMoveTab('product');
            });
        	
            $(document).on('click','.tPages > ul > li > a',function(){
            	var target = $("#target").val();
            	$("#targetPage").val($(this).data("page"));
            	var formData = $("form[name=totalSearchForm]").serialize();
            	var url = "/front/totalsearch/inc/inc_"+target;
           		$.ajax ({
           			type : "GET",                   // GET 또는 POST
       	    		url : url,         				// 서버측에서 가져올 페이지
            		data : formData,				// 서버측에 전달할 parameter
           			dataType : 'html',              // html , javascript, text, xml, jsonp 등이 있다
    				success : function(data) {      // 정상적으로 완료되었을 경우에 실행된다
    					$("#innerContentArea").empty();
    					$(".search_lnb > .menu > li > a").attr("class","");
    					$("#"+target+"_tab").attr("class","active");
    					$("#innerContentArea").html(data);
           			},
            		error : function(request, status, error ) {   // 오류가 발생했을 때 호출된다.
    	        		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            		},
            		complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수
            		}
           		});
            });

            $(document).on('click','#jsSearchWordOrg',function(){
            	/* $("#searchWord").val($("searchWordOrg").val());
            	var formData = $("form[name=totalSearchForm]").serialize();
            	 $("#totalSearchForm").attr("target","/front/totalsearch/main");
            	 $("#totalSearchForm").submit(); */
            	 Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+$("#searchWordOrg").val()+"&searchWordOrg=" + $("#searchWordOrg").val());
            });
            
            $(document).on("click","a[action_id='sugSearchWord']",function(){
            	/* $("#searchWord").val($(this).text());
            	var formData = $("form[name=totalSearchForm]").serialize();
            	 $("#totalSearchForm").attr("target","/front/totalsearch/main");
            	 $("#totalSearchForm").submit(); */
            	Dmall.FormUtil.submit('/front/totalsearch/main?searchType=1&searchWord='+$(this).text());
            });
        });
        
        //브랜드관 이동
       	function ajaxGoodsList(searchBrands){

			var param = 'searchBrands='+searchBrands;
			var url = '/front/brand-category-dtl?'+param;

			location.href=url;
		}

       	var jsMoveTab = function(kind){
        	//alert(kind)
        	$("#target").val(kind);
        	$("#targetPage").val("1");
        	if(kind != "product"){
        		$(".btn_view_filter").css("display","none");
        	}else{
        		$(".btn_view_filter").css("display","inline");
        	}
        	var formData = $("form[name=totalSearchForm]").serialize();
        	url = "/front/totalsearch/inc/inc_"+kind;
       		$.ajax ({
       			type : "GET",                   // GET 또는 POST
   	    		url : url,         				// 서버측에서 가져올 페이지
        		data : formData,				// 서버측에 전달할 parameter
       			dataType : 'html',              // html , javascript, text, xml, jsonp 등이 있다
				success : function(data) {		// 정상적으로 완료되었을 경우에 실행된다
					$("#innerContentArea").empty();
					$(".search_lnb > .menu > li > a").attr("class","");
					$("#"+kind+"_tab").attr("class","active");
					$("#"+kind+"_tab").focus();
					$("#innerContentArea").html(data);
       			},
        		error : function(request, status, error ) {   // 오류가 발생했을 때 호출된다.
	        		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        		},
        		complete : function () {   // 정상이든 비정상인든 실행이 완료될 경우 실행될 함수

        		}
       		});
        };
        
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 02.LAYOUT: SEARCH AREA --->
	<div class="category_middle">
		<form name="totalSearchForm" id="totalSearchForm" method="get" >
		<input type="hidden" id="targetPage" name="targetPage">
		<input type="hidden" id="target" name="target">	
		<input type="hidden" id="searchWordOrg" name="searchWordOrg" value="<c:out value="${searchWordOrg}"/>">
		<input type="hidden" name="totalSearchText" id="totalSearchText" value='<c:out value="${searchWord}"/>' />
		<input type="hidden" name="searchWord" id="searchWord" value='<c:out value="${searchWord}"/>' />
		
	<div class="search_keyword">
		<span class="tit" >연관검색어<a href="#" class="help_keyword">도움말</a></span>
		  <c:set var="comma" value=","/>
		<c:forEach var="suggestions" items="${suggestions}" varStatus="status" >
		<a style="margin: 0px 0px 0px 7px;" href="#" action_id="sugSearchWord">${suggestions}
		</a>
		<c:if test="${not status.last }">
					<c:out value=","/>
				    </c:if>
		</c:forEach>
				
<!--
				<span class="tit">오타교정 : </span>
				<c:forEach var="spell" items="${spell }" varStatus="status">
				<a href="#">${spell}</a>
				</c:forEach>
 -->
				<!-- <span class="tit">인기검색어 :</span>
				<div id="rankings"></div>  -->
			</div>
			<div class="search_result_tit" style="color:black;">
				<span class="search_result_word">'${searchWord}'</span> 으로 검색한 결과입니다.
			<c:if test="${searchWordOrg ne null and searchWordOrg ne ''}">
				<span style="font-weight:bold;">'<c:out value="${searchWordOrg}" />'</span> <a href="#" id="jsSearchWordOrg" style="color:blue; cursor:pointer;">검색결과 보기</a>
			</c:if>
			</div>
			<div class="search_lnb">
				<ul class="menu">
					<li><a href="javascript:jsMoveTab('total');" id="total_tab" class="active">통합검색</a></li>
					<li><a href="javascript:jsMoveTab('product');" id="product_tab">상품</a></li>
					<li><a href="javascript:jsMoveTab('promotion');" id="promotion_tab">프로모션</a></li>
					<!-- <li><a href="javascript:jsMoveTab('withitem');" id="withitem_tab">MD추천</a></li> --> <!-- 20200612 -->
					<li><a href="javascript:jsMoveTab('magazine');" id="magazine_tab">D.매거진</a></li>
					<li><a href="javascript:jsMoveTab('video');" id="video_tab">동영상</a></li>
					<li><a href="javascript:jsMoveTab('qna');" id="qna_tab">Q&A</a></li>
					<li><a href="javascript:jsMoveTab('news')" id="news_tab">뉴스</a></li>
					<li><a href="javascript:jsMoveTab('vcs')" id="vcs_tab">관련검사</a></li>
				</ul>
				<button type="button" class="btn_view_filter" style="display:none;">검색옵션</button>
			</div>
			
			<div class="search_filter option">
		            <ul>
		                <li id="td_goods_select_ctg">
		                    <label class="tit" for="">상품분류</label>
		                    <select class="select_option" name="searchCtg1" id="sel_ctg_1">
		                        <option selected="selected" value="">1차 카테고리</option>
		                    </select>
		                    <select class="select_option" name="searchCtg2" id="sel_ctg_2">
		                        <option selected="selected" value="">2차 카테고리</option>
		                    </select>
		                    <select class="select_option" name="searchCtg3" id="sel_ctg_3">
		                        <option selected="selected" value="">3차 카테고리</option>
		                    </select>
		                    <%--<select class="select_option" name="searchCtg4" id="sel_ctg_4">
		                        <option selected="selected" value="">4차 카테고리</option>
		                    </select>--%>
		                </li>
		                <li>
		                    <label class="tit" for="">검색조건</label>
		                    <select class="select_option" title="select option" id="searchType" name="searchType">
		                        <option selected="selected" value="0">선택하세요.</option>
		                        <option value="1">상품명</option>
		                        <option value="2">브랜드</option>
		                        <option value="3">모델명</option>
		                        <option value="4">제조사</option>
		                    </select>
		                    <input type="text" id="searchDetailWord" name="searchDetailWord" class="form_search">
		                    <%--<input type="checkbox" id="search_again">
		                    <label for="search_again"><span></span>결과내 검색</label>--%>
		                </li>
		                <li>
		                    <label class="tit" for="">가격대</label>
		                    <input type="text" id="searchPriceFrom" name="searchPriceFrom" class="form_price">
		                    ~
		                    <input type="text" id="searchPriceTo" name="searchPriceTo" class="form_price">
		                </li>
		            </ul>
		            <div class="btn_filter_area">
		                <button type="button" class="btn_refresh btn_category_search_reset">초기화</button>
		                <button type="button" class="btn_good_search btn_category_search" id="btn_goods_detail_search">찾기<i></i></button>
		            </div>
		            	<button type="button" class="btn_option_close">검색옵션 닫기</button>
		        </div>
			
		</form>
		<!--// 레이어 검색창 -->
		<div id="innerContentArea">
		</div>
		<!-- 상품이미지 미리보기 팝업 -->
		<div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
			<div id ="goodsPreview"></div>
		</div>
	</div>
	<!---// 02.LAYOUT: SEARCH AREA --->
    </t:putAttribute>
</t:insertDefinition>