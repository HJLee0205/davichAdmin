<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<dl id="information">
    <dt>
        <h2 class="information_title">CUSTOMER CENTER</h2>
        <span class="tel">${site_info.custCtTelNo}</span><br>
    </dt>
    <dd>
        <ul class="information_list">
            <li><b>상담시간</b>: ${site_info.custCtOperTime}</li>
            <li><b>점심시간</b> : ${site_info.custCtLunchTime}</li>
            <li>${site_info.custCtClosedInfo}</li>
        </ul>
    </dd>
</dl>