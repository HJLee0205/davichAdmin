<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--- footer area --->
<div id="footer_area">
    <div class="footer_layout">
        <%--
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
        --%>
        <ul class="footer_address" style="width:935px;">
            <li>
                <span>${site_info.companyNm}</span>
                <span>대표이사 : ${site_info.ceoNm}</span>
                <span>사업자등록번호 : ${site_info.bizNo} [<a href="javascript:communicationPopup();">확인</a>]</span>
                <span>통신판매업신고번호 : ${site_info.commSaleRegistNo}</span>
            </li>
            <li>
                <span>주소 : ${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl}</span>
                <span>대표전화 : ${site_info.telNo}</span>
                <span>이메일 : ${site_info.email}</span>
            </li>
            <li class="copyright">${site_info.siteNm} © Davich Corp. All Rights Reserved.</li>
        </ul>

        <div id="qrcodeCanvas" style="width: 70px;float: left;"></div>
        <div style="float: left;padding-top: 10px;">
        모바일 앱으로 만나세요!<br>
        ◀ 다비치 앱 설치
        </div>
        <div class="sns_list">
            <a href="javascript:;" onclick='javascript:window.open("https://mark.inicis.com/mark/escrow_popup.php?mid=davichcom1","mark","scrollbars=no,resizable=no,width=565,height=683");'>${PG_SEAL_MARK}</a>
            <a href="https://www.facebook.com/%EB%8B%A4%EB%B9%84%EC%B9%98%EB%A7%88%EC%BC%93-2253282748223706/?modal=admin_todo_tour" target="_blank"><button type="button" class="btn_fbook">페이스북</button></a>
            <a href="https://www.instagram.com/bibiem_official" target="_blank"><button type="button" class="btn_instar">인스타그램</button></a>
            <a href="https://blog.naver.com/eyekeeper13579" target="_blank"><button type="button" class="btn_blog">블로그</button></a>
            <a href="https://pf.kakao.com/_exaxexoM" target="_blank"><button type="button" class="btn_kakao">카카오플러스</button></a>
            <a href="https://www.youtube.com/channel/UCJoAvzt6GNBZLuXYY50F3Yw" target="_blank"><button type="button" class="btn_youtube">유투브</button></a>
            
        </div>

    </div>
    <%--<div class="copyright">
        Copyright (c) All rights reserved. Designed by ${site_info.siteNm}
    </div>--%>
</div>
<!---// footer area --->
<script type="text/javascript" src="/front/js/jquery.qrcode.min.js"></script>
<script>
    //qrcode
    $('#qrcodeCanvas').qrcode({
        width: 59,
        height: 59,
        text: "http://www.davichmarket.com/m/front/appDownload#"
    });

</script>