<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:choose>
	<c:when test="${productList.resultList eq null and promotionList.resultList eq null and magazineList.resultList eq null and newsList.resultList eq null and
					qnaList.resultList eq null and vcsList.resultList eq null and videoList.resultList eq null and withitemList.resultList eq null and dictionaryList.resultList eq null}">
			<p class="no_blank"> <em>"${so.searchWord}"</em> 에 대한 검색결과가 없습니다.</p>
	</c:when>

	<c:otherwise>

			<c:choose>
            <c:when test="${dictionaryList.resultList ne null}">
				<c:forEach var="dictionaryList" items="${dictionaryList.resultList}" varStatus="status">
					<div class="search_text_result">
						<p class="tit"><a href="/m${dictionaryList.detailLink }">${dictionaryList.title }</a></p>
						<div class="text">
							${dictionaryList.content }
						</div>
						<a href="/m${dictionaryList.detailLink }">내용 자세히 보기</a>
					</div>
				</c:forEach>
			</c:when>

			<c:otherwise>
				<div class="search_text_result">
	               <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 관련검사 검색결과가 없습니다.</p> --%>
				</div>
	           </c:otherwise>
			</c:choose>

		<c:if test="${search_banner.resultList ne null}">
		<h3 class="search_area_tit">나에게 맞는 렌즈 추천받기</h3>
		<ul class="search_event_list">
			<c:if test="${search_banner.resultList ne null && fn:length(search_banner.resultList) gt 0}">
                <c:forEach var="resultModel" items="${search_banner.resultList}" varStatus="status" end="1">
	                <li class="recomm_lens">
		                <c:if test="${!empty resultModel.linkUrl}">
		                	<a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
		                </c:if>
		                <c:if test="${empty resultModel.linkUrl}">
		                	<a href="#">
		                </c:if>
		                <p class="tit">렌즈 추천받기</p>
		                <img src="${_IMAGE_DOMAIN}/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}" alt="${resultModel.bannerNm}">
		                </a>
	                </li>
                </c:forEach>
            </c:if>
		</ul>
		</c:if>

		<!-- 상품 -->
        <c:choose>
            <c:when test="${productList.resultList ne null}">
				<h3 class="search_area_tit">상품</h3>
				<div class="search_slider_area">
					<div class="slider_area">
						<%-- ul loop --%>
					<%-- 	<c:forEach var="product" items="${productList.resultList}" varStatus="ulstatus" end="${fn:length(productList.resultList)/4}"> --%>
					<c:forEach var="product" items="${productList.resultList}" varStatus="ulstatus" end="${fn:length(productList.resultList)/5}"> <!-- 상품 페이징 갯수 -->
							<% java.util.List list = new java.util.ArrayList(); %>
							<ul class="product_list_typeB">
								<c:forEach var="product" items="${productList.resultList}" varStatus="status" begin="${ulstatus.index*4}" end="${ulstatus.index*4+3}" >
									<%
										list.add((net.danvi.dmall.biz.app.goods.model.GoodsVO) pageContext.getAttribute("product"));
									%>
								</c:forEach>
								<%
							     pageContext.setAttribute("productLi", list);
								%>
       	                    	<data:goodsList value="${productLi}" displayTypeCd="${so.displayTypeCd}" headYn="Y" topYn="N" iconYn="Y"/>
							</ul>

						</c:forEach>
 					</div>
				</div>
                </c:when>
                <c:otherwise>
                    <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
                </c:otherwise>
            </c:choose>
			<c:choose>
				<c:when test="${productList.resultList ne null}">
					<button type="button" class="search_go_more" id="product_tab" onclick="javascript:jsMoveTab('product')">상품 더보기<i></i></button>
				</c:when>
				<c:otherwise>
					<!-- <div class="search_divice"></div> -->
				</c:otherwise>
			</c:choose>

		<!-- 프로모션 -->
	    	<c:choose>
			    <c:when test="${promotionList.resultList ne null}">
				<h3 class="search_area_tit">프로모션</h3>
			    <ul class="search_event_list">
			    	<c:forEach var="promotionList" items="${promotionList.resultList}" varStatus="status">
						<li>
							<a href="/m${promotionList.detailLink }">
							<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${promotionList.prmtWebBannerImgPath}&id1=${promotionList.prmtWebBannerImg}" alt="기획전 이미지">
							<p class="tit">${promotionList.prmtNm}</p>
							</a>
						</li>
			   		</c:forEach>
				</ul>
			   </c:when>
			   <c:otherwise>
			   		<%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
			   </c:otherwise>
		   </c:choose>
		<c:choose>
			<c:when test="${promotionList.resultList ne null}">
				<button type="button" class="search_go_more" id="promotion_tab" onclick="javascript:jsMoveTab('promotion')">프로모션 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>
		<!-- //프로모션 -->

		<!-- 연관상품 -->
