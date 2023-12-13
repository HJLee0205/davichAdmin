<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8"%>
<%-- Jquery --%>
<script src="/admin/js/lib/jquery/jquery-1.12.2.min.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/jquery.cookie.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/jquery.mask.min.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/jquery.form.min.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/jquery.blockUI.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/autoNumeric.js" charset="utf-8"></script>
<script type="text/javascript" src="/admin/js/lib/jquery/jquery-1.2.3.min.js"></script>
<script src="/admin/js/lib/jquery/jquery.easing.min.js" charset="utf-8"></script>
<script>
    window.jQuery1_2_3 = jQuery.noConflict(true);
</script>

<%-- Jquery UI --%>
<script src="/admin/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" media="screen" href="/admin/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.css" />

<%-- Jquery JsTree --%>
<link rel="stylesheet" type="text/css" media="screen" href="/admin/js/lib/jsTree/themes/default/style.css" />
<script src="/admin/js/lib/jsTree/jstree.min.js" charset="utf-8"></script>

<%-- Jquery Validation Engine --%>
<link type="text/css" rel="stylesheet" href="/admin/js/lib/jquery/validation-Engine-2.6.2/css/validationEngine.jquery.css" />
<script src="/admin/js/lib/jquery/validation-Engine-2.6.2/js/jquery.validationEngine.js" charset="utf-8"></script>
<script src="/admin/js/lib/jquery/validation-Engine-2.6.2/js/languages/jquery.validationEngine-ko.js" charset="utf-8"></script>

<link rel="stylesheet" type="text/css" href="/admin/css/include.css">
<link rel="stylesheet" type="text/css" href="/admin/css/custom.css">


<script src="/admin/js/common.js" charset="utf-8"></script>
<script src="/admin/js/custom.js" charset="utf-8"></script>
<script src="/admin/js/popup.js" charset="utf-8"></script>
<script src="/admin/js/file.js" charset="utf-8"></script>
<script src="/admin/js/cookie.js" charset="utf-8"></script>
<%--<script type="text/javascript" src="/admin/js/design.js" charset="utf-8"></script>--%>

<script src="/admin/js/style.js" charset="utf-8"></script>

<!--[if lt IE 9]>
<script src="/admin/js/lib/html5shiv.js"></script>
<script src="/admin/js/lib/html5shiv.printshiv.js"></script>
<![endif]-->
<!--[if (gte IE 6)&(lte IE 8)]>
<script src="/admin/inc/js/selectivizr.js"></script>
<noscript><link rel="stylesheet" href="[fallback css]" /></noscript>
<![endif]-->

<%-- 다음 우편번호 --%>
<%
    if("https".equals(request.getScheme())) {
%>
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<%
    } else {
%>
<script type="text/javascript" src="http://dmaps.daum.net/map_js_init/postcode.v2.js" charset="utf-8"></script>
<%
    }
%>