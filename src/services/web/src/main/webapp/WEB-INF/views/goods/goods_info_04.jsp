<%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<h3 class="product_stit">배송정보</h3>
<div>${term_14.data.content}</div>
<h3 class="product_stit">반품/교환안내</h3>
<div>${term_15.data.content}</div>
<h3 class="product_stit">반품/환불안내</h3>
<div>${term_16.data.content}</div>
<%--
<c:if test="${!empty site_info.retadrssPost}">
    <h3 class="product_stit">반품 주소지</h3>
    <div>${site_info.retadrssPost})&nbsp;${site_info.retadrssAddrNum}${site_info.retadrssAddrRoadnm}${site_info.retadrssAddrDtl}</div>
</c:if>--%>
