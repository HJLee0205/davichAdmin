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
    <t:putAttribute name="title">검색결과</t:putAttribute>
    <t:putAttribute name="script">
    <%-- 카카오 모먼트 --%>
    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
	<script type="text/javascript">
		  kakaoPixel('59690711162928695').pageView();
		  kakaoPixel('59690711162928695').search({
			keyword: '${so.searchWord}'
		  });
		  kakaoPixel('7385103066531646539').pageView();
          kakaoPixel('7385103066531646539').search({
            keyword: '${so.searchWord}'
          });
	</script>
	<%-- // 카카오 모먼트 --%>
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
    	          	var param = $('#form_id_search').serialize()+'&page='+pageIndex;
    	     		var url = '${_MOBILE_PATH}/front/search/goods-list-search';
    		        Dmall.AjaxUtil.loadByPost(url, param, function(result) {
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
            
            $("#changeSort").on('change',function() {
    			var _val = $(this).val();
                chang_sort(_val);
    		});
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!---script --->
    <%@ include file="search_list_js.jsp" %>
    <!--- script --->
	<%-- logCorpAScript --%>
    <c:set var="http_IS" value="${so.searchWord}" scope="request"/> <%--내부검색어--%>
    <c:if test="${resultListModel.filterdRows > 0}">
        <c:set var="http_IC" value="Y" scope="request"/> <%--내부검색어성공여부(성공:Y,실패:N)--%>
    </c:if>
    <c:if test="${resultListModel.filterdRows < 1}">
        <c:set var="http_IC" value="N" scope="request"/> <%--내부검색어성공여부(성공:Y,실패:N)--%>
    </c:if>
    <%--// logCorpAScript --%>
    <!--- 03.LAYOUT:CONTENTS --->
    <div id="middle_area">
        <div class="product_head">
            <button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
            <c:choose>
	        	<c:when test="${empty so.searchVisionCtg}">
	        		검색결과
	        	</c:when>
	        	<c:otherwise>
	        		추천렌즈 목록 : 안경렌즈
	        	</c:otherwise>
	        </c:choose>            	
        </div>

        <!--- 검색 필터 영역 --->
        <form:form id="form_id_search" commandName="so">
        <form:hidden path="page" id="page" />
        <form:hidden path="rows" id="rows" />
        <form:hidden path="sortType" id="sortType" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />
        <form:hidden path="searchVisionCtg" id="searchVisionCtg"/>
        <form:hidden path="searchVisionCtgNm" id="searchVisionCtgNm"/>
        <form:hidden path="searchVisionCtgAll" id="searchVisionCtgAll" value="${so.searchVisionCtgAll}"/>
        <form:hidden path="searchVisionCtgNmAll" id="searchVisionCtgNmAll" value="${so.searchVisionCtgNmAll}"/>
        <div class="cont_body">
	        <c:choose>
	        	<c:when test="${empty so.searchVisionCtg}">		       
		            <div class="search_filter">
		                <ul>
		                    <li>
		                        <select name="searchCtg1" id="sel_ctg_1">
		                            <option selected="selected" value="">1차 카테고리</option>
		                        </select>
		                        <select name="searchCtg2" id="sel_ctg_2">
		                            <option selected="selected" value="">2차 카테고리</option>
		                        </select>
		                    </li>
		                    <li>
		                        <select name="searchCtg3" id="sel_ctg_3">
		                            <option selected="selected" value="">3차 카테고리</option>
		                        </select>
		                        <select name="searchCtg4" id="sel_ctg_4">
		                            <option selected="selected" value="">4차 카테고리</option>
		                        </select>
		                    </li>
		                    <li>
		                        <%--<label class="tit" for="search_again">검색조건</label> --%>
		                        <%--<input type="checkbox" id="search_again">
		                        <label for="search_again"><span></span>결과내 검색</label><br>--%>
		                        <select id="searchType" name="searchType" class="search01">
		                            <option value="0">선택하세요.</option>
		                            <option value="1">상품명</option>
		                            <option value="2">브랜드</option>
		                            <option value="3">모델명</option>
		                            <option value="4">제조사</option>
		                        </select>
		                        <input type="text" id="searchWord" name="searchWord"class="form_search search02">
		
		                    </li>
		                    <li>
		                        <label class="tit" for="" style="width:18%;">가격대</label>
		                        <input type="text" id="searchPriceFrom" name="searchPriceFrom" class="form_price"> ~ <input type="text" id="searchPriceTo" name="searchPriceTo" class="form_price">
		                    </li>
		                </ul>
		                <div class="btn_filter_area">
		                    <button type="button" class="btn_refresh btn_category_search_reset">초기화</button>
		                    <button type="button" class="btn_good_search btn_category_search">찾기<i></i></button>
		                </div>
		            </div><!-- //search_filter -->
		            <!---// 검색 필터 영역 --->	
				</c:when>
				<c:otherwise>
					<script>
	        			function fn_vision_search(v_searchVisionCtg, v_searchVisionCtgNm){
	        				$("#searchVisionCtg").val(v_searchVisionCtg);
	        				$("#searchVisionCtgNm").val(v_searchVisionCtgNm);
	        				
	        				var data = $('#form_id_search').serializeArray();
	                        var param = {};
	                        $(data).each(function(index,obj){
	                            param[obj.name] = obj.value;
	                        });
	                        Dmall.waiting.start();
	                        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/search/goods-list-search', param);
	        			}
	        		</script>
	        		<div class="lens_recomm_wrap">
	        		<input type="hidden" id="searchType" name="searchType" value="0"/>
					<ul class="lens_recomm_menu">
						<li><a href="#none" <c:if test="${so.searchVisionCtgAll == so.searchVisionCtg}">class="active"</c:if> onclick="fn_vision_search('${so.searchVisionCtgAll}','${so.searchVisionCtgNmAll}')">전체</a></li>						
						<c:forEach var="vision_result" items="${searchVisionCtg}" varStatus="status">
							<li><a href="#none" <c:if test="${so.searchVisionCtg == vision_result.searchVisionCtg}">class="active"</c:if> onclick="fn_vision_search('${vision_result.searchVisionCtg}','${vision_result.searchVisionCtgNm}')">${vision_result.searchVisionCtgNm}</a></li>
						</c:forEach>
					</ul>
					<button type="button" class="btn_lens_show" onclick="document.location.href='${_MOBILE_PATH}/front/vision2/vision-check';">렌즈추천 다시받기<i></i></button>
					</div>
				</c:otherwise>
			</c:choose>	
		</div><!-- //cont_body -->

        <!-- 목록헤드 -->
        <div class="list_head">
            <div class="top">
                <div class="left"><!-- //모바일에서 search_area class추가 -->
                    <span class="view_no">${resultListModel.filterdRows} 개 </span>
                    <%--<span class="search_word">검색어01,</span>
                    <span class="search_word">씨엔블루</span>--%>
                </div>
                <div class="right"><!-- //모바일에서 search_area class추가 -->
                    <c:choose>
						<c:when test='${so.displayTypeCd eq "01"}'>
							<button type="button" class="btn_img_type active" id="selectOption_image" rel="tab1" onclick="chang_dispType('02');">이미지형</button>&nbsp;
						</c:when>
						<c:otherwise>
	                    	<button type="button" class="btn_list_type active" id="selectOption_list" rel="tab2" onclick="chang_dispType('01');">리스트형</button>
	                    </c:otherwise>
                    </c:choose>&nbsp;
                    <%--<button type="button" class="btn_filter">필터</button>--%>
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

        <!-- 목록영역 -->
        <div id="div_id_detail" class="product_list_area">
            <c:choose>
                <c:when test="${resultListModel.resultList ne null}">
                    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="N"/>
                </c:when>
                <c:otherwise>
                    <div style="text-align:center;margin-top: 20px;margin-bottom: 20px;">등록된 상품이 없습니다.</div>
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
    </form:form>
    </div>
    <!---// 03.LAYOUT: MIDDLE AREA --->
    </t:putAttribute>
</t:insertDefinition>