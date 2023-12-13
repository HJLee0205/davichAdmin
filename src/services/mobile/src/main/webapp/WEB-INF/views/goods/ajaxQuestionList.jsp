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

<c:choose>
    <c:when test="${fn:length(questionList.resultList) > 0}">
    <c:forEach var="resultModel" items="${questionList.resultList}" varStatus="status">
    <c:if test="${resultModel.lvl eq '0' || resultModel.lvl eq null}">
    <li data-bbs-nm="${so.bbsNm}" data-regr-no="${so.regrNo}" data-title-no="${so.titleNo}">
        <p class="tit qna_view_title">
            <%-- 비밀글 --%>
            <c:choose>
                <c:when test="${resultModel.sectYn eq 'Y'}">
                    <c:if test="${resultModel.loginId eq user.session.loginId }">
                        <c:set var="title" value="<img src='${_SKIN_IMG_PATH}/community/icon_free_lock.png' alt='비밀글'>  ${resultModel.title}."/>
                    </c:if>
                    <c:if test="${resultModel.loginId ne user.session.loginId }">
                        <c:set var="title" value="<img src='${_SKIN_IMG_PATH}/community/icon_free_lock.png' alt='비밀글'>  비밀글입니다."/>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <c:set var="title" value="${resultModel.title}"/>
                </c:otherwise>
            </c:choose>
            ${title}
        </p>
        <span class="user_name">${StringUtil.maskingName(resultModel.memberNm)}</span>
        <span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></span>
        <c:if test="${resultModel.replyStatusYn == 'Y'}" ><span class="qna_labelR">답변완료</span></c:if>
        <c:if test="${resultModel.replyStatusYn != 'Y'}" ><span class="qna_labelG">답변대기</span></c:if>

    </li>
        <%-- 비밀글 --%>
        <c:choose>
            <c:when test="${resultModel.sectYn eq 'Y'}">
                <c:if test="${resultModel.loginId eq user.session.loginId }">
                    <li class="question" style="display: none;">
                        <div class="text_area">
                            <c:set value="${resultModel.content}" var="data"/>
                            <c:set value="${fn:replace(data, cn, br)}" var="content"/>
                                ${content}
                        </div>
                        <div class="btn_area">
                            <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
                                <c:if test="${resultModel.replyStatusYn != 'Y'}" >
                                    <button type="button" onclick="selectQuestion('${resultModel.lettNo}');" class="btn_modify">수정</button>
                                    <button type="button" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
                                </c:if>
                            </c:if>
                        </div>
                        <%-- 답변 --%>
                        <c:if test="${resultModel.replyStatusYn == 'Y'}" >
                            <c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
                                <c:if test="${resultModel.lettNo eq replyList.grpNo}">
                                    <div class="anwser_area">
                                        <em>[답변]</em>${replyList.title}<br>
                                        <c:set value="${replyList.content}" var="rdata"/>
                                        <c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
                                            ${rcontent}
                                            <%--<span class="date">관리자 <em>2018-01-08 18:02</em></span>--%>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <%--// 답변 --%>
                    </li>
                </c:if>
                <c:if test="${resultModel.loginId ne user.session.loginId }">
                    <li class="question" style="display: none;">
                    <div class="text_area">
                        비밀글입니다.
                    </div>
                    </li>

                </c:if>
            </c:when>
            <c:otherwise>
                <li class="question" style="display: none;">
                    <div class="text_area">
                        <c:set value="${resultModel.content}" var="data"/>
                        <c:set value="${fn:replace(data, cn, br)}" var="content"/>
                            ${content}
                    </div>
                    <div class="btn_area">
                        <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
                            <c:if test="${resultModel.replyStatusYn != 'Y'}" >
                                <button type="button" onclick="selectQuestion('${resultModel.lettNo}');" class="btn_modify">수정</button>
                                <button type="button" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
                            </c:if>
                        </c:if>
                    </div>
                    <%-- 답변 --%>
                    <c:if test="${resultModel.replyStatusYn == 'Y'}" >
                        <c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
                            <c:if test="${resultModel.lettNo eq replyList.grpNo}">
                                <div class="anwser_area">
                                    <em>[답변]</em>${replyList.title}<br>
                                    <c:set value="${replyList.content}" var="rdata"/>
                                    <c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
                                        ${rcontent}
                                        <%--<span class="date">관리자 <em>2018-01-08 18:02</em></span>--%>
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <%--// 답변 --%>
                </li>
            </c:otherwise>
        </c:choose>


    </c:if>
    </c:forEach>
    </c:when>
    <c:otherwise>
    </c:otherwise>
    </c:choose>


	<%--<c:forEach var="resultModel" items="${questionList.resultList}" varStatus="status">
        <c:choose>
        <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
			<li data-lett-no="225" data-bbs-nm="${so.bbsNm}" data-regr-no="${so.regrNo}" data-title-no="${so.titleNo}">
				<ul class="qna_view">
					<li class="qna_view_title">
						<div class="qna_view_title_area">
							${resultModel.title}
						</div>
						<span class="qna_time">
							<fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" />
						</span>
						<div class="qna_check">
							<c:if test="${resultModel.replyStatusYn == 'Y'}" ><span class="answerLB">답변완료</span></c:if>
      						<c:if test="${resultModel.replyStatusYn != 'Y'}" ><span class="answerLR">답변대기</span></c:if>
						</div>
					</li>
					<li class="qna_view_text">
						<!-- 질문 -->
						<div class="qna_question_text">
							<c:set value="${resultModel.content}" var="data"/>
							<c:set value="${fn:replace(data, cn, br)}" var="content"/>
							${content}<br>
							&lt;%&ndash; ${resultModel.content}<br> &ndash;%&gt;
							<c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.regrNo || user.session.authGbCd eq 'A')}">
								<c:if test="${resultModel.replyStatusYn != 'Y'}" >
			                        <button type="button" class="" onclick="selectQuestion('${resultModel.lettNo}');"><span class="answerLB">수정</span></button>
			                        <button type="button" class="" onclick="deleteQuestion('${resultModel.lettNo}');"><span class="answerLR">삭제</span></button>
		                        </c:if>
	                        </c:if>
						</div>
						<!--// 질문 -->
						
						<!-- 답변 -->
						<c:if test="${resultModel.replyStatusYn == 'Y'}" >
							<c:forEach var="replyList" items="${replyList.resultList}" varStatus="status">
							<c:if test="${resultModel.lettNo eq replyList.grpNo}">
								<div class="qna_answer_text">
									${replyList.title}<br>
									<c:set value="${replyList.content}" var="rdata"/>
									<c:set value="${fn:replace(rdata, cn, br)}" var="rcontent"/>
									${rcontent}
									&lt;%&ndash; ${replyList.content} &ndash;%&gt;
								</div>
							</c:if>
						</c:forEach>
						</c:if>
						<!--// 답변 -->	
					</li>						
				</ul>
			</li>
		</c:when>
       	</c:choose>
   	</c:forEach>	--%>

	    	