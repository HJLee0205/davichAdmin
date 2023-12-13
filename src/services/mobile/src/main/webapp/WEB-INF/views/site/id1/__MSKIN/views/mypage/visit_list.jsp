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
	<t:putAttribute name="title">방문예약</t:putAttribute>
	
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_search'));

        //달력
        $(function() {
            $( ".datepicker" ).datepicker();
        });
        //검색
        $('.btn_form').on('click', function() {
            if($("#visitRsvDayS").val() == '' || $("#visitRsvDayE").val() == '') {
                Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-list', param);
        });
        
        $('.btn_visit_reservation').on('click', function() {
            var param = {};
            Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-welcome', param);
        });        
        
    });
    
    function viewVisitInfoDtl(rsvNo){
        Dmall.FormUtil.submit('${_MOBILE_PATH}/front/visit/visit-detail', {rsvNo : rsvNo});
    }    
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    
	<div id="middle_area">
		<div class="product_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			방문예약내역
		</div>
		<div class="cont_body">			
			<div style="height:20px;">
			</div>					

			<table class="tProduct_Board offline wd-100p">
				<caption>
					<h1 class="blind">방문예약내역 목록입니다.</h1>
				</caption>
				<colgroup>
					<col style="width:30%">
					<col style="width:70%">
				</colgroup>
				<tbody>
                   <c:choose>
                       <c:when test="${visit_list.resultList ne null && fn:length(visit_list.resultList) gt 0}">
                           <c:forEach var="visitList" items="${visit_list.resultList}" varStatus="status">
								<tr>
									<th colspan="2">
										<a href="javascript:void(0);" onClick="viewVisitInfoDtl('${visitList.rsvNo}');" class="visit_link">
											<span class="offline_date">
												<fmt:formatDate pattern="yyyy-MM-dd" value="${visitList.rsvDate}" /> &nbsp; &nbsp; 
												<fmt:parseDate pattern="kkmm" value="${visitList.rsvTime}" var="time"/>
												<fmt:formatDate pattern=" kk:mm" value="${time}" />
											</span>
											<p class="offline_good_name">
												<c:set var="visitPurposeNm" value="${fn:split(visitList.visitPurposeNm,'_')}" />
												<c:if test="${fn:length(visitPurposeNm) > 1}">
												${visitPurposeNm[1]}
												</c:if>
												<c:if test="${fn:length(visitPurposeNm) <= 1}">
												${fn:replace(visitList.visitPurposeNm, ' ', '&nbsp;')}
												</c:if>
											</p>
										</a>
										
									</th>
								</tr>
								<tr>	
									<td class="stit">예약매장</td>
									<td>${visitList.storeNm}</td>
								</tr>
								<tr>	
									<td class="stit">상태</td>
									<c:choose>
										<c:when test="${visitList.cancelYn eq 'Y'}">
											<td><span class="label_wait">예약취소</span></td>
										</c:when>
										<c:otherwise>
											<td><span class="label_anwser">예약완료</span></td>
										</c:otherwise>
									</c:choose>	
								</tr>
	                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="2">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>							
				</tbody>
			</table>
			<div class="visit_reservation_area">
				<ul class="dot">
					<li>매장 사정으로 인해 불가피하게 예약변경 또는 취소상황이 발생할 수 있으며, 이 경우 별도로 연락드립니다.</li>
					<li>예약내용 변경을 원하시는 경우 예약내용을 취소하시고, 다시 접수해 주세요.</li>
				</ul>
				<button type="button" class="btn_visit_reservation">방문예약<i></i></button>
			</div>
		</div><!-- //cont_body -->
	</div>
	<!---// 03.LAYOUT: MIDDLE AREA --->
    
    </t:putAttribute>
</t:insertDefinition>