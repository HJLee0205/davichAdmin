<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="user-scalable=yes, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, width=device-width">
<meta property="fb:app_id" content="${snsMap.get('fbAppId')}"/>
<meta property="og:title" content="${goodsInfo.data.goodsNm}"/>
<meta property="og:image" content="${_DMALL_HTTP_SERVER_URL}${goodsInfo.data.snsImg}"/>
<meta property="og:type" content="website"/>
<meta property="og:site_name" content="${site_info.siteNm}"/>
<meta property="og:url" content="${_DMALL_HTTP_SERVER_URL}/front/goods/goods-detail?goodsNo=${goodsInfo.data.goodsNo}"/>
<meta property="og:description" content="${goodsInfo.data.prWords}"/>
<c:if test="${site_info.goodsUseYn eq 'N'}">
    <c:set var="title" value="${site_info.goodsTitle}" />
    <c:if test="${site_info.goodsTitle eq null}">
        <c:set var="title" value="${site_info.siteNm}" />
    </c:if>
    <c:set var="author" value="${site_info.goodsManager}" />
    <c:if test="${site_info.goodsManager eq null}">
        <c:set var="author" value="${site_info.companyNm}" />
    </c:if>
    <meta name="title" content="<c:out value="${title}" />" />
    <meta name="author" content="<c:out value="${author}" />" />
    <c:if test="${goodsInfo.data.prWords ne null}">
        <meta name="description" content="${goodsInfo.data.prWords}" />
    </c:if>
    <c:if test="${goodsInfo.data.seoSearchWord ne null}">
        <meta name="keywords" content="${goodsInfo.data.seoSearchWord}" />
    </c:if>
</c:if>