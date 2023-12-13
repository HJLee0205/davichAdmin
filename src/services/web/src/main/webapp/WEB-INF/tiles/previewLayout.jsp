<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><t:insertAttribute name="title" ignore="true" defaultValue="DMALL"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="shortcut icon" href="/resource/image/favicon/favicon.ico" type="image/x-icon" />
	<link rel="icon" href="/resource/image/favicon/favicon.ico" type="image/x-icon" />
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" CONTENT="0">
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="_csrf" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta property="og:url" content="http://www.davichmarket.com">
    <meta property="og:title" content="${site_info.siteNm}">
    <meta property="og:type" content="website">
    <meta property="og:description" content="다비치 쇼핑몰">
    <meta property="og:image" content="">
	<t:insertAttribute name="meta" ignore="true"/>
	<t:insertAttribute name="common"/>
	<t:insertAttribute name="skinCommon" ignore="true"/>
	<t:insertAttribute name="style" ignore="true"/>
	<t:insertAttribute name="jsVar" />
</head>
<c:set var="_block" value="" />
<c:if test="${_DMALL_SITE_INFO.mouseRclickUseYn eq 'N'}">
	<c:set var="_block" value="${_block} oncontextmenu=\"return false\"" />
</c:if>
<c:if test="${_DMALL_SITE_INFO.dragCopyUseYn eq 'N'}">
	<c:set var="_block" value="${_block} ondragstart=\"return false\" onselectstart=\"return false\"" />
</c:if>
<body${_block}>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-K72KQL7" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<!--- 00.LAYOUT: --->
<div id="wrap">
<%-- 	<t:insertAttribute name="header" /> --%>
	<!--- 04.LAYOUT: MIDDLE AREA --->
	<!--- side/content area --->
	<div id="main_container">
		<t:insertAttribute name="content" />
	</div>
	<!---// side/content area --->
	<!---// 04.LAYOUT: MIDDLE AREA --->
<%-- 	<t:insertAttribute name="footer" /> --%>
</div>
<!---// 00.LAYOUT: --->
</body>
<t:insertAttribute name="script" ignore="true"/>
</html>