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
    <t:putAttribute name="title">다비치마켓 :: 오프라인 구매내역</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));

            //달력
            $(function() {
                $( ".datepicker" ).datepicker();
            });

            //검색
            $('.btn_form').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_list').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('/front/member/offline_sal', param);
            });
        });

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

           	<!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
    
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            
            <div class="mypage_body">
				<h3 class="my_tit">오프라인 구매내역</h3>
				
				<form:form id="form_id_list" commandName="so">
					<form:hidden path="page" id="page" />
					<form:hidden path="period" id="period" />
					
					<div class="filter_datepicker date_select_area">
						<input type="text" name="stRegDttm" id="event_start" class="datepicker date" value="${so.stRegDttm}" readonly="readonly" onkeydown="return false">
						~
						<input type="text" name="endRegDttm" id="event_end" class="datepicker date" value="${so.endRegDttm}" readonly="readonly" onkeydown="return false">
						<span class="btn_date_area">
							<button type="button" style="display:none"></button>
							<button type="button" <c:if test="${so.period eq '1' }">class="active"</c:if> >15일</button>
							<button type="button" <c:if test="${so.period eq '2' }">class="active"</c:if> >1개월</button>
							<button type="button" <c:if test="${so.period eq '3' }">class="active"</c:if> >3개월</button>
							<button type="button" <c:if test="${so.period eq '4' }">class="active"</c:if> >6개월</button>
							<button type="button" <c:if test="${so.period eq '5' }">class="active"</c:if> >1년</button>
						</span>
						<button type="button" class="btn_form">조회하기</button>
					</div>
					
					<table class="tProduct_Board">
						<caption>
							<h1 class="blind">오프라인 구매내역 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:138px">
							<col style="">
							<col style="width:77px">
							<col style="width:138px">
							<col style="width:120px">
						</colgroup>
						<thead>
							<tr>
								<th>구매일자</th>
								<th>상품</th>
								<th>수량</th>
								<th>구매금액</th>
								<th>매장</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
                                <c:when test="${fn:length(salList) > 0}">
                                	<c:forEach var="li" items="${salList }">
                               			<tr>
                               				<td>
                               					<fmt:parseDate var="salDate" value="${li.salDate }" pattern="yyyyMMdd" />
                               					<fmt:formatDate value="${salDate }" pattern="yyyy-MM-dd" />
                               				</td>
                                    		<%-- <td class="textL">${li.itmName }</td> --%>
                                    		<td class="textL">*</td>
                                    		<td><c:if test="${li.cancType eq '반품'}">- </c:if> ${li.qty }</td>
                                    		<td><fmt:formatNumber value="${li.salAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                                    		<td>${li.strName }</td>
                                    	</tr>
                                	</c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5">오프라인 구매 내역이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
						</tbody>
					</table>
					<!---- 페이징 ---->
                    <div class="tPages" id="div_id_paging">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                    <!----// 페이징 ---->
				</form:form>
			</div>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->
    </t:putAttribute>
</t:insertDefinition>