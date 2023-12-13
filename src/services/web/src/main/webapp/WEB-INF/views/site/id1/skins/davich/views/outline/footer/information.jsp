<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="bottom_menu">
    <div class="bottom_menu_layout">
        <ul class="bottom_menu_list">
            <li><a href="/front/company-info?siteInfoCd=01">회사소개</a></li>
            <li><a href="/front/company-info?siteInfoCd=04">개인정보처리방침</a></li>
            <li><a href="/front/company-info?siteInfoCd=22">위치정보이용약관</a></li>
            <li><a href="/front/company-info?siteInfoCd=21">청소년보호정책</a></li>
            <li><a href="/front/company-info?siteInfoCd=09">멤버쉽회원약관</a></li>
            <li><a href="/front/company-info?siteInfoCd=10">온라인몰이용약관</a></li>
            <li><a href="/front/seller/seller-detail">입점/제휴문의</a></li>
            <li><a href="/front/customer/customer-main">고객센터</a></li>
			<li><a href="/front/customer/board-list?bbsId=news">뉴스</a></li>
            <%--<c:if test="${site_info.bbsCnt gt 0}">
                <li><a href="/front/community/board-list">커뮤니티</a></li>
            </c:if>--%>
        </ul>
        <select class="family_site">
            <option selected>Family Sites</option>
			<option value="http://www.davich.com/">다비치안경</option>
			<option value="http://davichlens.com/">다비치렌즈</option>
			<option value="http://www.davichhearing.com/">다비치보청기</option>
			<option value="http://www.kvisionoptical.com/">K비젼안경</option>
			<option value="http://www.bibiem.co.kr/">bibiem</option>
        </select>
    </div>
</div>
