<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<div id="utility_menu">
    <div class="utility_menu_layout">
        <ul class="utility_menu_list">
            <li class="utility_menu_favorite"><a href="javascript:add_favorite();">FAVORITE</a></li>
            <sec:authorize access="!hasRole('ROLE_USER')">
            <li><a href="${_DMALL_HTTPS_SERVER_URL}/front/login/member-login">LOGIN</a></li>
            <li><a href="${_DMALL_HTTPS_SERVER_URL}/front/member/terms-apply">JOIN</a></li>
            </sec:authorize>
            <sec:authorize access="hasRole('ROLE_USER')">
            <li id="a_id_logout"><a href="#none">LOGOUT</a></li>
            </sec:authorize>
            <li id="move_cart"><a href="#none">CART</a></li>
            <li id="move_order"><a href="#none">ORDER/DELIVERY</a></li>
            <li id="move_mypage"><a href="#none">MYPAGE</a></li>
            <li><a href="/front/customer/customer-main">CUSTOMER</a></li>
        </ul>
    </div>
</div>
