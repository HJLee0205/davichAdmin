<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="logo">
    <h1>
        <c:if test="${empty site_info.logoPath}">
            <a href="/front/main-view"><img src="/front/img/common/logo/logo.png" alt="LOGO"></a>
        </c:if>
        <c:if test="${!empty site_info.logoPath}">
        <a href="/front/main-view"><img src="${site_info.logoPath}" alt="LOGO" onerror="this.src='/front/img/common/logo/logo.png'"></a>
        </c:if>
    </h1>
</div>


