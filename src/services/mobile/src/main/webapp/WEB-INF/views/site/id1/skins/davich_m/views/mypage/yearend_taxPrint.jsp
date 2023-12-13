<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script>

$(document).ready(function() {
	$(".btn_year_cose").on("click", function(){
		Dmall.LayerPopupUtil.close('div_year_popup');
		location.reload();
	});	
});

</script>
<div id="year_pop">			

	<div id="cash_bill">
		<div class="bill_head">	
			<h1 class="bill_tit">영수증<span>(소득공제용)</span></h1>
		</div>
		
           <c:forEach var="yearList" items="${yearPrint}" varStatus="status">
	             <c:set var="nmCust" value="${yearList.nmCust}"/>
	             <c:set var="cdCust" value="${yearList.cdCust}"/>
	             <c:set var="busiNo" value="${yearList.busiNo}"/>
	             <c:set var="strLname" value="${yearList.strLname}"/>
	             <c:set var="ownName" value="${yearList.ownName}"/>
	             <c:set var="nmBtype" value="${yearList.nmBtype}"/>
	             <c:set var="nmBitem" value="${yearList.nmBitem}"/>
	             <c:set var="telNo" value="${yearList.telNo}"/>
	             <c:set var="addr" value="${yearList.addr}"/>
           </c:forEach>

		<h2 class="bill_stit">고객정보</h2>
		<table class="tBill"> 
			<caption>소득공제용 고객정보입니다.</caption>
			<colgroup>
				<col style="width:20%">
				<col style="width:30%">
				<col style="width:20%">
				<col style="width:30%">
			</colgroup>
			<tbody>
				<tr>
					<th>성명</th>
					<td>${nmCust}</td>
					<th>회원번호</th>
					<td>${cdCust}</td>
				</tr>
			</tbody>
		</table>

		<h2 class="bill_stit">공급자</h2>
		<table class="tBill"> 
			<caption>소득공제용 공급자정보입니다.</caption>
			<colgroup>
				<col style="width:22%">
				<col style="width:30%">
				<col style="width:18%">
				<col style="width:30%">
			</colgroup>
			<tbody>
				<tr>
					<th>사업자등록번호</th>
					<td colspan="3">${busiNo}</td>
				
				</tr>
				<tr>
					<th>상호</th>
					<td>${strLname}</td>
					<th>대표자</th>
					<td>${ownName}</td>
				</tr>
				<tr>
					<th>업태</th>
					<td>${nmBtype}</td>
					<th>종목</th>
					<td>${nmBitem}</td>				
				</tr>
				<tr>
					<th>전화번호</th>
					<td>${telNo}</td>
					<th>회원번호</th>
					<td>${cdCust}</td>
				</tr>
				<tr>
					<th>소재지</th>
					<td colspan="3">${addr}</td>
				</tr>
			</tbody>
		</table>

		<h2 class="bill_stit">구매내역 <span class="bill_info"><em>(구입용도</em> : 시력교정용)</span></h2>
		<table class="tBill"> 
			<caption>구매내역 공급자정보입니다.</caption>
			<colgroup>
				<col style="width:18%">
				<col style="width:20%">
				<col style="width:20%">
				<%--<col style="width:20%">--%>
				<col style="width:20%">
			</colgroup>
			<thead>
				<tr>
					<th>구매년도</th>
					<th>현금</th>
					<th>신용카드</th>
					<%--<th>기타</th>--%>
					<th>계</th>
				</tr>
			</thead>
			<tbody>
	            <c:set var="cashTotalAmt" value="0"/>
	            <c:set var="cardTotalAmt" value="0"/>
	            <%--<c:set var="gitaTotalAmt" value="0"/>--%>
	            <c:set var="totalAmt" value="0"/>
			
	           <c:forEach var="yearList" items="${yearPrint}" varStatus="status">
					<tr>
			            <c:set var="cashTotalAmt" value="${cashTotalAmt + yearList.cashAmt}"/>
			            <c:set var="cardTotalAmt" value="${cardTotalAmt + yearList.cardAmt}"/>
			            <c:set var="gitaTotalAmt" value="${cardTotalAmt + yearList.gitaAmt}"/>
			            <c:set var="totalAmt" value="${totalAmt + yearList.total}"/>
					
						<td>${fn:substring(yearList.dates,0,4)} - ${fn:substring(yearList.dates,4,6)}</td>
						<td> <c:if test="${yearList.cashAmt eq null}">0</c:if>
						     <c:if test="${yearList.cashAmt ne null}"><fmt:formatNumber value="${yearList.cashAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></c:if></td>
						<td> <c:if test="${yearList.cardAmt eq null}">0</c:if>
						     <c:if test="${yearList.cardAmt ne null}"><fmt:formatNumber value="${yearList.cardAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></c:if></td>
						<%--<td> <c:if test="${yearList.gitaAmt eq null}">0</c:if>
						 	 <c:if test="${yearList.gitaAmt ne null}"><fmt:formatNumber value="${yearList.gitaAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></c:if></td>--%>
						<td> <c:if test="${yearList.total eq null}">0</c:if>
						     <c:if test="${yearList.total ne null}"><fmt:formatNumber value="${yearList.total}" type="currency" maxFractionDigits="0" currencySymbol=""/></c:if></td>
					</tr>
				</c:forEach>
				
				<tr class="bTotal">
					<td></td>
					<td><fmt:formatNumber value="${cashTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
					<td><fmt:formatNumber value="${cardTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
					<%--<td><fmt:formatNumber value="${gitaTotalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>--%>
					<td><em><fmt:formatNumber value="${totalAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em></td>
				</tr>
				<tr>
					<th colspan="2">비고</th>
					<td colspan="2"></td>
				</tr>
			</tbody>
		</table>

		<div class="bill_text">
			이 계산서는 소득세법사의 의료비공제 신청에 필요합니다.<br>
			위 사실을 확인합니다.

			<div class="bill_stamp">
				확인자 : 김인규 <img src="${_SKIN_IMG_PATH}/mypage/bill_stamp.gif" alt="확인자 김인규 인">
			</div>
		</div>
	</div>
	<div class="btn_davichi_area">
		<button type="button" class="btn_presc_registration btn_year_cose">닫기</button>
	</div>
</div>	