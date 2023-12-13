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
<%
pageContext.setAttribute("cn", "\r\n"); //Space, Enter
pageContext.setAttribute("br", "<br>"); //br 태그
%>
<jsp:useBean id="now" class="java.util.Date"/>
<script>
    $(function () {
    	$( ".review_view_text" ).hide();	
    	$('.review_view_title').off("click").on('click', function(e) {
    		$(".review_view_text:visible").slideUp("middle");
    		$(this).next('.review_view_text:hidden').slideDown("middle");
    		return false;
        });
    });
    
</script>

<c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
	 <c:choose>
        <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
			<li>
				<ul class="review_view">
					<li class="review_view_title">
						[${resultModel.goodsNm}]<br>
						${resultModel.title}
						<fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
						<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
						<c:if test="${date eq today}"><span class="review_view_new">NEW</span></c:if>
						<div class="review_date floatC">
							<span class="star_area">
								<c:forEach begin="1" end="${resultModel.score}" ><img src="${_MOBILE_PATH}/front/img/product/icon_star_yellow.png" alt="상품평가 별"></c:forEach>
							</span>
							<span class="review_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
							<span class="review_id">${resultModel.memberNm}</span>
						</div>
					</li>
					<li class="review_view_text">
						<c:set value="${resultModel.content}" var="data"/>
						<c:set value="${fn:replace(data, cn, br)}" var="content"/>
						${content}<br>
						<%-- ${resultModel.content} --%>
						<c:if test="${resultModel.imgFilePath ne null}">
			                  	<img src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.src='../img/product/product_300_300.gif'">
			                  </c:if>
						<div class="view_btn_area">
			                                  <button type="button" class="" onclick="selectReview('${resultModel.lettNo}');"><span class="answerLB">수정</span></button>
			                                  <button type="button" class="" onclick="deleteReview('${resultModel.lettNo}');"><span class="answerLR">삭제</span></button>
			                              </div>
					</li>
				</ul>
			</li>
		</c:when>
		<c:otherwise>
		    <li>
		        <ul class="review_view">
		            <li class="review_view_title">
		                [${resultModel.goodsNm}]<br>
		                <img src="${_MOBILE_PATH}/front/img/product/icon_reply.png" alt="댓글 아이콘"> ${resultModel.title}
		                <fmt:formatDate pattern="yyyy-MM-dd" value="${now}" var="today" />
		                <fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" var="date" />
		                <c:if test="${date eq today}"><span class="review_view_new">NEW</span></c:if>
		                <div class="review_date floatC">
		                    <span class="review_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
		                    <span class="review_id">${resultModel.memberNm}</span>
		                </div>
		            </li>
		            <li class="review_view_text">
		                <c:set value="${resultModel.content}" var="data"/>
		                <c:set value="${fn:replace(data, cn, br)}" var="content"/>
		                ${content}<br>
		                <%-- ${resultModel.content} --%>
		                <c:if test="${resultModel.imgFilePath ne null}">
		                    <img src="/image/image-view?type=BBS&path=${resultModel.imgFilePath}&id1=${resultModel.imgFileNm}" width="100px" height="100px;" onerror="this.src='../img/product/product_300_300.gif'">
		                </c:if>
		            </li>
		        </ul>
		    </li>
		</c:otherwise>
		</c:choose>
</c:forEach>