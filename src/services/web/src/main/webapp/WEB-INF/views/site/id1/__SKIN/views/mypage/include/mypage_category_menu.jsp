<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
});
</script>

	<!--- category header --->
	<div id="category_header">
		<div id="category_location">
			<ul class="category_menu">
				<li><a href="/front/main-view">홈</a></li>
				<li>
					마이페이지
				</li>
				
				<c:choose>
					<c:when test="${leftMenu eq 'order_list'}">
						<li>나의 주문</li>
						<li>주문배송조회</li>
					</c:when>
					<c:when test="${leftMenu eq 'order_cancel_request'}">
						<li>나의 주문</li>
						<li>취소/교환/반품 신청</li>
					</c:when>
					<c:when test="${leftMenu eq 'order_cancel_list'}">
						<li>나의 주문</li>
						<li>취소/교환/반품 현황</li>
					</c:when>
					
					<c:when test="${leftMenu eq 'my_coupon'}">
						<li>나의 혜택</li>
						<li>D-쿠폰</li>
					</c:when>
					<c:when test="${leftMenu eq 'my_mileage'}">
						<li>나의 혜택</li>
						<li>마켓포인트</li>
					</c:when>
					<c:when test="${leftMenu eq 'my_point'}">
						<li>나의 혜택</li>
						<li>다비치포인트</li>
					</c:when>
					
					<c:when test="${leftMenu eq 'interest'}">
						<li>나의 활동</li>
						<li>관심상품</li>
					</c:when>
					<c:when test="${leftMenu eq 'goods_sms'}">
						<li>나의 활동</li>
						<li>재입고알림</li>
					</c:when>
					<c:when test="${leftMenu eq 'inquiry'}">
						<li>나의 활동</li>
						<li>문의/후기</li>
					</c:when>
					
					<c:when test="${leftMenu eq 'eyesight'}">
						<li>나의 다비치</li>
						<li>시력정보</li>
					</c:when>
					<c:when test="${leftMenu eq 'prescription'}">
						<li>나의 다비치</li>
						<li>처방전</li>
					</c:when>
					<c:when test="${leftMenu eq 'my-vision-check'}">
						<li>나의 다비치</li>
						<li>비젼체크</li>
					</c:when>
					<c:when test="${leftMenu eq 'visit_list'}">
						<li>나의 다비치</li>
						<li>방문예약</li>
					</c:when>
					<c:when test="${leftMenu eq 'integration_member'}">
						<li>나의 다비치</li>
						<li>멤버쉽통합</li>
					</c:when>
					
					<c:when test="${leftMenu eq 'modify_member'}">
						<li>나의 정보관리</li>
						<li>회원정보수정</li>
					</c:when>
					<c:when test="${leftMenu eq 'delivery'}">
						<li>나의 정보관리</li>
						<li>배송지관리</li>
					</c:when>
					<c:when test="${leftMenu eq 'refund_account'}">
						<li>나의 정보관리</li>
						<li>환불/입금계좌관리</li>
					</c:when>
					<c:when test="${leftMenu eq 'leave_member'}">
						<li>나의 정보관리</li>
						<li>회원탈퇴</li>
					</c:when>
					<c:when test="${leftMenu eq 'bibiem_warranty'}">
						<li>나의 다비치</li>
						<li>비비엠 워런티 카드</li>
					</c:when>
					<c:otherwise>
					
					
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
    </div>
	<!---// category header --->    

