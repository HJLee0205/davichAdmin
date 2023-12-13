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
	<t:putAttribute name="title">다비치마켓 :: 환불/입금계좌관리</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){
        /* 환불계좌등록 팝업*/
        $('#insert_account').on('click', function() {
            var act_check = '${resultModel.data}';
            if(act_check == ''){
                $('#popup_tit').html('환불계좌 등록');
                Dmall.LayerPopupUtil.open($('#popup_bank_no_plus'));
            }else{
                Dmall.LayerUtil.alert('등록된 환불계좌가 있습니다.');
                return;
            }
        });

        /* 환불계좌수정 팝업*/
        $('#update_account').on('click', function() {
            $('#popup_tit').html('환불계좌 수정');
            Dmall.LayerPopupUtil.open($('#popup_bank_no_plus'));
        });
        /* 환불계좌 삭제*/
        $('#delete_account').on('click', function() {
            Dmall.LayerUtil.confirm('삭제하시겠습니까?', function() {
                var url = '${_MOBILE_PATH}/front/member/refund-account-delete';
                var param = '';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Dmall.LayerPopupUtil.close('popup_bank_no_plus');
                         location.href= "${_MOBILE_PATH}/front/member/refund-account";
                     }
                 });
               })
        });

        /* 계좌 저장(추가/수정) 실행*/
        $('.btn_popup_ok').on('click', function() {
            if(Dmall.validation.isEmpty($("#holderNm").val())){
                Dmall.LayerUtil.alert("예금주를 입력해주세요.");
                return;
            }

            if($("#bankCd option:selected").val() == ''){
                Dmall.LayerUtil.alert("은행명을 선택해주세요.");
                return;
            }

            if(Dmall.validation.isEmpty($("#actNo").val())){
                Dmall.LayerUtil.alert("계좌번호를 입력해주세요.");
                return;
            }
            var url = '${_MOBILE_PATH}/front/member/refund-account-update';
            var param = $('#modifyForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.LayerPopupUtil.close('popup_bank_no_plus');
                     location.href= "${_MOBILE_PATH}/front/member/refund-account";
                 }
            });
        });

        /* 계좌 저장팝업 닫기*/
        $('.btn_popup_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_bank_no_plus');
        });
    });
    
  	//숫자만 입력 가능 메소드
    function onlyNumDecimalInput(event){
        var code = window.event.keyCode;

        if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
            window.event.returnValue = true;
            return;
        }else{
            window.event.returnValue = false;
            return false;
        }
    }
  
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    
    <!--- 마이페이지 category header 메뉴 --->
    <%--<%@ include file="include/mypage_category_menu.jsp" %>--%>
    <!---// 마이페이지 category header 메뉴 --->

    <!--- 02.LAYOUT: 마이페이지 --->
	<div class="mypage_middle">	
        <div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			환불계좌관리
		</div>

			<!--- 마이페이지 오른쪽 컨텐츠 --->
			<div id="mypage_content">
            	<form:form id="form_id_search" commandName="so">
               	<form:hidden path="page" id="page" />
               	<form:hidden path="rows" id="rows" />
            	</form:form>

	        <!--- 마이페이지 탑 --->
            <%--<%@ include file="include/mypage_top_menu.jsp" %>--%>
    
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="my_shopping_view">
				<%--<h3 class="my_tit">환불계좌관리</h3>--%>
				
				<div class="order_cancel_info">
                    <button type="button" class="btn_order_history"  id="insert_account">계좌등록</button>
					<span class="icon_purpose" style="float: none;">지정하신 계좌로 주문취소/반품시 환불금액을 입금해 드립니다.</span>
				</div>

                <c:set var="resultModel" value="${resultModel.data}" />
                <table class="tCart_Board mybenefit">
                    <caption>
						<h1 class="blind">환불계좌관리 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
					</colgroup>
                    <thead>
                        <tr>
                            <th>예금주</th>
                            <th>은행명</th>
                            <th>계좌번호</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${!empty resultModel}">
                        <tr class="end_line">
                            <td>
                            	<em class="bank_name">${resultModel.holderNm}</em>
                            </td>
                            <td>${resultModel.bankNm}</td>
                            <td>${resultModel.actNo}</td>
                            <td>
                                <button type="button" class="btn_ship_modify" id="update_account">수정</button>
                                <button type="button" class="btn_ship_del marginT03" id="delete_account">삭제</button>
                            </td>
                        </tr>
                        </c:if>
                        <c:if test="${empty resultModel}">
                        <tr>
                            <td colspan="4">등록된 환불 계좌가 없습니다.</td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
                
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                
				<h4 class="my_stit marginT33">
					입금대기중인 주문 확인하세요~
					<%--<button type="button" class="btn_order_history">주문내역 전체보기</button>--%>
				</h4>
				
               <table class="tCart_Board Mypage mybenefit">
                    <caption>
						<h1 class="blind">입금대기중인 주문현황 목록입니다.</h1>
					</caption>
					<colgroup>
						<col style="width:20%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
						<col style="width:15%">
						<col>
					</colgroup>
                    <thead>
						<tr>
							<th>주문일자/주문번호</th>
							<th colspan="2">상품/옵션/수량</th>
							<th>입금대기금액</th>
							<th>입금기한</th>
							<th>입금하실 계좌</th>
						</tr>
					</thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null && fn:length(resultListModel.resultList) gt 0}">
                        <c:forEach var="resultList" items="${resultListModel.resultList}" varStatus="status">
                        <c:if test="${resultList.addOptYn eq 'N'}">
                        <tr class="<c:if test="${status.index > 0 }">end_line</c:if>">
                            <c:if test="${ordNo ne resultList.ordNo}">
                            <td class="textL">
                            	<span class="order_date">${fn:substring(resultList.ordAcceptDttm, 0, 10)}</span>
                            	<a href="#" class="order_no">[${resultList.ordNo}]</a>
								<button type="button" class="btn_order_detail" onclick="move_order_detail('${resultList.ordNo}');">주문상세내역</button>
                            </td>
                            </c:if>
                            <td class="noline">
                            	<div class="cart_img">
                                	<img src="${_IMAGE_DOMAIN}${resultList.goodsDispImgC}">
                                </div>
                            </td>
							<td class="textL vaT">
								<a href="#">${resultList.goodsNm}</a>
								<c:if test="${resultList.itemNm ne null}">
								<p class="option">${resultList.itemNm}</p>
								</c:if>
								<p class="option_s">${resultList.addOptNm}</p>
                            </td>
                            <td>
								<span class="price"><fmt:formatNumber value="${resultList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></span>원
							</td>
							<td>
								<fmt:parseDate var="dpstScdDt" pattern="yyyyMMddHHmmss" value="${resultList.dpstScdDt}"/>
								<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${dpstScdDt}"/><br>(0일 남음)
							</td>
							<td>
								<em class="mall_name02">다비치마켓</em>
								${resultList.bankNm}
								<p>${resultList.actNo}</p>
							</td>
                        </tr>
                        </c:if>
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
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    <!--- popup 계좌 추가 --->
    <div id="popup_bank_no_plus" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit" id="popup_tit"></h1>
            <button type="button" class="btn_close_popup"><img src="${_MOBILE_PATH}/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form action="${_MOBILE_PATH}/front/customer/refund-account-update" id="modifyForm" >
            <table class="tProduct_Insert" style="margin-top:5px">
                <caption>
                    <h1 class="blind">배송지 추가/수정 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">예금주</th>
                        <td><input type="text" style="width:140px;" id="holderNm" name="holderNm" value="${resultModel.holderNm}"></td>
                    </tr>
                    <tr>
                        <th class="order_tit">은행명</th>
                        <td>
                            <select name="bankCd" id="bankCd">
                                <code:option codeGrp="BANK_CD" includeTotal="true" value="${resultModel.bankCd}" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">계좌번호</th>
                        <td><input type="text" id="actNo" name="actNo" value="${resultModel.actNo}" onKeydown="return onlyNumDecimalInput(event);"></td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok">저장</button>
                <button type="button" class="btn_popup_cancel">닫기</button>
            </div>
        </div>
    </div>
    <!---// popup 계좌 추가 --->
    </t:putAttribute>
</t:insertDefinition>