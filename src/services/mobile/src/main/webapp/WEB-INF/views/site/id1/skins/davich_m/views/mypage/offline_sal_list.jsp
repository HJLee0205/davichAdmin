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
    <t:putAttribute name="title">오프라인 구매내역</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
        	// 페이징 처리
    		$('.more_view').on('click', function() {
				var pageIndex = Number($('#page').val())+1;
				$("#page").val(pageIndex);
           	 	var param = $('#form_id_search').serialize();
             	var url = '${_MOBILE_PATH}/front/member/offline_sal-paging';
             	Dmall.AjaxUtil.loadByPost(url, param, function(result) {
             		
					if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $("#page").val(pageIndex);
    		        $('.list_page_view em').text(pageIndex);
    		        console.log(result)
    		        $('#tbody').append(result);
				})
			});
            
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
                var data = $('#form_id_search').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('${_MOBILE_PATH}/front/member/offline_sal', param);
            });

        });
        
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			오프라인 구매내역
		</div>
		
		<div class="cont_body">
			<form:form id="form_id_search" commandName="so">
				<form:hidden path="page" id="page" />
			
				<div class="filter_datepicker date_select_area">
					<input type="text" name="stRegDttm" id="event_start" class="datepicker date" value="${so.stRegDttm}" readonly="readonly" onkeydown="return false">
					~
					<input type="text" name="endRegDttm" id="event_end" class="datepicker date" value="${so.endRegDttm}" readonly="readonly" onkeydown="return false">
					<button type="button" class="btn_form">조회하기</button>
					<div class="btn_date_area">
						<button type="button" class="btn_date_select" style="display:none"></button>
						<button type="button" class="btn_date_select">15일</button>
						<button type="button" class="btn_date_select">1개월</button>
						<button type="button" class="btn_date_select">3개월</button>
						<button type="button" class="btn_date_select">6개월</button>
						<button type="button" class="btn_date_select">1년</button>
					</div>
				</div>
				
				<table class="tProduct_Board offline wd-100p">
					<caption>
						<h1 class="blind">오프라인 구매내역 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
					</colgroup>
					<tbody id="tbody">
						<c:choose>
							<c:when test="${fn:length(salList) > 0}">
								<c:forEach var="li" items="${salList }">
									<tr>
										<th class="textL" colspan="4">
											<fmt:parseDate var="salDate" value="${li.salDate }" pattern="yyyyMMdd" />
	                                		<fmt:formatDate var="formatSalDate" value="${salDate }" pattern="yyyy-MM-dd" />
											<span class="offline_date">구매일 : ${formatSalDate }</span>
											<%-- <p class="offline_good_name">${li.itmName }</p> --%>
											<p class="offline_good_name">*</p>
										</th>
									</tr>
									<tr>	
										<td class="stit">수량</td>
										<td><c:if test="${li.cancType eq '반품'}">- </c:if> ${li.qty }</td>
										<td class="stit">매장</td>
										<td>${li.strName }</td>
									</tr>
									<tr>	
										<td class="stit">구매금액</td>
										<td colspan="3"><b><fmt:formatNumber value="${li.salAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></b>원</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
                                    <th class="textC" colspan="4">오프라인 구매 내역이 없습니다.</th>
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
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
         
    </t:putAttribute>
</t:insertDefinition>