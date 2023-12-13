<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="gnb">
    <div class="layout">
        <ul class="gnb_list">
                <li><a href="javascript:;" class="gnb_menu btn_all" rel="layer_all"><i>전체메뉴</i></a></li>
                <!-- <li><a href="javascript:;" class="gnb_menu blue" rel="gnb_menu01">EASY PICK!<i class="arrow"></i></a></li> -->
                <li><a href="javascript:;" onclick="move_category('434','best');return false;" class="gnb_menu blue active">BEST</a></li>
				<%--<li><a href="/front/vision2/vision-check" class="gnb_menu blue active">맞춤렌즈</a></li>--%>
				<%--<li><a href="javascript:;" onclick="move_category('426');return false;" class="gnb_menu blue active">매장픽업</a></li>--%>
			<c:set value="2" var="idx"/>
            <c:forEach var="gnbList" items="${gnb_info.get('0')}" varStatus="status">
                <c:if test="${gnbList.ctgNo eq '747'}">
                <li><a href="/front/vision2/vision-check" class="gnb_menu" >렌즈추천</a></li>
                </c:if>
                <li>
                    <a href="#gnb0${gnbList.ctgNo}" onclick="move_category('${gnbList.ctgNo}');return false;" class="gnb_menu" rel="gnb_menu0${idx}">
                    <c:set value="${idx+1 }" var="idx"/>
                    <c:if test="${gnbList.ctgExhbtionTypeCd eq 1}">
                    	<c:if test="${gnbList.ctgNo eq '747'}">
                        <i class="icon_maga"></i>
                        </c:if>
                    ${gnbList.ctgNm}
                        <c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0}">
                        <i class="arrow"></i>
                        </c:if>
                    </c:if>
                    <c:if test="${gnbList.ctgExhbtionTypeCd eq 2}">
                        <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList.ctgImgPath}_${gnbList.ctgImgNm}" <c:if test="${!empty gnbList.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList.mouseoverImgPath}_${gnbList.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList.ctgImgPath}_${gnbList.ctgImgNm}'"</c:if>/>
                        <c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0 || gnbList.ctgNo eq '747'}">
                        <i class="arrow"></i>
                        </c:if>

                    </c:if>
                    </a>
                </li>
            </c:forEach>

        </ul>

        <!-- 실시간 인기어 -->
		<div class="hot_word">
			<a href="#" onclick><em></em><span></span></a>
			<button type="button" class="btn_hot_word">더보기</button>
		</div>

		<!-- 펼침 보기 -->
		<div class="hot_word_view">
			<h1 class="hot_tit">실시간 인기 검색어</h1>
			<!-- <a href="#" class="hot_list"><em class="top">1</em><span>동글이안경</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em class="top">2</em><span>성유리선글라스</span><i class="hot_same">동률</i></a>
			<a href="#" class="hot_list"><em class="top">3</em><span>온수매트</span><i class="hot_down">하락</i></a>
			<a href="#" class="hot_list"><em>4</em><span>컬러원데이</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>5</em><span>곤약떡볶이</span><i class="hot_down">상승</i></a>
			<a href="#" class="hot_list"><em>6</em><span>다비치이벤트</span><i class="hot_same">상승</i></a>
			<a href="#" class="hot_list"><em>7</em><span>led미용기기</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>8</em><span>비비엠</span><i class="hot_down">상승</i></a>
			<a href="#" class="hot_list"><em>9</em><span>다비치매장</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>10</em><span>다온</span><i class="hot_down">상승</i></a>
			<div class="hot_btm">
				2019. 09. 18 10:16:00 기준
			</div> -->
		</div>
		<!--// 펼침 보기 -->
		<!--// 실시간 인기어 -->
    </div>
    <!-- layer_all -->
    <div class="layer_all" style="visibility: hidden;">
    	<div class="layer_all_top">
			<a href="javascript:;" onclick="move_category('434','best');return false;">BEST</a>
			<a href="/front/vision2/vision-check">렌즈추천 서비스</a>
			<a href="javascript:;" onclick="move_category('426');return false;">매장픽업</a>
			<a href="javascript:;" onclick="move_category('747');return false;">D.매거진</a>
		</div>
        <div class="layer_all_row">
        <c:forEach var="lnbList" items="${lnb_info.get('0')}" varStatus="status">
        <c:if test="${lnbList.ctgNo ne '426' and lnbList.ctgNo ne '434' and lnbList.ctgNo ne '747'}">
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('${lnbList.ctgNo}');">
                <c:if test="${lnbList.ctgExhbtionTypeCd eq 1}">
                    ${lnbList.ctgNm}
                </c:if>
                <c:if test="${lnbList.ctgExhbtionTypeCd eq 2}">
                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList.ctgImgPath}_${lnbList.ctgImgNm}" <c:if test="${!empty lnbList.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList.mouseoverImgPath}_${lnbList.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList.ctgImgPath}_${lnbList.ctgImgNm}'"</c:if>/>
                </c:if>
                </a>
            </h2>
            <c:if test="${fn:length(lnb_info.get(lnbList.ctgNo)) > 0}">
                <c:forEach var="lnbList2" items="${lnb_info.get(lnbList.ctgNo)}" varStatus="status1">
                    <a href="javascript:move_category('${lnbList2.ctgNo}')">
                        <c:if test="${lnbList2.ctgExhbtionTypeCd eq 1}">
                            ${lnbList2.ctgNm}
                        </c:if>
                        <c:if test="${lnbList2.ctgExhbtionTypeCd eq 2}">
                            <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList2.ctgImgPath}_${lnbList2.ctgImgNm}" <c:if test="${!empty lnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList2.mouseoverImgPath}_${lnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${lnbList2.ctgImgPath}_${lnbList2.ctgImgNm}'"</c:if>/>
                        </c:if>
                    </a>
                </c:forEach>
            </c:if>
        </div>
        </c:if>
        </c:forEach>
        </div>
        <div class="layer_all_bottom">
            <ul class="menu">
                <li><a href="/front/brand-category">브랜드관</a></li>
                <li><a href="/front/promotion/promotion-list">기획전</a></li>
                <li><a href="/front/event/event-list">이벤트</a></li>
                <li><a href="/front/customer/customer-main">고객센터</a></li>
            </ul>
            <div class="right">
                <a href="/front/vision2/vision-check">렌즈추천</a>
                <a href="/front/visit/visit-welcome">방문예약</a>
            </div>
        </div>
    </div>
    <!--// layer_all -->

    <!-- layer_2depth -->
    <div class="layer_2depth gnb_menu01 eazypick" style="visibility: hidden;">
		<div class="easypick_tit">
			쇼핑이 잘보인다! <em>다비치마켓</em>
		</div>
		<div class="gnb_box">
			<h2><a href="javascript:;" onclick="move_category('1');return false;">안경테</a></h2>
			<a href="javascript:;" onclick="move_category('439');return false;">디자인별 추천</a>
			<a href="javascript:;" onclick="move_category('374');return false;">착용목적별 추천</a>
			<a href="javascript:;" onclick="move_category('342');return false;">얼굴형별 추천</a>

			<h2><a href="javascript:;" onclick="move_category('3');return false;">안경렌즈</a></h2>
			<a href="javascript:;" onclick="move_category('400');return false;">시력증상별 추천</a>
			<a href="javascript:;" onclick="move_category('390');return false;">생활패턴별 추천</a>

			<h2><a href="javascript:;" onclick="move_category('4');return false;">콘택트렌즈</a></h2>
			<a href="javascript:;" onclick="move_category('12');return false;">컬러별 추천</a>
			<a href="javascript:;" onclick="move_category('13');return false;">착용주기별 추천</a>
			<a href="javascript:;" onclick="move_category('16');return false;">가격대 추천</a>

			<h2><a href="javascript:;" onclick="move_category('2');return false;">선글라스</a></h2>
			<a href="javascript:;" onclick="move_category('26');return false;">디자인별 추천</a>
			<a href="javascript:;" onclick="move_category('28');return false;">컬러별 추천</a>
			<a href="javascript:;" onclick="move_category('27');return false;">소재별 추천</a>
		</div>
		<div class="gnb_easypick">
			<a href="javascript:;" onclick="move_category('434','best');return false;"><img src="${_SKIN_IMG_PATH}/header/easypick_01.gif" alt="잘 나가는 BEST"></a>
			<a href="/front/vision2/vision-check"><img src="${_SKIN_IMG_PATH}/header/easypick_02.gif" alt="맞춤렌즈 큐레이팅 서비스"></a>
			<a href="javascript:;" onclick="move_category('426');return false;"><img src="${_SKIN_IMG_PATH}/header/easypick_03.gif" alt="기다림 없는 매장픽업"></a>
		</div>
	</div>
	<c:set value="2" var="idx"/>
	<c:forEach var="gnbList" items="${gnb_info.get('0')}" varStatus="status">
		<c:if test="${fn:length(lnb_info.get(gnbList.ctgNo)) > 0 || gnbList.ctgNo eq '747'}">
			<c:set var="menuType" value=" beauty" />
			<c:set var="limit" value="10" />
			<c:if test="${gnbList.ctgNo eq '762' }"><c:set var="menuType" value=" glass" /><c:set var="limit" value="3" /></c:if>
			<c:if test="${gnbList.ctgNo eq '4' }"><c:set var="menuType" value=" con_lens" /><c:set var="limit" value="3" /></c:if>
			<c:if test="${gnbList.ctgNo eq '171' }"><c:set var="menuType" value=" beauty" /><c:set var="limit" value="10" /></c:if>
			<c:if test="${gnbList.ctgNo eq '170' }"><c:set var="menuType" value=" health" /><c:set var="limit" value="8" /></c:if>
			<c:if test="${gnbList.ctgNo eq '169' }"><c:set var="menuType" value=" living" /><c:set var="limit" value="6" /></c:if>
			<c:if test="${gnbList.goodsContsGbCd eq '02' }"><c:set var="menuType" value=" magazine" /></c:if>
			<c:choose>
				<c:when test="${menuType eq ' glass' }"><!-- 아이웨어 -->
					<div class="layer_2depth gnb_menu0${idx} ${menuType}" style="visibility: hidden;">
						<div class="inner">
							<div class="gnb_box left">
								<c:forEach var="gnbList2" items="${lnb_info.get(gnbList.ctgNo)}" varStatus="status2">
									<c:choose>
										<c:when test="${status2.index eq 0 }">
											<div class="gnb_box_s">
												<p class="glass_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<div class="depth04_top_hot">
													<c:set var="best_ctgNo" value=""/>
													<c:set var="hot_ctgNo" value=""/>
													<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
														<c:if test="${gnbList3.ctgNm eq 'BEST'}"><c:set var="best_ctgNo" value="${gnbList3.ctgNo}"/></c:if>
														<c:if test="${gnbList3.ctgNm eq 'HOT'}"><c:set var="hot_ctgNo" value="${gnbList3.ctgNo}"/></c:if>
													</c:forEach>
													<c:if test="${best_ctgNo ne ''}"><a href="javascript:move_category('${best_ctgNo }')">BEST</a></c:if>
													<c:if test="${hot_ctgNo ne ''}"><a href="javascript:move_category('${hot_ctgNo }')">HOT</a></c:if>
												</div>
												<ul class="depth04_menu">
													<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
														<c:if test="${gnbList3.ctgNm ne 'BEST' and gnbList3.ctgNm ne 'HOT'}">
															<a href="javascript:move_category('${gnbList3.ctgNo}')">
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
								                                    ${gnbList3.ctgNm}
								                                </c:if>
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
								                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
								                                </c:if>
								                            </a>
							                            </c:if>
													</c:forEach>
												</ul>
											</div>
										</c:when>
										<c:when test="${status2.index eq 1 }">
											<div class="gnb_box_s gray">
												<p class="glass_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<div class="depth04_top_hot">
													<c:set var="best_ctgNo" value=""/>
													<c:set var="hot_ctgNo" value=""/>
													<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
														<c:if test="${gnbList3.ctgNm eq 'BEST'}"><c:set var="best_ctgNo" value="${gnbList3.ctgNo}"/></c:if>
														<c:if test="${gnbList3.ctgNm eq 'HOT'}"><c:set var="hot_ctgNo" value="${gnbList3.ctgNo}"/></c:if>
													</c:forEach>
													<c:if test="${best_ctgNo ne ''}"><a href="javascript:move_category('${best_ctgNo }')">BEST</a></c:if>
													<c:if test="${hot_ctgNo ne ''}"><a href="javascript:move_category('${hot_ctgNo }')">HOT</a></c:if>
												</div>
												<ul class="depth04_menu">
													<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
														<c:if test="${gnbList3.ctgNm ne 'BEST' and gnbList3.ctgNm ne 'HOT'}">
															<a href="javascript:move_category('${gnbList3.ctgNo}')">
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
								                                    ${gnbList3.ctgNm}
								                                </c:if>
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
								                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
								                                </c:if>
								                            </a>
							                            </c:if>
													</c:forEach>
												</ul>
											</div>
										</c:when>
										<c:when test="${status2.index eq 2 }">
											<div class="gnb_box_s three">
												<p class="glass_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
													<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('${gnbList3.ctgNo}')">
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
								                                    ${gnbList3.ctgNm}
								                                </c:if>
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
								                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
								                                </c:if>
								                            </a>
								                        </li>
								                        <c:forEach var="gnbList4" items="${lnb_info.get(gnbList3.ctgNo)}" varStatus="status4">
									                        <li>
									                            <a href="javascript:move_category('${gnbList4.ctgNo}')">
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 1}">
									                                    ${gnbList4.ctgNm}
									                                </c:if>
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 2}">
									                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}" <c:if test="${!empty gnbList4.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.mouseoverImgPath}_${gnbList4.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}'"</c:if>/>
									                                </c:if>
									                            </a>
									                        </li>
								                        </c:forEach>
									                </ul>
												</c:forEach>
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</div>
							<div class="gnb_box right">
				            	<c:forEach items="${main_disp_goods}" var="mainDispGoods">
				            		<c:if test="${mainDispGoods.ctgNo eq gnbList.ctgNo}">
				            			<a href="javascript:goods_detail('${mainDispGoods.goodsNo }');">
						                    <img src="${_IMAGE_DOMAIN}${mainDispGoods.ctgImgPath}" alt="${mainDispGoods.goodsNm }" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">${mainDispGoods.goodsNm }</p>

						                    <c:if test="${mainDispGoods.ctgExhbtionTypeCd ne '2' }">
						                    	<p class="price">
						                    		<c:if test="${mainDispGoods.customerPrice > 0 and mainDispGoods.customerPrice ne mainDispGoods.salePrice}">
						                    		<span class="discount">￦<fmt:formatNumber value="${mainDispGoods.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
						                    		</c:if>
						                    		￦<fmt:formatNumber value="${mainDispGoods.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						                    	</p>
						                    </c:if>
						                </a>
				            		</c:if>
				            	</c:forEach>
				            </div>
						</div>
					</div>
				</c:when>
				<c:when test="${menuType eq ' con_lens' }"><!-- 콘택트렌즈 -->
					<div class="layer_2depth gnb_menu0${idx} ${menuType}" style="visibility: hidden;">
						<div class="inner">
							<div class="gnb_box left">
								<c:forEach var="gnbList2" items="${lnb_info.get(gnbList.ctgNo)}" varStatus="status2">
									<c:choose>
										<c:when test="${status2.index eq 0 }">
											<div class="gnb_box_s con_brand">
												<p class="glass_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<ul class="depth04_menu">
													<c:set var="best_ctgNo" value=""/>
													<c:set var="hot_ctgNo" value=""/>
													<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
														<c:choose>
															<c:when test="${gnbList3.ctgNm eq 'BEST'}"><c:set var="best_ctgNo" value="${gnbList3.ctgNo}"/></c:when>
															<c:when test="${gnbList3.ctgNm eq 'HOT'}"><c:set var="hot_ctgNo" value="${gnbList3.ctgNo}"/></c:when>
															<c:otherwise>
																<a href="javascript:move_category('${gnbList3.ctgNo}')">
									                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
									                                    ${gnbList3.ctgNm}
									                                </c:if>
									                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
									                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
									                                </c:if>
									                            </a>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</ul>
												<div class="depth04_top_hot">
													<c:if test="${best_ctgNo ne ''}"><a href="javascript:move_category('${best_ctgNo }')">BEST</a></c:if>
													<c:if test="${hot_ctgNo ne ''}"><a href="javascript:move_category('${hot_ctgNo }')">HOT</a></c:if>
												</div>
											</div>
										</c:when>
										<c:when test="${status2.index eq 1 }">
											<div class="gnb_box_s color">
												<p class="lens_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
													<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('${gnbList3.ctgNo}')">
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
								                                    ${gnbList3.ctgNm}
								                                </c:if>
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
								                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
								                                </c:if>
								                            </a>
								                        </li>
								                        <c:forEach var="gnbList4" items="${lnb_info.get(gnbList3.ctgNo)}" varStatus="status4">
									                        <li>
									                            <a href="javascript:move_category('${gnbList4.ctgNo}')">
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 1}">
									                                    ${gnbList4.ctgNm}
									                                </c:if>
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 2}">
									                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}" <c:if test="${!empty gnbList4.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.mouseoverImgPath}_${gnbList4.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}'"</c:if>/>
									                                </c:if>
									                            </a>
									                        </li>
								                        </c:forEach>
									                </ul>
												</c:forEach>
											</div>
										</c:when>
										<c:when test="${status2.index eq 2 }">
											<div class="gnb_box_s transparent">
												<p class="lens_tit">
													<a href="javascript:move_category('${gnbList2.ctgNo}')">
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
						                                    ${gnbList2.ctgNm}
						                                </c:if>
						                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
						                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
						                                </c:if>
						                            </a>
												</p>
												<c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
													<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('${gnbList3.ctgNo}')">
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
								                                    ${gnbList3.ctgNm}
								                                </c:if>
								                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
								                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
								                                </c:if>
								                            </a>
								                        </li>
								                        <c:forEach var="gnbList4" items="${lnb_info.get(gnbList3.ctgNo)}" varStatus="status4">
									                        <li>
									                            <a href="javascript:move_category('${gnbList4.ctgNo}')">
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 1}">
									                                    ${gnbList4.ctgNm}
									                                </c:if>
									                                <c:if test="${gnbList4.ctgExhbtionTypeCd eq 2}">
									                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}" <c:if test="${!empty gnbList4.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.mouseoverImgPath}_${gnbList4.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList4.ctgImgPath}_${gnbList4.ctgImgNm}'"</c:if>/>
									                                </c:if>
									                            </a>
									                        </li>
								                        </c:forEach>
									                </ul>
												</c:forEach>
											</div>
										</c:when>
									</c:choose>
								</c:forEach>
							</div>
							<div class="gnb_box right">
				            	<c:forEach items="${main_disp_goods}" var="mainDispGoods">
				            		<c:if test="${mainDispGoods.ctgNo eq gnbList.ctgNo}">
				            			<a href="javascript:goods_detail('${mainDispGoods.goodsNo }');">
						                    <img src="${_IMAGE_DOMAIN}${mainDispGoods.ctgImgPath}" alt="${mainDispGoods.goodsNm }" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">${mainDispGoods.goodsNm }</p>

						                    <c:if test="${mainDispGoods.ctgExhbtionTypeCd ne '2' }">
						                    	<p class="price">
						                    		<c:if test="${mainDispGoods.customerPrice > 0 and mainDispGoods.customerPrice ne mainDispGoods.salePrice}">
						                    		<span class="discount">￦<fmt:formatNumber value="${mainDispGoods.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
						                    		</c:if>
						                    		￦<fmt:formatNumber value="${mainDispGoods.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						                    	</p>
						                    </c:if>
						                </a>
				            		</c:if>
				            	</c:forEach>
				            </div>
						</div>
					</div>
				</c:when>
				<c:when test="${menuType eq ' magazine' }"><!-- D.매거진 -->
					<div class="layer_2depth gnb_menu0${idx} ${menuType}" style="visibility: hidden;">
						<div class="inner">
							<div class="gnb_box right">
				            	<c:forEach items="${main_disp_goods}" var="mainDispGoods">
				            		<c:if test="${mainDispGoods.ctgNo eq gnbList.ctgNo}">
				            			<a href="javascript:goods_detail('${mainDispGoods.goodsNo }');">
						                    <img src="${_IMAGE_DOMAIN}${mainDispGoods.ctgImgPath}" alt="${mainDispGoods.goodsNm }" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">${mainDispGoods.goodsNm }</p>

						                    <c:if test="${mainDispGoods.ctgExhbtionTypeCd ne '2' }">
						                    	<p class="price">
						                    		<c:if test="${mainDispGoods.customerPrice > 0 and mainDispGoods.customerPrice ne mainDispGoods.salePrice}">
						                    		<span class="discount">￦<fmt:formatNumber value="${mainDispGoods.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
						                    		</c:if>
						                    		￦<fmt:formatNumber value="${mainDispGoods.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						                    	</p>
						                    </c:if>
						                </a>
				            		</c:if>
				            	</c:forEach>
				            </div>
						</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="layer_2depth gnb_menu0${idx} ${menuType}" style="visibility: hidden;">
						<div class="inner">
							<div class="gnb_box left">
								<c:forEach var="gnbList2" items="${lnb_info.get(gnbList.ctgNo)}" varStatus="status2" end="${limit -1 }">
									<ul class="depth04_menu <c:if test="${status2.first or (menuType eq ' beauty' and status2.index eq 5) or (menuType eq ' health' and status2.index eq 4)}"> first</c:if>">
				                        <li class="tit">
				                            <a href="javascript:move_category('${gnbList2.ctgNo}')">
				                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 1}">
				                                    ${gnbList2.ctgNm}
				                                </c:if>
				                                <c:if test="${gnbList2.ctgExhbtionTypeCd eq 2}">
				                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}" <c:if test="${!empty gnbList2.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.mouseoverImgPath}_${gnbList2.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList2.ctgImgPath}_${gnbList2.ctgImgNm}'"</c:if>/>
				                                </c:if>
				                            </a>
				                        </li>
				                        <c:forEach var="gnbList3" items="${lnb_info.get(gnbList2.ctgNo)}" varStatus="status3">
					                        <li>
					                            <a href="javascript:move_category('${gnbList3.ctgNo}')">
					                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 1}">
					                                    ${gnbList3.ctgNm}
					                                </c:if>
					                                <c:if test="${gnbList3.ctgExhbtionTypeCd eq 2}">
					                                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}" <c:if test="${!empty gnbList3.mouseoverImgPath}">onmouseover="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.mouseoverImgPath}_${gnbList3.mouseoverImgNm}'" onmouseout="this.src='${_IMAGE_DOMAIN}/image/image-view?type=CATEGORY&id1=${gnbList3.ctgImgPath}_${gnbList3.ctgImgNm}'"</c:if>/>
					                                </c:if>
					                            </a>
					                        </li>
				                        </c:forEach>
					                </ul>
					                <c:if test="${(menuType eq ' beauty' and status2.index eq 4) or (menuType eq ' health' and status2.index eq 3)}">
					                <div class="clear"></div>
					                </c:if>
								</c:forEach>
							</div>
							<div class="gnb_box right">
				            	<c:forEach items="${main_disp_goods}" var="mainDispGoods">
				            		<c:if test="${mainDispGoods.ctgNo eq gnbList.ctgNo}">
				            			<a href="javascript:goods_detail('${mainDispGoods.goodsNo }');">
						                    <img src="${_IMAGE_DOMAIN}${mainDispGoods.ctgImgPath}" alt="${mainDispGoods.goodsNm }" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">${mainDispGoods.goodsNm }</p>

						                    <c:if test="${mainDispGoods.ctgExhbtionTypeCd ne '2' }">
						                    	<p class="price">
						                    		<c:if test="${mainDispGoods.customerPrice > 0 and mainDispGoods.customerPrice ne mainDispGoods.salePrice}">
						                    		<span class="discount">￦<fmt:formatNumber value="${mainDispGoods.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
						                    		</c:if>
						                    		￦<fmt:formatNumber value="${mainDispGoods.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						                    	</p>
						                    </c:if>
						                </a>
				            		</c:if>
				            	</c:forEach>
				            </div>
						</div>
					</div>
				</c:otherwise>

			</c:choose>
		</c:if>

		<c:set value="${idx+1 }" var="idx"/>
	</c:forEach>
    <!--// layer_2depth -->
