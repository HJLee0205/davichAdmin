<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" %>
<%@ page import="aegis.pgclient.*,java.text.*,java.net.*,java.lang.*" %>
<%@ page import="dmall.framework.common.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
</head>
<body >
<!-- <body onload="javascript:frmAGS_pay_ing.submit();"> -->
<input type="button" value="다음단계진행" onclick="javascript:frmAGS_pay_ing.submit();">
<form name=frmAGS_pay_ing method=post action=approve-result>
<c:forEach var="i" items="${resultModel.extraData}">
    <input type="hidden" name='${i.key}' id='${i.key}' value='${i.value}' />
    ${i.key}=>${i.value}</br>
</c:forEach>
</form>
</body>
</html>
