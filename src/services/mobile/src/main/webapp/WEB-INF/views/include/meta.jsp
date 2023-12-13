<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<c:if test="${site_info.cmnUseYn eq 'Y'}">
    <c:set var="title" value="${site_info.cmnTitle}" />
    <c:if test="${site_info.cmnTitle eq null}">
        <c:set var="title" value="${site_info.siteNm}" />
    </c:if>
    <c:set var="author" value="${site_info.cmnManager}" />
    <c:if test="${site_info.cmnManager eq null}">
        <c:set var="author" value="${site_info.companyNm}" />
    </c:if>
    <meta name="title" content="<c:out value="${title}" />" />
    <meta name="author" content="<c:out value="${author}" />" />
    <c:if test="${site_info.cmnDscrt ne null}">
    <meta name="description" content="${site_info.cmnDscrt}" />
    </c:if>
    <c:if test="${site_info.cmnKeyword ne null}">
    <meta name="keywords" content="${site_info.cmnKeyword}" />
    </c:if>
    <meta property="fb:app_id" content="${snsMap.get('fbAppId')}"/>
    <meta property="og:site_name" content="${site_info.siteNm}"/>
    <meta property="og:type" content="website" />

    <c:set var="uri" value="${requestScope['javax.servlet.forward.servlet_path']}" />
    <c:choose>
        <c:when test="${uri.startsWith('/front/event/trevues-event')}">
        <meta property="og:title" content="다비치 샘플링 1" />
        <meta property="og:description" content="다비치 샘플링 1 뜨레뷰편" />
        <meta property="og:url" content="http://www.davichmarket.com/front/event/trevues-event" />
        <meta property="og:image" content="https://www.davichmarket.com/skin/img/event/event_210412_t01.jpg?dt=1.2" />

        </c:when>

        <c:when test="${uri.startsWith('/front/event/teanseon-event')}">
        <meta property="og:title" content="다비치 샘플링 2" />
        <meta property="og:description" content="다비치 샘플링 1 텐션편" />
        <meta property="og:url" content="http://www.davichmarket.com/front/event/teanseon-event" />
        <meta property="og:image" content="https://www.davichmarket.com/skin/img/event/event_210412_ts01.jpg?dt=1.2" />

        </c:when>
        <c:otherwise>
        <meta property="og:title" content="${site_info.siteNm}" />
        <meta property="og:description" content="${site_info.cmnDscrt}" />
        <meta property="og:url" content="https://${site_info.dlgtDomain}" />
        <meta property="og:image" content="https://www.davichmarket.com/skin/img/header/logo.jpg" />
        </c:otherwise>
    </c:choose>


</c:if>