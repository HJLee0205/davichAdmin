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
<t:putAttribute name="title">다비치마켓 :: 검색결과</t:putAttribute>
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
    $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
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
    <!--- 02.LAYOUT: 상품 메인 --->
    <div class="category_middle">
        <!-- 검색결과 -->
        <c:choose>
        	<c:when test="${empty so.searchVisionCtg}">
        		<h3 class="search_mid_tit">검색결과</h3>
        	</c:when>
        	<c:otherwise>
        		<div class="lens_head">
					<h2 class="lens_tit">추천렌즈 목록 : 안경렌즈</h2>
				</div>
        	</c:otherwise>
        </c:choose>
        <!--- 검색 필터 영역 --->
        <form:form id="form_id_search" commandName="so" action="/front/search/goods-list-search">
        <form:hidden path="page" id="page" />
        <form:hidden path="rows" id="rows" />
        <form:hidden path="sortType" id="sortType" />
        <form:hidden path="displayTypeCd" id="displayTypeCd" />
        <form:hidden path="searchVisionCtg" id="searchVisionCtg"/>
        <form:hidden path="searchVisionCtgNm" id="searchVisionCtgNm"/>
        <form:hidden path="searchVisionCtgAll" id="searchVisionCtgAll" value="${so.searchVisionCtgAll}"/>
        <form:hidden path="searchVisionCtgNmAll" id="searchVisionCtgNmAll" value="${so.searchVisionCtgNmAll}"/>
        <c:choose>
        	<c:when test="${empty so.searchVisionCtg}">
		        <div class="search_filter">
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
		                    <input type="text" id="searchWord" name="searchWord" class="form_search">
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
		                <button type="button" class="btn_good_search btn_category_search">찾기<i></i></button>
		            </div>
		        </div>
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
                        Dmall.FormUtil.submit('/front/search/goods-list-search', param);
        			}
        		</script>
        		<div class="lens_recomm_menu">
        			<input type="hidden" id="searchType" name="searchType" value="0"/>
					<a href="#none" <c:if test="${so.searchVisionCtgAll == so.searchVisionCtg}">class="active"</c:if> onclick="fn_vision_search('${so.searchVisionCtgAll}','${so.searchVisionCtgNmAll}')">전체</a>					
					<c:forEach var="vision_result" items="${searchVisionCtg}" varStatus="status">
						<a href="#none" <c:if test="${so.searchVisionCtg == vision_result.searchVisionCtg}">class="active"</c:if> onclick="fn_vision_search('${vision_result.searchVisionCtg}','${vision_result.searchVisionCtgNm}')">${vision_result.searchVisionCtgNm}</a>
					</c:forEach>
					<!-- 
					<button type="button" class="btn_lens_show" onclick="document.location.href='/front/vision/vision-check';">렌즈추천 다시받기<i></i></button>
					 -->
					<button type="button" class="btn_lens_show" onclick="document.location.href='/front/vision2/vision-check';">렌즈추천 다시받기<i></i></button>
				</div>
        	</c:otherwise>
        </c:choose>
        <!--// 검색결과 -->

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
        <!-- 목록헤드 -->

        <!-- 목록영역 -->
        <div class="product_list_area">
            <c:choose>
                <c:when test="${resultListModel.resultList ne null}">
                    <data:goodsList value="${resultListModel.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
                </c:when>
                <c:otherwise>
                    <p class="no_blank" style="padding:50px 0 50px 0;">등록된 상품이 없습니다.</p>
                </c:otherwise>
            </c:choose>
            <!---- 페이징 ---->
            <div class="tPages" id="div_id_paging">
                <grid:paging resultListModel="${resultListModel}" />
            </div>
            <!----// 페이징 ---->
        </div>
        <!--// 목록영역 -->
        </form:form>
    </div>
    <!---// 02.LAYOUT: 상품 메인 --->
    <!-- 상품이미지 미리보기 팝업 -->
    <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
        <div id ="goodsPreview"></div>
    </div>
    <!--// 상품이미지 미리보기 팝업 -->
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
    <!---// popup 장바구니 등록성공 --->
    </t:putAttribute>
</t:insertDefinition>