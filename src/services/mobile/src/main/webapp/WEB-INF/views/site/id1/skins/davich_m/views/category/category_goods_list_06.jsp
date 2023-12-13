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
	<t:putAttribute name="title">${so.ctgNm}</t:putAttribute>
	<t:putAttribute name="script">
	<script type="text/javascript" src="${_MOBILE_PATH}/front/js/swiper.min.js"></script>
	<script>
	$(document).ready(function(){
		
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">

	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">
		<!--- navigation --->
		<%@ include file="navigation.jsp" %>
		<!---// navigation --->

		<c:if test="${fn:length(category_list) > 0}">
			<c:forEach var="category_list" items="${category_list}" varStatus="status">
			
				<h3 class="best_area_tit">${category_list.dispzoneNm} BEST</h3>
				
				<c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
		        <c:set var="list" value="${requestScope.get(goods_list)}" />
		        <c:if test="${fn:length(list) > 0 }">
			        <c:forEach var="li" items="${list}" varStatus="status2">
			        	<c:choose>
				        	<c:when test="${status2.first }"><!-- 베스트1상품 -->
								<ul class="product_list_Best">
									<li>    
										<a href="javascript:goods_detail('${li.goodsNo }');">
											<div class="img_area">        
												<img src="${li.goodsImg02}" data-img="${li.goodsImg02}" alt="${li.goodsNm}"  title="${li.goodsNm}" width="425px" height="373px" onerror="this.src='/front/img/product/product_180_180.gif'">
												<i class="icon_best01">Best 1</i>
											</div> 
										</a>
										<div class="text_area">			
											<p class="name">${li.goodsNm }</p>	
											<div class="label_area">
												${li.iconImgs }
											</div>
											
											<p class="price"><fmt:formatNumber value="${li.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</p>
											<c:if test="${li.customerPrice > li.salePrice}">
											<span class="discount">
												<del><fmt:formatNumber value="${li.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>                   
												<span class="icon_down"><fmt:formatNumber value="${li.saleRate }" pattern="0" />%</span>
											</span>
											</c:if>
											<%-- <span class="counpon_img">
												<a href="javascript:downloadCoupon();">
													<img src="${_SKIN_IMG_PATH}/product/coupon_img01.gif" alt="쿠폰이미지">
												</a>
											</span> --%>
										</div>
									</li> 
								</ul>
				        	</c:when>
				        	<c:otherwise><!-- 나머지 상품 -->
				        		<c:if test="${status2.index eq 1 }">
				        			<div class="best_list_area">
										<div class="best_swiper_slider">
											<ul class="product_list_typeB swiper-wrapper">
				        		</c:if>
							        			<li class="swiper-slide">    
													<a href="javascript:goods_detail('${li.goodsNo }');">
														<div class="img_area">    
															<img src="${li.goodsDispImgB}" data-img="${li.goodsDispImgB}" alt="${li.goodsNm}"  title="${li.goodsNm}" width="285px" height="270px" onerror="this.src='/front/img/product/product_180_180.gif'">       
														</div> 
														<div class="text_area">			
															<p class="name">${li.goodsNm }</p>
															<c:if test="${li.customerPrice > li.salePrice}">
															<span class="discount">
																<del><fmt:formatNumber value="${li.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>                   
																<span class="icon_down"><fmt:formatNumber value="${li.saleRate }" pattern="0" />%</span>
															</span>
															</c:if>
															<p class="price"><fmt:formatNumber value="${li.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</p>
														</div>
														<div class="label_area">
															${li.iconImgs }
														</div>
													</a>
												</li>
				        	</c:otherwise>
				        </c:choose>
				        <c:if test="${status2.last }">
				    						</ul> 
											<div class="best_btm_area">
												<div class="best_prev"></div>
												<div class="best_swiper_pagination"></div>
												<div class="best_next"></div>
											</div>
										</div>
									</div>
							
							<c:set var="moveCtgNo" value="434"/>
							<c:choose>
						    	<c:when test="${category_list.dispzoneNm eq '안경테'}"><c:set var="moveCtgNo" value="1"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '콘택트렌즈'}"><c:set var="moveCtgNo" value="4"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '안경렌즈'}"><c:set var="moveCtgNo" value="3"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '선글라스'}"><c:set var="moveCtgNo" value="2"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq 'D.라이프'}"><c:set var="moveCtgNo" value="499"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '아이웨어'}"><c:set var="moveCtgNo" value="762"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '헬스케어'}"><c:set var="moveCtgNo" value="170"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '리빙'}"><c:set var="moveCtgNo" value="169"/></c:when>
						    	<c:when test="${category_list.dispzoneNm eq '뷰티'}"><c:set var="moveCtgNo" value="171"/></c:when>
						    </c:choose>
									<button type="button" class="search_go_more" onclick="javascript:move_category('${moveCtgNo }')">${category_list.dispzoneNm} 더보기<i></i></button>    
				        </c:if>
			        </c:forEach>
				</c:if>
			</c:forEach>
		</c:if>
		
	</div><!-- //middle_area -->
	<!---// 03.LAYOUT:CONTENTS --->

	</t:putAttribute>
</t:insertDefinition>