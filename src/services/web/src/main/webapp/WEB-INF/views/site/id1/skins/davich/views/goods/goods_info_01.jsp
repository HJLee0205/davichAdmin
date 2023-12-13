<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="bottom_info">
    <span class="tit">상품 정보 제공 고시</span> [전자상거래에 관한 상품정보 제공에 관한 고시] 항목에 의거 [다비치]에 의해 등록된 정보입니다.
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

