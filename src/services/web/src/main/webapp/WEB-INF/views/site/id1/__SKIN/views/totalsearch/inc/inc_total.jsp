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
					<p class="tit"><a href="${dictionaryList.detailLink }">${dictionaryList.title }</a></p>
					<div class="text" style="text-overflow: ellipsis; white-space: nowrap; width: 100%; overflow: hidden;">
						${dictionaryList.content }
					</div>
					<a href="${dictionaryList.detailLink }">내용 자세히 보기</a>
				</div>
				</c:forEach>
			</c:when>
			
			<c:otherwise>
				<%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
	           </c:otherwise>
			</c:choose>	
		
			<c:if test="${search_banner.resultList ne null || vcsList.resultList ne null}">
				<ul class="search_vision_list">
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
		<c:choose>
           <c:when test="${vcsList.resultList ne null}">
			<c:forEach var="vcsList" items="${vcsList.resultList}" varStatus="status">
					<li>
						<a href="${vcsList.detailLink }">
							<p class="tit">${vcsList.title}</p>
							<img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${vcsList.imgFilePath}&amp;id1=${vcsList.imgFileNm}" alt="" style="width:170px; height: 169px">
						</a>
					</li>
			</c:forEach>
		</c:when>
			
			<c:otherwise>
	               <%-- <p class="no_blank main"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
	           </c:otherwise>
			</c:choose>	
		</ul>
		<div class="search_divice_top"></div>
		</c:if>
		
		
		<!-- 상품 -->
            <c:choose>
                <c:when test="${productList.resultList ne null}">
                	<h3 class="search_area_tit">상품</h3>	
					<ul class="product_list_typeS search"> <!-- 검색화면용 별도 이미지 사이즈 적용 -->
               		     <data:goodsList value="${productList.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
					</ul>
                </c:when>
                <c:otherwise>
                    <%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
                </c:otherwise>
            </c:choose>		
		<c:choose>
			<c:when test="${productList.resultList ne null}">
				<%-- <div class="search_divice"><a href="/front/totalsearch/inc/inc_product?searchType=1&searchWord=${so.searchWord}&_SKIN_ID=davich" class="go_more">더보기</a></div> --%>
				<div class="search_divice"><a href="javascript:jsMoveTab('product')" id="product_tab" class="go_more" >더보기</a></div>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>
		<!-- //프로덕트 -->

		<!-- 프로모션 -->
	    	<c:choose>
			    <c:when test="${promotionList.resultList ne null}">
					<h3 class="search_area_tit">프로모션</h3>
				    <ul class="search_event_list">
				    	<c:forEach var="promotionList" items="${promotionList.resultList}" varStatus="status">
							<li>
								<%-- <a href="/front/promotion/promotion-detail?prmtNo=${promotionList.prmtNo}"> --%>
								<a href="${promotionList.detailLink }">
								<img src="${_IMAGE_DOMAIN}/image/image-view?type=EXHIBITION&path=${promotionList.prmtWebBannerImgPath}&id1=${promotionList.prmtWebBannerImg}" alt="" onerror="this.src='../img/promotion/promotion_ing01.jpg'">
								<p class="tit">${promotionList.prmtNm}</p>
								</a>
							</li>
				   		</c:forEach>
					</ul>
				   </c:when>
			   <c:otherwise>
			   		<%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
			   </c:otherwise>
		   </c:choose>
		<c:choose>
			<c:when test="${promotionList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('promotion')" id="promotion_tab" class="go_more">더보기</a></div>	
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
				<ul class="product_list_typeS search">
                    <data:goodsList value="${withitemList.resultList}" displayTypeCd="${so.displayTypeCd}" headYn="Y" iconYn="Y"/>
				</ul>
                </c:when>
                <c:otherwise>
                    <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p>
                </c:otherwise>
            </c:choose>
		<c:choose>
			<c:when test="${withitemList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('withitem')" id="withitem_tab" class="go_more">더보기</a></div>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>  --%> <!-- 20200612 -->
		<!-- //연관상품 -->
		
		<!-- 매거진 -->
		<c:choose>
			<c:when test="${magazineList.resultList ne null}">
			<h3 class="search_area_tit">D.매거진</h3>		
			<ul class="search_magazine_list">
			    <c:forEach var="magazineList" items="${magazineList.resultList}" varStatus="status">
			    	<li>
						<a href="${magazineList.detailLink }"><img src="${_IMAGE_DOMAIN}${magazineList.goodsDispImgM }" style = "width : 110px; height : 110px;" alt=""></a>
						<div class="right_text">
							<p class="tit"><a href="${magazineList.detailLink }">${magazineList.goodsNm}</a></p>
							<p class="text">${magazineList.prWords}<br></p>							
							<span class="date">${magazineList.regDate}</span>
						</div>
					</li>
			   </c:forEach>
			</ul>		
			</c:when>
			<c:otherwise>
				<%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
			</c:otherwise>
		</c:choose>		
		<c:choose>
			<c:when test="${magazineList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('magazine')" id="magazine_tab" class="go_more">더보기</a></div>
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
							<a href="${videoList.linkUrl }" target="_blank">
								<div class="movie_area"> 
									<img src="https://img.youtube.com/vi/${fn:substring(videoList.linkUrl, 17, 99)}/0.jpg" style='width:221px; height:auto' ">
									<i class="icon_play"></i>
								</div>
								<p class="tit">${videoList.title}</p>
								<span>${videoList.regDate }</span>
							</a>
							</li>
						</c:forEach>
					</ul>
					</c:when>
				<c:otherwise>
	                <%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
	            </c:otherwise>
				</c:choose>	
		
		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${videoList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('video')" id="video_tab" class="go_more">더보기</a></div>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>

		<c:choose>
            <c:when test="${qnaList.resultList ne null}">
			<h3 class="search_area_tit">Q&A - 자주하는 질문</h3>
			<c:forEach var="qnaList" items="${qnaList.resultList}" varStatus="status">
			<div class="search_qna_list">
				<p class="tit">
					<a href="${qnaList.detailLink}"><em>Q.</em>${qnaList.title}</a>
					<span class="date">${qnaList.regDate }</span>
				</p>
				<%-- <p class="q_text">${qnaList.content }</p> --%>
			<p class="a_text"><em>A.</em>${qnaList.content }</p>
			</div>
				</c:forEach>
			</c:when>
			<c:otherwise>
                <%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
            </c:otherwise>
		</c:choose> 
		
		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${qnaList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('qna')" id="qna_tab" class="go_more">더보기</a></div>
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
						<c:if test="${newsList.imgFileNm ne ''}" >
							<a href="${newsList.detailLink }"><img src="${_IMAGE_DOMAIN}/image/image-view?type=BBS&amp;path=${newsList.imgFilePath}&amp;id1=${newsList.imgFileNm}" alt=""></a>
						</c:if>
						<div class="right_text">
							<p class="tit"><a href="${newsList.detailLink }">${newsList.title}</a></p>
							<p class="text" style="text-overflow: ellipsis;  width: 100%; overflow: hidden;">${newsList.content }</p>
							<span class="date">${newsList.regDate }</span>
							<!-- <p class="text">${newsList.imgFileNm}</p>  -->
						</div>
					</li>
				</c:forEach> 
			</ul>
			</c:when>
		<c:otherwise>
               <%-- <p class="no_blank"><em>'${so.searchWord}'</em> 에 대한 검색결과가 없습니다.</p> --%>
           </c:otherwise>
		</c:choose>	
		
		<!--// 목록 영역 -->
		<c:choose>
			<c:when test="${newsList.resultList ne null}">
				<div class="search_divice"><a href="javascript:jsMoveTab('news')" id="news_tab" class="go_more">더보기</a></div>
			</c:when>
			<c:otherwise>
				<!-- <div class="search_divice"></div> -->
			</c:otherwise>
		</c:choose>
		
	</c:otherwise>
</c:choose>	
	
