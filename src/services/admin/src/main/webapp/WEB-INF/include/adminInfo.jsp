<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-07-25
  Time: 오전 9:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="admin_info menu_aco" id="div_id_adminInfo">
    <%--<h2 class="admin_tlt">
        <a href="#none">
            <span class="ico_comm"></span>
            <span class="tlt">관리자 정보보기</span>
            <span class="btn_comm"></span>
        </a>
    </h2>--%>
    <div class="aco_con">
        <ul class="info_txt">
            <li>
                <strong class="tlt">버전</strong>
                <span class="txt" id="span_id_adminInfo_version">1.0</span>
            </li>
            <li>
                <strong class="tlt">최초 설치일</strong>
                <span class="txt" id="span_id_adminInfo_regDttm">
                    <fmt:formatDate value="${ADMIN_INFO.regDttm}" pattern="yyyy.MM.dd" />
                </span>
            </li>
            <c:if test="${SITE_INFO.siteTypeCd ne '3'}">
            <li>
                <strong class="tlt">사용기간</strong>
                <span class="txt" id="span_id_adminInfo_svcDt">
                <fmt:formatDate value="${ADMIN_INFO.svcStartDt}" pattern="yyyy.MM.dd" /> - <fmt:formatDate value="${ADMIN_INFO.svcEndDt}" pattern="yyyy.MM.dd" /></span>
            </li>
            <li>
                <strong class="tlt">남은기간</strong>
                <span class="txt" id="span_id_adminInfo_restDate">${ADMIN_INFO.restDate} 일</span>
                <button class="btn_comm btn_set">설정</button>
            </li>
            </c:if>
            <li>
                <strong class="tlt">도메인</strong>
                <span class="txt" id="span_id_adminInfo_domain">${ADMIN_INFO.domain}</span>
                <a href="/admin/setup/siteinfo/site-info#domain"><button class="btn_comm btn_set">설정</button></a>
            </li>
            <li>
                <strong class="tlt">SMS</strong>
                <span class="txt" id="span_id_adminInfo_sms">0 point</span>
                <a href="/admin/operation/sms?pageGb=5"><button class="btn_comm btn_set">설정</button></a>
            </li>
            <li>
                <strong class="tlt">용량</strong>
                <span class="txt" id="span_id_adminInfo_disk">${ADMIN_INFO.useSpace} (${ADMIN_INFO.totalSpace})</span>
                <button class="btn_comm btn_re" id="btn_id_refreshDiskSpace">새로고침</button>
                <button class="btn_comm btn_set">설정</button>
            </li>
        </ul>
        <div class="volume">
            <div class="bar">
                <div class="bg" style="width:${ADMIN_INFO.useSpacePercent}%;" id="div_id_adminInfo_diskPercent1"></div>
            </div>
            <div class="btn_comm move" style="left:${ADMIN_INFO.useSpacePercent}%;" id="div_id_adminInfo_diskPercent2"></div>
            <p class="txt" id="p_id_adminInfo_diskPercent"><strong>${ADMIN_INFO.useSpacePercent}%</strong> ${ADMIN_INFO.useSpace}</p>
        </div>
    </div>
</div>