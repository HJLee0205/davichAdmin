<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<div class="category_middle">
    <div>
        <c:forEach var="category_list" items="${category_list}" varStatus="status">
            <c:if test="${category_list.ctgExhbtionTypeCd eq '2'}">
            <h2 class="main_title"><img src="/image/image-view?type=CATEGORY&id1=${category_list.ctgDispzoneImgPath}_${category_list.ctgDispzoneImgNm}" /></h2>
            </c:if>
            <c:if test="${category_list.ctgExhbtionTypeCd eq '1'}">
            <h2 class="main_title">${category_list.dispzoneNm}</h2>
            </c:if>
            <c:set var="goods_list" value="category_display_goods_${category_list.ctgDispzoneNo}" />
            <c:set var="list" value="${requestScope.get(goods_list)}" />
            <data:goodsList value="${list}" displayTypeCd="06" headYn="N" iconYn="N"/>
        </c:forEach>
    </div>
</div>