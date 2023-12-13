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
    <t:putAttribute name="title">다비치마켓 :: 나의 다비치포인트</t:putAttribute>


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
                Dmall.FormUtil.submit('/front/member/point', param);
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
				<h3 class="my_tit">나의 다비치포인트</h3>
				<div class="order_cancel_info">					
					<span class="icon_purpose">다비치포인트는 오프라인 다비치안경매장에서만 적립 사용가능합니다.</span>
				</div>	
				<form:form id="form_id_list" commandName="so">
					<form:hidden path="page" id="page" />
					<form:hidden path="period" id="period" />
					
					<div class="my_cash">
						<div class="box">
							<p class="tit">사용가능</p>
							<p class="text"><em><fmt:formatNumber value="${point}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</p>
						</div>
						<div class="box">
							<p class="tit">30일 이내 소멸예정</p>
							${test }
							<!-- <p class="text"><em>78,000</em>P</p> -->
						</div>
						<div class="box02 offline">
							<p>다비치안경매장 적립<br>다비치안경매장 사용</p>
						</div>
						<div class="box03">
							<p class="tit point">VIP 회원님의 적립혜택은?</p>
							<ul class="dot">
								<li>결제금액의 : <em>최대 10%</em></li>
							</ul>
						</div>
					</div>
	
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
					<table class="tCart_Board mycash">
						<caption>
							<h1 class="blind">나의 다비치포인트 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:170px">
							<col style="width:120px">
							<col style="width:150px">
							<col style="width:">
							<col style="width:110px">
						</colgroup>
						<thead>
							<tr>
								<th>날짜</th>
								<th>구분</th>
								<th>금액</th>
								<th>사유</th>
								<th>매장</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
                                <c:when test="${fn:length(dealList) > 0}">
                                    <c:forEach var="li" items="${dealList}">
                                    <tr>
                                        <td>${li.dealDate}<%-- <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${li.dealDate}"/> --%></td>
                                        <td>
                                        	<c:if test="${li.usePoint == 0 and li.salPoint > 0 }">
                                        		<span class="cash_plus">+ 지급</span>
                                        	</c:if>
                                        	<c:if test="${li.usePoint == 0 and li.salPoint < 0 }">
                                        		<span class="cash_minus">- 차감</span>
                                        	</c:if>
                                        	<c:if test="${li.salPoint == 0 and li.usePoint > 0}">
                                        		<span class="cash_minus">- 차감</span>
                                        	</c:if>
                                        	<c:if test="${li.salPoint == 0 and li.usePoint < 0}">
                                        		<span class="cash_plus">+ 지급</span>
                                        	</c:if>
                                        </td>
                                        <td>
                                       		<c:if test="${li.usePoint == 0 and li.salPoint != 0}">
                                       			<c:if test="${li.salPoint > 0}">
                                       				<span class="cashBlue"><fmt:formatNumber value="${li.salPoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
                                       			</c:if>
                                       			<c:if test="${li.salPoint < 0}">
                                       				<span class="cashBlue"><fmt:formatNumber value="${li.salPoint * -1}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
                                       			</c:if>
                                        	</c:if>
                                        	<c:if test="${li.salPoint == 0 and li.usePoint != 0}">
                                        		<c:if test="${li.usePoint > 0}">
                                        			<span><fmt:formatNumber value="${li.usePoint * -1}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
                                        		</c:if>
                                        		<c:if test="${li.usePoint < 0}">
                                        			<span><fmt:formatNumber value="${li.usePoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
                                        		</c:if>
                                        		
                                        	</c:if>
                                        </td>
                                        <td>
                                        	<c:choose>
                                        		<c:when test="${li.cancType eq '2'}">
                                        			반품
                                        		</c:when>
                                        		<c:otherwise>
                                        			<c:choose>
                                        				<c:when test="${li.inFlag eq '0' }">누적</c:when>
                                        				<c:when test="${li.inFlag eq '1' }">통합</c:when>
                                        				<c:when test="${li.inFlag eq '2' }">소멸</c:when>
                                        				<c:when test="${li.inFlag eq '3' }">변경</c:when>
                                        				<c:when test="${li.inFlag eq '4' }">사용</c:when>
                                        			</c:choose>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </td>
                                        <td>${li.strName}</td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5">다비치포인트 내역이 없습니다.</td>
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