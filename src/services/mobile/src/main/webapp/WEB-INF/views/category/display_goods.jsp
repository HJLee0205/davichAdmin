<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<div class="category_middle">
    <div>
        <c:forEach var="category_list" items="${category_list}" varStatus="status">
            <h2 class="main_title">${category_list.dispzoneNm}</h2>
            <c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
            <c:set var="list" value="${requestScope.get(goods_list)}" />
            <data:goodsList value="${list}" displayTypeCd="${category_list.ctgDispDispTypeCd}" headYn="Y"/>
        </c:forEach>
    </div>
</div>