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
	<t:putAttribute name="title">환불/입금계좌관리</t:putAttribute>
	
	
	
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
                var url = '/front/member/refund-account-delete';
                var param = '';
                Dmall.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Dmall.LayerPopupUtil.close('popup_bank_no_plus');
                         location.href= "/front/member/refund-account";
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
            var url = '/front/member/refund-account-update';
            var param = $('#modifyForm').serialize();
            Dmall.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Dmall.LayerPopupUtil.close('popup_bank_no_plus');
                     location.href= "/front/member/refund-account";
                 }
            });
        });

        /* 계좌 저장팝업 닫기*/
        $('.btn_popup_cancel').on('click', function() {
            Dmall.LayerPopupUtil.close('popup_bank_no_plus');
        });
    });
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="">이전페이지</a><span class="location_bar"></span><a href="">HOME</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 정보 <span>&gt;</span>환불/입금계좌관리
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    환불/입금계좌관리
                    <span class="row_info_text">주문취소/반품 진행 시 정확한 환불을 위해 입금 받고자 하는 계좌를 관리하실 수 있습니다.</span>
                </h3>
                <div class="floatC">
                    <span class="floatL" style="margin-top:15px;">* 환불계좌는 계정당 한 건만 등록 가능합니다.</span>
                    <button type="button" class="btn_mypage_ok floatR" style="margin-bottom:5px;" id="insert_account">계좌등록</button>
                </div>
                <c:set var="resultModel" value="${resultModel.data}" />
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">환불/입금계좌 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:150px">
                        <col style="width:150px">
                        <col style="width:">
                        <col style="width:150px">
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
                        <tr>
                            <td>${resultModel.holderNm}</td>
                            <td>${resultModel.bankNm}</td>
                            <td>${resultModel.actNo}</td>
                            <td>
                                <button type="button" class="btn_mypage_s03" id="update_account">수정</button>
                                <button type="button" class="btn_mypage_s03" id="delete_account">삭제</button>
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

                <div class="bank_info_box">
                    <h4 class="bank_info_box_title">무통장 입금 계좌 목록</h4>
                    <ul>
                        <li>무통장입금 계좌는 고객님 한 분마다 부여되는 개인계좌로서, 부여 받으신 계좌번호로 PC뱅킹, 타행환, 계좌이체 등을 통해 자유롭게 입금하실 수 있습니다. </li>
                        <li>무통장입금(가상계좌)으로 주문하신 경우, 주문 시 선택하신 입금계좌를 확인 후 입금하세요! </li>
                    </ul>
                </div>
                <span>- 입금 대기 주문이 ${orderList.filterdRows}건 있습니다.</span>
                <table class="tMypage_Board" style="margin-top:5px;">
                    <caption>
                        <h1 class="blind">입금 대기 주문 목록 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:110px">
                        <col style="width:68px">
                        <col style="width:">
                        <col style="width:100px">
                        <col style="width:120px">
                        <col style="width:90px">
                        <col style="width:110px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문일자<br>[주문번호]</th>
                            <th colspan="2">주문상품정보</th>
                            <th>입금대기 금액</th>
                            <th>입금기한</th>
                            <th>입금은행</th>
                            <th>계좌번호</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${orderList.resultList ne null && fn:length(orderList.resultList) gt 0}">
                        <c:forEach var="resultList" items="${orderList.resultList}" varStatus="status">
                        <tr>
                            <td class="text11">
                                2016-03-21
                                [AB20160321001]
                            </td>
                            <td>
                                <img src="/front/img/product/cart_img01.gif">
                            </td>
                            <td class="textL">
                                BL7827/시스루패턴 하이넥블라우스
                            </td>
                            <td>16,000원</td>
                            <td><span class="fRed">2014.06.30까지</span></td>
                            <td>국민은행</td>
                            <td>123456-12-001</td>
                        </tr>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${orderList}" />
                </div>
                <!----// 페이징 ---->

            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    <!--- popup 계좌 추가 --->
    <div id="popup_bank_no_plus" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit" id="popup_tit"></h1>
            <button type="button" class="btn_close_popup"><img src="/front/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form action="/front/customer/refund-account-update" id="modifyForm" >
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
                        <td><input type="text" style="width:232px;" id="holderNm" name="holderNm" value="${resultModel.holderNm}"></td>
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
                        <td><input type="text" style="width:232px;" name="actNo" value="${resultModel.actNo}"></td>
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