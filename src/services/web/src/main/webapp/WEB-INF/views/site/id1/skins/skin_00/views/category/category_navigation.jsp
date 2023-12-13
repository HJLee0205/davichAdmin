<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="category_header">
    <div id="category_location" style="background:none;">
        <a href="javascript:history.back();" class="skin_navi">이전페이지</a><span class="location_bar"></span><a href="/front/main-view">HOME</a>
        <c:forEach var="navigationList" items="${navigation}" varStatus="status">
        <div class="category_selectBox select_box" style="width:120px;">
            <label for="select_option">[[1depth]]</label>
            <select class="select_option" title="select option" id="navigation_combo_${status.index}">
                <c:forEach var="ctgList1" items="${lnb_info.get(navigationList.upCtgNo)}" varStatus="status1">
                    <option value="${ctgList1.ctgNo}" <c:if test="${ctgList1.ctgNo eq navigationList.ctgNo}">selected</c:if>>${ctgList1.ctgNm}</option>
                </c:forEach>
            </select>
        </div>
        </c:forEach>
    </div>
</div>
