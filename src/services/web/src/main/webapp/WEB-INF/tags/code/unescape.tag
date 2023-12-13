<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="데이터 unescape" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="value" required="true" type="java.lang.String" description="escape 문자열" %>
<%
	value = value.replace("&amp;", "&");
	value = value.replace("&lt;", "<");
	value = value.replace("&gt;", ">");
	value = value.replace("&quot;", "\"");
	value = value.replace("&#39;", "'");
	value = value.replace("&#x2f;", "/");
%>
<div><%= value %></div>
