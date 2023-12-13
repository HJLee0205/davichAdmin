<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<dl id="bank_info">
    <dt>
        <h2 class="bank_info_title">무통장 계좌 안내</h2>
        <span>예금주 : ${nopb_info[0].holder}</span>
    </dt>
    <dd>
        <ul class="bank_info_no">
            <c:forEach var="nopb_info" items="${nopb_info}" varStatus="status">
            <li><b>${nopb_info.bankNm}</b> ${nopb_info.actno}</li>
            </c:forEach>
        </ul>
    </dd>
</dl>
