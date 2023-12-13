<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><t:insertAttribute name="title" ignore="true" defaultValue="${site_info.siteNm}"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Expires" CONTENT="0">
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="_csrf" content="${_csrf.token}"/>
	<!-- default header name is X-CSRF-TOKEN -->
	<meta name="_csrf_header" content="${_csrf.headerName}"/>
	<t:insertAttribute name="meta" ignore="true"/>
	<t:insertAttribute name="common"/>
    <t:insertAttribute name="skinCommon" ignore="true"/>
	<t:insertAttribute name="style" ignore="true"/>
	<t:insertAttribute name="jsVar" />
	<t:insertAttribute name="script" ignore="true"/>
</head>
<c:set var="_block" value="" />
<c:if test="${_DMALL_SITE_INFO.mouseRclickUseYn eq 'Y'}">
	<c:set var="_block" value="${_block} oncontextmenu=\"return false\"" />
</c:if>
<c:if test="${_DMALL_SITE_INFO.dragCopyUseYn eq 'Y'}">
	<c:set var="_block" value="${_block} ondragstart=\"return false\" onselectstart=\"return false\"" />
</c:if>
<body${_block}>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-K72KQL7" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
	<t:insertAttribute name="content"/>
</body>
</html>




