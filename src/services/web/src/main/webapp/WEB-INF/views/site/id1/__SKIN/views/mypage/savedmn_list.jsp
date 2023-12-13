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
    <t:putAttribute name="title">다비치마켓 :: 나의 마켓포인트</t:putAttribute>


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
                Dmall.FormUtil.submit('/front/member/savedmoney-list', param);
            });
            
            // 쿠폰 금액선택 체인지
            $('input[name="radio_discount"]').change(function(){
            	var savedMnVal = "${mileage}";
            	var prcAmt = 0;
            	$('input[name="radio_discount"]').each(function(){
            		if($(this).is(":checked")){
            			prcAmt = $(this).val();
            			$('#couponNo').val($(this).attr('data-no'))
            			$('#prcAmt').val(prcAmt);
            		}
            	});

            	var discountTotal = (savedMnVal*1) - (prcAmt*1);
            	discountTotal = String(discountTotal).replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
            	
            	$('.discount_total').children('em').text(discountTotal);
            });
            
            // 팝업 확인 클릭
            $('.btn_go_okay').click(function(){
            	var savedMnVal = $('#savedMnVal').val()*1;
            	var prcAmt = $('#prcAmt').val()*1;
            	
            	//쿠폰 금액 유효성 체크
                if(prcAmt == 0){
                    Dmall.LayerUtil.alert("쿠폰 금액을 선택하여 주십시오");
                    return;
                }
                if(savedMnVal < prcAmt){
                    Dmall.LayerUtil.alert("쿠폰 금액은 보유하고 있는 마켓포인트를 초과할 수 없습니다.");
                    return;
                }
            	
				if(Dmall.validate.isValid('form_id_saveMn_insert')) {
                    
                    var url = '/front/member/savedmoney-insert',
                        param = $('#form_id_saveMn_insert').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.alert("오프라인 쿠폰이 전환되었습니다.", "알림");
                            location.href="/front/member/savedmoney-list";
                        }
                    });
                }
            });
            
            $('#btn_exchange_offcp').click(function(){
            	$('#exchange_offcp_popup').show();
            });
        });

        //통화 표시
        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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

           	<!--- 마이페이지 탑 --->
            <%@ include file="include/mypage_top_menu.jsp" %>
    
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            
            <div class="mypage_body">
				<h3 class="my_tit">나의 마켓포인트</h3>
				<div class="order_cancel_info">					
					<span class="icon_purpose">마켓포인트은 온라인 다비치마켓에서만 적립, 사용가능합니다.</span>
				</div>	
				<form:form id="form_id_list" commandName="so">
					<form:hidden path="page" id="page" />
					<form:hidden path="period" id="period" />
				
					<div class="my_cash">
						<div class="box">
							<p class="tit">사용가능</p>
							<p class="text"><em><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</p>
						</div>
						<div class="box">
							<p class="tit">30일 이내 소멸예정</p>
							<p class="text"><em><fmt:formatNumber value="${extinctionSavedMn.data.usePsbAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>P</p>
						</div>
						<div class="box02 online">
							<p>온라인 다비치마켓 적립<br>온라인 다비치마켓 사용</p>
						</div>
						<div class="box03">
							<button type="button" class="btn_exchage_off" id="btn_exchange_offcp">오프라인 쿠폰 전환하기<i></i></button>
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
							<h1 class="blind">나의 마켓포인트 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:170px">
							<col style="width:120px">
							<col style="width:150px">
							<col style="width:">
							<col style="width:110px">
							<col style="width:150px">
						</colgroup>
						<thead>
							<tr>
								<th>날짜</th>
								<th>구분</th>
								<th>금액</th>
								<th>사유</th>
								<th>매장</th>
								<th>유효기간</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
                                <c:when test="${resultListModel.resultList ne null }">
                                    <c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" >
                                    <tr>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${savedmnList.regDttm}"/></td>
                                        <td>
                                        	<c:choose>
                                        		<c:when test="${savedmnList.svmnType eq '+ ' }">
                                        			<span class="cash_plus">${savedmnList.svmnType} ${savedmnList.svmnTypeNm}</span>
                                        		</c:when>
                                        		<c:otherwise>
                                        			<span class="cash_minus">${savedmnList.svmnType} ${savedmnList.svmnTypeNm}</span>
                                        		</c:otherwise>
                                        	</c:choose>
                                        </td>
                                        <td>
                                        	<span class="<c:if test="${savedmnList.svmnType eq '+ ' }">cashBlue</c:if>">${savedmnList.svmnType} <fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span></td>
                                        <td>${savedmnList.reasonNm}</td>
                                        
                                        <c:if test="${empty savedmnList.ordNo}">
                                        <td>${savedmnList.etcReason}</td>
                                        </c:if>
                                        
                                        <c:if test="${!empty savedmnList.ordNo}">
                                        <td>
                                        </td>
                                        </c:if>
                                        
                                        <fmt:parseDate var="period" value="${savedmnList.validPeriod}" pattern="yyyy-MM-dd"/>
                                        <td><fmt:formatDate value="${period}" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <td colspan="6">마켓포인트 내역이 없습니다.</td>
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
       
	<!-- popup -->
	<div class="popup" id="exchange_offcp_popup" style="display:none;">
		<div class="inner disccount off" style="height:auto;">
			<div class="popup_head">
				<h1 class="tit">오프라인 쿠폰 전환</h1>
				<button type="button" class="btn_close_popup">창닫기</button>
			</div>
			<div class="popup_body"> 
				<p class="discount_warning">※  마켓포인트를 오프라인 쿠폰으로 전환 후 전국 다비치매장 방문시 제시하시면, 쿠폰액수만큼 할인된 가격으로 상품을 구매하실 수 있습니다.(일부 매장 제외)</p>
				<div class="popup_tCart_outline">
					<form id="form_id_saveMn_insert" >
						<input type="hidden" id="memberNoPInsert" name="memberNo" value="${so.memberNoSelect }" />
                        <input type="hidden" id="typeCd" name="typeCd" value="M" />
                        <input type="hidden" id="ordCanselYn" name="ordCanselYn" value="N" />
                        <input type="hidden" id="savedMnVal" name="savedMnVal" value="${mileage}" /><!-- 소유마켓포인트 -->
                        <input type="hidden" id="prcAmt" name="prcAmt" value="0"/><!-- 쿠폰전환금 -->
                        <input type="hidden" id="gbCd" name="gbCd" value="20" /><!-- 구분 - 20:차감 -->
                        <input type="hidden" id="reasonCd" name="reasonCd" value="03" /><!-- 사유 - 03:상품구매 사용차감 -->
                        <input type="hidden" id="validPeriod" name="validPeriod" value="01" /><!-- 유효기간 - 01:제한하지않음 -->
                        <input type="hidden" id="couponNo" name="couponNo" />
                        <input type="hidden" id="couponKindCd" name="couponKindCd" value="99"/><!-- 쿠폰종류 - 99:오프라인쿠폰-->
					
						<table class="tCart_Insert">
							<caption>오프라인 쿠폰 전환 내용입니다.</caption>
							<colgroup>
								<col style="width:184px">
								<col style="width:">
							</colgroup>
							<tbody>
								<tr>
									<th>전환가능한 보유 마켓포인트</th>
									<td><em class="discount_price"><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원</td>
								</tr>
								<tr>
									<th class="vaT">쿠폰 금액선택</th>
									<td>
										<c:forEach var="li" items="${couponList }" varStatus="status">
											<c:if test="${status.index != 0 }"><br></c:if>
											<input type="radio" class="discount_radio" id="radio_discount${status.index }" name="radio_discount" value="${li.couponBnfDcAmt }" data-no="${li.couponNo }">
											<label for="radio_discount${status.index }"><span></span>${li.couponNm }</label>
										</c:forEach>
										
									</td>
								</tr>
								<tr>
									<td colspan="2" class="discount_total">
										<span>전환 후 마켓포인트 잔액</span> <em><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
										<!--span>전환 후 마켓포인트 잔액</span> <em class="point0">잔액부족</em-->
									</td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<div class="popup_btn_area">
					<button type="button" class="btn_go_okay">확인</button>
					<button type="button" class="btn_close_popup02">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!--// popup -->
	
    </t:putAttribute>
</t:insertDefinition>