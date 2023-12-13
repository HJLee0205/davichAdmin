<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- 마이페이지 왼쪽 메뉴 --->
<script>
$(document).ready(function(){
    $(".selected").parents('li').parents('ul').parents('li').find('a').eq(0).addClass('selected');
});

function order_list(no, ordrMobile){
    Dmall.FormUtil.submit('/front/order/nomember-order-list', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile});
}
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
                <li><a href="javascript:order_list('${so.ordNo}', '${so.nonOrdrMobile}');" <c:if test="${leftMenu eq 'order'}" >class="selected"</c:if>>- 주문/배송조회</a></li>
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
<!---// 비회원 주문/배송조회 왼쪽 메뉴 --->