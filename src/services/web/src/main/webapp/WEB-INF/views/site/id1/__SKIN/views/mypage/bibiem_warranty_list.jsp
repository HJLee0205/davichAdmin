<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">다비치마켓 :: 비비엠 워런티 카드</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    	<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 마이페이지 category header 메뉴 --->
    <%@ include file="include/mypage_category_menu.jsp" %>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
	<div class="mypage_middle">	
    
   		<!--- 마이페이지 왼쪽 메뉴 --->
       	<%@ include file="include/mypage_left_menu.jsp" %>
		<!---// 마이페이지 왼쪽 메뉴 --->

		<!--- 마이페이지 오른쪽 컨텐츠 --->
		<div id="mypage_content">


           	<!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
    
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_body">
				<h4 class="my_stit">비비엠 워런티 카드</h4>

				<div class="bibiem_waranty">
					<img src="${_SKIN_IMG_PATH}/mypage/bibiem_warrantycard.png" alt="">
				</div>
				<form:form id="form_id_list" commandName="so">
	              	<form:hidden path="page" id="page" />
	              	<form:hidden path="rows" id="rows" />
				<table class="tCart_Board Mypage">
					<caption>
						<h1 class="blind">비비엠 워런티 카드 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:100px">
						<col style="width:163px">
						<col style="width:">
						<col style="width:300px">
						<col style="width:234px">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>날짜</th>
							<th>이름</th>
							<th>모델명</th>
							<th>매장</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${fn:length(resultListModel.resultList) > 0}">
								<c:forEach var="warrantyList" items="${resultListModel.resultList}" varStatus="status">
									<tr>
										<td>${warrantyList.pagingNum}</td>
										<td>${warrantyList.dates}</td>
										<td>${warrantyList.memberNm}</td>
										<td>${warrantyList.itmName}</td>
										<td>${warrantyList.strName}</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="5">조회된 데이터가 없습니다.</td>
								</tr>
							</c:otherwise>
						</c:choose>

					</tbody>
				</table>
				</form:form>
				<!-- pageing -->
				<div class="tPages" id="div_id_paging">
                        <grid:paging resultListModel="${resultListModel}" />
				</div>
				<!--// pageing -->
			</div>

            <%--<div class="mypage_body">
				<h3 class="my_tit">비비엠 워런티 카드</h3>
				<div class="my_qna_info">					
					<span class="icon_purpose">사용기한이 지난 쿠폰은 자동으로 삭제됩니다.</span>	                       	                       
					<div class="my_search_area">							
						<select name="goodsTypeCd" id="searchGoodsTypeCd">
							<tags:option codeStr=":제품별;01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${so.goodsTypeCd }"/>
						</select>
						<select name="ageCd" id="searchAgeCd">
							<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;" value="${so.ageCd }"/>
						</select>
					</div>
				</div>
				<form:form id="form_id_list" commandName="so">
	              	<form:hidden path="page" id="page" />
	              	<form:hidden path="rows" id="rows" />
              									
					<table class="tCart_Board mybenefit">
						<caption>
							<h1 class="blind">나의 쿠폰 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:145px">
							<col style="width:">
							<col style="width:150px">
							<col style="width:110px">
							<col style="width:110px">
							<col style="width:140px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>쿠폰명/혜택</th>
								<th>사용기한</th>
								<th>적용대상</th>
								<th>상세</th>
								<th>사용일시</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
	                            <c:when test="${fn:length(resultListModel.resultList) > 0}">
		                            <c:forEach var="warrantyList" items="${resultListModel.resultList}" varStatus="status">
			                            <tr>
											<td class="noline">
												<div class="my_coupon
														<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}">
															<c:choose>
																<c:when test="${warrantyList.goodsTypeCd eq '01' }"> off01</c:when>
																<c:when test="${warrantyList.goodsTypeCd eq '02' }"> off04</c:when>
																<c:when test="${warrantyList.goodsTypeCd eq '03' }"> off03</c:when>
																<c:when test="${warrantyList.goodsTypeCd eq '04' }"> off02</c:when>
																<c:otherwise> off00</c:otherwise>
															</c:choose>
														</c:if>">

													<c:choose>
														<c:when test="${warrantyList.couponKindCd eq '97'}">
															증정쿠폰
														</c:when>
														<c:otherwise>
															<c:choose>
																<c:when test="${warrantyList.couponBnfCd eq '01' }">
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"><em></c:if>
																		<fmt:formatNumber value="${warrantyList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:when>
																<c:when test="${warrantyList.couponBnfCd eq '02' }">
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"><em></c:if>
																		<fmt:formatNumber value="${warrantyList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:when>
																<c:otherwise>
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"><em></c:if>
																		${warrantyList.couponBnfTxt}
																	<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:otherwise>
															</c:choose>
															${warrantyList.bnfUnit}
															<!--p class="text">할인쿠폰</p-->
															&lt;%&ndash; <c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn eq 'Y'}">
																<c:if test="${warrantyList.goodsTypeCd eq '02' || warrantyList.goodsTypeCd eq '03' || warrantyList.goodsTypeCd eq '04' }"><p class="btm">전국 다비치매장(일부매장 제외)</p></c:if>
															</c:if> &ndash;%&gt;
														</c:otherwise>
													</c:choose>
												</div>
											</td>
											<td class="textL vaT">
												<a href="javascript:;" style="cursor:default;" class="coupon_name">${warrantyList.couponNm}</a>
												<c:if test="${warrantyList.couponKindCd ne '97'}">
												<p class="coupon_option">
													<fmt:formatNumber value="${warrantyList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시
													<c:if test="${warrantyList.couponBnfCd eq '01' && warrantyList.couponBnfDcAmt > 0}">
	                                    				/ 최대 <fmt:formatNumber value="${warrantyList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
	                                    			</c:if>
												</p>
												</c:if>
											</td>
											<td>
											<c:choose>
		                                        <c:when test="${warrantyList.couponApplyPeriodCd eq '01' }">
		                                        	${warrantyList.cpApplyStartDttm}<br>~ ${warrantyList.cpApplyEndDttm}
		                                        </c:when>
		                                        <c:otherwise>
		                                        	<c:choose>
														<c:when test="${warrantyList.couponApplyPeriodCd eq '02' }">
															<c:if test="${warrantyList.couponApplyPeriodDttm ne null}">
																${warrantyList.couponApplyPeriodDttm}
																<br>
																(${warrantyList.couponApplyPeriod} 일 남음)
															</c:if>
														</c:when>
														<c:otherwise>
															<c:if test="${warrantyList.confirmYn eq 'N'}">
															구매확정일로 부터 ${warrantyList.couponApplyConfirmAfPeriod} 일간 사용 가능
															</c:if>
															<c:if test="${warrantyList.confirmYn eq 'Y'}">
															${warrantyList.couponApplyPeriodDttm}
															</c:if>
														</c:otherwise>
													</c:choose>
		                                        </c:otherwise>
		                                    </c:choose>
	                                    	</td>
	                                    	<td>
	                                    		<c:choose>
	                                    			<c:when test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}">
	                                    				<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn eq 'Y'}">
	                                    				오프라인<br>다비치매장
	                                    				</c:if>
	                                    				<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn eq 'F'}">
	                                    				온/오프라인<br>다비치매장
	                                    				</c:if>
	                                    			</c:when>
	                                    			<c:otherwise>
	                                    				<c:choose>
	                                    			<c:when test="${warrantyList.couponApplyLimitCd eq '01'}">
	                                    				전체상품
	                                    			</c:when>
	                                    			<c:otherwise>
	                                    				<button type="button" class="btn_coupon_product btn_apply_pop" data-coupon-no="${warrantyList.couponNo}" data-coupon-apply-limit-cd="${warrantyList.couponApplyLimitCd}" data-coupon-apply-target-cd="${warrantyList.couponApplyTargetCd}">적용</button>
	                                    			</c:otherwise>
	                                    		</c:choose>
	                                    			</c:otherwise>
	                                    		</c:choose>
											</td>
											<td>
												<c:if test="${warrantyList.couponKindCd eq '99' or warrantyList.offlineOnlyYn ne 'N'}">
													<c:choose>
														<c:when test="${warrantyList.useDttm eq null}">
															<button type="button" class="btn_coupon_product btn_print_pop" data-coupon-no="${warrantyList.memberCpNo}">보기/인쇄</button>
														</c:when>
														<c:otherwise>
															사용완료
														</c:otherwise>
													</c:choose>
												</c:if>
											</td>
											<td>
												<c:choose>
				                                    <c:when test="${warrantyList.useDttm eq null}">
				                                        <c:choose>
														<c:when test="${warrantyList.couponApplyPeriodCd eq '03' }">
														    <c:if test="${warrantyList.confirmYn eq 'N'}">
															사용불가
															</c:if>
															<c:if test="${warrantyList.confirmYn eq 'Y'}">
															미사용
															</c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            미사용
                                                        </c:otherwise>
                                                        </c:choose>

				                                    </c:when>
				                                    <c:otherwise>
				                                    	${warrantyList.useDttm}
				                                    </c:otherwise>
				                                </c:choose>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
		                            <tr>
		                                <td colspan="6">조회된 데이터가 없습니다.</td>
		                            </tr>
	                            </c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</form:form>
				
				<!-- pageing -->
				<div class="tPages" id="div_id_paging"> 
                        <grid:paging resultListModel="${resultListModel}" />
				</div>
				<!--// pageing -->
					
			</div>--%>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->

    </t:putAttribute>
</t:insertDefinition>