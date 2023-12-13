<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="resultModel" items="${lately_goods}" varStatus="status">
    <li><a href="javascript:goods_detail('test');"><img src="${_SKIN_IMG_PATH}/quick/quick_view01.gif"></a></li>
</c:forEach>