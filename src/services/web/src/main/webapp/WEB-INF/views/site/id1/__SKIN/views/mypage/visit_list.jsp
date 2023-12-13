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
	<t:putAttribute name="title">다비치마켓 :: 방문예약내역</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $(function() {
            $( ".datepicker" ).datepicker();
        });
        
        $('.btn_visit_reservation').on('click', function() {
            var param = {};
            Dmall.FormUtil.submit('/front/visit/my-visit-welcome', param);
        });        
        
    });
    
    function viewVisitInfoDtl(rsvNo){
        Dmall.FormUtil.submit('/front/visit/visit-detail', {rsvNo : rsvNo});
    }    
    
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
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
	            
	            <!--- 마이페이지 탑 --->
	            <%@ include file="include/mypage_top_menu.jsp" %>
	            
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
											<a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}');" class="visit-link">
											<fmt:formatDate pattern="yyyy-MM-dd" value="${visitList.rsvDate}" /> &nbsp; &nbsp; 
											<fmt:parseDate pattern="kkmm" value="${visitList.rsvTime}" var="time"/>
											<fmt:formatDate pattern=" kk:mm" value="${time}" />
											</a>
										</td>							
										<td class="textL">
											<a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}');">
												<c:set var="visitPurposeNm" value="${fn:split(visitList.visitPurposeNm,'_')}" />
												<c:if test="${fn:length(visitPurposeNm) > 1}">
												${visitPurposeNm[1]}
												</c:if>
												<c:if test="${fn:length(visitPurposeNm) <= 1}">
												${fn:replace(visitList.visitPurposeNm, ' ', '&nbsp;')}
												</c:if>
												<%--${fn:replace(visitList.visitPurposeNm, ' ', '&nbsp;')}--%>
											</a>
										</td>
										<td><a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}');">${visitList.storeNm}</a></td>
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
					<div class="visit_reservation_area">
						<ul class="dot">
							<li>매장 사정으로 인해 불가피하게 예약변경 또는 취소상황이 발생할 수 있으며, 이 경우 별도로 연락드립니다.</li>
							<li>예약내용 변경을 원하시는 경우 예약내용을 취소하시고, 다시 접수해 주세요.</li>
						</ul>
						<button type="button" class="btn_visit_reservation">방문예약<i></i></button>
					</div>
					
	                </form:form>
				</div>
			</div>		
			<!--// content -->	            
    </div>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>	            
