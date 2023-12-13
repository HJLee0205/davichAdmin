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
	<t:putAttribute name="title">교환신청</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="style">
        <link href="${_MOBILE_PATH}/front/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
	<t:putAttribute name="script">  
	<script src="${_MOBILE_PATH}/front/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
    <script> 
  		//에디터
	    Dmall.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
	    Dmall.DaumEditor.create('claimDtlReason'); // claimDtlReason 를 ID로 가지는 Textarea를 에디터로 설정
	    $('.tx-resize-bar').hide();
    </script>
	</t:putAttribute>
	
	<t:putAttribute name="content">
	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">  
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			교환신청
		</div>
		<div class="my_order_no">
			주문번호 : ${so.ordNo}
		</div>
		
	   <form:form id="form_id_exchage" commandName="so">
		<input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
		   <input type="hidden" name="claimReasonCdArr" id="claimReasonCdArr" value=""/>
		   <input type="hidden" name="ordNoArr" id="ordNoArr" value=""/>
		   <input type="hidden" name="ordDtlSeqArr" id="ordDtlSeqArr" value=""/>
		   <input type="hidden" name="claimQttArr" id="claimQttArr" value=""/>
		<div class="myshopping_all_view_area">  
			<c:choose>
			<c:when test="${orderVO.orderGoodsVO ne null}">
			<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
				<c:if test="${goodsList.rsvOnlyYn ne 'Y'}">
			<c:if test="${goodsList.addOptYn eq 'N'}">
			<div class="my_order" data-ord-no="${goodsList.ordNo}"  data-ord-dtl-seq="${goodsList.ordDtlSeq}">
				<!-- <ul class="my_order_detail" style="border-top:none">
					<li>
						<span class="title">배송지</span>
						<p class="my_address_detail">
							(100-809) 서울특별시 중구 명동길 74-2 (명동2가) 123123
						</p>
					</li>
				</ul> -->
				<div class="checkbox cancel_order_check">
					<label for="itemNoArr_${status.index}">
						<input type="checkbox" name="itemNoArr" id="itemNoArr_${status.index}">
						<span></span>
					</label>
					<input type="hidden" name="itemNoArr" value="${goodsList.itemNo}"/>
				</div>
				<ul class="my_order_info_top cancel_order_list">
					<li class="my_order_product_pic">						 
						<c:if test="${empty goodsList.imgPath}">
						<img src="${_MOBILE_PATH}/front/img/product/cart_img01.gif">
						</c:if>
						<c:if test="${!empty goodsList.imgPath}">
						<img src="${goodsList.imgPath}">
						</c:if>
					</li>
					<li class="my_order_product_title">
						<a href="${_MOBILE_PATH}/front/goods/goods-detail?goodsNo=${goodsList.goodsNo}">${goodsList.goodsNm}</a>
						<ul class="my_order_info_text">
							<li>
								<span class="option_title_check">[옵션] ${goodsList.itemNm} / ${goodsList.ordQtt}개</span>
								<span class="option_price"><fmt:formatNumber value="${goodsList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span>
							</li>
							<c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
								<c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
								<li>
									<span class="option_title_check">
									[추가옵션] (${amtFlag})- ${addOptList.ordQtt}개]
									</span>
									<span class="option_price"><fmt:formatNumber value="${addOptList.saleAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</span>
								</li>
								</c:if>
							</c:forEach>
						</ul>
					</li>
				</ul>
				
				<ul class="my_order_detail">
					<li>
						<span class="title">배송비</span>
						<p class="detail">
							<fmt:formatNumber value="${goodsList.realDlvrAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
						</p>
					</li>
					<li>
						<span class="title">주문상태</span>
						<p class="detail">
							${goodsList.ordDtlStatusNm}
							
						</p>
					</li>
				</ul>
				<ul class="my_order_detail5">
					<li>
						<span class="title">결제금액</span>
						<p class="detail">
							<em><fmt:formatNumber value="${goodsList.payAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></em>원
						</p>
					</li>
					<li>
						<span class="title">교환사유</span>
						<p class="detail">
						<select class="select_option" title="select option" name="claimReasonCd_${status.index}" id="claimReasonCd_${status.index}">
							<code:optionUDV codeGrp="CLAIM_REASON_CD" usrDfn1Val="ALWAYS" />
						</select>
						</p>
					</li>
					<li>
						<span class="title">교환수량</span>
						<p class="detail">
						<c:choose>
							<c:when test="${goodsList.ordQtt > goodsList.claimQtt}">
								<c:set var="claimQtt" value="${goodsList.ordQtt-goodsList.claimQtt}"></c:set>
								<select class="select_option" name="claimQtt" id="claimQtt_${status.index}" style="width:80px;">
									<option value="">선택</option>
									<c:forEach begin="1" end="${claimQtt}" step="1" var="claimQtt">
										<option value="${claimQtt}">${claimQtt}</option>
									</c:forEach>
								</select>
							</c:when>
							<c:otherwise>
								0
							</c:otherwise>
						</c:choose>
						</p>
					</li>
					<li>
						<span class="title">반품주소</span>
						<p class="detail">
							<c:if test="${goodsList.retadrssPostNo ne null}">(${goodsList.retadrssPostNo})</c:if>${goodsList.retadrssAddr}&nbsp; &nbsp;${goodsList.retadrssDtlAddr}
						</p>
					</li>
				</ul>
			</div>
			</c:if>
				</c:if>
			</c:forEach>
			</c:when>
			<c:otherwise>
				<li>등록된 상품이 없습니다.</li>
			</c:otherwise>
			</c:choose>                
				   
			<%--<h2 class="my_stit">반품주소</h2>
			<div class="re_adress">
				(136 - 130) 서울특별시 성북구 하월곡동 228번지 꿈의숲푸르지오 104동 603호
				<h3>상세사유</h3>
				<textarea id="claimDtlReason" rows="5"></textarea>
			</div>--%>
			<h2 class="my_stit">상세사유</h2>
			<div class="re_adress">
				<textarea style="width:97.5%;height:128px" id="claimDtlReason" name="claimDtlReason" class="blind"></textarea>
			</div>
			
			<%--<ul class="my_order_detail">
				<li>
					<span class="title">상세사유</span>
					<p class="textarea">
						 <textarea id="claimDtlReason" rows="5"></textarea>
					</p>
				</li>
			</ul>--%>
			<div class="all_btn_cancel_area">
				<button type="button" class="btn_cancel_go" onclick="claim_exchange()">교환신청</button>
			</div>
		</div>  
	  </form:form>
	</div>  
	<!---// 03.LAYOUT:CONTENTS --->

	</t:putAttribute>
</t:insertDefinition>