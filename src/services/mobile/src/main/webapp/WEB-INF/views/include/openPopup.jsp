<%@ page contentType="text/html;charset=UTF-8" language="java"  %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.js"></script>


<script>
$(document).ready(function() {
    $('#content').html('${so.content}');
});

function addCookie(){
    var expdate = new Date();
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * '${so.cookieValidPeriod}');
    var name = "cookieName_m_${so.popupNo}";
    var value = "cookieValue_m_${so.popupNo}";
    window.opener.setCookie(name,value,expdate);
    window.close();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${so.popupNm}</title>
</head>
<body>
<div id="content"></div>
<div id="div"></div>
<button name="addCookieClick" id = "addCookieClick" onclick="addCookie()" >${so.cookieValidPeriod}일 동안 안보기</button>
</body>
</html>