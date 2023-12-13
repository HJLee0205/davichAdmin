<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 고객센터 왼쪽 메뉴 --->
<div class="customer_side_area">
    <ul class="customer_side">
        <li><a href="javascript:move_page('faq');" <c:if test="${leftMenu eq 'faq'}" >class="selected"</c:if>>자주묻는 질문</a></li>
        <li><a href="javascript:move_page('notice');" <c:if test="${leftMenu eq 'notice'}" >class="selected"</c:if>>공지사항</a></li>
        <li><a href="javascript:move_page('inquiry');" <c:if test="${leftMenu eq 'inquiry'}" >class="selected"</c:if>>1:1 문의</a></li>
    </ul>
    <ul class="customer_side_info">
        <li>
            <c:if test="${(site_info.custCtTelNo ne null) and (site_info.custCtTelNo ne '')}">
                <span class="side_info_tit">CUSTOMER CENTER</span>
                <span class="side_info_tel">${site_info.custCtTelNo}</span>
            </c:if>
            <c:if test="${(site_info.custCtFaxNo ne null) and (site_info.custCtFaxNo ne '')}">
                <span class="side_info_tit">FAX</span>
                <span class="side_info_tel">${site_info.custCtFaxNo}</span>
            </c:if>
            <c:if test="${(site_info.custCtEmail ne null) and (site_info.custCtEmail ne '')}">
                <span class="side_info_tit">EMAIL</span>
                <span class="side_info_tel">${site_info.custCtEmail}</span>
            </c:if>

            <c:if test="${(site_info.custCtOperTime ne null) and (site_info.custCtOperTime ne '')}">
                    상담시간 : ${site_info.custCtOperTime}<br>
            </c:if>
            <c:if test="${(site_info.custCtLunchTime ne null) and (site_info.custCtLunchTime ne '')}">
                    점심시간 : ${site_info.custCtLunchTime}<br>
            </c:if>
            <c:if test="${(site_info.custCtClosedInfo ne null) and (site_info.custCtClosedInfo ne '')}">
                ${site_info.custCtClosedInfo}
            </c:if>
        </li>
        <li>
            <span class="side_info_tit">BANK INFO</span><br>
            예금주 : ${nopb_info[0].holder}<br>
         <c:forEach var="nopb_info" items="${nopb_info}" varStatus="status">
         ${nopb_info.bankNm} : ${nopb_info.actno}<br>
         </c:forEach>
        </li>
    </ul>
</div>
<!---// 고객센터 왼쪽 메뉴 --->