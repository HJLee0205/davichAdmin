<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');
});
</script>
<!--- 비회원 주문/배송조회 왼쪽 메뉴 --->
<div class="mypage_side_area">
    <div class="nonmember_on">
        <ul>
            <li>비회원 고객님</li>
        </ul>
    </div>
    <ul class="mypage_side" style="margin-bottom:438px">
        <li>
            <a href="" class="selected">나의 쇼핑</a>
            <ul class="mypage_side_s">
                <li><a href="/front/order/nomember-order-list" <c:if test="${leftMenu eq 'order'}" >class="selected"</c:if>>- 주문/배송조회</a></li>
            </ul>
        </li>
    </ul>
    <ul class="community_side_info">
        <li>
            <span class="side_info_tit">CUSTOMER CENTER</span>
            <span class="side_info_tel">${su.phoneNumber(site_info.custCtTelNo)}</span>
            상담시간 : ${site_info.custCtOperTime}<br>
            점심시간 : ${site_info.custCtLunchTime}<br>
            주말, 공휴일 : 휴무
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
<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->