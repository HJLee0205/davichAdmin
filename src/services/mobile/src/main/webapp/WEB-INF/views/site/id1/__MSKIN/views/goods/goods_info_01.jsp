<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div>
    <div class="review_info">
        * 아래 내용은 상품정보제공 고시에 따라 작성되었습니다.
    </div>
    <table class="tProduct_Con">
        <caption>
            <h1 class="blind">상품정보 고시 표 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:267px">
            <col style="width:">
        </colgroup>
        <tbody>
            <c:forEach var="resultList" items="${goodsNotifyList}" varStatus="status">
            <tr>
                <th>${resultList.itemNm}</th>
                <td>${resultList.itemValue}</td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
