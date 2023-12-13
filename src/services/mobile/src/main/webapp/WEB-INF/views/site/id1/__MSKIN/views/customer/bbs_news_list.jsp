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
	<t:putAttribute name="title">${bbsInfo.data.bbsNm}</t:putAttribute>
	
	
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
	    <script type="text/javascript">
	    $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
            
            $('.more_view').on('click', function() {
	        	var pageIndex = Number($('#page').val())+1;
	        	$("#page").val(pageIndex);
	        	var param = $('#form_id_search').serialize();
	     		var url = '${_MOBILE_PATH}/front/customer/bbs-list-ajax';
	     		Dmall.AjaxUtil.loadByPost(url, param, function(result) {

    		    	if('${newsList.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $('.news_list').append(result);
    	        })
	         });
	    });

	    //글 상세 보기
        function goCheckBbsDtl(lettNo, noticeYn) {
        	var param = {bbsId : "${so.bbsId}", lettNo : lettNo, noticeYn : noticeYn}
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/customer/letter-detail', param);
        }
	    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
        <div class="product_head search">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			뉴스
		</div>
		<!-- cont_body -->
		
		<form:form id="form_id_search" commandName="so">
		    <form:hidden path="page" id="page" />
		    <form:hidden path="rows" id="rows" />
		    <form:hidden path="bbsId" id="bbsId" />
		    
		    <c:if test="${null ne mainNewsList.resultList}">
				<div class="news_top_view">
					<c:forEach var="bbsList" items="${mainNewsList.resultList}" varStatus="status">
						<c:if test="${bbsList.rowNum eq 'notice' }">
							<div class="text">
								<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}', 'Y')">
	                                <c:choose>
	                                    <c:when test="${bbsList.imgFilePath ne null}">
	                                        <img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${bbsList.imgFilePath}&id1=${bbsList.imgFileNm}'  alt=''>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <img src='../img/community/gallery_img01.gif' alt=''>
	                                    </c:otherwise>
	                                </c:choose>
								</a>
								<span class="tit"><a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}', 'Y')">${bbsList.title}</a></span>
								<c:out value='${(bbsList.content).replaceAll("\\\<.*?\\\>","")}' />
							</div>
							<span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${bbsList.regDttm}" /></span>
						</c:if>
					</c:forEach>
				</div>
			</c:if>
		
			<ul class="news_list">
				<c:choose>
					<c:when test="${null ne newsList.resultList}">
						<c:forEach var="bbsList" items="${newsList.resultList}" varStatus="status">
							<c:if test="${bbsList.rowNum ne 'notice' }">
								<li>
									<div class="tit">
										<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}', 'N')">${bbsList.title}</a>
									</div>
									<a href="javascript:void(0);" onclick="goCheckBbsDtl('${bbsList.lettNo}', 'N')">
		                                <c:choose>
		                                    <c:when test="${bbsList.imgFilePath ne null}">
		                                        <img src='${_IMAGE_DOMAIN}/image/image-view?type=BBS&path=${bbsList.imgFilePath}&id1=${bbsList.imgFileNm}'  alt=''>
		                                    </c:when>
		                                    <c:otherwise>
		                                        <img src='../img/community/gallery_img01.gif' alt=''>
		                                    </c:otherwise>
		                                </c:choose>
									</a>
									<div class="right_text">
										<p class="text">
											<c:out value='${(bbsList.content).replaceAll("\\\<.*?\\\>","").replaceAll("&nbsp;"," ")}' />
										</p>
										<span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${bbsList.regDttm}" /></span>
									</div>
								</li>
							</c:if>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<!--- 게시물이 없을 경우 --->
                        <li class="no_data">
                            등록된 게시물이 없습니다.
                        </li>
                        <!---// 게시물이 없을 경우 --->
					</c:otherwise>
				</c:choose>
			</ul

			<!---- 페이징 ---->
            <div class="tPages" id="div_id_paging">
                <grid:paging resultListModel="${newsList}" />
            </div>
            <!----// 페이징 ---->
                        
		</form:form>
    </t:putAttribute>
</t:insertDefinition>