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
<jsp:useBean id="StringUtil" class="dmall.framework.common.util.StringUtil"></jsp:useBean>
<c:if test="${null ne resultListModel.resultList}">
	<c:choose>
		<c:when test="${null ne resultListModel.resultList}">
			<c:forEach var="bbsList" items="${resultListModel.resultList}" varStatus="status">
				<c:set var="lvl" value="0"/>
				<%-- 비밀글 --%>
				<c:choose>
					<c:when test="${bbsList.sectYn eq 'Y'}">
						<c:set var="title" value="<img src='../img/mypage/icon_free_lock.png' alt='비밀글' style='vertical-align:middle'>  ${bbsList.title}"/>
					</c:when>
					<c:otherwise>
						<c:set var="title" value="${bbsList.title}"/>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<%-- 공지 --%>
					<c:when test="${bbsList.noticeYn eq 'Y'}">
						<c:set var="bbsNum" value="<span class='label_red'>공지</span>"/>
						<c:set var="bbsTitle" value="${title}"/>
					</c:when>
					<%-- 답변 --%>
					<c:when test="${bbsList.lvl > 0 }">
						<c:set var="bbsNum" value="${bbsList.rowNum}"/>
						<c:set var="bbsTitle" value="<img src='../img/mypage/icon_reply.gif' alt='답변' style='vertical-align:middle'>  ${title}"/>
						<c:set var="lvl" value="${(bbsList.lvl-2)*15}"/>
					</c:when>
					<c:otherwise>
						<c:set var="bbsNum" value="${bbsList.rowNum}"/>
						<c:set var="bbsTitle" value="${title}"/>
					</c:otherwise>
				</c:choose>
				<c:if test="${bbsList.lvl > 1 }">
					<c:set var="lvl" value="${(bbsList.lvl)*10}"/>
				</c:if>
				<tr>
					<td>
					<!--td class="textC">${bbsNum}</td-->
						<c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
							<c:if test="${bbsList.lvl eq '0'}">
								<span class="label_keyword"> ${bbsList.titleNm}</span>
							</c:if>
						</c:if>
						<div class="ellipsis">
							<a href="javascript:goCheckBbsDtl('${bbsList.lettNo}')">
								<span style="padding-left:${lvl}px">
									${bbsTitle}
									<c:if test="${bbsList.iconCheckValueNew eq 'Y'}">
										<i class='bbs_icon_new'>NEW</i>
									</c:if>
									<c:if test="${bbsList.iconCheckValueHot eq 'Y'}">
										<i class='bbs_icon_hot'>HOT</i>
									</c:if>
								</span>
								<c:if test="${bbsList.cmntCnt > 0 }">(${bbsList.cmntCnt })</c:if>
							</a>
						</div>
					</td>
				   <td class="bbs_date">
						<c:choose>
							<c:when test="${bbsList.regrDispCd eq '01' }">
								${StringUtil.maskingName(bbsList.memberNm)}
							</c:when>
							<c:otherwise>
								${StringUtil.maskingName(bbsList.loginId)}
							</c:otherwise>
						</c:choose>
						&nbsp; (<fmt:formatDate pattern="yyyy-MM-dd" value="${bbsList.regDttm}" /> )
					</td>
					<!--<td class="font12 textC">
						${bbsList.inqCnt}
					</td> -->
				</tr>
			</c:forEach>
		</c:when>
		<c:otherwise>
			<tr>
			<c:choose>
				<c:when test="${bbsInfo.data.titleUseYn eq 'Y'}">
				<td class="textC" colspan="3">등록된 게시물이 없습니다.</td>
				</c:when>
				<c:otherwise>
				<td class="textC" colspan="3">등록된 게시물이 없습니다.</td>
				</c:otherwise>
			</c:choose>
			</tr>
		</c:otherwise>
	</c:choose>
</c:if>