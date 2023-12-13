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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">나의 마켓포인트</t:putAttribute>
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
            $('.btn_date').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_list').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/savedmoney-list', param);
            });
            
            
            /*$('.more_view').on('click', function() {
            	 var pageIndex = Number($('#page').val())+1; 
            	 var param = param = "page="+ (Number($('#page').val())+1);
                 var url = '${_MOBILE_PATH}/front/member/savedmoney-list?'+param;

                 Dmall.AjaxUtil.load(url, function(result) {
                	 if(${so.totalPageCount}==pageIndex){
                 		$('#div_id_paging').hide();
                 	}
                 	$("#page").val(pageIndex);
                 	$('.list_page_view em').text(pageIndex);
                 	
                     $('.tMypage_list tbody').append(result);
                 })
                 
               
              });*/
            
            
        });

        //통화 표시
        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }
        
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
 
    <!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			마켓포인트 내역
		</div>
		<ul class="emoney_top">
			<li>
				<span class="emoney_get"><em><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
				사용가능 금액
			</li>
			<li>
				<span class="emoney_used"><em><fmt:formatNumber value="${extinctionSavedMn.data.usePsbAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</span>
				소멸예정 금액 
			</li>
		</ul>	
		<form:form id="form_id_list" commandName="so">
               <form:hidden path="page" id="page" />	
		<table class="tMypage_list">
			<colgroup>			
				<col style="width:30%">
				<col style="width:45%">
				<col style="width:25%">
			</colgroup>
			<thead>
				<tr>
					<th>발생일자/구분</th>
					<th>적립/사용 내역</th>
					<th>잔여마켓포인트</th>
				</tr>
			</thead>
			<tbody>
			
			   <c:choose>
               <c:when test="${resultListModel.resultList ne null }">
                   <c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" > 
					<tr>
						<input type="hidden" name="prcAmt" value="${savedmnList.prcAmt}">
						<td>
							<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${savedmnList.regDttm}"/><br>
							${savedmnList.svmnTypeNm}
						</td>
						<td>
							${savedmnList.content}
							<span class="emoney_detail">${savedmnList.svmnType} <fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
						</td>
						<td>
							<fmt:formatNumber value="${savedmnList.restAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/> 원
						</td>
					</tr>
				  </c:forEach>
              </c:when>
              <c:otherwise>
	              <tr>
	                  <td colspan="3">마켓포인트 내역이 없습니다.</td>
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
	<!---// 03.LAYOUT:CONTENTS --->
        
    </t:putAttribute>
</t:insertDefinition>