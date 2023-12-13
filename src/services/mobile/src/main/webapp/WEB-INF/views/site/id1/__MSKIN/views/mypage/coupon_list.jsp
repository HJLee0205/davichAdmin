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
    <t:putAttribute name="title">나의 쿠폰</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
        	
            //페이징
            $('.more_view').on('click', function() {
            	var pageIndex = Number($('#page').val())+1;    		        
            	$("#page").val(pageIndex);
            	var param = $('#form_id_list').serialize();
           		var url = '${_MOBILE_PATH}/front/coupon/coupon-list-paging';
           		Dmall.AjaxUtil.loadByPost(url, param, function(result) {

    		    	if('${resultListModel.totalPages}' == pageIndex){
    		        	$('#div_id_paging').hide();
    		        }
    		        $('#tbody').append(result);
    	        })
             });
            
            $('#searchGoodsTypeCd, #searchAgeCd').change(function(){
            	var goodsTypeCd = $('#searchGoodsTypeCd').val();
            	var ageCd = $('#searchAgeCd').val();
            	var param = {goodsTypeCd : goodsTypeCd, ageCd : ageCd};
            	Dmall.FormUtil.submit('${_MOBILE_PATH}/front/coupon/coupon-list', param);
            });
            
        });
        
        function fn_print_pop(couponNo){
        	
        	var url = "${_MOBILE_PATH}/front/coupon/coupon-info-ajax";
            var param = {memberCpNo:couponNo};
            
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                	var data = result.data;
                	
                	var endDttm = data.cpApplyStartDttm + ' ~ ' + data.cpApplyEndDttm;
                	if(data.couponApplyPeriodCd != '01'){
                		endDttm = data.couponApplyPeriodDttm;
                	}
                	var bnfDc = data.couponUseLimitAmt + '원 이상 구매시';
                	if(data.couponBnfCd == '01' && data.couponBnfDcAmt > 0){
                		bnfDc += '/ 최대 ' + data.couponBnfDcAmt + '원';
                	}
                	var dcAmt = data.couponBnfDcAmt;
                	var dcUnit = '원';
                	if(data.couponBnfCd == '01'){
                		dcAmt = data.couponBnfValue;
                		dcUnit = '%';
                	}
                	var divType = "coupon";
                	if(data.goodsTypeCd == '01') divType += " off01";
                	else if(data.goodsTypeCd == '02') divType += " off04";
                	else if(data.goodsTypeCd == '03') divType += " off03";
                	else if(data.goodsTypeCd == '04') divType += " off02";
                	else divType += " off00";
                	$('#print_div').attr('class', divType);
                	$('#print_regDttm').text(data.issueDttm);
                	$('#print_usePeriod').text(endDttm);
                	$('#print_couponNm').text(data.couponNm);
                	if(data.couponKindCd == '97'){
                		$('#print_bnfValue').html('증정쿠폰');
                		$('#print_bnfValue').css("margin-top","15px");
                	}else{
                		$('#print_useLimitAmt').text(commaNumber(bnfDc));
                		if(data.couponBnfCd != '03') {
							$('#print_bnfValue').html('<em>' + commaNumber(dcAmt) + '</em>' + dcUnit + ' 할인');
						}else{
							$('#print_bnfValue').html('<em style="font-size:23px;">' + data.couponBnfTxt+'</em>');
						}
                	}
                	$('#print_dscrt').text(data.couponDscrt);
                	
                	var cpIssueNo = data.cpIssueNo;
                	
                	$("#bcTarget_coupon").barcode(cpIssueNo, "code128",{barWidth:2});
                	$('#cp_issue_no').text("NO. " + cpIssueNo.substring(0,2) + "-" + cpIssueNo.substring(2,5) + "-" + cpIssueNo.substring(5,9) + "-" + cpIssueNo.substring(9,13));
                	
                	Dmall.LayerPopupUtil.open($('#coupon_print_popup'));
                }
            });
        }
        
        function commaNumber(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        };
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
			보유한 쿠폰
		</div>
		<!-- filter area 20190307 -->
		<div class="list_head coupon">				
			<div class="select_coupon">
				<label for="searchAgeCd">연령대별</label>
				<select name="ageCd" id="searchAgeCd">
					<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;" value="${so.ageCd }"/>
				</select>
			</div>
			<div class="select_coupon">
				<label for="searchGoodsTypeCd">:제품별</label>
				<select name="goodsTypeCd" id="searchGoodsTypeCd">
					<tags:option codeStr=":제품별;01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${so.goodsTypeCd }"/>
				</select>
			</div>
		</div>
		<!--// filter area 20190307 -->
		<div class="coupon_list_area">
			<table class="tMypage_list">
				<colgroup>	
					<col style="width:95px">		
					<col style="">
					<col style="width:21%">
					<col style="width:21%">
				</colgroup>
				<thead>
					<tr>
						<th>쿠폰명/혜택</th>
						<th>이벤트명</th>
						<th>사용기한</th>
						<th>사용일시</th>
					</tr>
				</thead>
				<tbody id="tbody">
				<c:choose>
				<c:when test="${fn:length(resultListModel.resultList) > 0}">
				<c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">
				
					<tr <c:if test="${couponList.couponKindCd eq '99' and couponList.useDttm eq null or couponList.offlineOnlyYn ne 'N'}">onClick="fn_print_pop('${couponList.memberCpNo}');"</c:if>>
						<td class="textL">
							<div class="my_coupon
									<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}">
										<c:choose>
											<c:when test="${couponList.goodsTypeCd eq '01' }"> off01</c:when>
											<c:when test="${couponList.goodsTypeCd eq '02' }"> off04</c:when>
											<c:when test="${couponList.goodsTypeCd eq '03' }"> off03</c:when>
											<c:when test="${couponList.goodsTypeCd eq '04' }"> off02</c:when>
											<c:otherwise> off00</c:otherwise>
										</c:choose>
									</c:if>">
								<c:choose>
									<c:when test="${couponList.couponKindCd eq '97'}">
										증정쿠폰
									</c:when>
									<c:otherwise>	
										<c:choose>
											<c:when test="${couponList.couponBnfCd eq '01' }">
												<fmt:formatNumber value="${couponList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>		
											</c:when>
											<c:when test="${couponList.couponBnfCd eq '02' }">
												<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
											</c:when>
											<c:otherwise>
													${couponList.couponBnfTxt}
											</c:otherwise>
										</c:choose>
										${couponList.bnfUnit}
									</c:otherwise>
								</c:choose>
							</div>	
						</td>
						<td class="textL">
							${couponList.couponNm}
							<c:if test="${couponList.couponKindCd eq '99' and couponList.useDttm eq null or couponList.offlineOnlyYn ne 'N'}">▶</c:if>
							<!--span class="coupon_detail">
								<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시 
								<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
                       				/ 최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                       			</c:if>
							</span-->
						</td>
						<td class="f11">
							<c:choose>
								<c:when test="${couponList.couponApplyPeriodCd eq '01' }">
									${couponList.cpApplyStartDttm}<br>~ ${couponList.cpApplyEndDttm}
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${couponList.couponApplyPeriodCd eq '02' }">
											<c:if test="${couponList.couponApplyPeriodDttm ne null}">
												${couponList.couponApplyPeriodDttm}
												<br>
												<span class="coupon_dday">D-${couponList.couponApplyPeriod}일</span>
											</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${couponList.confirmYn eq 'N'}">
											구매확정일로 부터 ${couponList.couponApplyConfirmAfPeriod} 일간 사용 가능
											</c:if>
											<c:if test="${couponList.confirmYn eq 'Y'}">
											${couponList.couponApplyPeriodDttm}
											</c:if>
										</c:otherwise>
									</c:choose>

								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<c:choose>
	                            <c:when test="${couponList.useDttm eq null}">
	                            	<c:choose>
										<c:when test="${couponList.couponApplyPeriodCd eq '03' }">
											<c:if test="${couponList.confirmYn eq 'N'}">
												사용불가
											</c:if>
											<c:if test="${couponList.confirmYn eq 'Y'}">
												미사용
											</c:if>
										</c:when>
										<c:otherwise>
											미사용
										</c:otherwise>
									</c:choose>
	                            </c:when>
	                            <c:otherwise>
	                            	<span class="used">${couponList.useDttm}</span>
	                            </c:otherwise>
	                        </c:choose>
						</td>
					</tr>
				</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="4"><p class="no_product">조회된 데이터가 없습니다.</p></td>
					</tr>
				 </c:otherwise>
				 </c:choose>
				</tbody>
			</table>
		</div>
		<!--- 페이징 --->
		<div class="tPages" id="div_id_paging">
            <grid:paging resultListModel="${resultListModel}" />
        </div>
		<!---// 페이징 --->
 </form:form>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
	
	<!-- popup -->
	<div class="popup_coupon_select" id="coupon_print_popup" style="display:none;">
		<div class="popup_header">
			<h1 class="popup_tit">쿠폰정보</h1>
			<button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
		</div>
		<div class="popup_content"> 
			<div id="print_area">
				<div class="popup_coupon_area">
					<div class="coupon" id="print_div">
						<p class="price" id="print_bnfValue"></p>
						<p class="text" id="print_useLimitAmt"></p>
					</div>
					<div class="barcode">
						<div id="bcTarget_coupon" style="margin: 0 auto"></div>
						<p class="member_no"><span id="cp_issue_no" style="font-size:20px;"></span></p>
					</div>
				</div>
				<div class="popup_coupon_outline">
					<table class="tb_coupon">
						<caption>쿠폰 정보 내용입니다.</caption>
						<colgroup>
							<col style="width:70px">
							<col style="width:">
						</colgroup>
						<tbody>
							<tr>
								<th>이벤트명</th>
								<td id="print_couponNm">0000-00-00</td>
							</tr>
							<tr>
								<th>사용기간</th>
								<td id="print_usePeriod">0000-00-00 00:00 ~ 0000-00-00 00:00</td>
							</tr>
							<tr>
								<th>사용</th>
								<td>전국 다비치매장 (일부매장 제외)</td>
							</tr>
						</tbody>
					</table>
				</div>
					
				<div class="popup_bottom_coupon">
					<p class="tit">※  쿠폰사용안내</p>
					<div class="text_area" id="print_dscrt">
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--// popup -->

    </t:putAttribute>
</t:insertDefinition>