<%-- 			<c:choose>
                <c:when test="${withitemList.resultList ne null}">
				<h3 class="search_area_tit">MD추천</h3>
				<div class="search_slider_area">
					<div class="slider_area">
						<data:goodsList value="${withitemList.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
					</div>
		        </div>
                </c:when>
                <c:otherwise>
                    <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p>
                </c:otherwise>
            </c:choose>
		<c:choose>
			<c:when test="${withitemList.resultList ne null}">
				<button type="button" class="search_go_more" id="withitem_tab" onclick="javascript:jsMoveTab('withitem')">MD추천 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose> --%><!-- 20200612 -->
		<!-- //연관상품 -->

		<!-- 매거진 -->
		<c:choose>
			<c:when test="${magazineList.resultList ne null}">
			<h3 class="search_area_tit">D.매거진</h3>
			<ul class="search_magazine_list">
			    <c:forEach var="magazineList" items="${magazineList.resultList}" varStatus="status">
			    	<li>
			    	<a href="${magazineList.detailLink }"><img src="${_IMAGE_DOMAIN}${magazineList.goodsDispImgM }" style = "width : 90px; height : auto;" alt=""></a>
						<div class="right_text">
							<p class="tit"><a href="/m${magazineList.detailLink }">${magazineList.goodsNm}</a></p>
							<p class="text">${magazineList.prWords}<br></p>
							<span class="date">${magazineList.regDate}</span>
						</div>
					</li>
			   </c:forEach>
			</ul>
			</c:when>
			<c:otherwise>
				<%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${magazineList.resultList ne null}">
				<button type="button" class="search_go_more" id="magazine_tab" onclick="javascript:jsMoveTab('magazine')">D.매거진 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>
		<!-- //매거진 -->

		<c:choose>
            <c:when test="${videoList.resultList ne null}">
			<h3 class="search_area_tit">동영상</h3>
			<ul class="search_movie_list">
				<c:forEach var="videoList" items="${videoList.resultList}" varStatus="status">
					<li>
						<a href="${videoList.linkUrl }">
							<div class="left_movie">
								<img src="https://img.youtube.com/vi/${fn:substring(videoList.linkUrl, 17, 99)}/0.jpg" style='width:221px; height:auto' ">
								<i class="icon_play"></i>
							</div>
							<div class="right_text">
								<p class="tit">${videoList.title}</p>
								<span>${videoList.regDate }</span>
							</div>
						</a>
					</li>
				</c:forEach>
			</ul>
			</c:when>
		<c:otherwise>
             	  <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
           </c:otherwise>
		</c:choose>

		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${videoList.resultList ne null}">
				<button type="button" class="search_go_more" id="video_tab" onclick="javascript:jsMoveTab('video')">동영상 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>

		<c:choose>
            <c:when test="${qnaList.resultList ne null}">
			<h3 class="search_area_tit">Q&A - 자주하는 질문</h3>
			<ul class="search_qna_list">
			<c:forEach var="qnaList" items="${qnaList.resultList}" varStatus="status">
				<li>
					<p class="tit">
						<a href="${qnaList.detailLink}"><em>Q.</em>${qnaList.title}</a>
					</p>
					<p class="a_text"><em>A.</em>${qnaList.content }</p>
					<span class="date">${qnaList.regDate }</span>
				</li>
			</c:forEach>
			</ul>
			</c:when>
			<c:otherwise>
                <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
            </c:otherwise>
		</c:choose>

		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${qnaList.resultList ne null}">
				<button type="button" class="search_go_more" id="qna_tab" onclick="javascript:jsMoveTab('qna')">Q&A 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>

			<c:choose>
	            <c:when test="${newsList.resultList ne null}">
				<h3 class="search_area_tit">뉴스</h3>
				<ul class="search_news_list">
					<c:forEach var="newsList" items="${newsList.resultList}" varStatus="status">
						<li>
							<div class="tit">
								<a href="${newsList.detailLink }">${newsList.title }</a>
							</div>
							<a href="${newsList.detailLink }"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${newsList.imgFilePath}&amp;id1=${newsList.imgFileNm}" alt=""></a>
								<div class="right_text">
									<p class="text">${newsList.content }</p>
									<span class="date">${newsList.regDate }</span>
								</div>
						</li>
					</c:forEach>
				</ul>
				</c:when>
			<c:otherwise>
	               <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
	           </c:otherwise>
			</c:choose>

		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${newsList.resultList ne null}">
				<button type="button" class="search_go_more" id="news_tab" onclick="javascript:jsMoveTab('news')">뉴스 더보기<i></i></button>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>

			<c:choose>
            <c:when test="${vcsList.resultList ne null}">
			<h3 class="search_area_tit">관련검사</h3>
			<ul class="search_test_list">
				<c:forEach var="vcsList" items="${vcsList.resultList}" varStatus="status">
						<li>
							<a href="/m${vcsList.detailLink }"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${vcsList.imgFilePath}&amp;id1=${vcsList.imgFileNm}" alt=""></a>
							<div class="right_text">
								<p class="tit"><a href="${vcsList.detailLink }">${vcsList.title}</a></p>
								<p class="text">${vcsList.content}</p>
							</div>
						</li>
				</c:forEach>
			</ul>
			</c:when>

			<c:otherwise>
	               <%-- <p class="no_blank"><em>'${so.searchWord}'</em>에 대한 검색결과가 없습니다.</p> --%>
	           </c:otherwise>
			</c:choose>

		<c:choose>
			<c:when test="${vcsList.resultList ne null}">
				<button type="button" class="search_go_more" id="vcs_tab" onclick="javascript:jsMoveTab('vcs')">검사법 더보기<i></i></button>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
