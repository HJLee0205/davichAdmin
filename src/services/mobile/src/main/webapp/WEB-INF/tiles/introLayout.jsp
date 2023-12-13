<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
     response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
 %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title><t:insertAttribute name="title" ignore="true" defaultValue="${site_info.siteNm}"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="shortcut icon" href="/m/resource/image/favicon/favicon.ico" type="image/x-icon" />
    <link rel="icon" href="/m/resource/image/favicon/favicon.ico" type="image/x-icon" />
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" CONTENT="-1">
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <t:insertAttribute name="meta" ignore="true"></t:insertAttribute>
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>

    <t:insertAttribute name="common"/>
    <t:putAttribute name="skinCommon" value="/WEB-INF/views/site/${_SKIN_PATH}/include/skinCommon.jsp" />
    <t:putAttribute name="gnb" value="/WEB-INF/views/site/${_SKIN_PATH}/include/gnb.jsp" />
    <t:putAttribute name="header" value="/WEB-INF/views/site/${_SKIN_PATH}/include/header.jsp" />
    <t:putAttribute name="footer" value="/WEB-INF/views/site/${_SKIN_PATH}/include/footer.jsp" />
    <t:insertAttribute name="skinCommon" />
    <t:insertAttribute name="style" ignore="true"/>
    <t:insertAttribute name="jsVar" />
</head>
 

<c:set var="_block" value="" />
<%-- <c:if test="${_DMALL_SITE_INFO.mouseRclickUseYn eq 'N'}">
	<c:set var="_block" value="${_block} oncontextmenu=\"return false\"" />
</c:if>
<c:if test="${_DMALL_SITE_INFO.dragCopyUseYn eq 'N'}">
	<c:set var="_block" value="${_block} ondragstart=\"return false\" onselectstart=\"return false\"" />
</c:if> --%>
<!--- 00.LAYOUT:BODY --->

<body id="body" class="intro">
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-K72KQL7" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

	<!--- 01.LAYOUT:GNB --->
	<t:insertAttribute name="gnb" />
	<!---// 01.LAYOUT:GNB --->
	
	<!--- 02.LAYOUT:CONTAINER --->
	<div id="intro_header">
		<!--- logo --->
		<h1 class="logo"><a href="${_MOBILE_PATH}/front/main-view"><img src="${_SKIN_IMG_PATH}/header/logo.png" alt="LOGO"></a></h1>
		<!---// logo --->
		<sec:authentication var="user" property='details'/>
		<sec:authorize access="!hasRole('ROLE_USER')">
		<a href="${_DMALL_HTTPS_SERVER_URL}${_MOBILE_PATH}/front/login/member-login" class="btn_login">로그인</a>
		</sec:authorize>
	</div>
		<!---// 03.LAYOUT:HEADER AREA --->
		
		<!--- 04.LAYOUT:CONTENTS AREA --->
		<t:insertAttribute name="content" />
		<!---// 04.LAYOUT:CONTENTS AREA --->
	<!---// 02.LAYOUT:CONTAINER --->
	
	<!---// 00.LAYOUT: --->
</body>

<t:insertAttribute name="script" ignore="true"/>
</html>