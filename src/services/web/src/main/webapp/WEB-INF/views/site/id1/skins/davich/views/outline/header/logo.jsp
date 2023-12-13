<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<h1 id="logo">
    <c:if test="${empty site_info.logoPath}">
        <a href="/front/main-view"><img src="${_SKIN_IMG_PATH}/header/logo.png" alt="다비치마켓"></a>
    </c:if>
    <c:if test="${!empty site_info.logoPath}">
    <a href="/front/main-view"><img src="${_IMAGE_DOMAIN}${site_info.logoPath}" alt="다비치마켓" onerror="this.src='${_SKIN_IMG_PATH}/header/logo.png'"></a>
    </c:if>
</h1>


