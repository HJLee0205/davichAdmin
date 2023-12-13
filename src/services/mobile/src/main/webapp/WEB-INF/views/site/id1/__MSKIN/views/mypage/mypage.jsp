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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
	<t:putAttribute name="title">마이페이지</t:putAttribute>
	<sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    
    var integration = "${user.session.integrationMemberGbCd}";
    
    $(document).ready(function(){

        $("#btn_modify_delivery").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/member/delivery-list";
        });
        $("#btn_modify_email").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/member/information-update-form";
        });
        $("#btn_modify_mobile").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/member/information-update-form";
        });
        $(".my_point01").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/member/savedmoney-list";
        });
        $(".my_point02").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/member/point";
        });
        $(".my_point03").on('click', function() {
            location.href ="${_MOBILE_PATH}/front/coupon/coupon-list";
        });
    });
    
    function fn_go_point(){
    	if(integration == '03'){
    		location.href = "${_MOBILE_PATH}/front/member/point";
    	}
    	else if(integration == '01'){
    		Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
                location.href="${_MOBILE_PATH}/front/member/member-integration-form";
            });
            
    	}
    	else if(integration == '02'){
    		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
                location.href="${_MOBILE_PATH}/front/member/information-update-form";
            });
    	}
    }
    
    function fn_go_yearend_tax(){
    	if(integration == '03'){
    		location.href = "${_MOBILE_PATH}/front/member/yearend-taxList";
    	}
    	else if(integration == '01'){
    		Dmall.LayerUtil.confirm('통합멤버쉽 회원만 이용하실 수 있습니다.<br>지금 멤버쉽 통합절차를 진행할까요?', function() {
                location.href="${_MOBILE_PATH}/front/member/member-integration-form";
            });
            
    	}
    	else if(integration == '02'){
    		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
                location.href="${_MOBILE_PATH}/front/member/information-update-form";
            });
    	}
    }
    
    function fn_go_offlineSal(){
    	if(integration == '03'){
    		location.href = "${_MOBILE_PATH}/front/member/offline_sal";
    	}
    	else if(integration == '01'){
    		Dmall.LayerUtil.confirm('멤버쉽통합 회원이 아닙니다.<br>멤버쉽통합을 진행하시겠습니까?', function() {
                location.href="${_MOBILE_PATH}/front/member/member-integration-form";
            });
            
    	}
    	else if(integration == '02'){
    		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
                location.href="${_MOBILE_PATH}/front/member/information-update-form";
            });
    	}
    }

    function fn_go_integration(){
    	if(integration == '01'){
    		location.href = "${_MOBILE_PATH}/front/member/member-integration-form";
    	}
    	else if(integration == '02'){
    		Dmall.LayerUtil.confirm('간편로그인 회원입니다.<br>정회원 전환을 진행하시겠습니까?', function() {
                location.href="${_MOBILE_PATH}/front/member/information-update-form";
            });
    	}
    	else if(integration == '03'){
    		Dmall.LayerUtil.alert('이미 멤버쉽 통합이 완료되었습니다.','','');
    	}
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
     
   	<!--- 03.LAYOUT:CONTENTS --->
	<div id="middle_area">	
		<div class="mypage_head">
			<button type="button" class="btn_go_prev"><span class="icon_go_prev"></span></button>
			마이페이지
		</div>
		<ul class="mypage_info">
			<li class="mylevel">
				<span class="icon_level"></span>${user.session.memberGradeNm}
			</li>
			<li class="myname">${user.session.memberNm}
				<c:choose>
					<c:when test="${user.session.integrationMemberGbCd eq '01'}"><span class="member_type">정회원</span></c:when>
					<c:when test="${user.session.integrationMemberGbCd eq '02'}"><span class="member_type">간편회원</span></c:when>
					<c:when test="${user.session.integrationMemberGbCd eq '03'}"><span class="member_type">통합멤버쉽</span></c:when>
				</c:choose>
			</li>
		</ul>
		<ul class="mymenu_list">
			
			<li>
				<a href="${_MOBILE_PATH}/front/order/order-list">
					<span class="icon_mymenu01"></span>
					주문/배송
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/basket/basket-list">
					<span class="icon_mymenu03"></span>
					장바구니
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/coupon/coupon-list">
					<span class="icon_mymenu07"></span>
					쿠폰
				</a>
			</li>
			<li>
				<%--<a href="${_MOBILE_PATH}/front/member/savedmoney-list">--%>
				<a href="javascript:fn_go_point();">
					<span class="icon_mymenu02"></span>
					다비치포인트
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/question/question-list">
					<span class="icon_mymenu05"></span>
					상품 문의
				</a>
			</li>
			
			<!-- <li>
				<a href="${_MOBILE_PATH}/front/interest/interest-item-list">
					<span class="icon_mymenu04"></span>
					관심상품
				</a>
			</li> -->
			
			<!-- <li>
				<a href="${_MOBILE_PATH}/front/customer/inquiry-list">
					<span class="icon_mymenu06"></span>
					1:1문의
				</a>
			</li> -->
		</ul>
		<div class="mypage_content">
			<h2 class="mypage_stit2"><span>주문현황</span></h2>
			<ul class="shipment_steps">
				<li onClick="location.href='${_MOBILE_PATH}/front/order/order-list'">
					<span>${order_cnt_info.data.receiveOrderCount}</span>
					주문접수
				</li>
				<li>
					<span>${order_cnt_info.data.prepareOrderCount}</span>
					상품준비중
				</li>
				<li>
					<span>${order_cnt_info.data.deliveryOrderCount}</span>
					배송중
				</li>
				<li>
					<span>${order_cnt_info.data.completeOrderCount}</span>
					배송완료
				</li>
			</ul>

			<div class="cancel_history">
				<div class="cancel_box">
					<span class="ch_label">취소</span><span class="ch_count">${order_cnt_info.data.cancleOrderCount}</span>
				</div>
				<div class="cancel_box">
					<span class="ch_label">교환</span><span class="ch_count">${order_cnt_info.data.exchangeOrderCount}</span>
				</div>
				<div class="cancel_box">
					<span class="ch_label">반품</span><span class="ch_count">${order_cnt_info.data.returnOrderCount}</span>
				</div>
			</div>
			<!-- <h2 class="mypage_stit">
				<span>내 상품평</span>
				<span class="my_review_no">${my_review_info.filterdRows}</span>
			</h2> -->
			<h2 class="mypage_stit">
				<span>마이페이지 전체메뉴</span>
			</h2>
			<div class="mypage_menu">
				<a href="${_MOBILE_PATH}/front/order/order-list">
					나의 주문
					<span class="icon_mypage_s_menu"></span>
				</a>
			</div>
			<c:if test="${user.session.integrationMemberGbCd ne '02'}">
			<div class="mypage_menu">
				<a href="#1">
					나의 혜택
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>							
			<ul class="mypage_smenu">
				<li>
					<a href="${_MOBILE_PATH}/front/coupon/coupon-list">
						쿠폰
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<%--<li>
					<a href="${_MOBILE_PATH}/front/member/savedmoney-list">
						마켓포인트
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>--%>
				<li>
					<a href="javascript:fn_go_point();">
						다비치포인트
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
			</ul>
			</c:if>
			<div class="mypage_menu">
				<a href="#1">
					나의 활동
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>
			<ul class="mypage_smenu">
				<li>
					<a href="${_MOBILE_PATH}/front/interest/interest-item-list">
						관심상품
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/customer/inquiry-list">
					   1:1문의
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>
                <li>
                    <a href="${_MOBILE_PATH}/front/question/question-list">
                    상품문의
                    <span class="icon_mypage_s_menu"></span>
                    </a>
                </li>
                <li>
                    <a href="${_MOBILE_PATH}/front/review/review-list">
                    상품후기
                    <span class="icon_mypage_s_menu"></span>
                    </a>
                </li>
				
			</ul>
			<c:if test="${user.session.integrationMemberGbCd ne '02'}">
			<div class="mypage_menu">
				<a href="#1">
					나의 다비치
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>
			</c:if>
			<ul class="mypage_smenu">
				<c:if test="${user.session.integrationMemberGbCd ne '02'}">
				<%--<li>
					<a href="${_MOBILE_PATH}/front/mypage/eyesight">
					   시력정보
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/mypage/prescription">
					   처방전
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>--%>
				<li>
					<a href="${_MOBILE_PATH}/front/vision2/my-vision-check-g">
					<%-- <a href="${_MOBILE_PATH}/front/vision2/my-vision-check-g"> --%>
					   추천렌즈
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<%--<li>
					<a href="${_MOBILE_PATH}/front/hearingaid/my-hearingaid-check">
					   보청기 추천
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>--%>
				<li>
					<a href="${_MOBILE_PATH}/front/visit/visit-list">
					    방문예약 내역
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<%--<li>
					<a href="javascript:fn_go_offlineSal();">
						가맹점 구매내역
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>--%>
				<li>
					<a href="javascript:fn_go_integration();">
						멤버쉽통합
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="javascript:fn_go_yearend_tax();" >
						연말정산
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				</c:if>
				<c:if test="${user.session.integrationMemberGbCd eq '03'}">
				<li>
					<a href="${_MOBILE_PATH}/front/member/bibiem-warranty-list" >
						비비엠 워런티 카드
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				</c:if>
			</ul>

			<div class="mypage_menu">
				<a href="#1">
					나의 정보관리
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>
			<ul class="mypage_smenu">
				<li>
					<a href="${_MOBILE_PATH}/front/member/information-update-form">
					   회원정보수정
					   <span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/member/member-leave-form">
						회원탈퇴
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<c:if test="${user.session.integrationMemberGbCd ne '02'}">
				<li>
					<a href="${_MOBILE_PATH}/front/member/member-certify-form">
						휴대폰 인증
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				</c:if>
				<li>
					<a href="${_MOBILE_PATH}/front/member/delivery-list">
						배송지관리
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/member/refund-account">
						환불/입금계좌관리
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/member/push-message-market">
						메세지함(마켓)
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/member/push-message">
						메세지함(매장)
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
			</ul>
		</div>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
     
     
    </t:putAttribute>
</t:insertDefinition>