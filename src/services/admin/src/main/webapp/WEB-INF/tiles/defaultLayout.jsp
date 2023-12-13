<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="_menu" value="${_DMALL_MENU}" />
<c:set var="_site" value="${_DMALL_SITE_INFO}" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<title><t:insertAttribute name="title" ignore="true" defaultValue="D-Mall 관리자"/></title>
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
	
	    <script>
	    
	    	// lnb영역의 background 이미지 짤리는 문제 수정
	    	// 원인 : lnb영익인 content영역보다 길경우 짤림
	    	// lnb영역이 클경우 강제로 content영역의 heigth를 조절
	    	// 예외) 통계영역의 content height를 정상적으로 가져올수 없음 (제외처리)
            jQuery(document).ready(function() {
            	var aheight = $('#aside .lnb').height();
            	var cheight = $('#content').height();
            	var tit = $('title').text();

            	if (tit.indexOf('분석') < 0) {
                	if (aheight > cheight) {
	                	$('#content').css({ height: aheight + 'px' });
    	        	} else {
        	        	$('#content').css({ height: cheight + 'px' });
            		}
            	}
            });
		</script>

</head>
<body>
<!-- wrapper -->
<div id="wrapper">
	<!-- header -->
	<t:insertAttribute name="header"></t:insertAttribute>
	<!-- //header -->

	<!-- contents -->
	<div id="contents">
		<!-- aside -->
		<t:insertAttribute name="aside"></t:insertAttribute>
		<!-- //aside -->
		<!-- content -->
		<div id="contents_body">
			<t:insertAttribute name="content"/>
		</div>
	</div>
	<!-- //section -->
	<!-- footer -->
	<%--<div id="footer">copyright &copy; D-Mall. all right reserved.</div>--%>
	<!-- footer -->
</div>
<!-- //container -->
</body>
<t:insertAttribute name="script" ignore="true"/>
</html>