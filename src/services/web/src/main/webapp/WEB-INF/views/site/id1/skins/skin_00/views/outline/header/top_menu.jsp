<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--- top menu --->
<div id="top_menu">
    <ul class="top_menu_list">
        <li>
            <a href="/front/event/event-list">
                <img src="${_SKIN_IMG_PATH}/header/icon_event.png" alt=""><%--<br>
                이벤트--%>
            </a>
        </li>
        <c:if test="${!empty site_info.eventNo}">
        <li>
            <a href="javascript:viewAttendance()">
                <img src="${_SKIN_IMG_PATH}/header/icon_visit.png" alt=""><%--<br>
                출석체크이벤트--%>
            </a>
        </li>
        </c:if>
        <c:if test="${site_info.bbsCnt gt 0}">
        <li>
            <a href="/front/community/board-list">
                <img src="${_SKIN_IMG_PATH}/header/icon_faq.png" alt=""><%--<br>
                커뮤니티--%>
            </a>
        </li>
        </c:if>
        <li>
            <a href="/front/promotion/promotion-list">
                <img src="${_SKIN_IMG_PATH}/header/icon_promo.png" alt=""><%--<br>
                기획전--%>
            </a>
        </li>
    </ul>
</div>
<!---// top menu --->