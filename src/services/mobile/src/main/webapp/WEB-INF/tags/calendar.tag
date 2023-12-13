<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="달력" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="from" required="true" description="시작 일자 엘리먼트의 이름" %>
<%@ attribute name="fromValue" required="false" description="시작 일자의 값" %>
<%@ attribute name="to" required="true" description="종료 일자의 값" %>
<%@ attribute name="toValue" required="false" description="종료 일자의 값" %>
<%@ attribute name="idPrefix" required="true" description="ID의 접두어" %>
<%@ attribute name="hasTotal" required="false" description="전체 표시 여부" type="java.lang.Boolean" %>
<span class="intxt"><input type="text" name="${from}" value="${fromValue}" id="${idPrefix}_sc01" class="bell_date_sc"></span>
<a href="javascript:void(0)" class="date_sc ico_comm" id="${idPrefix}_date01">달력이미지</a>
~
<span class="intxt"><input type="text" name="${to}" value="${toValue}" id="${idPrefix}_sc02" class="bell_date_sc"></span>
<a href="javascript:void(0)" class="date_sc ico_comm" id="${idPrefix}_date02">달력이미지</a>
<div class="tbl_btn">
    <button class="btn_day"><span></span>오늘</button>
    <button class="btn_day"><span></span>3일간</button>
    <button class="btn_day"><span></span>일주일</button>
    <button class="btn_day"><span></span>1개월</button>
    <button class="btn_day"><span></span>3개월</button>
    <c:if test="${hasTotal ne false}">
    <button class="btn_day"><span></span>전체</button>
    </c:if>
</div>
