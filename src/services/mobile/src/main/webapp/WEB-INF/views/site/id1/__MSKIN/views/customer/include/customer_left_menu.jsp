<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 고객센터 왼쪽 메뉴 --->
<input type="hidden" id="hiddenUserId" value="${user.session.memberNo}"/>
<div class="customer_side_area">
    <ul class="customer_side">
        <li><a href="javascript:move_page('faq');" <c:if test="${leftMenu eq 'faq'}" >class="selected"</c:if>>자주묻는 질문</a></li>
        <li><a href="javascript:move_page('notice');" <c:if test="${leftMenu eq 'notice'}" >class="selected"</c:if>>공지사항</a></li>
        <li><a href="javascript:move_page('inquiry');" <c:if test="${leftMenu eq 'inquiry'}" >class="selected"</c:if>>1:1 문의</a></li>
    </ul>
    <ul class="customer_side_info">
        <li>
            <span class="side_info_tit">CUSTOMER CENTER</span>
            <span class="side_info_tel">1544-1544</span>
            평일 : 오전 9시 ~ 오후 6시<br>
            주말, 공휴일 : 휴무
        </li>
        <li>
            <span class="side_info_tit">BANK INFO</span><br>
            예금주 : 이동준<br>
            신한 : 000-0000-00<br>
            기업 : 123-1234-15
        </li>
    </ul>
</div>
<!---// 고객센터 왼쪽 메뉴 --->