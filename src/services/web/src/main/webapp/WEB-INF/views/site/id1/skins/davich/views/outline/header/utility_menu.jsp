<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<script>
    jQuery(document).ready(function() {
        //장바구니 카운트 조회
        /*var url = '/front/member/quick-info';
        Dmall.AjaxUtil.getJSON(url, '', function (result) {
            if (result.success) {
                $("#move_cart .cart_won").html("("+result.data.basketCnt+")");//장바구니갯수
            }
        });*/
    });
</script>
<!--- util menu --->
<div class="util_area">
    <ul class="util_list">

        <sec:authorize access="!hasRole('ROLE_USER')">
            <li><a href="${_DMALL_HTTPS_SERVER_URL}/front/login/member-login">로그인</a></li>
            <li><a href="${_DMALL_HTTPS_SERVER_URL}/front/member/terms-apply">회원가입</a></li>
        </sec:authorize>
        <sec:authorize access="hasRole('ROLE_USER')">
            <li id="a_id_logout"><a href="#none">로그아웃</a></li>
        </sec:authorize>
        <li id="move_cart"><a href="javascript:;" class="cart">장바구니<em class="cart_won"></em></a></li>
        <li id="move_order"><a href="javascript:;">주문배송조회</a></li>
        <li id="move_mypage"><a href="javascript:;" class="mypage">마이페이지</a></li>
        <%--<li><a href="javascript:add_favorite();">FAVORITE</a></li>--%>
        <c:if test="${!empty site_info.eventNo}">
            <li><a href="javascript:viewAttendance()" class="visit_check"><i></i>출석체크</a></li>
        </c:if>

        <%--<li><a href="#">구매팁</a></li>--%>
        <%--<li><a href="#">최근본상품</a></li>--%>

        <%--<li><a href="/front/customer/customer-main">고객센터</a></li>--%>
    </ul>
</div>
<!---// util menu --->