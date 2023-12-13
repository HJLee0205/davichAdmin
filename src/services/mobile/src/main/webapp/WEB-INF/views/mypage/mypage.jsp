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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">마이페이지</t:putAttribute>
	
	
	
	
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
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
				<span class="icon_level"></span>회원등급 : ${user.session.memberGradeNm}
			</li>
			<li class="myname">${user.session.memberNm}</li>
		</ul>
		<ul class="mymenu_list">
			<li>
				<a href="${_MOBILE_PATH}/front/order/order-list">
					<span class="icon_mymenu01"></span>
					주문/배송조회
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/member/savedmoney-list">
					<span class="icon_mymenu02"></span>
					보유 마켓포인트
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/basket/basket-list">
					<span class="icon_mymenu03"></span>
					장바구니
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/interest/interest-item-list">
					<span class="icon_mymenu04"></span>
					관심상품
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/question/question-list">
					<span class="icon_mymenu05"></span>
					상품 문의
				</a>
			</li>
			<li>
				<a href="${_MOBILE_PATH}/front/customer/inquiry-list">
					<span class="icon_mymenu06"></span>
					1:1문의&답변
				</a>
			</li>
		</ul>
		<div class="mypage_content">
			<h2 class="mypage_stit"><span>주문현황</span></h2>
			<ul class="shipment_steps">
				<li>
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
			<h2 class="mypage_stit"><span>취소/교환/반품</span></h2>
			<ul class="cancel_history">
				<li>
					<span>${order_cnt_info.data.cancleOrderCount}</span>
					취소
				</li>
				<li>
					<span>${order_cnt_info.data.exchangeOrderCount}</span>
					교환
				</li>
				<li>
					<span>${order_cnt_info.data.returnOrderCount}</span>
					반품
				</li>
			</ul>
			<h2 class="mypage_stit">
				<span>내 상품평</span>
				<span class="my_review_no">${my_review_info.filterdRows}</span>
			</h2>
			<h2 class="mypage_stit">
				<span>마이페이지 메뉴 전체보기</span>
			</h2>
			<div class="mypage_menu">
				<a href="${_MOBILE_PATH}/front/order/order-list">
					나의 쇼핑
					<span class="icon_mypage_s_menu"></span>
				</a>
			</div>
			<div class="mypage_menu">
				<a href="#1">
					나의 혜택
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>							
			<ul class="mypage_smenu">
				<li>
					<a href="${_MOBILE_PATH}/front/member/savedmoney-list">
						마켓포인트
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/member/point">
						다비치포인트
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
				<li>
					<a href="${_MOBILE_PATH}/front/coupon/coupon-list">
						보유한 쿠폰
						<span class="icon_mypage_s_menu"></span>
					</a>
				</li>
			</ul>
			<div class="mypage_menu">
				<a href="${_MOBILE_PATH}/front/interest/interest-item-list">
					나의관심상품
					<span class="icon_mypage_s_menu"></span>
				</a>
			</div>
			<div class="mypage_menu">
				<a href="#1">
					나의 활동
					<span class="icon_mypage_arrow"></span>
				</a>
			</div>
			<ul class="mypage_smenu">
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
		</div>
	</div>	
	<!---// 03.LAYOUT:CONTENTS --->
     
     
    </t:putAttribute>
</t:insertDefinition>