<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--- 00.LAYOUT: HEADER AREA --->
<div id="head">
    <%@ include file="header/utility_menu.jsp" %>
    <div class="logo_area">
        <div class="logo_area_layout">
            <%@ include file="header/logo.jsp"%>
            <%@ include file="header/search.jsp"%>
            <%@ include file="header/top_menu.jsp"%>
        </div>
    </div>
    <div id="gnb">
        <%@ include file="header/gnb.jsp"%>
    </div>
</div>
<!---// 00.LAYOUT: HEADER AREA --->