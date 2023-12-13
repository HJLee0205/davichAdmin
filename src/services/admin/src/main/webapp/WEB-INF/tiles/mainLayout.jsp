<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><t:insertAttribute name="title" ignore="true" defaultValue="VECI 관리자"/></title>
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
	<t:insertAttribute name="style" ignore="true"/>
	<t:insertAttribute name="jsVar" />
</head>
<body>
<div id="wrapper">
	<!-- header -->
	<t:insertAttribute name="header"></t:insertAttribute>
	<!-- //header -->
	<!-- content -->
	<div id="contents">
		<%--<t:insertAttribute name="content"/>--%>
		<div id="contents_main">
			<t:insertAttribute name="content"/>
		</div>
	</div>
	<!-- //content -->
	<!-- footer -->
	<%--<div id="footer">copyright &copy;  D-Mall. all right reserved.</div>--%>
	<!-- footer -->
</div>

</body>
<t:insertAttribute name="script" ignore="true"/>
</html>