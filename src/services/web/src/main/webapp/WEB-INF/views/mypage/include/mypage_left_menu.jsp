<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');

    $('.btn_mypaeg_info_modify').on('click', function() {
        location.href = '/front/member/information-update-form';
    });
});
</script>
<div class="mypage_side_area">
    <div class="mypage_on">
        <ul>
            <li>${user.session.memberNm}님</li>
            <li>${user.session.loginId}</li>
            <li class="member_level">회원님은 <span>[${user.session.memberGradeNm}]</span>회원이십니다.</li>
            <li class="textC"><button type="button" class="btn_mypaeg_info_modify">회원정보 수정</button></li>
        </ul>
    </div>
    <ul class="mypage_side">
        <li>
            <a href="/front/order/order-list">나의 쇼핑</a>
            <ul class="mypage_side_s">
                <li><a href="/front/order/order-list" <c:if test="${leftMenu eq 'order_list'}" >class="selected"</c:if>>- 주문/배송조회</a></li>
                <li><a href="/front/order/order-cancelrequest-list" <c:if test="${leftMenu eq 'order_cancel_request'}" >class="selected"</c:if>>- 주문취소/교환/환불접수</a></li>
                <li><a href="/front/order/order-cancel-list" <c:if test="${leftMenu eq 'order_cancel_list'}" >class="selected"</c:if>>- 주문취소/교환/환불내역</a></li>
            </ul>
        </li>
        <li>
            <a href="/front/member/savedmoney-list">나의 혜택</a>
            <ul class="mypage_side_s">
                <li><a href="/front/member/savedmoney-list" <c:if test="${leftMenu eq 'my_mileage'}" >class="selected"</c:if>>- 나의 마켓포인트</a></li>
                <li><a href="/front/member/point" <c:if test="${leftMenu eq 'my_point'}" >class="selected"</c:if>>- 나의 다비치포인트</a></li>
                <li><a href="/front/coupon/coupon-list" <c:if test="${leftMenu eq 'my_coupon'}" >class="selected"</c:if>>- 나의 쿠폰</a></li>
            </ul>
        </li>
        <li>
            <a href="/front/basket/basket-list">나의 관심상품</a>
            <ul class="mypage_side_s">
                <li><a href="/front/basket/basket-list" <c:if test="${leftMenu eq 'basket'}" >class="selected"</c:if>>- 장바구니</a></li>
                <li><a href="/front/interest/interest-item-list" <c:if test="${leftMenu eq 'interest'}" >class="selected"</c:if>>- 관심상품</a></li>
                <li><a href="/front/member/stock-alarm" <c:if test="${leftMenu eq 'goods_sms'}" >class="selected"</c:if>>- 재입고알림</a></li>
            </ul>
        </li>
        <li>
            <a href="/front/customer/inquiry-list">나의 활동</a>
            <ul class="mypage_side_s">
                <li><a href="/front/customer/inquiry-list" <c:if test="${leftMenu eq 'inquiry'}" >class="selected"</c:if>>- 1:1문의</a></li>
                <li><a href="/front/question/question-list" <c:if test="${leftMenu eq 'question'}" >class="selected"</c:if>>- 상품문의</a></li>
                <li><a href="/front/review/review-list" <c:if test="${leftMenu eq 'review'}" >class="selected"</c:if>>- 상품후기</a></li>
            </ul>
        </li>
        <li>
            <a href="/front/member/delivery-list">나의 정보</a>
            <ul class="mypage_side_s">
                <li><a href="/front/member/delivery-list" <c:if test="${leftMenu eq 'delivery'}" >class="selected"</c:if>>- 자주쓰는 배송지</a></li>
                <li><a href="/front/member/refund-account" <c:if test="${leftMenu eq 'refund_account'}" >class="selected"</c:if>>- 환불/입금계좌 관리</a></li>
                <li><a href="/front/member/information-update-form" <c:if test="${leftMenu eq 'modify_member'}" >class="selected"</c:if>>- 개인정보 수정</a></li>
                <li><a href="/front/member/member-leave-form" <c:if test="${leftMenu eq 'leave_member'}" >class="selected"</c:if>>- 회원탈퇴</a></li>
            </ul>
        </li>
    </ul>
    <ul class="community_side_info">
        <li>
            <c:if test="${(site_info.custCtTelNo ne null) and (site_info.custCtTelNo ne '')}">
                <span class="side_info_tit">CUSTOMER CENTER</span>
                <span class="side_info_tel">${site_info.custCtTelNo}</span>
            </c:if>
            <c:if test="${(site_info.custCtFaxNo ne null) and (site_info.custCtFaxNo ne '')}">
                <span class="side_info_tit">FAX</span>
                <span class="side_info_tel">${site_info.custCtFaxNo}</span>
            </c:if>
            <c:if test="${(site_info.custCtEmail ne null) and (site_info.custCtEmail ne '')}">
                <span class="side_info_tit">EMAIL</span>
                <span class="side_info_tel">${site_info.custCtEmail}</span>
            </c:if>

            <c:if test="${(site_info.custCtOperTime ne null) and (site_info.custCtOperTime ne '')}">
                    상담시간 : ${site_info.custCtOperTime}<br>
            </c:if>
            <c:if test="${(site_info.custCtLunchTime ne null) and (site_info.custCtLunchTime ne '')}">
                    점심시간 : ${site_info.custCtLunchTime}<br>
            </c:if>
            <c:if test="${(site_info.custCtClosedInfo ne null) and (site_info.custCtClosedInfo ne '')}">
                ${site_info.custCtClosedInfo}
            </c:if>
        </li>
        <li>
            <span class="side_info_tit">BANK INFO</span><br>
            예금주 : ${nopb_info[0].holder}<br>
            <c:forEach var="nopb_info" items="${nopb_info}" varStatus="status">
            ${nopb_info.bankNm} : ${nopb_info.actno}<br>
            </c:forEach>
        </li>
    </ul>
</div>
<!---// 마이페이지 왼쪽 메뉴 --->