</div>

<%--
<div id="gnb">
    <div class="layout">
        <ul class="gnb_list">
                <li><a href="javascript:;" class="gnb_menu btn_all" rel="layer_all"><i>전체메뉴</i></a></li>
                <!-- <li><a href="javascript:;" class="gnb_menu blue" rel="gnb_menu01">EASY PICK!<i class="arrow"></i></a></li> -->
                <li><a href="javascript:;" onclick="move_category('434','best');return false;" class="gnb_menu blue">BEST</a></li>
				<li><a href="/front/vision2/vision-check" class="gnb_menu blue">맞춤렌즈</a></li>
				<li><a href="javascript:;" onclick="move_category('426');return false;" class="gnb_menu blue">매장픽업</a></li>
			<li>
                    <a href="#gnb0762" onclick="move_category('762');return false;" class="gnb_menu" rel="gnb_menu02">
                    아이웨어<i class="arrow"></i>
                        </a>
                </li>
            <li>
                    <a href="#gnb04" onclick="move_category('4');return false;" class="gnb_menu" rel="gnb_menu03">
                    콘택트렌즈<i class="arrow"></i>
                        </a>
                </li>
            <li>
                    <a href="#gnb0171" onclick="move_category('171');return false;" class="gnb_menu" rel="gnb_menu04">
                    뷰티<i class="arrow"></i>
                        </a>
                </li>
            <li>
                    <a href="#gnb0170" onclick="move_category('170');return false;" class="gnb_menu" rel="gnb_menu05">
                    헬스케어<i class="arrow"></i>
                        </a>
                </li>
            <li>
                    <a href="#gnb0169" onclick="move_category('169');return false;" class="gnb_menu active" rel="gnb_menu06">
                    리빙<i class="arrow"></i>
                        </a>
                </li>
            <li>
                    <a href="#gnb0747" onclick="move_category('747');return false;" class="gnb_menu" rel="gnb_menu07">
                    <i class="icon_maga"></i>
                        D.매거진<i class="arrow"></i>
                        </a>
                </li>
            </ul>

        <!-- 실시간 인기어 -->
		<div class="hot_word">
			<a href="#" onclick=""><em>8</em><span>아큐브</span></a>
			<button type="button" class="btn_hot_word">더보기</button>
		</div>

		<!-- 펼침 보기 -->
		<div class="hot_word_view" style="display: none;">
			<h1 class="hot_tit">실시간 인기 검색어</h1>
			<!-- <a href="#" class="hot_list"><em class="top">1</em><span>동글이안경</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em class="top">2</em><span>성유리선글라스</span><i class="hot_same">동률</i></a>
			<a href="#" class="hot_list"><em class="top">3</em><span>온수매트</span><i class="hot_down">하락</i></a>
			<a href="#" class="hot_list"><em>4</em><span>컬러원데이</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>5</em><span>곤약떡볶이</span><i class="hot_down">상승</i></a>
			<a href="#" class="hot_list"><em>6</em><span>다비치이벤트</span><i class="hot_same">상승</i></a>
			<a href="#" class="hot_list"><em>7</em><span>led미용기기</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>8</em><span>비비엠</span><i class="hot_down">상승</i></a>
			<a href="#" class="hot_list"><em>9</em><span>다비치매장</span><i class="hot_up">상승</i></a>
			<a href="#" class="hot_list"><em>10</em><span>다온</span><i class="hot_down">상승</i></a>
			<div class="hot_btm">
				2019. 09. 18 10:16:00 기준
			</div> -->
		&lt;%&ndash;<a href="#" class="hot_list"><em class="top">1</em><span>뜨레뷰</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em class="top">2</em><span>안경테</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em class="top">3</em><span>누진</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em>4</em><span>쿠퍼비전</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em>5</em><span>클래리티</span><i class="hot_down">하락</i></a><a href="#" class="hot_list"><em>6</em><span>투명렌즈</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em>7</em><span>선글라스</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em>8</em><span>아큐브</span><i class="hot_down">하락</i></a><a href="#" class="hot_list"><em>9</em><span>베타티타늄</span><i class="hot_up">상승</i></a><a href="#" class="hot_list"><em>10</em><span>누진렌즈</span><i class="hot_same">동률</i></a><div class="hot_btm">2020. 02. 21 17:05:14 기준</div></div>&ndash;%&gt;
		<!--// 펼침 보기 -->
		<!--// 실시간 인기어 -->
    </div>
    <!-- layer_all -->
    <div class="layer_all" style="visibility: hidden;">
    	<div class="layer_all_top">
			<a href="javascript:;" onclick="move_category('434','best');return false;">BEST</a>
			<a href="/front/vision2/vision-check">렌즈추천 서비스</a>
			<a href="javascript:;" onclick="move_category('426');return false;">매장픽업</a>
			<a href="javascript:;" onclick="move_category('747');return false;">D.매거진</a>
		</div>
        <div class="layer_all_row">
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('762');">
                아이웨어</a>
            </h2>
            <a href="javascript:move_category('1')">
                        안경테</a>
                <a href="javascript:move_category('2')">
                        선글라스</a>
                <a href="javascript:move_category('3')">
                        안경렌즈</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('4');">
                콘택트렌즈</a>
            </h2>
            <a href="javascript:move_category('661')">
                        브랜드</a>
                <a href="javascript:move_category('702')">
                        컬러렌즈</a>
                <a href="javascript:move_category('708')">
                        투명렌즈</a>
                <a href="javascript:move_category('807')">
                        2월 기획전</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('171');">
                뷰티</a>
            </h2>
            <a href="javascript:move_category('312')">
                        피부별고민</a>
                <a href="javascript:move_category('196')">
                        스킨케어</a>
                <a href="javascript:move_category('174')">
                        메이크업</a>
                <a href="javascript:move_category('200')">
                        바디케어</a>
                <a href="javascript:move_category('779')">
                        브랜드관</a>
                <a href="javascript:move_category('687')">
                        남성 </a>
                <a href="javascript:move_category('494')">
                        헤어케어</a>
                <a href="javascript:move_category('201')">
                        뷰티 Acc.</a>
                <a href="javascript:move_category('168')">
                        패션</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('170');">
                헬스케어</a>
            </h2>
            <a href="javascript:move_category('778')">
                        선물세트</a>
                <a href="javascript:move_category('179')">
                        365일 건강케어</a>
                <a href="javascript:move_category('317')">
                        기능별 헬스케어</a>
                <a href="javascript:move_category('172')">
                        스포츠용품</a>
                <a href="javascript:move_category('790')">
                        식품</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('169');">
                리빙</a>
            </h2>
            <a href="javascript:move_category('294')">
                        인테리어 </a>
                <a href="javascript:move_category('792')">
                        욕실/여성용품</a>
                <a href="javascript:move_category('180')">
                        주방용품</a>
                <a href="javascript:move_category('507')">
                        청소.세제/건강관리</a>
                <a href="javascript:move_category('167')">
                        가전</a>
                <a href="javascript:move_category('311')">
                        장난감</a>
                <a href="javascript:move_category('251')">
                        반려동물</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('5');">
                보청기</a>
            </h2>
            <a href="javascript:move_category('520')">
                        난청정보</a>
                <a href="javascript:move_category('572')">
                        4주무료체험캠페인</a>
                <a href="javascript:move_category('571')">
                        정부지원보조금</a>
                <a href="javascript:move_category('570')">
                        청력지킴이봉사활동</a>
                <a href="javascript:move_category('569')">
                        청력사관학교</a>
                <a href="javascript:move_category('516')">
                        다비치보청기 특별함</a>
                <a href="javascript:move_category('466')">
                        청각정보</a>
                </div>
        <div class="menu_box">
            <h2>
                <a href="javascript:move_category('808');">
                Shop in Shop</a>
            </h2>
            </div>
        </div>
        <div class="layer_all_bottom">
            <ul class="menu">
                <li><a href="/front/brand-category">브랜드관</a></li>
                <li><a href="/front/promotion/promotion-list">기획전</a></li>
                <li><a href="/front/event/event-list">이벤트</a></li>
                <li><a href="/front/customer/customer-main">고객센터</a></li>
            </ul>
            <div class="right">
                <a href="/front/vision2/vision-check">렌즈추천</a>
                <a href="/front/visit/visit-welcome">방문예약</a>
            </div>
        </div>
    </div>
    <!--// layer_all -->

    <!-- layer_2depth -->
    <div class="layer_2depth gnb_menu01 eazypick" style="visibility: hidden; height: 20px;">
		<div class="easypick_tit">
			쇼핑이 잘보인다! <em>다비치마켓</em>
		</div>
		<div class="gnb_box">
			<h2><a href="javascript:;" onclick="move_category('1');return false;">안경테</a></h2>
			<a href="javascript:;" onclick="move_category('439');return false;">디자인별 추천</a>
			<a href="javascript:;" onclick="move_category('374');return false;">착용목적별 추천</a>
			<a href="javascript:;" onclick="move_category('342');return false;">얼굴형별 추천</a>

			<h2><a href="javascript:;" onclick="move_category('3');return false;">안경렌즈</a></h2>
			<a href="javascript:;" onclick="move_category('400');return false;">시력증상별 추천</a>
			<a href="javascript:;" onclick="move_category('390');return false;">생활패턴별 추천</a>

			<h2><a href="javascript:;" onclick="move_category('4');return false;">콘택트렌즈</a></h2>
			<a href="javascript:;" onclick="move_category('12');return false;">컬러별 추천</a>
			<a href="javascript:;" onclick="move_category('13');return false;">착용주기별 추천</a>
			<a href="javascript:;" onclick="move_category('16');return false;">가격대 추천</a>

			<h2><a href="javascript:;" onclick="move_category('2');return false;">선글라스</a></h2>
			<a href="javascript:;" onclick="move_category('26');return false;">디자인별 추천</a>
			<a href="javascript:;" onclick="move_category('28');return false;">컬러별 추천</a>
			<a href="javascript:;" onclick="move_category('27');return false;">소재별 추천</a>
		</div>
		<div class="gnb_easypick">
			<a href="javascript:;" onclick="move_category('434','best');return false;"><img src="/skin/img/header/easypick_01.gif" alt="잘 나가는 BEST"></a>
			<a href="/front/vision2/vision-check"><img src="/skin/img/header/easypick_02.gif" alt="맞춤렌즈 큐레이팅 서비스"></a>
			<a href="javascript:;" onclick="move_category('426');return false;"><img src="/skin/img/header/easypick_03.gif" alt="기다림 없는 매장픽업"></a>
		</div>
	</div>
	<!-- 아이웨어 -->
					<div class="layer_2depth gnb_menu02 glass" style="visibility: hidden; height: 379px;">
						<div class="inner">
							<div class="gnb_box left">
								<div class="gnb_box_s">
												<p class="glass_tit">
													<a href="javascript:move_category('1')">
						                                안경테</a>
												</p>
												<div class="depth04_top_hot">
													<a href="javascript:move_category('382')">BEST</a><a href="javascript:move_category('437')">HOT</a></div>
												<ul class="depth04_menu">
													<a href="javascript:move_category('788')">
								                                비치베르 기획전</a>
							                            <a href="javascript:move_category('374')">
								                                착용목적</a>
							                            <a href="javascript:move_category('21')">
								                                브랜드</a>
							                            <a href="javascript:move_category('436')">
								                                사이즈</a>
							                            <a href="javascript:move_category('439')">
								                                디자인</a>
							                            <a href="javascript:move_category('366')">
								                                가격대</a>
							                            <a href="javascript:move_category('342')">
								                                얼굴형</a>
							                            <a href="javascript:move_category('438')">
								                                재질</a>
							                            <a href="javascript:move_category('440')">
								                                연령</a>
							                            <a href="javascript:move_category('333')">
								                                안경악세서리</a>
							                            <a href="javascript:move_category('548')">
								                                다온 동글이 1만원</a>
							                            </ul>
											</div>
										<div class="gnb_box_s gray">
												<p class="glass_tit">
													<a href="javascript:move_category('2')">
						                                선글라스</a>
												</p>
												<div class="depth04_top_hot">
													<a href="javascript:move_category('641')">BEST</a><a href="javascript:move_category('633')">HOT</a></div>
												<ul class="depth04_menu">
													<a href="javascript:move_category('25')">
								                                브랜드</a>
							                            <a href="javascript:move_category('26')">
								                                스타일</a>
							                            <a href="javascript:move_category('28')">
								                                컬러</a>
							                            <a href="javascript:move_category('647')">
								                                가격대</a>
							                            <a href="javascript:move_category('642')">
								                                사용자</a>
							                            </ul>
											</div>
										<div class="gnb_box_s three">
												<p class="glass_tit">
													<a href="javascript:move_category('3')">
						                                안경렌즈</a>
												</p>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('725')">
								                                눈상태</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('726')">
									                                근시/원시</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('727')">
									                                난시</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('728')">
									                                부동시 (짝눈)</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('729')">
									                                노안 (근거리불편)</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('730')">
								                                시력보호</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('731')">
									                                블루라이트 차단</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('732')">
									                                자외선 차단</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('745')">
									                                변색 선글라스</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('734')">
									                                라식안경</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('735')">
									                                눈피로 감소</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('736')">
									                                눈부심 차단</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('737')">
									                                근거리 불편</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('738')">
									                                시력교정</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('740')">
								                                연령별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('741')">
									                                10대 안경</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('742')">
									                                20대 안경</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('743')">
									                                30대 안경</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('744')">
									                                40대 이상 안경</a>
									                        </li>
								                        </ul>
												</div>
										</div>
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G1902270055_4324');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200212_2efab354e0410618ee35c8106cd229218da2795ab2a93a9d5803ce03c034c886_135x170xO" alt="깃털처럼 가벼운 5그램 안경테" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">깃털처럼 가벼운 5그램 안경테</p>

						                    <p class="price">

						                    		￦ 130,000</p>
						                    </a>
				            		<a href="javascript:goods_detail('G2001161831_7195');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200211_f68af5e43d85d6b5d507971718f3f5f4bf5aec91378d1515e272828683f6f982_135x170xO" alt="비비엠 아세테이트 컬렉션" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">비비엠 아세테이트 컬렉션</p>

						                    <p class="price">
						                    		<span class="discount">￦ 198,000</span>

						                    		￦ 119,000</p>
						                    </a>
				            		</div>
						</div>
					</div>
				<!-- 콘택트렌즈 -->
					<div class="layer_2depth gnb_menu03 con_lens" style="visibility: hidden; height: 312px;">
						<div class="inner">
							<div class="gnb_box left">
								<div class="gnb_box_s con_brand">
												<p class="glass_tit">
													<a href="javascript:move_category('661')">
						                                브랜드</a>
												</p>
												<ul class="depth04_menu">
													<a href="javascript:move_category('52')">
									                                TREVUES뜨레뷰</a>
															<a href="javascript:move_category('53')">
									                                EYE♥LUV아이럽</a>
															<a href="javascript:move_category('547')">
									                                TENTEN텐텐</a>
															<a href="javascript:move_category('698')">
									                                세븐틴</a>
															<a href="javascript:move_category('56')">
									                                쿠퍼비전</a>
															<a href="javascript:move_category('55')">
									                                바슈롬</a>
															<a href="javascript:move_category('54')">
									                                아큐브</a>
															</ul>
												<div class="depth04_top_hot">
													</div>
											</div>
										<div class="gnb_box_s color">
												<p class="lens_tit">
													<a href="javascript:move_category('702')">
						                                컬러렌즈</a>
												</p>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('13')">
								                                착용주기별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('94')">
									                                1일 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('95')">
									                                3일 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('813')">
									                                7일 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('509')">
									                                2주 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('96')">
									                                3주 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('97')">
									                                1개월 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('98')">
									                                3~6개월 권장</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('12')">
								                                컬러별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('86')">
									                                브라운</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('87')">
									                                초코</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('88')">
									                                그레이</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('89')">
									                                블랙</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('90')">
									                                블루/그린</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('92')">
									                                혼혈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('93')">
									                                멀티</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('91')">
									                                핑크/바이올렛</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('17')">
								                                그래픽 직경</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('510')">
									                                12.8mm 이하</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('58')">
									                                12.8~13.1mm</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('59')">
									                                13.2~13.4mm</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('60')">
									                                13.5~13.8mm</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('61')">
									                                14~14.5mm</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('16')">
								                                가격별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('636')">
									                                1만원 이하</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('637')">
									                                1만원-3만원</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('638')">
									                                3만원-5만원</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('639')">
									                                5만원-10만원</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('640')">
									                                10만원 이상</a>
									                        </li>
								                        </ul>
												</div>
										<div class="gnb_box_s transparent">
												<p class="lens_tit">
													<a href="javascript:move_category('708')">
						                                투명렌즈</a>
												</p>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('709')">
								                                착용주기별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('711')">
									                                1일 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('712')">
									                                3일 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('814')">
									                                7일 권장 </a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('713')">
									                                2주 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('714')">
									                                3주 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('715')">
									                                1개월 권장</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('716')">
									                                3-6개월 권장</a>
									                        </li>
								                        </ul>
												<ul class="depth04_menu">
								                        <li class="tit">
								                            <a href="javascript:move_category('710')">
								                                증상별</a>
								                        </li>
								                        <li>
									                            <a href="javascript:move_category('717')">
									                                쉽게 피로한 눈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('718')">
									                                가까이가 흐린 눈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('719')">
									                                멀리가 흐린 눈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('720')">
									                                도수가 높은 눈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('721')">
									                                난시가 있는 눈</a>
									                        </li>
								                        <li>
									                            <a href="javascript:move_category('722')">
									                                건조한 눈</a>
									                        </li>
								                        </ul>
												</div>
										</div>
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G1812281703_3371');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200102_a19f1d432ee898c0a763450df8d71a674ed5e050270478bf58c1fb378e4159ee_135x170xO" alt="바이오트루 토릭(1day/30p)" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">바이오트루 토릭(1day/30p)</p>

						                    <p class="price">

						                    		￦ 50,000</p>
						                    </a>
				            		<a href="javascript:goods_detail('G1903071544_4411');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200102_2a1f10b4e61611370e899bee9fa77a6d7616b8394e23ed501cea814591095e09_135x170xO" alt="클래리티 원데이 토릭(1day/30p)" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">클래리티 원데이 토릭(1day/30p)</p>

						                    <p class="price">
						                    		<span class="discount">￦ 45,000</span>

						                    		￦ 24,000</p>
						                    </a>
				            		</div>
						</div>
					</div>
				<div class="layer_2depth gnb_menu04 beauty" style="visibility: hidden; height: 475px;">
						<div class="inner">
							<div class="gnb_box left">
								<ul class="depth04_menu  first">
				                        <li class="tit">
				                            <a href="javascript:move_category('312')">
				                                피부별고민</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('313')">
					                                트러블 / 피지</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('314')">
					                                수분/보습</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('315')">
					                                민감성피부</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('316')">
					                                화이트닝</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('668')">
					                                안티에이징</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('196')">
				                                스킨케어</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('677')">
					                                토너/미스트</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('678')">
					                                에센스/세럼/앰플</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('679')">
					                                에멀전/크림</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('202')">
					                                마스크팩</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('204')">
					                                선케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('682')">
					                                클렌징.필링</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('174')">
				                                메이크업</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('184')">
					                                베이스</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('683')">
					                                립 메이크업</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('684')">
					                                아이메이크업</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('763')">
					                                네일케어</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('200')">
				                                바디케어</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('659')">
					                                로션.크림</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('669')">
					                                워시.스크럽</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('746')">
					                                데오.제모</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('764')">
					                                미스트.오일</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('765')">
					                                핸드.풋</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('766')">
					                                아토피케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('767')">
					                                민감성피부</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('779')">
				                                브랜드관</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('780')">
					                                벨르랑코</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('781')">
					                                -417</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('782')">
					                                뷰애드</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('783')">
					                                르헤브</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('784')">
					                                벨라</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('785')">
					                                큐타니아</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('786')">
					                                파모나</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('787')">
					                                쯔야다마</a>
					                        </li>
				                        </ul>
					                <div class="clear"></div>
					                <ul class="depth04_menu  first">
				                        <li class="tit">
				                            <a href="javascript:move_category('687')">
				                                남성 </a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('688')">
					                                스킨케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('689')">
					                                베이스/썬케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('690')">
					                                클렌징/에프터쉐이빙</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('494')">
				                                헤어케어</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('670')">
					                                탈모케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('671')">
					                                두피케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('673')">
					                                베이직케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('674')">
					                                손상모케어</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('201')">
				                                뷰티 Acc.</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('768')">
					                                메이크업 소품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('769')">
					                                미용가전</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('770')">
					                                기타소품</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('168')">
				                                패션</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('511')">
					                                아우터</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('512')">
					                                상의</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('513')">
					                                하의</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('514')">
					                                드레스.세트</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('515')">
					                                패션잡화</a>
					                        </li>
				                        </ul>
					                </div>
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G1908101106_5788');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20191011_e4ccb5b874875da8b885fef9782a377d20218972c619d25dc42acf0e8a4002bd_135x170xO" alt="국내최초 음이온 비타민샤워필터 피부보습 아로마테라피 효과" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">국내최초 음이온 비타민샤워필터 피부보습 아로마테라피 효과</p>

						                    <p class="price">
						                    		<span class="discount">￦ 25,000</span>

						                    		￦ 8,000</p>
						                    </a>
				            		<a href="javascript:goods_detail('G1909012248_6380');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20190920_2ec5294d6e41b3a7bd789256ea6b67471cf9a3cf7a2908a73759c8135b055ec5_135x170xO" alt="포고니아 탈모방지 샴푸" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">포고니아 탈모방지 샴푸</p>

						                    <p class="price">
						                    		<span class="discount">￦ 22,900</span>

						                    		￦ 19,800</p>
						                    </a>
				            		</div>
						</div>
					</div>
				<div class="layer_2depth gnb_menu05 health" style="visibility: hidden; height: 450px;">
						<div class="inner">
							<div class="gnb_box left">
								<ul class="depth04_menu  first">
				                        <li class="tit">
				                            <a href="javascript:move_category('778')">
				                                선물세트</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('789')">
					                                추천 선물세트</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('791')">
					                                갈비세트</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('179')">
				                                365일 건강케어</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('185')">
					                                건강즙.과일즙</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('192')">
					                                건강음료</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('190')">
					                                건강환.정</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('188')">
					                                건강분말</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('191')">
					                                홍삼.인삼 제품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('189')">
					                                비타민</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('187')">
					                                영양제</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('263')">
					                                음료.차</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('758')">
					                                탄산수</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('317')">
				                                기능별 헬스케어</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('324')">
					                                대상별 헬스케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('318')">
					                                눈건강.간건강</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('319')">
					                                장건강.배변</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('320')">
					                                콜레스테롤.혈행개선</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('321')">
					                                피부건강.항산화</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('322')">
					                                지구력증진</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('323')">
					                                면역강화</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('772')">
					                                구강케어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('773')">
					                                다이어트.헬시</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('172')">
				                                스포츠용품</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('771')">
					                                스포츠웨어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('206')">
					                                요가, 필라테스</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('173')">
					                                골프웨어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('500')">
					                                기능성 웨어</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('501')">
					                                기능성 슈즈</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('266')">
					                                스포츠기타</a>
					                        </li>
				                        </ul>
					                <div class="clear"></div>
					                <ul class="depth04_menu  first">
				                        <li class="tit">
				                            <a href="javascript:move_category('790')">
				                                식품</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('798')">
					                                신선식품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('799')">
					                                가공식품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('800')">
					                                건강식품</a>
					                        </li>
				                        </ul>
					                </div>
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G1908101007_5785');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20191023_42fa16cd26b03423e9e172b432de348545d640b1700ed2dc501e924dc88e1065_135x170xO" alt="촉촉! 탄력! 먹는 콜라겐 에버콜라겐" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">촉촉! 탄력! 먹는 콜라겐 에버콜라겐</p>

						                    <p class="price">
						                    		<span class="discount">￦ 69,000</span>

						                    		￦ 30,900</p>
						                    </a>
				            		<a href="javascript:goods_detail('G1909110811_6452');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20191023_232fb31c364264095e83c1d20aebc451e484a579ff57506b5542465c3d2052f1_135x170xO" alt="V라인만들기 누트25.5 괄사마사지" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">V라인만들기 누트25.5 괄사마사지</p>

						                    <p class="price">
						                    		<span class="discount">￦ 160,000</span>

						                    		￦ 68,900</p>
						                    </a>
				            		</div>
						</div>
					</div>
				<div class="layer_2depth gnb_menu06 living" style="visibility: visible; height: 310px;">
						<div class="inner">
							<div class="gnb_box left">
								<ul class="depth04_menu  first">
				                        <li class="tit">
				                            <a href="javascript:move_category('294')">
				                                인테리어 </a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('775')">
					                                인테리어 소품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('335')">
					                                1인 가구</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('237')">
					                                수납</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('336')">
					                                D.I.Y</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('285')">
					                                산업용품</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('792')">
				                                욕실/여성용품</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('793')">
					                                면도용품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('794')">
					                                구강용품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('796')">
					                                생리대</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('180')">
				                                주방용품</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('222')">
					                                식기.홈세트</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('227')">
					                                수저.조리기구</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('228')">
					                                수납.정리.잡화</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('225')">
					                                보온.보냉용품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('226')">
					                                칼.도마.커팅기구</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('223')">
					                                컵.머그.티포트</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('230')">
					                                밀폐용기.양념통</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('221')">
					                                냄비.후라이팬</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('229')">
					                                커피/베이킹용품</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('507')">
				                                청소.세제/건강관리</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('691')">
					                                세제</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('777')">
					                                청소용품</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('797')">
					                                마스크</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('167')">
				                                가전</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('213')">
					                                생활가전</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('175')">
					                                주방가전</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('212')">
					                                음향가전</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('211')">
					                                주변기기</a>
					                        </li>
				                        </ul>
					                <ul class="depth04_menu ">
				                        <li class="tit">
				                            <a href="javascript:move_category('311')">
				                                장난감</a>
				                        </li>
				                        <li>
					                            <a href="javascript:move_category('332')">
					                                보드게임</a>
					                        </li>
				                        <li>
					                            <a href="javascript:move_category('724')">
					                                어린이 장난감</a>
					                        </li>
				                        </ul>
					                </div>
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G1909101717_6446');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20191011_fe1d582072a3d96691fd1c22d023686cd39efff1ef6d1b456a9c61fb12e5e5fb_135x170xO" alt="스팀보이 침대용 온수매트  S6500-S1812(퀸)" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">스팀보이 침대용 온수매트  S6500-S1812(퀸)</p>

						                    <p class="price">
						                    		<span class="discount">￦ 289,000</span>

						                    		￦ 195,000</p>
						                    </a>
				            		<a href="javascript:goods_detail('G1909101751_6450');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20190920_76d9323b475af704d99c4abd1d447699650f0b6cba731de6d46057b49c398657_135x170xO" alt="(온라인단독)닥터웰 말락스 목어깨 안마기 DR-2400" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">(온라인단독)닥터웰 말락스 목어깨 안마기 DR-2400</p>

						                    <p class="price">
						                    		<span class="discount">￦ 99,000</span>

						                    		￦ 48,000</p>
						                    </a>
				            		</div>
						</div>
					</div>
				<!-- D.매거진 -->
					<div class="layer_2depth gnb_menu07 magazine" style="visibility: hidden; height: 20px;">
						<div class="inner">
							<div class="gnb_box right">
				            	<a href="javascript:goods_detail('G2001071359_7152');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200107_d58e25753cc0030ca5cb30925924325eb6def59f845147c75a1e897a0661a88e_135x170xO" alt="난시렌즈란 무엇인가?" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">난시렌즈란 무엇인가?</p>

						                    </a>
				            		<a href="javascript:goods_detail('G2001151722_7186');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200115_4e382ef72a098b118651d41b77621c904b4bcea3b1102136081a50ddd85b1f7f_135x170xO" alt="다비치 안경테는 왜 저렴할까?" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">다비치 안경테는 왜 저렴할까?</p>

						                    </a>
				            		<a href="javascript:goods_detail('G2001161012_7187');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200116_93df6b57ba3c44f26e267dcca3129bc96a2051a2fbf0e3f8658483b6c0d38ab4_135x170xO" alt="누진렌즈 사용방법을 상세히!" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">누진렌즈 사용방법을 상세히!</p>

						                    </a>
				            		<a href="javascript:goods_detail('G2001301725_7225');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200130_8e796c69ef19a7622b0141839a63718457229f36ea87b3314d95d91baaa8394c_135x170xO" alt="마마무 5그램 비비엠 안경테 " width="135px"> <!-- size 135*170 -->
						                    <p class="tit">마마무 5그램 비비엠 안경테 </p>

						                    </a>
				            		<a href="javascript:goods_detail('G2001310906_7226');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200131_0b04fa5e68c2c961d3213c04ceaedf372d10f7b592c19a1248ae1b60199742ab_135x170xO" alt="자외선 차단되는 콘택트렌즈" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">자외선 차단되는 콘택트렌즈</p>

						                    </a>
				            		<a href="javascript:goods_detail('G2002071743_7282');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200207_162c9ef18e5e6391f8e133d58143d508800993e2367405afc7440fe415a0f1cf_135x170xO" alt="안경을 착용하면 시력이 나빠지나요?" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">안경을 착용하면 시력이 나빠지나요?</p>

						                    </a>
				            		<a href="javascript:goods_detail('G2002101012_7286');">
						                    <img src="${_IMAGE_DOMAIN}/image/image-view?type=GOODSDTL&amp;id1=20200210_d169be20453e23cbb826aeec1ef355f3d57d2917f13f2669652aab6ee0d78318_135x170xO" alt="렌즈 훌라현상" width="135px"> <!-- size 135*170 -->
						                    <p class="tit">렌즈 훌라현상</p>

						                    </a>
				            		</div>
						</div>
					</div>
				<!--// layer_2depth -->
</div>--%>
