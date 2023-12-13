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
    <t:putAttribute name="title">비비엠 워런티 카드</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
        	
            //페이징
            $('.more_view').on('click', function() {
            	var pageIndex = Number($('#page').val())+1;    		        
            	$("#page").val(pageIndex);
            	var param = $('#form_id_list').serialize();
           		var url = '${_MOBILE_PATH}/front/member/bibiem-warranty-list-paging';
           		Dmall.AjaxUtil.loadByPost(url, param, function(result) {

    		    	if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $('#tbody').append(result);
    	        })
             });
            

            
        });

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <jsp:useBean id="toDay" class="java.util.Date" />
	<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="today"/>
	<fmt:parseNumber value="${toDay.time /(1000*60*60*24)}" integerOnly="true" var="nowDays" scope="request" />
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
	<form:form id="form_id_list" commandName="so">
    <form:hidden path="page" id="page" />       
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			마이페이지
		</div>

		<div class="mypage_content">
			<h2 class="mypage_stit2"><span>비비엠 워런티 카드</span></h2>

			<div class="bibiem_waranty">
				<img src="${_SKIN_IMG_PATH}/mypage/bibiem_warrantycard.png" alt="">
			</div>
		</div>
		<table class="tCart_Board bibiem">
			<caption>
				<h1 class="blind">비비엠 워런티 카드 목록입니다.</h1>
			</caption>
			<colgroup>
				<col style="width:10%">
				<col style="width:18%">
				<col style="width:19%">
				<col style="">
				<col style="width:22%">
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>이름</th>
					<th>모델명</th>
					<th>매장</th>
				</tr>
			</thead>
			<tbody id="tbody">
				<c:choose>
					<c:when test="${fn:length(resultListModel.resultList) > 0}">
						<c:forEach var="warrantyList" items="${resultListModel.resultList}" varStatus="status">
							<tr>
								<td>${warrantyList.pagingNum}</td>
								<td>${warrantyList.dates}</td>
								<td>${warrantyList.memberNm}</td>
								<td>${warrantyList.itmName}</td>
								<td>${warrantyList.strName}</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="5" style="text-align:center">조회된 데이터가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>

		<!--- 페이징 --->
		<div class="tPages" id="div_id_paging">
            <grid:paging resultListModel="${resultListModel}" />
        </div>
		<!---// 페이징 --->
 </form:form>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->

    </t:putAttribute>
</t:insertDefinition>