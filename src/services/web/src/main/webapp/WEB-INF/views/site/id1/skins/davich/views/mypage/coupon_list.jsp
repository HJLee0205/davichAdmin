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
    <t:putAttribute name="title">다비치마켓 :: 나의 쿠폰</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    	<script src="${_SKIN_JS_PATH}/jquery-barcode.js" charset="utf-8"></script>
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));
            
            //달력
            $(function() {
                $( ".datepicker" ).datepicker();
            });

            //검색
            /* $('.btn_date').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Dmall.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_list').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Dmall.FormUtil.submit('/front/coupon/coupon-list', param);
            }); */
            
            $('#searchGoodsTypeCd, #searchAgeCd').change(function(){
            	var goodsTypeCd = $('#searchGoodsTypeCd').val();
            	var ageCd = $('#searchAgeCd').val();
            	var param = {goodsTypeCd : goodsTypeCd, ageCd : ageCd};
            	Dmall.FormUtil.submit('/front/coupon/coupon-list', param);
            });

            //적용대상
            $('.btn_apply_pop').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                $('#apply_content').html('');
                var d = $(this).data();

                var htmlApplyTarget = '';
                //alert(d.couponNo + ' : 쿠폰 적용 대상 / '+ d.couponApplyLimitCd);
                if(d.couponApplyLimitCd == '01') {
                    htmlApplyTarget += '<table class="tProduct_Insert" style="margin-top:5px">';
                    htmlApplyTarget += '    <caption><h1 class="blind">쿠폰적용 선택 표 입니다.</h1></caption>';
                    htmlApplyTarget += '    <colgroup>';
                    htmlApplyTarget += '        <col style="width:24%">';
                    htmlApplyTarget += '        <col style="width:">';
                    htmlApplyTarget += '    </colgroup>';
                    htmlApplyTarget += '    <tbody>';
                    htmlApplyTarget += '        <tr>';
                    htmlApplyTarget += '            <th class="order_tit">적용 상품 선택</th>';
                    htmlApplyTarget += '            <td>전체상품</td>';
                    htmlApplyTarget += '        </tr>';
                    htmlApplyTarget += '    </tbody>';
                    htmlApplyTarget += '</table>';

                    $('#apply_content').html(htmlApplyTarget);
                    Dmall.LayerPopupUtil.open($('#coupon_apply_popup'));
                } else {
                    var url = "/front/coupon/coupon-applytarget-list";
                    var param = {couponNo:d.couponNo, couponApplyLimitCd:d.couponApplyLimitCd, couponApplyTargetCd:d.couponApplyTargetCd};
                    Dmall.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            htmlApplyTarget += '<table class="tProduct_Insert" style="margin-top:5px;width:100%">';
                            htmlApplyTarget += '    <caption><h1 class="blind">쿠폰적용 선택 표 입니다.</h1></caption>';
                            htmlApplyTarget += '    <colgroup>';
                            htmlApplyTarget += '        <col style="width:24%">';
                            htmlApplyTarget += '        <col style="width:">';
                            htmlApplyTarget += '    </colgroup>';
                            htmlApplyTarget += '    <tbody>';
                            if(d.couponApplyTargetCd == '02' || d.couponApplyTargetCd == '03') {
                                if(result.data.couponTargetCtgList != null && result.data.couponTargetCtgList.length > 0){
                                    htmlApplyTarget += '        <tr>';
                                    if(d.couponApplyLimitCd == "02") {
                                        htmlApplyTarget += '        <th class="order_tit">적용 카테고리</th>';
                                    } else if(d.couponApplyLimitCd == "03"){
                                        htmlApplyTarget += '        <th class="order_tit">적용 예외 카테고리</th>';
                                    }
                                    htmlApplyTarget += '            <td>';
                                    htmlApplyTarget += '                <ul class="coupon_ok_category">';
                                    $.each(result.data.couponTargetCtgList, function (i){
                                        htmlApplyTarget += '                    <li>- '+result.data.couponTargetCtgList[i].ctgNm+'</li>';
                                    })
                                    htmlApplyTarget += '                <ul>';
                                    htmlApplyTarget += '            </td>';
                                    htmlApplyTarget += '        </tr>';
                                }
                            }
                            if(d.couponApplyTargetCd == '01' || d.couponApplyTargetCd == '03') {
                                if(result.data.couponTargetGoodsList != null && result.data.couponTargetGoodsList.length > 0){
                                    htmlApplyTarget += '        <tr>';
                                    if(d.couponApplyLimitCd == "02") {
                                        htmlApplyTarget += '        <th class="order_tit">적용 상품</th>';
                                    } else if(d.couponApplyLimitCd == "03"){
                                        htmlApplyTarget += '        <th class="order_tit">적용 예외 상품</th>';
                                    }
                                    htmlApplyTarget += '            <td style="padding:0">';
                                    htmlApplyTarget += '                <div class="coupon_ok_product_scroll">';
                                    htmlApplyTarget += '                    <ul class="coupon_select_list">';
                                    $.each(result.data.couponTargetGoodsList, function (j){

                                        htmlApplyTarget += '                        <li class="pix_img">';
                                        htmlApplyTarget += '                            <img src="'+result.data.couponTargetGoodsList[j].imgPath+'" alt="상품 이미지">';
                                        htmlApplyTarget += '                            <div class="goods_title">';
                                        htmlApplyTarget += '                                '+result.data.couponTargetGoodsList[j].goodsNm;
                                        htmlApplyTarget += '                            </div>';
                                        htmlApplyTarget += '                        </li>';
                                    });
                                    htmlApplyTarget += '                    </ul>';
                                    htmlApplyTarget += '                </div>';
                                    htmlApplyTarget += '            </td>';
                                    htmlApplyTarget += '        </tr>';
                                }
                            }
                            htmlApplyTarget += '    </tbody>';
                            htmlApplyTarget += '</table>';

                            $('#apply_content').html(htmlApplyTarget);
                            Dmall.LayerPopupUtil.open($('#coupon_apply_popup'));
                        }
                    });
                }
            });
            
            $('.btn_print_pop').click(function(){
            	
            	var d = $(this).data();
            	var url = "/front/coupon/coupon-info-ajax";
                var param = {memberCpNo:d.couponNo};
                
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
                    		$('#print_bnfValue').css("margin-top","30px");
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
                    	
                    	$("#bcTarget_coupon").barcode(cpIssueNo, "code128",{barWidth:3});
                    	$('#cp_issue_no').text("NO. " + cpIssueNo.substring(0,2) + "-" + cpIssueNo.substring(2,5) + "-" + cpIssueNo.substring(5,9) + "-" + cpIssueNo.substring(9,13));
                    	
                    	Dmall.LayerPopupUtil.open($('#coupon_print_popup'));
                    }
                });
            	
            });

            // 적용대상 팝업 닫기
            $('.btn_mypage_ok').on('click', function() {
                Dmall.LayerPopupUtil.close('coupon_apply_popup');
            });

        });
        
        // 인쇄하기
        function btn_img_print(){
        	
        	var printWindow = window.open("about:blank","_blank"); 
        	
        	html2canvas($('#print_area').get(0)).then(function(canvas) {
                var image = canvas.toDataURL("image/png");
                printWindow.document.open();
                printWindow.document.write(ImagetoPrint(image));
                printWindow.document.close();
        	});
        	
        }
        
        // 이미지가 인쇄 프리뷰에 나오기 위해 필요
        function ImagetoPrint(image) {
            return "<html><head><script>function step1(){\n" +
                    "setTimeout('step2()', 100);}\n" +
                    "function step2(){window.print();window.close()}\n" +
                    "</scri" + "pt></head><body onload='step1()'>\n" +
                    "<img src='" + image + "' /></body></html>";
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
				<h3 class="my_tit">나의 D-쿠폰</h3>
				<div class="my_qna_info">					
					<span class="icon_purpose">사용기한이 지난 쿠폰은 자동으로 삭제됩니다.</span>	                       	                       
					<div class="my_search_area">							
						<select name="goodsTypeCd" id="searchGoodsTypeCd">
							<tags:option codeStr=":제품별;01:안경테;02:선글라스;03:안경렌즈;04:콘텍트렌즈;" value="${so.goodsTypeCd }"/>
						</select>
						<select name="ageCd" id="searchAgeCd">
							<tags:option codeStr=":연령대별;10:10대;20:20대;30:30대;40:40대;50:50대;60:60대;" value="${so.ageCd }"/>
						</select>
					</div>
				</div>
				<form:form id="form_id_list" commandName="so">
	              	<form:hidden path="page" id="page" />
	              	<form:hidden path="rows" id="rows" />
              									
					<table class="tCart_Board mybenefit">
						<caption>
							<h1 class="blind">나의 쿠폰 목록입니다.</h1>
						</caption>
						<colgroup>
							<col style="width:145px">
							<col style="width:">
							<col style="width:150px">
							<col style="width:110px">
							<col style="width:110px">
							<col style="width:140px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>쿠폰명/혜택</th>
								<th>사용기한</th>
								<th>적용대상</th>
								<th>상세</th>
								<th>사용일시</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
	                            <c:when test="${fn:length(resultListModel.resultList) > 0}">
		                            <c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">
			                            <tr>
											<td class="noline">	
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
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"><em></c:if>
																		<fmt:formatNumber value="${couponList.couponBnfValue}" type="currency" maxFractionDigits="0" currencySymbol=""/>
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:when>
																<c:when test="${couponList.couponBnfCd eq '02' }">
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"><em></c:if>
																		<fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:when>
																<c:otherwise>
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"><em></c:if>
																		${couponList.couponBnfTxt}
																	<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}"></em></c:if>
																</c:otherwise>
															</c:choose>
															${couponList.bnfUnit}
															<!--p class="text">할인쿠폰</p-->
															<%-- <c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'Y'}">
																<c:if test="${couponList.goodsTypeCd eq '02' || couponList.goodsTypeCd eq '03' || couponList.goodsTypeCd eq '04' }"><p class="btm">전국 다비치매장(일부매장 제외)</p></c:if>
															</c:if> --%>
														</c:otherwise>
													</c:choose>
												</div>															
											</td>
											<td class="textL vaT">
												<a href="javascript:;" style="cursor:default;" class="coupon_name">${couponList.couponNm}</a>
												<c:if test="${couponList.couponKindCd ne '97'}">
												<p class="coupon_option">
													<fmt:formatNumber value="${couponList.couponUseLimitAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원 이상 구매시 
													<c:if test="${couponList.couponBnfCd eq '01' && couponList.couponBnfDcAmt > 0}">
	                                    				/ 최대 <fmt:formatNumber value="${couponList.couponBnfDcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
	                                    			</c:if>
												</p>
												</c:if>
											</td>
											<td>
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
																(${couponList.couponApplyPeriod} 일 남음)
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
	                                    			<c:when test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}">
	                                    				<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'Y'}">
	                                    				오프라인<br>다비치매장
	                                    				</c:if>
	                                    				<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn eq 'F'}">
	                                    				온/오프라인<br>다비치매장
	                                    				</c:if>
	                                    			</c:when>
	                                    			<c:otherwise>
	                                    				<c:choose>
	                                    			<c:when test="${couponList.couponApplyLimitCd eq '01'}">
	                                    				전체상품
	                                    			</c:when>
	                                    			<c:otherwise>
	                                    				<button type="button" class="btn_coupon_product btn_apply_pop" data-coupon-no="${couponList.couponNo}" data-coupon-apply-limit-cd="${couponList.couponApplyLimitCd}" data-coupon-apply-target-cd="${couponList.couponApplyTargetCd}">적용</button>
	                                    			</c:otherwise>
	                                    		</c:choose>
	                                    			</c:otherwise>
	                                    		</c:choose>
											</td>
											<td>
												<c:if test="${couponList.couponKindCd eq '99' or couponList.offlineOnlyYn ne 'N'}">
													<c:choose>
														<c:when test="${couponList.useDttm eq null}">
															<button type="button" class="btn_coupon_product btn_print_pop" data-coupon-no="${couponList.memberCpNo}">보기/인쇄</button>
														</c:when>
														<c:otherwise>
															사용완료
														</c:otherwise>
													</c:choose>
												</c:if>
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
				                                    	${couponList.useDttm}
				                                    </c:otherwise>
				                                </c:choose>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
		                            <tr>
		                                <td colspan="6">조회된 데이터가 없습니다.</td>
		                            </tr>
	                            </c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</form:form>
				
				<!-- pageing -->
				<div class="tPages" id="div_id_paging"> 
                        <grid:paging resultListModel="${resultListModel}" />
				</div>
				<!--// pageing -->
					
			</div>
		</div>		
		<!--// content -->
	</div>
    <!---// 02.LAYOUT: 마이페이지 --->
    
	<!--- popup 쿠폰적용 대상 --->
	<div class="popup_coupon_select" id="coupon_apply_popup" style="display:none">
	    <div class="popup_header">
	        <h1 class="popup_tit">쿠폰적용 대상</h1>
	        <button type="button" class="btn_close_popup"><img src="../img/common/btn_close_popup.png" alt="팝업창닫기"></button>
	    </div>
	    <div class="popup_content">
	        <div id="apply_content"></div>
	        <div class="popup_btn_area">
	            <button type="button" class="btn_mypage_ok">닫기</button>
	        </div>
	    </div>
	</div>
	<!---// popup 쿠폰적용 대상 --->
	
	<!-- popup -->
	<div class="popup_coupon_select" id="coupon_print_popup" style="display:none;width:511px">
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
					<table class="tCart_Insert">
						<caption>쿠폰 정보 내용입니다.</caption>
						<colgroup>
							<col style="width:100px">
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
				<div class="popup_btn_area print">
		            <button type="button" class="btn_go_okay" onClick="btn_img_print();"><i></i>프린트</button>
		        </div>
			</div>
		</div>
	</div>
	<!--// popup -->
	
    </t:putAttribute>
</t:insertDefinition>