<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="resultModel" items="${left_wing_banner}" varStatus="status">
    <c:if test="${status.index > 0 }">
    <br/>
    </c:if>
    <c:if test="${empty resultModel.linkUrl}">
    <img src="/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}">
    </c:if>
    <c:if test="${!empty resultModel.linkUrl}">
    <a href="javascript:click_banner('${resultModel.dispLinkCd}','${resultModel.linkUrl}');">
    <img src="/image/image-view?type=BANNER&id1=${resultModel.imgFileInfo}"></a>
    </c:if>
</c:forEach>
