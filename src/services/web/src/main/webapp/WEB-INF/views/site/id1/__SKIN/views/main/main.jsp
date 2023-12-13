<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="content">
        <div id="main_container">
            <%@ include file="main_visual.jsp" %>
            <!-- Best of Best -->
            <div class="best_area">
                <div class="main_layout_middle">
                    <h2 class="main_title">Best of Best</h2>
                    <div class="main_mid_tab">
	                    <ul class="BB_list">
	                    	<c:forEach var="mainAreaTypeA" items="${mainAreaTypeA}" varStatus="status">
	                   			<a href="javascript:;" data-slide-index="${status.index}" <c:if test="${status.index==0}"> class="active" </c:if>><span>${mainAreaTypeA.dispNm}</span></a>
	                        </c:forEach>
	                    </ul>
                    </div>
                    <!-- 베스트오브베스트 배너영역 슬라이드 -->
					<div class="BB_banner_area">
						<div class="BB_list_banner">
							<ul>
								<c:choose>
    								<c:when test="${main_banner_A.resultList ne null && fn:length(main_banner_A.resultList) gt 0}">
										<c:forEach var="resultModel" items="${main_banner_A.resultList}" varStatus="status">
										<li>
											<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
												<div class="text_area" style="display:none;"><!-- 2018-11-16 감춤 -->
													<%-- <p class="name">${resultModel.bannerNm}</p>
													<p class="price">${resultModel.bannerDscrt}</p> --%>
												</div>
												<img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}" title="${resultModel.bannerNm}">
											</a>
										</li>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<%--등록된 데이터가 없습니다.--%>
									</c:otherwise>
									</c:choose>
							</ul>
						</div>
					</div>
					<!--// 베스트오브베스트 배너영역 슬라이드 -->
                    <!-- slider -->
                    <div class="BB_slider">
                    <c:forEach var="mainAreaTypeA" items="${mainAreaTypeA}" varStatus="status">
  	                    <c:set var="mainAreaTypeAList" value="mainAreaTypeA${status.index}" />
		            	<c:set var="list" value="${requestScope.get(mainAreaTypeAList)}" />
		            	<%-- <data:goodsList value="${list}" displayTypeCd="08" headYn="N" iconYn="N"/> --%>
		            	 <ul class="BB_list">
		            	 <c:forEach var="goodsList" items="${list}" varStatus="stts" end="5">
		            	 	<c:set var="salePrice" value="0"/>
							<c:set var="customerPrice" value="${goodsList.customerPrice}"/>
							<c:set var="dcAmt" value="0"/>
							<c:set var="totalSaleRate" value="0"/>
		            	 	<c:choose>
		            	 		<c:when test="${stts.index==0}">
		            	 			<li class="w">
										<a href="javascript:goods_detail('${goodsList.goodsNo}');">
											<div class="img_area">
												<img src="${_IMAGE_DOMAIN}${goodsList.goodsDispImgF}" alt="${goodsList.goodsNm}" title="${goodsList.goodsNm}">
											</div>
											<div class="text_area">
												<p class="name">${goodsList.goodsNm}</p>
												<p class="price">
			                                    	<%--<fmt:formatNumber value="${goodsList.salePrice}" groupingUsed="true"/>

			                                    	<c:if test="${goodsList.salePrice ne goodsList.customerPrice and goodsList.customerPrice > 0}">
			                                    	<span class="discount">
			                                    		<del><fmt:formatNumber value="${goodsList.customerPrice}" groupingUsed="true"/></del>

			                                    		<span class="icon_down"><fmt:formatNumber value="${100-(goodsList.salePrice/goodsList.customerPrice*100)}" pattern="0"/>%</span>
			                                    	</span>
			                                    	</c:if>--%>
			                                       <c:if test="${goodsList.customerPrice eq 0}">
													   <c:set var="customerPrice" value="${goodsList.salePrice}"/>
												   </c:if>
												   <c:choose>
													  <c:when test="${goodsList.prmtDcGbCd eq '01'}" >
														<c:set var="dcAmt" value="${((goodsList.salePrice*goodsList.prmtDcValue/100)/10)*10}"/>
													  </c:when>
													  <c:when test="${goodsList.prmtDcGbCd eq '02'}" >
														<c:set var="dcAmt" value="${goodsList.prmtDcValue}"/>
													  </c:when>
													  <c:otherwise>
													  </c:otherwise>
												   </c:choose>
												   <c:set var="salePrice" value="${goodsList.salePrice-dcAmt}"/>
												   <c:set var="totalSaleRate" value="${100-(salePrice/customerPrice*100)}"/>
													<%--<c:if test="${salePrice ne customerPrice and customerPrice > 0}">--%>

													<c:if test="${salePrice < goodsList.couponApplyAmt or goodsList.couponApplyAmt eq null}">
                                                        <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        <c:if test="${totalSaleRate > 0}">
                                                        <span class="discount">
                                                            <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                            <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                        </span>
                                                        </c:if>
                                                    </c:if>

                                                    <c:if test="${salePrice >= goodsList.couponApplyAmt}">
                                                        <c:if test="${goodsList.couponApplyAmt<=0 or salePrice eq goodsList.couponApplyAmt}">
                                                            <c:if test="${totalSaleRate > 0}">
                                                            <span class="discount">
                                                                <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                                <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                            </span>
                                                            </c:if>
                                                            <c:if test="${totalSaleRate <= 0}">
                                                            <span class="discount">
                                                        	    <c:if test="${goodsList.couponBnfCd eq '03'}">
                                                        	    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        	    <span style="color:#214bbb">
																${goodsList.couponBnfTxt}
																</span>
                                                                </c:if>
                                                                <c:if test="${goodsList.couponBnfCd ne '03'}">
																<span class="icon_down">
																<fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
																</span>
                                                                </c:if>
                                                        	</span>
                                                            </c:if>
                                                        </c:if>
                                                        <c:if test="${goodsList.couponApplyAmt>0 and salePrice ne goodsList.couponApplyAmt}">

                                                        	<span class="discount">
                                                        	    <c:if test="${goodsList.couponBnfCd eq '03'}">
                                                        	    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        	    <span style="color:#214bbb">
																${goodsList.couponBnfTxt}
																</span>
                                                                </c:if>
                                                                <c:if test="${goodsList.couponBnfCd ne '03'}">
																<span class="icon_down">
																<fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
																</span>
																<span>쿠폰 적용가</span>
																<fmt:formatNumber value="${goodsList.couponApplyAmt}" groupingUsed="true"/>원
                                                                </c:if>
                                                        	</span>
                                                        	<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                            <c:if test="${totalSaleRate > 0}">
                                                            <span class="discount">
                                                                <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                                <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                            </span>
                                                            </c:if>--%>
                                                        </c:if>
                                                    </c:if>
			                                    </p>
											</div>
										</a>
									</li>
									<li class="h"></li>
		            	 		</c:when>
		            	 		<c:otherwise>
			            	 		<li>
										<a href="javascript:goods_detail('${goodsList.goodsNo}');">
											<div class="img_area">
												<img src="${_IMAGE_DOMAIN}${goodsList.goodsDispImgF}" alt="${goodsList.goodsNm}" title="${goodsList.goodsNm}">
											</div>
											<div class="text_area">
												<p class="name">${goodsList.goodsNm}</p>
												<p class="price">
			                                    	<%--<fmt:formatNumber value="${goodsList.salePrice}" groupingUsed="true"/>
			                                    	<c:if test="${goodsList.salePrice ne goodsList.customerPrice and goodsList.customerPrice > 0}">
			                                    	<span class="discount">
			                                    		<del><fmt:formatNumber value="${goodsList.customerPrice}" groupingUsed="true"/></del>

			                                    		<span class="icon_down"><fmt:formatNumber value="${100-(goodsList.salePrice/goodsList.customerPrice*100)}" pattern="0"/>%</span>
			                                    	</span>
			                                    	</c:if>--%>
			                                    	<c:if test="${goodsList.customerPrice eq 0}">
													   <c:set var="customerPrice" value="${goodsList.salePrice}"/>
												   </c:if>
												   <c:choose>
													  <c:when test="${goodsList.prmtDcGbCd eq '01'}" >
														<c:set var="dcAmt" value="${((goodsList.salePrice*goodsList.prmtDcValue/100)/10)*10}"/>
													  </c:when>
													  <c:when test="${goodsList.prmtDcGbCd eq '02'}" >
														<c:set var="dcAmt" value="${goodsList.prmtDcValue}"/>
													  </c:when>
													  <c:otherwise>
													  </c:otherwise>
												   </c:choose>
												   <c:set var="salePrice" value="${goodsList.salePrice-dcAmt}"/>
												   <c:set var="totalSaleRate" value="${100-(salePrice/customerPrice*100)}"/>
													<%--<c:if test="${salePrice ne customerPrice and customerPrice > 0}">--%>
													<c:if test="${salePrice < goodsList.couponApplyAmt or goodsList.couponApplyAmt eq null}">
                                                        <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        <c:if test="${totalSaleRate > 0}">
                                                        <span class="discount">
                                                            <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                            <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                        </span>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${salePrice >= goodsList.couponApplyAmt}">
                                                        <c:if test="${goodsList.couponApplyAmt<=0}">
                                                            <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                            <c:if test="${totalSaleRate > 0}">
                                                            <span class="discount">
                                                                <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                                <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                            </span>
                                                            </c:if>
                                                        </c:if>
                                                        <c:if test="${goodsList.couponApplyAmt>0}">

															<span class="discount">
															    <c:if test="${goodsList.couponBnfCd eq '03'}">
															    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        	    <span style="color:#214bbb">
																${goodsList.couponBnfTxt}
																</span>
                                                                </c:if>
                                                                <c:if test="${goodsList.couponBnfCd ne '03'}">
																<span class="icon_down">
																<fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
																</span>
																<span>쿠폰 적용가</span>
																<fmt:formatNumber value="${goodsList.couponApplyAmt}" groupingUsed="true"/>원
                                                                </c:if>

															</span>
															<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                            <c:if test="${totalSaleRate > 0}">
                                                            <span class="discount">
                                                                <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                                <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                            </span>
                                                            </c:if>--%>
                                                        </c:if>
                                                    </c:if>
			                                    </p>
											</div>
										</a>
									</li>
			            	 	</c:otherwise>
		            	 	</c:choose>
		            	 </c:forEach>
		            	 </ul>
                    </c:forEach>
                    </div>
                    <!--// slider -->
                    <div class="BB_slider_btn">
                        <button type="button" class="btn_BB_list_prev">이전으로</button>
                        <button type="button" class="btn_BB_list_next">다음으로</button>
                    </div>
                </div>
            </div>
            <!--// Best of Best -->

            <!-- Beauty & Living -->
            <div class="main_layout_middle">
				<!-- D매거진 배너 -->
				<%@ include file="main_magazine_list.jsp" %>
				<!-- D매거진 배너 -->
				<c:if test="${main_banner_middle_left.resultList ne null or main_banner_middle_right.resultList ne null}">
                <div class="mid_banner_area">
                <c:choose>
					<c:when test="${main_banner_middle_left.resultList ne null && fn:length(main_banner_middle_left.resultList) gt 0}">
		                <c:forEach var="resultModel" items="${main_banner_middle_left.resultList}" varStatus="status">
		                    <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');" class="floatL"><img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}" title="${resultModel.bannerNm}" onerror="this.src='${_SKIN_IMG_PATH}/product/product_300_300.gif'"></a>
		                </c:forEach>
    		        </c:when>
		            <c:otherwise>
		            		<%--<a href="javascript:;" class="floatL"><img class="lazy" data-original="${_SKIN_IMG_PATH}/product/product_300_300.gif"></a>--%>
		            </c:otherwise>
		        </c:choose>
		        <c:choose>
					<c:when test="${main_banner_middle_right.resultList ne null && fn:length(main_banner_middle_right.resultList) gt 0}">
		                <c:forEach var="resultModel" items="${main_banner_middle_right.resultList}" varStatus="status">
		                    <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');" class="floatR"><img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}" title="${resultModel.bannerNm}" onerror="this.src='${_SKIN_IMG_PATH}/product/product_300_300.gif'"></a>
		                </c:forEach>
		            </c:when>
		            <c:otherwise>
							<%--<a href="javascript:;" class="floatR"><img class="lazy" data-original="${_SKIN_IMG_PATH}/product/product_300_300.gif"></a>--%>
		            </c:otherwise>
		        </c:choose>
                </div>
                </c:if>
                <c:if test="${main_banner_B.resultList ne null }">
                <h2 class="main_title">${mainAreaTypeB[0].dispNm}</h2>
                <div class="BL_left">
                	<c:choose>
						<c:when test="${main_banner_B.resultList ne null && fn:length(main_banner_B.resultList) gt 0}">
		                	<c:forEach var="resultModel" items="${main_banner_B.resultList}" varStatus="status">
		                    <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"><img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}" title="${resultModel.bannerNm}"></a>
		                	</c:forEach>
		                </c:when>
		                <c:otherwise>
		                	<a href="javascript:;"><img class="lazy" data-original="${_SKIN_IMG_PATH}/product/product_300_300.gif"  style="height: 100%;width: 100%;"></a>
		                </c:otherwise>
	                </c:choose>
                </div>
                </c:if>
                <c:forEach var="mainAreaTypeB" items="${mainAreaTypeB}" varStatus="status">
                <div class="BL_right">
  	                    <c:set var="mainAreaTypeBList" value="mainAreaTypeB${status.index}" />
		            	<c:set var="list" value="${requestScope.get(mainAreaTypeBList)}" />
		            	<c:forEach var="goodsList" items="${list}" varStatus="stts" end="7">
							<c:set var="salePrice" value="0"/>
							<c:set var="customerPrice" value="${goodsList.customerPrice}"/>
							<c:set var="dcAmt" value="0"/>
							<c:set var="totalSaleRate" value="0"/>
	            			<c:if test="${stts.index eq 0}">
	            				<ul class="BL_list">
	            			</c:if>
	            			<c:if test="${stts.index eq 4}">
	            				<ul class="BL_list bottom">
	            			</c:if>
							<li <c:if test="${stts.index eq 2}"> style="clear:both;"</c:if>>
								<a href="javascript:goods_detail('${goodsList.goodsNo}');">
									<div class="img_area">
										<img class="lazy" data-original="${_IMAGE_DOMAIN}${goodsList.goodsDispImgB}" alt="${goodsList.goodsNm}" title="${goodsList.goodsNm}"width="285" height="270">
									</div>
									<div class="text_area">
										<p class="name">[${goodsList.brandNm}]</p>
										<p class="goods">${goodsList.goodsNm}</p>
										<p class="price">

											<%--<fmt:formatNumber value="${goodsList.salePrice}" groupingUsed="true"/>
											<c:if test="${goodsList.salePrice ne goodsList.customerPrice and goodsList.customerPrice > 0}">
											<span class="discount">
												<del><fmt:formatNumber value="${goodsList.customerPrice}" groupingUsed="true"/></del>

												<span class="icon_down"><fmt:formatNumber value="${100-(goodsList.salePrice/goodsList.customerPrice*100)}" pattern="0"/>%</span>
											</span>
											</c:if>--%>
											<c:if test="${goodsList.customerPrice eq 0}">
												   <c:set var="customerPrice" value="${goodsList.salePrice}"/>
											   </c:if>
											   <c:choose>
												  <c:when test="${goodsList.prmtDcGbCd eq '01'}" >
													<c:set var="dcAmt" value="${((goodsList.salePrice*goodsList.prmtDcValue/100)/10)*10}"/>
												  </c:when>
												  <c:when test="${goodsList.prmtDcGbCd eq '02'}" >
													<c:set var="dcAmt" value="${goodsList.prmtDcValue}"/>
												  </c:when>
												  <c:otherwise>
												  </c:otherwise>
											   </c:choose>
											   <c:set var="salePrice" value="${goodsList.salePrice-dcAmt}"/>
											   <c:set var="totalSaleRate" value="${100-(salePrice/customerPrice*100)}"/>

												<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
												&lt;%&ndash;<c:if test="${salePrice ne customerPrice and customerPrice > 0}">&ndash;%&gt;
												<c:if test="${totalSaleRate > 0}">
												<span class="discount">
													<del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
													<span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
												</span>
												</c:if>--%>
                                            <c:if test="${salePrice < goodsList.couponApplyAmt or goodsList.couponApplyAmt eq null}">
                                                <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                <c:if test="${totalSaleRate > 0}">
                                                <span class="discount">
                                                    <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                    <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                </span>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${salePrice >= goodsList.couponApplyAmt}">
                                                <c:if test="${goodsList.couponApplyAmt<=0 or salePrice eq goodsList.couponApplyAmt}">
                                                    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                    <c:if test="${totalSaleRate > 0}">
                                                    <span class="discount">
                                                        <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                        <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                    </span>
                                                    </c:if>
                                                </c:if>
                                                <c:if test="${goodsList.couponApplyAmt>0 and salePrice ne goodsList.couponApplyAmt}">

													<span class="discount">
													    <c:if test="${goodsList.couponBnfCd eq '03'}">
													    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        <span style="color:#214bbb">
                                                        ${goodsList.couponBnfTxt}
                                                        </span>
                                                        </c:if>
                                                        <c:if test="${goodsList.couponBnfCd ne '03'}">
                                                        <span class="icon_down">
                                                        <fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
                                                        </span>
                                                        <span>쿠폰 적용가</span>
                                                        <fmt:formatNumber value="${goodsList.couponApplyAmt}" groupingUsed="true"/>원
                                                        </c:if>
													</span>
													<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                    <c:if test="${totalSaleRate > 0}">
                                                    <span class="discount">
                                                        <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                        <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                    </span>
                                                    </c:if>--%>
                                                </c:if>
                                            </c:if>
										</p>
									</div>
								</a>
							</li>
							<c:if test="${stts.index eq 3}"></ul></div></c:if>
		            	</c:forEach>
		            			</ul>
		          </div>
		          </c:forEach>

            <!--// Beauty & Living -->

            <!-- MD Pick -->
            <div class="main_layout_middle">
				<c:if test="${main_banner_text.resultList ne null && fn:length(main_banner_text.resultList) gt 0}">
				<div class="MD_top">
					<a href="#none" class="MD_prev" style="z-index:9999;"><i>이전으로</i></a>
                    <a href="#none" class="MD_next" style="z-index:9999;"><i>다음으로</i></a>
                    <ul>
	                    <c:forEach var="resultModel" items="${main_banner_text.resultList}" varStatus="status">
	                    	<li><h2 class="MD_banner" <c:if test="${!empty resultModel.linkUrl}"> onclick="click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');"</c:if>>${resultModel.bannerNm}</h2></li>
		                </c:forEach>
	                </ul>
                </div>
				</c:if>

				<c:forEach var="mainAreaTypeC" items="${mainAreaTypeC}" varStatus="status">
					<c:set var="mainAreaTypeCList" value="mainAreaTypeC${status.index}" />
	        		<c:set var="list" value="${requestScope.get(mainAreaTypeCList)}" />
		            <h2 class="main_title">${mainAreaTypeC.dispNm}</h2>
	                <ul class="MD_list">
		            <c:forEach var="goodsList" items="${list}" varStatus="stts">
		            	<c:set var="salePrice" value="0"/>
		            	<c:set var="customerPrice" value="${goodsList.customerPrice}"/>
		            	<c:set var="dcAmt" value="0"/>
		            	<c:set var="totalSaleRate" value="0"/>
		            	<%-- <data:goodsList value="${list}" displayTypeCd="05" headYn="N" iconYn="N"/>   --%>
		            	<li>
							<a href="javascript:goods_detail('${goodsList.goodsNo}');">
								<div class="img_area"><img class="lazy" data-original="${_IMAGE_DOMAIN}${goodsList.goodsDispImgB}" alt="${goodsList.goodsNm}" title="${goodsList.goodsNm}"></div>
								<div class="text_area">
									<p class="name">${goodsList.goodsNm}</p>
		                            <p class="price">
									   <c:if test="${goodsList.customerPrice eq 0}">
										   <c:set var="customerPrice" value="${goodsList.salePrice}"/>
									   </c:if>
									   <c:choose>
										  <c:when test="${goodsList.prmtDcGbCd eq '01'}" >
										  	<c:set var="dcAmt" value="${((goodsList.salePrice*goodsList.prmtDcValue/100)/10)*10}"/>
										  </c:when>
										  <c:when test="${goodsList.prmtDcGbCd eq '02'}" >
										  	<c:set var="dcAmt" value="${goodsList.prmtDcValue}"/>
										  </c:when>
										  <c:otherwise>
										  </c:otherwise>
									   </c:choose>
									   <c:set var="salePrice" value="${goodsList.salePrice-dcAmt}"/>
									   <c:set var="totalSaleRate" value="${100-(salePrice/customerPrice*100)}"/>
                                    	<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                    	&lt;%&ndash;<c:if test="${salePrice ne customerPrice and customerPrice > 0}">&ndash;%&gt;
                                    	<c:if test="${totalSaleRate > 0}">
                                    	<span class="discount">
                                    		<del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                    		<span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                    	</span>
                                    	</c:if>--%>
                                    	<c:if test="${salePrice < goodsList.couponApplyAmt or goodsList.couponApplyAmt eq null}">
                                            <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                            <c:if test="${totalSaleRate > 0}">
                                            <span class="discount">
                                                <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                            </span>
                                            </c:if>
                                            <c:if test="${totalSaleRate <= 0}">
                                            <span class="discount">
                                                <c:if test="${goodsList.couponBnfCd eq '03'}">
                                                <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                <span style="color:#214bbb">
                                                ${goodsList.couponBnfTxt}
                                                </span>
                                                </c:if>
                                            </span>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${salePrice >= goodsList.couponApplyAmt}">
                                            <c:if test="${goodsList.couponApplyAmt<=0 or salePrice eq goodsList.couponApplyAmt}">

                                                <c:if test="${totalSaleRate > 0}">
                                                <span class="discount">
                                                    <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                    <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                </span>
                                                </c:if>
                                                <c:if test="${totalSaleRate <= 0}">
                                                    <span class="discount">
                                                        <c:if test="${goodsList.couponBnfCd eq '03'}">
                                                        <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                        <span style="color:#214bbb">
                                                        ${goodsList.couponBnfTxt}
                                                        </span>
                                                        </c:if>
                                                        <c:if test="${goodsList.couponBnfCd ne '03'}">
                                                        <span class="icon_down">
                                                        <fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
                                                        </span>
                                                        </c:if>
                                                    </span>
                                                    </c:if>
                                            </c:if>
                                            <c:if test="${goodsList.couponApplyAmt>0 and salePrice ne goodsList.couponApplyAmt}">

												<span class="discount">
												    <c:if test="${goodsList.couponBnfCd eq '03'}">
												    <fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                    <span style="color:#214bbb">
                                                    ${goodsList.couponBnfTxt}
                                                    </span>
                                                    </c:if>
                                                    <c:if test="${goodsList.couponBnfCd ne '03'}">
                                                    <span class="icon_down">
                                                    <fmt:formatNumber value="${goodsList.couponDcRate}" groupingUsed="true"/>% ↓
                                                    </span>
                                                    <span>쿠폰 적용가</span>
                                                    <fmt:formatNumber value="${goodsList.couponApplyAmt}" groupingUsed="true"/>원
                                                    </c:if>
												</span>
												<%--<fmt:formatNumber value="${salePrice}" groupingUsed="true"/>원
                                                <c:if test="${totalSaleRate > 0}">
                                                <span class="discount">
                                                    <del><fmt:formatNumber value="${customerPrice}" groupingUsed="true"/>원</del>
                                                    <span class="icon_down"><fmt:formatNumber value="${totalSaleRate}" pattern="0"/>%</span>
                                                </span>
                                                </c:if>--%>
                                            </c:if>
                                        </c:if>
                                    </p>
								</div>
							</a>
						</li>
		            </c:forEach>
                	</ul>
            	</c:forEach>
            </div>
            <!--// MD Pick -->

            <!-- BRAND SHOP -->
            <c:if test="${fn:length(resultListModel) > 0 }">
            <div class="main_layout_middle">
                <h2 class="main_title">BRAND SHOP</h2>
                <ul class="brand_list">
                	<c:forEach var="brandList" items="${resultListModel}" varStatus="status">
  	                    <li><a href="javascript:ajaxGoodsList('${brandList.brandNo}');"><img class="lazy" data-original="${_IMAGE_DOMAIN}/image/image-view?type=BRAND&id1=${brandList.brandLogoImgPath}_${brandList.brandLogoImgNm}" alt="${brandList.brandNm}" title="${brandList.brandNm}"></a></li>
                    </c:forEach>
                </ul>
            </div>
            </c:if>
            <!--// BRAND SHOP -->
        </div>

        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
        <%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>
        <!-- 상품이미지 미리보기 팝업 -->
        <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
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
        <%-- main Bottom --%>


        <%--

        <c:if test="${!empty displayGoods1}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods1}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods2}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods2}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods3}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods3}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods4}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods4}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods5}">
            <div class="main_layout_middle">
                <div id="main_best_product">
                <data:goodsList value="${displayGoods5}" headYn="Y" iconYn="Y" />
                </div>
            </div>
        </c:if>

        --%>

    </t:putAttribute>
     <t:putAttribute name="script">
        <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
		<!-- lazyload 1.9.3 CDN -->
		<script src="/front/js/lib/jquery.lazyload.min.js" charset="utf-8"></script>
        <script>
		$("img.lazy").lazyload({
			threshold :0,        //뷰포트에 보이기 300px 전에 미리 로딩
			effect : "fadeIn"       //효과
		});
        $(document).ready(function(){
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
        });

        //브랜드관 이동
       	function ajaxGoodsList(searchBrands){

			var param = 'searchBrands='+searchBrands;
			var url = '/front/brand-category-dtl?'+param;

			location.href=url;
		}
        </script>
    </t:putAttribute>
</t:insertDefinition>