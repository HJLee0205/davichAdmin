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
    <t:putAttribute name="title">나의 마켓포인트</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            
        	//페이징
            $('.more_view').on('click', function() {
            	var pageIndex = Number($('#page').val())+1;    		        
            	$("#page").val(pageIndex);
            	var param = $('#form_id_list').serialize();
           		var url = '${_MOBILE_PATH}/front/member/savedmoney-list-paging';
           		Dmall.AjaxUtil.loadByPost(url, param, function(result) {

    		    	if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $('#tbody').append(result);
    	        })
            });
        	
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
                    
                    var url = '${_MOBILE_PATH}/front/member/savedmoney-insert',
                        param = $('#form_id_saveMn_insert').serialize();

                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Dmall.LayerUtil.alert("오프라인 쿠폰이 전환되었습니다.", "알림");
                            location.href="${_MOBILE_PATH}/front/member/savedmoney-list";
                        }
                    });
                }
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
              
            $('#btn_exchange_offcp').click(function(){
            	//$('#exchange_offcp_popup').show();
            	Dmall.LayerPopupUtil.open1($('#exchange_offcp_popup'));
            });
            
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
		
		<div class="btn_discount_area">
			<button type="button" class="btn_go_exchange" id="btn_exchange_offcp">할인권 전환하기</button>
		</div>
		<p class="savemoney_infotext">* 최근 15일간의 마켓포인트 사용내역입니다.</p>
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
					<th>금액</th>
				</tr>
			</thead>
			<tbody id="tbody">
			
			   <c:choose>
               <c:when test="${resultListModel.resultList ne null }">
                   <c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" > 
					<tr>
						<input type="hidden" name="prcAmt" value="${savedmnList.prcAmt}">
						<td>
							<fmt:formatDate pattern="yyyy-MM-dd" value="${savedmnList.regDttm}"/><br>
							<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
							<span class="cash_plus">+${savedmnList.svmnTypeNm}</span>
							</c:if>
							<c:if test="${savedmnList.svmnTypeNm eq '차감'}">
								<span class="cash_minus">-${savedmnList.svmnTypeNm}</span>
							</c:if>
						</td>
						<td>
							${savedmnList.content}
						</td>
						<td>

							<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
								<span class="emoney_detail">
							</c:if>
							${savedmnList.svmnType}
							<fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>
							<c:if test="${savedmnList.svmnTypeNm eq '적립'}">
							</span>
							</c:if>
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
        
    <div class="layer_popup" id="exchange_offcp_popup" style="display:none; top:5%;">
		<div class="dimmed2"></div>
		<div class="pop_wrap">
			<div class="popup_header">
				<h1 class="popup_tit">할인권 전환</h1>
				<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
			</div>
			<div class="popup_body"> 
				<p class="discount_warning">※  마켓포인트를 할인권으로 전환하신 후에는 되돌리기가 불가능합니다.</p>
				<div class="popup_tCart_outline coupon_scroll" style="height:300px;">
				
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
							<caption>할인권 전환 내용입니다.</caption>
							<colgroup>
								<col style="width:100%">
							</colgroup>
							<tbody>
								<tr>
									<th>전환가능한 보유 마켓포인트</th>
								</tr>
								<tr>
									<td class="textL">
										<em class="discount_price" style="margin-left:30px"><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
									</td>
								</tr>
								<tr>								
									<th class="vaT textL">쿠폰 금액선택</th>
								</tr>
								<tr>
									<td class="textL" style="line-height: 200%; padding-bottom:20px;">
										<c:forEach var="li" items="${couponList }" varStatus="status">
											<c:if test="${status.index != 0 }"><br></c:if>
											<input type="radio" class="discount_radio" id="radio_discount${status.index }" name="radio_discount" value="${li.couponBnfDcAmt }" data-no="${li.couponNo }">
											<label for="radio_discount${status.index }"><span <c:if test="${status.index == 0}">style="margin-left:30px"</c:if>></span>${li.couponNm }</label>
										</c:forEach>
									</td>
								</tr>
								<tr>
									<td class="discount_total">
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
				</div>
			</div>
		</div>
	</div>
    </t:putAttribute>
</t:insertDefinition>