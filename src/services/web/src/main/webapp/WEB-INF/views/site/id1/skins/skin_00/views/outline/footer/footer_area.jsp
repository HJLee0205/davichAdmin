<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- footer area --->
<div id="footer_area">
    <div class="footer_layout">
        <h1 class="f_logo">
            <c:if test="${empty site_info.logoPath}"><img src="/front/img/common/logo/f_logo.png" width="164" height="108" alt="하단 로고" ></c:if>
            <c:if test="${!empty site_info.logoPath}"><img src="${site_info.bottomLogoPath}" width="164" height="108" alt="하단 로고" ></c:if>
        </h1>
        <ul class="footer_address">
            <li><span>회사명 : ${site_info.companyNm}</span> <span>주소 : ${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl}</span> <span>TEL/FAX : ${site_info.telNo}/${site_info.faxNo}</span> <span>담당자 이메일 : ${site_info.email}</span></li>
            <li><span>대표자 : ${site_info.ceoNm}</span> <span>사업자등록번호 : ${site_info.bizNo}</span> <span>통신사업자번호 :${site_info.commSaleRegistNo}  <a href="javascript:communicationPopup();">사업자정보확인</a></span></li>
            <li><span>개인정보관리책임자 : ${site_info.privacymanager}</span></li>
        </ul>
        <!-- 인증마크 Start -->
        <div class="f_mark">
            <ul>
                <li>${PG_SEAL_MARK}</li>
                <li>${SSL_SEAL_MARK}</li>
            </ul>
        </div>
        <!-- 인증마크 End -->
    </div>
    <div class="copyright">
        Copyright (c) All rights reserved. Designed by ${site_info.siteNm}
    </div>
</div>
<!---// footer area --->

