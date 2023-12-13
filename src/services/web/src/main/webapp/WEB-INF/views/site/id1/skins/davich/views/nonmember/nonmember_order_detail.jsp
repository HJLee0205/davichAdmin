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
	<t:putAttribute name="title">비회원 주문/배송상세</t:putAttribute>

	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //재구매
        $('#btn_rebuy').on('click',function(){
            $('#order_form').attr('action','/front/order/order-form');
            $('#order_form').attr('method','post');
            $('#order_form').submit();
        });
    });

    function order_list(no, ordrMobile){
        Dmall.FormUtil.submit('/front/order/nomember-order-list', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile});
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 비회원 주문/배송조회 메인  --->
    <!--- category header --->
	<div id="category_header">
        <div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>
					비회원 주문/배송조회
				</li>
			</ul>
		</div>
	</div>
    <!---// category header --->        

	<div class="mypage_middle">
    <form name="form_id_order_info" id="form_id_order_info">
        <input type="hidden" name="useGbCd" id="useGbCd"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="telNo" id="telNo"/>
        <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
        <c:choose>
            <c:when test="${fn:length(order_info.orderGoodsVO) gt 1}">
            <input type="hidden" name="goodsNm" id="goodsNm" value="${order_info.orderGoodsVO[0].goodsNm} 외 ${fn:length(order_info.orderGoodsVO)-1}건">
            </c:when>
            <c:otherwise>
            <input type="hidden" name="goodsNm" id="goodsNm" value="${order_info.orderGoodsVO[0].goodsNm}">
            </c:otherwise>
        </c:choose>

		<!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
		<%@ include file="include/nonmember_left_menu.jsp" %>
		<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->          
	
		<!--- 비회원 주문/배송조회 오른쪽 컨텐츠 --->
		<div id="mypage_content">
			<div class="mypage_body">				
				<h3 class="my_tit">주문 상세정보</h3>
				
				<h4 class="my_stit">주문상품정보</h4>
				<div class="my_order_info">
					<p class="text">
						<span>주문번호 : <em> ${so.ordNo}</em></span>
						<span>주문일시 : 2019-03-11</span>
					</p>
					<button type="button" class="btn_order_again" id="btn_rebuy"><i></i>현재 상품 재주문</button>
				</div>		
				
				<table class="tCart_Board Mypage">
					<caption>
						<h1 class="blind">주문상품정보 내용입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:68px">
						<col style="width:">
						<col style="width:110px">
						<col style="width:110px">
						<col style="width:110px">
						<col style="width:110px">
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">상품/옵션/수량</th>
							<th>상품금액</th>
							<th>할인금액</th>
							<th>배송비</th>
							<th>주문/배송상태</th>
						</tr>
					</thead>
					<tbody>
						<c:set var="sumQty" value="0"/>
						<c:set var="sumSaleAmt" value="0"/>
						<c:set var="sumDcAmt" value="0"/>
						<c:set var="sumMileage" value="0"/>
						<c:set var="sumDlvrAmt" value="0"/>
						<c:set var="sumPayAmt" value="0"/>
						<c:set var="preGrpCd" value=""/>
						<c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
						<c:forEach var="orderGoodsVo" items="${order_info.orderGoodsVO}" varStatus="status">
						<tr>
							<td class="noline">
								<div class="cart_img">
									<img src="${orderGoodsVo.imgPath}">
								</div>
							</td>
							<td class="textL">
								<c:if test="${orderGoodsVo.addOptYn eq 'Y'}">
									<a href="#">${orderGoodsVo.goodsNm}</a>
								</c:if>
								<c:if test="${orderGoodsVo.addOptYn eq 'N'}">
									<a href="#">${orderGoodsVo.goodsNm}</a>
									<c:if test="${!empty orderGoodsVo.itemNm}">
										<p class="option"><c:out value="${orderGoodsVo.itemNm}"/> ${orderGoodsVo.ordQtt} 개</p>
									</c:if>
								</c:if>
							</td>
							<td>
								<span class="price"><fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="number"/></span>원
							</td>
							<td>
								<c:if test="${orderGoodsVo.saleAmt < 0}">
									<span class="discount">(-<fmt:formatNumber value="${orderGoodsVo.saleAmt}" type="number"/>)</span>
								</c:if>
							</td>
							<td rowspan="${orderGoodsVo.cnt}">
							<c:set var="dlvrText" value=""/>
							<c:choose>
								<c:when test="${orderGoodsVo.dlvrcPaymentCd eq '02' }">
									<c:set var="dlvrText" value="선불"/>
									<c:if test="${orderGoodsVo.realDlvrAmt + orderGoodsVo.areaAddDlvrc == 0}">
										<c:set var="dlvrText" value="무료"/>
									</c:if>
								</c:when>
								<c:otherwise>
									<c:set var="dlvrText" value="${orderGoodsVo.dlvrcPaymentNm}"/>
								</c:otherwise>
							</c:choose>
							<c:if test="${orderGoodsVo.addOptYn eq 'N'}">
								${dlvrText}
								<c:if test="${orderGoodsVo.dlvrcPaymentCd ne '01' && orderGoodsVo.dlvrcPaymentCd ne '04' && orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc gt 0}">
								<br><fmt:formatNumber value='${orderGoodsVo.realDlvrAmt+orderGoodsVo.areaAddDlvrc}' type='number'/>원
								</c:if>
							</c:if>
							</td>
							<td rowspan="${orderGoodsVo.cnt}">
							${orderGoodsVo.ordDtlStatusNm}
							</td>
						</tr>
						<c:set var="sumQty" value="${sumQty + orderGoodsVo.ordQtt}"/>
						<c:set var="sumSaleAmt" value="${sumSaleAmt + (orderGoodsVo.saleAmt*orderGoodsVo.ordQtt)}"/>
						<c:set var="sumDcAmt" value="${sumDcAmt +orderGoodsVo.dcAmt}"/>
						<c:set var="sumMileage" value="${sumMileage + orderGoodsVo.addedAmountAmt}"/>
						<c:set var="sumDlvrAmt" value="${sumDlvrAmt + orderGoodsVo.realDlvrAmt}"/>
						<c:set var="sumPayAmt" value="${sumPayAmt + orderGoodsVo.payAmt}"/>
						<%-- 재주문 관련 --%>
						<c:set var="itemArr" value=""/>
						<c:set var="optArr" value=""/>
						<c:if test="${orderGoodsVo.itemNo ne preGrpCd && orderGoodsVo.addOptYn eq 'N'}">
							<c:set var="itemArr" value="${orderGoodsVo.goodsNo}▦${orderGoodsVo.itemNo}^${orderGoodsVo.ordQtt}^${orderGoodsVo.dlvrcPaymentCd}▦"/>
							<c:forEach var="optList" items="${order_info.orderGoodsVO }" varStatus="status2">
								<c:if test="${optList.addOptYn eq 'Y' && optList.itemNo eq orderGoodsVo.itemNo}">
									<c:if test="${!empty optArr}">
										<c:set var="optArr" value="${optArr}*"/>
									</c:if>
									<c:set var="optArr" value="${optArr}${optList.addOptNo}^${optList.addOptDtlSeq}^${optList.ordQtt}"/>
								</c:if>
							</c:forEach>
						<input type="hidden" name="itemArr" value="${itemArr}${optArr}▦${orderGoodsVo.ctgNo}">
						</c:if>
						<c:set var="preGrpCd" value="${orderGoodsVo.itemNo}"/>
						</c:forEach>
					</tbody>
				</table>

				<h3 class="mypage_con_stit">결제정보</h3>
				<div class="pay_info_box">
					<div class="count">
						<span>상품금액</span>
						<em><fmt:formatNumber value='${sumSaleAmt}' type='number'/></em>원
					</div>
					<i class="minus"></i>
					<div class="count">
						<span>할인금액</span>
						<em><fmt:formatNumber value="${sumDcAmt}" type="number"/></em>원
					</div>
					<i class="plus"></i>
					<div class="count">
						<span>배송비</span>
						<em><fmt:formatNumber value="${sumDlvrAmt}" type="number"/></em>원
					</div>
					<i class="equal"></i>
					<div class="count total">
						<span>결제금액</span>
						<em><fmt:formatNumber value="${sumPayAmt}" type="number"/></em>원	
					</div>
				</div>
				<!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->
				<c:forEach var="orderPayVO_Bank" items="${order_info.orderPayVO}" varStatus="status">
				<c:if test="${orderPayVO_Bank.paymentWayCd eq '11' || orderPayVO_Bank.paymentWayCd eq '22'}">
				<div class="pay_info_bottom">
					<span class="dot">결제정보 : 
					<c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
					${orderPayVO.paymentWayNm}
					</c:forEach></span>
					<span class="dot">입금계좌 : ${orderPayVO_Bank.bankNm} ${orderPayVO_Bank.confirmNo} (입금자:)</span>
					<span class="dot">예금주 : ${orderPayVO_Bank.dpsterNm}</span>
					<fmt:parseDate var="dpstScdDt" value="${orderPayVO_Bank.dpstScdDt}" pattern="yyyyMMddHHmmss"/>
					<span class="dot">입금확인일시 : <fmt:formatDate value="${dpstScdDt}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
				</div>
				</c:if>
				</c:forEach>
				<!-- 입금대기 주문건에 한해서 입금은행정보 노출 -->

				<div class="payment_area mypage">
					<div class="left">
						<h4 class="my_stit">배송지 정보</h4>
						<div class="tCart_outline">
							<table class="tCart_Insert">
								<caption>배송지 정보입니다.</caption>
								<colgroup>
									<col style="width:112px">
									<col style="width:">
								</colgroup>
								<tbody>
									<tr>
										<th>받는사람</th>
										<td>${order_info.orderInfoVO.adrsNm}</td>
									</tr>
									<tr>
										<th>연락처</th>
										<td>${order_info.orderInfoVO.adrsMobile}</td>
									</tr>
									<tr>
										<th>주소</th>
										<td>
											[${order_info.orderInfoVO.postNo}]<br>
											${order_info.orderInfoVO.roadnmAddr}<br>
											${order_info.orderInfoVO.dtlAddr}<br>
										</td>
									</tr>
									<tr>
										<th>배송메모</th>
										<td>${order_info.orderInfoVO.dlvrMsg}</td>
									</tr>
								</tbody>
							</table>	
						</div>
					</div>
					<div class="right">
						<h4 class="my_stit">주문고객 정보</h4>
						<div class="tCart_outline">
							<table class="tCart_Insert">
								<caption>주문고객 정보입니다.</caption>
								<colgroup>
									<col style="width:100px">
									<col style="width:">
								</colgroup>
								<tbody>
									<tr>
										<th>주문자명</th>
										<td>${order_info.orderInfoVO.ordrNm}</td>
									</tr>
									<tr>
										<th>이메일</th>
										<td>${order_info.orderInfoVO.ordrEmail}</td>
									</tr>
									<tr>
										<th>핸드폰</th>
										<td>${order_info.orderInfoVO.ordrMobile}</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="btn_area">
					<c:if test="${billYn eq 'Y'}">
					<c:forEach var="orderPayVO" items="${order_info.orderPayVO}" varStatus="status">
						<c:if test="${orderPayVO.paymentWayCd eq '23'}">
							<!-- 신용카드영수증 조회 -->
							<input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/><BR>
							<input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>" readonly="readonly"/><BR>
							<input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/><BR>
							<button type="button" class="btn_cash_bill" onclick="show_card_bill();">신용카드 영수증조회</button>
						</c:if>
						<c:if test="${orderPayVO.paymentWayCd eq '11' || orderPayVO.paymentWayCd eq '21' || orderPayVO.paymentWayCd eq '22'}">
							<input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/><BR>
							<input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.paymentAmt}' integerOnly='true'/>"readonly="readonly"/><BR>
							<input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}" readonly="readonly"/><BR>
							<!-- 현금영수증발급신청 -->
							<c:if test="${cash_bill_info.data.ordNo ne 'N' && tax_bill_info.data.ordNo ne 'N'}">
							<button type="button" class="btn_cash_bill" onclick="cash_receipt_pop();">현금영수증 발급신청</button>
							<!-- 세금계산서발급신청 -->
							<button type="button" class="btn_cash_bill" onclick="tax_bill_pop();">세금계산서 발급신청</button>
							</c:if>
							<c:if test="${!empty cash_bill_info.data.linkTxNo}">
							<input type="hidden" name="txNo" id="txNo" value="${cash_bill_info.data.linkTxNo}"/>
							<!-- 현금영수증발급조회 -->
							<button type="button" class="btn_cash_bill" onclick="show_cash_receipt();">현금영수증조회</button>
							</c:if>
							<c:if test="${!empty tax_bill_info.data.linkTxNo}">
							<!-- 세금계산서발급조회 -->
							<button type="button" class="btn_cash_bill" onclick="show_tax_bill();">세금계산서조회</button>
							</c:if>
						</c:if>
					</c:forEach>
					</c:if>
					<div class="mypage_btn_area">
						<button type="button" class="btn_go_home02" onclick="order_list('${so.ordNo}', '${so.nonOrdrMobile}');">이전 페이지로</button>
					</div>
				</div>
			</div>
		</div>
		<!---// 비회원 주문/배송조회 오른쪽 컨텐츠 --->

		<!--- popup 현금영수증 발급신청 --->
		<div class="popup_my_cash" id="popup_my_cash" style="display: none;">
			<div class="popup_header">
				<h1 class="popup_tit">현금영수증 발급신청</h1>
				<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
			</div>
			<div class="popup_content">
				<table class="tMypage_Board" style="margin-top:15px">
					<caption>
						<h1 class="blind">현금영수증 발급신청 폼 입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:110px">
						<col style="width:">
					</colgroup>
					<tbody>
						<tr>
							<th class="textL">발행용도</th>
							<td class="textL">
								<input type="radio" id="cash_personal" name="my_cash" checked="checked">
								<label for="cash_personal" style="margin-right:44px">
									<span></span>
									개인 소득공제용
								</label>
								<input type="radio" id="cash_business" name="my_cash">
								<label for="cash_business">
									<span></span>
									사업자지출 증빙용
								</label>
							</td>
						</tr>
						<tr>
							<th class="textL">인증번호</th>
							<td class="form">
								<input type="text" id="issueWayNo" name="issueWayNo"><span class="popup_text_info">휴대폰번호 or 사업자번호('-'없이 입력 해주세요)</span>
							</td>
						</tr>
						<tr>
							<th class="textL">주문자명</th>
							<td class="form">
								<input type="text" id="applicantNm" name="applicantNm" value="${order_info.orderInfoVO.ordrNm}" readonly="readonly">
							</td>
						</tr>
						<tr>
							<th class="textL">이메일</th>
							<td class="form">
								<input type="text" id="cash_email01" style="width:124px;"> @ <input type="text" id="cash_email02" style="width:124px;">
								<div class="select_box28" style="display:inline-block">
									<label for="cash_email03"></label>
									<select class="select_option" id="cash_email03" title="select option">
										<option value="" selected="selected">- 이메일 선택 -</option>
										<option value="naver.com">naver.com</option>
										<option value="daum.net">daum.net</option>
										<option value="nate.com">nate.com</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="yahoo.com">yahoo.com</option>
										<option value="empas.com">empas.com</option>
										<option value="korea.com">korea.com</option>
										<option value="dreamwiz.com">dreamwiz.com</option>
										<option value="gmail.com">gmail.com</option>
										<option value="etc">직접입력</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th class="textL">전화번호</th>
							<td class="form">
								<input type="text" id="cashTelNo" name="cashTelNo"><span class="popup_text_info">('-'없이 입력 해주세요)</span>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_area">
					<button type="button" class="btn_mypage_ok" onclick="apply_cash_receipt();">발급신청</button>
					<button type="button" class="btn_mypage_cancel" onclick="close_cash_receipt_pop();">닫기</button>
				</div>
			</div>
		</div>
		<!---// popup 현금영수증 발급신청 --->
		<!--- popup 세금계산서 발급신청 --->
		<div class="popup_my_cash" id="popup_my_tax" style="display: none;height:inherit">
			<div class="popup_header">
				<h1 class="popup_tit">세금계산서 발급신청</h1>
				<button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
			</div>
			<div class="popup_content">
				<table class="tMypage_Board" style="margin-top:15px">
					<caption>
						<h1 class="blind">세금계산서 발급신청 폼 입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:110px">
						<col style="width:">
					</colgroup>
					<tbody>
						<tr>
							<th class="textL">발행용도</th>
							<td class="textL">
								<input type="radio" id="tax_Yes" name="my_tax" checked="checked">
								<label for="tax_yes" style="margin-right:44px">
									<span></span>
									과세 세금계산서
								</label>
								<input type="radio" id="tax_no" name="my_tax">
								<label for="tax_no">
									<span></span>
									비과세 세금계산서
								</label>
							</td>
						</tr>
						<tr>
							<th class="textL">상호명</th>
							<td class="form">
								<input type="text" id="companyNm" name="companyNm">
							</td>
						</tr>
						<tr>
							<th class="textL">사업자번호</th>
							<td class="form">
								<input type="text" id="bizNo" name="bizNo">
							</td>
						</tr>
						<tr>
							<th class="textL">대표자명</th>
							<td class="form">
								<input type="text" id="ceoNm" name="ceoNm">
							</td>
						</tr>
						<tr>
							<th class="textL">업태/업종</th>
							<td class="form">
								<input type="text" id="bsnsCdts" name="bsnsCdts"> / <input type="text" id="item" name="item">
							</td>
						</tr>
						<tr>
							<th class="textL" rowspan="4">주소</th>
							<td class="form">
								<input type="text" id="postNo" name="postNo" readonly="readonly"> <button type="button" class="btn_mypage_s03" id="btn_post">우편번호</button>
							</td>
						</tr>
						<tr>
							<td class="form">
								<span class="popup_text_info t_blank">(도로명)</span> <input type="text" id="roadnmAddr" name="roadnmAddr" class="t_input" readonly="readonly">
							</td>
						</tr>
						<tr>
							<td class="form">
								<span class="popup_text_info t_blank">(지번)</span> <input type="text" id="numAddr" name="numAddr" class="t_input" readonly="readonly">
							</td>
						</tr>
						<tr>
							<td class="form">
								<span class="popup_text_info t_blank">(상세주소)</span> <input type="text" id="dtlAddr" name="dtlAddr" class="t_input">
							</td>
						</tr>
						<tr>
							<th class="textL">담당자명</th>
							<td class="form">
								<input type="text" id="managerNm" name="managerNm">
							</td>
						</tr>
						<tr>
							<th class="textL">담당자이메일</th>
							<td class="form">
								<input type="text" id="tax_email01" style="width:124px;"> @ <input type="text" id="tax_email02" style="width:124px;">
								<div class="select_box28" style="display:inline-block">
									<label for="tax_email03"></label>
									<select class="select_option" id="tax_email03" title="select option">
										<option value="" selected="selected">- 이메일 선택 -</option>
										<option value="naver.com">naver.com</option>
										<option value="daum.net">daum.net</option>
										<option value="nate.com">nate.com</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="yahoo.com">yahoo.com</option>
										<option value="empas.com">empas.com</option>
										<option value="korea.com">korea.com</option>
										<option value="dreamwiz.com">dreamwiz.com</option>
										<option value="gmail.com">gmail.com</option>
										<option value="etc">직접입력</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th class="textL">전화번호</th>
							<td class="form">
								<input type="text" id="taxTelNo" name="taxTelNo">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_area">
					<button type="button" class="btn_mypage_ok" onclick="apply_tax_bill();">발급신청</button>
					<button type="button" class="btn_mypage_cancel" onclick="close_tax_bill_pop();">닫기</button>
				</div>
			</div>
		</div>
		<!---// popup 세금계산서 발급신청 --->
    </form>
    </div>
    <!---// 비회원 주문/배송조회 메인 --->
    </t:putAttribute>
</t:insertDefinition>