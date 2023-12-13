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
	<t:putAttribute name="title">비회원 방문예약 조회</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    function viewVisitInfoDtl(rsvNo,rsvMobile){
        Dmall.FormUtil.submit('/front/visit/nomember-rsv-detail', {'rsvNo':rsvNo,'rsvMobile':rsvMobile});
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 비회원 방문예약조회 메인  --->
    <div id="category_header">
		<div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>
					비회원 방문예약조회
				</li>
			</ul>
		</div>
    </div>
	
	<div class="mypage_middle">       
		<!--- 비회원 방문예약조회 왼쪽 메뉴 -->
		<%@ include file="include/nonmember_rsv_menu.jsp" %>
		<!---// 비회원 방문예약조회 왼쪽 메뉴 --->

		 <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
		<!--- 비회원 방문예약조회 오른쪽 컨텐츠 --->
		<div id="mypage_content">
		<div class="mypage_body">
			<h3 class="my_tit">방문예약내역</h3>
			<div style="height:20px;">
			</div>
			<table class="tProduct_Board">
				<caption>
					<h1 class="blind">방문예약내역 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:170px">
					<col style="width:">
					<col style="width:190px">
					<col style="width:134px">
					<col style="width:130px">
				</colgroup>
				<thead>
					<tr>
						<th>예약일시</th>
						<th>방문목적</th>
						<th>예약매장</th>
						<th>등록일</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${visit_list.resultList ne null && fn:length(visit_list.resultList) gt 0}">
							<c:forEach var="visitList" items="${visit_list.resultList}" varStatus="status">
							<tr>
								<td>
									<a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}','${visitList.noMemberMobile}');" class="visit-link">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${visitList.rsvDate}" /> &nbsp; &nbsp;
									<fmt:parseDate pattern="kkmm" value="${visitList.rsvTime}" var="time"/>
									<fmt:formatDate pattern=" kk:mm" value="${time}" />
									</a>
								</td>
								<td class="textL">
									<a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}','${visitList.noMemberMobile}');">
										<c:set var="visitPurposeNm" value="${fn:split(visitList.visitPurposeNm,'_')}" />
										<c:if test="${fn:length(visitPurposeNm) > 1}">
										${visitPurposeNm[1]}
										</c:if>
										<c:if test="${fn:length(visitPurposeNm) <= 1}">
										${fn:replace(visitList.visitPurposeNm, ' ', '&nbsp;')}
										</c:if>
									</a>
								</td>
								<td><a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}','${visitList.noMemberMobile}');">${visitList.storeNm}</a></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd" value="${visitList.regDttm}" /></td>
								<td>
										<c:choose>
											<c:when test="${visitList.cancelYn eq 'Y'}">
												<span class="label_wait">예약취소</span>
											</c:when>
											<c:otherwise>
												<span class="label_anwser">예약완료</span>
											</c:otherwise>
										</c:choose>
								</td>
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
			<!-- pageing -->
			<div class="tPages" id="div_id_paging">
				<grid:paging resultListModel="${visit_list}" />
			</div>
			<!--// pageing -->
			</form:form>
		</div>
        <!---// 비회원 방문예약조회 오른쪽 컨텐츠 --->
		</div>
    </div>

    <!---// 비회원 방문예약조회 메인 --->
    </t:putAttribute>
</t:insertDefinition>