<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="달력" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ attribute name="from" required="true" description="시작 일자 엘리먼트의 이름" %>
<%@ attribute name="fromValue" required="false" description="시작 일자의 값" %>
<%@ attribute name="to" required="true" description="종료 일자의 값" %>
<%@ attribute name="toValue" required="false" description="종료 일자의 값" %>
<%@ attribute name="idPrefix" required="true" description="ID의 접두어" %>
<span class="intxt"><input type="text" name="${from}" value="${fn:substring(fromValue, 0, 8)}" id="${idPrefix}_sc01" class="bell_date_sc" placeholder="YYYY-MM-DD"></span>
<a href="javascript:void(0)" class="date_sc ico_comm" id="${idPrefix}_date01">달력이미지</a>
<span class="select shot">
    <label for="${idPrefix}_from_hour"></label>
    <select name="${from}Hour" id="${idPrefix}_from_hour">
        <c:forEach var="i" begin="0" end="23">
            <c:set var="selected" value=""/>
            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
            <c:if test="${fn:substring(fromValue, 8, 10) eq timePattern}">
                <c:set var="selected" value="selected"/>
            </c:if>
            <option value="${timePattern}" ${selected}>${timePattern}시</option>
        </c:forEach>
    </select>
</span>
<span class="select shot">
    <label for="${idPrefix}_from_minute"></label>
    <select name="${from}Minute" id="${idPrefix}_from_minute">
        <c:forEach var="i" begin="0" end="59">
            <c:set var="selected" value=""/>
            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
            <c:if test="${fn:substring(fromValue, 10, 12) eq timePattern}">
                <c:set var="selected" value="selected"/>
            </c:if>
            <option value="${timePattern}" ${selected}>${timePattern}분</option>
        </c:forEach>
    </select>
</span>
~
<span class="intxt ml10"><input type="text" name="${to}" value="${fn:substring(toValue, 0, 8)}" id="${idPrefix}_sc02" class="bell_date_sc" placeholder="YYYY-MM-DD"></span>
<a href="javascript:void(0)" class="date_sc ico_comm" id="${idPrefix}_date02">달력이미지</a>
<span class="select shot">
    <label for="${idPrefix}_to_hour"></label>
    <select name="${to}Houre" id="${idPrefix}_to_hour">
        <c:forEach var="i" begin="0" end="23">
            <c:set var="selected" value=""/>
            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
            <c:if test="${fn:substring(toValue, 8, 10) eq timePattern}">
                <c:set var="selected" value="selected"/>
            </c:if>
            <option value="${timePattern}" ${selected}>${timePattern}시</option>
        </c:forEach>
    </select>
</span>
<span class="select shot">
    <label for="${idPrefix}_to_minute"></label>
    <select name="${to}Minute" id="${idPrefix}_to_minute">
        <c:forEach var="i" begin="0" end="59">
            <c:set var="selected" value=""/>
            <fmt:formatNumber var="timePattern" value="${i}" pattern="00"/>
            <c:if test="${fn:substring(toValue, 10, 12) eq timePattern}">
                <c:set var="selected" value="selected"/>
            </c:if>
            <option value="${timePattern}" ${selected}>${timePattern}분</option>
        </c:forEach>
    </select>
</span>