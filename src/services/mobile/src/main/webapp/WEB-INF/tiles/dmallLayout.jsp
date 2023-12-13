<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title><t:insertAttribute name="title" ignore="true" defaultValue="${site_info.siteNm}"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="shortcut icon" href="/m/resource/image/favicon/favicon.ico" type="image/x-icon" />
    <link rel="icon" href="/m/resource/image/favicon/favicon.ico" type="image/x-icon" />
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" CONTENT="0">
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <t:insertAttribute name="meta" ignore="true"></t:insertAttribute>
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
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
<body id="body">
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-K72KQL7" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->

    <div id="header">
        <!--- 01.LAYOUT:HEADER AREA --->
        <t:insertAttribute name="header" />
        <!---// 01.LAYOUT:HEADER AREA --->
        <!--- 02.LAYOUT:GNB --->
        <t:insertAttribute name="gnb" />
        <!---// 02.LAYOUT:GNB --->
    </div>

	<!--- 03.LAYOUT:CONTAINER --->
    <%--<div id="container">--%>
	<%--<div class="container o-wrapper" id="o-wrapper">--%>
		<!--- 04.LAYOUT:CONTENTS AREA --->
		<t:insertAttribute name="content" />
		<!---// 04.LAYOUT:CONTENTS AREA --->
	<%--</div>--%>
	<!---// 03.LAYOUT:CONTAINER --->

    <!--- 05.LAYOUT:FOOTER AREA --->
    <div id="footer">
        <t:insertAttribute name="footer" />
    </div>
    <!---// 05.LAYOUT:FOOTER AREA --->
	
	<!---// 00.LAYOUT: --->
</body>

<t:insertAttribute name="script" ignore="true"/>
</html>