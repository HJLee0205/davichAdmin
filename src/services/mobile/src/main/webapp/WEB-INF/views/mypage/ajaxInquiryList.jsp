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
    <script>
	    $(function () {
	    	$( ".qna_view_text" ).hide();	
	    	$('.qna_view_title').off("click").on('click', function(e) {
	    		$(".qna_view_text:visible").slideUp("middle");
	    		$(this).next('.qna_view_text:hidden').slideDown("middle");
	    		return false;
	        });
	    });
    </script>
    
            <c:forEach var="inquiryList" items="${resultListModel.resultList}" varStatus="status">
            <c:if test="${inquiryList.lvl eq '0' || inquiryList.lvl eq null}" >
			<li>
				<ul class="qna_view">
					<li class="qna_view_title">
						<div class="qna_view_title_area">
							[${inquiryList.inquiryNm}] ${inquiryList.title}
						</div>
						<span class="qna_time"><fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" /></span>
						<div class="qna_check">
							<c:if test="${inquiryList.replyStatusYn == 'Y'}" ><span class="answerLB">답변완료</span></c:if>
							<c:if test="${inquiryList.replyStatusYn != 'Y'}" ><span class="answerLR">답변대기</span></c:if>
						</div>
					</li>
					<li class="qna_view_text">
						<!-- 질문 -->
						<div class="qna_question_text">
							<c:set value="${inquiryList.content}" var="data"/>
							<c:set value="${fn:replace(data, cn, br)}" var="content"/>
							${content}<br>
							<%-- ${inquiryList.content} --%>
							<%-- <c:if test="${inquiryList.replyStatusYn != 'Y'}" >
                                <div class="view_btn_area">
                                    <button type="button" class="" onclick="deleteQuestion('${inquiryList.lettNo}', '${inquiryList.regrNo}');"><span class="answerLR">삭제</span></button>
                                </div>
                            </c:if> --%>							
						</div>
						<!--// 질문 -->
						<!-- 답변 -->
						<c:if test="${inquiryList.replyStatusYn == 'Y'}" >
							<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
							<c:if test="${inquiryList.lettNo eq replyList.grpNo}">
								<div class="qna_answer_text">
									${replyList.title}<br>
									<c:set value="${replyList.content}" var="rdata"/>
									<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
									${rcontent}
									<%-- ${replyList.content} --%>
								</div>
							</c:if>
						</c:forEach>
						</c:if>			
						<!--// 답변 -->							
					</li>						
				</ul>
			</li>
			</c:if>
            </c:forEach>
            