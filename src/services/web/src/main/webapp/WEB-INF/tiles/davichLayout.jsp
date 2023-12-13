<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
 %>
<%--  LOG corp Web Analitics & Live Chat  START --%>
<%!
private void logCorpSendXML(HttpServletRequest req, HttpServletResponse res, HttpSession sess) {
	StringBuffer sessId = new StringBuffer();
	String queryString = req.getQueryString();
	String referer = null;

	if(queryString != null && queryString.length() > 0) {
		queryString = "?" + queryString;
	}else{
		queryString = "";
	}

	try{
		referer = java.net.URLEncoder.encode(req.getHeader("referer"));
	}catch(Exception e){
	e.printStackTrace();
	}


	java.security.MessageDigest md = null;
	try{
		md = java.security.MessageDigest.getInstance("MD5");
	}catch(java.security.NoSuchAlgorithmException e) {
	e.printStackTrace();
	}
	if(md != null) {
		md.update(sess.getId().getBytes());

		byte digest[] = md.digest();

		for(int i=0; i < digest.length; i++) {
			sessId.append(Integer.toHexString(0xFF & digest[i]));
		}
	}

	StringBuffer now = new StringBuffer();
	try{
		java.util.Calendar c = java.util.Calendar.getInstance();
		now.append(c.get(c.YEAR));
		int month = c.get(c.MONTH) + 1;
		int date = c.get(c.DATE);
		if(month < 10) {
			now.append("0");
		}
		now.append(month);
		if(date < 10) {
			now.append("0");
		}
		now.append(date);
		now.append(Long.toString(c.getTimeInMillis()).substring(5, 12));
	}catch(Exception e) {
	e.printStackTrace();
	}

	String logsrid = "";
	Cookie cookies[] = req.getCookies();
	try{
		for(int i=0; i < cookies.length; i++) {
			if(cookies[i].getName().equals("logsrid")) {
				logsrid = cookies[i].getValue();
			}
		}
	}catch(Exception e) {
	e.printStackTrace();
	}

	if(logsrid.length() < 1) {
		logsrid = sessId.toString().substring(0,26) + "-" + now.toString();
	}

	sess.setAttribute("logsid", sessId);
	try {
		sess.setAttribute("logref", referer);
	} catch(Exception e) {
		sess.setAttribute("logref", "");
		e.printStackTrace();
	}

	StringBuffer pv = new StringBuffer();

	pv.append("GET /jserver.php?");
	pv.append("logra=");
	pv.append(req.getRemoteAddr());
	pv.append("&logsid=");
	pv.append(sessId);
	pv.append("&logsrid=");
	pv.append(logsrid);
	pv.append("&logua=");
	try{
		pv.append(java.net.URLEncoder.encode(req.getHeader("user-agent")));
	} catch(Exception e) {}
	pv.append("&logha=");
	try {
		pv.append(java.net.URLEncoder.encode(req.getHeader("accept")));
	} catch(Exception e) {}
	pv.append("&logref=");
	try {
		pv.append(referer);
	} catch(Exception e) {}
	pv.append("&logurl=");

	String ptc = "http://";
	if(req.getProtocol().indexOf("HTTPS") > -1) {
		ptc = "https://";
	}
	try {
		pv.append(java.net.URLEncoder.encode(ptc + req.getHeader("host") + req.getRequestURI() + queryString));
	} catch(Exception e) {}
	pv.append("&cdkey=davichmarket&asp=asp36");
	/**********************  cdkey와 asp 변경 *****************/
	pv.append(" HTTP/1.0\r\nHost: 114.108.138.227\r\nConnection: Close\r\n\r\n");

	try {
		java.net.Socket socket = new java.net.Socket("114.108.138.227", 80);
		socket.setSoTimeout(200);
		java.io.BufferedWriter bw = new java.io.BufferedWriter(new java.io.OutputStreamWriter(socket.getOutputStream()));
		bw.write(pv.toString());
		bw.newLine();
		bw.flush();
		socket.close();
	} catch(Exception e) {
	e.printStackTrace();
	}

	Cookie cookie = new Cookie("logsrid", logsrid);
	cookie.setMaxAge(259200000);
	cookie.setDomain(req.getServerName().replace("www.", ""));
	cookie.setPath("/");
	res.addCookie(cookie);
}
%>

<%
String url = request.getAttribute("javax.servlet.forward.request_uri").toString();
if (url.indexOf("/main-view") != -1) {
   // logCorpSendXML(request, response, session);
}
%>
<%-- LOG corp Web Analitics & Live Chat END  --%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><t:insertAttribute name="title" ignore="true" defaultValue="${site_info.siteNm}"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="shortcut icon" href="/resource/image/favicon/favicon.ico" type="image/x-icon" />
	<link rel="icon" href="/resource/image/favicon/favicon.ico" type="image/x-icon" />
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
    <t:putAttribute name="header" value="/WEB-INF/views/site/${_SKIN_PATH}/include/header.jsp" />
    <t:putAttribute name="footer" value="/WEB-INF/views/site/${_SKIN_PATH}/include/footer.jsp" />
    <t:insertAttribute name="skinCommon" />
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
<!-- Google Tag Manager (noscript) 2021.07.21 -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WZP57R7"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<!--- 00.LAYOUT: --->
<div id="wrap">
	<t:insertAttribute name="header" />
	<!--- 02.LAYOUT: MIDDLE AREA --->
	<t:insertAttribute name="content" />
	<!---// 02.LAYOUT: MIDDLE AREA --->
	<!--- 03.LAYOUT: FOOTER AREA --->
	<t:insertAttribute name="footer" />
	<!---// 03.LAYOUT: FOOTER AREA --->
</div>
<!---// 00.LAYOUT: --->
</body>
<t:insertAttribute name="script" ignore="true"/>
</html>